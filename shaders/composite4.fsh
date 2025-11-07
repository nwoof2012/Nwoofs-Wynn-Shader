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

#define AMBIENT_LIGHT_R 0.8 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define AMBIENT_LIGHT_G 0.9 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define AMBIENT_LIGHT_B 1.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

#define VIBRANT_MODE 1 //[0 1 2 3]

#define LUT_NORM 1 // [0 1]
#define LUT_SE 0 // [0 1]

#define MIN_LIGHT 0.25f // [0.0f 0.05f 0.1f 0.15f 0.2f 0.25f 0.3f 0.35f 0.4f 0.45f 0.5f]

#define SE_MIN_LIGHT 0.5f // [0.0f 0.05f 0.1f 0.15f 0.2f 0.25f 0.3f 0.35f 0.4f 0.45f 0.5f]

#define MAX_LIGHT 1.5f // [1.0f 1.1f 1.2f 1.3f 1.4f 1.5f 1.6f 1.7f 1.8f 1.9f 2.0f 2.1f 2.2f 2.3f 2.4f 2.5f 2.6f 2.7f 2.8f 2.9f 3.0f 3.1f 3.2f 3.3f 3.4f 3.5f 3.6f 3.7f 3.8f 3.9f 4.0f 4.1f]

#define SE_MAX_LIGHT 2.0f // [1.0f 1.1f 1.2f 1.3f 1.4f 1.5f 1.6f 1.7f 1.8f 1.9f 2.0f 2.1f 2.2f 2.3f 2.4f 2.5f 2.6f 2.7f 2.8f 2.9f 3.0f 3.1f 3.2f 3.3f 3.4f 3.5f 3.6f 3.7f 3.8f 3.9f 4.0f 4.1f]

#define LIGHTMAP_QUALITY 16 // [4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80 84 88 92 96 100 104 108 112 116 120 124 128]

#define FRAGMENT_SHADER

#define PATH_TRACING_GI 0 // [0 1]

#define AO_WIDTH 0.1 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

#define GAMMA 2.2 // [1.0 1.2 1.4 1.6 1.8 2.0 2.2 2.4 2.6 2.8 3.0]

#define MIN_SE_SATURATION 1.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

#define SSR 1 // [0 1 2 3]

#define WATER_WAVES

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

uniform sampler2D cSampler11;
uniform sampler2D cSampler12;

uniform sampler2D noisetex;

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

uniform sampler2D colortex8;
uniform sampler2D colortex9;

uniform sampler2D lutnormal;
uniform sampler2D lutse;

uniform sampler2D water;

uniform sampler2D noiseb;

uniform sampler2D colortex10;
uniform sampler2D colortex11;

uniform sampler2D colortex12;

uniform sampler2D colortex15;

uniform int dhRenderDistance;

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

layout (rgba8) uniform image2D cimage14;

float thisExposure;
float thisLum;

#include "lib/buffers.glsl"
#include "lib/optimizationFunctions.glsl"
#include "distort.glsl"
#include "lib/spaceConversion.glsl"
#include "program/underwater.glsl"
#include "program/gaussianBlur.glsl"
#include "lib/colorFunctions.glsl"

vec3 dayColor = vec3(DAY_R,DAY_G,DAY_B);
vec3 nightColor = vec3(NIGHT_R,NIGHT_G,NIGHT_B);
vec3 transitionColor = vec3(SUNSET_R,SUNSET_G,SUNSET_B);

vec3 seColor = vec3(SE_R,SE_G,SE_B);

vec3 currentColor;

vec3 Diffuse;

vec3 baseColor;
vec3 baseDiffuse;

vec3 baseDiffuseModifier;

vec3 baseFog;

float baseFogIntensity;

vec3 fogAlbedo;

float fogIntensity;
float fogCurve;

#define FOG_RAIN_MULTIPLIER 1.0;

float baseFogDHTransition;

float fogDHTransition;

float baseFogDistMin;
float baseFogDistMax;

float fogDistMin;
float fogDistMax;

uniform float dhFarPlane;

uniform float rainStrength;

in vec3 lightmap;

uniform vec3 shadowLightPosition;

uniform float screenBrightness;

in vec3 foot_pos;
in vec3 world_pos;

in float isLeaves;

#include "program/ambientOcclusion.glsl"

float getDepthMask(sampler2D local, sampler2D distant) {
    return mix2(linearizeDepth(texture2D(depthtex0, TexCoords).x,near,far) / dhFarPlane, texture2D(colortex13, TexCoords).z * 0.475, step(1.0, texture2D(depthtex0, TexCoords).x)) * 32;
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

vec3 worldToView(vec3 worldPos) {
    vec4 viewSpace = gbufferModelView * vec4(worldPos, 1.0);

    return viewSpace.xyz;
}

vec3 screenToFoot(vec2 screenPos, float depth) {
    vec2 ndc = screenPos * 2.0 - 1.0;

    vec4 clipSpace = vec4(ndc, depth, 1.0);
    vec4 viewSpace = gbufferProjectionInverse * clipSpace;
    viewSpace /= viewSpace.w;

    vec4 worldSpace = gbufferModelViewInverse * viewSpace;
    worldSpace /= worldSpace.w;

    return worldSpace.xyz;
}

vec3 translucentMult;

vec3 blurLightmap(mediump float waterTest, vec2 specularCoord, vec3 Normal, vec4 Albedo, vec2 UVs) {
    vec3 worldUVs = screenToWorld(UVs, texture2D(depthtex1, UVs).r);
    mediump float radius = 1f;
    vec3 sum = vec3(0.0);
    mediump float blur = radius/viewHeight;
    mediump float hstep = 1f;
    vec3 lightColor = texture2D(colortex2, worldUVs.xy).rgb;
    sum += lightColor;

    const vec3 TorchColor = vec3(1.0f, 0.25f, 0.08f);

    mediump float depthTolerance = 0.0125;

    for(int i = 0; i < LIGHTMAP_QUALITY/2; i++) {
        mediump float sampleDepth = mix2(0.0162162162,0.985135135,float(i)/(LIGHTMAP_QUALITY/2));
        vec2 shiftedUVs = vec2(UVs.x - (float(i)/LIGHTMAP_QUALITY) * radius * 4f * blur * hstep, UVs.y - (float(i)/LIGHTMAP_QUALITY) * radius * 4f * blur * hstep).rg;
        vec2 specularUVs = vec2(specularCoord.x - (float(i)/LIGHTMAP_QUALITY) * radius * 4f * blur * hstep, specularCoord.y - (float(i)/LIGHTMAP_QUALITY) * radius * 4f * blur * hstep).rg;
        vec3 light = texture2D(colortex2, shiftedUVs).rgb;
        vec2 UVsOffset = vec2((float(i)/LIGHTMAP_QUALITY) * radius * 4f * blur * hstep, (float(i)/LIGHTMAP_QUALITY) * radius * 4f * blur * hstep).rg;
        light += texture2D(colortex2, vec2(worldUVs.x - UVsOffset.x, worldUVs.y + UVsOffset.y)).rgb;
        vec3 lightColor2 = light;
        if(texture2D(colortex2, shiftedUVs).r > 0.0f) {
            sum = mix2(sum,lightColor2, 0.5);
        }
        lightColor2 = light * sampleDepth;
        sum = mix2(sum,lightColor2, 0.5);
    }

    for(int i = 0; i < LIGHTMAP_QUALITY/2; i++) {
        mediump float sampleDepth = mix2(0.0162162162,0.985135135,float(i)/(LIGHTMAP_QUALITY/2));
        vec2 shiftedUVs = vec2(UVs.x + (float(i)/LIGHTMAP_QUALITY) * radius * 4f * blur * hstep, UVs.y + (float(i)/LIGHTMAP_QUALITY) * radius * 4f * blur * hstep).rg;
        vec2 specularUVs = vec2(specularCoord.x - (float(i)/LIGHTMAP_QUALITY) * radius * 4f * blur * hstep, specularCoord.y - (float(i)/LIGHTMAP_QUALITY) * radius * 4f * blur * hstep).rg;
        vec3 light = texture2D(colortex2, shiftedUVs).rgb;
        vec2 UVsOffset = -vec2((float(i)/LIGHTMAP_QUALITY) * radius * 4f * blur * hstep, (float(i)/LIGHTMAP_QUALITY) * radius * 4f * blur * hstep).rg;
        light += texture2D(colortex2, vec2(worldUVs.x - UVsOffset.x, worldUVs.y + UVsOffset.y)).rgb;
        vec3 lightColor2 = light;
        
        if(texture2D(colortex2, shiftedUVs).r > 0.0f) {
            sum = mix2(sum,lightColor2, 0.5);
        }
        lightColor2 = light * sampleDepth;
        sum = mix2(sum,lightColor2, 0.5);
    }

    mediump float bloomLerp = 1.0f;
    #if BLOOM_INTENSITY + 0.5 > 0.0
        bloomLerp = clamp(length((sum * vec3(0.0625))/(BLOOM_THRESHOLD - 0.25)),0,1);
    #endif

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

#include "program/tonemapping.glsl"

mediump float ambientOcclusion(vec3 normal, vec3 pos, float camDist) {
    mediump float ao = 0.0;
    vec3 samplePos = pos + vec3(AO_WIDTH * 0.1/(camDist));
    if(texture2D(colortex15,pos.xy).g - texture2D(colortex15,samplePos.xy).g > 0.01f) return 1.0;
    vec3 sampleNormal = texture2D(colortex1, samplePos.xy).xyz;
    ao += max(0.0, dot(sampleNormal, normal));
    return ao;
}

#include "program/bloom.glsl"

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
    fogIntensity = FOG_DAY_INTENSITY;
    fogCurve = FOG_DAY_CURVE;
    baseDiffuseModifier = vec3(DAY_I);
    currentColor = dayColor;
    Diffuse = pow2(Diffuse.rgb,vec3(GAMMA)) * baseDiffuseModifier;
    if(isBiomeEnd) {
        fogAlbedo = vec3(FOG_SE_R, FOG_SE_G, FOG_SE_B);
        fogIntensity = FOG_SE_INTENSITY;
        fogCurve = FOG_SE_CURVE;
        fogDHTransition = far/dhFarPlane;
        fogDistMin = FOG_SE_DIST_MIN;
        fogDistMax = FOG_SE_DIST_MAX;
    } else {
        vec3 fogAlbedoDry = vec3(FOG_DAY_R, FOG_DAY_G, FOG_DAY_B);
        fogAlbedo = vec3(FOG_DAY_RAIN_R, FOG_DAY_RAIN_G, FOG_DAY_RAIN_B);
        float fogRain = FOG_DAY_RAIN_INTENSITY * FOG_RAIN_MULTIPLIER;
        fogIntensity = mix2(fogIntensity, fogRain, rainStrength);
        float fogCurveRain = FOG_DAY_RAIN_CURVE;
        fogCurve = mix2(fogCurve, fogCurveRain, rainStrength);
        float fogDHTransitionDry = far/DH_FOG_DAY_DIST_MAX;
        fogDHTransition = far/dhFarPlane;
        fogDistMin = FOG_DAY_DIST_MIN;
        fogDistMax = FOG_DAY_DIST_MAX;
    }
}

void sunsetFunc(float time, float timeFactor) {
    mediump float sunsetLerp = clamp((time)/timeFactor,0,1);
    fogIntensity = mix3(FOG_DAY_INTENSITY, FOG_SUNSET_INTENSITY, FOG_NIGHT_INTENSITY, sunsetLerp, 0.5);
    fogCurve = mix3(FOG_DAY_CURVE, FOG_SUNSET_CURVE, FOG_NIGHT_CURVE, sunsetLerp, 0.5);
    baseDiffuseModifier = mix3(vec3(DAY_I), vec3(SUNSET_I), vec3(NIGHT_I), sunsetLerp, 0.5);
    currentColor = mix3(dayColor, transitionColor, nightColor, sunsetLerp, 0.5);
    Diffuse = pow2(Diffuse.rgb,vec3(GAMMA)) * baseDiffuseModifier;
    if(isBiomeEnd) {
        fogAlbedo = vec3(FOG_SE_R, FOG_SE_G, FOG_SE_B);
        fogIntensity = FOG_SE_INTENSITY;
        fogCurve = FOG_SE_CURVE;
        fogDHTransition = far/dhFarPlane;
        fogDistMin = FOG_SE_DIST_MIN;
        fogDistMax = FOG_SE_DIST_MAX;
    } else {
        vec3 fogAlbedoDry = mix3(vec3(FOG_DAY_R, FOG_DAY_G, FOG_DAY_B), vec3(FOG_SUNSET_R, FOG_SUNSET_G, FOG_SUNSET_B), vec3(FOG_NIGHT_R, FOG_NIGHT_G, FOG_NIGHT_B), sunsetLerp, 0.5);
        vec3 fogAlbedoWet = mix3(vec3(FOG_DAY_RAIN_R, FOG_DAY_RAIN_G, FOG_DAY_RAIN_B), vec3(FOG_SUNSET_RAIN_R, FOG_SUNSET_RAIN_G, FOG_SUNSET_RAIN_B), vec3(FOG_NIGHT_RAIN_R, FOG_NIGHT_RAIN_G, FOG_NIGHT_RAIN_B), sunsetLerp, 0.5);
        fogAlbedo = mix2(fogAlbedoDry, fogAlbedoWet, rainStrength);
        float fogRain = mix3(FOG_DAY_RAIN_INTENSITY, FOG_SUNSET_RAIN_INTENSITY, FOG_NIGHT_RAIN_INTENSITY, sunsetLerp, 0.5) * FOG_RAIN_MULTIPLIER;
        float fogCurveRain = mix3(FOG_DAY_RAIN_CURVE, FOG_SUNSET_RAIN_CURVE, FOG_NIGHT_RAIN_CURVE, sunsetLerp, 0.5);
        fogIntensity = mix2(fogIntensity, fogRain, rainStrength);
        fogCurve = mix2(fogCurve, fogCurveRain, rainStrength);
        float fogDHTransitionDry = far/mix3(DH_FOG_DAY_DIST_MAX, DH_FOG_SUNSET_DIST_MAX, DH_FOG_NIGHT_DIST_MAX, sunsetLerp, 0.5);
        float fogDHTransitionWet = far/mix3(DH_FOG_DAY_RAIN_DIST_MAX, DH_FOG_SUNSET_RAIN_DIST_MAX, DH_FOG_NIGHT_RAIN_DIST_MAX, sunsetLerp, 0.5);
        fogDHTransition = far/dhFarPlane;
        fogDistMin = mix3(FOG_DAY_DIST_MIN, FOG_SUNSET_DIST_MIN, FOG_NIGHT_DIST_MIN, sunsetLerp, 0.5);
        fogDistMax = mix3(FOG_DAY_DIST_MAX, FOG_SUNSET_DIST_MAX, FOG_NIGHT_DIST_MAX, sunsetLerp, 0.5);
    }
}

void nightFunc(float time, float timeFactor) {
    mediump float dayNightLerp = clamp((time+250f)/timeFactor,0,1);
    fogIntensity = FOG_NIGHT_INTENSITY;
    fogCurve = FOG_NIGHT_CURVE;
    baseDiffuseModifier = vec3(NIGHT_I);
    currentColor = nightColor;
    Diffuse = pow2(Diffuse.rgb,vec3(GAMMA)) * baseDiffuseModifier;
    if(isBiomeEnd) {
        fogAlbedo = vec3(FOG_SE_R, FOG_SE_G, FOG_SE_B);
        fogIntensity = FOG_SE_INTENSITY;
        fogCurve = FOG_SE_CURVE;
        fogDHTransition = far/DH_FOG_SE_DIST_MAX;
        fogDistMin = FOG_SE_DIST_MIN;
        fogDistMax = FOG_SE_DIST_MAX;
    } else {
        vec3 fogAlbedoDry = vec3(FOG_NIGHT_R, FOG_NIGHT_G, FOG_NIGHT_B);
        fogAlbedo = vec3(FOG_NIGHT_RAIN_R, FOG_NIGHT_RAIN_G, FOG_NIGHT_RAIN_B);
        float fogRain = FOG_NIGHT_RAIN_INTENSITY * FOG_RAIN_MULTIPLIER;
        fogIntensity = mix2(fogIntensity, fogRain, rainStrength);
        float fogCurveRain = FOG_NIGHT_RAIN_CURVE;
        fogCurve = mix2(fogCurve, fogCurveRain, rainStrength);
        float fogDHTransitionDry = far/DH_FOG_NIGHT_DIST_MAX;
        fogDHTransition = far/dhFarPlane;
        fogDistMin = FOG_NIGHT_DIST_MIN;
        fogDistMax = FOG_NIGHT_DIST_MAX;
    }
}

void dawnFunc(float time, float timeFactor) {
    mediump float sunsetLerp = clamp((time)/timeFactor,0,1);
    fogIntensity = mix3(FOG_NIGHT_INTENSITY, FOG_SUNSET_INTENSITY, FOG_DAY_INTENSITY, sunsetLerp, 0.5);
    fogCurve = mix3(FOG_NIGHT_CURVE, FOG_SUNSET_CURVE, FOG_DAY_CURVE, sunsetLerp, 0.5);
    baseDiffuseModifier = mix3(vec3(NIGHT_I), vec3(SUNSET_I), vec3(DAY_I), sunsetLerp, 0.5);
    currentColor = mix3(nightColor, transitionColor, dayColor, sunsetLerp, 0.5);
    Diffuse = pow2(Diffuse.rgb,vec3(GAMMA)) * baseDiffuseModifier;
    if(isBiomeEnd) {
        fogAlbedo = vec3(FOG_SE_R, FOG_SE_G, FOG_SE_B);
        fogIntensity = FOG_SE_INTENSITY;
        fogCurve = FOG_SE_CURVE;
        fogDHTransition = far/DH_FOG_SE_DIST_MAX;
        fogDistMin = FOG_SE_DIST_MIN;
        fogDistMax = FOG_SE_DIST_MAX;
    } else {
        vec3 fogAlbedoDry = mix3(vec3(FOG_NIGHT_R, FOG_NIGHT_G, FOG_NIGHT_B), vec3(FOG_SUNSET_R, FOG_SUNSET_G, FOG_SUNSET_B), vec3(FOG_DAY_R, FOG_DAY_G, FOG_DAY_B), sunsetLerp, 0.5);
        vec3 fogAlbedoWet = mix3(vec3(FOG_NIGHT_RAIN_R, FOG_NIGHT_RAIN_G, FOG_NIGHT_RAIN_B), vec3(FOG_SUNSET_RAIN_R, FOG_SUNSET_RAIN_G, FOG_SUNSET_RAIN_B), vec3(FOG_DAY_RAIN_R, FOG_DAY_RAIN_G, FOG_DAY_RAIN_B), sunsetLerp, 0.5);
        fogAlbedo = mix2(fogAlbedoDry, fogAlbedoWet, rainStrength);
        float fogRain = mix3(FOG_NIGHT_RAIN_INTENSITY, FOG_SUNSET_RAIN_INTENSITY, FOG_DAY_RAIN_INTENSITY, sunsetLerp, 0.5) * FOG_RAIN_MULTIPLIER;
        fogIntensity = mix2(fogIntensity, fogRain, rainStrength);
        float fogCurveRain = mix3(FOG_NIGHT_RAIN_CURVE, FOG_SUNSET_RAIN_CURVE, FOG_DAY_RAIN_CURVE, sunsetLerp, 0.5);
        fogCurve = mix2(fogCurve, fogCurveRain, rainStrength);
        float fogDHTransitionDry = far/mix3(DH_FOG_NIGHT_DIST_MAX, DH_FOG_SUNSET_DIST_MAX, DH_FOG_DAY_DIST_MAX, sunsetLerp, 0.5);
        float fogDHTransitionWet = far/mix3(DH_FOG_NIGHT_RAIN_DIST_MAX, DH_FOG_SUNSET_RAIN_DIST_MAX, DH_FOG_DAY_RAIN_DIST_MAX, sunsetLerp, 0.5);
        fogDHTransition = far/dhFarPlane;
        fogDistMin = mix3(FOG_NIGHT_DIST_MIN, FOG_SUNSET_DIST_MIN, FOG_DAY_DIST_MIN, sunsetLerp, 0.5);
        fogDistMax = mix3(FOG_NIGHT_DIST_MAX, FOG_SUNSET_DIST_MAX, FOG_DAY_DIST_MAX, sunsetLerp, 0.5);
    }
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

vec3 rgbToHsv(vec3 c) {
    mediump float max = max(c.r, max(c.g, c.b));
    mediump float min = min(c.r, min(c.g, c.b));
    mediump float chroma = max - min;
    mediump float saturation = (max == 0.0) ? 0.0 : chroma / max;
    return vec3(saturation);
}

float waterFresnel(vec3 normal, vec3 viewDir, float bias, float scale, float power) {
    float cosTheta = clamp(dot(normalize2(normal), normalize2(viewDir)),0.0,1.0);

    return bias + scale * pow2(1.0 - cosTheta, power);
}

vec3 waterFunction(vec2 coords, vec4 noise, float lightBrightness) {
    mediump float distanceFromCamera = distance(vec3(0), viewSpaceFragPosition);
    mediump float isRain = texture2D(colortex3, TexCoords).r;
    vec2 refractionFactor = vec2(0);
    vec2 TexCoords2 = coords;
    mediump float underwaterDepth = getDepthMask(depthtex0, cSampler11);
    mediump float underwaterDepth2 = getDepthMask(depthtex1, cSampler11);
    #ifdef WATER_REFRACTION
        if(isRain == 1.0) {
            refractionFactor = sin(noise.y) * vec2(0.03125f) / max( distanceFromCamera*2f,1);
            TexCoords2 += refractionFactor;
            underwaterDepth = getDepthMask(depthtex0, cSampler11);
            underwaterDepth2 = getDepthMask(depthtex1, cSampler11);
        }
    #endif
    vec3 waterColor = vec3(0.0f, 0.2f, 0.22f);
    if(underwaterDepth >= 1.0) {
        waterColor = vec3(0.0f, 0.2f, 0.22f);
        return pow2(clamp(mix2(texture2D(colortex0, TexCoords2).rgb,waterColor,0.85),vec3(0.0f, 0.0f, 0.0f),(texture2D(colortex0, TexCoords2).rgb/0.2 * 0.15) + (waterColor*0.85)), vec3(GAMMA));
    }

    if(texture2D(depthtex0,TexCoords).x == 1.0) {
        underwaterDepth = getDepthMask(depthtex0, cSampler11);
        underwaterDepth2 = getDepthMask(depthtex1, cSampler11);
        return pow2(mix2(texture2D(colortex0, TexCoords2).rgb,waterColor,clamp(1 - (underwaterDepth2 - underwaterDepth) * 0.125f,0,0.5)), vec3(GAMMA));
    }
    vec3 finalColor = mix2(texture2D(colortex0, TexCoords2).rgb,waterColor,clamp(1 - (underwaterDepth2 - underwaterDepth) * 0.125f,0,0.5));
    
    vec3 worldPos = screenToWorld(coords, clamp(texture2D(depthtex0,coords).x,0,1));
    vec3 viewDir = normalize2(cameraPosition - worldPos);

    vec3 reflectionColor = vec3(1.0);
    float fresnelBlend = waterFresnel(noise.xyz, viewDir, 0.02, 0.1, 5.0);
    finalColor = mix2(finalColor, reflectionColor, fresnelBlend);

    return pow2(finalColor, vec3(GAMMA));
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

vec3 getViewPosition(vec2 texcoord, float depth) {
    vec3 clipSpace = vec3(texcoord, depth) * 2.0 - 1.0;
    vec4 viewW = gbufferProjectionInverse * vec4(clipSpace, 1.0);
    vec3 viewSpace = viewW.xyz / viewW.w;

    return viewSpace;
}

vec3 getUVFromPosition(vec3 position) {
    vec4 projection = gbufferProjection * gbufferModelView * vec4(position, 1.0);
    projection.xyz /= projection.w;
    vec3 clipSpace = projection.xyz * 0.5 + 0.5;

    return clipSpace.xyz;
}

vec3 getUVFromViewPosition(vec3 position) {
    vec4 projection = gbufferProjection * vec4(position, 1.0);
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
        mediump float currDepth = getDepthMask(depthtex0, cSampler11);

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

vec4 waterReflections(vec3 color, vec2 uv, vec3 normal, vec4 noise) {
    vec4 finalColor = vec4(color, 1.0);
    
    mediump float distanceFromCamera = distance(vec3(0), viewSpaceFragPosition);
    mediump float isRain = texture2D(colortex3, uv).r;
    mediump float depth = getDepthMask(depthtex0, cSampler11);
    vec3 position = getWorldPosition(uv, depth);
    vec3 viewDir = normalize2(position);
    vec3 reflectedDir = normalize2(reflect(viewDir, normal));

    vec2 refractionFactor = vec2(0);
    #ifdef WATER_REFRACTION
        if(isRain == 1.0) {
            refractionFactor = sin(noise.y) * vec2(0.03125f) / max( distanceFromCamera*2f,1);
        }
    #endif

    vec2 reflectionUV = ssrRay(viewDir, reflectedDir) + refractionFactor;
    if(reflectionUV.x > 0.0) {
        vec3 reflectionColor = texture2D(colortex0, reflectionUV).rgb;
        finalColor = mix2(mix2(vec4(reflectionColor, 1.0), finalColor, 0.4), finalColor, 1 - uv.y);
    }
    
    return finalColor;
}

vec4 waterReflectionsDH(vec3 color, vec2 uv, vec3 normal, vec4 noise) {
    vec4 finalColor = vec4(color, 1.0);
    
    mediump float distanceFromCamera = distance(vec3(0), viewSpaceFragPosition);
    mediump float isRain = texture2D(colortex3, uv).r;
    mediump float depth = texture2D(colortex15, uv).g;
    vec3 position = getWorldPosition(uv, depth);
    vec3 viewDir = normalize2(position);
    vec3 reflectedDir = normalize2(reflect(viewDir, normal));

    vec2 refractionFactor = vec2(0);
    #ifdef WATER_REFRACTION
        if(isRain == 1.0) {
            refractionFactor = sin(noise.y) * vec2(0.03125f) / max( distanceFromCamera*2f,1);
        }
    #endif

    vec2 reflectionUV = ssrRay(viewDir, reflectedDir) + refractionFactor;
    if(reflectionUV.x > 0.0) {
        vec3 reflectionColor = texture2D(colortex0, reflectionUV).rgb;
        finalColor = mix2(mix2(vec4(reflectionColor, 1.0), finalColor, 0.4), finalColor, 1 - uv.y);
    }
    
    return finalColor;
}

vec4 metallicReflections(vec3 color, vec2 uv, vec3 normal) {
    vec4 finalColor = vec4(color, 1.0);

    mediump float depth = getDepthMask(depthtex0, cSampler11);
    vec3 position = getViewPosition(uv, depth);
    vec3 viewDir = normalize2(position);
    vec3 reflectedDir = normalize2(reflect(viewDir, normal));

    vec2 reflectionUV = ssrRay(position, reflectedDir);
    if(reflectionUV.x > 0.0) {
        vec3 reflectionColor = texture2D(colortex0, reflectionUV).rgb;
        finalColor = mix2(mix2(vec4(reflectionColor, 1.0), finalColor, 0.8), finalColor, 1 - uv.y);
    }
    
    return finalColor;
}

float foamFactor(vec3 worldCoords, vec3 worldCoords2) {
    vec2 depthA2d = triplanarCoords(abs(worldCoords - worldCoords2), texture2D(colortex1,TexCoords).rgb * 2.0 - 1.0, 1.0).xy;
    float depth = max(depthA2d.x, depthA2d.y);
    vec2 depthB2d = triplanarCoords(worldCoords, texture2D(colortex1,TexCoords).rgb * 2.0 - 1.0, 1.0).xy;
    float depth2 = max(depthB2d.x, depthB2d.y);
    float foamScale = sqrt(dot(cameraPosition - worldCoords, cameraPosition - worldCoords));
    float distanceFactor = 1.0/(1.0 + depth * 32.0);
    depth *= distanceFactor;
    float foamThreshold = clamp(1.25 * distanceFactor, 0.0, 1.0);
    float shoreDistance = clamp(depth * 5.0, 0.0, 1.0);
    float noiseA = triplanarTexture(worldCoords*0.125 + vec3(0.001 * frameTimeCounter), texture2D(colortex1,TexCoords).rgb * 2.0 - 1.0, noiseb, 1.0).r * 2 - 1;
    float noiseB = triplanarTexture(worldCoords*0.25 - vec3(0.001 * frameTimeCounter), texture2D(colortex1,TexCoords).rgb * 2.0 - 1.0, noiseb, 1.0).r * 2 - 1;
    float noise = (noiseA + noiseB)/2;

    if(depth > 0.5 * distanceFactor + noise * 0.1) return 0;

    return smoothstep(foamThreshold, foamThreshold + 0.05, shoreDistance * 250) * smoothstep(0.0, 0.35, (0.5 * distanceFactor + noise * 0.1) - (depth*0.1));
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

        color = clamp(color, vec3(0.0), vec3(1.0));

        finalColor = sharpenMask(tex, UVs, color, BAA_SHARPEN_AMOUNT, BAA_SHARPEN_BLEND);
    #endif

    return finalColor;
}

#include "program/fog.glsl"

#include "program/blindness.glsl"

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
    #if SCENE_AWARE_LIGHTING > 0 && defined BLOOM
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

        float planeTransition = far/dhFarPlane;

        vec3 Normal = normalize2(texture2D(colortex1, TexCoords2).rgb * 2.0f -1.0f);

        vec3 worldGeoNormal = normalize2(texture2D(colortex1,TexCoords).xyz * 2.0 - 1.0);

        vec4 noiseMapA = triplanarTexture(fract((worldTexCoords + ((frameCounter)/90f)*0.5f) * 0.035f), texture2D(colortex1, TexCoords).xyz, water, 1.0);
        vec4 noiseMapB = triplanarTexture(fract((worldTexCoords - ((frameCounter)/90f)*0.5f) * 0.035f), texture2D(colortex1, TexCoords).xyz, water, 1.0);

        vec4 finalNoise = noiseMapA * noiseMapB;

        vec3 worldTangent = mat3(gbufferModelViewInverse) * Tangent.xyz;

        mat3 TBN = tbnNormalTangent(worldGeoNormal,worldTangent);

        vec4 noiseMap3 = texture2D(water, fract(TexCoords - sin(TexCoords.y*64f + ((frameCounter)/90f)) * 0.005f));

        vec3 normalWorldSpace = normalize2(texture2D(colortex1,TexCoords).xyz);

        vec3 shadowLightDirection = normalize2(mat3(gbufferModelViewInverse) * shadowLightPosition);

        mediump float lightBrightness = clamp(dot(shadowLightDirection, worldGeoNormal),0.2,1.0);

        #if AA > 0
            Albedo = antialiasing(TexCoords, colortex0);
        #else
            Albedo = texture2D(colortex0, TexCoords).rgb;
        #endif

        vec2 refractionFactor = vec2(0);

        mediump float isRain = texture2D(colortex3, TexCoords).r;

        if(waterTest > 0) {
            if(underwaterDepth2 - underwaterDepth > 0f)
            {
                if(Depth >= 1.0) {
                    Albedo = pow2(waterFunction(TexCoords, finalNoise, lightBrightness),vec3(1/GAMMA));
                    albedoAlpha = 0.0;
                } else {
                    Albedo = waterFunction(TexCoords, finalNoise, lightBrightness);
                    albedoAlpha = 0.0;
                }

                #ifdef WATER_WAVES
                    Albedo = mix3(Albedo * 0.5, Albedo, Albedo * 0.75 + vec3(0.25), 0.3,cubicBezier(texture2D(colortex15,TexCoords).b, vec2(0.9, 0.0), vec2(1.0, 1.0)));
                #endif
                
                shadowLightDirection = normalize2(mat3(gbufferModelViewInverse) * shadowLightPosition);
                
                vec3 reflectionDir = reflect(-shadowLightDirection, normalWorldSpace);

                vec3 fragFeetPlayerSpace = vec3(gbufferModelViewInverse * vec4(viewSpaceFragPosition, 1.0));

                vec3 fragWorldSpace = fragFeetPlayerSpace + cameraPosition;

                vec3 viewDirection = normalize2(cameraPosition - viewSpaceFragPosition);

                mediump float specularStrength = 0.5;

                mediump float ambientLight = 0.0;
            } else {
                underwaterDepth = getDepthMask(depthtex0, cSampler11);
                underwaterDepth2 = getDepthMask(depthtex0, cSampler11);
                Albedo = pow2(mix2(Albedo,vec3(0.0f,0.33f,0.55f),clamp((0.5 - (underwaterDepth2 - underwaterDepth)) * 0.5,0,1)), vec3(GAMMA));

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
            
            #if SSR == 1 || SSR == 2
                if(isRain == 1.0) {
                    vec3 refNormal = texture2D(colortex1, TexCoords).rgb * 2.0 - 1.0;
                    vec4 Albedo4 = waterReflections(Albedo.xyz,TexCoords,refNormal, finalNoise);
                    Albedo = Albedo4.xyz;
                    albedoAlpha = Albedo4.a;
                }
            #endif

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

        #if SSR == 1 || SSR == 3
            mediump float isReflective = texture2D(colortex5, TexCoords).b;

            if(isReflective > 0.0) {
                Albedo = metallicReflections(Albedo,TexCoords,Normal).xyz;
            }
        #endif

        vec3 currentColor = dayColor;

        Diffuse = Albedo;

        vec3 baseColor = currentColor;
        vec3 baseDiffuse = Diffuse;

        vec3 baseDiffuseModifier;

        vec3 currentFogColor = vec3(FOG_DAY_R,FOG_DAY_G,FOG_DAY_B);

        float currentFogIntensity = FOG_DAY_INTENSITY;

        fogDHTransition = far/DH_FOG_DAY_DIST_MAX;

        baseFogDistMin = FOG_DAY_DIST_MIN;
        baseFogDistMax = FOG_DAY_DIST_MAX;
        
        if(worldTime/(timePhase + 1) < 500f) {
            baseColor = currentColor;
            baseDiffuse = Diffuse;
            baseFog = currentFogColor;
            baseFogIntensity = currentFogIntensity;
            baseFogDHTransition = fogDHTransition;
            fogDistMin = baseFogDistMin;
            fogDistMax = baseFogDistMax;
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
        }

        float occlusion = step(1.0, Depth2);

        float brightnessMask = 0.0;

        mediump float minLight = MIN_LIGHT;
        mediump float seMinLight = SE_MIN_LIGHT;

        mediump float maxLight = MAX_LIGHT;
        mediump float seMaxLight = SE_MAX_LIGHT;
        
        vec3 LightmapColor;
        float lightBrightness2 = 0;

        float globalDepthMask = getDepthMask(depthtex0, colortex13) * dhFarPlane;

        float globalDepthMask2 = getDepthMask(depthtex1, colortex13) * dhFarPlane;

        if(Depth == 1.0f){
            currentColor = mix2(currentColor, cloudColor.xyz, cloudColor.a);

            mediump float detectSky = texture2D(colortex5, TexCoords).g;
            mediump float detectEntity = texture2D(colortex12, TexCoords).r;
            #ifdef BLOOM
                vec4 bloomAmount = bloom(waterTest, worldTexCoords.xy/vec2(500f) + refractionFactor, Normal, vec4(Albedo,albedoAlpha));
                vec3 lightmapColor = bloomAmount.xyz;
                float lightBrightness2 = bloomAmount.a;
            #else
                vec3 lightmapColor = texture2D(colortex2, TexCoords.xy).rgb;
            #endif
            if(detectSky < 1.0) {
                if(isBiomeEnd) {
                    vec3 shadowLightDirection = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);

                    vec3 worldNormal = texture2D(colortex1, TexCoords).xyz * 2 - 1;

                    mediump float lightBrightness = clamp(dot(shadowLightDirection, worldNormal),max(0.2, SE_MIN_LIGHT),SE_MAX_LIGHT);

                    Diffuse = pow2(texture2D(colortex0, TexCoords.xy).rgb,vec3(GAMMA));

                    if(waterTest > 0) {
                        Albedo = waterFunction(TexCoords, finalNoise, lightBrightness);
                        Diffuse.xyz = mix2(Diffuse.xyz, Albedo, 0.95);
                        #ifdef WATER_WAVES
                            Diffuse.xyz = mix3(Diffuse.xyz * 0.5, Diffuse.xyz, Diffuse.xyz * 0.75 + vec3(0.25), 0.3,cubicBezier(texture2D(colortex15,TexCoords).b, vec2(0.9, 0.0), vec2(1.0, 1.0)));
                        #endif
                    }

                    mediump float seMinLight = SE_MIN_LIGHT;

                    lightmapColor = mix2(lightmapColor, max(vec3(0.5), normalize2(lightmapColor)) * vec3(seMinLight), 1 - step(seMinLight * seMinLight, dot(lightmapColor, lightmapColor)));

                    vec3 worldSpaceSunPos = (gbufferModelViewInverse * vec4(sunPosition,1.0)).xyz;
                    mediump float NdotL = max(dot(Normal, normalize2(worldSpaceSunPos)), 0.2f);

                    float aoValue = 1;
                    #ifdef AO
                        aoValue = DHcalcAO(TexCoords, foot_pos, 100, colortex6, colortex1);
                    #endif
                    vec3 shadowLerp = GetShadow(Depth2);

                    lightmapColor *= vec3(3.5025);

                    vec3 rawLight = lightmapColor;

                    vec3 Diffuse3 = mix2(Diffuse * ((mix2(lightmapColor,vec3(dot(lightmapColor,vec3(0.333f))),0.75)*0.125 + NdotL * shadowLerp + Ambient)) * aoValue,Diffuse * ((NdotL * shadowLerp + Ambient)) * aoValue,0.25);
                    Diffuse3 = mix2(Diffuse3,mix2(vec3(pow2(dot(Diffuse3,vec3(0.333f)),1/2.55) * 0.175f),seColor * 0.125f, 0.01),1.0625-clamp(vec3(dot(lightmapColor.rg,vec2(0.333f))),MIN_SE_SATURATION,1));
                    Diffuse3 = mix2(Diffuse3, lightmapColor, clamp(pow2(length(lightmapColor * 0.0025),1.75),0,0.025));

                    #ifdef AUTO_EXPOSURE
                        Diffuse3.xyz = autoExposure(Diffuse3.xyz, SE_EXP, 5.0);
                    #endif

                    Diffuse.xyz = calcTonemap(Diffuse3.xyz);

                    Diffuse.xyz = mix2(Diffuse.xyz * lightBrightness,Diffuse.xyz,dot(Diffuse.xyz, vec3(0.333)));

                   float fogFactor = clamp(pow2(smoothstep(fogDistMin, fogDistMax,globalDepthMask),fogCurve),0,min(fogIntensity,1.0));
                    Diffuse.xyz = calcFogColor(ScreenToView(vec3(TexCoords, Depth2)), sunPosition, Diffuse.xyz, fogAlbedo, vec3(VL_COLOR_R, VL_COLOR_G, VL_COLOR_B), fogFactor);
                } else {
                    vec3 shadowLightDirection = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);

                    vec3 worldNormal = texture2D(colortex1, TexCoords).xyz * 2 - 1;

                    mediump float lightBrightness = clamp(dot(shadowLightDirection, worldNormal),max(0.2, MIN_LIGHT),MAX_LIGHT);

                    mediump float minLight = MIN_LIGHT;

                    lightmapColor = mix2(lightmapColor, normalize2(lightmapColor) * vec3(minLight), 1 - step(minLight * minLight,dot(lightmapColor, lightmapColor)));

                    vec3 rawLight = lightmapColor;
                    if(maxLight < 4.1f) {
                        float lightMagnitude = length(lightmapColor);
                        lightMagnitude = clamp(lightMagnitude, MIN_LIGHT, maxLight);
                        lightmapColor = clamp(lightmapColor, vec3(0.0),normalize2(lightmapColor) * lightMagnitude);
                    }

                    lightmapColor = max(lightmapColor, vec3(minLight));

                    vec3 worldSpaceSunPos = (gbufferModelViewInverse * vec4(sunPosition,1.0)).xyz;
                    mediump float NdotL = max(dot(Normal, normalize2(worldSpaceSunPos)), 0.2f);

                    float aoValue = 1;
                    #ifdef AO
                        aoValue = DHcalcAO(TexCoords, foot_pos, 100, colortex6, colortex1);
                    #endif
                    vec3 shadowLerp = GetShadow(Depth2);

                    Diffuse = pow2(texture2D(colortex0, TexCoords.xy).rgb,vec3(GAMMA));   
                    if(waterTest > 0) {
                        Albedo = waterFunction(TexCoords, finalNoise, lightBrightness);
                        Diffuse.xyz = mix2(Diffuse.xyz, Albedo, 0.95);
                        #ifdef WATER_WAVES
                            Diffuse.xyz = mix3(Diffuse.xyz * 0.5, Diffuse.xyz, Diffuse.xyz * 0.75 + vec3(0.25), 0.3,cubicBezier(texture2D(colortex15,TexCoords).b, vec2(0.9, 0.0), vec2(1.0, 1.0)));
                        #endif
                    }

                    vec3 sunDir = normalize2(mat3(gbufferModelViewInverse) * sunPosition);
                    vec3 Diffuse3 = Diffuse.xyz * mix2(clamp(lightmapColor * lightBrightness2 * smoothstep(0.0, 0.1, 1 - sunDir.z),MIN_LIGHT, MAX_LIGHT), vec3(AMBIENT_LIGHT_R, AMBIENT_LIGHT_G, AMBIENT_LIGHT_B) * MIN_LIGHT, clamp(1 - dot(sunDir, texture2D(colortex1, TexCoords).xyz * 2 - 1),0,1)) * aoValue;

                    Diffuse3 = mix2(Diffuse3, LightmapColor*0.025, clamp(pow2(smoothstep(MIN_LIGHT, 1.0, length(rawLight)) * 0.5,1.75),0,0.125));

                    Diffuse3.xyz = mix2(Diffuse3.xyz, vec3(VL_COLOR_R, VL_COLOR_G, VL_COLOR_B), texture2D(colortex14,TexCoords).x * brightnessMask);
                    
                    #ifdef AUTO_EXPOSURE
                        Diffuse3.xyz = autoExposure(Diffuse3.xyz, NORM_EXP, 5.0);
                    #endif

                    Diffuse.xyz = calcTonemap(Diffuse3.xyz);

                    float fogFactor = clamp(pow2(smoothstep(fogDistMin, fogDistMax,globalDepthMask),fogCurve),0,min(fogIntensity,1.0));
                    Diffuse.xyz = calcFogColor(ScreenToView(vec3(TexCoords, Depth2)), sunPosition, Diffuse.xyz, fogAlbedo, vec3(VL_COLOR_R, VL_COLOR_G, VL_COLOR_B), fogFactor);
                }

                #if VIBRANT_MODE == 1
                    if(isBiomeEnd) {
                        Diffuse.xyz = loadLUT(Diffuse.xyz, lutse);
                    } else {
                        Diffuse.xyz = loadLUT(Diffuse.xyz, lutnormal);
                    }
                #endif
                Diffuse.xyz = blindEffect(Diffuse.xyz, TexCoords);
                gl_FragData[0] = vec4(pow2(Diffuse.xyz,vec3(1/GAMMA)), 1.0f);
            } else {
                #ifdef BLOOM
                    Albedo.xyz = mix2(Albedo.xyz, lightmapColor, clamp(length(lightmapColor), 0.0, 1.0));
                #endif
                #ifdef AUTO_EXPOSURE
                    if(isBiomeEnd) Albedo.xyz = autoExposure(Albedo.xyz, 1.2, 5.0);
                #endif
                #if VIBRANT_MODE == 1
                    if(isBiomeEnd) {
                        Albedo.xyz = loadLUT(Albedo.xyz, lutse);
                    } else {
                        Albedo.xyz = loadLUT(Albedo.xyz, lutnormal);
                    }
                #endif
                Albedo.xyz = blindEffect(Albedo.xyz, TexCoords);
                Albedo.xyz = mix2(Albedo.xyz, vec3(0), blindness);
                gl_FragData[0] = vec4(currentColor * Albedo, 1.0f);
            }
            return;
        }
            #ifdef BLOOM
                vec4 bloomAmount = bloom(waterTest, worldTexCoords.xy/vec2(500f) + refractionFactor, Normal, vec4(Albedo,albedoAlpha));
                LightmapColor = bloomAmount.xyz;
                lightBrightness2 = bloomAmount.a;
            #else
                blurLightmap(waterTest, worldTexCoords.xy/vec2(500f) + refractionFactor, Normal, vec4(Albedo,albedoAlpha), TexCoords);
                lightBrightness2 = texture2D(colortex2,TexCoords).a;
            #endif
        vec3 LightmapColor2 = texture2D(colortex7,TexCoords2).rgb + lightBrightness;

        if(isBiomeEnd) {
            LightmapColor = mix2(LightmapColor, max(vec3(0.5), normalize2(LightmapColor)) * vec3(seMinLight), 1 - step(seMinLight * seMinLight, dot(LightmapColor, LightmapColor)));
        } else {
            LightmapColor = mix2(LightmapColor, normalize2(LightmapColor) * vec3(minLight), 1 - step(minLight * minLight,dot(LightmapColor, LightmapColor)));
        }

        vec3 worldSpaceSunPos = (gbufferModelViewInverse * vec4(sunPosition,1.0)).xyz;
        mediump float NdotL = max(dot(Normal, normalize2(worldSpaceSunPos)), 0.0f);

        mediump float isParticle = texture2D(colortex6, TexCoords).r;
        
        vec3 shadowLerp = GetShadow(Depth2);

        if(waterTest > 0) {
            shadowLerp = vec3(1.0);
        }
        shadowLerp = mix2(shadowLerp, vec3(0.0), rainStrength);
        float aoValue = 1;
        #ifdef AO
            aoValue = calcAO(TexCoords, foot_pos, 100, depthtex0, colortex1);
        #endif

        float timer = 0;

        if(isBiomeEnd) {
            if(seMaxLight < 4.1f) {
                float lightMagnitude = length(LightmapColor);
                lightMagnitude = clamp(lightMagnitude, SE_MIN_LIGHT, seMaxLight);
                LightmapColor = clamp(LightmapColor, vec3(0.0),normalize2(LightmapColor) * lightMagnitude);
            }
            LightmapColor *= vec3(3.5025) * smoothstep(0.0, 0.1, LightmapColor);
            vec3 Diffuse3 = mix2(Albedo * ((mix2(LightmapColor,vec3(dot(LightmapColor,vec3(0.333f))),0.75)*0.125 + NdotL * shadowLerp + Ambient) * currentColor) * aoValue,Albedo * ((NdotL * shadowLerp + Ambient) * currentColor) * aoValue,0.25);
            Diffuse3 = mix2(Diffuse3,vec3(pow2(dot(Diffuse3,vec3(0.333f)),1/2.55) * 0.125f),1.0625-clamp(vec3(dot(LightmapColor.rg,vec2(0.333f))),MIN_SE_SATURATION,1));
            Diffuse3 = mix2(Diffuse3, LightmapColor, clamp(pow2(length(LightmapColor * 0.0025),1.75),0,0.025));
            #ifdef AUTO_EXPOSURE
                Diffuse3.xyz = autoExposure(Diffuse3.xyz, SE_EXP, 5.0);
            #endif
            Diffuse3 = calcTonemap(Diffuse3);

            Diffuse.xyz = Diffuse3;
        } else {
            vec3 rawLight = LightmapColor;
            if(maxLight < 4.1f) {
                float lightMagnitude = length(LightmapColor);
                lightMagnitude = clamp(lightMagnitude, MIN_LIGHT, maxLight);
                LightmapColor = clamp(LightmapColor, vec3(0.0),normalize2(LightmapColor) * lightMagnitude);
            }
            LightmapColor = max(currentLightColor,LightmapColor * lightBrightness2 * 8)/128;
            vec3 Diffuse3 = mix2(Albedo * (LightmapColor + NdotL * shadowLerp + Ambient) * aoValue,Albedo * (NdotL * shadowLerp + Ambient) * aoValue,0.25);
            Diffuse3 = mix2(Diffuse3, LightmapColor*0.025, clamp(pow2(smoothstep(MIN_LIGHT, 1.0, length(rawLight)) * 0.5,1.75),0,0.125));
            #ifdef AUTO_EXPOSURE
                /*float targetExposure = calcTargetExposure(Diffuse.xyz, 7.0, 5.0);
                if(abs(thisExposure - timeExposure.prevExposure) > 0.0 && timeExposure.isActive != true) {
                    timeExposure.startTime = frameTimeCounter;
                    timeExposure.time = 0;
                    timeExposure.isActive = true;
                    //gl_FragData[0] = vec4(1.0);
                } else if(abs(thisExposure - targetExposure) <= 0.0) {
                    timeExposure.isActive = false;
                }
                timeExposure.time += frameTime;
                //timeExposure.delta = frameTime;*/
                Diffuse3.xyz = autoExposure(Diffuse3.xyz, NORM_EXP, 5.0);
                //timeExposure.prevExposure = thisExposure;
                //timeExposure.prevLum = thisLum;
            #endif
            Diffuse3 = calcTonemap(Diffuse3);

            Diffuse.xyz = Diffuse3;
        }

        Diffuse.xyz = mix2(Diffuse.xyz * lightBrightness,Diffuse.xyz,dot(LightmapColor, vec3(0.333)));
        #if FOG_STYLE > 0
            float fogFactor = clamp(pow2(smoothstep(fogDistMin, fogDistMax,globalDepthMask),fogCurve),0,min(fogIntensity,1.0));
            //Diffuse.xyz = mix2(Diffuse.xyz, max(fogAlbedo, LightmapColor), fogFactor);
            Diffuse.xyz = calcFogColor(ScreenToView(vec3(TexCoords, Depth2)), sunPosition, Diffuse.xyz, fogAlbedo, vec3(VL_COLOR_R, VL_COLOR_G, VL_COLOR_B), fogFactor);
        #endif

        #if VIBRANT_MODE >= 1
            if(isBiomeEnd) {
                #if VIBRANT_MODE == 1 || VIBRANT_MODE == 2
                    Diffuse.xyz = loadLUT(Diffuse.xyz, lutse);
                #endif
            } else {
                #if VIBRANT_MODE == 1 || VIBRANT_MODE == 3
                    Diffuse.xyz = loadLUT(Diffuse.xyz, lutnormal);
                #endif
            }
        #endif

        Diffuse.xyz = blindEffect(Diffuse.xyz, TexCoords);

        gl_FragData[0] = vec4(pow2(Diffuse.xyz,vec3(1/GAMMA)), 1.0f);
    #else
        vec4 Albedo = texture2D(colortex0,TexCoords);
        Albedo.xyz = pow2(Albedo.xyz, vec3(GAMMA));
        #if defined VOLUMETRIC_LIGHTING && defined BLOOM
            vec2 refractionFactor = vec2(0);
            mediump float waterTest = texture2D(colortex5, TexCoords).r;
            mediump float Depth = texture2D(depthtex0, TexCoords).r;
            mediump float Depth2 = texture2D(depthtex1, TexCoords).r;
            vec3 worldTexCoords = screenToWorld(TexCoords, clamp(Depth,0.0,1.0));
            vec3 worldTexCoords2 = screenToWorld(TexCoords, clamp(Depth2,0.0,1.0));
            vec3 Normal = texture2D(colortex1, TexCoords).xyz * 2 - 1;
            vec4 bloomAmount = bloom(waterTest, worldTexCoords.xy/vec2(500f) + refractionFactor, Normal, Albedo);
            vec3 LightmapColor = bloomAmount.xyz;
            float lightBrightness2 = bloomAmount.a;

            mediump float detectSky = texture2D(colortex5, TexCoords).g;

            vec3 vlColor = vec3(VL_COLOR_R, VL_COLOR_G, VL_COLOR_B);

            if(detectSky < 1.0) {
                vec2 fragCoord = gl_FragCoord.xy / vec2(viewWidth, viewHeight);

                vec4 sunViewPos = gbufferProjection * vec4(sunPosition, 1.0);
                vec4 sunClipPos = sunViewPos;

                vec3 sunDirection = normalize2(sunPosition);
    
                vec3 sunNDC = sunClipPos.xyz / sunClipPos.w;

                vec2 sunScreenPos = sunNDC.xy * 0.5 + 0.5;

                mediump float sunMaxDistance = 0.06;
                mediump float distToSun = length((fragCoord - sunScreenPos) * vec2(aspectRatio, 1.0));
                mediump float sunGradient = 1.0 - smoothstep(0.0, sunMaxDistance, distToSun);
                Albedo.xyz += LightmapColor*LightmapColor*vlColor*sunGradient;
            }
        #endif

        Albedo.xyz = pow2(Albedo.xyz, vec3(1/GAMMA));
        gl_FragData[0] = Albedo;
    #endif
}