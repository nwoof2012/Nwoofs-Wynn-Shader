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

#define BLOOM

#define BLOOM_QUALITY 48 // [4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64]
#define BLOOM_INTENSITY 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
//#define BLOOM_THRESHOLD 0.7f // [0.0f 0.1f 0.2f 0.3f 0.4f 0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f 1.6f 1.7f 1.8f 1.9f 2.0f]

#define MIN_LIGHT 0.05f // [0.0f 0.05f 0.1f 0.15f 0.2f 0.25f 0.3f 0.35f 0.4f 0.45f 0.5f]

#define SE_MIN_LIGHT 0.05f // [0.0f 0.05f 0.1f 0.15f 0.2f 0.25f 0.3f 0.35f 0.4f 0.45f 0.5f]

#define MAX_LIGHT 1.5f // [1.0f 1.1f 1.2f 1.3f 1.4f 1.5f 1.6f 1.7f 1.8f 1.9f 2.0f 2.1f 2.2f 2.3f 2.4f 2.5f 2.6f 2.7f 2.8f 2.9f 3.0f 3.1f 3.2f 3.3f 3.4f 3.5f 3.6f 3.7f 3.8f 3.9f 4.0f 4.1f]

#define WATER_REFRACTION
#define WATER_FOAM

#define FRAGMENT_SHADER

#define PATH_TRACING 0 // [0 1]

varying vec2 TexCoords;

uniform vec3 sunPosition;

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D colortex3;
uniform sampler2D colortex4;
uniform sampler2D colortex5;
uniform sampler2D colortex6;
uniform sampler2D colortex7;

uniform sampler2D depthtex0;
uniform sampler2D depthtex1;

uniform sampler2D shadowtex0;

uniform sampler2D shadowtex1;
uniform sampler2D shadowcolor0;

uniform mat4 shadowProjectionInverse;
uniform mat4 shadowModelViewInverse;

uniform sampler2D noisetex;

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferProjection;

uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferModelView;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;

uniform int worldTime;
uniform int frameCounter;
uniform float frameTime;

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

const float sunPathRotation = -40.0f;

const float Ambient = 0.1f;

const int shadowMapResolution = SHADOW_RES;

const ivec3 voxelVolumeSize = ivec3(1,0.5, 1);
float effectiveACLdistance = min(1, SHADOW_DIST * 2.0);

uniform float maxBlindnessDarkness;

const int ShadowSamplesPerSize = 2 * SHADOW_SAMPLES + 1;
const int TotalSamples = ShadowSamplesPerSize * ShadowSamplesPerSize;
varying vec2 LightmapCoords;

uniform bool isBiomeEnd;

in vec3 vaPosition;

in vec3 viewSpaceFragPosition;

in vec3 vNormal;
in vec3 vViewDir;

in vec3 at_tangent;

#include "distort.glsl"
#include "lib/commonFunctions.glsl"
#include "lib/spaceConversion.glsl"
#include "program/underwater.glsl"
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

in vec3 lightmap;

uniform vec3 shadowLightPosition;

uniform float screenBrightness;

float AdjustLightmapTorch(in float torch) {
    const float K = 2.0f;
    const float P = 5.06f;
    return K * pow(torch, P);
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

vec3 translucentMult;

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

float Visibility(in sampler2D ShadowMap, in vec3 SampleCoords) {
    return step(SampleCoords.z - 0.001f, texture2D(ShadowMap, SampleCoords.xy).r);
}

vec3 TransparentShadow(in vec3 SampleCoords){
    float ShadowVisibility0 = Visibility(shadowtex0, SampleCoords);
    float ShadowVisibility1 = Visibility(shadowtex1, SampleCoords);
    vec4 ShadowColor0 = texture2D(shadowcolor0, SampleCoords.xy);
    vec3 TransmittedColor = ShadowColor0.rgb * (1.0f - ShadowColor0.a);
    return mix(TransmittedColor * ShadowVisibility1, vec3(1.0f), ShadowVisibility0);
}

vec3 GetShadow(float depth) {
    vec3 ClipSpace = vec3(TexCoords, depth) * 2.0f - 1.0f;
    vec4 ViewW = gbufferProjectionInverse * vec4(ClipSpace, 1.0f);
    vec3 View = ViewW.xyz / ViewW.w;
    vec4 World = gbufferModelViewInverse * vec4(View, 1.0f);
    vec4 ShadowSpace = shadowProjection * shadowModelView * World;
    ShadowSpace.xy = DistortPosition(ShadowSpace.xy);
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
}

vec3 SceneToVoxel(vec3 scenePos) {
	return scenePos + fract(cameraPosition) + (0.5 * vec3(voxelVolumeSize));
}

vec3 aces(vec3 x) {
  float a = 2.51;
  float b = 0.03;
  float c = 2.43;
  float d = 0.59;
  float e = 0.14;
  return clamp((x * (a * x + b)) / (x * (c * x + d) + e), 0.0, 1.0);
}

vec3 lottes(vec3 x) {
  vec3 a = vec3(1.6);
  vec3 d = vec3(0.977);
  vec3 hdrMax = vec3(8.0);
  vec3 midIn = vec3(0.18);
  vec3 midOut = vec3(0.267);

  vec3 b =
      (-pow(midIn, a) + pow(hdrMax, a) * midOut) /
      ((pow(hdrMax, a * d) - pow(midIn, a * d)) * midOut);
  vec3 c =
      (pow(hdrMax, a * d) * pow(midIn, a) - pow(hdrMax, a) * pow(midIn, a * d) * midOut) /
      ((pow(hdrMax, a * d) - pow(midIn, a * d)) * midOut);

  return pow(x, a) / (pow(x, a * d) * b + c);
}

vec3 unreal(vec3 x) {
  return x / (x + 0.155) * 1.019;
}

vec3 bloom(float waterTest, vec2 specularCoord, vec3 Normal, vec4 Albedo) {
    float radius = 2f;
    vec3 sum = vec3(0.0);
    float blur = radius/viewHeight;
    float hstep = 1f;
    #if PATH_TRACING == 1
        vec2 uv = gl_FragCoord.xy / vec2(viewWidth, viewHeight);
        vec3 lightDir = normalize(sunPosition);
        vec3 cameraRight = normalize(cross(lightDir, vec3(0.0, 1.0, 0.0)));
        vec3 cameraUp = cross(cameraRight, lightDir);
        vec3 rayDir = normalize(lightDir + uv.x * cameraRight + uv.y * cameraUp);
        Ray ray = Ray(viewSpaceFragPosition, rayDir);

        sum += traceRay(ray,vec2(length(lightmap),1f), Normal,Albedo.a)/vec3(2);
    #else
        sum += GetLightmapColor(texture2D(colortex2, TexCoords).rg) + (texture2D(colortex10, specularCoord).rgb + texture2D(colortex11, specularCoord).rgb)/vec3(2);
    #endif

    /*if(texture2D(colortex2, TexCoords).r < 0.85 || texture2D(colortex2, TexCoords).g < 0.85) {
        GetLightmapColor(texture2D(colortex2, TexCoords).rg);
    }*/

    /*if(abs(sum.r - sum.g) > 0.25) {
        return GetLightmapColor(texture2D(colortex2, TexCoords).rg);
    }*/

    const vec3 TorchColor = vec3(1.0f, 0.25f, 0.08f);

    for(int i = 0; i < BLOOM_QUALITY/2; i++) {
        float sampleDepth = mix(0.0162162162,0.985135135,float(i)/(BLOOM_QUALITY/2));
        vec2 shiftedUVs = vec2(TexCoords.x - (float(i)/BLOOM_QUALITY) * radius * 4f * blur * hstep, TexCoords.y - (float(i)/BLOOM_QUALITY) * radius * 4f * blur * hstep).rg;
        vec2 specularUVs = vec2(specularCoord.x - (float(i)/BLOOM_QUALITY) * radius * 4f * blur * hstep, specularCoord.y - (float(i)/BLOOM_QUALITY) * radius * 4f * blur * hstep).rg;
        vec3 specularMap = (texture2D(colortex10, specularUVs).rgb + texture2D(colortex11, specularUVs).rgb);
        specularMap = pow(specularMap, vec3(100.0));
        vec3 light = GetLightmapColor(texture2D(colortex2, shiftedUVs).rg * vec2(0.6f, 1.0f));
        /*if(waterTest > 0f) {
            sum += (specularMap + light) * sampleDepth;
            continue;
        }*/
        #if PATH_TRACING == 1
            cameraRight = normalize(cross(lightDir, vec3(0.0, 1.0, 0.0)));
            cameraUp = cross(cameraRight, lightDir);
            rayDir = normalize(lightDir + shiftedUVs.x * cameraRight + shiftedUVs.y * cameraUp);
            Ray ray = Ray(viewSpaceFragPosition + vec3(shiftedUVs, 0.0), rayDir);
        
            sum += traceRay(ray,vec2(length(lightmap),1f), Normal,Albedo.a)/vec3(2) * sampleDepth;
            if(texture2D(colortex2, shiftedUVs).r > 0.0f) {
                sum += vec3(0.6f) * (texture2D(colortex2, shiftedUVs).r) * mix(vec3(1.0), TorchColor,0.4f);
            }
        #else
            sum += light * sampleDepth;
        #endif
    }

    for(int i = 0; i < BLOOM_QUALITY/2; i++) {
        float sampleDepth = mix(0.0162162162,0.985135135,float(i)/(BLOOM_QUALITY/2));
        vec2 shiftedUVs = vec2(TexCoords.x + (float(i)/BLOOM_QUALITY) * radius * 4f * blur * hstep, TexCoords.y + (float(i)/BLOOM_QUALITY) * radius * 4f * blur * hstep).rg;
        vec2 specularUVs = vec2(specularCoord.x - (float(i)/BLOOM_QUALITY) * radius * 4f * blur * hstep, specularCoord.y - (float(i)/BLOOM_QUALITY) * radius * 4f * blur * hstep).rg;
        vec3 specularMap = (texture2D(colortex10, specularUVs).rgb + texture2D(colortex11, specularUVs).rgb);
        specularMap = pow(specularMap, vec3(100.0));
        vec3 light = GetLightmapColor(texture2D(colortex2, shiftedUVs).rg * vec2(0.6f, 1.0f));
        /*if(waterTest > 0f) {
            sum += (specularMap + light) * sampleDepth;
            continue;
        }*/
        #if PATH_TRACING == 1
            cameraRight = normalize(cross(lightDir, vec3(0.0, 1.0, 0.0)));
            cameraUp = cross(cameraRight, lightDir);
            rayDir = normalize(lightDir + shiftedUVs.x * cameraRight + shiftedUVs.y * cameraUp);
            Ray ray = Ray(viewSpaceFragPosition + vec3(shiftedUVs, 0.0), rayDir);
        
            sum += traceRay(ray,vec2(length(lightmap),1f), Normal,Albedo.a)/vec3(2) * sampleDepth;
            if(texture2D(colortex2, shiftedUVs).r > 0.0f) {
                sum += vec3(0.6f) * (texture2D(colortex2, shiftedUVs).r) * mix(vec3(1.0), TorchColor,0.4f);
            }
        #else
            sum += light * sampleDepth;
        #endif
    }

    sum /= BLOOM_QUALITY/8;
    sum *= BLOOM_INTENSITY;

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
        sum *= mix(vec3(2),vec3(0.5),clamp(dot(sum, vec3(0.333)),0,1.2));
    }*/
    return pow(sum,vec3(2.2)) * vec3(0.0625);
}

float far = 1f;

vec4 GetLightVolume(vec3 pos) {
    vec4 lightVolume;

    #ifdef COMPOSITE
        #undef ACL_CORNER_LEAK_FIX
    #endif

    #ifdef ACL_CORNER_LEAK_FIX
        float minMult = 1.5;
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
}

vec3 GetColoredLightFog(vec3 nPlayerPos, vec3 translucentMult, float lViewPos, float lViewPos1, float dither, float caveFactor) {
    vec3 lightFog = vec3(0.0);

    float stepMult = 8.0;

    float maxDist = min(effectiveACLdistance * 0.5, far);
    float halfMaxDist = maxDist * 0.5;
    int sampleCount = int(maxDist / stepMult + 0.001);
    vec3 traceAdd = nPlayerPos * stepMult;
    vec3 tracePos = traceAdd * dither;

    for (int i = 0; i < sampleCount; i++) {
        tracePos += traceAdd;

        float lTracePos = length(tracePos);
        if (lTracePos > lViewPos1) break;

        vec3 voxelPos = SceneToVoxel(tracePos);
        voxelPos = clamp01(voxelPos / vec3(voxelVolumeSize));

        vec4 lightVolume = GetLightVolume(voxelPos);
        vec3 lightSample = lightVolume.rgb;

        float lTracePosM = length(vec3(tracePos.x, tracePos.y * 2.0, tracePos.z));
        lightSample *= max0(1.0 - lTracePosM / maxDist);
        lightSample *= pow2(min1(lTracePos * 0.03125));

        #ifdef CAVE_SMOKE
            if (caveFactor > 0.00001) {
                vec3 smokePos = 0.0025 * (tracePos + cameraPosition);
                vec3 smokeWind = frameTimeCounter * vec3(0.006, 0.003, 0.0);
                float smoke = Noise3D(smokePos + smokeWind)
                            * Noise3D(smokePos * 3.0 - smokeWind)
                            * Noise3D(smokePos * 9.0 + smokeWind);
                smoke = smoothstep1(smoke);
                lightSample *= mix(1.0, smoke * 16.0, caveFactor);
                lightSample += caveFogColor * pow2(smoke) * 0.05 * caveFactor;
            }
        #endif

        if (lTracePos > lViewPos) lightSample *= translucentMult;
        lightFog += lightSample;
    }

    #ifdef NETHER
        lightFog *= netherColor * 5.0;
    #endif

    lightFog *= 1.0 - maxBlindnessDarkness;

    return pow(lightFog / sampleCount, vec3(0.25));
}

vec4 rayMarch(vec3 rayOrigin, vec3 rayDir, float density) {
    vec4 color = vec4(0.0);
    float stepSize = 0.01;
    for(float t = 0.0; t < 1.0; t += stepSize) {
        vec3 pos = rayOrigin + t * rayDir;
        vec3 lightDir = normalize(sunPosition - viewSpaceFragPosition);
        vec3 light = vec3(max(dot(normalize(lightDir),normalize(pos - cameraPosition)), 0.0));
        color.rgb += density * light * stepSize;
        color.a += density * stepSize;

        if(color.a >= 1.0) break;
    }

    return color;
}

float fresnel(float sin_critical) {
	float t = (1.f - sin_critical) / (1.f + sin_critical);
	return t * t;
}

float fresnel(vec3 normal, vec3 viewDir, float power) {
    return pow(1.0 - dot(normalize(normal), normalize(viewDir)), power);
}

mat3 tbnNormalTangent(vec3 normal, vec3 tangent) {
    vec3 bitangent = cross(tangent, normal);
    return mat3(tangent, bitangent, normal);
}

void noonFunc(float time, float timeFactor) {
    float dayNightLerp = clamp((time+250f)/timeFactor,0,1);
    baseDiffuseModifier = vec3(DAY_I);
    currentColor = mix(baseColor,dayColor,dayNightLerp);
    Diffuse = mix(baseDiffuse, pow(Diffuse.rgb,vec3(2.2)) * baseDiffuseModifier, mod(worldTime/6000f,2f));
}

void sunsetFunc(float time, float timeFactor) {
    float sunsetLerp = clamp((time+250f)/timeFactor,0,1);
    baseDiffuseModifier = vec3(SUNSET_I);
    currentColor = mix(dayColor, transitionColor, sunsetLerp);
    Diffuse = mix(baseDiffuse, pow(Diffuse.rgb,vec3(2.2)) * baseDiffuseModifier, mod(worldTime/6000f,2f));
}

void nightFunc(float time, float timeFactor) {
    float dayNightLerp = clamp((time+250f)/timeFactor,0,1);
    baseDiffuseModifier = vec3(NIGHT_I * 0.4f);
    currentColor = mix(baseColor, nightColor, dayNightLerp);
    Diffuse = mix(baseDiffuse, pow(Diffuse.rgb,vec3(2.2)) * baseDiffuseModifier,mod(worldTime/6000f,2f));
}

void dawnFunc(float time, float timeFactor) {
    float sunsetLerp = clamp((time+250f)/timeFactor,0,1);
    baseDiffuseModifier = vec3(SUNSET_I);
    currentColor = mix(dayColor, transitionColor, sunsetLerp);
    Diffuse = mix(baseDiffuse, pow(Diffuse.rgb,vec3(2.2)) * baseDiffuseModifier, mod(worldTime/6000f,2f));
}

vec4 triplanarTexture(sampler2D texture, vec3 pos) {
    vec3 blendWeights = abs(normalize(vNormal));
    blendWeights /= (blendWeights.x + blendWeights.y + blendWeights.z);

    vec4 xProjection = texture2D(texture, pos.yz);
    vec4 yProjection = texture2D(texture, pos.xz);
    vec4 zProjection = texture2D(texture, pos.xy);

    return xProjection*blendWeights.x + yProjection*blendWeights.y + zProjection*blendWeights.z;
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

vec3 rgbToHsv(vec3 c) {
    float max = max(c.r, max(c.g, c.b));
    float min = min(c.r, min(c.g, c.b));
    float chroma = max - min;
    float saturation = (max == 0.0) ? 0.0 : chroma / max;
    return vec3(saturation);
}

vec3 waterFunction(vec2 coords, vec4 noise, float lightBrightness) {
    float distanceFromCamera = distance(vec3(0), viewSpaceFragPosition);
    vec2 refractionFactor = vec2(0);
    vec2 TexCoords2 = coords;
    float underwaterDepth = texture2D(depthtex0, TexCoords2).r;
    float underwaterDepth2 = texture2D(depthtex1, TexCoords2).r;
    #ifdef WATER_REFRACTION
        refractionFactor = sin(noise.y) * vec2(0.03125f) / max( distanceFromCamera*2f,1);
        TexCoords2 += refractionFactor;
        underwaterDepth = texture2D(depthtex0, TexCoords2).r;
        underwaterDepth2 = texture2D(depthtex1, TexCoords2).r;
    #endif
    vec3 waterColor = vec3(0.0f, 0.33f, 0.44f);
    if(underwaterDepth >= 1.0) {
        waterColor = vec3(0.0f, 0.33f, 0.44f);
        return pow(clamp(mix(texture2D(colortex0, TexCoords2).rgb/lightBrightness,waterColor,0.85)/clamp(lightBrightness,0.99,1.0),vec3(0.0f, 0.0f, 0.0f),(texture2D(colortex0, TexCoords2).rgb/0.2 * 0.15) + (waterColor*0.85))*clamp(lightBrightness,0.2,1.0), vec3(2.2f));
    }
    return pow(mix(texture2D(colortex0, TexCoords2).rgb,waterColor,clamp(1 - (underwaterDepth2 - underwaterDepth) * 0.125f,0,0.5)), vec3(2.2f)) * clamp(lightBrightness,0.5,1.0);
}

#include "lib/timeCycle.glsl"

void main() {
    float aspectRatio = float(viewWidth)/float(viewHeight);
    float waterTest = texture2D(colortex5, TexCoords).r;
    float dhTest = texture2D(colortex5, TexCoords).g;

    vec2 TexCoords2 = TexCoords;

    float Depth = texture2D(depthtex0, TexCoords).r;
    float Depth2 = texture2D(depthtex1, TexCoords).r;

    vec2 fragCoord = gl_FragCoord.xy/vec2(viewWidth, viewHeight);

    vec3 worldTexCoords = screenToWorld(TexCoords, clamp(Depth,0.0,1.0));

    float underwaterDepth = texture2D(depthtex0, TexCoords2).r;
    float underwaterDepth2 = texture2D(depthtex1, TexCoords2).r;
    
    vec3 Albedo;

    float albedoAlpha;

    float distanceFromCamera = distance(vec3(0), viewSpaceFragPosition);

    vec4 noiseMap = texture2D(colortex8, mod(worldTexCoords.xz/5,5)/vec2(5f) + (mod(worldTexCoords.x/5,5)*0.005f + ((frameCounter)/90f)*2.5f) * 0.01f);
    vec4 noiseMap2 = texture2D(colortex9, mod(worldTexCoords.xz/5,5)/vec2(2.5f) - (mod(worldTexCoords.x/5,5)*0.005f + ((frameCounter)/90f)*2.5f) * 0.01f);

    vec4 noiseMap4 = texture2D(colortex8, mod(worldTexCoords.xz/50,5)/vec2(5f) + (mod(worldTexCoords.x/50,5)*0.005f + ((frameCounter)/90f)*2.5f) * 0.01f);
    vec4 noiseMap5 = texture2D(colortex9, mod(worldTexCoords.xz/5,5)/vec2(2.5f) - (mod(worldTexCoords.x/5,5)*0.005f + ((frameCounter)/90f)*2.5f) * 0.01f);

    vec4 finalNoiseA = (noiseMap * noiseMap2);
    vec4 finalNoiseB = (noiseMap4 * noiseMap5);

    vec4 finalNoise = (finalNoiseA * finalNoiseB);

    vec4 noiseMap3 = texture2D(colortex8, TexCoords - sin(TexCoords.y*64f + ((frameCounter)/90f)) * 0.005f);

    vec3 Normal = normalize(texture2D(colortex1, TexCoords2).rgb * 2.0f -1.0f);

    vec3 worldGeoNormal = mat3(gbufferModelViewInverse) * Normal;

    vec3 worldTangent = mat3(gbufferModelViewInverse) * at_tangent.xyz;

    vec3 normalNormalSpace = vec3(Normal.xy, sqrt(1.0 - dot(Normal.xy, Normal.xy))) * 2.0 - 1.0;
    mat3 TBN = tbnNormalTangent(worldGeoNormal,worldTangent);

    vec3 normalWorldSpace = TBN * normalNormalSpace;

    vec3 shadowLightDirection = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);

    float lightBrightness = clamp(dot(shadowLightDirection, worldGeoNormal),0.2,1.0);

    vec4 specularDataA = 1 - texture2D(colortex10,worldTexCoords.xy/vec2(500f));
    vec4 specularDataB = 1 - texture2D(colortex11,worldTexCoords.xy/vec2(500f));

    vec2 refractionFactor = vec2(0);

    if(waterTest > 0) {
        if(underwaterDepth2 - underwaterDepth > 0f || Depth >= 1.0)
        {
            if(Depth >= 1.0) {
                Albedo = pow(waterFunction(TexCoords, finalNoise, lightBrightness),vec3(1/2.2));
                albedoAlpha = 0.0;
            } else {
                Albedo = waterFunction(TexCoords, finalNoise, lightBrightness);
                albedoAlpha = 0.0;
            }
            vec3 Albedo2 = pow(mix(texture2D(colortex0, TexCoords2).rgb,vec3(0.0f,0.11f,0.33f),clamp(1 - (underwaterDepth2 - underwaterDepth) * 0.125f,0,0.5)), vec3(2.2f));
            //Normal = normalize(max(finalNoise.xyz * 2.0f -1.0f,Normal));
            
            shadowLightDirection = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);
            worldGeoNormal = mat3(gbufferModelViewInverse) * Normal;
            worldTangent = mat3(gbufferModelViewInverse) * at_tangent.xyz;

            normalNormalSpace = vec3(Normal.xy, sqrt(1.0 - dot(Normal.xy, Normal.xy))) * 2.0 - 1.0;
            TBN = tbnNormalTangent(worldGeoNormal,worldTangent);

            normalWorldSpace = TBN * normalNormalSpace;

            specularDataA = 1 - texture2D(colortex10,worldTexCoords.xy/vec2(500f) + refractionFactor);
            specularDataB = 1 - texture2D(colortex11,worldTexCoords.xy/vec2(500f) + refractionFactor);
            
            float perceptualSmoothness = (specularDataA.r + specularDataB.r)/2;
            float roughness = pow(1.0 - perceptualSmoothness, 2.0);

            float smoothness = 1 - roughness;
            
            vec3 reflectionDir = reflect(-shadowLightDirection, normalWorldSpace);

            vec3 fragFeetPlayerSpace = vec3(gbufferModelViewInverse * vec4(viewSpaceFragPosition, 1.0));

            vec3 fragWorldSpace = fragFeetPlayerSpace + cameraPosition;

            vec3 viewDirection = normalize(cameraPosition - fragWorldSpace);

            float diffuseLight = roughness * clamp(dot(shadowLightDirection, normalWorldSpace), 0.0, 1.0);
            
            float specularLight = smoothness * clamp(pow(dot(shadowLightDirection, normalWorldSpace),100.0), 0.0, 1.0);

            float ambientLight = 0.0;

            //lightBrightness = ambientLight + diffuseLight + specularLight;
            //Albedo.xyz = mix(Albedo.xyz, vec3(1.0), lightBrightness);
        } else {
            underwaterDepth = texture2D(depthtex0, TexCoords).r;
            underwaterDepth2 = texture2D(depthtex1, TexCoords).r;
            Albedo = pow(mix(texture2D(colortex0, TexCoords).rgb,vec3(0.0f,0.33f,0.55f),clamp((0.5 - (underwaterDepth2 - underwaterDepth)) * 0.5,0,1)), vec3(2.2f));
            Normal = normalize(texture2D(colortex1, TexCoords).rgb * 2.0f -1.0f);
            TexCoords2 = TexCoords;
        }
        #ifdef WATER_FOAM
            float isRain = texture2D(colortex3, TexCoords).r;
            if(abs(Depth - Depth2) < 0.0005f && isRain == 0.0) {
                Albedo = mix(Albedo, vec3(1.0f), clamp(1 - abs(Depth - Depth2),0f,1));
            }
        #endif
    } else {
        albedoAlpha = 0.0;
        Albedo = pow(isInWater(colortex0, vec3(0.0f,0.33f,0.55f), TexCoords2, vec2(noiseMap3.x * 0.025,0), 0.25), vec3(2.2f));
        Normal = normalize(texture2D(colortex1, TexCoords).rgb * 2.0f -1.0f);
    }

    /*if(Depth != Depth2 && waterTest > 0) {
        Albedo = mix(Albedo,mix(Albedo,vec3(0.0f,0.22f,0.55f),0.25), clamp((1 - (Depth - Depth2)),0,1)*0.5);
    }*/

    vec3 currentColor = dayColor;

    /*if(timePhase > 3) {
        timePhase = 0;
    }*/
    Diffuse = Albedo;

    vec3 baseColor = currentColor;
    vec3 baseDiffuse = Diffuse;

    vec3 baseDiffuseModifier;
    
    if(worldTime/(timePhase + 1) < 500f) {
        baseColor = currentColor;
        baseDiffuse = Diffuse;
    }
    
    float dayNightLerp = clamp(quadTime/11500,0,1);
    float sunsetLerp = clamp(quadTime/500,0,1);
    
    vec4 cloudViewPos = gbufferProjection * vec4(TexCoords, 0.0, 1.0);
    vec4 cloudClipPos = cloudViewPos;
    
    vec3 cloudNDC = cloudClipPos.xyz / cloudClipPos.w;

    vec2 cloudScreenPos = cloudNDC.xy * 0.5 + 0.5;

    vec4 cloudNoiseMap = texture2D(noisetex, cloudScreenPos - vec2(worldTime * 550.0, 0.0));
    vec4 cloudNoiseMap2 = texture2D(noisetex, cloudScreenPos + vec2(0.0, worldTime * 550.0));
    vec4 cloudFinalNoise = mix(cloudNoiseMap,vec4(0.0),cloudNoiseMap2);

    vec3 cloudRayDir = normalize(viewSpaceFragPosition);
    vec4 cloudColor = rayMarch(cameraPosition, cloudRayDir, cloudFinalNoise.y);

    Diffuse = mix(Diffuse, cloudColor.xyz, cloudColor.a);

    if(isBiomeEnd) {
        if(dhTest <= 0) {
            currentColor = vec3(0.3f);
        } else {
            currentColor = seColor;
        }
    } else {
        timeFunctionFrag();
    }/*else if(timePhase < 1) {
        baseDiffuseModifier = vec3(DAY_I);
        currentColor = mix(baseColor,dayColor,dayNightLerp);
        Diffuse = mix(baseDiffuse, pow(Diffuse.rgb,vec3(2.2)) * baseDiffuseModifier, mod(worldTime/6000f,2f));
        
    } else if(timePhase < 2) {
        baseDiffuseModifier = vec3(SUNSET_I);
        currentColor = mix(dayColor, transitionColor, sunsetLerp);
        Diffuse = mix(baseDiffuse, pow(Diffuse.rgb,vec3(2.2)) * baseDiffuseModifier, mod(worldTime/6000f,2f));
    } else if(timePhase < 3) {
        baseDiffuseModifier = vec3(NIGHT_I * 0.4f);
        currentColor = mix(baseColor, nightColor, dayNightLerp);
        Diffuse = mix(baseDiffuse, pow(Diffuse.rgb,vec3(2.2)) * baseDiffuseModifier,mod(worldTime/6000f,2f));
    } else if(timePhase < 4) {
        baseDiffuseModifier = vec3(SUNSET_I);
        currentColor = mix(nightColor, transitionColor, sunsetLerp);
        Diffuse = mix(baseDiffuse, pow(Diffuse.rgb,vec3(2.2)) * baseDiffuseModifier, mod(worldTime/6000f,2f));
    }*/

    //Diffuse *= currentColor;

    if(Depth == 1.0f){
        /*float distanceFromCamera = distance(vec3(0), viewSpaceFragPosition);

        float maxBlindnessDistance = 30;
        float minBlindnessDistance = 20;

        float blindnessBlendValue = clamp((distanceFromCamera - minBlindnessDistance) / (maxBlindnessDistance - minBlindnessDistance),0,1);*/
    
        currentColor = mix(currentColor, cloudColor.xyz, cloudColor.a);

        /*if(worldTime%24000 > 12000 && dot(Albedo,vec3(0.333f)) < 0.5f) {
            currentColor *= NIGHT_I * 0.5f;
        }*/

        float detectSky = texture2D(colortex5, TexCoords).g;
        vec3 lightmapColor = texture2D(colortex2, TexCoords.xy).rgb;
        if(detectSky < 1.0) {
            if(isBiomeEnd) {
                Diffuse = pow(texture2D(colortex0, TexCoords.xy).rgb,vec3(2.2));
                Diffuse = mix(Diffuse,vec3(pow(dot(Diffuse,vec3(0.333f)),1/2.55) * 0.125f),1.0625-clamp(vec3(dot(Diffuse.rgb,vec3(0.333f))),0.5,1));
                Diffuse.xyz = mix(unreal(Diffuse.xyz),aces(Diffuse.xyz),0.75);
            } else {
                /*if(dot(LightmapColor,vec3(0.333)) > maxLight) {
                    LightmapColor = LightmapColor/vec3(dot(LightmapColor,vec3(0.333)));
                }*/
                Diffuse.xyz = mix(unreal(Diffuse.xyz),aces(Diffuse.xyz),0.75);
            }
            /*if(waterTest > 0f) {
                Diffuse = pow(waterFunction(TexCoords, finalNoise, lightBrightness),vec3(1/2.2));
            }*/
            Diffuse.xyz = mix(Diffuse.xyz, vec3(0), blindness);
            gl_FragData[0] = vec4(pow(Diffuse.xyz,vec3(1/2.2)) * currentColor, 1.0f);
        } else {
            Diffuse.xyz = mix(Diffuse.xyz, vec3(0), blindness);
            gl_FragData[0] = vec4(currentColor * Albedo, 1.0f);
        }
        return;
    }

    float minLight = MIN_LIGHT;
    float seMinLight = SE_MIN_LIGHT;
    
    vec3 LightmapColor;
    //vec3 Lightmap = bloom();

    /*#ifdef PATH_TRACING
        vec2 uv = gl_FragCoord.xy / vec2(viewWidth, viewHeight);
        vec3 lightDir = normalize(sunPosition);
        vec3 cameraRight = normalize(cross(lightDir, vec3(0.0, 1.0, 0.0)));
        vec3 cameraUp = cross(cameraRight, lightDir);
        vec3 rayDir = normalize(lightDir + uv.x * cameraRight + uv.y * cameraUp);
        Ray ray = Ray(viewSpaceFragPosition, rayDir);

        LightmapColor = traceRay(ray,vec2(length(lightmap),1f), Normal);

        LightmapColor += GetLightmapColor(vec2(length(lightmap),0f));
    #else*/
        #ifdef BLOOM
            LightmapColor = bloom(waterTest, worldTexCoords.xy/vec2(500f) + refractionFactor, Normal, vec4(Albedo,albedoAlpha));
            /*if(dot(LightmapColor,vec3(0.333f)) < BLOOM_THRESHOLD) {
                LightmapColor = GetLightmapColor(texture2D(colortex2, TexCoords).rg);
            }*/
        #else
            LightmapColor = GetLightmapColor(texture2D(colortex2, TexCoords2).rg);
        #endif
    //#endif
    vec3 LightmapColor2 = texture2D(colortex7,TexCoords2).rgb + lightBrightness;

    /*if(isBiomeEnd) {
        if(dot(LightmapColor, vec3(0.333f)) < seMinLight) {
            LightmapColor = vec3(seMinLight);
        }
    } else if(dot(LightmapColor, vec3(0.333f)) < minLight) {
        LightmapColor = vec3(minLight);
    }*/

    float NdotL = max(dot(Normal, normalize(sunPosition)), 0.0f);

    /*if((Lightmap.r + Lightmap.g + Lightmap.b)/3 < 0) {
        Diffuse = Albedo * LightmapColor;
    } else {
        Diffuse = Albedo * ((LightmapColor + NdotL * GetShadow(Depth) + Ambient) * currentColor);
    }*/

    float isParticle = texture2D(colortex6, TexCoords).r;

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
        Diffuse.xyz = mix(Albedo * ((LightmapColor + NdotL * GetShadow(Depth) + Ambient) * currentColor),LightmapColor,Lightmap.r * vec3(0.0625));
    }*/

    float maxLight = MAX_LIGHT;
    
    vec3 shadowLerp = mix(GetShadow(Depth), vec3(1.0), length(LightmapColor));
    if(isBiomeEnd) {
        #if PATH_TRACING == 1
            LightmapColor *= vec3(1.5025);
        #else
            LightmapColor *= vec3(1.5025);
        #endif
        lightBrightness = max(lightBrightness, 0.5);
        Diffuse.xyz = mix(Albedo * ((mix(LightmapColor,vec3(dot(LightmapColor,vec3(0.333f))),0.75)*0.125 + NdotL * shadowLerp + Ambient) * currentColor),Albedo * ((NdotL * shadowLerp + Ambient) * currentColor),0.25);
        //Diffuse = mix(Diffuse, seColor, 0.01);
        Diffuse = mix(Diffuse,vec3(pow(dot(Diffuse,vec3(0.333f)),1/2.55) * 0.125f),1.0625-clamp(vec3(dot(LightmapColor.rg,vec2(0.333f))),0.5,1));
        Diffuse.xyz = mix(unreal(Diffuse.xyz),aces(Diffuse.xyz),0.75);
    } else {
        /*if(dot(LightmapColor,vec3(0.333)) > maxLight) {
            LightmapColor = LightmapColor/vec3(dot(LightmapColor,vec3(0.333)));
        }*/
        if(maxLight < 4.1f) {
            LightmapColor = clamp(LightmapColor,vec3(0f), (LightmapColor/dot(LightmapColor,vec3(0.333))) * maxLight);
        }
        Diffuse.xyz = mix(Albedo * (LightmapColor + NdotL * shadowLerp + Ambient),Albedo * (NdotL * shadowLerp + Ambient),0.25);
        Diffuse.xyz = mix(unreal(Diffuse.xyz),aces(Diffuse.xyz),0.75);
    }

    //if(waterTest <= 0) {
        Diffuse.xyz = mix(Diffuse.xyz * lightBrightness,Diffuse.xyz,dot(LightmapColor, vec3(0.333)));
    //}

    //vec3 worldSpaceVertexPosition = cameraPosition + (gbufferModelViewInverse * projectionMatrix * modelViewMatrix * vec4(vaPosition,1)).xyz;

    float maxBlindnessDistance = 30;
    float minBlindnessDistance = 20;

    float blindnessBlendValue = clamp((distanceFromCamera - minBlindnessDistance) / (maxBlindnessDistance - minBlindnessDistance),0,1);
    
    //Diffuse.xyz = mix(Diffuse.xyz, vec3(0), blindness);

    //Diffuse.xyz = mix(Diffuse.xyz,vec3(0),blindnessBlendValue);
    
    /*if(isLiquidEmerald > 0.0) {
        Diffuse *= vec3(1);
    }*/

    /*if(timePhase < 4 && timePhase > 2) {
        Diffuse.xyz *= vec3(0.4f);
    }*/

    gl_FragData[0] = vec4(pow(Diffuse.xyz,vec3(1/2.2)), 1.0f);
}