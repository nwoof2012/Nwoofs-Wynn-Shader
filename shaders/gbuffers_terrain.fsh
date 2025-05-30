#version 460 compatibility

#include "lib/includes2.glsl"
#include "lib/optimizationFunctions.glsl"
#include "program/blindness.glsl"
#include "lib/globalDefines.glsl"
#include "program/gaussianBlur.glsl"

#define PATH_TRACING_GI 0 // [0 1]

#define FRAGMENT_SHADER

#define WAVING_FOLIAGE
#define FOLIAGE_SPEED 1.0f // [0.1f 0.2f 0.3f 0.4f 0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f 1.6f 1.7f 1.8f 1.9f 2.0f]
#define FOLIAGE_INTENSITY 1.0f // [0.1f 0.2f 0.3f 0.4f 0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f 1.6f 1.7f 1.8f 1.9f 2.0f]
#define FOLIAGE_WAVE_DISTANCE 4 // [2 4 8 16 32]

#define GAMMA 2.2 // [1.0 1.2 1.4 1.6 1.8 2.0 2.2 2.4 2.6 2.8 3.0]

#define MIN_LIGHT 0.05f // [0.0f 0.05f 0.1f 0.15f 0.2f 0.25f 0.3f 0.35f 0.4f 0.45f 0.5f]

#define SE_MIN_LIGHT 0.05f // [0.0f 0.05f 0.1f 0.15f 0.2f 0.25f 0.3f 0.35f 0.4f 0.45f 0.5f]

#define MAX_LIGHT 1.5f // [1.0f 1.1f 1.2f 1.3f 1.4f 1.5f 1.6f 1.7f 1.8f 1.9f 2.0f 2.1f 2.2f 2.3f 2.4f 2.5f 2.6f 2.7f 2.8f 2.9f 3.0f 3.1f 3.2f 3.3f 3.4f 3.5f 3.6f 3.7f 3.8f 3.9f 4.0f 4.1f]

#define SE_MAX_LIGHT 2.0f // [1.0f 1.1f 1.2f 1.3f 1.4f 1.5f 1.6f 1.7f 1.8f 1.9f 2.0f 2.1f 2.2f 2.3f 2.4f 2.5f 2.6f 2.7f 2.8f 2.9f 3.0f 3.1f 3.2f 3.3f 3.4f 3.5f 3.6f 3.7f 3.8f 3.9f 4.0f 4.1f]

precision mediump float;

layout (rgba16f) uniform image2D cimage7;

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
uniform usampler3D cSampler2;
uniform usampler3D cSampler5;

uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferProjection;
uniform mat4 gbufferModelView;

uniform ivec2 atlasSize;
uniform vec3 sunPosition;

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

in float isFoliage;

uniform bool isBiomeEnd;

uniform float frameTimeCounter;

uniform int viewWidth;
uniform int viewHeight;

const vec3 TorchColor = vec3(1.0f, 0.25f, 0.08f);
const float TorchBrightness = 1.0;
const vec3 GlowstoneColor = vec3(1.0f, 0.85f, 0.5f);
const float GlowstoneBrightness = 1.0;
const vec3 LampColor = vec3(1.0f, 0.75f, 0.4f);
const float LampBrightness = 1.0;
const vec3 LanternColor = vec3(0.8f, 1.0f, 1.0f);
const float LanternBrightness = 1.0;
const vec3 RedstoneColor = vec3(1.0f, 0.0f, 0.0f);
const float RedstoneBrightness = 1.0;
const vec3 RodColor = vec3(1.0f, 1.0f, 1.0f);
const float RodBrightness = 1.0;
const vec3 PortalColor = vec3(0.75f, 0.0f, 1.0f);
const float PortalBrightness = 1.0;
const vec3 FireColor = vec3(1.0f, 0.5f, 0.08f);
const float FireBrightness = 1.0;

//#include "program/generateNormals.glsl"

#if PATH_TRACING_GI == 1
    #include "program/pathTracing.glsl"
#endif

mediump float AdjustLightmapTorch(in float torch) {
    const mediump float K = 2.0f;
    const mediump float P = 5.06f;
    return K * pow2(torch, P);
}

mediump float AdjustLightmapSky(in float sky){
    mediump float sky_2 = sky * sky;
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
    mediump float magA = length(a.xyz);
    mediump float magB = length(b.xyz);
    if(magA < magB) {
        return b;
    }
    return a;
}

/*vec3 smoothUVs3D(in vec3 v) {
    return v*v*(3.0-2.0*v);
}*/

vec4 decodeLightmap(uint lightmap) {
    vec4 lighting = vec4(vec3(0.0),1.0);
    if(lightmap == 1)
    {
        lighting.xyz = TorchColor;
        lighting.w = TorchBrightness;
    }
    else if(lightmap == 2)
    {
        lighting.xyz = GlowstoneColor;
        lighting.w = GlowstoneBrightness;
    } else if(lightmap == 3)
    {
        lighting.xyz = LampColor;
        lighting.w = LampBrightness;
    } else if(lightmap == 4)
    {
        lighting.xyz = LanternColor;
        lighting.w = LanternBrightness;
    } else if(lightmap == 5)
    {
        lighting.xyz = RedstoneColor;
        lighting.w = RedstoneBrightness;
    } else if(lightmap == 6)
    {
        lighting.xyz = RodColor;
        lighting.w = RodBrightness;
    } else if(lightmap == 7)
    {
        lighting.xyz = PortalColor;
        lighting.w = PortalBrightness;
    } else if(lightmap == 8)
    {
        lighting.xyz = FireColor;
        lighting.w = FireBrightness;
    } else {
        lighting.w = 0;
    }
    return lighting;
}

/*vec4 smooth_light(vec3 p) {
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
}*/

bool pointsIntersect(vec3 origin, vec3 dir, vec3 solidTex) {
    vec3 oc = origin - solidTex;
    mediump float b = dot(oc, dir);
    mediump float c = dot(oc, oc);
    mediump float h = b * b - c;
    if(h > 0.0) {
        return true;
    }
    return false;
}

/* RENDERTARGETS:0,1,2,3,5,10,15*/

void main() {
    vec3 lightColor = texture(lightmap, LightmapCoords).rgb;
    vec4 albedo = texture2D(gtexture, TexCoords) * Color;
    albedo.xyz = pow2(albedo.xyz, vec3(GAMMA));

    mediump float depth = texture2D(depthtex0, TexCoords).r;
    mediump float depth2 = texture2D(depthtex1, TexCoords).r;
    
    if(albedo.a >= .1 && depth >= 0.1) {
        //vec3 bitangent = normalize2(cross(Tangent.xyz, Normal.xyz));
        //mat3 tbnMatrix = mat3(Tangent.xyz, bitangent.xyz, Normal.xyz);
        vec3 newNormal = Normal;
        newNormal = (gbufferModelViewInverse * vec4(newNormal, 1.0)).xyz;
        //vec3 newNormal2 = tbnMatrix * normalFromDepth(TexCoords, gtexture, vec2(32.0), 1.0).xyz;
        //newNormal2 = (gbufferModelViewInverse * vec4(newNormal2, 1.0)).xyz;

        //GenerateNormals(newNormal, albedo.xyz, gtexture, tbnMatrix);

        //vec3 newNormal3 = (newNormal + newNormal2) / 2.0;
        albedo.xyz = pow2(albedo.xyz, vec3(1/GAMMA));
        mediump float distanceFromCamera = distance(vec3(0), viewSpaceFragPosition);

        if(blindness > 0.0) {
            albedo.xyz = blindEffect(albedo.xyz);
        }

        gl_FragData[0] = albedo;
        gl_FragData[1] = vec4(newNormal * 0.5 + 0.5f, 1.0f);
        #ifndef SCENE_AWARE_LIGHTING
            gl_FragData[2] = vec4(LightmapCoords, 0.0f, 1.0f);
        #else
            //vec3 coords = vec3(0.0);
            // Lighting and voxel-related calculations (optimizations applied)
            #define VOXEL_AREA 128 //[32 64 128]
            #define VOXEL_RADIUS (VOXEL_AREA/2)
            ivec3 voxel_pos = ivec3(block_centered_relative_pos+VOXEL_RADIUS);
            vec3 light_color = vec3(0.0);// = texture3D(cSampler1, vec3(foot_pos+2.0*normals_face_world+fract(cameraPosition) + VOXEL_RADIUS)).rgb;
            if(clamp(voxel_pos,0,VOXEL_AREA) == voxel_pos) {
                vec4 bytes = unpackUnorm4x8(texture3D(cSampler1,vec3(voxel_pos)/vec3(VOXEL_AREA)).r);
                light_color = bytes.xyz;
            }
            
            vec4 lighting = vec4(0.0); //decodeLightmap(vec4(light_color, 1.0));
            float lightBrightness = 0.0;

            if(lighting.w <= 0.0) {
                lowp vec3 block_centered_relative_pos3 = foot_pos +at_midBlock2.xyz/64.0 + vec3(-LIGHT_RADIUS - 1) + fract(cameraPosition);
                //lowp vec4 bytes2 = unpackUnorm4x8(texture3D(cSampler1,vec3(ivec3(block_centered_relative_pos3+VOXEL_RADIUS))/vec3(VOXEL_AREA)).r);
                // Calculate the total number of iterations (light radius cubed)
                //int totalLightRadius = int(pow2(2 * LIGHT_RADIUS,3)); // 2 * LIGHT_RADIUS ^ 3

                int side = 2 * LIGHT_RADIUS;
                int totalLightRadius = int(pow2(side, 3));

                lowp vec3 sphereCoords = vec3(gl_FragCoord.xy, gl_FragCoord.z) - vec3(LIGHT_RADIUS);
                
                lowp float voxel_open = 1.0;

                for (int idx = 0; idx < totalLightRadius + 1; idx++) {
                    // Explicitly cast the index to (x, y, z) coordinates
                    //int x = (idx / (2 * LIGHT_RADIUS * 2 * LIGHT_RADIUS)) - LIGHT_RADIUS; // Integer division for x
                    //int y = ((idx / (2 * LIGHT_RADIUS)) % (2 * LIGHT_RADIUS)) - LIGHT_RADIUS; // Integer division for y
                    //int z = (idx % (2 * LIGHT_RADIUS)) - LIGHT_RADIUS; // Integer division for z

                    int x = int(idx / (side * side) - LIGHT_RADIUS);
                    int y = int(mod(idx/side, side) - LIGHT_RADIUS);
                    int z = int(mod(idx, side) - LIGHT_RADIUS);

                    if(x * x + y * y + z * z > LIGHT_RADIUS * LIGHT_RADIUS) continue;

                    //coords = vec3(x, y, z);

                    // Compute the block-relative position
                    lowp vec3 block_centered_relative_pos2 = foot_pos + at_midBlock2.xyz / 64.0 + vec3(x, z, y) + fract(cameraPosition);
                    
                    // Skip if out of light radius
                    if (distance(vec3(0.0), block_centered_relative_pos2) > VOXEL_RADIUS) continue;

                    ivec3 voxel_pos2 = ivec3(block_centered_relative_pos2 + VOXEL_RADIUS);

                    //if (x * x + y * y + z * z > LIGHT_RADIUS * LIGHT_RADIUS) continue;

                    // Sample textures for light and block data
                    uint bytes = texture3D(cSampler1, vec3(voxel_pos2) / vec3(VOXEL_AREA)).r;
                    //uint blockBytes = texture3D(cSampler2, vec3(voxel_pos2) / vec3(VOXEL_AREA)).r;

                    if(bytes == 0u) continue;

                    // Check light-block interactions
                    if (bytes != 0) {
                        //mediump float distA = distance(voxel_pos2, cameraPosition);
                        //mediump float distB = distance(voxel_pos, cameraPosition);
                        /*if (blockBytes.x == 1.0 && bytes2.xyz == vec3(0.0) && voxel_open > 0.0) {
                            voxel_open *= step(distB, distA);
                        }*/

                        lowp vec3 foot_pos3 = vec3(0.0); //foot_pos;
                        lowp vec3 block_centered_relative_pos4 = block_centered_relative_pos2 - foot_pos;

                        block_centered_relative_pos4 = mat3(gbufferModelView) * block_centered_relative_pos4;
                        //foot_pos3 = mat3(gbufferProjection) * mat3(gbufferModelView) * foot_pos3;

                        // Compute lighting contribution
                        lighting = mix2((lighting + vec4(lightColor * 0.25f,0.0)) * 0.75f, decodeLightmap(bytes),
                                    clamp(1.0 - blockDist(foot_pos3, block_centered_relative_pos4) / float(LIGHT_RADIUS), 0.0, 1.0)) * normalize2(vanillaLight(AdjustLightmap(LightmapCoords))) * 2.5f;

                        lightBrightness = decodeLightmap(bytes).w * clamp(1.0 - blockDist(foot_pos3, block_centered_relative_pos4) / float(LIGHT_RADIUS), 0.0, 1.0);
                        
                        //lighting = mix2(vec4(0.0), lighting, vanillaLight(AdjustLightmap(LightmapCoords)));
                        //lighting.xyz *= lightColor;
                    }

                    // Update secondary light data
                    //bytes2 = unpackUnorm4x8(texture3D(cSampler1, vec3(voxel_pos2) / vec3(VOXEL_AREA)).r);
                }
            }
            vec4 finalLighting = lighting;
            #if PATH_TRACING_GI == 1
                vec3 lightDir = normalize2(sunPosition);
                vec3 cameraRight = normalize2(cross(lightDir, vec3(0.0, 1.0, 0.0)));
                vec3 cameraUp = cross(cameraRight, lightDir);
                vec3 rayDir = normalize2(lightDir + TexCoords.x * cameraRight + TexCoords.y * cameraUp);
                Ray ray = Ray(viewSpaceFragPosition, rayDir);
                vec3 rayColor = traceRay(ray,vec2(length(lighting),1f), Normal,albedo.a)/vec3(2);
                finalLighting *= vec4(vec3(length(rayColor)),1.0);
                finalLighting *= 0.0035f;
            #endif
            /*if(clamp(voxel_pos,0,VOXEL_AREA) != voxel_pos || length(finalLighting) <= 0.0) {
                finalLighting = pow2(vanillaLight(AdjustLightmap(LightmapCoords)) * 0.25f,vec4(0.5f));
            }*/
            vec4 finalLighting2 = vanillaLight(AdjustLightmap(LightmapCoords));
            if(isBiomeEnd) finalLighting2 = max(finalLighting2, vec4(MIN_LIGHT * 0.1)); else finalLighting2 = max(finalLighting2, vec4(SE_MIN_LIGHT * 0.1));
            finalLighting = mix2(finalLighting, finalLighting2, max(float(any(notEqual(clamp(voxel_pos,0,VOXEL_AREA), voxel_pos))), float(1 - smoothstep(0,1,finalLighting))));
            uint integerValue = packUnorm4x8(vec4(lighting.xyz, lightBrightness));
            //finalLighting = mix2(finalLighting, vec4(vec3(0.0),1.0), float(any(equal(vec3(depth2), vec3(0.0)))));
            //imageStore(cimage7, ivec2(gl_FragCoord.xy/2), vec4(finalLighting.xyz, lightBrightness));
            gl_FragData[2] = finalLighting;
        #endif
        gl_FragData[3] = vec4(distanceFromCamera);
        gl_FragData[4] = vec4(0.0, 1.0, isReflective, 1.0);
        gl_FragData[5] = vec4(worldSpaceVertexPosition, 1.0);
        gl_FragData[6] = vec4(distanceFromCamera, distanceFromCamera/20f, isFoliage * (1 - albedo.a), 1.0);
    }
}
