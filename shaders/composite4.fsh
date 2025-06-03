#version 460 compatibility
#define SHADOW_SAMPLES 2
#define PI 3.14159265358979323846f
#define DAY_R 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
#define DAY_G 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
#define DAY_B 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
#define DAY_I 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]

#define NIGHT_R 0.9f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
#define NIGHT_G 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
#define NIGHT_B 1.1f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
#define NIGHT_I 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]

#define SUNSET_R 1.1f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
#define SUNSET_G 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
#define SUNSET_B 0.8f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
#define SUNSET_I 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]

#define SE_R 0.7f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
#define SE_G 0.4f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
#define SE_B 0.8f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
#define SE_I 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]

#define SHADOW_RES 4096 // [128 256 512 1024 2048 4096 8192]
#define SHADOW_DIST 16 // [4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32]


#define NATURAL_LIGHT_DAY_R 1.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define NATURAL_LIGHT_DAY_G 0.7 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define NATURAL_LIGHT_DAY_B 0.2 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define NATURAL_LIGHT_DAY_I 1.0 // [0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5]

#define NATURAL_LIGHT_NIGHT_R 0.2 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define NATURAL_LIGHT_NIGHT_G 0.7 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define NATURAL_LIGHT_NIGHT_B 1.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define NATURAL_LIGHT_NIGHT_I 0.1 // [0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5]


#define BLOOM

#define VIBRANT_MODE 1 //[0 1]

#define BLOOM_QUALITY 48 // [4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64]
#define BLOOM_INTENSITY 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
#define BLOOM_THRESHOLD 0.7f // [0.0f 0.1f 0.2f 0.3f 0.4f 0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f 1.6f 1.7f 1.8f 1.9f 2.0f]

#define MIN_LIGHT 0.05f // [0.0f 0.05f 0.1f 0.15f 0.2f 0.25f 0.3f 0.35f 0.4f 0.45f 0.5f]

#define SE_MIN_LIGHT 0.05f // [0.0f 0.05f 0.1f 0.15f 0.2f 0.25f 0.3f 0.35f 0.4f 0.45f 0.5f]

#define MAX_LIGHT 1.5f // [1.0f 1.1f 1.2f 1.3f 1.4f 1.5f 1.6f 1.7f 1.8f 1.9f 2.0f 2.1f 2.2f 2.3f 2.4f 2.5f 2.6f 2.7f 2.8f 2.9f 3.0f 3.1f 3.2f 3.3f 3.4f 3.5f 3.6f 3.7f 3.8f 3.9f 4.0f 4.1f]

#define SE_MAX_LIGHT 2.0f // [1.0f 1.1f 1.2f 1.3f 1.4f 1.5f 1.6f 1.7f 1.8f 1.9f 2.0f 2.1f 2.2f 2.3f 2.4f 2.5f 2.6f 2.7f 2.8f 2.9f 3.0f 3.1f 3.2f 3.3f 3.4f 3.5f 3.6f 3.7f 3.8f 3.9f 4.0f 4.1f]

#define LIGHTMAP_QUALITY 16 // [4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80 84 88 92 96 100 104 108 112 116 120 124 128]

#define WATER_REFRACTION
#define WATER_FOAM

#define FRAGMENT_SHADER

#define PATH_TRACING_GI 0 // [0 1]

#define AO_WIDTH 0.1 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

#define GAMMA 2.2 // [1.0 1.2 1.4 1.6 1.8 2.0 2.2 2.4 2.6 2.8 3.0]

#define MIN_SE_SATURATION 0.5 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

#include "lib/globalDefines.glsl"

varying vec2 TexCoords;

uniform vec3 sunPosition;

uniform vec3 playerLookVector;

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D colortex3;
uniform sampler2D colortex4;
uniform sampler2D colortex5;
uniform sampler2D colortex6;
uniform sampler2D colortex7;
uniform sampler2D colortex13;
uniform sampler2D colortex14;

uniform sampler2D depthtex0;
uniform sampler2D depthtex1;

uniform sampler2D shadowtex0;

uniform sampler2D shadowtex1;
uniform sampler2D shadowcolor0;

uniform mat4 shadowProjectionInverse;
uniform mat4 shadowModelViewInverse;

uniform sampler3D cSampler1;
uniform sampler3D cSampler8;
layout (rgba8) uniform image2D cimage7;

uniform sampler2D noisetex;

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferProjection;

uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferModelView;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

mat4 gbufferProjectionModelView = gbufferProjection * gbufferModelView;

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;

uniform int worldTime;
uniform int frameCounter;
uniform float frameTime;
uniform float frameTimeCounter;

uniform int entityId;
uniform int blockId;
uniform int heldItemId;

uniform float viewWidth;
uniform float viewHeight;

uniform vec3 cameraPosition;

uniform float blindness;

uniform sampler2D colortex8;
uniform sampler2D colortex9;

uniform sampler2D colortex10;
uniform sampler2D colortex11;

uniform sampler2D colortex12;

uniform sampler2D colortex15;

uniform float aspectRatio;

const float sunPathRotation = -40.0f;

const float Ambient = 0.1f;

const int shadowMapResolution = SHADOW_RES;

const ivec3 voxelVolumeSize = ivec3(1,0.5, 1);
float effectiveACLdistance = min(1, SHADOW_DIST * 2.0);

uniform float maxBlindnessDarkness;

uniform float near;
uniform float far;

const int ShadowSamplesPerSize = 2 * SHADOW_SAMPLES + 1;
const int TotalSamples = ShadowSamplesPerSize * ShadowSamplesPerSize;
varying vec2 LightmapCoords;

uniform bool isBiomeEnd;

in vec3 vaPosition;

in vec3 viewSpaceFragPosition;

in vec3 vNormal;
in vec3 vViewDir;

in vec2 FoV;

in vec3 Tangent;

#include "lib/optimizationFunctions.glsl"
#include "distort.glsl"
#include "lib/commonFunctions.glsl"
#include "lib/spaceConversion.glsl"
#include "program/underwater.glsl"
#include "program/gaussianBlur.glsl"
#include "lib/colorFunctions.glsl"
//#include "lib/includes.glsl"

//vec3 dayColor = vec3(1.0f,1.0f,1.0f);
vec3 dayColor = vec3(DAY_R,DAY_G,DAY_B);
//vec3 nightColor = vec3(0.9f,1.0f,1.1f);
vec3 nightColor = vec3(NIGHT_R,NIGHT_G,NIGHT_B);
//vec3 transitionColor = vec3(1.1f, 1.0f, 0.8f);
vec3 transitionColor = vec3(SUNSET_R,SUNSET_G,SUNSET_B);

vec3 seColor = vec3(SE_R,SE_G,SE_B);

vec3 currentColor;

vec3 Diffuse;

vec3 baseColor;
vec3 baseDiffuse;

vec3 baseDiffuseModifier;

vec3 baseFog;

vec3 fogAlbedo;

in vec3 lightmap;

uniform vec3 shadowLightPosition;

uniform float screenBrightness;

in vec3 foot_pos;
in vec3 world_pos;

#include "lib/buffers.glsl"
#include "program/ambientOcclusion.glsl"

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

vec3 screenToWorld(vec2 screenPos, float depth) {
    vec2 ndc = screenPos * 2.0 - 1.0;

    vec4 clipSpace = vec4(ndc, depth, 1.0);
    vec4 viewSpace = gbufferProjectionInverse * clipSpace;
    viewSpace /= viewSpace.w;

    vec4 worldSpace = gbufferModelViewInverse * viewSpace;
    worldSpace /= worldSpace.w;
    worldSpace.xyz += cameraPosition * 2.0;

    return worldSpace.xyz;
}

vec3 screenToFoot(vec2 screenPos, float depth) {
    vec2 ndc = screenPos * 2.0 - 1.0;

    vec4 clipSpace = vec4(ndc, depth, 1.0);
    vec4 viewSpace = gbufferProjectionInverse * clipSpace;
    viewSpace /= viewSpace.w;

    vec4 worldSpace = gbufferModelViewInverse * viewSpace;
    worldSpace /= worldSpace.w;
    //worldSpace.xyz += cameraPosition * 2.0;

    return worldSpace.xyz;
}

vec3 translucentMult;

vec3 blurLightmap(mediump float waterTest, vec2 specularCoord, vec3 Normal, vec4 Albedo, vec2 UVs) {
    vec3 worldUVs = screenToWorld(UVs, texture2D(depthtex1, UVs).r);
    /*if(texture2D(colortex2, UVs).a <= 0.0) {
        return texture2D(colortex2, UVs).rgb;
    }*/
    mediump float radius = 1f;
    vec3 sum = vec3(0.0);
    mediump float blur = radius/viewHeight;
    mediump float hstep = 1f;
    vec3 lightColor = texture2D(colortex2, worldUVs.xy).rgb;
    sum += lightColor;

    /*if(texture2D(colortex2, TexCoords).r < 0.85 || texture2D(colortex2, TexCoords).g < 0.85) {
        GetLightmapColor(texture2D(colortex2, TexCoords).rg);
    }*/

    /*if(abs(sum.r - sum.g) > 0.25) {
        return GetLightmapColor(texture2D(colortex2, TexCoords).rg);
    }*/

    const vec3 TorchColor = vec3(1.0f, 0.25f, 0.08f);

    mediump float depthTolerance = 0.0125;

    //mediump float camDistance = distance(vec3(0.0),viewSpaceFragPosition);

    for(int i = 0; i < LIGHTMAP_QUALITY/2; i++) {
        mediump float sampleDepth = mix2(0.0162162162,0.985135135,float(i)/(LIGHTMAP_QUALITY/2));
        vec2 shiftedUVs = vec2(UVs.x - (float(i)/LIGHTMAP_QUALITY) * radius * 4f * blur * hstep, UVs.y - (float(i)/LIGHTMAP_QUALITY) * radius * 4f * blur * hstep).rg;
        vec2 specularUVs = vec2(specularCoord.x - (float(i)/LIGHTMAP_QUALITY) * radius * 4f * blur * hstep, specularCoord.y - (float(i)/LIGHTMAP_QUALITY) * radius * 4f * blur * hstep).rg;
        //vec3 specularMap = (texture2D(colortex10, specularUVs).rgb + texture2D(colortex11, specularUVs).rgb);
        //specularMap = pow2(specularMap, vec3(100.0));
        vec3 light = texture2D(colortex2, shiftedUVs).rgb;
        vec2 UVsOffset = vec2((float(i)/LIGHTMAP_QUALITY) * radius * 4f * blur * hstep, (float(i)/LIGHTMAP_QUALITY) * radius * 4f * blur * hstep).rg;
        light += texture2D(colortex2, vec2(worldUVs.x - UVsOffset.x, worldUVs.y + UVsOffset.y)).rgb;
        /*mediump float normalA = texture2D(depthtex0,shiftedUVs).r;
        mediump float normalB = texture2D(depthtex0,shiftedUVs + UVsOffset).r;
        mediump float isEntity = texture2D(colortex15,shiftedUVs).r;
        mediump float isEntity2 = texture2D(colortex15,shiftedUVs + UVsOffset).r;
        mediump float camDistance = texture2D(colortex15, shiftedUVs).g;
        
        /*if(abs(normalA - normalB) >= depthTolerance/camDistance) {
            continue;
        }*/
        /*if(waterTest > 0f) {
            sum += (specularMap + light) * sampleDepth;
            continue;
        }*/
        vec3 lightColor2 = light;
        /*if(dot((sum + lightColor) * vec3(1.5025),vec3(0.333f)) < BLOOM_THRESHOLD) {
            continue;
        }*/
        if(texture2D(colortex2, shiftedUVs).r > 0.0f) {
            sum = mix2(sum,lightColor2, 0.5);
        }
        lightColor2 = light * sampleDepth;
        /*if(dot((sum + lightColor) * vec3(1.5025),vec3(0.333f)) < BLOOM_THRESHOLD) {
            continue;
        }*/
        sum = mix2(sum,lightColor2, 0.5);
    }

    for(int i = 0; i < LIGHTMAP_QUALITY/2; i++) {
        mediump float sampleDepth = mix2(0.0162162162,0.985135135,float(i)/(LIGHTMAP_QUALITY/2));
        vec2 shiftedUVs = vec2(UVs.x + (float(i)/LIGHTMAP_QUALITY) * radius * 4f * blur * hstep, UVs.y + (float(i)/LIGHTMAP_QUALITY) * radius * 4f * blur * hstep).rg;
        vec2 specularUVs = vec2(specularCoord.x - (float(i)/LIGHTMAP_QUALITY) * radius * 4f * blur * hstep, specularCoord.y - (float(i)/LIGHTMAP_QUALITY) * radius * 4f * blur * hstep).rg;
        //vec3 specularMap = (texture2D(colortex10, specularUVs).rgb + texture2D(colortex11, specularUVs).rgb);
        //specularMap = pow2(specularMap, vec3(100.0));
        vec3 light = texture2D(colortex2, shiftedUVs).rgb;
        vec2 UVsOffset = -vec2((float(i)/LIGHTMAP_QUALITY) * radius * 4f * blur * hstep, (float(i)/LIGHTMAP_QUALITY) * radius * 4f * blur * hstep).rg;
        light += texture2D(colortex2, vec2(worldUVs.x - UVsOffset.x, worldUVs.y + UVsOffset.y)).rgb;
        /*mediump float normalA = texture2D(depthtex0,shiftedUVs).r;
        mediump float normalB = texture2D(depthtex0,shiftedUVs + UVsOffset).r;
        mediump float isEntity = texture2D(colortex15,shiftedUVs).r;
        mediump float isEntity2 = texture2D(colortex15,shiftedUVs + UVsOffset).r;
        mediump float camDistance = texture2D(colortex15, shiftedUVs).g;

        /*if(abs(normalA - normalB) >= depthTolerance/camDistance) {
            continue;
        }*/
        /*if(waterTest > 0f) {
            sum += (specularMap + light) * sampleDepth;
            continue;
        }*/
        vec3 lightColor2 = light;
        
        /*if(dot((sum + lightColor) * vec3(1.5025),vec3(0.333f)) < BLOOM_THRESHOLD) {
            continue;
        }*/
        if(texture2D(colortex2, shiftedUVs).r > 0.0f) {
            sum = mix2(sum,lightColor2, 0.5);
        }
        lightColor2 = light * sampleDepth;
        /*if(dot((sum + lightColor) * vec3(1.5025),vec3(0.333f)) < BLOOM_THRESHOLD) {
            continue;
        }*/
        sum = mix2(sum,lightColor2, 0.5);
    }

    /*sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x - 8.0 * blur * hstep, TexCoords.y - 8.0 * blur * hstep)).rg) * 0.0162162162;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x - 7.0 * blur * hstep, TexCoords.y - 7.0 * blur * hstep)).rg) * 0.0540540541;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x - 6.0 * blur * hstep, TexCoords.y - 6.0 * blur * hstep)).rg) * 0.1216216216;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x - 5.0 * blur * hstep, TexCoords.y - 5.0 * blur * hstep)).rg) * 0.1945945946;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x - 4.0 * blur * hstep, TexCoords.y - 4.0 * blur * hstep)).rg) * 0.389189189;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x - 3.0 * blur * hstep, TexCoords.y - 3.0 * blur * hstep)).rg) * 0.583783784;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x - 2.0 * blur * hstep, TexCoords.y - 2.0 * blur * hstep)).rg) * 0.875675676;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x - 1.0 * blur * hstep, TexCoords.y - 1.0 * blur * hstep)).rg) * 0.985135135;

    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x + 8.0 * blur * hstep, TexCoords.y + 8.0 * blur * hstep)).rg) * 0.0162162162;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x + 7.0 * blur * hstep, TexCoords.y + 7.0 * blur * hstep)).rg) * 0.0540540541;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x + 6.0 * blur * hstep, TexCoords.y + 6.0 * blur * hstep)).rg) * 0.1216216216;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x + 5.0 * blur * hstep, TexCoords.y + 5.0 * blur * hstep)).rg) * 0.1945945946;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x + 4.0 * blur * hstep, TexCoords.y + 1.0 * blur * hstep)).rg) * 0.389189189;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x + 3.0 * blur * hstep, TexCoords.y + 2.0 * blur * hstep)).rg) * 0.583783784;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x + 2.0 * blur * hstep, TexCoords.y + 3.0 * blur * hstep)).rg) * 0.875675676;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x + 1.0 * blur * hstep, TexCoords.y + 4.0 * blur * hstep)).rg) * 0.985135135;*/

    /*if(dot(sum, vec3(0.333)) > 2) {
        sum *= mix2(vec3(2),vec3(0.5),clamp(dot(sum, vec3(0.333)),0,1.2));
    }*/
    

    mediump float bloomLerp = 1.0f;
    #if BLOOM_INTENSITY + 0.5 > 0.0
        bloomLerp = clamp01(length((sum * vec3(0.0625))/(BLOOM_THRESHOLD - 0.25)));
    #endif

    //sum *= BLOOM_INTENSITY + 0.5;

    return pow2(sum,vec3(GAMMA));
}


vec3 GetLightmapColor(in vec2 Lightmap){
    Lightmap = AdjustLightmap(Lightmap);
    Lightmap.x = min(Lightmap.x, 0.25);
    const vec3 TorchColor = vec3(1.0f, 0.25f, 0.08f);
    const vec3 GlowstoneColor = vec3(1.0f, 0.85f, 0.5f);
    const vec3 LampColor = vec3(1.0f, 0.75f, 0.4f);
    const vec3 LanternColor = vec3(0.8f, 1.0f, 1.0f);
    const vec3 RedstoneColor = vec3(1.0f, 0.0f, 0.0f);
    const vec3 RodColor = vec3(1.0f, 1.0f, 1.0f);
    vec3 SkyColor = vec3(0.05f, 0.15f, 0.3f);
    SkyColor = currentColor;
    if(worldTime%24000 > 12000) {
        Lightmap.y *= NIGHT_I * 0.05f;
    }
    vec3 TorchLighting = Lightmap.x * TorchColor;
    vec3 GlowstoneLighting = Lightmap.x * GlowstoneColor;
    vec3 LampLighting = Lightmap.x * LampColor;
    vec3 LanternLighting = Lightmap.x * LanternColor;
    vec3 RedstoneLighting = Lightmap.x * RedstoneColor;
    vec3 RodLighting = Lightmap.x * RodColor;
    vec3 SkyLighting = Lightmap.y * SkyColor;
    if(lightmap.x > 0) {
        TorchLighting = TorchColor * lightmap.x;
    }
    if(lightmap.x < 0) {
        GlowstoneLighting = GlowstoneColor * -lightmap.x;
    }
    if(lightmap.y > 0) {
        LampLighting = LampColor * lightmap.y;
    }
    if(lightmap.y < 0) {
        LanternLighting = LanternColor * -lightmap.y;
    }
    if(lightmap.z > 0) {
        RedstoneLighting = RedstoneColor * lightmap.z;
    }
    if(lightmap.z < 0) {
        RodLighting = RodColor * -lightmap.z;
    }
    vec3 LightmapLighting = TorchLighting + GlowstoneLighting + LampLighting + LanternLighting + RedstoneLighting + RodLighting + SkyLighting;
    return LightmapLighting;
}

#include "program/pathTracing.glsl"

mediump float Visibility(in sampler2D ShadowMap, in vec3 SampleCoords) {
    return step(SampleCoords.z - 0.001f, texture2D(ShadowMap, SampleCoords.xy).r);
}

mat3 tbnNormalTangent(vec3 normal, vec3 tangent) {
    vec3 bitangent = cross(tangent, normal);
    return mat3(tangent, bitangent, normal);
}

vec3 TransparentShadow(in vec3 SampleCoords){
    mediump float ShadowVisibility0 = Visibility(shadowtex0, SampleCoords);
    mediump float ShadowVisibility1 = Visibility(shadowtex1, SampleCoords);
    vec4 ShadowColor0 = texture2D(shadowcolor0, SampleCoords.xy);
    vec3 TransmittedColor = ShadowColor0.rgb * (1.0f - ShadowColor0.a);
    return mix2(TransmittedColor * ShadowVisibility1, vec3(1.0f), ShadowVisibility0);
}

vec3 GetShadow(float depth) {
    vec3 ClipSpace = vec3(TexCoords, depth) * 2.0f - 1.0f;
    vec4 ViewW = gbufferProjectionInverse * vec4(ClipSpace, 1.0f);
    vec3 View = ViewW.xyz / ViewW.w;
    vec4 World = gbufferModelViewInverse * vec4(View, 1.0f);
    vec4 ShadowSpace = shadowProjection * shadowModelView * World;
    ShadowSpace.xy = DistortPosition(ShadowSpace.xy);
    vec3 worldSpaceSunPos = (gbufferProjection * vec4(sunPosition,1.0)).xyz;
    vec3 lightDir = normalize2(worldSpaceSunPos);
    vec3 normal = texture2D(colortex1, TexCoords).rgb;
    normal = tbnNormalTangent(normal, Tangent) * normal;
    vec3 normalClip = normal * 2.0f - 1.0f;
    vec4 normalViewW = gbufferProjectionInverse * vec4(normalClip, 1.0);
    vec3 normalView = normalViewW.xyz/normalViewW.w;
    vec4 normalWorld = gbufferModelViewInverse * vec4(normalView, 1.0f);
    vec3 fragPos = texture2D(colortex10, TexCoords).rgb;
    #if RAY_TRACED_SHADOWS == 1
        return computeShadows(lightDir, vec3(0.0), normal, World.xyz);
    #else
        vec3 SampleCoords = ShadowSpace.xyz * 0.5f + 0.5f;
        vec3 ShadowAccum = vec3(0.0f);
        for(int x = -SHADOW_SAMPLES; x <= SHADOW_SAMPLES; x++){
            for(int y = -SHADOW_SAMPLES; y <= SHADOW_SAMPLES; y++){
                vec2 Offset = vec2(x, y) / SHADOW_RES;
                vec3 CurrentSampleCoordinate = vec3(SampleCoords.xy + Offset, SampleCoords.z);
                ShadowAccum += TransparentShadow(CurrentSampleCoordinate);
            }
        }
        ShadowAccum /= TotalSamples;
        return ShadowAccum;
    #endif
}

#include "program/volumetricLight.glsl"

vec3 SceneToVoxel(vec3 scenePos) {
	return scenePos + fract(cameraPosition) + (0.5 * vec3(voxelVolumeSize));
}

vec3 aces(vec3 x) {
  mediump float a = 2.51;
  mediump float b = 0.03;
  mediump float c = 2.43;
  mediump float d = 0.59;
  mediump float e = 0.14;
  return clamp((x * (a * x + b)) / (x * (c * x + d) + e), 0.0, 1.0);
}

vec3 lottes(vec3 x) {
  vec3 a = vec3(1.6);
  vec3 d = vec3(0.977);
  vec3 hdrMax = vec3(8.0);
  vec3 midIn = vec3(0.18);
  vec3 midOut = vec3(0.267);

  vec3 b =
      (-pow2(midIn, a) + pow2(hdrMax, a) * midOut) /
      ((pow2(hdrMax, a * d) - pow2(midIn, a * d)) * midOut);
  vec3 c =
      (pow2(hdrMax, a * d) * pow2(midIn, a) - pow2(hdrMax, a) * pow2(midIn, a * d) * midOut) /
      ((pow2(hdrMax, a * d) - pow2(midIn, a * d)) * midOut);

  return pow2(x, a) / (pow2(x, a * d) * b + c);
}

vec3 unreal(vec3 x) {
  return x / (x + 0.155) * 1.019;
}

mediump float ambientOcclusion(vec3 normal, vec3 pos, float camDist) {
    mediump float ao = 0.0;
    vec3 samplePos = pos + vec3(AO_WIDTH * 0.1/(camDist));
    if(texture2D(colortex15,pos.xy).g - texture2D(colortex15,samplePos.xy).g > 0.01f) return 1.0;
    vec3 sampleNormal = texture2D(colortex1, samplePos.xy).xyz;
    ao += max(0.0, dot(sampleNormal, normal));
    return ao;
}

vec4 bloom(float waterTest, vec2 specularCoord, vec3 Normal, vec4 Albedo) {
    mediump float radius = 2f;
    vec3 sum = vec3(0.0);
    mediump float blur = radius/viewHeight;
    mediump float hstep = 1f;
    vec2 uv = gl_FragCoord.xy / vec2(viewWidth, viewHeight);
    vec3 lightColor = texture2D(colortex2,uv).rgb;
    float illumination = texture2D(colortex2,uv).a;
    #ifdef VOLUMETRIC_LIGHTING
        lightColor += volumetricLight(sunPosition, depthtex1, TexCoords, VL_SAMPLES, VL_DECAY, VL_EXPOSURE, VL_WEIGHT, VL_DENSITY, vec3(VL_COLOR_R, VL_COLOR_G, VL_COLOR_B));
    #endif

    #ifdef SCENE_AWARE_LIGHTING
        //sum = blurLightmap(waterTest, specularCoord, Normal, Albedo, uv);
        sum += lightColor;
    #elif PATH_TRACING_GI == 1
        vec3 lightDir = normalize2(sunPosition);
        vec3 cameraRight = normalize2(cross(lightDir, vec3(0.0, 1.0, 0.0)));
        vec3 cameraUp = cross(cameraRight, lightDir);
        vec3 rayDir = normalize2(lightDir + uv.x * cameraRight + uv.y * cameraUp);
        Ray ray = Ray(viewSpaceFragPosition, rayDir);
        vec3 rayColor = traceRay(ray,vec2(length(lightmap),1f), Normal,Albedo.a)/vec3(2);

        sum += rayColor;
    #else
        sum += lightColor;
    #endif

    vec3 lightColor3 = texture2D(colortex2, uv).rgb;

    float depth = texture2D(depthtex0, uv).r;
    float depth2 = texture2D(depthtex1, uv).r;

    /*if(depth2 < 0.1f) {
        return vec4(vec3(0.0), 1.0);
    }*/

    //sum += mix2(vec3(0.0), lightColor3, float(depth >= 1.0));

    /*if(texture2D(colortex2, TexCoords).r < 0.85 || texture2D(colortex2, TexCoords).g < 0.85) {
        GetLightmapColor(texture2D(colortex2, TexCoords).rg);
    }*/

    /*if(abs(sum.r - sum.g) > 0.25) {
        return GetLightmapColor(texture2D(colortex2, TexCoords).rg);
    }*/

    const vec3 TorchColor = vec3(1.0f, 0.25f, 0.08f);

    mediump float depthTolerance = 0.0125;

    //mediump float camDistance = distance(vec3(0.0),viewSpaceFragPosition);

    //lightColor += gaussianBlur(colortex2, uv, radius, vec2(viewWidth, viewHeight)).xyz;

    for(int i = 0; i < BLOOM_QUALITY/2; i++) {
        mediump float sampleDepth = mix2(0.0162162162,0.985135135,float(i)/(BLOOM_QUALITY/2));
        vec2 shiftedUVs = vec2(TexCoords.x - (float(i)/BLOOM_QUALITY) * radius * 4f * blur * hstep, TexCoords.y - (float(i)/BLOOM_QUALITY) * radius * 4f * blur * hstep).rg;
        vec2 specularUVs = vec2(specularCoord.x - (float(i)/BLOOM_QUALITY) * radius * 4f * blur * hstep, specularCoord.y - (float(i)/BLOOM_QUALITY) * radius * 4f * blur * hstep).rg;
        //vec3 specularMap = (texture2D(colortex10, specularUVs).rgb + texture2D(colortex11, specularUVs).rgb);
        //specularMap = pow2(specularMap, vec3(100.0));
        vec3 light = GetLightmapColor(texture2D(colortex2, shiftedUVs).rg * vec2(0.6f, 1.0f));
        lightColor3 = texture2D(colortex2,shiftedUVs).rgb;
        illumination += texture2D(colortex2,shiftedUVs).a;
        vec2 UVsOffset = vec2((float(i)/BLOOM_QUALITY) * radius * 4f * blur * hstep, (float(i)/BLOOM_QUALITY) * radius * 4f * blur * hstep).rg;
        /*#ifdef VOLUMETRIC_LIGHTING
            light += volumetricLight(sunPosition, depthtex1, shiftedUVs, VL_SAMPLES, VL_DECAY, VL_EXPOSURE, VL_WEIGHT, VL_DENSITY, vec3(VL_COLOR_R, VL_COLOR_G, VL_COLOR_B));
        #endif*/
        /*mediump float normalA = texture2D(depthtex0,shiftedUVs).r;
        mediump float normalB = texture2D(depthtex0,shiftedUVs + UVsOffset).r;
        mediump float isEntity = texture2D(colortex15,shiftedUVs).r;
        mediump float isEntity2 = texture2D(colortex15,shiftedUVs + UVsOffset).r;
        mediump float camDistance = texture2D(colortex15, shiftedUVs).g;*/
        
        /*if(abs(normalA - normalB) >= depthTolerance/camDistance) {
            continue;
        }*/
        /*if(waterTest > 0f) {
            sum += (specularMap + light) * sampleDepth;
            continue;
        }*/
        #ifdef SCENE_AWARE_LIGHTING
            light = lightColor * illumination;
            sum += lightColor * sampleDepth;
        #elif PATH_TRACING_GI == 1
            cameraRight = normalize2(cross(lightDir, vec3(0.0, 1.0, 0.0)));
            cameraUp = cross(cameraRight, lightDir);
            rayDir = normalize2(lightDir + shiftedUVs.x * cameraRight + shiftedUVs.y * cameraUp);
            Ray ray = Ray(viewSpaceFragPosition + vec3(shiftedUVs, 0.0), rayDir);
            vec3 rayColor2 = traceRay(ray,vec2(length(lightmap),1f), Normal,Albedo.a)/vec3(2) * sampleDepth;
            
            /*if(dot((sum + rayColor) * vec3(10.5025),vec3(0.333f)) < BLOOM_THRESHOLD) {
                continue;
            }*/

            sum += rayColor2;
            if(texture2D(colortex2, shiftedUVs).r > 0.0f) {
                sum += vec3(0.6f) * (texture2D(colortex2, shiftedUVs).r);
            }
        #else
            vec3 lightColor2 = vec3(0.6f) * (texture2D(colortex2, shiftedUVs).r);
            /*if(dot((sum + lightColor) * vec3(1.5025),vec3(0.333f)) < BLOOM_THRESHOLD) {
                continue;
            }*/
            if(texture2D(colortex2, shiftedUVs).r > 0.0f) {
                sum += lightColor2;
            }
            lightColor2 = light * sampleDepth;
            /*if(dot((sum + lightColor) * vec3(1.5025),vec3(0.333f)) < BLOOM_THRESHOLD) {
                continue;
            }*/
            sum += lightColor2;
        #endif

        depth = texture2D(depthtex0, shiftedUVs).r;

        //sum += mix2(vec3(0.0), lightColor3, float(depth >= 1.0));
    }

    for(int i = 0; i < BLOOM_QUALITY/2; i++) {
        mediump float sampleDepth = mix2(0.0162162162,0.985135135,float(i)/(BLOOM_QUALITY/2));
        vec2 shiftedUVs = vec2(TexCoords.x + (float(i)/BLOOM_QUALITY) * radius * 4f * blur * hstep, TexCoords.y + (float(i)/BLOOM_QUALITY) * radius * 4f * blur * hstep).rg;
        vec2 specularUVs = vec2(specularCoord.x - (float(i)/BLOOM_QUALITY) * radius * 4f * blur * hstep, specularCoord.y - (float(i)/BLOOM_QUALITY) * radius * 4f * blur * hstep).rg;
        //vec3 specularMap = (texture2D(colortex10, specularUVs).rgb + texture2D(colortex11, specularUVs).rgb);
        //specularMap = pow2(specularMap, vec3(100.0));
        vec3 light = GetLightmapColor(texture2D(colortex2, shiftedUVs).rg * vec2(0.6f, 1.0f));
        lightColor3 = texture2D(colortex2,shiftedUVs).rgb;
        illumination += texture2D(colortex2,shiftedUVs).a;
        vec2 UVsOffset = -vec2((float(i)/BLOOM_QUALITY) * radius * 4f * blur * hstep, (float(i)/BLOOM_QUALITY) * radius * 4f * blur * hstep).rg;
        /*#ifdef VOLUMETRIC_LIGHTING
            light += volumetricLight(sunPosition, depthtex1, shiftedUVs, VL_SAMPLES, VL_DECAY, VL_EXPOSURE, VL_WEIGHT, VL_DENSITY, vec3(VL_COLOR_R, VL_COLOR_G, VL_COLOR_B));
        #endif*/
        /*mediump float normalA = texture2D(depthtex0,shiftedUVs).r;
        mediump float normalB = texture2D(depthtex0,shiftedUVs + UVsOffset).r;
        mediump float isEntity = texture2D(colortex15,shiftedUVs).r;
        mediump float isEntity2 = texture2D(colortex15,shiftedUVs + UVsOffset).r;
        mediump float camDistance = texture2D(colortex15, shiftedUVs).g;*/

        /*if(abs(normalA - normalB) >= depthTolerance/camDistance) {
            continue;
        }*/
        /*if(waterTest > 0f) {
            sum += (specularMap + light) * sampleDepth;
            continue;
        }*/
        #ifdef SCENE_AWARE_LIGHTING
            light = lightColor * illumination;
            sum += lightColor * sampleDepth;
        #elif PATH_TRACING_GI == 1
            cameraRight = normalize2(cross(lightDir, vec3(0.0, 1.0, 0.0)));
            cameraUp = cross(cameraRight, lightDir);
            rayDir = normalize2(lightDir + shiftedUVs.x * cameraRight + shiftedUVs.y * cameraUp);
            Ray ray = Ray(viewSpaceFragPosition + vec3(shiftedUVs, 0.0), rayDir);
            vec3 rayColor2 = traceRay(ray,vec2(length(lightmap),1f), Normal,Albedo.a)/vec3(2) * sampleDepth;
            
            /*if(dot((sum + rayColor) * vec3(10.5025),vec3(0.333f)) < BLOOM_THRESHOLD) {
                continue;
            }*/

            sum += rayColor2;
            if(texture2D(colortex2, shiftedUVs).r > 0.0f) {
                sum += vec3(0.6f) * (texture2D(colortex2, shiftedUVs).r) * mix2(vec3(1.0), TorchColor,0.4f);
            }
        #else
            vec3 lightColor2 = vec3(0.6f) * (texture2D(colortex2, shiftedUVs).r) * mix2(vec3(1.0), TorchColor,0.4f);
            /*if(dot((sum + lightColor) * vec3(1.5025),vec3(0.333f)) < BLOOM_THRESHOLD) {
                continue;
            }*/
            if(texture2D(colortex2, shiftedUVs).r > 0.0f) {
                sum += lightColor2;
            }
            lightColor2 = light * sampleDepth;
            /*if(dot((sum + lightColor) * vec3(1.5025),vec3(0.333f)) < BLOOM_THRESHOLD) {
                continue;
            }*/
            sum += lightColor2;
        #endif

        depth = texture2D(depthtex0, shiftedUVs).r;

        //sum += mix2(vec3(0.0), lightColor3, float(depth >= 1.0));
    }

    sum /= BLOOM_QUALITY/8;

    /*sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x - 8.0 * blur * hstep, TexCoords.y - 8.0 * blur * hstep)).rg) * 0.0162162162;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x - 7.0 * blur * hstep, TexCoords.y - 7.0 * blur * hstep)).rg) * 0.0540540541;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x - 6.0 * blur * hstep, TexCoords.y - 6.0 * blur * hstep)).rg) * 0.1216216216;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x - 5.0 * blur * hstep, TexCoords.y - 5.0 * blur * hstep)).rg) * 0.1945945946;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x - 4.0 * blur * hstep, TexCoords.y - 4.0 * blur * hstep)).rg) * 0.389189189;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x - 3.0 * blur * hstep, TexCoords.y - 3.0 * blur * hstep)).rg) * 0.583783784;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x - 2.0 * blur * hstep, TexCoords.y - 2.0 * blur * hstep)).rg) * 0.875675676;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x - 1.0 * blur * hstep, TexCoords.y - 1.0 * blur * hstep)).rg) * 0.985135135;

    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x + 8.0 * blur * hstep, TexCoords.y + 8.0 * blur * hstep)).rg) * 0.0162162162;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x + 7.0 * blur * hstep, TexCoords.y + 7.0 * blur * hstep)).rg) * 0.0540540541;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x + 6.0 * blur * hstep, TexCoords.y + 6.0 * blur * hstep)).rg) * 0.1216216216;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x + 5.0 * blur * hstep, TexCoords.y + 5.0 * blur * hstep)).rg) * 0.1945945946;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x + 4.0 * blur * hstep, TexCoords.y + 1.0 * blur * hstep)).rg) * 0.389189189;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x + 3.0 * blur * hstep, TexCoords.y + 2.0 * blur * hstep)).rg) * 0.583783784;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x + 2.0 * blur * hstep, TexCoords.y + 3.0 * blur * hstep)).rg) * 0.875675676;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x + 1.0 * blur * hstep, TexCoords.y + 4.0 * blur * hstep)).rg) * 0.985135135;*/

    /*if(dot(sum, vec3(0.333)) > 2) {
        sum *= mix2(vec3(2),vec3(0.5),clamp(dot(sum, vec3(0.333)),0,1.2));
    }*/

    //sum = mix2(vec3(0.0), sum, 1 - step(1 - length(lightColor),0.1));

    mediump float bloomLerp = 1.0f;
    #if BLOOM_INTENSITY + 0.5 > 0.0
        //bloomLerp = clamp(length((sum * vec3(0.0625))/(BLOOM_THRESHOLD - 0.25)),0,1);
        bloomLerp = clamp(1 - smoothstep(BLOOM_THRESHOLD, 1, 1 - length(sum * vec3(0.0625))), 0, 1);
    #endif

    /*if(bloomLerp - 0.25 > 1.0f) {
        bloomLerp -= 1.0f;
    } else {
        bloomLerp = 0;
    }*/

    //bloomLerp = clamp01(bloomLerp);

    sum *= 0.5f;

    #ifdef SCENE_AWARE_LIGHTING
        sum = mix2(sum,lightColor,bloomLerp);
    #elif PATH_TRACING_GI == 1
        sum = mix2(rayColor,sum,bloomLerp);
    #else
        sum = mix2(lightColor,sum,bloomLerp);
    #endif

    sum *= BLOOM_INTENSITY + 0.5;

    return vec4(pow2(sum,vec3(GAMMA)), illumination);
}

//mediump float far = 1f;

/*vec4 GetLightVolume(vec3 pos) {
    vec4 lightVolume;

    #ifdef COMPOSITE
        #undef ACL_CORNER_LEAK_FIX
    #endif

    #ifdef ACL_CORNER_LEAK_FIX
        mediump float minMult = 1.5;
        ivec3 posTX = ivec3(pos * voxelVolumeSize);

        ivec3[6] adjacentOffsets = ivec3[](
            ivec3( 1, 0, 0),
            ivec3(-1, 0, 0),
            ivec3( 0, 1, 0),
            ivec3( 0,-1, 0),
            ivec3( 0, 0, 1),
            ivec3( 0, 0,-1)
        );

        int adjacentCount = 0;
        for (int i = 0; i < 6; i++) {
            int voxel = int(texelFetch(voxel_sampler, posTX.xy + adjacentOffsets[i].xy, 0).r);
            if (voxel == 1 || voxel >= 200) adjacentCount++;
        }

        if (int(texelFetch(voxel_sampler, posTX.xy, 0).r) >= 200) adjacentCount = 6;
    #endif

    if ((frameCounter & 1) == 0) {
        lightVolume = texture(colortex4, pos.xy);
        #ifdef ACL_CORNER_LEAK_FIX
            if (adjacentCount >= 3) {
                vec4 lightVolumeTX = texelFetch(colortex4, posTX.xy, 0);
                if (dot(lightVolumeTX, lightVolumeTX) > 0.01)
                lightVolume.rgb = min(lightVolume.rgb, lightVolumeTX.rgb * minMult);
            }
        #endif
    } else {
        lightVolume = texture(colortex4, pos.xy);
        #ifdef ACL_CORNER_LEAK_FIX
            if (adjacentCount >= 3) {
                vec4 lightVolumeTX = texelFetch(colortex4, posTX.xy, 0);
                if (dot(lightVolumeTX, lightVolumeTX) > 0.01)
                lightVolume.rgb = min(lightVolume.rgb, lightVolumeTX.rgb * minMult);
            }
        #endif
    }

    return lightVolume;
}*/

vec4 rayMarch(vec3 rayOrigin, vec3 rayDir, float density) {
    vec4 color = vec4(0.0);
    mediump float stepSize = 0.01;
    for(float t = 0.0; t < 1.0; t += stepSize) {
        vec3 pos = rayOrigin + t * rayDir;
        vec3 lightDir = normalize2(sunPosition - viewSpaceFragPosition);
        vec3 light = vec3(max(dot(normalize2(lightDir),normalize2(pos - cameraPosition)), 0.0));
        vec4 newColor = color;
        newColor.rgb += density * light * stepSize;
        newColor.a += density * stepSize;

        color = mix2(color, newColor, 1 - step(color.a, 1.0));
    }

    return color;
}

mediump float fresnel(float sin_critical) {
	mediump float t = (1.f - sin_critical) / (1.f + sin_critical);
	return t * t;
}

mediump float fresnel(vec3 normal, vec3 viewDir, float pow2er) {
    return pow2(1.0 - dot(normalize2(normal), normalize2(viewDir)), pow2er);
}

void noonFunc(float time, float timeFactor) {
    mediump float dayNightLerp = clamp((time+250f)/timeFactor,0,1);
    baseDiffuseModifier = vec3(DAY_I);
    currentColor = mix2(baseColor,dayColor,dayNightLerp);
    Diffuse = mix2(baseDiffuse, pow2(Diffuse.rgb,vec3(GAMMA)) * baseDiffuseModifier, mod(worldTime/6000f,2f));
    fogAlbedo = mix2(baseFog, vec3(FOG_DAY_R, FOG_DAY_G, FOG_DAY_B), dayNightLerp);
}

void sunsetFunc(float time, float timeFactor) {
    mediump float sunsetLerp = clamp((time+250f)/timeFactor,0,1);
    baseDiffuseModifier = vec3(SUNSET_I);
    currentColor = mix2(dayColor, transitionColor, sunsetLerp);
    Diffuse = mix2(baseDiffuse, pow2(Diffuse.rgb,vec3(GAMMA)) * baseDiffuseModifier, mod(worldTime/6000f,2f));
    fogAlbedo = mix2(baseFog, vec3(FOG_SUNSET_R, FOG_SUNSET_G, FOG_SUNSET_B), sunsetLerp);
}

void nightFunc(float time, float timeFactor) {
    mediump float dayNightLerp = clamp((time+250f)/timeFactor,0,1);
    baseDiffuseModifier = vec3(NIGHT_I * 0.4f);
    currentColor = mix2(baseColor, nightColor, dayNightLerp);
    Diffuse = mix2(baseDiffuse, pow2(Diffuse.rgb,vec3(GAMMA)) * baseDiffuseModifier,mod(worldTime/6000f,2f));
    fogAlbedo = mix2(baseFog, vec3(FOG_NIGHT_R, FOG_NIGHT_G, FOG_NIGHT_B), dayNightLerp);
}

void dawnFunc(float time, float timeFactor) {
    mediump float sunsetLerp = clamp((time+250f)/timeFactor,0,1);
    baseDiffuseModifier = vec3(SUNSET_I);
    currentColor = mix2(dayColor, transitionColor, sunsetLerp);
    Diffuse = mix2(baseDiffuse, pow2(Diffuse.rgb,vec3(GAMMA)) * baseDiffuseModifier, mod(worldTime/6000f,2f));
    fogAlbedo = mix2(baseFog, vec3(FOG_SUNSET_R, FOG_SUNSET_G, FOG_SUNSET_B), sunsetLerp);
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

mediump float linearizeDepth(float depth, float near, float far) {
    return (near * far) / (depth * (near - far) + far);
}

vec3 rgbToHsv(vec3 c) {
    mediump float max = max(c.r, max(c.g, c.b));
    mediump float min = min(c.r, min(c.g, c.b));
    mediump float chroma = max - min;
    mediump float saturation = (max == 0.0) ? 0.0 : chroma / max;
    return vec3(saturation);
}

vec3 waterFunction(vec2 coords, vec4 noise, float lightBrightness) {
    mediump float distanceFromCamera = distance(vec3(0), viewSpaceFragPosition);
    mediump float isRain = texture2D(colortex3, TexCoords).r;
    vec2 refractionFactor = vec2(0);
    vec2 TexCoords2 = coords;
    mediump float underwaterDepth = texture2D(depthtex0, TexCoords2).r;
    mediump float underwaterDepth2 = texture2D(depthtex1, TexCoords2).r;
    #ifdef WATER_REFRACTION
        if(isRain == 1.0) {
            refractionFactor = sin(noise.y) * vec2(0.03125f) / max( distanceFromCamera*2f,1);
            TexCoords2 += refractionFactor;
            underwaterDepth = texture2D(depthtex0, TexCoords2).r;
            underwaterDepth2 = texture2D(depthtex1, TexCoords2).r;
        }
    #endif
    vec3 waterColor = vec3(0.0f, 0.33f, 0.44f);
    if(underwaterDepth >= 1.0) {
        waterColor = vec3(0.0f, 0.33f, 0.44f);
        return pow2(clamp(mix2(texture2D(colortex0, TexCoords2).rgb/lightBrightness,waterColor,0.85)/clamp(lightBrightness,0.99,1.0),vec3(0.0f, 0.0f, 0.0f),(texture2D(colortex0, TexCoords2).rgb/0.2 * 0.15) + (waterColor*0.85))*clamp(lightBrightness,0.2,1.0), vec3(GAMMA));
        //return pow2(mix2(texture2D(colortex0, TexCoords2).rgb,waterColor,0.5),vec3(GAMMA));
    }
    return pow2(mix2(texture2D(colortex0, TexCoords2).rgb,waterColor,clamp(1 - (underwaterDepth2 - underwaterDepth) * 0.125f,0,0.5)), vec3(GAMMA)) * clamp(lightBrightness,0.5,1.0);
    //return pow2(mix2(texture2D(colortex0, TexCoords2).rgb,waterColor,0.5),vec3(GAMMA));
}

bool isOutOfTexture(vec2 texcoord) {
    return (texcoord.x < 0.0 || texcoord.x > 1.0 || texcoord.y < 0.0 || texcoord.y > 1.0);
}

vec3 getWorldPosition(vec2 texcoord, float depth) {
    vec3 clipSpace = vec3(texcoord, depth) * 2.0 - 1.0;
    vec4 viewW = gbufferProjectionInverse * vec4(clipSpace, 1.0);
    vec3 viewSpace = viewW.xyz / viewW.w;
    vec4 world = gbufferModelViewInverse * vec4(viewSpace, 1.0);

    return world.xyz;
}

vec3 getUVFromPosition(vec3 position) {
    vec4 projection = gbufferProjectionModelView * gbufferModelView * vec4(position, 1.0);
    projection.xyz /= projection.w;
    vec3 clipSpace = projection.xyz * 0.5 + 0.5;

    return clipSpace.xyz;
}

vec2 ssrRay(vec3 startPosition, vec3 reflectionDir) {
    vec3 currPos = vec3(0.0);
    vec3 currUV = vec3(0.0);
    mediump float currLength = 10.0;
    int maxIter = 100;
    mediump float bias = 0.00001;

    for (int i = 0; i < maxIter; i++) {
        // Get ray position
        currPos = startPosition + reflectionDir * currLength;
        // Get UV coordinates of ray
        currUV = getUVFromPosition(currPos);
        // Get depth of ray
        mediump float currDepth = texture2D(depthtex0, currUV.xy).r;

        if (isOutOfTexture(currUV.xy)) {
            return vec2(-1);
        }

        if (abs(currUV.z - currDepth) < bias) {
            if (currDepth < 1.0)
                return currUV.xy;
            else
                return vec2(-1);
        }

        // March along ray
        vec3 newPos = getWorldPosition(currUV.xy, currDepth);
        currLength = length(newPos - startPosition);
    }

    return vec2(-2);
}

vec4 waterReflections(vec3 color, vec2 uv, vec3 normal) {
    vec4 finalColor = vec4(color, 1.0);

    mediump float depth = texture2D(depthtex0, uv).r;
    vec3 position = getWorldPosition(uv, depth);
    vec3 viewDir = normalize2(position);
    //vec3 newNormal = (gbufferModelView * gbufferProjection * vec4(normal,1.0)).xyz;
    vec3 reflectedDir = normalize2(reflect(viewDir, normal));

    vec2 reflectionUV = ssrRay(position, reflectedDir);
    if(reflectionUV.x > 0.0) {
        vec3 reflectionColor = texture2D(colortex0, reflectionUV).rgb;
        finalColor = mix2(mix2(vec4(reflectionColor, 1.0), finalColor, 0.4), finalColor, 1 - uv.y);
    }

    //finalColor = mix2(vec4(finalColor, 1.0), vec4(color, 1.0),uv.x);
    
    return finalColor;
}

vec4 metallicReflections(vec3 color, vec2 uv, vec3 normal) {
    vec4 finalColor = vec4(color, 1.0);

    mediump float depth = texture2D(depthtex0, uv).r;
    vec3 position = getWorldPosition(uv, depth);
    vec3 viewDir = normalize2(position);
    vec3 reflectedDir = normalize2(reflect(viewDir, normal));

    vec2 reflectionUV = ssrRay(position, reflectedDir);
    if(reflectionUV.x > 0.0) {
        vec3 reflectionColor = texture2D(colortex0, reflectionUV).rgb;
        finalColor = mix2(mix2(vec4(reflectionColor, 1.0), finalColor, 0.8), finalColor, 1 - uv.y);
    }

    //finalColor = mix2(vec4(finalColor, 1.0), vec4(color, 1.0),uv.x);
    
    return finalColor;
}

float foamFactor(vec3 worldCoords, vec3 worldCoords2) {
    vec2 depthA2d = triplanarCoords(abs(worldCoords - worldCoords2), texture2D(colortex1,TexCoords).rgb * 2.0 - 1.0, 1.0).xy;
    float depth = max(depthA2d.x, depthA2d.y);
    vec2 depthB2d = triplanarCoords(worldCoords, texture2D(colortex1,TexCoords).rgb * 2.0 - 1.0, 1.0).xy; //textureLod(depthtex0, TexCoords, 0).r;
    float depth2 = max(depthB2d.x, depthB2d.y);
    float foamScale = sqrt(dot(cameraPosition - worldCoords, cameraPosition - worldCoords));
    float distanceFactor = 1.0/(1.0 + depth * 32.0);
    depth *= distanceFactor;
    float foamThreshold = clamp(1.25 * distanceFactor, 0.0, 1.0);
    float shoreDistance = clamp(depth * 5.0, 0.0, 1.0);
    float noiseA = triplanarTexture(worldCoords*0.125 + vec3(0.001 * frameTimeCounter), texture2D(colortex1,TexCoords).rgb * 2.0 - 1.0, colortex13, 1.0).r * 2 - 1;
    float noiseB = triplanarTexture(worldCoords*0.25 - vec3(0.001 * frameTimeCounter), texture2D(colortex1,TexCoords).rgb * 2.0 - 1.0, colortex13, 1.0).r * 2 - 1;
    float noise = (noiseA + noiseB)/2;

    if(depth > 0.25 * distanceFactor + noise * 0.05) return 0;

    return smoothstep(foamThreshold, foamThreshold + 0.05, shoreDistance * 500);
}

vec2 getUVsForLUT(vec3 color) {
    vec2 texelSize = vec2(1.0 / 256.0, 1.0 / 16.0);
    float tileX = mod(color.b, 16.0);
    float tileY = floor(color.b/16.0);
    vec2 uv = vec2(
        (color.r + tileX * 16.0 + 0.5) * texelSize.x,
        (color.g + tileY * 16.0 + 0.5) * texelSize.y
    );

    return uv;
}

vec3 loadLUT(vec3 color, sampler2D lut) {
    color = pow2(color, vec3(1/2.2));
    color = clamp(color, vec3(0.0), vec3(1.0));

    vec3 scaled = color * 15.0;
    vec3 index = floor(scaled);
    vec3 frac = scaled - index;

    vec3 c000 = texture2D(lut, getUVsForLUT(index)).rgb;
    vec3 c100 = texture2D(lut, getUVsForLUT(index + vec3(1.0, 0.0, 0.0))).rgb;
    vec3 c010 = texture2D(lut, getUVsForLUT(index + vec3(0.0, 1.0, 0.0))).rgb;
    vec3 c110 = texture2D(lut, getUVsForLUT(index + vec3(1.0, 1.0, 0.0))).rgb;
    vec3 c001 = texture2D(lut, getUVsForLUT(index + vec3(0.0, 0.0, 1.0))).rgb;
    vec3 c101 = texture2D(lut, getUVsForLUT(index + vec3(1.0, 0.0, 1.0))).rgb;
    vec3 c011 = texture2D(lut, getUVsForLUT(index + vec3(0.0, 1.0, 1.0))).rgb;
    vec3 c111 = texture2D(lut, getUVsForLUT(index + vec3(1.0, 1.0, 1.0))).rgb;

    vec3 c00 = mix2(c000, c100, frac.r);
    vec3 c01 = mix2(c001, c101, frac.r);
    vec3 c10 = mix2(c010, c110, frac.r);
    vec3 c11 = mix2(c011, c111, frac.r);

    vec3 c0 = mix2(c00, c10, frac.g);
    vec3 c1 = mix2(c01, c11, frac.g);

    vec3 result = mix2(c0, c1, frac.b);

    result = pow2(result, vec3(2.2));
    return clamp(result, vec3(0.0), vec3(1.0));
}

vec3 BrightnessContrast(vec3 color, float brt, float sat, float con)
{
	// Increase or decrease theese values to adjust r, g and b color channels seperately
	const float AvgLumR = 0.5;
	const float AvgLumG = 0.5;
	const float AvgLumB = 0.5;
	
	const vec3 LumCoeff = vec3(0.2125, 0.7154, 0.0721);
	
	vec3 AvgLumin  = vec3(AvgLumR, AvgLumG, AvgLumB);
	vec3 brtColor  = color * brt;
	vec3 intensity = vec3(dot(brtColor, LumCoeff));
	vec3 satColor  = mix(intensity, brtColor, sat);
	vec3 conColor  = mix(AvgLumin, satColor, con);
	
	return conColor;
}

vec3 sharpenMask(sampler2D tex, vec2 UVs, vec3 color, float factor, float blendAmount) {
    vec2 uv2 = (UVs*vec2(viewWidth, viewHeight) + vec2(0,1))/vec2(viewWidth, viewHeight);
    vec3 up = texture2D(tex, uv2).rgb;
    
    uv2 = (UVs*vec2(viewWidth, viewHeight) + vec2(-1,0))/vec2(viewWidth, viewHeight);
    vec3 left = texture2D(tex, uv2).rgb;

    uv2 = (UVs*vec2(viewWidth, viewHeight) + vec2(1,0))/vec2(viewWidth, viewHeight);
    vec3 right = texture2D(tex, uv2).rgb;

    uv2 = (UVs*vec2(viewWidth, viewHeight) + vec2(0,-1))/vec2(viewWidth, viewHeight);
    vec3 down = texture2D(tex, uv2).rgb;

    vec3 sharpenedTexture = (1.0 + 4.0*factor)*color - factor*(up + left + right + down);

    return mix(color, sharpenedTexture, blendAmount);
}

#if AA == 2
    #include "lib/smaa.glsl"
#elif AA == 3
    #include "lib/taa.glsl"
#endif

vec3 antialiasing(vec2 UVs, sampler2D tex) {
    vec3 finalColor = texture2D(tex, UVs).rgb;
    #if AA == 3
        finalColor = applyTAA(UVs, tex);
    #elif AA == 2
        float edge = edgeFactor(UVs, tex);
        float blendStrength = computeBlendStrength(UVs);

        vec3 blended = blendSMAA(UVs, tex);
        vec3 original = texture2D(tex, UVs).rgb;
        vec3 aaColor = mix2(original, blended, blendStrength);
        finalColor = mix2(aaColor, original, step(edge, 0.0));
        //finalColor = sharpenMask(tex, UVs, finalColor, 0.25, 0.25 * step(edge, 0.0));
    #elif AA == 1
        float u  =  floor(UVs.x * viewWidth) / viewWidth;
        float v  = (floor(UVs.y * viewHeight) / viewHeight);

        vec3 left = texture2D(tex, vec2(u, v)).rgb;

        u  =  ceil(UVs.x* viewWidth) / viewWidth;
        v  = (ceil(UVs.y * viewHeight) / viewHeight);

        vec3 right = texture2D(tex, vec2(u, v)).rgb;

        vec3 color = texture2D(tex, UVs).rgb;

        color.r = mix2(left.r, right.r, clamp(fract(color.r),0,1));
        color.g = mix2(left.g, right.g, clamp(fract(color.g),0,1));
        color.b = mix2(left.b, right.b, clamp(fract(color.b),0,1));

        //color = pow2(color, vec3(2.2));
        color = clamp(color, vec3(0.0), vec3(1.0));

        finalColor = sharpenMask(tex, UVs, color, BAA_SHARPEN_AMOUNT, BAA_SHARPEN_BLEND);
    #endif

    return finalColor;
}

#if VOXEL_AREA == 32
    const mediump float voxelDistance = 32.0;
#endif
#if VOXEL_AREA == 64
    const mediump float voxelDistance = 64.0;
#endif
#if VOXEL_AREA == 128
    const mediump float voxelDistance = 128.0;
#endif

#include "lib/timeCycle.glsl"

void main() {
    #if defined SCENE_AWARE_LIGHTING && defined BLOOM
        mediump float aspect = float(viewWidth)/float(viewHeight);
        mediump float waterTest = texture2D(colortex5, TexCoords).r;
        mediump float dhTest = texture2D(colortex5, TexCoords).g;

        vec2 TexCoords2 = TexCoords;

        mediump float Depth = texture2D(depthtex0, TexCoords).r;
        mediump float Depth2 = texture2D(depthtex1, TexCoords).r;

        vec2 fragCoord = gl_FragCoord.xy/vec2(viewWidth, viewHeight);

        vec3 worldTexCoords = screenToWorld(TexCoords, clamp(Depth,0.0,1.0));
        vec3 worldTexCoords2 = screenToWorld(TexCoords, clamp(Depth2,0.0,1.0));

        mediump float underwaterDepth = texture2D(depthtex0, TexCoords2).r;
        mediump float underwaterDepth2 = texture2D(depthtex1, TexCoords2).r;
        
        vec3 Albedo;

        mediump float albedoAlpha;

        mediump float distanceFromCamera = distance(vec3(0), viewSpaceFragPosition);

        //vec4 noiseMap = texture2D(colortex8, mod(worldTexCoords.xz/5,5)/vec2(5f) + (mod(worldTexCoords.x/5,5)*0.005f + ((frameCounter)/90f)*2.5f) * 0.01f);
        //vec4 noiseMap2 = texture2D(colortex9, mod(worldTexCoords.xz/5,5)/vec2(2.5f) - (mod(worldTexCoords.x/5,5)*0.005f + ((frameCounter)/90f)*2.5f) * 0.01f);

        //vec4 noiseMap4 = texture2D(colortex8, mod(worldTexCoords.xz/50,5)/vec2(5f) + (mod(worldTexCoords.x/50,5)*0.005f + ((frameCounter)/90f)*2.5f) * 0.01f);
        //vec4 noiseMap5 = texture2D(colortex9, mod(worldTexCoords.xz/5,5)/vec2(2.5f) - (mod(worldTexCoords.x/5,5)*0.005f + ((frameCounter)/90f)*2.5f) * 0.01f);

        //vec4 finalNoiseA = (noiseMap * noiseMap2);
        //vec4 finalNoiseB = (noiseMap4 * noiseMap5);

        //vec4 finalNoise = (finalNoiseA * finalNoiseB);

        //vec4 noiseMapA = texture2D(colortex8, worldTexCoords.xz/6.25f + vec2(fract(frameTimeCounter/120f)));
        //vec4 noiseMapB = texture2D(colortex8, worldTexCoords.xz/6.25f - vec2(fract(frameTimeCounter/120f)));

        vec4 noiseMapA = triplanarTexture(worldTexCoords/6.25f + vec3(fract(frameTimeCounter/120f)), vNormal, colortex8, 1.0);
        vec4 noiseMapB = triplanarTexture(worldTexCoords/6.25f - vec3(fract(frameTimeCounter/120f)), vNormal, colortex8, 1.0);

        vec4 finalNoise = noiseMapA * noiseMapB;

        vec4 noiseMap3 = texture2D(colortex8, TexCoords - sin(TexCoords.y*64f + ((frameCounter)/90f)) * 0.005f);

        vec3 Normal = normalize2(texture2D(colortex1, TexCoords2).rgb * 2.0f -1.0f);

        vec3 worldGeoNormal = normalize2(texture2D(colortex1,TexCoords).xyz);

        //vec3 worldTangent = mat3(gbufferModelViewInverse) * Tangent.xyz;

        //vec3 normalNormalSpace = vec3(Normal.xy, sqrt(1.0 - dot(Normal.xy, Normal.xy))) * 2.0 - 1.0;
        //mat3 TBN = tbnNormalTangent(worldGeoNormal,worldTangent);

        vec3 normalWorldSpace = normalize2(texture2D(colortex1,TexCoords).xyz);

        vec3 shadowLightDirection = normalize2(mat3(gbufferModelViewInverse) * shadowLightPosition);

        mediump float lightBrightness = clamp(dot(shadowLightDirection, worldGeoNormal),0.2,1.0);

        #if AA > 0
            Albedo = antialiasing(TexCoords, colortex0);
        #else
            Albedo = texture2D(colortex0, TexCoords).rgb;
        #endif

        //vec4 specularDataA = 1 - texture2D(colortex10,worldTexCoords.xy/vec2(500f));
        //vec4 specularDataB = 1 - texture2D(colortex11,worldTexCoords.xy/vec2(500f));

        vec2 refractionFactor = vec2(0);

        mediump float isRain = texture2D(colortex3, TexCoords).r;

        if(waterTest > 0) {
            if(underwaterDepth2 - underwaterDepth > 0f || Depth >= 1.0)
            {
                if(Depth >= 1.0) {
                    Albedo = pow2(waterFunction(TexCoords, finalNoise, lightBrightness),vec3(1/GAMMA));
                    albedoAlpha = 0.0;
                } else {
                    Albedo = waterFunction(TexCoords, finalNoise, lightBrightness);
                    albedoAlpha = 0.0;
                }
                vec3 Albedo2 = pow2(mix2(texture2D(colortex0, TexCoords2).rgb,vec3(0.0f,0.11f,0.33f),clamp(1 - (underwaterDepth2 - underwaterDepth) * 0.125f,0,0.5)), vec3(GAMMA));
                //Normal = normalize2(max(finalNoise.xyz * 2.0f -1.0f,Normal));
                
                shadowLightDirection = normalize2(mat3(gbufferModelViewInverse) * shadowLightPosition);
                //worldGeoNormal = mat3(gbufferModelViewInverse) * Normal;
                //worldTangent = mat3(gbufferModelViewInverse) * Tangent.xyz;

                //normalNormalSpace = vec3(Normal.xy, sqrt(1.0 - dot(Normal.xy, Normal.xy))) * 2.0 - 1.0;
                //TBN = tbnNormalTangent(worldGeoNormal,worldTangent);

                //normalWorldSpace = TBN * normalNormalSpace;

                //specularDataA = 1 - texture2D(colortex10,worldTexCoords.xy/vec2(500f) + refractionFactor);
                //specularDataB = 1 - texture2D(colortex11,worldTexCoords.xy/vec2(500f) + refractionFactor);
                
                //mediump float perceptualSmoothness = (specularDataA.r + specularDataB.r)/2;
                //mediump float roughness = pow2(1.0 - perceptualSmoothness, 2.0);

                //mediump float smoothness = 1 - roughness;
                
                vec3 reflectionDir = reflect(-shadowLightDirection, normalWorldSpace);

                vec3 fragFeetPlayerSpace = vec3(gbufferModelViewInverse * vec4(viewSpaceFragPosition, 1.0));

                vec3 fragWorldSpace = fragFeetPlayerSpace + cameraPosition;
                
                //vec3 fragPos = gl_FragCoord.xyz;

                vec3 viewDirection = normalize2(cameraPosition - viewSpaceFragPosition);
                vec3 reflectDir = reflect(-sunPosition, Normal);

                mediump float specularStrength = 0.5;

                mediump float spec = pow2(max(dot(viewDirection, reflectDir),0.0),32);
                vec3 specularColor = vec3(1.0);
                vec3 specular = specularStrength * spec * specularColor;

                //mediump float diffuseLight = roughness * clamp(dot(shadowLightDirection, normalWorldSpace), 0.0, 1.0);
                
                //mediump float specularLight = smoothness * clamp(pow2(dot(shadowLightDirection, normalWorldSpace),100.0), 0.0, 1.0);

                mediump float ambientLight = 0.0;

                vec3 result = (ambientLight + Albedo.xyz + specular);

                //Albedo.xyz = mix2(Albedo.xyz, specularColor, specularStrength * clamp(spec,0,1));

                //lightBrightness = ambientLight + diffuseLight + specularLight;
                //Albedo.xyz = mix2(Albedo.xyz, vec3(1.0), lightBrightness);
            } else {
                underwaterDepth = texture2D(depthtex0, TexCoords).r;
                underwaterDepth2 = texture2D(depthtex1, TexCoords).r;
                Albedo = pow2(mix2(Albedo,vec3(0.0f,0.33f,0.55f),clamp((0.5 - (underwaterDepth2 - underwaterDepth)) * 0.5,0,1)), vec3(GAMMA));

                Normal = normalize2(texture2D(colortex1, TexCoords).rgb * 2.0f -1.0f);
                TexCoords2 = TexCoords;
            }
            #ifdef WATER_FOAM
                vec3 foamColor = vec3(1.0);
                #ifdef BLOOM
                    vec3 lightColor = bloom(waterTest, worldTexCoords.xy/vec2(500f) + refractionFactor, Normal, vec4(Albedo,albedoAlpha)).xyz;
                    foamColor *= clamp(dot(sunPosition, normalWorldSpace * 2.0 - 1.0), MIN_LIGHT, MAX_LIGHT);
                    foamColor = mix(foamColor, lightColor, clamp(length(lightColor), 0.0, 0.5));
                #endif
                vec3 foamWater = mix2(Albedo.xyz, foamColor, foamFactor(worldTexCoords, worldTexCoords2));
                
                Albedo = mix2(Albedo, foamWater, 1 - step(isRain, 0.9));
            #endif

            vec3 refNormal = texture2D(colortex1, TexCoords).rgb;
            //refNormal = tbnNormalTangent(refNormal, Tangent) * refNormal;
            vec4 Albedo4 = waterReflections(Albedo.xyz,TexCoords,refNormal);
            Albedo = mix2(Albedo, Albedo4.xyz, step(isRain, 0.9));
            albedoAlpha = mix2(albedoAlpha, Albedo4.a, step(isRain, 0.9));

            if(blindness > 0.0) {
                mediump float waterBlindness = texture2D(colortex5,TexCoords).z;
                Albedo = mix2(Albedo, vec3(0.0), waterBlindness);
            }
        } else {
            albedoAlpha = 0.0;
            if(isEyeInWater >= 1) {
                Albedo = pow2(isInWater(colortex0, vec3(0.0f,0.33f,0.55f), TexCoords2, vec2(noiseMap3.x * 0.025,0), 0.25), vec3(GAMMA)); 
            } else {
                #if AA > 0
                    Albedo = pow2(antialiasing(TexCoords, colortex0), vec3(GAMMA));
                #else
                    Albedo = pow2(texture2D(colortex0, TexCoords).rgb, vec3(GAMMA));
                #endif
            }
            Normal = normalize2(texture2D(colortex1, TexCoords).rgb * 2.0f -1.0f);
        }

        mediump float isReflective = texture2D(colortex5, TexCoords).b;

        if(isReflective > 0.0) {
            Albedo = metallicReflections(Albedo,TexCoords,Normal).xyz;
        }

        /*if(Depth != Depth2 && waterTest > 0) {
            Albedo = mix2(Albedo,mix2(Albedo,vec3(0.0f,0.22f,0.55f),0.25), clamp((1 - (Depth - Depth2)),0,1)*0.5);
        }*/

        vec3 currentColor = dayColor;

        /*if(timePhase > 3) {
            timePhase = 0;
        }*/
        Diffuse = Albedo;

        vec3 baseColor = currentColor;
        vec3 baseDiffuse = Diffuse;

        vec3 baseDiffuseModifier;

        vec3 currentFogColor = vec3(FOG_DAY_R,FOG_DAY_G,FOG_DAY_B);
        
        if(worldTime/(timePhase + 1) < 500f) {
            baseColor = currentColor;
            baseDiffuse = Diffuse;
            baseFog = currentFogColor;
        }
        
        mediump float dayNightLerp = clamp(quadTime/11500,0,1);
        mediump float sunsetLerp = clamp(quadTime/500,0,1);
        
        vec4 cloudViewPos = gbufferProjection * vec4(TexCoords, 0.0, 1.0);
        vec4 cloudClipPos = cloudViewPos;
        
        vec3 cloudNDC = cloudClipPos.xyz / cloudClipPos.w;

        vec2 cloudScreenPos = cloudNDC.xy * 0.5 + 0.5;

        vec4 cloudNoiseMap = texture2D(noisetex, cloudScreenPos - vec2(worldTime * 550.0, 0.0));
        vec4 cloudNoiseMap2 = texture2D(noisetex, cloudScreenPos + vec2(0.0, worldTime * 550.0));
        vec4 cloudFinalNoise = mix2(cloudNoiseMap,vec4(0.0),cloudNoiseMap2);

        vec3 cloudRayDir = normalize2(viewSpaceFragPosition);
        vec4 cloudColor = rayMarch(cameraPosition, cloudRayDir, cloudFinalNoise.y);

        Diffuse = mix2(Diffuse, cloudColor.xyz, cloudColor.a);

        vec3 lightColorDay = vec3(NATURAL_LIGHT_DAY_R, NATURAL_LIGHT_DAY_G, NATURAL_LIGHT_DAY_B) * NATURAL_LIGHT_DAY_I;
        vec3 lightColorNight = vec3(NATURAL_LIGHT_NIGHT_R, NATURAL_LIGHT_NIGHT_G, NATURAL_LIGHT_NIGHT_B) * NATURAL_LIGHT_NIGHT_I;
        
        float timeNorm = mod(worldTime,24000.0) / 24000.0;

        float weightDay = 0.5 + 0.5 * cos((timeNorm - 0.25) * 2.0 * PI);
        float weightNight = 0.5 + 0.5 * cos((timeNorm - 0.75) * 2.0 * PI);
        vec3 currentLightColor = (weightDay * lightColorDay) + (weightNight * lightColorNight);

        if(isBiomeEnd) {
            timeFunctionFrag();
            if(dhTest <= 0) {
                currentColor = vec3(0.3f);
            } else {
                currentColor = seColor;
            }
        } else {
            timeFunctionFrag();
        }/*else if(timePhase < 1) {
            baseDiffuseModifier = vec3(DAY_I);
            currentColor = mix2(baseColor,dayColor,dayNightLerp);
            Diffuse = mix2(baseDiffuse, pow2(Diffuse.rgb,vec3(2.2)) * baseDiffuseModifier, mod(worldTime/6000f,2f));
            
        } else if(timePhase < 2) {
            baseDiffuseModifier = vec3(SUNSET_I);
            currentColor = mix2(dayColor, transitionColor, sunsetLerp);
            Diffuse = mix2(baseDiffuse, pow2(Diffuse.rgb,vec3(2.2)) * baseDiffuseModifier, mod(worldTime/6000f,2f));
        } else if(timePhase < 3) {
            baseDiffuseModifier = vec3(NIGHT_I * 0.4f);
            currentColor = mix2(baseColor, nightColor, dayNightLerp);
            Diffuse = mix2(baseDiffuse, pow2(Diffuse.rgb,vec3(2.2)) * baseDiffuseModifier,mod(worldTime/6000f,2f));
        } else if(timePhase < 4) {
            baseDiffuseModifier = vec3(SUNSET_I);
            currentColor = mix2(nightColor, transitionColor, sunsetLerp);
            Diffuse = mix2(baseDiffuse, pow2(Diffuse.rgb,vec3(2.2)) * baseDiffuseModifier, mod(worldTime/6000f,2f));
        }*/

        //Diffuse *= currentColor;

        if(Depth == 1.0f){
            /*mediump float distanceFromCamera = distance(vec3(0), viewSpaceFragPosition);

            mediump float maxBlindnessDistance = 30;
            mediump float minBlindnessDistance = 20;

            mediump float blindnessBlendValue = clamp((distanceFromCamera - minBlindnessDistance) / (maxBlindnessDistance - minBlindnessDistance),0,1);*/
        
            currentColor = mix2(currentColor, cloudColor.xyz, cloudColor.a);

            /*if(worldTime%24000 > 12000 && dot(Albedo,vec3(0.333f)) < 0.5f) {
                currentColor *= NIGHT_I * 0.5f;
            }*/

            mediump float detectSky = texture2D(colortex5, TexCoords).g;
            mediump float detectEntity = texture2D(colortex12, TexCoords).r;
            #ifdef BLOOM
                vec4 bloomAmount = bloom(waterTest, worldTexCoords.xy/vec2(500f) + refractionFactor, Normal, vec4(Albedo,albedoAlpha));
                vec3 lightmapColor = bloomAmount.xyz;
                float lightBrightness2 = bloomAmount.a;
            #else
                vec3 lightmapColor = texture2D(colortex2, TexCoords.xy).rgb;
            #endif
            //Diffuse = mix2(Diffuse, vec3(1.0), lightmapColor.x);
            if(detectSky < 1.0) {
                if(isBiomeEnd) {
                    vec3 shadowLightDirection = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);

                    vec3 worldNormal = texture2D(colortex1, TexCoords).xyz * 2 - 1;

                    mediump float lightBrightness = clamp(dot(shadowLightDirection, worldNormal),max(0.2, SE_MIN_LIGHT),SE_MAX_LIGHT);

                    Diffuse = pow2(texture2D(colortex0, TexCoords.xy).rgb,vec3(GAMMA));
                    //Diffuse *= vec3(3.5025);
                    //Diffuse.xyz *= lightBrightness;

                    //Diffuse.xyz = max(Diffuse.xyz, vec3(0.02));

                    mediump float seMinLight = SE_MIN_LIGHT;

                    lightmapColor = mix2(lightmapColor, max(vec3(0.5), normalize2(lightmapColor)) * vec3(seMinLight), 1 - step(seMinLight * seMinLight, dot(lightmapColor, lightmapColor)));

                    //lightmapColor = max(vec3(seMinLight), lightmapColor);

                    vec3 worldSpaceSunPos = (gbufferProjectionInverse * gbufferModelViewInverse * vec4(sunPosition,1.0)).xyz;
                    mediump float NdotL = max(dot(Normal, normalize2(worldSpaceSunPos)), 0.2f);
                    //vec3 Diffuse2 = texture2D(colortex0, TexCoords.xy).rgb;
                    //Diffuse = mix2(Diffuse, Diffuse/vec3(lightBrightness),0.75);
                    //Diffuse /= lightBrightness;
                    //Diffuse = mix2(Diffuse, Diffuse * vec3(lightBrightness),0.5);
                    //Diffuse.xyz += lightmapColor;
                    //Diffuse2.xyz *= vec3(3.5025);
                    //vec3 Diffuse3 = mix2(Diffuse, Diffuse2, 0.5);
                    //Diffuse = mix2(Diffuse, Diffuse3, length(Diffuse));
                    //Diffuse = mix2(Diffuse, vec3(1.0), lightmapColor.x);
                    /*Diffuse = mix2(Diffuse,vec3(pow2(dot(Diffuse,vec3(0.333f)),1/2.55) * 0.5),clamp(CalcSaturation(Diffuse.xyz),0,1 - MIN_SE_SATURATION));//1.0625-clamp(vec3(dot(lightmapColor.rgb,vec3(0.333f))),0.5,1));
                    float aoValue = 1;
                    Diffuse = mix2(Diffuse * (lightmapColor + NdotL + Ambient) * aoValue,Diffuse * (NdotL + Ambient) * aoValue,0.25);
                    float fogFactor = texture2D(colortex6, TexCoords).y;
                    Diffuse = mix2(Diffuse, fogAlbedo, fogFactor);*/

                    float aoValue = 1;
                    vec3 shadowLerp = GetShadow(Depth2);

                    lightmapColor *= vec3(3.5025);

                    vec3 Diffuse3 = mix2(Diffuse * ((mix2(lightmapColor,vec3(dot(lightmapColor,vec3(0.333f))),0.75)*0.125 + NdotL * shadowLerp + Ambient)) * aoValue,Diffuse * ((NdotL * shadowLerp + Ambient)) * aoValue,0.25);
                    //Diffuse = mix2(Diffuse, seColor, 0.01);
                    Diffuse3 = mix2(Diffuse3,mix2(vec3(pow2(dot(Diffuse3,vec3(0.333f)),1/2.55) * 0.175f),seColor * 0.125f, 0.01),1.0625-clamp(vec3(dot(lightmapColor.rg,vec2(0.333f))),MIN_SE_SATURATION,1));
                    Diffuse3 = mix2(Diffuse3, lightmapColor, clamp(pow2(length(lightmapColor * 0.0025),1.75),0,0.025));

                    float fogFactor = texture2D(colortex6, TexCoords).y;
                    Diffuse3 = mix2(Diffuse3, fogAlbedo, fogFactor);

                    Diffuse.xyz = mix2(unreal(Diffuse3.xyz),aces(Diffuse3.xyz),0.75);
                    

                    Diffuse.xyz = mix2(Diffuse.xyz * lightBrightness,Diffuse.xyz,dot(Diffuse.xyz, vec3(0.333)));
                } else {
                    /*if(dot(LightmapColor,vec3(0.333)) > maxLight) {
                        LightmapColor = LightmapColor/vec3(dot(LightmapColor,vec3(0.333)));
                    }*/
                    vec3 shadowLightDirection = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);

                    vec3 worldNormal = texture2D(colortex1, TexCoords).xyz * 2 - 1;

                    mediump float lightBrightness = clamp(dot(shadowLightDirection, worldNormal),max(0.2, MIN_LIGHT),MAX_LIGHT);

                    mediump float minLight = MIN_LIGHT;

                    lightmapColor = mix2(lightmapColor, normalize2(lightmapColor) * vec3(minLight), 1 - step(minLight * minLight,dot(lightmapColor, lightmapColor)));

                    lightmapColor = max(lightmapColor, vec3(minLight));

                    vec3 worldSpaceSunPos = (gbufferProjectionInverse * gbufferModelViewInverse * vec4(sunPosition,1.0)).xyz;
                    mediump float NdotL = max(dot(Normal, normalize2(worldSpaceSunPos)), 0.2f);

                    float aoValue = 1;
                    vec3 shadowLerp = GetShadow(Depth2);

                    Diffuse = pow2(texture2D(colortex0, TexCoords.xy).rgb,vec3(GAMMA));

                    //Diffuse *= lightBrightness;

                    //vec3 LightmapColor = vec3(1.0);

                    Diffuse.xyz += lightmapColor;

                    lightmapColor = max(currentLightColor,lightmapColor * lightBrightness2 * 8)/128;
                    vec3 Diffuse3 = mix2(Albedo * (lightmapColor + NdotL * shadowLerp + Ambient) * aoValue,Albedo * (NdotL * shadowLerp + Ambient) * aoValue,0.25);
                    Diffuse3 = mix2(Diffuse3, lightmapColor, clamp(pow2(length(lightmapColor * 0.0025),1.75),0,0.025));

                    if(waterTest > 0) {
                        Diffuse3.xyz = mix2(Diffuse3.xyz, vec3(0.0f,0.33f,0.55f), clamp(waterTest,0,0.5));
                        vec3 refNormal = texture2D(colortex1, TexCoords).rgb;
                        vec4 Albedo4 = waterReflections(Diffuse3.xyz,TexCoords,refNormal);
                        Diffuse3.xyz = Albedo4.xyz;
                        albedoAlpha = Albedo4.a;
                        Diffuse3.xyz *= lightBrightness/2f;
                    }

                    float fogFactor = texture2D(colortex6, TexCoords).y;
                    Diffuse3 = mix2(Diffuse3, fogAlbedo, fogFactor);

                    Diffuse.xyz = mix2(unreal(Diffuse3.xyz),aces(Diffuse3.xyz),0.75);
                }
                /*if(waterTest > 0f) {
                    Diffuse = pow2(waterFunction(TexCoords, finalNoise, lightBrightness),vec3(1/2.2));
                }*/

                if(waterTest <= 0 && !isBiomeEnd) Diffuse.xyz *= max(ambientOcclusion(Normal, vec3(TexCoords, 1.0), texture2D(colortex15, TexCoords).x),max(0.2,MIN_LIGHT));
                Diffuse.xyz = mix2(Diffuse.xyz, vec3(0), blindness);
                #if VIBRANT_MODE == 1
                    if(isBiomeEnd) {
                        Diffuse.xyz = loadLUT(Diffuse.xyz, colortex14);
                        //Diffuse.xyz = BrightnessContrast(Diffuse.xyz, 1.5, 1.0, 0.995);
                    } else {
                        Diffuse.xyz = loadLUT(Diffuse.xyz, colortex9);
                        //Diffuse.xyz = BrightnessContrast(Diffuse.xyz, 1.0, 1.0, 1.0125);
                    }
                #endif
                gl_FragData[0] = vec4(pow2(Diffuse.xyz,vec3(1/GAMMA)), 1.0f);
            } else {
                #ifdef BLOOM
                    Albedo.xyz = mix2(Albedo.xyz, lightmapColor, clamp(length(lightmapColor), 0.0, 1.0));
                #endif
                #if VIBRANT_MODE == 1
                    if(isBiomeEnd) {
                        Albedo.xyz = loadLUT(Albedo.xyz, colortex14);
                        //Diffuse.xyz = BrightnessContrast(Diffuse.xyz, 1.5, 1.0, 0.995);
                    } else {
                        Albedo.xyz = loadLUT(Albedo.xyz, colortex9);
                        //Diffuse.xyz = BrightnessContrast(Diffuse.xyz, 1.0, 1.0, 1.0125);
                    }
                #endif
                Albedo.xyz = mix2(Albedo.xyz, vec3(0), blindness);
                gl_FragData[0] = vec4(currentColor * Albedo, 1.0f);
            }
            return;
        }

        mediump float minLight = MIN_LIGHT;
        mediump float seMinLight = SE_MIN_LIGHT;
        
        vec3 LightmapColor;
        float lightBrightness2 = 0;
        //vec3 Lightmap = bloom();

        /*#ifdef PATH_TRACING
            vec2 uv = gl_FragCoord.xy / vec2(viewWidth, viewHeight);
            vec3 lightDir = normalize2(sunPosition);
            vec3 cameraRight = normalize2(cross(lightDir, vec3(0.0, 1.0, 0.0)));
            vec3 cameraUp = cross(cameraRight, lightDir);
            vec3 rayDir = normalize2(lightDir + uv.x * cameraRight + uv.y * cameraUp);
            Ray ray = Ray(viewSpaceFragPosition, rayDir);

            LightmapColor = traceRay(ray,vec2(length(lightmap),1f), Normal);

            LightmapColor += GetLightmapColor(vec2(length(lightmap),0f));
        #else*/
            #ifdef BLOOM
                vec4 bloomAmount = bloom(waterTest, worldTexCoords.xy/vec2(500f) + refractionFactor, Normal, vec4(Albedo,albedoAlpha));
                LightmapColor = bloomAmount.xyz;
                lightBrightness2 = bloomAmount.a;
                /*if(dot(LightmapColor,vec3(0.333f)) < BLOOM_THRESHOLD) {
                    LightmapColor = GetLightmapColor(texture2D(colortex2, TexCoords).rg);
                }*/
            #else
                blurLightmap(waterTest, worldTexCoords.xy/vec2(500f) + refractionFactor, Normal, vec4(Albedo,albedoAlpha), TexCoords);
                lightBrightness2 = texture2D(colortex2,TexCoords).a;
            #endif
        //#endif
        vec3 LightmapColor2 = texture2D(colortex7,TexCoords2).rgb + lightBrightness;

        if(isBiomeEnd) {
            LightmapColor = mix2(LightmapColor, max(vec3(0.5), normalize2(LightmapColor)) * vec3(seMinLight), 1 - step(seMinLight * seMinLight, dot(LightmapColor, LightmapColor)));
        } else {
            LightmapColor = mix2(LightmapColor, normalize2(LightmapColor) * vec3(minLight), 1 - step(minLight * minLight,dot(LightmapColor, LightmapColor)));
        }

        vec3 worldSpaceSunPos = (gbufferProjectionInverse * gbufferModelViewInverse * vec4(sunPosition,1.0)).xyz;
        mediump float NdotL = max(dot(Normal, normalize2(worldSpaceSunPos)), 0.0f);

        /*if((Lightmap.r + Lightmap.g + Lightmap.b)/3 < 0) {
            Diffuse = Albedo * LightmapColor;
        } else {
            Diffuse = Albedo * ((LightmapColor + NdotL * GetShadow(Depth) + Ambient) * currentColor);
        }*/

        mediump float isParticle = texture2D(colortex6, TexCoords).r;

        /*if(isLiquidEmerald > 0.0) {
            Diffuse = Albedo;
        } else {
            Diffuse = Albedo * ((LightmapColor + NdotL * GetShadow(Depth) + Ambient) * currentColor);
        }*/
        //ivec2 texelCoord = ivec2(gl_FragCoord.xy);
        //translucentMult = 1.0 - texelFetch(colortex4, texelCoord, 0).rgb;
        //vec3 lightFog = GetColoredLightFog(vec3(0), translucentMult, 0, 1, 0, 0);
        /*if(dot(LightmapColor, vec3(0.333f)) < 1.0) {
            Diffuse.xyz = Albedo * ((LightmapColor + NdotL * GetShadow(Depth) + Ambient) * currentColor);
        } else {
            Diffuse.xyz = mix2(Albedo * ((LightmapColor + NdotL * GetShadow(Depth) + Ambient) * currentColor),LightmapColor,Lightmap.r * vec3(0.0625));
        }*/

        mediump float maxLight = MAX_LIGHT;
        mediump float seMaxLight = SE_MAX_LIGHT;
        
        vec3 shadowLerp = GetShadow(Depth2);//mix2(GetShadow(Depth), vec3(1.0), length(LightmapColor));
        if(waterTest > 0) {
            shadowLerp = vec3(1.0);
            //lightBrightness = 1.0;
        }
        float aoValue = 1;
        #ifdef AO
            //shadowLerp *= ambientOcclusion(Normal, vec3(TexCoords, 1.0), texture2D(colortex15, TexCoords).x);
            aoValue = calcAO(TexCoords, foot_pos, 100, depthtex0, colortex1);
        #endif

        float timer = 0;

        /*if(!transitionSE.data.prevDiffuseInit) {
            transitionSE.data.prevDiffuse = Diffuse.xyz;
            transitionSE.data.prevDiffuseInit = true;
        }*/

        transition_data transData = transitionSE.data;

        bool doTransition = transData.prevIsBiomeEnd != isBiomeEnd;

        bool transitionActive = false;
        bool transitionCompleted = false;

        if(doTransition) {
            transitionActive = false;
            transitionCompleted = false;
            transData.transitionCompleted = false;
            transData.transitionActive = false;
        }

        if(!transData.transitionInit) {
            if(isBiomeEnd)
                transData.transitionAmount = 0;
            else
                transData.transitionAmount = 1;
            
            transData.transitionInit = true;
            transData.transitionCompleted = false;
            transData.transitionActive = false;
            transitionActive = false;
            transitionCompleted = false;
            doTransition = true;
        }

        /*#if VIBRANT_MODE == 1
            maxLight = 1.0;
        #endif*/
        
        if(isBiomeEnd) {
            if(!transitionActive && doTransition) {
                transData.entering = true;
                //transData.transitionTimer = 0;
                //timer = 0;
                transData.transitionStartTime = frameTimeCounter;
                transData.transitionCompleted = false;
                transData.transitionActive = true;
                transitionActive = true;
                transitionCompleted = false;
            }
            /*#if PATH_TRACING_GI == 1
                LightmapColor *= vec3(3.5025);
                lightBrightness = max(lightBrightness, 0.5);
            #else
                LightmapColor *= vec3(1.5025);
                lightBrightness = max(lightBrightness, 0.5);
            #endif*/
            if(seMaxLight < 4.1f) {
                float lightMagnitude = length(LightmapColor);
                lightMagnitude = clamp(lightMagnitude, SE_MIN_LIGHT, seMaxLight);
                LightmapColor = clamp(LightmapColor, vec3(0.0),normalize2(LightmapColor) * lightMagnitude);
            }
            LightmapColor *= vec3(3.5025);
            /*if(length(LightmapColor.xyz) > 1.0) {
                LightmapColor.xyz = normalize(LightmapColor.xyz);
            }*/
            vec3 Diffuse3 = mix2(Albedo * ((mix2(LightmapColor,vec3(dot(LightmapColor,vec3(0.333f))),0.75)*0.125 + NdotL * shadowLerp + Ambient) * currentColor) * aoValue,Albedo * ((NdotL * shadowLerp + Ambient) * currentColor) * aoValue,0.25);
            //Diffuse = mix2(Diffuse, seColor, 0.01);
            Diffuse3 = mix2(Diffuse3,vec3(pow2(dot(Diffuse3,vec3(0.333f)),1/2.55) * 0.125f),1.0625-clamp(vec3(dot(LightmapColor.rg,vec2(0.333f))),MIN_SE_SATURATION,1));
            Diffuse3 = mix2(Diffuse3, LightmapColor, clamp(pow2(length(LightmapColor * 0.0025),1.75),0,0.025));
            Diffuse3 = mix2(unreal(Diffuse3),aces(Diffuse3),0.75);

            if(!transData.transitionCompleted) timer = frameTimeCounter - transData.transitionStartTime;
            
            transData.transitionAmount = clamp(timer, 0, 1);

            /*if(transData.transitionCompleted) {
                Diffuse.xyz = Diffuse3;
            } else {
                Diffuse.xyz = mix2(transData.prevDiffuse, Diffuse3, transData.transitionAmount);
            }*/
            Diffuse.xyz = Diffuse3;
        } else {
            if(!transitionActive && doTransition) {
                transData.entering = false;
                //transData.transitionTimer = 0;
                //timer = 0;
                transData.transitionStartTime = frameTimeCounter;
                transData.transitionCompleted = false;
                transData.transitionActive = true;
                transitionActive = true;
                transitionCompleted = false;
            }
            /*#if PATH_TRACING_GI == 0
                LightmapColor *= vec3(0.2525);
                lightBrightness = max(lightBrightness, 0.5);
            #endif*/
            /*if(dot(LightmapColor,vec3(0.333)) > maxLight) {
                LightmapColor = LightmapColor/vec3(dot(LightmapColor,vec3(0.333)));
            }*/
            //LightmapColor *= vec3(0.2525);
            if(maxLight < 4.1f) {
                float lightMagnitude = length(LightmapColor);
                lightMagnitude = clamp(lightMagnitude, MIN_LIGHT, maxLight);
                LightmapColor = clamp(LightmapColor, vec3(0.0),normalize2(LightmapColor) * lightMagnitude);
            }
            LightmapColor = max(currentLightColor,LightmapColor * lightBrightness2 * 8)/128;
            vec3 Diffuse3 = mix2(Albedo * (LightmapColor + NdotL * shadowLerp + Ambient) * aoValue,Albedo * (NdotL * shadowLerp + Ambient) * aoValue,0.25);
            Diffuse3 = mix2(Diffuse3, LightmapColor, clamp(pow2(length(LightmapColor * 0.0025),1.75),0,0.025));
            Diffuse3 = mix2(unreal(Diffuse3),aces(Diffuse3),0.75);

            if(!transData.transitionCompleted) timer = frameTimeCounter - transData.transitionStartTime;

            transData.transitionAmount = clamp(timer, 0, 1);

            /*if(transData.transitionCompleted) {
                Diffuse.xyz = Diffuse3;
            } else {
                Diffuse.xyz = mix2(transData.prevDiffuse, Diffuse3, transData.transitionAmount);
            }*/
            Diffuse.xyz = Diffuse3;
        }

        transData.prevDiffuse = Diffuse.xyz;

        if(timer >= 1) {
            transData.transitionCompleted = true;
            timer = 0;
            transData.transitionTimer = 0;
            transData.transitionAmount = 0;
            transData.transitionActive = false;
        }

        transData.prevIsBiomeEnd = isBiomeEnd;

        transitionSE.data = transData;

        //if(waterTest <= 0) {
            Diffuse.xyz = mix2(Diffuse.xyz * lightBrightness,Diffuse.xyz,dot(LightmapColor, vec3(0.333)));
        //}

        if(waterTest > 0) {
            Diffuse.xyz = Albedo;
        }

        #if VIBRANT_MODE == 1
            if(isBiomeEnd) {
                Diffuse.xyz = loadLUT(Diffuse.xyz, colortex14);
                //Diffuse.xyz = BrightnessContrast(Diffuse.xyz, 1.5, 1.0, 0.995);
            } else {
                Diffuse.xyz = loadLUT(Diffuse.xyz, colortex9);
                //Diffuse.xyz = BrightnessContrast(Diffuse.xyz, 1.0, 1.0, 1.0125);
            }
        #endif

        //vec3 worldSpaceVertexPosition = cameraPosition + (gbufferModelViewInverse * projectionMatrix * modelViewMatrix * vec4(vaPosition,1)).xyz;

        //mediump float maxBlindnessDistance = 30;
        //mediump float minBlindnessDistance = 20;

        //mediump float blindnessBlendValue = clamp((distanceFromCamera - minBlindnessDistance) / (maxBlindnessDistance - minBlindnessDistance),0,1);
        
        //Diffuse.xyz = mix2(Diffuse.xyz, vec3(0), blindness);

        //Diffuse.xyz = mix2(Diffuse.xyz,vec3(0),blindnessBlendValue);
        
        /*if(isLiquidEmerald > 0.0) {
            Diffuse *= vec3(1);
        }*/

        /*if(timePhase < 4 && timePhase > 2) {
            Diffuse.xyz *= vec3(0.4f);
        }*/

        gl_FragData[0] = vec4(pow2(Diffuse.xyz,vec3(1/GAMMA)), 1.0f);
    #else
        gl_FragData[0] = texture2D(colortex0,TexCoords);
    #endif
}