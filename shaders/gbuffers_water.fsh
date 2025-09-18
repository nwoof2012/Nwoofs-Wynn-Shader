#version 460 compatibility

#define WATER_WAVES
#define WATER_WAVES_DISTANCE 12 // [4 6 8 10 12 14 16]
#define WATER_CHUNK_RESOLUTION 128 // [32 64 128]

precision mediump float;

varying vec2 TexCoords;
varying vec4 Normal;
varying vec3 Tangent;
varying vec4 Color;

uniform usampler3D cSampler1;
uniform usampler3D cSampler2;
uniform usampler2D cSampler4;

varying vec2 LightmapCoords;

varying float isWaterBlock;

uniform sampler2D texture;

uniform sampler2D gDepth;

uniform sampler2D noise;

uniform sampler2D water;

uniform sampler2D colortex0;
uniform sampler2D depthtex0;
uniform sampler2D depthtex1;

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

in vec3 world_pos;

in vec4 at_midBlock2;

in float waterShadingHeight;

uniform float near;
uniform float far;

#include "lib/globalDefines.glsl"

#include "lib/includes2.glsl"
#include "lib/optimizationFunctions.glsl"

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
const vec3 FireColor = vec3(1.0f, 0.25f, 0.08f);
const float FireBrightness = 5.0;

vec4 decodeLightmap(vec4 lightmap) {
    vec4 lighting = vec4(vec3(0.0),1.0);
    if(lightmap.xyz == vec3(1.0, 0.0, 0.0))
    {
        lighting.xyz = TorchColor;
        lighting.w = TorchBrightness;
    }
    else if(lightmap.xyz == vec3(0.0, 1.0, 0.0))
    {
        lighting.xyz = GlowstoneColor;
        lighting.w = GlowstoneBrightness;
    } else if(lightmap.xyz == vec3(0.0, 0.0, 1.0))
    {
        lighting.xyz = LampColor;
        lighting.w = LampBrightness;
    } else if(lightmap.xyz == vec3(1.0, 1.0, 0.0))
    {
        lighting.xyz = LanternColor;
        lighting.w = LanternBrightness;
    } else if(lightmap.xyz == vec3(0.0, 1.0, 1.0))
    {
        lighting.xyz = RedstoneColor;
        lighting.w = RedstoneBrightness;
    } else if(lightmap.xyz == vec3(1.0, 0.0, 1.0))
    {
        lighting.xyz = RodColor;
        lighting.w = RodBrightness;
    } else if(lightmap.xyz == vec3(1.0, 1.0, 1.0))
    {
        lighting.xyz = PortalColor;
        lighting.w = PortalBrightness;
    } else if(lightmap.xyz == vec3(0.5, 0.0, 0.0))
    {
        lighting.xyz = FireColor;
        lighting.w = FireBrightness;
    } else {
        lighting.w = 0;
    }
    return lighting;
}

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

vec4 normalFromHeight(sampler2D heightTex, vec2 uv, float scale, bool divide) {
    mediump float moveStep = 1.0/viewHeight;
    mediump float height = texture2D(heightTex,uv).r;
    if(divide) height /= 32767;
    vec2 dxy;
    dxy = vec2(height) - vec2(texture2D(heightTex,uv + vec2(moveStep, 0.0)).r,  texture2D(heightTex,uv + vec2(0.0, moveStep)).r);
    return vec4(normalize2(vec3(dxy * scale / moveStep, 1.0)),height);
}

vec4 triplanarTexture(vec3 worldPos, vec3 normal, sampler2D tex, float scale) {
    normal = abs(normal);
    normal = normal / (normal.x + normal.y + normal.z + 0.0001);

    vec2 uvXZ = worldPos.xz * scale;
    vec2 uvXY = worldPos.xy * scale;
    vec2 uvZY = worldPos.zy * scale;

    vec4 texXZ = texture2D(tex,uvXZ) * normal.y;
    vec4 texXY = texture2D(tex,uvXY) * normal.z;
    vec4 texZY = texture2D(tex,uvZY) * normal.x;

    return texXZ + texXY + texZY;
}

vec2 triplanarCoords(vec3 worldPos, vec3 normal, float scale) {
    normal = abs(normal);
    normal = normal / (normal.x + normal.y + normal.z + 0.0001);

    vec2 uvXZ = worldPos.xz * scale;
    vec2 uvXY = worldPos.xy * scale;
    vec2 uvZY = worldPos.zy * scale;

    vec2 texXZ = uvXZ * normal.y;
    vec2 texXY = uvXY * normal.z;
    vec2 texZY = uvZY * normal.x;

    return texXZ + texXY + texZY;
}

//attribute vec4 mc_Entity;

/* RENDERTARGETS:0,1,2,3,5,10,15*/

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

    vec4 noiseMapA = triplanarTexture(fract((world_pos + ((frameCounter)/90f)*0.5f) * 0.035f), Normal.xyz, water, 1.0);
    vec4 noiseMapB = triplanarTexture(fract((world_pos - ((frameCounter)/90f)*0.5f) * 0.035f), Normal.xyz, water, 1.0);

    vec4 finalNoise = noiseMapA * noiseMapB;

    vec3 newNormal = Normal.xyz;

    newNormal = (gbufferModelViewInverse * vec4(newNormal,1.0)).xyz;

    albedo.a = 0.75f;
    
    //vec4 finalNoise = mix2(noiseMap,noiseMap2,0.5f);
    
    vec4 Lightmap;

    if(isWater < 0.1f && isWaterBlock == 1) {
        albedo.xyz = mix2(vec3(0.0f,0.33f,0.55f),vec3(1.0f,1.0f,1.0f),pow2(finalNoise.x,5));
        albedo.a = 0.0f;//mix2(0.5f,1f,pow2(finalNoise.x,5));
        Lightmap = vec4(LightmapCoords.x, LightmapCoords.y, 0.0, 1.0f);
        if(albedo.a < 0.75f) {
            albedo.a = 0.0;
        }

        newNormal = tbnMatrix * finalNoise.xyz;

        newNormal = (gbufferModelViewInverse * vec4(newNormal,1.0)).xyz;

        #ifdef WATER_WAVES
            //newNormal = tbnMatrix * normalFromHeight(cSampler4, TexCoords/WATER_CHUNK_RESOLUTION, 1.0, true).xyz * 0.5 + 0.5;
            //newNormal = (gbufferModelViewInverse * vec4(newNormal,1.0)).xyz;
        #endif
    } else {
        albedo = texture2D(colortex0, TexCoords);
        //albedo.xyz *= gl_Color.xyz;
        Lightmap = vec4(LightmapCoords.x, LightmapCoords.y, 0f, 1.0f);
    }

    //vec4 normalDefine = vec4(noiseMap.xyz * 0.5 + 0.5f, 1.0f);
    //normalDefine = normalDefine + noiseMap;
    mediump float distanceFromCamera = distance(viewSpaceFragPosition,vec3(0));
    
    /*if(blindness > 0f) {
        albedo.xyz = blindEffect(albedo.xyz);
    }*/

    gl_FragData[0] = albedo;
    gl_FragData[1] = vec4(newNormal * 0.5 + 0.5,1.0);
    #if SCENE_AWARE_LIGHTING == 0
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
            vec3 block_centered_relative_pos3 = foot_pos +at_midBlock2.xyz/64.0 + vec3(-LIGHT_RADIUS - 1) + fract(cameraPosition);
            vec4 bytes2 = unpackUnorm4x8(texture3D(cSampler1,vec3(ivec3(block_centered_relative_pos3+VOXEL_RADIUS))/vec3(VOXEL_AREA)).r);
            // Calculate the total number of iterations (light radius cubed)
            int totalLightRadius = 8 * LIGHT_RADIUS * LIGHT_RADIUS * LIGHT_RADIUS; // 2 * LIGHT_RADIUS ^ 3

            vec3 sphereCoords = vec3(gl_FragCoord.xy, gl_FragCoord.z) - vec3(LIGHT_RADIUS);
            
            mediump float voxel_open = 1.0;

            for (int idx = 0; idx < totalLightRadius; idx++) {
                // Explicitly cast the index to (x, y, z) coordinates
                int x = (idx / (2 * LIGHT_RADIUS * 2 * LIGHT_RADIUS)) - LIGHT_RADIUS; // Integer division for x
                int y = ((idx / (2 * LIGHT_RADIUS)) % (2 * LIGHT_RADIUS)) - LIGHT_RADIUS; // Integer division for y
                int z = (idx % (2 * LIGHT_RADIUS)) - LIGHT_RADIUS; // Integer division for z

                // Compute the block-relative position
                vec3 block_centered_relative_pos2 = foot_pos + at_midBlock2.xyz / 64.0 + vec3(x, z, y) + fract(cameraPosition);
                ivec3 voxel_pos2 = ivec3(block_centered_relative_pos2 + VOXEL_RADIUS);

                if (x * x + y * y + z * z > LIGHT_RADIUS * LIGHT_RADIUS) continue;

                // Skip if out of light radius
                if (distance(vec3(0.0), block_centered_relative_pos2) > VOXEL_RADIUS) continue;

                // Sample textures for light and block data
                vec4 bytes = unpackUnorm4x8(texture3D(cSampler1, vec3(voxel_pos2) / vec3(VOXEL_AREA)).r);
                vec4 blockBytes = unpackUnorm4x8(texture3D(cSampler2, vec3(voxel_pos2) / vec3(VOXEL_AREA)).r);

                // Check light-block interactions
                if (bytes.xyz != vec3(0.0)) {
                    mediump float distA = distance(voxel_pos2, vec3(0.0));
                    mediump float distB = distance(voxel_pos, vec3(0.0));
                    if (blockBytes.x == 1.0 && bytes2.xyz == vec3(0.0)) {
                        voxel_open *= step(distA, distB);
                    }

                    // Compute lighting contribution
                    lighting = mix2(vec4(0.0), decodeLightmap(bytes),
                                clamp(1.0 - distance(block_centered_relative_pos, block_centered_relative_pos2) / float(LIGHT_RADIUS), 0.0, 1.0));
                    
                    lighting = mix2(vec4(0.0), lighting, voxel_open);
                    //lighting.xyz *= lightColor;
                }

                // Update secondary light data
                bytes2 = unpackUnorm4x8(texture3D(cSampler1, vec3(voxel_pos2) / vec3(VOXEL_AREA)).r);
            }
        }

        if(clamp(voxel_pos,0,VOXEL_AREA) != voxel_pos) {
            lighting = vanillaLight(AdjustLightmap(LightmapCoords));
        }
        gl_FragData[2] = lighting;
    #endif
    gl_FragData[3] = vec4(1.0,0.0,0.0,1.0);
    gl_FragData[4] = vec4(isWaterBlock, 0.0, 0.0, isWaterBlock);
    gl_FragData[6] = vec4(distanceFromCamera, depth.r, waterShadingHeight, 1.0);
}