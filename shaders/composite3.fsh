#version 460 compatibility

#define FRAGMENT_SHADER
#define COMPOSITE_3

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

#define LUT_NORM 1 // [0 1 2]
#define LUT_SE 0 // [0 1]

#define LIGHTMAP_QUALITY 8 // [4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80 84 88 92 96 100 104 108 112 116 120 124 128]

#define FRAGMENT_SHADER

#define PATH_TRACING_GI 0 // [0 1]

#define AO_WIDTH 0.1 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

#define MIN_SE_SATURATION 1.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

#define WATER_WAVES

#include "lib/includes2.glsl"

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

in vec3 vNormal;
in vec3 vViewDir;

in vec2 FoV;

in vec3 Tangent;

layout (rgba8) uniform image2D cimage14;

mediump float thisExposure;
mediump float thisLum;

#include "lib/misc/buffers.glsl"
#include "lib/optimizationFunctions.glsl"
#include "program/distort.glsl"
#include "lib/spaceConversion.glsl"
#include "lib/post/underwater.glsl"
#include "lib/post/gaussianBlur.glsl"
#include "lib/colorFunctions.glsl"

#include "lib/post/hdr.glsl"

mediump vec3 dayColor = vec3(DAY_R,DAY_G,DAY_B);
mediump vec3 nightColor = vec3(NIGHT_R,NIGHT_G,NIGHT_B);
mediump vec3 transitionColor = vec3(SUNSET_R,SUNSET_G,SUNSET_B);

mediump vec3 seColor = vec3(SE_R,SE_G,SE_B);

mediump vec3 currentColor;

mediump vec3 Diffuse;

mediump vec3 baseColor;
mediump vec3 baseDiffuse;

mediump vec3 baseDiffuseModifier;

mediump vec3 baseFog;

mediump float baseFogIntensity;

mediump vec3 fogAlbedo;

mediump float fogIntensity;
mediump float fogCurve;

#define FOG_RAIN_MULTIPLIER 1.0;

mediump float baseFogDHTransition;

mediump float fogDHTransition;

mediump float baseFogDistMin;
mediump float baseFogDistMax;

mediump float fogDistMin;
mediump float fogDistMax;

uniform float dhFarPlane;

uniform float rainStrength;

in vec3 lightmap;

uniform vec3 shadowLightPosition;

uniform float screenBrightness;

in vec3 foot_pos;
in vec3 world_pos;

in float isLeaves;

float getDistMask(sampler2D local) {
    return decodeDist(texture2D(local, TexCoords).y, dhFarPlane);
}

mediump float getDepthMask(sampler2D local, sampler2D distant) {
    return mix2(linearizeDepth(texture2D(depthtex0, TexCoords).x,near,far) / dhFarPlane, texture2D(colortex13, TexCoords).z * 0.5, step(1.0, texture2D(depthtex0, TexCoords).x)) * 32;
}

#include "lib/lighting/ambientOcclusion.glsl"

mediump float AdjustLightmapTorch(in float torch) {
    const mediump float K = 2.0f;
    const mediump float P = 5.06f;
    return K * pow2(torch, P);
}

mediump float AdjustLightmapSky(in float sky){
    mediump float sky_2 = sky * sky;
    return sky_2 * sky_2;
}

mediump vec2 AdjustLightmap(in vec2 Lightmap){
    mediump vec2 NewLightMap;
    NewLightMap.x = AdjustLightmapTorch(Lightmap.x);
    NewLightMap.y = AdjustLightmapSky(Lightmap.y);
    return NewLightMap;
}

mediump vec3 screenToWorld(vec2 screenPos, float depth) {
    mediump vec2 ndc = screenPos * 2.0 - 1.0;

    mediump vec4 clipSpace = vec4(ndc, depth, 1.0);
    mediump vec4 viewSpace = gbufferProjectionInverse * clipSpace;
    viewSpace /= viewSpace.w;

    mediump vec4 worldSpace = gbufferModelViewInverse * viewSpace;
    worldSpace /= worldSpace.w;
    worldSpace.xyz += cameraPosition * 2.0;

    return worldSpace.xyz;
}

mediump vec3 worldToView(vec3 worldPos) {
    mediump vec4 viewSpace = gbufferModelView * vec4(worldPos, 1.0);

    return viewSpace.xyz;
}

mediump vec3 screenToFoot(vec2 screenPos, float depth) {
    mediump vec2 ndc = screenPos * 2.0 - 1.0;

    mediump vec4 clipSpace = vec4(ndc, depth, 1.0);
    mediump vec4 viewSpace = gbufferProjectionInverse * clipSpace;
    viewSpace /= viewSpace.w;

    mediump vec4 worldSpace = gbufferModelViewInverse * viewSpace;
    worldSpace /= worldSpace.w;

    return worldSpace.xyz;
}

mediump vec3 translucentMult;

mediump vec3 blurLightmap(mediump float waterTest, vec2 specularCoord, vec3 Normal, vec4 Albedo, vec2 UVs) {
    mediump vec3 worldUVs = screenToWorld(UVs, texture2D(depthtex1, UVs).r);
    mediump float radius = 1f;
    mediump vec3 sum = vec3(0.0);
    mediump float blur = radius/viewHeight;
    mediump float hstep = 1f;
    mediump vec3 lightColor = texture2D(colortex2, worldUVs.xy).rgb;
    sum += lightColor;

    const vec3 TorchColor = vec3(1.0f, 0.25f, 0.08f);

    mediump float depthTolerance = 0.0125;

    for(int i = 0; i < LIGHTMAP_QUALITY/2; i++) {
        mediump float sampleDepth = mix2(0.0162162162,0.985135135,float(i)/(LIGHTMAP_QUALITY/2));
        mediump vec2 shiftedUVs = vec2(UVs.x - (float(i)/LIGHTMAP_QUALITY) * radius * 4f * blur * hstep, UVs.y - (float(i)/LIGHTMAP_QUALITY) * radius * 4f * blur * hstep).rg;
        mediump vec2 specularUVs = vec2(specularCoord.x - (float(i)/LIGHTMAP_QUALITY) * radius * 4f * blur * hstep, specularCoord.y - (float(i)/LIGHTMAP_QUALITY) * radius * 4f * blur * hstep).rg;
        mediump vec3 light = texture2D(colortex2, shiftedUVs).rgb;
        mediump vec2 UVsOffset = vec2((float(i)/LIGHTMAP_QUALITY) * radius * 4f * blur * hstep, (float(i)/LIGHTMAP_QUALITY) * radius * 4f * blur * hstep).rg;
        light += texture2D(colortex2, vec2(worldUVs.x - UVsOffset.x, worldUVs.y + UVsOffset.y)).rgb;
        mediump vec3 lightColor2 = light;
        if(texture2D(colortex2, shiftedUVs).r > 0.0f) {
            sum = mix2(sum,lightColor2, 0.5);
        }
        lightColor2 = light * sampleDepth;
        sum = mix2(sum,lightColor2, 0.5);
    }

    for(int i = 0; i < LIGHTMAP_QUALITY/2; i++) {
        mediump float sampleDepth = mix2(0.0162162162,0.985135135,float(i)/(LIGHTMAP_QUALITY/2));
        mediump vec2 shiftedUVs = vec2(UVs.x + (float(i)/LIGHTMAP_QUALITY) * radius * 4f * blur * hstep, UVs.y + (float(i)/LIGHTMAP_QUALITY) * radius * 4f * blur * hstep).rg;
        mediump vec2 specularUVs = vec2(specularCoord.x - (float(i)/LIGHTMAP_QUALITY) * radius * 4f * blur * hstep, specularCoord.y - (float(i)/LIGHTMAP_QUALITY) * radius * 4f * blur * hstep).rg;
        mediump vec3 light = texture2D(colortex2, shiftedUVs).rgb;
        mediump vec2 UVsOffset = -vec2((float(i)/LIGHTMAP_QUALITY) * radius * 4f * blur * hstep, (float(i)/LIGHTMAP_QUALITY) * radius * 4f * blur * hstep).rg;
        light += texture2D(colortex2, vec2(worldUVs.x - UVsOffset.x, worldUVs.y + UVsOffset.y)).rgb;
        mediump vec3 lightColor2 = light;
        
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


mediump vec3 GetLightmapColor(in vec2 Lightmap){
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
    mediump vec3 TorchLighting = Lightmap.x * TorchColor;
    mediump vec3 GlowstoneLighting = Lightmap.x * GlowstoneColor;
    mediump vec3 LampLighting = Lightmap.x * LampColor;
    mediump vec3 LanternLighting = Lightmap.x * LanternColor;
    mediump vec3 RedstoneLighting = Lightmap.x * RedstoneColor;
    mediump vec3 RodLighting = Lightmap.x * RodColor;
    mediump vec3 SkyLighting = Lightmap.y * SkyColor;
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
    mediump vec3 LightmapLighting = TorchLighting + GlowstoneLighting + LampLighting + LanternLighting + RedstoneLighting + RodLighting + SkyLighting;
    return LightmapLighting;
}

#include "lib/lighting/pathTracing.glsl"

mediump float Visibility(in sampler2D ShadowMap, in vec3 SampleCoords) {
    return step(SampleCoords.z - 0.001f, texture2D(ShadowMap, SampleCoords.xy).r);
}

mat3 tbnNormalTangent(vec3 normal, vec3 tangent) {
    mediump vec3 bitangent = cross(tangent, normal);
    return mat3(tangent, bitangent, normal);
}

mediump vec3 TransparentShadow(in vec3 SampleCoords){
    mediump float ShadowVisibility0 = Visibility(shadowtex0, SampleCoords);
    mediump float ShadowVisibility1 = Visibility(shadowtex1, SampleCoords);
    mediump vec4 ShadowColor0 = texture2D(shadowcolor0, SampleCoords.xy);
    mediump vec3 TransmittedColor = ShadowColor0.rgb * (1.0f - ShadowColor0.a);
    return mix2(TransmittedColor * ShadowVisibility1, vec3(1.0f), ShadowVisibility0);
}

mediump vec3 GetShadow(float depth) {
    mediump vec3 ClipSpace = vec3(TexCoords, depth) * 2.0f - 1.0f;
    mediump vec4 ViewW = gbufferProjectionInverse * vec4(ClipSpace, 1.0f);
    mediump vec3 View = ViewW.xyz / ViewW.w;
    mediump vec4 World = gbufferModelViewInverse * vec4(View, 1.0f);
    mediump vec4 ShadowSpace = shadowProjection * shadowModelView * World;
    ShadowSpace.xy = DistortPosition(ShadowSpace.xy);
    mediump vec3 worldSpaceSunPos = (gbufferProjection * vec4(sunPosition,1.0)).xyz;
    mediump vec3 lightDir = normalize2(worldSpaceSunPos);
    mediump vec3 normal = texture2D(colortex1, TexCoords).rgb * 2 - 1;
    normal = tbnNormalTangent(normal, Tangent) * normal;
    mediump vec3 normalClip = normal * 2.0f - 1.0f;
    mediump vec4 normalViewW = gbufferProjectionInverse * vec4(normalClip, 1.0);
    mediump vec3 normalView = normalViewW.xyz/normalViewW.w;
    mediump vec4 normalWorld = gbufferModelViewInverse * vec4(normalView, 1.0f);
    mediump vec3 fragPos = texture2D(colortex10, TexCoords).rgb;
    #if RAY_TRACED_SHADOWS == 1
        return computeShadows(lightDir, vec3(0.0), normal, World.xyz);
    #else
        mediump vec3 SampleCoords = ShadowSpace.xyz * 0.5f + 0.5f;
        mediump vec3 ShadowAccum = vec3(0.0f);
        for(int x = -SHADOW_SAMPLES; x <= SHADOW_SAMPLES; x++){
            for(int y = -SHADOW_SAMPLES; y <= SHADOW_SAMPLES; y++){
                mediump vec2 Offset = vec2(x, y) / SHADOW_RES;
                mediump vec3 CurrentSampleCoordinate = vec3(SampleCoords.xy + Offset, SampleCoords.z);
                ShadowAccum += TransparentShadow(CurrentSampleCoordinate);
            }
        }
        ShadowAccum /= TotalSamples;
        return ShadowAccum;
    #endif
}

#include "lib/lighting/volumetricLight.glsl"

mediump vec3 SceneToVoxel(vec3 scenePos) {
	return scenePos + fract(cameraPosition) + (0.5 * vec3(voxelVolumeSize));
}

#include "lib/post/tonemapping.glsl"

mediump float ambientOcclusion(vec3 normal, vec3 pos, float camDist) {
    mediump float ao = 0.0;
    vec3 samplePos = pos + vec3(AO_WIDTH * 0.1/(camDist));
    if(texture2D(colortex15,pos.xy).g - texture2D(colortex15,samplePos.xy).g > 0.01f) return 1.0;
    vec3 sampleNormal = texture2D(colortex1, samplePos.xy).xyz;
    ao += max(0.0, dot(sampleNormal, normal));
    return ao;
}

#include "lib/post/bloom.glsl"

mediump vec4 rayMarch(vec3 rayOrigin, vec3 rayDir, float density) {
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

mediump vec3 skyInfluenceColor;

mediump float timeBlendFactor;

void noonFunc(float time, float timeFactor) {
    mediump float dayNightLerp = smoothstep(250.0, 11750.0, float(worldTime) + fract(frameTimeCounter));
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
        mediump vec3 fogAlbedoDry = vec3(FOG_DAY_R, FOG_DAY_G, FOG_DAY_B);
        fogAlbedo = vec3(FOG_DAY_RAIN_R, FOG_DAY_RAIN_G, FOG_DAY_RAIN_B);
        mediump float fogRain = FOG_DAY_RAIN_INTENSITY * FOG_RAIN_MULTIPLIER;
        fogIntensity = mix2(fogIntensity, fogRain, rainStrength);
        mediump float fogCurveRain = FOG_DAY_RAIN_CURVE;
        fogCurve = mix2(fogCurve, fogCurveRain, rainStrength);
        mediump float fogDHTransitionDry = far/DH_FOG_DAY_DIST_MAX;
        fogDHTransition = far/dhFarPlane;
        fogDistMin = FOG_DAY_DIST_MIN;
        fogDistMax = FOG_DAY_DIST_MAX;
        skyInfluenceColor = vec3(SKY_DAY_A_R, SKY_DAY_A_G, SKY_DAY_A_B);
    }
    timeBlendFactor = 0.0;
}

void sunsetFunc(float time, float timeFactor) {
    mediump float sunsetLerp = smoothstep(11750.0, 12250.0, float(worldTime) + fract(frameTimeCounter));
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
        mediump vec3 fogAlbedoDry = mix3(vec3(FOG_DAY_R, FOG_DAY_G, FOG_DAY_B), vec3(FOG_SUNSET_R, FOG_SUNSET_G, FOG_SUNSET_B), vec3(FOG_NIGHT_R, FOG_NIGHT_G, FOG_NIGHT_B), sunsetLerp, 0.5);
        vec3 fogAlbedoWet = mix3(vec3(FOG_DAY_RAIN_R, FOG_DAY_RAIN_G, FOG_DAY_RAIN_B), vec3(FOG_SUNSET_RAIN_R, FOG_SUNSET_RAIN_G, FOG_SUNSET_RAIN_B), vec3(FOG_NIGHT_RAIN_R, FOG_NIGHT_RAIN_G, FOG_NIGHT_RAIN_B), sunsetLerp, 0.5);
        fogAlbedo = mix2(fogAlbedoDry, fogAlbedoWet, rainStrength);
        mediump float fogRain = mix3(FOG_DAY_RAIN_INTENSITY, FOG_SUNSET_RAIN_INTENSITY, FOG_NIGHT_RAIN_INTENSITY, sunsetLerp, 0.5) * FOG_RAIN_MULTIPLIER;
        mediump float fogCurveRain = mix3(FOG_DAY_RAIN_CURVE, FOG_SUNSET_RAIN_CURVE, FOG_NIGHT_RAIN_CURVE, sunsetLerp, 0.5);
        fogIntensity = mix2(fogIntensity, fogRain, rainStrength);
        fogCurve = mix2(fogCurve, fogCurveRain, rainStrength);
        mediump float fogDHTransitionDry = far/mix3(DH_FOG_DAY_DIST_MAX, DH_FOG_SUNSET_DIST_MAX, DH_FOG_NIGHT_DIST_MAX, sunsetLerp, 0.5);
        mediump float fogDHTransitionWet = far/mix3(DH_FOG_DAY_RAIN_DIST_MAX, DH_FOG_SUNSET_RAIN_DIST_MAX, DH_FOG_NIGHT_RAIN_DIST_MAX, sunsetLerp, 0.5);
        fogDHTransition = far/dhFarPlane;
        fogDistMin = mix3(FOG_DAY_DIST_MIN, FOG_SUNSET_DIST_MIN, FOG_NIGHT_DIST_MIN, sunsetLerp, 0.5);
        fogDistMax = mix3(FOG_DAY_DIST_MAX, FOG_SUNSET_DIST_MAX, FOG_NIGHT_DIST_MAX, sunsetLerp, 0.5);
        skyInfluenceColor = mix3(vec3(SKY_DAY_A_R, SKY_DAY_A_G, SKY_DAY_A_B), vec3(SKY_SUNSET_A_R, SKY_SUNSET_A_G, SKY_SUNSET_A_B), vec3(SKY_NIGHT_A_R, SKY_NIGHT_A_G, SKY_NIGHT_A_B), sunsetLerp, 0.5);
    }
    timeBlendFactor = sunsetLerp;
}

void nightFunc(float time, float timeFactor) {
    mediump float dayNightLerp = smoothstep(12250.0, 23750.0, float(worldTime) + fract(frameTimeCounter));
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
        mediump vec3 fogAlbedoDry = vec3(FOG_NIGHT_R, FOG_NIGHT_G, FOG_NIGHT_B);
        fogAlbedo = vec3(FOG_NIGHT_RAIN_R, FOG_NIGHT_RAIN_G, FOG_NIGHT_RAIN_B);
        mediump float fogRain = FOG_NIGHT_RAIN_INTENSITY * FOG_RAIN_MULTIPLIER;
        fogIntensity = mix2(fogIntensity, fogRain, rainStrength);
        mediump float fogCurveRain = FOG_NIGHT_RAIN_CURVE;
        fogCurve = mix2(fogCurve, fogCurveRain, rainStrength);
        mediump float fogDHTransitionDry = far/DH_FOG_NIGHT_DIST_MAX;
        fogDHTransition = far/dhFarPlane;
        fogDistMin = FOG_NIGHT_DIST_MIN;
        fogDistMax = FOG_NIGHT_DIST_MAX;
        skyInfluenceColor = vec3(SKY_NIGHT_A_R, SKY_NIGHT_A_G, SKY_NIGHT_A_B);
    }
    timeBlendFactor = 1.0;
}

void dawnFunc(float time, float timeFactor) {
    mediump float sunsetLerp = smoothstep(23750.0, 24250.0, float(worldTime) + fract(frameTimeCounter));
    if(worldTime < 250) sunsetLerp = smoothstep(-250.0, 250.0, float(worldTime) + fract(frameTimeCounter));
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
        mediump vec3 fogAlbedoDry = mix3(vec3(FOG_NIGHT_R, FOG_NIGHT_G, FOG_NIGHT_B), vec3(FOG_SUNSET_R, FOG_SUNSET_G, FOG_SUNSET_B), vec3(FOG_DAY_R, FOG_DAY_G, FOG_DAY_B), sunsetLerp, 0.5);
        mediump vec3 fogAlbedoWet = mix3(vec3(FOG_NIGHT_RAIN_R, FOG_NIGHT_RAIN_G, FOG_NIGHT_RAIN_B), vec3(FOG_SUNSET_RAIN_R, FOG_SUNSET_RAIN_G, FOG_SUNSET_RAIN_B), vec3(FOG_DAY_RAIN_R, FOG_DAY_RAIN_G, FOG_DAY_RAIN_B), sunsetLerp, 0.5);
        fogAlbedo = mix2(fogAlbedoDry, fogAlbedoWet, rainStrength);
        mediump float fogRain = mix3(FOG_NIGHT_RAIN_INTENSITY, FOG_SUNSET_RAIN_INTENSITY, FOG_DAY_RAIN_INTENSITY, sunsetLerp, 0.5) * FOG_RAIN_MULTIPLIER;
        fogIntensity = mix2(fogIntensity, fogRain, rainStrength);
        mediump float fogCurveRain = mix3(FOG_NIGHT_RAIN_CURVE, FOG_SUNSET_RAIN_CURVE, FOG_DAY_RAIN_CURVE, sunsetLerp, 0.5);
        fogCurve = mix2(fogCurve, fogCurveRain, rainStrength);
        mediump float fogDHTransitionDry = far/mix3(DH_FOG_NIGHT_DIST_MAX, DH_FOG_SUNSET_DIST_MAX, DH_FOG_DAY_DIST_MAX, sunsetLerp, 0.5);
        mediump float fogDHTransitionWet = far/mix3(DH_FOG_NIGHT_RAIN_DIST_MAX, DH_FOG_SUNSET_RAIN_DIST_MAX, DH_FOG_DAY_RAIN_DIST_MAX, sunsetLerp, 0.5);
        fogDHTransition = far/dhFarPlane;
        fogDistMin = mix3(FOG_NIGHT_DIST_MIN, FOG_SUNSET_DIST_MIN, FOG_DAY_DIST_MIN, sunsetLerp, 0.5);
        fogDistMax = mix3(FOG_NIGHT_DIST_MAX, FOG_SUNSET_DIST_MAX, FOG_DAY_DIST_MAX, sunsetLerp, 0.5);
        skyInfluenceColor = mix3(vec3(SKY_NIGHT_A_R, SKY_NIGHT_A_G, SKY_NIGHT_A_B), vec3(SKY_SUNSET_A_R, SKY_SUNSET_A_G, SKY_SUNSET_A_B), vec3(SKY_DAY_A_R, SKY_DAY_A_G, SKY_DAY_A_B), sunsetLerp, 0.5);
    }
    timeBlendFactor = 1 - sunsetLerp;
}

mediump vec4 triplanarTexture(vec3 worldPos, vec3 normal, sampler2D tex, float scale) {
    normal = abs(normal);
    normal = normal / (normal.x + normal.y + normal.z + 0.0001);

    mediump vec2 uvXZ = worldPos.xz * scale;
    mediump vec2 uvXY = worldPos.xy * scale;
    mediump vec2 uvZY = worldPos.zy * scale;

    mediump vec4 texXZ = texture2D(tex,uvXZ) * normal.y;
    mediump vec4 texXY = texture2D(tex,uvXY) * normal.z;
    mediump vec4 texZY = texture2D(tex,uvZY) * normal.x;

    return texXZ + texXY + texZY;
}

mediump vec2 triplanarCoords(vec3 worldPos, vec3 normal, float scale) {
    normal = abs(normal);
    normal = normal / (normal.x + normal.y + normal.z + 0.0001);

    mediump vec2 uvXZ = worldPos.xz * scale;
    mediump vec2 uvXY = worldPos.xy * scale;
    mediump vec2 uvZY = worldPos.zy * scale;

    mediump vec2 texXZ = uvXZ * normal.y;
    mediump vec2 texXY = uvXY * normal.z;
    mediump vec2 texZY = uvZY * normal.x;

    return texXZ + texXY + texZY;
}

mediump vec3 rgbToHsv(vec3 c) {
    mediump float max = max(c.r, max(c.g, c.b));
    mediump float min = min(c.r, min(c.g, c.b));
    mediump float chroma = max - min;
    mediump float saturation = (max == 0.0) ? 0.0 : chroma / max;
    return vec3(saturation);
}

mediump float waterFresnel(vec3 normal, vec3 viewDir, float bias, float scale, float power) {
    mediump float cosTheta = clamp(dot(normalize2(normal), normalize2(viewDir)),0.0,1.0);

    return bias + scale * pow2(1.0 - cosTheta, power);
}

mediump vec3 waterFunction(vec2 coords, vec3 noise, float lightBrightness, out vec2 refractionUVs) {
    mediump float distanceFromCamera = distance(vec3(0), viewSpaceFragPosition);
    mediump float isRain = texture2D(colortex3, TexCoords).r;
    mediump vec2 refractionFactor = vec2(0);
    mediump vec2 TexCoords2 = coords;
    mediump float underwaterDepth = linearizeDepth(texture2D(depthtex0,coords).x,near,far);
    mediump float underwaterDepth2 = linearizeDepth(texture2D(depthtex1,coords).x,near,far);
    refractionUVs = vec2(0.0);
    #ifdef WATER_REFRACTION
        if(isRain == 1.0) {
            refractionUVs = calcRefraction(coords, distanceFromCamera*2f, noise.xz);
            TexCoords2 += refractionUVs;
            underwaterDepth = linearizeDepth(texture2D(depthtex0,coords).x,near,far);
            underwaterDepth2 = linearizeDepth(texture2D(depthtex1,coords).x,near,far);
        }
    #endif
    mediump vec3 waterColor = mix2(vec3(0.2f, 0.4f, 0.44f), vec3(0.0f, 0.2f, 0.22f), smoothstep(0,4,(underwaterDepth2 - underwaterDepth)));
    /*if(underwaterDepth >= 1.0) {
        //waterColor = vec3(0.0f, 0.2f, 0.22f);
        return pow2(clamp(mix2(texture2D(colortex0, TexCoords2).rgb,waterColor,1.85),vec3(0.0f, 0.0f, 0.0f),(texture2D(colortex0, TexCoords2).rgb/0.2 * 0.15) + (waterColor*0.85)), vec3(GAMMA));
    }*/

    mediump vec3 worldPos = screenToWorld(coords, clamp(texture2D(depthtex0,coords).x,0,1));
    mediump vec3 worldPos2 = screenToWorld(coords, clamp(texture2D(depthtex1,coords).x,0,1));
    mediump vec3 viewDir = normalize2(cameraPosition - worldPos);

    mediump vec3 sunDir = (gbufferModelViewInverse * vec4(sunPosition,1.0)).xyz;

    if(texture2D(depthtex0,TexCoords).x == 1.0) {
        underwaterDepth = getDepthMask(depthtex0, cSampler11)*dhFarPlane;
        underwaterDepth2 = getDepthMask(depthtex1, cSampler12)*dhFarPlane;
        //mediump vec3 waterColor = vec3(0.0f, 0.2f, 0.22f) * 0.8;
        mediump vec3 finalColor = mix2(texture2D(colortex0, TexCoords2).rgb,waterColor,1);
        mediump vec3 reflectionColor = vec3(1.0);
        float fresnelBlend = waterFresnel(noise.xyz, sunDir, 0.02, 0.1, 5.0);
        finalColor = mix2(finalColor, vec3(1.0), fresnelBlend);
        return pow2(finalColor, vec3(GAMMA));
    }
    mediump vec3 finalColor = mix2(texture2D(colortex0, TexCoords2).rgb,waterColor,smoothstep(0,1.5,(underwaterDepth2 - underwaterDepth)));

    mediump vec3 reflectionColor = vec3(1.0);
    float fresnelBlend = waterFresnel(noise.xyz, sunDir, 0.02, 0.1, 5.0);
    finalColor = mix2(finalColor, vec3(1.0), fresnelBlend);

    //finalColor = mix2(finalColor, vec3(1.0), smoothstep(0.95,1.0,dot((gbufferModelViewInverse * vec4(sunPosition,1.0)).xyz, noise.xyz * 2 - 1)));

    return pow2(finalColor, vec3(GAMMA));
}

bool isOutOfTexture(vec2 texcoord) {
    return (texcoord.x < 0.0 || texcoord.x > 1.0 || texcoord.y < 0.0 || texcoord.y > 1.0);
}

mediump vec3 getWorldPosition(vec2 texcoord, float depth) {
    mediump vec3 clipSpace = vec3(texcoord, depth) * 2.0 - 1.0;
    mediump vec4 viewW = gbufferProjectionInverse * vec4(clipSpace, 1.0);
    mediump vec3 viewSpace = viewW.xyz / viewW.w;
    mediump vec4 world = gbufferModelViewInverse * vec4(viewSpace, 1.0);

    return world.xyz;
}

mediump vec3 getViewPosition(vec2 texcoord, float depth) {
    mediump vec3 clipSpace = vec3(texcoord, depth) * 2.0 - 1.0;
    mediump vec4 viewW = gbufferProjectionInverse * vec4(clipSpace, 1.0);
    mediump vec3 viewSpace = viewW.xyz / viewW.w;

    return viewSpace;
}

mediump vec3 getUVFromPosition(vec3 position) {
    mediump vec4 projection = gbufferProjection * gbufferModelView * vec4(position, 1.0);
    projection.xyz /= projection.w;
    mediump vec3 clipSpace = projection.xyz * 0.5 + 0.5;

    return clipSpace.xyz;
}

mediump vec3 getUVFromViewPosition(vec3 position) {
    mediump vec4 projection = gbufferProjection * vec4(position, 1.0);
    projection.xyz /= projection.w;
    mediump vec3 clipSpace = projection.xyz * 0.5 + 0.5;

    return clipSpace.xyz;
}

mediump vec3 screenToView(vec2 uv, float depth) {
    mediump vec4 ndcPos = vec4(uv, depth, 1.0) * 2.0 - 1.0;
    mediump vec4 tmp = gbufferProjectionInverse * ndcPos;
    return tmp.xyz / tmp.w;
}


mediump vec2 ssrRay(vec3 startPosition, vec3 reflectionDir) {

    const int maxIter = 64;
    const float stepSize = 0.25;
    const float thickness = 0.2;

    float currLength = stepSize;

    for (int i = 0; i < maxIter; i++) {

        mediump vec3 currPos = startPosition + reflectionDir * currLength;
        mediump vec3 currUV = getUVFromPosition(currPos);

        // Exit if off-screen
        if (currUV.x < 0.0 || currUV.x > 1.0 ||
            currUV.y < 0.0 || currUV.y > 1.0)
            return vec2(-1.0);

        // Sample scene depth AT RAY UV
        float sceneDepth = texture2D(depthtex0, currUV.xy).r;

        // Reconstruct scene position
        mediump vec3 scenePos = getWorldPosition(currUV.xy, sceneDepth);

        // Compare in SAME SPACE
        float depthDiff = currPos.z - scenePos.z;

        if (depthDiff > -thickness && depthDiff < thickness) {
            if (sceneDepth < 1.0)
                return currUV.xy;
            else
                return vec2(-1.0);
        }

        currLength += stepSize;
    }

    return vec2(-2.0);
}


mediump vec4 waterReflections(vec3 color, vec2 uv, vec3 normal, vec3 noise) {
    mediump vec4 finalColor = vec4(color, 1.0);
    
    mediump float distanceFromCamera = distance(vec3(0), viewSpaceFragPosition);
    mediump float isRain = texture2D(colortex3, uv).r;
    if(isRain < 1.0) return finalColor;
    mediump float depth = getDepthMask(depthtex0, cSampler11);
    mediump vec3 position = screenToFoot(uv, texture2D(depthtex0, uv).r);
    mediump vec3 viewDir = normalize2(position);
    mediump vec3 reflectedDir = normalize2(reflect(viewDir, normal));

    mediump vec2 refractionFactor = vec2(0);
    #ifdef WATER_REFRACTION
        if(isRain == 1.0) {
            refractionFactor = sin(noise.y) * vec2(0.03125f) / max( distanceFromCamera*2f,1);
        }
    #endif
 
    mediump vec2 reflectionUV = ssrRay(viewDir, reflectedDir) + refractionFactor;
    if(reflectionUV.x > 0.0) {
        mediump vec3 reflectionColor = texture2D(colortex0, reflectionUV).rgb;
        finalColor = mix2(mix2(vec4(reflectionColor, 1.0), finalColor, 0.4), finalColor, 1 - uv.y*0.25);
    }

    if(texture2D(colortex5, reflectionUV).r > 0.0) finalColor.xyz = color;
    
    return finalColor;
}

mediump vec4 waterReflectionsDH(vec3 color, vec2 uv, vec3 normal, vec3 noise) {
    mediump vec4 finalColor = vec4(color, 1.0);
    
    mediump float distanceFromCamera = distance(vec3(0), viewSpaceFragPosition);
    mediump float isRain = texture2D(colortex3, uv).r;
    if(isRain < 1.0) return finalColor;
    mediump float depth = texture2D(colortex15, uv).g;
    mediump vec3 position = getWorldPosition(uv, depth);
    mediump vec3 viewDir = normalize2(position);
    mediump vec3 reflectedDir = normalize2(reflect(viewDir, normal));

    mediump vec2 refractionFactor = vec2(0);
    #ifdef WATER_REFRACTION
        if(isRain == 1.0) {
            refractionFactor = sin(noise.y) * vec2(0.03125f) / max( distanceFromCamera*2f,1);
        }
    #endif

    mediump vec2 reflectionUV = ssrRay(viewDir, reflectedDir) + refractionFactor;
    if(reflectionUV.x > 0.0) {
        mediump vec3 reflectionColor = texture2D(colortex0, reflectionUV).rgb;
        finalColor = mix2(mix2(vec4(reflectionColor, 1.0), finalColor, 0.4), finalColor, 1 - uv.y*0.25);
    }

    if(texture2D(colortex5, reflectionUV).r > 0.0) finalColor.xyz = color;
    
    return finalColor;
}

mediump vec4 metallicReflections(vec3 color, vec2 uv, vec3 normal) {
    mediump vec4 finalColor = vec4(color, 1.0);

    mediump float depth = getDepthMask(depthtex0, cSampler11);
    mediump vec3 position = getViewPosition(uv, depth);
    mediump vec3 viewDir = normalize2(position);
    mediump vec3 reflectedDir = normalize2(reflect(viewDir, normal));

    mediump vec2 reflectionUV = ssrRay(position, reflectedDir);
    if(reflectionUV.x > 0.0) {
        mediump vec3 reflectionColor = texture2D(colortex0, reflectionUV).rgb;
        finalColor = mix2(mix2(vec4(reflectionColor, 1.0), finalColor, 0.8), finalColor, 1 - uv.y);
    }
    
    return finalColor;
}

mediump float foamFactor(vec3 worldCoords, vec3 worldCoords2, float noise) {
    mediump float depth = linearizeDepth(texture2D(depthtex0,TexCoords).x, near, far);
    mediump float depth2 = linearizeDepth(texture2D(depthtex1,TexCoords).x, near, far);

    return 1 - smoothstep(0, 0.35, (depth2 - depth) + noise * 0.5);
}

mediump vec2 getUVsForLUT(vec3 color) {
    mediump vec2 texelSize = vec2(1.0 / 256.0, 1.0 / 16.0);
    mediump float tileX = mod(color.b, 16.0);
    mediump float tileY = floor(color.b/16.0);
    mediump vec2 uv = vec2(
        (color.r + tileX * 16.0 + 0.5) * texelSize.x,
        (color.g + tileY * 16.0 + 0.5) * texelSize.y
    );

    return uv;
}

mediump vec3 loadLUT(vec3 color, sampler2D lut) {
    color = pow2(color, vec3(1/2.2));
    color = clamp(color, vec3(0.0), vec3(1.0));

    mediump vec3 scaled = color * 15.0;
    mediump vec3 index = floor(scaled);
    mediump vec3 frac = scaled - index;

    mediump vec3 c000 = texture2D(lut, getUVsForLUT(index)).rgb;
    mediump vec3 c100 = texture2D(lut, getUVsForLUT(index + vec3(1.0, 0.0, 0.0))).rgb;
    mediump vec3 c010 = texture2D(lut, getUVsForLUT(index + vec3(0.0, 1.0, 0.0))).rgb;
    mediump vec3 c110 = texture2D(lut, getUVsForLUT(index + vec3(1.0, 1.0, 0.0))).rgb;
    mediump vec3 c001 = texture2D(lut, getUVsForLUT(index + vec3(0.0, 0.0, 1.0))).rgb;
    mediump vec3 c101 = texture2D(lut, getUVsForLUT(index + vec3(1.0, 0.0, 1.0))).rgb;
    mediump vec3 c011 = texture2D(lut, getUVsForLUT(index + vec3(0.0, 1.0, 1.0))).rgb;
    mediump vec3 c111 = texture2D(lut, getUVsForLUT(index + vec3(1.0, 1.0, 1.0))).rgb;

    mediump vec3 c00 = mix2(c000, c100, frac.r);
    mediump vec3 c01 = mix2(c001, c101, frac.r);
    mediump vec3 c10 = mix2(c010, c110, frac.r);
    mediump vec3 c11 = mix2(c011, c111, frac.r);

    mediump vec3 c0 = mix2(c00, c10, frac.g);
    mediump vec3 c1 = mix2(c01, c11, frac.g);

    mediump vec3 result = mix2(c0, c1, frac.b);

    result = pow2(result, vec3(2.2));
    return clamp(result, vec3(0.0), vec3(1.0));
}

mediump vec3 BrightnessContrast(vec3 color, float brt, float sat, float con)
{
	// Increase or decrease theese values to adjust r, g and b color channels seperately
	const float AvgLumR = 0.5;
	const float AvgLumG = 0.5;
	const float AvgLumB = 0.5;
	
	const vec3 LumCoeff = vec3(0.2125, 0.7154, 0.0721);
	
	mediump vec3 AvgLumin  = vec3(AvgLumR, AvgLumG, AvgLumB);
	mediump vec3 brtColor  = color * brt;
	mediump vec3 intensity = vec3(dot(brtColor, LumCoeff));
	mediump vec3 satColor  = mix(intensity, brtColor, sat);
	mediump vec3 conColor  = mix(AvgLumin, satColor, con);
	
	return conColor;
}

mediump vec3 sharpenMask(sampler2D tex, vec2 UVs, vec3 color, float factor, float blendAmount) {
    mediump vec2 uv2 = (UVs*vec2(viewWidth, viewHeight) + vec2(0,1))/vec2(viewWidth, viewHeight);
    mediump vec3 up = texture2D(tex, uv2).rgb;
    
    uv2 = (UVs*vec2(viewWidth, viewHeight) + vec2(-1,0))/vec2(viewWidth, viewHeight);
    mediump vec3 left = texture2D(tex, uv2).rgb;

    uv2 = (UVs*vec2(viewWidth, viewHeight) + vec2(1,0))/vec2(viewWidth, viewHeight);
    mediump vec3 right = texture2D(tex, uv2).rgb;

    uv2 = (UVs*vec2(viewWidth, viewHeight) + vec2(0,-1))/vec2(viewWidth, viewHeight);
    mediump vec3 down = texture2D(tex, uv2).rgb;

    mediump vec3 sharpenedTexture = (1.0 + 4.0*factor)*color - factor*(up + left + right + down);

    return mix(color, sharpenedTexture, blendAmount);
}

#if AA == 2
    #include "lib/antialiasing/smaa.glsl"
#elif AA == 3
    #include "lib/antialiasing/taa.glsl"
#endif

mediump vec3 antialiasing(vec2 UVs, sampler2D tex) {
    mediump vec3 finalColor = texture2D(tex, UVs).rgb;
    #if AA == 3
        finalColor = applyTAA(UVs, tex);
    #elif AA == 2
        mediump float edge = edgeFactor(UVs, tex);
        mediump float blendStrength = computeBlendStrength(UVs);

        mediump vec3 blended = blendSMAA(UVs, tex);
        mediump vec3 original = texture2D(tex, UVs).rgb;
        mediump vec3 aaColor = mix2(original, blended, blendStrength);
        finalColor = mix2(aaColor, original, step(edge, 0.0));
    #elif AA == 1
        mediump float u  =  floor(UVs.x * viewWidth) / viewWidth;
        mediump float v  = (floor(UVs.y * viewHeight) / viewHeight);

        mediump vec3 left = texture2D(tex, vec2(u, v)).rgb;

        u  =  ceil(UVs.x* viewWidth) / viewWidth;
        v  = (ceil(UVs.y * viewHeight) / viewHeight);

        mediump vec3 right = texture2D(tex, vec2(u, v)).rgb;

        mediump vec3 color = texture2D(tex, UVs).rgb;

        color.r = mix2(left.r, right.r, clamp(fract(color.r),0,1));
        color.g = mix2(left.g, right.g, clamp(fract(color.g),0,1));
        color.b = mix2(left.b, right.b, clamp(fract(color.b),0,1));

        color = clamp(color, vec3(0.0), vec3(1.0));

        finalColor = sharpenMask(tex, UVs, color, BAA_SHARPEN_AMOUNT, BAA_SHARPEN_BLEND);
    #endif

    return finalColor;
}

#include "lib/world/fog.glsl"

#include "lib/post/blindness.glsl"

#include "lib/world/timeCycle.glsl"

#include "lib/lighting/lighting.glsl"

/* RENDERTARGETS:0 */

void main() {
    #if DEBUG == 1
        #if DEBUG_MODE == 0
            gl_FragData[0] = texture2D(colortex0, TexCoords);
        #elif DEBUG_MODE == 1
            gl_FragData[0] = abs(texture2D(colortex1, TexCoords) * 2 - 1);
        #elif DEBUG_MODE == 2
            gl_FragData[0] = texture2D(colortex2, TexCoords);
        #elif DEBUG_MODE == 3
            gl_FragData[0] = texture2D(colortex3, TexCoords);
        #elif DEBUG_MODE == 4
            gl_FragData[0] = texture2D(colortex4, TexCoords);
        #elif DEBUG_MODE == 5
            gl_FragData[0] = texture2D(colortex5, TexCoords);
        #elif DEBUG_MODE == 6
            gl_FragData[0] = vec4(getDepthMask(colortex13, cSampler11));
        #elif DEBUG_MODE == 7
            gl_FragData[0] = vec4(getDistMask(colortex6)/dhFarPlane);
        #elif DEBUG_MODE == 8
            gl_FragData[0] = vec4(linearizeDepth(texture2D(depthtex1, TexCoords).x,near,far) - linearizeDepth(texture2D(depthtex0, TexCoords).x,near,far));
        #endif
        return;
    #endif
    #if LIGHTING_MODE > 0 && defined BLOOM
        mediump float aspect = float(viewWidth)/float(viewHeight);
        mediump float waterTest = texture2D(colortex5, TexCoords).r;
        mediump float dhTest = texture2D(colortex5, TexCoords).g;

        mediump vec2 TexCoords2 = TexCoords;

        mediump float Depth = texture2D(depthtex0, TexCoords).r;
        mediump float Depth2 = texture2D(depthtex1, TexCoords).r;

        mediump vec3 worldTexCoords = screenToWorld(TexCoords, clamp(Depth,0.0,1.0));
        mediump vec3 worldTexCoords2 = screenToWorld(TexCoords, clamp(Depth2,0.0,1.0));

        mediump vec3 clipCoords = vec3(TexCoords * 2 - 1, Depth);
        mediump vec4 viewCoords = gbufferProjectionInverse * vec4(clipCoords, 1.0);
        viewCoords /= viewCoords.w;
        mediump vec4 footCoords = gbufferModelViewInverse * viewCoords;
        footCoords /= footCoords.w;
        mediump vec3 worldCoords = footCoords.xyz + cameraPosition;

        mediump float underwaterDepth = texture2D(depthtex0, TexCoords).r;
        mediump float underwaterDepth2 = texture2D(depthtex1, TexCoords).r;
        
        mediump vec3 Albedo;

        mediump float albedoAlpha;

        mediump float distanceFromCamera = distance(vec3(0), viewSpaceFragPosition);

        float planeTransition = far/dhFarPlane;

        mediump vec3 Normal = normalize2(texture2D(colortex1, TexCoords).rgb * 2.0f -1.0f);

        mediump vec4 noiseMap3 = texture2D(water, fract(TexCoords - sin(TexCoords.y*64f + ((frameCounter)/90f)) * 0.005f));

        mediump vec3 shadowLightDirection = normalize2(mat3(gbufferModelViewInverse) * shadowLightPosition);

        mediump float lightBrightness = clamp(dot(shadowLightDirection, Normal),0.2,1.0);

        #if AA > 0
            Albedo = antialiasing(TexCoords, colortex0);
        #else
            Albedo = texture2D(colortex0, TexCoords).rgb;
        #endif

        mediump vec2 refractionFactor = vec2(0);

        mediump float isRain = texture2D(colortex3, TexCoords).r;

        mediump float timeDistance = abs(worldTime - 6000);
        mediump float maxTimeDistance = 6000.0;
        //mediump float timeBlendFactor = smoothstep(0.75,1.0,clamp(timeDistance/maxTimeDistance, 0, 1));

        mediump vec2 refractionUVs = TexCoords;

        if(waterTest > 0) {
            if(Depth2 - Depth > 0f)
            {
                if(Depth >= 1.0) {
                    Albedo = pow2(waterFunction(TexCoords, Normal, lightBrightness, refractionUVs),vec3(1/GAMMA));
                    albedoAlpha = 0.0;
                } else {
                    Albedo = waterFunction(TexCoords, Normal, lightBrightness, refractionUVs);
                    albedoAlpha = 0.0;
                }
                
                mediump vec3 reflectionDir = reflect(-shadowLightDirection, Normal);

                mediump vec3 fragFeetPlayerSpace = vec3(gbufferModelViewInverse * vec4(viewSpaceFragPosition, 1.0));

                mediump vec3 fragWorldSpace = fragFeetPlayerSpace + cameraPosition;

                mediump vec3 viewDirection = normalize2(cameraPosition - viewSpaceFragPosition);

                mediump float specularStrength = 0.5;

                mediump float ambientLight = 0.0;
            } else {
                underwaterDepth = getDepthMask(depthtex0, cSampler11);
                underwaterDepth2 = getDepthMask(depthtex0, cSampler11);
                Albedo = pow2(mix2(Albedo,vec3(0.0f,0.33f,0.55f),clamp((0.5 - (underwaterDepth2 - underwaterDepth)) * 0.5,0,1)), vec3(GAMMA));

                TexCoords2 = TexCoords;
            }
            #ifdef WATER_FOAM
                mediump vec3 foamColor = vec3(1.0);
                #ifdef BLOOM
                    mediump vec3 lightColor = bloom(waterTest, worldTexCoords.xy/vec2(500f) + refractionFactor, Normal, vec4(Albedo,albedoAlpha),refractionUVs).xyz;
                    //foamColor *= clamp(dot((gbufferModelViewInverse * vec4(sunPosition,1.0)).xyz, Normal), MIN_LIGHT, MAX_LIGHT);
                    //foamColor = mix(foamColor, lightColor, clamp(length(lightColor), 0.0, 0.5));
                #endif
                mediump vec3 foamWater = mix2(Albedo.xyz, foamColor, foamFactor(worldTexCoords, worldTexCoords2, Normal.x));
                
                Albedo = mix2(Albedo, foamWater, 1 - step(isRain, 0.9));
            #endif
            
            #if SSR == 1 || SSR == 2
                if(isRain == 1.0) {
                    mediump vec4 Albedo4 = waterReflections(Albedo.xyz,TexCoords,Normal, Normal);
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
        }

        #if SSR == 1 || SSR == 3
            mediump float isReflective = texture2D(colortex5, TexCoords).b;

            if(isReflective > 0.0 && Depth < 1.0) {
                Albedo = metallicReflections(Albedo,TexCoords,Normal).xyz;
            }
        #endif

        mediump vec3 currentColor = dayColor;

        Diffuse = Albedo;

        mediump vec3 baseColor = currentColor;
        mediump vec3 baseDiffuse = Diffuse;

        mediump vec3 baseDiffuseModifier;

        mediump vec3 currentFogColor = vec3(FOG_DAY_R,FOG_DAY_G,FOG_DAY_B);

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

        mediump vec3 lightColorDay = vec3(NATURAL_LIGHT_DAY_R, NATURAL_LIGHT_DAY_G, NATURAL_LIGHT_DAY_B) * NATURAL_LIGHT_DAY_I;
        mediump vec3 lightColorNight = vec3(NATURAL_LIGHT_NIGHT_R, NATURAL_LIGHT_NIGHT_G, NATURAL_LIGHT_NIGHT_B) * NATURAL_LIGHT_NIGHT_I;
        
        float timeNorm = mod(worldTime,24000.0) / 24000.0;

        float weightDay = 0.5 + 0.5 * cos((timeNorm - 0.25) * 2.0 * PI);
        float weightNight = 0.5 + 0.5 * cos((timeNorm - 0.75) * 2.0 * PI);
        mediump vec3 currentLightColor = (weightDay * lightColorDay) + (weightNight * lightColorNight);

        timeFunctionFrag();
        if(isBiomeEnd) {
            if(dhTest <= 0) {
                currentColor = vec3(0.3f);
            } else {
                currentColor = seColor;
            }
        }

        mediump float occlusion = step(1.0, Depth2);

        mediump float brightnessMask = 0.0;

        mediump float minLight = MIN_LIGHT;
        mediump float seMinLight = SE_MIN_LIGHT;

        mediump float maxLight = MAX_LIGHT;
        mediump float seMaxLight = SE_MAX_LIGHT;
        
        mediump vec4 LightmapColor;
        mediump float lightBrightness2 = 0;

        mediump float globalDepthMask = getDepthMask(depthtex0, colortex13) * dhFarPlane;

        mediump float globalDepthMask2 = getDepthMask(depthtex1, colortex13) * dhFarPlane;

        vec3 viewPos = ScreenToView(vec3(TexCoords, Depth2));

        mediump float desatAmount = smoothstep(64, 10240, globalDepthMask) * 0.1;

        mediump float isCave = smoothstep(0.0, 0.9, 1 - texture2D(colortex13, TexCoords).g);

        #ifdef BLOOM
            mediump vec4 bloomAmount = bloom(waterTest, worldTexCoords.xy/vec2(500f) + refractionFactor, Normal, vec4(Albedo,albedoAlpha),refractionUVs);
            LightmapColor = bloomAmount;
            lightBrightness2 = bloomAmount.a;
        #else
            LightmapColor = texture2D(colortex2, TexCoords.xy).rgba;
        #endif

        float distFactor = getDistMask(colortex6) * 32;

        mediump vec3 shadowLerp = 1 - (1 - texture2D(colortex14, TexCoords).xyz);

        if(Depth2 == 1.0f && texture2D(colortex10, TexCoords).x == 0.0){
            mediump float detectSky = texture2D(colortex5, TexCoords).g;
            mediump float detectEntity = texture2D(colortex12, TexCoords).g;
            if(detectSky < 1.0) {
                if(isBiomeEnd) {
                    Diffuse = pow2(texture2D(colortex0, TexCoords.xy).rgb,vec3(GAMMA));

                    if(waterTest > 0) {
                        Albedo = waterFunction(TexCoords, Normal, lightBrightness,refractionUVs);
                        Diffuse.xyz = Albedo;
                        #ifdef WATER_WAVES
                            Diffuse.xyz = mix3(Diffuse.xyz * 0.5, Diffuse.xyz, Diffuse.xyz * 0.75 + vec3(0.25), 0.3,cubicBezier(texture2D(colortex15,TexCoords).b, vec2(0.9, 0.0), vec2(1.0, 1.0)));
                        #endif
                    }

                    mediump float seMinLight = SE_MIN_LIGHT;

                    LightmapColor.xyz = mix2(LightmapColor.xyz, max(vec3(0.5), normalize2(LightmapColor.xyz)) * vec3(seMinLight), 1 - step(seMinLight * seMinLight, dot(LightmapColor.xyz, LightmapColor.xyz)));

                    mediump vec3 worldSpaceSunPos = (gbufferModelViewInverse * vec4(sunPosition,1.0)).xyz;
                    mediump float NdotL = max(dot(Normal, normalize2(worldSpaceSunPos)), 0.2f);

                    LightmapColor.xyz *= vec3(3.5025);

                    mediump vec3 rawLight = LightmapColor.xyz;

                    vec3 Diffuse3 = calcLighting(Diffuse.xyz, LightmapColor, 1, MIN_LIGHT, MAX_LIGHT, foot_pos, shadowLerp, timeBlendFactor);
                    
                    Diffuse3 = desaturate(Diffuse3, desatAmount);

                    #ifdef AUTO_EXPOSURE
                        Diffuse3.xyz = mix2(Diffuse3.xyz, calcHDR(Diffuse3.xyz, SE_EXP, 5.0, 16, 8), SE_EXP_BLEND);
                    #endif

                    Diffuse.xyz = calcTonemap(Diffuse3.xyz);

                    Diffuse.xyz = mix2(Diffuse.xyz * lightBrightness,Diffuse.xyz,dot(Diffuse.xyz, vec3(0.333)));

                    #if FOG_STYLE > 0
                        fogAlbedo = mix2(fogAlbedo, vec3(FOG_CAVE_R, FOG_CAVE_G, FOG_CAVE_B), isCave);
                        fogDistMin = mix2(fogDistMin, FOG_CAVE_DIST_MIN,isCave);
                        fogDistMax = mix2(fogDistMax, FOG_CAVE_DIST_MAX,isCave);
                        fogCurve = mix2(fogCurve, FOG_CAVE_CURVE,isCave);
                        fogIntensity = mix2(fogIntensity, FOG_CAVE_INTENSITY,isCave);
                        mediump float fogFactor = clamp(pow2(smoothstep(fogDistMin, fogDistMax,distFactor),fogCurve),0,min(fogIntensity,1.0));
                        Diffuse.xyz = calcFogColor(viewPos, sunPosition, Diffuse.xyz, fogAlbedo, vec3(VL_COLOR_R, VL_COLOR_G, VL_COLOR_B), fogFactor);
                    #endif
                    Diffuse.xyz = calcFogColor(viewPos, sunPosition, Diffuse.xyz, fogAlbedo, vec3(VL_COLOR_R, VL_COLOR_G, VL_COLOR_B), fogFactor);
                } else {
                    mediump float minLight = MIN_LIGHT;

                    mediump vec3 worldSpaceSunPos = (gbufferModelViewInverse * vec4(sunPosition,1.0)).xyz;
                    mediump float NdotL = max(dot(Normal, normalize2(worldSpaceSunPos)), 0.2f);

                    Diffuse = pow2(texture2D(colortex0, TexCoords.xy).rgb,vec3(GAMMA));
                    if(waterTest > 0) {
                        Albedo = waterFunction(TexCoords, Normal, lightBrightness, refractionUVs);
                        Albedo += pow2(texture2D(colortex2, TexCoords).xyz,vec3(GAMMA));
                        Albedo = blindEffect(Albedo, TexCoords);
                        #ifdef AUTO_EXPOSURE
                            if(isBiomeEnd) Albedo.xyz = mix2(Albedo.xyz, calcHDR(Albedo.xyz, SE_EXP, 5.0, 16, 8), SE_EXP_BLEND); else Albedo.xyz = mix2(Albedo.xyz, calcHDR(Albedo.xyz, NORM_EXP, 5.0, 16, 8), NORM_EXP_BLEND);
                        #endif
                        Albedo = calcTonemap(Albedo);
                        gl_FragData[0] = vec4(pow2(Albedo,vec3(0.75)), 1.0);
                        return;
                    } else {
                        mediump vec3 sunDir = normalize2(mat3(gbufferModelViewInverse) * sunPosition);

                        mediump vec3 Diffuse3 = calcLighting(Diffuse.xyz, LightmapColor, 1, MIN_LIGHT, MAX_LIGHT, foot_pos, shadowLerp, timeBlendFactor);
                        //Diffuse3 *= mix2(skyInfluenceColor, vec3(1.0), clamp(1 - dot(sunDir, Normal),0,1));

                        Diffuse3 = desaturate(Diffuse3, desatAmount);
                        
                        #ifdef AUTO_EXPOSURE
                            Diffuse3.xyz = mix2(Diffuse3.xyz, calcHDR(Diffuse3.xyz, NORM_EXP, 5.0, 16, 8), NORM_EXP_BLEND);
                        #endif

                        Diffuse.xyz = calcTonemap(Diffuse3.xyz);

                        #if FOG_STYLE > 0
                            fogAlbedo = mix2(fogAlbedo, vec3(FOG_CAVE_R, FOG_CAVE_G, FOG_CAVE_B), isCave);
                            fogDistMin = mix2(fogDistMin, FOG_CAVE_DIST_MIN,isCave);
                            fogDistMax = mix2(fogDistMax, FOG_CAVE_DIST_MAX,isCave);
                            fogCurve = mix2(fogCurve, FOG_CAVE_CURVE,isCave);
                            fogIntensity = mix2(fogIntensity, FOG_CAVE_INTENSITY,isCave);
                            mediump float fogFactor = clamp(pow2(smoothstep(fogDistMin, fogDistMax,distFactor),fogCurve),0,min(fogIntensity,1.0));
                            Diffuse.xyz = calcFogColor(viewPos, sunPosition, Diffuse.xyz, fogAlbedo, vec3(VL_COLOR_R, VL_COLOR_G, VL_COLOR_B), fogFactor);
                        #endif
                        Diffuse.xyz = calcFogColor(viewPos, sunPosition, Diffuse.xyz, fogAlbedo, vec3(VL_COLOR_R, VL_COLOR_G, VL_COLOR_B), fogFactor);
                    }
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
                LightmapColor = texture2D(colortex2, TexCoords.xy).rgba;
                #ifdef BLOOM
                    Albedo.xyz = mix2(Albedo.xyz, LightmapColor.xyz, clamp(length(LightmapColor.xyz), 0.0, 1.0));
                #endif
                #ifdef AUTO_EXPOSURE
                    //if(isBiomeEnd) Albedo.xyz = autoExposure(Albedo.xyz, 1.2, 5.0);
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
        if(waterTest > 0) {
            Albedo += pow2(texture2D(colortex2, TexCoords).xyz,vec3(GAMMA));
            Albedo = blindEffect(Albedo, TexCoords);
            mediump vec3 worldPos = screenToFoot(TexCoords,texture2D(depthtex0, TexCoords).x);
            mediump vec3 dirFromSun = normalize2(abs((gbufferModelViewInverse * vec4(sunPosition, 1.0)).xyz - 3.5) - abs(worldPos - 3.5));
            
            mediump float sunDist = smoothstep(0.2, 0.5, dirFromSun.b);
            //Albedo = mix2(Albedo, vec3(VL_COLOR_R, VL_COLOR_G, VL_COLOR_B) * 0.1,clamp(sunDist, 0, 1));
            #ifdef AUTO_EXPOSURE
                if(isBiomeEnd) Albedo.xyz = mix2(Albedo.xyz, calcHDR(Albedo.xyz, SE_EXP, 5.0, 16, 8), SE_EXP_BLEND); else Albedo.xyz = mix2(Albedo.xyz, calcHDR(Albedo.xyz, NORM_EXP, 5.0, 16, 8), NORM_EXP_BLEND);
            #endif
            Albedo = calcTonemap(Albedo);
            #if VIBRANT_MODE >= 1
                if(isBiomeEnd) {
                    #if VIBRANT_MODE == 1 || VIBRANT_MODE == 2
                        Albedo.xyz = loadLUT(Albedo.xyz, lutse);
                    #endif
                } else {
                    #if VIBRANT_MODE == 1 || VIBRANT_MODE == 3
                        Albedo.xyz = loadLUT(Albedo.xyz, lutnormal);
                    #endif
                }
            #endif
            gl_FragData[0] = vec4(pow2(Albedo, vec3(1.0/GAMMA)),1.0);
            return;
        }
        mediump vec3 LightmapColor2 = texture2D(colortex7,TexCoords2).rgb + lightBrightness;

        if(isBiomeEnd) {
            LightmapColor.xyz = mix2(LightmapColor.xyz, max(vec3(0.5), normalize2(LightmapColor.xyz)) * vec3(seMinLight), 1 - step(seMinLight * seMinLight, dot(LightmapColor.xyz, LightmapColor.xyz)));
        } else {
            LightmapColor.xyz = mix2(LightmapColor.xyz, normalize2(LightmapColor.xyz) * vec3(minLight), 1 - step(minLight * minLight,dot(LightmapColor.xyz, LightmapColor.xyz)));
        }

        mediump vec3 worldSpaceSunPos = (gbufferModelViewInverse * vec4(sunPosition,1.0)).xyz;
        mediump float NdotL = max(dot(Normal, normalize2(worldSpaceSunPos)), 0.0f);

        mediump float isParticle = texture2D(colortex6, TexCoords).r;

        if(waterTest > 0) {
            shadowLerp = vec3(1.0);
        }
        shadowLerp = mix2(shadowLerp, vec3(0.0), rainStrength);

        if(isBiomeEnd) {
            if(seMaxLight < 4.1f) {
                mediump float lightMagnitude = length(LightmapColor.xyz);
                lightMagnitude = clamp(lightMagnitude, SE_MIN_LIGHT, seMaxLight);
                LightmapColor.xyz = clamp(LightmapColor.xyz, vec3(0.0),normalize2(LightmapColor.xyz) * lightMagnitude);
            }
            LightmapColor.xyz *= vec3(2.5025) * smoothstep(0.0, 0.1, LightmapColor.xyz);
            mediump vec3 Diffuse3 = calcLighting(Albedo, LightmapColor, 0, SE_MIN_LIGHT, SE_MAX_LIGHT, foot_pos, shadowLerp, timeBlendFactor) * 0.125;
            
            Diffuse3 = desaturate(Diffuse3, desatAmount);

            #ifdef AUTO_EXPOSURE
                Diffuse3.xyz = mix2(Diffuse3.xyz, calcHDR(Diffuse3.xyz, SE_EXP, 5.0, 16, 8), SE_EXP_BLEND);
            #endif
            Diffuse3 = calcTonemap(Diffuse3);

            Diffuse.xyz = Diffuse3;
        } else {
            mediump vec3 rawLight = LightmapColor.xyz;
            if(maxLight < 4.1f) {
                mediump float lightMagnitude = length(LightmapColor.xyz);
                lightMagnitude = clamp(lightMagnitude, MIN_LIGHT, maxLight);
                LightmapColor.xyz = clamp(LightmapColor.xyz, vec3(0.0),normalize2(LightmapColor.xyz) * lightMagnitude);
            }
            LightmapColor.xyz = max(currentLightColor,LightmapColor.xyz * lightBrightness2 * 8)/128;

            mediump vec3 Diffuse3 = calcLighting(Albedo, LightmapColor, 0, MIN_LIGHT, MAX_LIGHT, foot_pos, shadowLerp, timeBlendFactor);

            Diffuse3 = desaturate(Diffuse3, desatAmount);

            #ifdef AUTO_EXPOSURE
                Diffuse3.xyz = mix2(Diffuse3.xyz, calcHDR(Diffuse3.xyz, NORM_EXP, 5.0, 16, 8), NORM_EXP_BLEND);
            #endif
            Diffuse3 = calcTonemap(Diffuse3);

            Diffuse.xyz = Diffuse3;
        }

        Diffuse.xyz = mix2(Diffuse.xyz * lightBrightness,Diffuse.xyz,dot(LightmapColor.xyz, vec3(0.333)));

        #if FOG_STYLE > 0
            fogAlbedo = mix2(fogAlbedo, vec3(FOG_CAVE_R, FOG_CAVE_G, FOG_CAVE_B), isCave);
            fogDistMin = mix2(fogDistMin, FOG_CAVE_DIST_MIN,isCave);
            fogDistMax = mix2(fogDistMax, FOG_CAVE_DIST_MAX,isCave);
            fogCurve = mix2(fogCurve, FOG_CAVE_CURVE,isCave);
            fogIntensity = mix2(fogIntensity, FOG_CAVE_INTENSITY,isCave);
            mediump float fogFactor = clamp(pow2(smoothstep(fogDistMin, fogDistMax,distFactor),fogCurve),0,min(fogIntensity,1.0));
            Diffuse.xyz = calcFogColor(viewPos, sunPosition, Diffuse.xyz, fogAlbedo, vec3(VL_COLOR_R, VL_COLOR_G, VL_COLOR_B), fogFactor);
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

        //Calculate Vignette
        #ifdef VIGNETTE
            mediump float vignetteAlpha = clamp(pow2(distance(TexCoords, vec2(0.5)),2.2),0,1);
            mediump vec3 vignetteColor = vec3(0.0);
            Diffuse.xyz = mix2(Diffuse.xyz, vignetteColor, vignetteAlpha);
        #endif

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