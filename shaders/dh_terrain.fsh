#version 460 compatibility
#include "lib/commonFunctions.glsl"

#define DISTANT_HORIZONS
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

#define MIN_LIGHT 0.05f // [0.0f 0.05f 0.1f 0.15f 0.2f 0.25f 0.3f 0.35f 0.4f 0.45f 0.5f]

#define SE_MIN_LIGHT 0.05f // [0.0f 0.05f 0.1f 0.15f 0.2f 0.25f 0.3f 0.35f 0.4f 0.45f 0.5f]

#define MAX_LIGHT 1.5f // [1.0f 1.1f 1.2f 1.3f 1.4f 1.5f 1.6f 1.7f 1.8f 1.9f 2.0f 2.1f 2.2f 2.3f 2.4f 2.5f 2.6f 2.7f 2.8f 2.9f 3.0f 3.1f 3.2f 3.3f 3.4f 3.5f 3.6f 3.7f 3.8f 3.9f 4.0f 4.1f]

#define SE_MAX_LIGHT 2.0f // [1.0f 1.1f 1.2f 1.3f 1.4f 1.5f 1.6f 1.7f 1.8f 1.9f 2.0f 2.1f 2.2f 2.3f 2.4f 2.5f 2.6f 2.7f 2.8f 2.9f 3.0f 3.1f 3.2f 3.3f 3.4f 3.5f 3.6f 3.7f 3.8f 3.9f 4.0f 4.1f]

#define FRAGMENT_SHADER

#define PATH_TRACING_GI 0 // [0 1]

#define PATH_TRACING_GI

#define AO_WIDTH 0.1 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

#define GAMMA 2.2 // [1.0 1.2 1.4 1.6 1.8 2.0 2.2 2.4 2.6 2.8 3.0]

#include "lib/globalDefines.glsl"

#include "lib/includes2.glsl"
#include "lib/optimizationFunctions.glsl"
#include "program/blindness.glsl"

precision mediump float;

uniform usampler3D cSampler3;

uniform sampler2D lightmap;
uniform sampler2D depthtex0;
uniform sampler2D depthtex1;
uniform float viewWidth;
uniform float viewHeight;
uniform vec3 fogColor;

uniform sampler2D noises;

uniform sampler2D colortex0;

varying float timePhase;
varying float quadTime;
uniform int worldTime;
uniform int frameCounter;
uniform float frameTime;

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferProjection;
uniform mat4 gbufferModelViewInverse;

uniform bool isBiomeEnd;

uniform vec3 cameraPosition;

uniform vec3 shadowLightPosition;

uniform float near;
uniform float far;
uniform float dhNearPlane;
uniform float dhFarPlane;

/* RENDERTARGETS:0,2,6,5,1,12,15 */
layout(location = 0) out vec4 outColor0;
layout(location = 1) out vec4 outColor2;
layout(location = 2) out vec4 fogOut;
layout(location = 3) out vec4 isWater;
layout(location = 4) out vec4 normal;
layout(location = 5) out vec4 dataTex0;
layout(location = 6) out vec4 camDist;

in vec4 blockColor;
in vec2 lightmapCoords;

in vec3 playerPos;

in float isWaterBlock;

in vec3 Normal;
in vec3 Tangent;

in vec3 block_centered_relative_pos;

in vec3 lightmap2;

in vec4 at_midBlock2;

in float isFoliage;

in float isReflective;

in vec3 worldSpaceVertexPosition;

in vec3 normals_face_world;

in vec3 foot_pos;

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
    //SkyColor = currentColor;
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
    if(lightmap2.x > 0) {
        TorchLighting = TorchColor * lightmap2.x;
    }
    if(lightmap2.x < 0) {
        GlowstoneLighting = GlowstoneColor * -lightmap2.x;
    }
    if(lightmap2.y > 0) {
        LampLighting = LampColor * lightmap2.y;
    }
    if(lightmap2.y < 0) {
        LanternLighting = LanternColor * -lightmap2.y;
    }
    if(lightmap2.z > 0) {
        RedstoneLighting = RedstoneColor * lightmap2.z;
    }
    if(lightmap2.z < 0) {
        RodLighting = RodColor * -lightmap2.z;
    }
    vec3 LightmapLighting = TorchLighting + GlowstoneLighting + LampLighting + LanternLighting + RedstoneLighting + RodLighting + SkyLighting;
    return LightmapLighting;
}

#include "program/pathTracing.glsl"

vec3 aces(vec3 x) {
  mediump float a = 2.51;
  mediump float b = 0.03;
  mediump float c = 2.43;
  mediump float d = 0.59;
  mediump float e = 0.14;
  return clamp((x * (a * x + b)) / (x * (c * x + d) + e), 0.0, 1.0);
}

vec3 unreal(vec3 x) {
  return x / (x + 0.155) * 1.019;
}

vec3 screenToView(vec3 screenPos) {
    vec4 ndcPos = vec4(screenPos, 1.0) * 2.0 - 1.0;
    vec4 tmp = gbufferProjectionInverse * ndcPos;
    return tmp.xyz / tmp.w;
}

vec3 screenToWorld(vec3 screenPos) {
    vec4 ndcPos = vec4(screenPos, 1.0) * 2.0 - 1.0;
    vec4 tmp = gbufferProjectionInverse * ndcPos;
    tmp = gbufferModelViewInverse * tmp;
    return tmp.xyz / tmp.w;
}

mediump float Noise3D(vec3 p) {
    p.z = fract(p.z) * 128.0;
    mediump float iz = floor(p.z);
    mediump float fz = fract(p.z);
    vec2 a_off = vec2(23.0, 29.0) * (iz) / 128.0;
    vec2 b_off = vec2(23.0, 29.0) * (iz + 1.0) / 128.0;
    mediump float a = texture2D(noises, p.xy + a_off).r;
    mediump float b = texture2D(noises, p.xy + b_off).r;
    return mix2(a, b, fz);
}

mediump float linearizeDepth(float depth, float near, float far) {
    return (near * far) / (depth * (near - far) + far);
}

void main() {
    vec3 shadowLightDirection = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);

    vec3 worldNormal = mat3(gbufferModelViewInverse) * Normal;

    mediump float lightBrightness = clamp(dot(shadowLightDirection, worldNormal),max(0.2, MIN_LIGHT),MAX_LIGHT);

    if(isBiomeEnd) {
        lightBrightness = clamp(dot(shadowLightDirection, worldNormal),max(0.2, SE_MIN_LIGHT),SE_MAX_LIGHT);
    }

    vec4 outputColorData = blockColor;
    vec3 outputColor = pow2(outputColorData.rgb,vec3(GAMMA));
    
    mediump float alpha = outputColorData.a;

    vec2 texCoord = gl_FragCoord.xy / vec2(viewWidth, viewHeight);

    mediump float depth = texture2D(depthtex0, texCoord).r;
    mediump float dhDepth = gl_FragCoord.z;
    mediump float depthLinear = linearizeDepth(depth, near, far*4);
    mediump float dhDepthLinear = linearizeDepth(dhDepth, dhNearPlane, dhFarPlane);

    if(alpha >= 0.1 && depth >= dhDepth && depth == 1) {
        mediump float distanceFromCamera = distance(viewSpaceFragPosition, vec3(0.0));

        //outputColor *= lightBrightness;

        isWater = vec4(0.0);

        if(blindness > 0f) {
            outputColor.xyz = blindEffect(outputColor.xyz);
        }

        mediump float fogBlend = pow2(smoothstep(0.9,1.0,dhDepth),4.2);

        fogOut = vec4(0.0, fogBlend, 0.0, 1.0);
        //outputColor.xyz = mix2(outputColor, fogColor, fogBlend);

        outColor0 = vec4(pow2(outputColor.xyz,vec3(1/GAMMA)), alpha);

        normal = vec4(worldNormal * 0.5 + 0.5, 1.0);
        dataTex0 = vec4(1.0);
        camDist = vec4(distanceFromCamera, vec2(0.0), 1.0);

        outColor2 = vec4(vec3(0.0), 1.0f);
        /*#ifndef SCENE_AWARE_LIGHTING
            outColor2 = vec4(LightmapCoords.x, LightmapCoords.x, LightmapCoords.y, 1.0f);
        #else
            #define VOXEL_AREA 128 //[32 64 128]
            #define VOXEL_RADIUS (VOXEL_AREA/2)
            ivec3 voxel_pos = ivec3(block_centered_relative_pos+VOXEL_RADIUS);
            vec3 light_color = vec3(0.0);// = texture3D(cSampler1, vec3(foot_pos+2.0*normals_face_world+fract(cameraPosition) + VOXEL_RADIUS)).rgb;
            if(clamp(voxel_pos,0,VOXEL_AREA) == voxel_pos) {
                vec4 bytes = unpackUnorm4x8(texture3D(cSampler3,vec3(voxel_pos)/vec3(VOXEL_AREA)).r);
                light_color = bytes.xyz;
            }

            outColor2 = mix2(vec4(0.0), vec4(light_color, 1.0), step(0.999, depth));
        #endif*/
    }
}