#version 460 compatibility

#define FRAGMENT_SHADER
#define COMPOSITE_2

#define PI 3.14159265358979323846f

#define CLOUD_STYLE 1 // [0 1]
#define CLOUD_FOG 0.5 // [0.0 0.25 0.5 0.75 1.0]
#define CLOUD_DENSITY 0.5 // [0.0 0.25 0.5 0.75 1.0 1.25 1.5 1.75 2.0]
#define CLOUD_DENSITY_RAIN 0.75 // [0.0 0.25 0.5 0.75 1.0 1.25 1.5 1.75 2.0]
#define CLOUD_SAMPLES 10.0 // [10.0 20.0 30.0 40.0 50.0 100.0]
#define CLOUD_SPEED 1.0 // [0.25 0.5 0.75 1.0 1.25 1.5 1.75 2.0]

#define CLOUD_SHADING_SAMPLES 2.0 // [2.0 3.0 4.0 5.0]
#define CLOUD_SHADING_DISTANCE 128.0 // [32.0 64.0 96.0 128.0 160.0 192.0 224.0 256.0]

#define CLOUD_RESOLUTION_REDUCTION 4 // [1 2 4 10]

#define SE_MAX_LIGHT 2.0f // [1.0f 1.1f 1.2f 1.3f 1.4f 1.5f 1.6f 1.7f 1.8f 1.9f 2.0f 2.1f 2.2f 2.3f 2.4f 2.5f 2.6f 2.7f 2.8f 2.9f 3.0f 3.1f 3.2f 3.3f 3.4f 3.5f 3.6f 3.7f 3.8f 3.9f 4.0f 4.1f]

#include "lib/includes2.glsl"
#include "lib/optimizationFunctions.glsl"
#include "lib/globalDefines.glsl"

uniform float frameTimeCounter;
uniform float frameTime;
uniform int worldTime;

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D colortex3;
uniform sampler2D colortex4;
uniform sampler2D colortex5;
uniform sampler2D colortex6;
uniform sampler2D colortex7;
uniform sampler2D colortex10;
uniform sampler2D colortex12;
uniform sampler2D colortex13;
uniform sampler2D colortex14;
uniform sampler2D depthtex0;
uniform sampler2D noisetex;
uniform mat4 gbufferPreviousModelView;
uniform mat4 gbufferPreviousProjection;
uniform mat4 gbufferPreviousModelViewInverse;
uniform mat4 gbufferPreviousProjectionInverse;

uniform sampler2D cSampler9;
uniform sampler2D cSampler11;
uniform sampler2D cSampler14;

layout (rgba8) uniform image2D cimage8;
layout (rgba8) uniform image2D cimage9;
layout (rgba8) uniform image2D cimage14;

uniform float rainStrength;
uniform vec3 sunPosition;

uniform float viewWidth;
uniform float viewHeight;

uniform vec3 shadowLightPosition;
uniform vec3 cameraPosition;

in vec2 texCoord;

uniform sampler2D noiseb;
uniform sampler2D noisec;

uniform sampler2D randnoisea;
uniform sampler2D randnoiseb;
uniform sampler2D randnoisec;

uniform sampler2D cloudtex;
uniform sampler2D clouddis;

uniform float near;
uniform float far;

uniform float dhFarPlane;

#include "lib/post/blindness.glsl"

#include "lib/misc/buffers.glsl"

#include "lib/post/gaussianBlur.glsl"

#include "lib/lighting/lighting.glsl"

vec4 triplanarTexture(vec3 worldPos, vec3 normal, sampler2D tex, float scale) {
    normal = abs(normal);
    normal = normal / (normal.x + normal.y + normal.z + 0.0001);

    vec2 uvXZ = fract(worldPos.xz * scale);
    vec2 uvXY = fract(worldPos.xy * scale);
    vec2 uvZY = fract(worldPos.zy * scale);

    vec4 texXZ = texture2D(tex,uvXZ) * normal.y;
    vec4 texXY = texture2D(tex,uvXY) * normal.z;
    vec4 texZY = texture2D(tex,uvZY) * normal.x;

    return texXZ + texXY + texZY;
}

float getDepthMask(sampler2D local, sampler2D distant) {
    if(texture2D(depthtex0, texCoord).x >= 1.0 && texture2D(colortex13, texCoord).z == 0.0) return 1.0;
    return mix2(linearizeDepth(texture2D(local, texCoord).x,near,far) / dhFarPlane, texture2D(colortex13, texCoord).z * 0.475, step(1.0, texture2D(depthtex0, texCoord).x)) * 32;
}

float getDepthMask(sampler2D local, sampler2D distant, vec2 uv) {
    return mix2(linearizeDepth(texture2D(depthtex0, uv).x,near,far) / dhFarPlane, texture2D(colortex13, uv).z * 0.475, step(1.0, texture2D(depthtex0, uv).x)) * 32;
}

float getDistMask(sampler2D local) {
    return decodeDist(texture2D(local, texCoord).y, dhFarPlane);
}

vec3 projectAndDivide(mat4 pm, vec3 p) {
    vec4 hp = pm * vec4(p, 1.0);
    return hp.xyz/hp.w;
}

mediump float random(in vec2 p) {
    return fract(sin(p.x*456.0+p.y*56.0)*100.0);
}

mediump float random3D(in vec3 p) {
    return fract(sin(p.x*456.0+p.y*56.0+p.z*741.0)*100.0);
}

mediump float randomHash(in vec2 p) {
    vec3 p3 = fract(vec3(p.xyx) * 0.1031);
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}

mediump float calcRandom(in vec2 p, float time) {
    float hashA =texture2D(randnoisea,p + time).x;
    float hashB = texture2D(randnoiseb,p + time).x;
    return mix2(hashA, hashB, time);
}

mediump float calcRandom3D(in vec3 p, float time) {
    float hashA = triplanarTexture(p + time, texture2D(colortex1, texCoord).xyz * 2 - 1, randnoisea, 1.0).x;
    float hashB = triplanarTexture(p + time, texture2D(colortex1, texCoord).xyz * 2 - 1, randnoiseb, 1.0).x;
    return mix2(hashA, hashB, time);
}

vec2 smoothUVs(in vec2 v) {
    return v*v*(3.0-2.0*v);
}

vec3 smoothUVs3D(in vec3 v) {
    return v*v*(3.0-2.0*v);
}


mediump float smooth_noise(in vec2 p) {
    vec2 f = smoothUVs(fract(p));
    mediump float a = random(floor(p));
    mediump float b = random(vec2(ceil(p.x),floor(p.y)));
    mediump float c = random(vec2(floor(p.x),ceil(p.y)));
    mediump float d = random(ceil(p));
    return mix2(
        mix2(a,b,f.x),
        mix2(c,d,f.x),
        f.y
    );
}

mediump float smooth_noise3D(in vec3 p) {
    vec3 f = smoothUVs3D(fract(p));
    mediump float a = random3D(floor(p));
    mediump float b = random3D(vec3(ceil(p.x),floor(p.y),floor(p.z)));
    mediump float c = random3D(vec3(floor(p.x),ceil(p.y),floor(p.y)));
    mediump float d = random3D(vec3(ceil(p.xy),floor(p.z)));

    mediump float bottom = mix2(mix2(a,b,f.x), mix2(c,d,f.x),f.y);

    mediump float a2 = random3D(vec3(floor(p.x),floor(p.y),ceil(p.z)));
    mediump float b2 = random3D(vec3(ceil(p.x),floor(p.y),ceil(p.z)));
    mediump float c2 = random3D(vec3(floor(p.x),ceil(p.y),ceil(p.y)));
    mediump float d2 = random3D(vec3(ceil(p.xy),ceil(p.z)));

    mediump float top = mix2(mix2(a,b,f.x), mix2(c,d,f.x),f.y);

    return mix2(bottom, top, f.z);
}

mediump float fractal_noise(in vec2 p) {
    mediump float total = 0.5;
    mediump float amplitude = 1.0;
    mediump float frequency = 1.0;
    mediump float iterations = 4.0;
    for(float i = 0; i < iterations; i++) {
        total += (smooth_noise(p * frequency) - 0.5)*amplitude;
        amplitude *= 0.5;
        frequency *= 2.0;
    }
    return total;
}

mediump float fractal_noise3D(in vec3 p) {
    mediump float total = 0.5;
    mediump float amplitude = 1.0;
    mediump float frequency = 1.0;
    mediump float iterations = 4.0;
    for(float i = 0; i < iterations; i++) {
        total += (smooth_noise3D(p * frequency) - 0.5)*amplitude;
        amplitude *= 0.5;
        frequency *= 2.0;
    }
    return total;
}

vec4 cloudStack(in vec2 uv) {
    vec4 finalNoise = vec4(0.0);
    mediump float cloudLevels = 8.0;
    mediump float cloudHeight = 550/viewHeight;
    mediump float attenuation = 0.125;
    for(float i = 0; i < cloudLevels; i++) {
        vec4 noiseA = texture2D(noiseb,fract(uv * 0.0625f - vec2(0.0, (cloudHeight * i)/cloudLevels) - worldTime));
        vec4 noiseB = texture2D(noiseb,fract(uv * 0.015625f - vec2(0.0, (cloudHeight * i)/cloudLevels) + worldTime));
        noiseA = mix2(pow2(noiseA, vec4(CLOUD_DENSITY)),pow2(noiseA, vec4(CLOUD_DENSITY_RAIN)),rainStrength);
        noiseB = mix2(pow2(noiseA, vec4(CLOUD_DENSITY)),pow2(noiseB, vec4(CLOUD_DENSITY_RAIN)),rainStrength);
        finalNoise += noiseA * noiseB * attenuation;
        attenuation += 0.125;
    }
    finalNoise /= attenuation;

    return finalNoise;
}

vec3 randomNoise(vec3 worldPos, vec3 Normal, sampler2D tex, float scale, float speed) {
    vec3 noiseA = triplanarTexture(worldPos, Normal, tex, scale).xyz;
    vec3 noiseB = triplanarTexture(worldPos + vec3(0.3, 0.2, 0.1), Normal, tex, scale).xyz;
    
    vec3 finalNoise = mix2(noiseA, noiseB, fract(frameTime * speed));
    return finalNoise;
}

vec3 warpNoise(vec3 worldPos, vec3 Normal, sampler2D tex, float scale, float speed) {
    vec3 warp = triplanarTexture(worldPos * 0.5 + frameTimeCounter * speed, Normal, tex, scale).rgb * 2.0 - 1.0;
    vec3 n = triplanarTexture(worldPos + warp * 0.2, Normal, tex, scale).rgb;
    return n;
}

vec3 lightNoise(vec3 worldPos, vec3 Normal) {
    vec3 lightA = pow2(triplanarTexture(worldPos, Normal, noiseb, 0.05).xyz,vec3(2.0));
    vec3 lightB = pow2(triplanarTexture(worldPos, Normal, noiseb, 0.05).xyz,vec3(0.5));
    float lightC = triplanarTexture(worldPos, Normal, noisec, 0.025).x;
    return mix2(lightA, lightB, lightC);
}

float lightVariationNoise(vec2 uv) {
    float noiseA = mix2(texture2D(randnoisea, uv).x, texture2D(randnoisea, fract(uv + 0.5)).x, fract(frameTimeCounter * 400));
    float noiseB = mix2(texture2D(randnoiseb, uv).x, texture2D(randnoiseb, fract(uv + 0.5)).x, fract(frameTimeCounter * 400));
    float noiseC = mix2(texture2D(randnoisec, uv).x, texture2D(randnoisec, fract(uv + 0.5)).x, fract(frameTimeCounter * 400));
    float noiseA2 = mix2(texture2D(randnoisea, 1 - uv).x, texture2D(randnoisea, 1 - fract(uv + 0.5)).x, fract(frameTimeCounter * 400));
    float noiseB2 = mix2(texture2D(randnoiseb, 1 - uv).x, texture2D(randnoiseb, 1 - fract(uv + 0.5)).x, fract(frameTimeCounter * 400));
    float noiseC2 = mix2(texture2D(randnoisec, 1 - uv).x, texture2D(randnoisec, 1 - fract(uv + 0.5)).x, fract(frameTimeCounter * 400));

    float noiseBlendA = mix3(noiseA, noiseB, noiseC, fract(frameTimeCounter * 100), 0.5);
    float noiseBlendB = mix3(noiseA2, noiseB2, noiseC2, fract(frameTimeCounter * 100), 0.5);

    return mix2(noiseBlendA, noiseBlendB, fract(frameTimeCounter*25));
}

mediump float get_cloud(vec3 p) {
    return clamp(texture2D(noiseb,p.xz/p.y).r * texture2D(noiseb,p.xz/p.y * 0.1).r * texture2D(noiseb,p.xz/p.y * 0.05).r * (1.0-(0.3*(1.0 - rainStrength)))*4.0,0,1);
}

mediump float get_cloud(vec3 p, vec3 p2) {
    return mix2(fractal_noise3D(p), fractal_noise3D(p2), 0.5);
}

mediump vec2 get_cloud(vec2 p, vec2 p2) {
    return mix2(texture2D(cloudtex, p).xy, texture2D(cloudtex, p).xy, 0.5);
}

vec4 normalFromHeight(sampler2D noiseTex, vec2 uv, float scale, float noiseType) {
    mediump float moveStep = 1.0/viewHeight;
    mediump float height = texture2D(noiseTex,uv).r;
    vec2 dxy;
    if(noiseType <= 0.0) {
        dxy = vec2(height) - vec2( cloudStack(uv + vec2(moveStep, 0.0)).r,  cloudStack(uv + vec2(0.0, moveStep)).r);
    } else {
        dxy = vec2(height) - vec2( cloudStack(uv + vec2(moveStep, 0.0)).r,  cloudStack(uv + vec2(0.0, moveStep)).r);
    }
    return vec4(normalize(vec3(dxy * scale / moveStep, 1.0)),height);
}

vec4 normalFromHeight(vec3 uv, float scale, float noiseType) {
    mediump float moveStep = 1.0/viewHeight;
    mediump float height = get_cloud(uv).r;
    vec3 dxy;
    if(noiseType <= 0.0) {
        dxy = vec3(height) - vec3( get_cloud(uv + vec3(moveStep, 0.0, 0.0)).r,  get_cloud(uv + vec3(0.0, moveStep,0.0)).r,get_cloud(uv + vec3(0.0, 0.0, moveStep)).r);
    } else {
        dxy = vec3(height) - vec3( get_cloud(uv + vec3(moveStep, 0.0, 0.0)).r,  get_cloud(uv + vec3(0.0, moveStep,0.0)).r,get_cloud(uv + vec3(0.0, 0.0, moveStep)).r);
    }
    return vec4(normalize(dxy * scale / moveStep),height);
}

mediump float invLerp(float from, float to, float value){
  return (value - from) / (to - from);
}

mediump float remap(float origFrom, float origTo, float targetFrom, float targetTo, float value){
  mediump float rel = invLerp(origFrom, origTo, value);
  return mix2(targetFrom, targetTo, rel);
}

mediump vec4 invLerp(vec4 from, vec4 to, vec4 value){
  return (value - from) / (to - from);
}

mediump vec4 remap(vec4 origFrom, vec4 origTo, vec4 targetFrom, vec4 targetTo, vec4 value){
  mediump vec4 rel = invLerp(origFrom, origTo, value);
  return mix2(targetFrom, targetTo, rel);
}

mediump vec2 invLerp(vec2 from, vec2 to, vec2 value){
  return (value - from) / (to - from);
}

mediump vec2 remap(vec2 origFrom, vec2 origTo, vec2 targetFrom, vec2 targetTo, vec2 value){
  mediump vec2 rel = invLerp(origFrom, origTo, value);
  return mix2(targetFrom, targetTo, rel);
}

vec4 blurImage(vec2 UVs, float radius, float strength, int samples, vec2 resolution, vec2 resolutionReduction) {
    vec2 uv = vec2((UVs.x*resolution.x)/CLOUD_RESOLUTION_REDUCTION,(UVs.x*resolution.y)/CLOUD_RESOLUTION_REDUCTION);
    vec4 color = imageLoad(cimage9, ivec2((UVs * resolution)/resolutionReduction));

    for(int i = 0; i < samples; i++) {
        ivec2 uv2 = ivec2(uv + (float(i) * radius/float(samples)));
        ivec2 uv3 = ivec2(uv - (float(i) * radius/float(samples)));
        color += imageLoad(cimage9, uv2) * strength;
        color += imageLoad(cimage9, uv3) * strength;
        color *= (1 - float(i)/float(samples));
    }

    return color;
}

uniform mat4 shadowProjectionInverse;
uniform mat4 shadowModelViewInverse;

uniform mat4 shadowProjection;
uniform mat4 shadowModelView;

uniform sampler2D shadowtex0;
uniform sampler2D shadowtex1;

uniform sampler2D shadowcolor0;

uniform sampler2D depthtex1;

in vec3 Tangent;

varying vec2 LightmapCoords;

uniform sampler2D lightmap;

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

const int ShadowSamplesPerSize = 2 * SHADOW_SAMPLES + 1;
const int TotalSamples = ShadowSamplesPerSize * ShadowSamplesPerSize;

#include "program/distort.glsl"

mediump float Visibility(in sampler2D ShadowMap, in vec3 SampleCoords) {
    return step(SampleCoords.z - 0.001f, texture2D(ShadowMap, SampleCoords.xy).r);
}

vec3 TransparentShadow(in vec3 SampleCoords){
    mediump float ShadowVisibility0 = Visibility(shadowtex0, SampleCoords);
    mediump float ShadowVisibility1 = Visibility(shadowtex1, SampleCoords);
    vec4 ShadowColor0 = texture2D(shadowcolor0, SampleCoords.xy);
    vec3 TransmittedColor = ShadowColor0.rgb * (1.0f - ShadowColor0.a);
    return mix2(TransmittedColor * ShadowVisibility1, vec3(1.0f), ShadowVisibility0);
}

mat3 tbnNormalTangent(vec3 normal, vec3 tangent) {
    vec3 bitangent = cross(tangent, normal);
    return mat3(tangent, bitangent, normal);
}

vec3 GetShadow(float depth) {
    vec3 ClipSpace = vec3(texCoord, depth) * 2.0f - 1.0f;
    vec4 ViewW = gbufferProjectionInverse * vec4(ClipSpace, 1.0f);
    vec3 View = ViewW.xyz / ViewW.w;
    vec4 World = gbufferModelViewInverse * vec4(View, 1.0f);
    vec4 ShadowSpace = shadowProjection * shadowModelView * World;
    ShadowSpace.xy = DistortPosition(ShadowSpace.xy);
    vec3 worldSpaceSunPos = (gbufferProjection * vec4(sunPosition,1.0)).xyz;
    vec3 lightDir = normalize2(worldSpaceSunPos);
    vec3 normal = texture2D(colortex1, texCoord).rgb;
    normal = tbnNormalTangent(normal, Tangent) * normal;
    vec3 normalClip = normal * 2.0f - 1.0f;
    vec4 normalViewW = gbufferProjectionInverse * vec4(normalClip, 1.0);
    vec3 normalView = normalViewW.xyz/normalViewW.w;
    vec4 normalWorld = gbufferModelViewInverse * vec4(normalView, 1.0f);
    vec3 fragPos = texture2D(colortex10, texCoord).rgb;
    #if RAY_TRACED_SHADOWS == 1
        return computeShadows(lightDir, vec3(0.0), normal, World.xyz);
    #else
        float totalWeight = 0.0;
        vec3 SampleCoords = ShadowSpace.xyz * 0.5f + 0.5f;
        vec3 ShadowAccum = vec3(0.0f);
        for(int x = -SHADOW_SAMPLES; x <= SHADOW_SAMPLES; x++){
            for(int y = -SHADOW_SAMPLES; y <= SHADOW_SAMPLES; y++){
                vec2 Offset = vec2(x, y) / SHADOW_RES;
                vec3 CurrentSampleCoordinate = vec3(SampleCoords.xy + Offset, SampleCoords.z);
                float weight = length(Offset);
                ShadowAccum += TransparentShadow(CurrentSampleCoordinate) * weight;
                totalWeight += weight;
            }
        }
        ShadowAccum /= totalWeight;
        return ShadowAccum;
    #endif
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

    return worldSpace.xyz;
}

vec2 worldToScreen(vec3 worldPos) {
    vec4 viewSpace = gbufferModelView * vec4(worldPos, 1.0);
    viewSpace /= viewSpace.w;
    vec4 clipSpace = gbufferProjection * viewSpace;
    clipSpace /= clipSpace.w;
    vec2 screenSpace = clipSpace.xy;

    return screenSpace;
}

vec3 screenToView(vec2 screenPos, float depth) {
    vec2 ndc = screenPos * 2.0 - 1.0;

    vec4 clipSpace = vec4(ndc, depth, 1.0);
    vec4 viewSpace = gbufferProjectionInverse * clipSpace;
    return viewSpace.xyz / viewSpace.w;
}

uniform bool isBiomeEnd;

vec3 cloudLight;
vec3 cloudAmbience;

vec3 sunlightAlbedo;

vec3 skyInfluenceColor;

float lightIntensity;

mediump float timeBlendFactor;

void noonFunc(float time, float timeFactor) {
    if(isBiomeEnd) {
        sunlightAlbedo = vec3(LIGHT_SE_R, LIGHT_SE_G, LIGHT_SE_B);
    } else {
        sunlightAlbedo = vec3(LIGHT_DAY_R, LIGHT_DAY_G, LIGHT_DAY_B);
    }
    mediump float dayNightLerp = smoothstep(250.0, 11750.0, float(worldTime) + fract(frameTimeCounter));
    cloudLight = vec3(VL_COLOR_R, VL_COLOR_G, VL_COLOR_B);
    cloudAmbience = vec3(AMBIENT_LIGHT_R, AMBIENT_LIGHT_G, AMBIENT_LIGHT_B);
    skyInfluenceColor = vec3(SKY_DAY_A_R, SKY_DAY_A_G, SKY_DAY_A_B);
    lightIntensity = LIGHT_DAY_I;
    timeBlendFactor = 0.0;
}

void sunsetFunc(float time, float timeFactor) {
    mediump float sunsetLerp = smoothstep(11750.0, 12250.0, float(worldTime) + fract(frameTimeCounter));
    if(isBiomeEnd) {
        sunlightAlbedo = vec3(LIGHT_SE_R, LIGHT_SE_G, LIGHT_SE_B);
    } else { sunlightAlbedo = mix3(vec3(LIGHT_DAY_R, LIGHT_DAY_G, LIGHT_DAY_B), vec3(LIGHT_SUNSET_R, LIGHT_SUNSET_G, LIGHT_SUNSET_B), vec3(LIGHT_NIGHT_R, LIGHT_NIGHT_G, LIGHT_NIGHT_B), sunsetLerp, 0.5);
    }
    cloudLight = mix3(vec3(VL_COLOR_R, VL_COLOR_G, VL_COLOR_B), vec3(AMBIENT_LIGHT_R, AMBIENT_LIGHT_G, AMBIENT_LIGHT_B), vec3(CLOUD_AMBIENCE_R, CLOUD_AMBIENCE_G, CLOUD_AMBIENCE_B), sunsetLerp, 0.5);
    cloudAmbience = mix2(vec3(AMBIENT_LIGHT_R, AMBIENT_LIGHT_G, AMBIENT_LIGHT_B), vec3(CLOUD_AMBIENCE_R, CLOUD_AMBIENCE_G, CLOUD_AMBIENCE_B), sunsetLerp);
    skyInfluenceColor = mix3(vec3(SKY_DAY_A_R, SKY_DAY_A_G, SKY_DAY_A_B), vec3(SKY_SUNSET_A_R, SKY_SUNSET_A_G, SKY_SUNSET_A_B), vec3(SKY_NIGHT_A_R, SKY_NIGHT_A_G, SKY_NIGHT_A_B), sunsetLerp, 0.5);
    lightIntensity = mix2(LIGHT_DAY_I, LIGHT_NIGHT_I, sunsetLerp);
    timeBlendFactor = sunsetLerp;
}

void nightFunc(float time, float timeFactor) {
    if(isBiomeEnd) {
        sunlightAlbedo = vec3(LIGHT_SE_R, LIGHT_SE_G, LIGHT_SE_B);
    } else { 
        sunlightAlbedo = vec3(LIGHT_NIGHT_R, LIGHT_NIGHT_G, LIGHT_NIGHT_B);
    }
    mediump float dayNightLerp = smoothstep(12250.0, 23750.0, float(worldTime) + fract(frameTimeCounter));
    cloudLight = vec3(CLOUD_AMBIENCE_R, CLOUD_AMBIENCE_G, CLOUD_AMBIENCE_B);
    cloudAmbience = vec3(CLOUD_AMBIENCE_R, CLOUD_AMBIENCE_G, CLOUD_AMBIENCE_B);
    skyInfluenceColor = vec3(SKY_NIGHT_A_R, SKY_NIGHT_A_G, SKY_NIGHT_A_B);
    lightIntensity = LIGHT_NIGHT_I;
    timeBlendFactor = 1.0;
}

void dawnFunc(float time, float timeFactor) {
    mediump float sunsetLerp = smoothstep(23750.0, 24250.0, float(worldTime) + fract(frameTimeCounter));
    if(worldTime < 250) sunsetLerp = smoothstep(-250.0, 250.0, float(worldTime) + fract(frameTimeCounter));
    if(isBiomeEnd) {
        sunlightAlbedo = vec3(LIGHT_SE_R, LIGHT_SE_G, LIGHT_SE_B);
    } else {
        sunlightAlbedo = mix3(vec3(LIGHT_NIGHT_R, LIGHT_NIGHT_G, LIGHT_NIGHT_B), vec3(LIGHT_SUNSET_R, LIGHT_SUNSET_G, LIGHT_SUNSET_B), vec3(LIGHT_DAY_R, LIGHT_DAY_G, LIGHT_DAY_B), sunsetLerp, 0.5);
    }
    cloudLight = mix3(vec3(CLOUD_AMBIENCE_R, CLOUD_AMBIENCE_G, CLOUD_AMBIENCE_B), vec3(AMBIENT_LIGHT_R, AMBIENT_LIGHT_G, AMBIENT_LIGHT_B), vec3(VL_COLOR_R, VL_COLOR_G, VL_COLOR_B), sunsetLerp, 0.5);
    cloudAmbience = mix2(vec3(CLOUD_AMBIENCE_R, CLOUD_AMBIENCE_G, CLOUD_AMBIENCE_B), vec3(AMBIENT_LIGHT_R, AMBIENT_LIGHT_G, AMBIENT_LIGHT_B), sunsetLerp);
    skyInfluenceColor = mix3(vec3(SKY_NIGHT_A_R, SKY_NIGHT_A_G, SKY_NIGHT_A_B), vec3(SKY_SUNSET_A_R, SKY_SUNSET_A_G, SKY_SUNSET_A_B), vec3(SKY_DAY_A_R, SKY_DAY_A_G, SKY_DAY_A_B), sunsetLerp, 0.5);
    lightIntensity = mix2(LIGHT_NIGHT_I, LIGHT_DAY_I, sunsetLerp);
    timeBlendFactor = 1 - sunsetLerp;
}

vec4 vanillaLight(in vec2 Lightmap) {
    const vec3 TorchColor = vec3(1.0f, 1.0f, 1.0f);
    vec4 lightColor = vec4(TorchColor * Lightmap.x,1.0);
    return lightColor;
}

vec3 blurNormals(vec2 uv, float radius, int sampleRadius) {
    vec3 baseNormal = texture2D(colortex1, uv).xyz * 2 - 1;
    vec3 accum = baseNormal;
    float depth = getDepthMask(depthtex1, colortex13, uv);
    float trueDepth = depth*dhFarPlane;

    float isFoliage = 1 - texture2D(colortex13, uv).b;

    float sampleAspect = 1.0/float(viewHeight) * float(viewWidth);

    float weight = 0.0;

    for(int x = -sampleRadius; x < sampleRadius; x++) {
        for(int y = -sampleRadius; y < sampleRadius; y++) {
            vec2 offset = vec2(x, y)/(vec2(sampleRadius * sampleAspect, sampleRadius)) * radius/1080.0 * (1 - depth);
            vec2 sampleUV = uv + offset;

            float offsetDepth = getDepthMask(depthtex1, colortex13, sampleUV);
            float trueOffsetDepth = offsetDepth*dhFarPlane;

            if(abs(trueDepth - trueOffsetDepth) > 25.0) continue;

            float isSampleFoliage = 1 - texture2D(colortex13, sampleUV).b;

            float sampleWeight = 1 - clamp(length(offset)/radius,0,1) * 1 - (abs(isFoliage - isSampleFoliage));
            vec3 sampleNormal = texture2D(colortex1, sampleUV).xyz * 2 - 1;
            accum += sampleNormal * sampleWeight;
            weight += sampleWeight;
        }
    }
    return accum/(weight + 1.0);
}

out vec3 VertNormal;

#include "lib/world/timeCycle.glsl"

uniform sampler2D cloudnormal;

#include "lib/world/clouds.glsl"

#define PT_THRESHOLD 0.1
#define PT_BOUNCE_COUNT 32

#if LIGHTING_MODE == 2
    #include "lib/lighting/pathTracing.glsl"
#endif

/* RENDERTARGETS:0,1,2,3,4,5,6,14 */
layout(location = 0) out vec4 outcolor;
layout(location = 1) out vec4 outnormal;

void main() {
    timeFunctionFrag();
    vec3 color = pow2(texture2D(colortex0, texCoord).rgb,vec3(GAMMA));
    vec3 sky_color = textureLod(colortex0, texCoord,6).rgb;
    mediump float depth = texture2D(depthtex0, texCoord).r;
    mediump float depth2 = texture2D(depthtex1, texCoord).r;
    mediump float depth3 = getDepthMask(depthtex1, colortex13);
    mediump float waterTest = texture2D(colortex5, texCoord).r;

    vec3 Normal = normalize2(texture2D(colortex1, texCoord).rgb * 2.0f -1.0f);

    vec3 shadowLightDirection = normalize2(mat3(gbufferModelViewInverse) * shadowLightPosition);
    
    //shadowLightDirection = abs(shadowLightDirection);

    mediump float cloud_time = fract(CLOUD_SPEED * float(worldTime)/12000);

    vec4 finalLight = vec4(0.0);

    vec3 softNormal = blurNormals(texCoord, 15.0, 2);

    mediump float lightMask = dot(shadowLightDirection, Normal);
    lightMask = clamp(lightMask, 0.0, 1.0);

    mediump float sunlightMask = dot(normalize2(mat3(gbufferModelViewInverse) * sunPosition), Normal);
    sunlightMask = clamp(sunlightMask, 0.0, 1.0);

    vec3 sunLight = sunlightAlbedo * sunlightMask;

    vec2 lightmap = 1 - texture2D(colortex13, texCoord).rg;
    mediump float isCave = smoothstep(0.0, 0.9, lightmap.g);

    mediump float isFoliage = 1 - texture2D(colortex13, texCoord).b;

    vec3 sunWorldPos = mat3(gbufferModelViewInverse) * sunPosition;

    vec4 sunClipPos = gbufferProjection * vec4(sunPosition,1.0);
    vec3 sunNDC = sunClipPos.xyz / sunClipPos.w;
    vec2 sunScreenPos = sunNDC.xy * 0.5 + 0.5;

    //mediump float timeDistance = abs(worldTime - 6000);
    //mediump float maxTimeDistance = 6000.0;
    //mediump float timeBlendFactor = smoothstep(0.75,1.0,timeDistance/maxTimeDistance);

    mediump float detectSky = texture2D(colortex5, texCoord).g;

    mediump float lightBlend = (1 - timeBlendFactor) * isCave;

    mediump float minLight = mix2(MIN_LIGHT, MIN_FOLIAGE_LIGHT, step(isFoliage, 0.5));

    vec3 shadowLerp = mix2(GetShadow(depth2),vec3(0.0),timeBlendFactor);
    shadowLerp = mix2(shadowLerp, vec3(0.0), rainStrength);
    if(depth2 >= 1.0) shadowLerp = vec3(1.0 - timeBlendFactor);

    /*vec3 ambientLight = mix2(vec3(AMBIENT_LIGHT_R, AMBIENT_LIGHT_G, AMBIENT_LIGHT_B)*SHADOW_BRIGHTNESS, sunlightAlbedo*1.5, max(vec3(step(isFoliage, 0.5)),shadowLerp));

    if(isFoliage < 1.0 || texture2D(colortex12, texCoord).g > 0.5) ambientLight = mix2(vec3(AMBIENT_LIGHT_R, AMBIENT_LIGHT_G, AMBIENT_LIGHT_B)*SHADOW_BRIGHTNESS, sunlightAlbedo*1.5, 1 - shadowLerp);

    vec3 totalSunlight = mix2(sunLight*0.9, vec3(0.0),1 - shadowLerp.x * lightMask);
    if(isFoliage < 1.0 || texture2D(colortex12, texCoord).g > 0.5) totalSunlight = mix2(sunlightAlbedo*0.9, vec3(0.0),1 - shadowLerp.x);
    if(detectSky != 1.0 && depth2 == 1.0) {
        totalSunlight = vec3(0);
    }*/

    vec3 totalSunlight = mix2(sunlightAlbedo*0.9,vec3(AMBIENT_LIGHT_R, AMBIENT_LIGHT_G, AMBIENT_LIGHT_B)*SHADOW_BRIGHTNESS*2, 1 - clamp(length(shadowLerp),0,1));
    totalSunlight = mix2(totalSunlight, vec3(LIGHT_NIGHT_R, LIGHT_NIGHT_G, LIGHT_NIGHT_B)*1.5,timeBlendFactor);
    if(detectSky == 1.0 && depth2 == 1.0) {
        totalSunlight = vec3(0);
    }
    mediump float detectEntity = texture2D(colortex12, texCoord).g;

    //vec3 naturalLight = mix2(sky_color * lightIntensity, ambientLight*minLight, smoothstep(0.0, 0.4, pow2(lightmap.g,1/2.2)));

    vec3 dynamicLight = vec3(0.0);

    vec4 cloudsNormal;
    
    if(depth2 == 1.0) {
        #if CLOUD_STYLE == 1
            vec4 pos = vec4(texCoord, depth, 1.0) * 2.0 - 1.0;
            pos.xyz = projectAndDivide(gbufferProjectionInverse,pos.xyz);
            vec3 view_pos = pos.xyz;
            pos = gbufferModelViewInverse * vec4(pos.xyz, 1.0);
            vec3 rayDir = normalize2(pos.xyz);

            vec2 uv = rayDir.xz*0.25/rayDir.y;
            vec2 uv2 = pos.xz*0.001+frameTimeCounter*0.1;

            vec3 p = vec3(uv, 0);

            p.xy -= cloud_time;
            p.xy = fract(p.xy);

            vec4 clouds = vec4(0.0);

            vec3 light = vec3(0.0);

            clouds = renderVolumetricClouds(p, rayDir, normalize2(sunPosition));

            light = lightCalc.xyz;

            if(detectSky == 1.0) {
                color.rgb = mix2(color.rgb, clouds.rgb,clouds.a);
            }

            #if LIGHTING_MODE > 0 && defined BLOOM
                if(detectSky == 1.0) {
                    #ifdef VOLUMETRIC_LIGHTING
                        finalLight = vec4(mix2(light, texture2D(colortex2, texCoord).xyz*texture2D(colortex2, texCoord).a + light, 1 - clouds.a),texture2D(colortex2, texCoord).a);
                    #else
                        finalLight = vec4(mix2(vec3(0.0), texture2D(colortex2, texCoord).xyz, 1 - clouds.a),1.0);
                    #endif
                }
            #else
                finalLight = vec4(texture2D(colortex2, texCoord).xyz*2.5, 1.0);
            #endif
        #endif
    } else {
        #if LIGHTING_MODE == 1
            dynamicLight = pow2(texture2D(colortex2, texCoord).xyz, vec3(GAMMA));
            if(waterTest > 0 || detectEntity > 0) dynamicLight *= GAMMA * GAMMA;
            #if SCENE_AWARE_LIGHTING == 1
                dynamicLight = blurLight(colortex2, depthtex1, texCoord, 4.0, 64, 4.0, 1.0)*4.0;
            /*#elif SCENE_AWARE_LIGHTING == 2
                //dynamicLight = blurLight(colortex2, depthtex1, texCoord, 4.0, 16, 4.0, 0.1)*4;
                int lightLength = int(sqrt(LIGHT_SAMPLE_COUNT));
                vec2 screenRes = vec2(1080/viewHeight * viewWidth, 1080);
                dynamicLight = pow2(texture2D(colortex2, texCoord).xyz,vec3(GAMMA*GAMMA));
                float totalWeight = 0.0;
                for(int i = 0; i < LIGHT_SAMPLE_COUNT; i++) {
                    int x = int(mod(i,lightLength) - lightLength/2);
                    int y = i/lightLength - lightLength/2;
                    
                    vec2 offset = vec2(x,y)/screenRes * (100/lightLength) / linearizeDepth(texture2D(depthtex1, texCoord).x, near, far);
                    float weight = clamp(length(offset)/100,0,1);
                    dynamicLight += pow2(texture2D(colortex2, texCoord + offset).xyz,vec3(GAMMA*GAMMA)) * weight;
                    totalWeight += weight;
                }
                dynamicLight /= totalWeight;
                dynamicLight *= 4;
                if(waterTest > 0) dynamicLight *= GAMMA * GAMMA;
                dynamicLight = min(dynamicLight, vec3(MAX_LIGHT));*/
            #endif
        #endif
    }

    /*for(float t = 0.0; t < 1.0; t += stepSize) {
        vec2 sampleUV = clamp(texCoord + worldToScreen(scatterDir) * t,0,1);
        vec3 sampleLight = sunlightAlbedo;
        scattered += sampleLight * pow2(decay, t / stepSize);
    }*/

    #if LIGHTING_MODE == 1
        if(detectSky < 1.0 || depth2 < 1.0) {
            vec2 res = vec2(1080/viewHeight * viewWidth, 1080);
            /*vec3 bounce =
            (texture2D(colortex0, texCoord + vec2( 2, 1)/res).rgb +
            texture2D(colortex0, texCoord + vec2(-2, 1)/res).rgb +
            texture2D(colortex0, texCoord + vec2( 0, 3)/res).rgb)/3;*/

            mediump float shadowBright = SHADOW_BRIGHTNESS;
            
            //vec4 vanilla = vanillaLight(1 - lightmap);
            mediump float shadowSize = length(shadowLerp);
            if(depth >= 1.0) shadowSize = 1.0 - timeBlendFactor;
            //mediump float dynamicLightBlend = 1 - smoothstep(minLight, 1.0, length(vanilla) - length(finalLight));
            //dynamicLightBlend = mix2(dynamicLightBlend * isCave,1.0, step(isFoliage, 0.5));
            //vec4 scatterLight = vec4(dynamicLightBlend * scattered * (1 - step(1.0, getDepthMask(depthtex0, cSampler11))) * (1 - timeBlendFactor) * mix2(dot(sunWorldPos, Normal), 1.0, step(isFoliage, 0.5)), 1.0);
            //scatterLight = mix2(scatterLight, vec4(vec3(0.0),1.0), 1 - shadowSize);
            //finalLight = mix2(finalLight, vanilla*0.75, dynamicLightBlend);
            //finalLight += scatterLight;
            //vec3 lightVariation = 0.875 + lightNoise(worldPos, Normal) * 0.25;
            //if(isBiomeEnd) lightVariation = 0.75 + lightNoise(worldPos, Normal) * 0.5;
            //finalLight.xyz *= lightVariation + bounce * 0.25;

            //if(texture2D(depthtex1, texCoord).x >= 1.0 && texture2D(depthtex0, texCoord).x < 1.0) finalLight.xyz = vec3(0.0);

            vec3 viewNormal = normalize2((gbufferModelView * vec4(Normal.xyz, 1.0)).xyz);
            vec3 viewDir = normalize2(screenToView(texCoord, depth));

            vec3 sunViewDir = normalize2(sunPosition);

            vec3 worldPos = screenToWorld(texCoord, depth);

            float distanceFromCamera = distance(cameraPosition*2.0, worldPos);

            float haze = clamp(pow2(getDistMask(colortex6) /70.0,0.75), 0.0, 1.0);

            float fresnel = pow2(1.0 - dot(Normal, viewDir),2.0);

            float spec = pow2(max(dot(reflect(sunViewDir,abs(viewNormal)),viewDir),0.0),1.0) * 0.03;
            spec *= mix2(0.3, 1.0, fresnel);

            float grazing = pow2(1.0 - abs(dot(viewNormal, viewDir)),0.75);

            float lightVariation = triplanarTexture(worldPos, Normal, noisec, 0.05).x;

            mediump float lightBlend2 = max(lightBlend * (1 - isCave),timeBlendFactor);

            //if(depth == 1.0 && detectSky == 0.0) lightBlend2 = 0.0;

            finalLight.xyz += mix2(totalSunlight, vec3(0.0), lightBlend2);

            finalLight.xyz = mix2(finalLight.xyz, vec3(LIGHT_NIGHT_R, LIGHT_NIGHT_G,LIGHT_NIGHT_B)*LIGHT_NIGHT_I, timeBlendFactor);

            if(depth >= 1.0) finalLight.xyz *= mix2(1.0, 0.5, timeBlendFactor);

            finalLight.xyz = mix2(finalLight.xyz, vec3(AMBIENT_LIGHT_R, AMBIENT_LIGHT_G, AMBIENT_LIGHT_B)*MIN_LIGHT, isCave);

            if(isBiomeEnd) {
                //scatterLight *= 0.0025;
                finalLight *= 0.6;
            }

            finalLight.w = 1.0;

            //if(depth2 == 1.0) finalLight *= (1 - texture2D(colortex10, texCoord).x);

            finalLight.xyz += min(dynamicLight*8, vec3(MAX_LIGHT));
            if(depth2 < 1.0) finalLight.xyz /= 3; else finalLight.xyz /= 1.5;

            finalLight.xyz += spec * (1 - lightBlend2);

            finalLight.xyz *= mix2(mix2(0.85, 1.15, grazing),1.0, 1 - lightBlend2);

            if(detectSky == 0.0 || depth2 < 1.0) finalLight.xyz *= mix2(0.9, 1.1, lightVariation);

            //if(texture2D(colortex12, texCoord).b == 1.0 && depth2 != 1.0) finalLight.xyz = vec3(0.0);

            if(!isBiomeEnd) color.xyz = mix2(color.xyz, skyInfluenceColor, haze*0.05);

            if(detectSky == 1.0 && depth2 == 1.0) finalLight.xyz = dynamicLight;
        }

        if(detectEntity == 1.0) finalLight.xyz *= 0.65;
        /*mediump float lightBlend2 = max(1 - length(shadowLerp),timeBlendFactor);
        if(depth == 1.0 && detectSky == 0.0) lightBlend2 = 0.0;
        finalLight += vec4(mix2(totalSunlight*1.25, ambientLight*shadowBright * 0.75,lightBlend2),1.0);
        if(texture2D(depthtex1, texCoord).x < 1.0) finalLight.xyz = mix2(finalLight.xyz, ambientLight*minLight, isCave);
        finalLight.xyz = max(finalLight.xyz, naturalLight);
        //finalLight.a = 1.0;
        if(texture2D(depthtex1, texCoord).x < 1.0 || (texture2D(colortex12, texCoord).g == 1.0 && texture2D(depthtex1, texCoord).x >= 1.0)) finalLight.xyz += min(dynamicLight*4, vec3(MAX_LIGHT));
        //if(isFoliage < 1.0 || texture2D(colortex12, texCoord).g > 0.5) finalLight.xyz *= max(vec3(AMBIENT_LIGHT_R,AMBIENT_LIGHT_G,AMBIENT_LIGHT_B) * shadowBright, shadowLerp);
        if(texture2D(colortex12, texCoord).g > 0.5) finalLight *= max(shadowBright * 2.25, shadowSize * mix2(0.25, 1.0, clamp(dot(sunWorldPos, texture2D(colortex1, texCoord).xyz * 2 - 1),0,1)));
        finalLight *= mix2(0.9, 0.95, 1 - shadowSize);
        if(detectEntity > 0) finalLight.xyz = max(finalLight.xyz, ambientLight*minLight * 2.2);
        finalLight.xyz = mix2(finalLight.xyz, mix2(totalSunlight*1.25, ambientLight*shadowBright * 0.75,lightBlend2), texture2D(colortex12, texCoord).b);
        //finalLight.xyz = lightFlicker(finalLight.xyz);
        finalLight.xyz *= 1.0 + 0.1 * calcRandom3D(worldPos, fract(frameTimeCounter*3.75));
        finalLight.xyz += spec * shadowLerp;
        finalLight.xyz *= mix2(mix2(0.85, 1.15, grazing),1.0, shadowLerp.x);
        finalLight.xyz *= mix2(0.9, 1.1, lightVariation);
        lightMask *= length(shadowLerp) * isCave;*/
        //finalLight.xyz *= 0.99 + lightVariationNoise(texCoord) * 0.05;
        //if(waterTest > 0) finalLight.xyz = texture2D(colortex2, texCoord).xyz*16;

        color.xyz = blindEffect(color.xyz, texCoord);
    #elif LIGHTING_MODE == 2
        vec3 worldPos = screenToWorld(texCoord, depth);
        vec3 throughput = color.xyz;
        vec3 radiance = vec3(0.0);

        vec3 outPos = vec3(0.0);
        vec3 outNormal = vec3(0.0);

        vec2 rand = vec2(calcRandom3D(worldPos, frameTimeCounter),calcRandom3D(worldPos - 1, frameTimeCounter));

        for (int bounce = 0; bounce < PT_BOUNCE_COUNT; bounce++) {

            vec3 dir = sampleHemisphere(Normal, rand * 2 - 1);
            vec3 hitPos;

            if (!rayMarch(worldPos, dir, hitPos)) {
                radiance += throughput * skyInfluenceColor;
                break;
            }

            vec2 hitUV = worldToScreen(hitPos);

            vec3 hitColor = texture2D(colortex0, hitUV).rgb;
            vec3 hitNormal = texture2D(colortex1, hitUV).xyz * 2 - 1;

            radiance += throughput * texture3D(colortex2, hitUV).xyz;

            throughput *= hitColor;
            outPos = hitPos;
            outNormal = hitNormal;
        }
        
        if(detectSky == 0.0 || depth2 < 1.0) finalLight = vec4(pow2(radiance,vec3(1/GAMMA)),1.0);
    #endif

    outcolor = vec4(pow2(color.xyz, vec3(1/GAMMA)), 1.0);
    gl_FragData[2] = finalLight;
    gl_FragData[3] = texture2D(colortex3, texCoord);
    gl_FragData[4] = texture2D(colortex4, texCoord);
    gl_FragData[5] = texture2D(colortex5, texCoord);
    gl_FragData[6] = texture2D(colortex6, texCoord);
    gl_FragData[7] = vec4(shadowLerp, 1.0);
}