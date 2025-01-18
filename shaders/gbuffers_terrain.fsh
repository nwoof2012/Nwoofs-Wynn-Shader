#version 460 compatibility

#include "lib/includes2.glsl"
#include "lib/optimizationFunctions.glsl"
#include "program/blindness.glsl"

#include "lib/globalDefines.glsl"

#define PATH_TRACING_GI 0 // [0 1]

varying vec2 TexCoords;
varying vec3 Normal;
varying vec3 Tangent;
varying vec4 Color;

varying vec2 LightmapCoords;

uniform sampler2D gtexture;
uniform sampler2D lightmap;

uniform sampler2D depthtex0;
uniform sampler2D depthtex1;

uniform usampler3D cSampler1;

uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjectionInverse;

uniform ivec2 atlasSize;

//flat in vec4 mc_Entity;

in vec4 lightSourceData;

in float isReflective;

uniform vec3 cameraPosition;

in vec3 worldSpaceVertexPosition;

in vec3 normals_face_world;

in vec3 block_centered_relative_pos;

in vec3 foot_pos;

in vec4 at_midBlock2;

in vec2 signMidCoordPos;
flat in vec2 absMidCoordPos;
flat in vec2 midCoord;

uniform bool isBiomeEnd;

const vec3 TorchColor = vec3(1.0f, 0.25f, 0.08f);
const vec3 GlowstoneColor = vec3(1.0f, 0.85f, 0.5f);
const vec3 LampColor = vec3(1.0f, 0.75f, 0.4f);
const vec3 LanternColor = vec3(0.8f, 1.0f, 1.0f);
const vec3 RedstoneColor = vec3(1.0f, 0.0f, 0.0f);
const vec3 RodColor = vec3(1.0f, 1.0f, 1.0f);
const vec3 PortalColor = vec3(0.75f, 0.0f, 1.0f);

#include "program/generateNormals.glsl"

#define LIGHT_RADIUS 3

float AdjustLightmapTorch(in float torch) {
    const float K = 2.0f;
    const float P = 5.06f;
    return K * pow2(torch, P);
}

float AdjustLightmapSky(in float sky){
    float sky_2 = sky * sky;
    return sky_2 * sky_2;
}

vec2 AdjustLightmap(in vec2 Lightmap){
    vec2 NewLightMap;
    NewLightMap.x = AdjustLightmapTorch(Lightmap.x);
    NewLightMap.y = AdjustLightmapSky(Lightmap.y);
    return NewLightMap;
}

vec4 vanillaLight(in vec2 Lightmap) {
    const vec3 TorchColor = vec3(1.0f, 1.0f, 1.0f);
    vec4 lightColor = vec4(TorchColor * Lightmap.x,1.0);
    return lightColor;
}

vec4 maxVec(vec4 a, vec4 b) {
    float magA = length(a.xyz);
    float magB = length(b.xyz);
    if(magA < magB) {
        return b;
    }
    return a;
}

vec3 smoothUVs3D(in vec3 v) {
    return v*v*(3.0-2.0*v);
}

vec4 decodeLightmap(vec4 lightmap) {
    vec4 lighting = vec4(vec3(0.0),1.0);
    if(lightmap.xyz == vec3(1.0, 0.0, 0.0))
    {
        lighting.xyz = TorchColor;
    }
    else if(lightmap.xyz == vec3(0.0, 1.0, 0.0))
    {
        lighting.xyz = GlowstoneColor;
    } else if(lightmap.xyz == vec3(0.0, 0.0, 1.0))
    {
        lighting.xyz = LampColor;
    } else if(lightmap.xyz == vec3(1.0, 1.0, 0.0))
    {
        lighting.xyz = LanternColor;
    } else if(lightmap.xyz == vec3(0.0, 1.0, 1.0))
    {
        lighting.xyz = RedstoneColor;
    } else if(lightmap.xyz == vec3(1.0, 0.0, 1.0))
    {
        lighting.xyz = RodColor;
    } else if(lightmap.xyz == vec3(1.0, 1.0, 1.0))
    {
        lighting.xyz = PortalColor;
    } else {
        lighting.w = 0;
    }
    return lighting;
}

vec4 smooth_light(vec3 p) {
    vec3 f = smoothUVs3D(p);
    vec4 bytes = unpackUnorm4x8(texture3D(cSampler1,floor(p)).r);
    vec4 a = decodeLightmap(bytes);
    bytes = unpackUnorm4x8(texture3D(cSampler1,vec3(ceil(p.x), floor(p.y), floor(p.z))).r);
    vec4 b = decodeLightmap(bytes);
    bytes = unpackUnorm4x8(texture3D(cSampler1,vec3(floor(p.x), ceil(p.y), floor(p.z))).r);
    vec4 c = decodeLightmap(bytes);
    bytes = unpackUnorm4x8(texture3D(cSampler1,vec3(ceil(p.xy), floor(p.z))).r);
    vec4 d = decodeLightmap(bytes);

    vec4 bottom = mix2(mix2(a,b,f.x),mix2(c,d,f.x),f.y);

    bytes = unpackUnorm4x8(texture3D(cSampler1,vec3(floor(p.x),floor(p.y),ceil(p.z))).r);
    vec4 a2 = decodeLightmap(bytes);
    bytes = unpackUnorm4x8(texture3D(cSampler1,vec3(ceil(p.x), floor(p.y), ceil(p.z))).r);
    vec4 b2 = decodeLightmap(bytes);
    bytes = unpackUnorm4x8(texture3D(cSampler1,vec3(floor(p.x), ceil(p.y), ceil(p.z))).r);
    vec4 c2 = decodeLightmap(bytes);
    bytes = unpackUnorm4x8(texture3D(cSampler1,ceil(p)).r);
    vec4 d2 = decodeLightmap(bytes);

    vec4 top = mix2(mix2(a2,b2,f.x),mix2(c2,d2,f.x),f.y);

    return mix2(bottom, top, f.z);
}

/* RENDERTARGETS:0,1,2,3,5,10,15*/

void main() {
    vec3 lightColor = texture(lightmap, LightmapCoords).rgb;
    vec4 albedo = texture2D(gtexture, TexCoords) * Color;
    albedo.xyz = pow2(albedo.xyz, vec3(2.2));

    float depth = texture2D(depthtex0, TexCoords).r;
    //albedo.rgb *= lightColor;
    
    if(albedo.a < .1 || depth < 0.1) {
        discard;
    }

    vec3 bitangent = normalize2(cross(Tangent.xyz, Normal.xyz));

    mat3 tbnMatrix = mat3(Tangent.xyz, bitangent.xyz, Normal.xyz);

    vec3 newNormal = Normal;

    newNormal = (gbufferModelViewInverse * vec4(newNormal, 1.0)).xyz;

    vec3 newNormal2 = tbnMatrix * normalFromDepth(TexCoords,gtexture,vec2(32.0),1.0).xyz;

    newNormal2 = (gbufferModelViewInverse * vec4(newNormal2, 1.0)).xyz;

    /*if(mc_Entity.x < 10005 || mc_Entity.x > 10010) {
        lightColor = vec3(0);
    }*/

    GenerateNormals(newNormal, albedo.xyz, gtexture, tbnMatrix);

    vec3 newNormal3 = (newNormal + newNormal2)/2;

    albedo.xyz = pow2(albedo.xyz, vec3(1/2.2));

    float distanceFromCamera = distance(vec3(0), viewSpaceFragPosition);

    if(blindness > 0f) {
        albedo.xyz = blindEffect(albedo.xyz);
    }

    gl_FragData[0] = albedo;
    gl_FragData[1] = vec4(newNormal * 0.5 + 0.5f, 1.0f);
    #ifndef SCENE_AWARE_LIGHTING
        gl_FragData[2] = vec4(LightmapCoords, 0f, 1.0f);
    #else
        #define VOXEL_AREA 128 //[32 64 128]
        #define VOXEL_RADIUS (VOXEL_AREA/2)
        ivec3 voxel_pos = ivec3(block_centered_relative_pos+VOXEL_RADIUS);
        vec3 light_color = vec3(0.0);// = texture3D(cSampler1, vec3(foot_pos+2.0*normals_face_world+fract(cameraPosition) + VOXEL_RADIUS)).rgb;
        if(clamp(voxel_pos,0,VOXEL_AREA) == voxel_pos) {
            vec4 bytes = unpackUnorm4x8(texture3D(cSampler1,vec3(voxel_pos)/vec3(VOXEL_AREA)).r);
            light_color = bytes.xyz;
        }
        
        vec4 lighting = decodeLightmap(vec4(light_color, 1.0));

        if(lighting.w <= 0.0) {
            for(int x = -LIGHT_RADIUS; x < LIGHT_RADIUS; x++) {
                for(int y = -LIGHT_RADIUS; y < LIGHT_RADIUS; y++) {
                    for(int z = -LIGHT_RADIUS; z < LIGHT_RADIUS; z++) {
                        vec3 block_centered_relative_pos2 = foot_pos +at_midBlock2.xyz/64.0 + vec3(x, z, y) + fract(cameraPosition);
                        ivec3 voxel_pos2 = ivec3(block_centered_relative_pos2+VOXEL_RADIUS);
                        if(distance(vec3(0.0), block_centered_relative_pos2) > VOXEL_RADIUS) break;
                        vec4 bytes = unpackUnorm4x8(texture3D(cSampler1,vec3(voxel_pos2)/vec3(VOXEL_AREA)).r);
                        if(bytes.xyz != vec3(0.0)) {
                            lighting = mix(vec4(0.0),decodeLightmap(vec4(bytes.xyz, 1.0)),clamp(1 - distance(block_centered_relative_pos, block_centered_relative_pos2)/LIGHT_RADIUS,0,1));
                        }
                    }
                }
            }
        }
        /*lightColor = vec3(0);
        if(lightSourceData.x > 0.5) {
            lightColor = TorchColor;
        }
        else if(lightSourceData.y > 0.5) {
            lightColor = GlowstoneColor;
        }
        else if(lightSourceData.z > 0.5) {
            lightColor = LampColor;
        }
        else if(lightSourceData.x > 0.0) {
            lightColor = LanternColor;
        }
        else if(lightSourceData.y > 0.0) {
            lightColor = RedstoneColor;
        }
        else if(lightSourceData.z > 0.0) {
            lightColor = RodColor;
        }
        vec4 vanilla = vanillaLight(AdjustLightmap(LightmapCoords));*/
        //vec4 lighting;
        /*if(isBiomeEnd) {
            #if PATH_TRACING_GI == 1
                lighting = mix2( pow2(vanilla * 0.25f,vec4(0.5f)),vec4(lightColor * lightSourceData.w * 50f,1.0),clamp(length(max(lightColor - vanilla.xyz,vec3(0.0))),0,1));
            #else
                lighting = mix2( pow2(vanilla * 0.25f,vec4(0.5f)),vec4(lightColor * lightSourceData.w * 50f,1.0),clamp(length(max(vec3(1.0) - vanilla.xyz,vec3(0.0))),0,1));
            #endif
        } else {
            #if PATH_TRACING_GI == 1
                lighting = mix2( pow2(vanilla * 0.25f,vec4(0.5f)),vec4(lightColor * lightSourceData.w,1.0),clamp(length(max(lightColor,vec3(0.0))),0,1));
            #else
                lighting = mix2( pow2(vanilla * 0.25f,vec4(0.5f)),vec4(lightColor * lightSourceData.w * 50f,1.0),clamp(length(max(vec3(1.0) - vanilla.xyz,vec3(0.0))),0,1));
            #endif
        }*/
        /*if(lighting.x == LightmapCoords.x) {
            lighting.x *= 2.0;
        }*/
        //gl_FragData[0] = vec4(lighting.xyz,1.0);
        if(clamp(voxel_pos,0,VOXEL_AREA) != voxel_pos || length(lighting) <= 0.0) {
            lighting = pow2(vanillaLight(AdjustLightmap(LightmapCoords)) * 0.25f,vec4(0.5f));
        }
        gl_FragData[2] = lighting;
    #endif
    //gl_FragData[3] = vec4(LightmapCoords, 0.0f, 1.0f);
    gl_FragData[3] = vec4(distanceFromCamera);
    gl_FragData[4] = vec4(0.0,1.0,isReflective,1.0);
    gl_FragData[5] = vec4(worldSpaceVertexPosition, 1.0);
    gl_FragData[6] = vec4(distanceFromCamera, vec2(0.0), 1.0);
}