#version 460 compatibility

#include "lib/globalDefines.glsl"

#include "lib/includes2.glsl"
#include "lib/optimizationFunctions.glsl"
#include "program/blindness.glsl"

varying vec2 TexCoords;
varying vec4 Normal;
varying vec3 Tangent;
varying vec4 Color;

uniform usampler3D cSampler1;

varying vec2 LightmapCoords;

varying float isWaterBlock;

uniform sampler2D texture;

uniform sampler2D gDepth;

uniform sampler2D noise;

uniform sampler2D colortex0;
uniform sampler2D depthtex0;
uniform sampler2D depthtex1;

uniform mat4 gbufferProjectionInverse;

uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

uniform int worldTime;
uniform int frameCounter;
uniform float frameTime;

uniform float viewWidth;
uniform float viewHeight;

in float isWater;

#define LIGHT_RADIUS 3

in vec4 lightSourceData;

in float isReflective;

uniform vec3 cameraPosition;

in vec3 worldSpaceVertexPosition;

in vec3 normals_face_world;

in vec3 block_centered_relative_pos;

in vec3 foot_pos;

in vec4 at_midBlock2;

const vec3 TorchColor = vec3(1.0f, 0.25f, 0.08f);
const vec3 GlowstoneColor = vec3(1.0f, 0.85f, 0.5f);
const vec3 LampColor = vec3(1.0f, 0.75f, 0.4f);
const vec3 LanternColor = vec3(0.8f, 1.0f, 1.0f);
const vec3 RedstoneColor = vec3(1.0f, 0.0f, 0.0f);
const vec3 RodColor = vec3(1.0f, 1.0f, 1.0f);
const vec3 PortalColor = vec3(0.75f, 0.0f, 1.0f);

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

//attribute vec4 mc_Entity;

/* DRAWBUFFERS:01235 */

void main() {
    //vec4 albedo = texture2D(texture, TexCoords) * Color;

    //isWater = Normal.w;

    vec4 depth = texture2D(depthtex1, TexCoords);
    vec4 depth2 = texture2D(depthtex0, TexCoords);

    vec3 ClipSpace = vec3(TexCoords, depth) * 2.0f - 1.0f;
    vec4 ViewW = gbufferProjectionInverse * vec4(ClipSpace, 1.0f);
    vec3 View = ViewW.xyz / ViewW.w;
    vec4 World = gbufferModelViewInverse * vec4(View, 1.0f);
    
    vec4 noiseMap = texture2D(noise, TexCoords + (sin(TexCoords.xy*32f + ((frameCounter)/90f)*0.0125f)/2 + 1)*2f);
    vec4 noiseMap2 = texture2D(noise, TexCoords - (sin(TexCoords.xy*16f + ((frameCounter)/90f)*0.0125f)/2 + 1)*2f);

    vec4 albedo = texture2D(texture, TexCoords) * Color;

    vec3 bitangent = normalize2(cross(Tangent.xyz, Normal.xyz));

    mat3 tbnMatrix = mat3(Tangent.xyz, bitangent.xyz, Normal.xyz);

    vec3 newNormal = Normal.xyz;

    newNormal = (gbufferModelViewInverse * vec4(newNormal,1.0)).xyz;

    albedo.a = 0.75f;
    
    vec4 finalNoise = mix2(noiseMap,noiseMap2,0.5f);
    
    vec4 Lightmap;

    if(isWater < 0.1f && isWaterBlock == 1) {
        albedo.xyz = mix2(vec3(0.0f,0.33f,0.55f),vec3(1.0f,1.0f,1.0f),pow2(finalNoise.x,5));
        albedo.a = 0.0f;//mix2(0.5f,1f,pow2(finalNoise.x,5));
        Lightmap = vec4(LightmapCoords.x, LightmapCoords.y, 0.0, 1.0f);
        if(albedo.a < 0.75f) {
            albedo.a = 0.0;
        }
    } else {
        albedo = texture2D(colortex0, TexCoords);
        //albedo.xyz *= gl_Color.xyz;
        Lightmap = vec4(LightmapCoords.x, LightmapCoords.y, 0f, 1.0f);
    }

    //vec4 normalDefine = vec4(noiseMap.xyz * 0.5 + 0.5f, 1.0f);
    //normalDefine = normalDefine + noiseMap;
    float distanceFromCamera = distance(viewSpaceFragPosition,vec3(0));
    
    if(blindness > 0f) {
        albedo.xyz = blindEffect(albedo.xyz);
    }

    gl_FragData[0] = albedo;
    gl_FragData[1] = vec4(newNormal,1.0);
    #ifndef SCENE_AWARE_LIGHTING
        gl_FragData[2] = Lightmap;
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

        if(clamp(voxel_pos,0,VOXEL_AREA) != voxel_pos) {
            lighting = vanillaLight(AdjustLightmap(LightmapCoords));
        }
        gl_FragData[2] = lighting;
    #endif
    gl_FragData[3] = vec4(1.0);
    gl_FragData[4] = vec4(isWaterBlock, 1.0, 1.0, 1.0);
}