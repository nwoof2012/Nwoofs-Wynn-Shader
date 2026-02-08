#version 460 compatibility

#define FRAGMENT_SHADER

//#define SHADER_CLOUDS

#define CLOUD_SPEED_A 0.1f // [0.05f 0.1f 0.15f 0.2f 0.25f 0.3f 0.35f 0.4f 0.45f 0.5f]
#define CLOUD_SPEED_B 0.05f // [0.05f 0.1f 0.15f 0.2f 0.25f 0.3f 0.35f 0.4f 0.45f 0.5f]

#define CLOUD_SCALE_A 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
#define CLOUD_SCALE_B 2.0f // [1.5f 1.6f 1.7f 1.8f 1.9f 2.0f 2.1f 2.2f 2.3f 2.4f 2.5f]

#define CLOUD_COLOR_A_R 1.0f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define CLOUD_COLOR_A_G 1.0f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define CLOUD_COLOR_A_B 1.0f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]

#define CLOUD_COLOR_B_R 0.2f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define CLOUD_COLOR_B_G 0.2f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define CLOUD_COLOR_B_B 0.2f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]

#define CLOUD_COLOR_RAIN_A_R 0.2f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define CLOUD_COLOR_RAIN_A_G 0.2f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define CLOUD_COLOR_RAIN_A_B 0.2f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]

#define CLOUD_COLOR_RAIN_B_R 0.0f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define CLOUD_COLOR_RAIN_B_G 0.0f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define CLOUD_COLOR_RAIN_B_B 0.0f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]

precision mediump float;

varying vec2 TexCoords;

uniform float viewWidth;
uniform float viewHeight;

flat in int worldTime2;
uniform int frameCounter;
uniform float frameTime;
uniform vec3 fogColor;
uniform vec3 skyColor;

uniform bool isBiomeEnd;
uniform bool isBiomeDry;

uniform sampler2D colortex11;

uniform sampler2D moon;

uniform float rainStrength;

uniform sampler2D noisetex;

uniform sampler2D depthtex0;

in vec4 starData;

flat in vec3 upVec, sunVec;

uniform vec3 sunPosition;
uniform vec3 moonPosition;

uniform float aspectRatio;

#include "lib/dither.glsl"

vec3 dayColorA;
vec3 dayColorB;

vec3 dayColorRainA;
vec3 dayColorRainB;
vec3 nightColorA;
vec3 nightColorB;
vec3 transitionColorA;
vec3 transitionColorB;

vec3 currentColorA;
vec3 currentColorB;

uniform float blindness;

layout (rgba8) uniform image2D cimage11;

#include "lib/globalDefines.glsl"
#include "lib/includes2.glsl"
#include "lib/optimizationFunctions.glsl"

mediump float fogify(float x, float w) {
    return w / (x * x + w);
}

vec3 aces(vec3 x) {
  mediump float a = 2.51;
  mediump float b = 0.03;
  mediump float c = 2.43;
  mediump float d = 0.59;
  mediump float e = 0.14;
  return clamp((x * (a * x + b)) / (x * (c * x + d) + e), 0.0, 1.0);
}

vec3 calcSkyColor(vec3 pos, vec3 currentColorA, vec3 currentColorB, vec4 noiseColor) {
    mediump float upDot = dot(pos, gbufferModelView[1].xyz);
    mediump float lerpAmount = fogify(max(clamp(upDot,0,1),0.0), 0.25);
    vec3 sky = mix2(currentColorB, currentColorA, lerpAmount);
    mediump float lerpAmount2 = clamp(lerpAmount * 2 - 1, 0, 1);
    vec3 cloudColorA = vec3(CLOUD_COLOR_A_R, CLOUD_COLOR_A_G, CLOUD_COLOR_A_B);
    vec3 cloudColorB = vec3(CLOUD_COLOR_B_R, CLOUD_COLOR_B_G, CLOUD_COLOR_B_B);
    if(rainStrength > 0.2f && !isBiomeDry) {
        cloudColorA = mix2(cloudColorA,1/vec3(CLOUD_COLOR_RAIN_A_R, CLOUD_COLOR_RAIN_A_G, CLOUD_COLOR_RAIN_A_B), (rainStrength - 0.2)/0.8);
        cloudColorB = mix2(cloudColorB,vec3(CLOUD_COLOR_RAIN_B_R, CLOUD_COLOR_RAIN_B_G, CLOUD_COLOR_RAIN_B_B),(rainStrength - 0.2)/0.8);
    }
    vec3 clouds = pow2(mix2(cloudColorA, cloudColorB, noiseColor.y),vec3(-1.5));
    vec3 cloudSky = mix2(sky,mix2(sky, clouds, noiseColor.y), pow2(1-lerpAmount2, 1/GAMMA));
    #ifdef SHADER_CLOUDS
        return cloudSky;
    #else
        return sky;
    #endif
}

vec3 screenToView(vec3 screenPos) {
    vec4 ndcPos = vec4(screenPos, 1.0) * 2.0 - 1.0;
    vec4 tmp = gbufferProjectionInverse * ndcPos;
    return tmp.xyz / tmp.w;
}

/* DRAWBUFFERS:052 */
layout(location = 0) out vec4 outputColor;

void noonFunc(float time, float timeFactor) {
    mediump float dayNightLerp = clamp(time/timeFactor,0,1);
    if(rainStrength < 0.2f || isBiomeDry) {
        currentColorA = dayColorA;
        currentColorB = mix2(transitionColorB,dayColorB,dayNightLerp);
    } else {
        currentColorA = dayColorRainA;
        currentColorB = mix2(transitionColorB,dayColorRainB,dayNightLerp);
    }
}

void sunsetFunc(float time, float timeFactor) {
    mediump float sunsetLerp = clamp(time/timeFactor,0,1);
    if(rainStrength < 0.2f || isBiomeDry) {
        currentColorA = mix2(dayColorA, nightColorA, sunsetLerp);
        currentColorB = mix2(dayColorB, transitionColorB, sunsetLerp);
    } else {
        currentColorA = mix2(dayColorRainA, nightColorA, sunsetLerp);
        currentColorB = mix2(dayColorRainB, transitionColorB, sunsetLerp);
    }
}

void nightFunc(float time, float timeFactor) {
    mediump float dayNightLerp = clamp(time/timeFactor,0,1);
    currentColorA = nightColorA;
    currentColorB = mix2(transitionColorB,nightColorB,dayNightLerp);
}

void dawnFunc(float time, float timeFactor) {
    mediump float sunsetLerp = clamp(time/timeFactor,0,1);
    if(rainStrength < 0.2f || isBiomeDry) {
        currentColorA = mix2(nightColorA, dayColorA, sunsetLerp);
        currentColorB = mix2(nightColorB, transitionColorB, sunsetLerp);
    } else {
        currentColorA = mix2(nightColorA, dayColorRainA, sunsetLerp);
        currentColorB = mix2(nightColorB, transitionColorB, sunsetLerp);
    }
}

vec3 getMoonCoords(float scale) {
    vec2 texCoord = gl_FragCoord.xy / vec2(viewWidth, viewHeight);

    mediump float depth = texture2D(depthtex0, texCoord * scale).r;

    vec3 ClipSpace = vec3(TexCoords * scale, depth * scale) * 2.0f - 1.0f;
    vec4 ViewW = gbufferProjectionInverse * vec4(ClipSpace, 1.0f);
    vec3 View = ViewW.xyz / ViewW.w;
    //View += sunPosition;
    vec4 World = gbufferModelViewInverse * vec4(View, 1.0f);

    vec2 ndc = texCoord * 2.0 - 1.0;

    vec4 clip = vec4(ndc, -1.0, 1.0);

    vec4 sunViewPos = vec4(sunPosition, 1.0);
    vec4 sunClipPos = sunViewPos;
    
    vec3 sunNDC = sunClipPos.xyz / sunClipPos.w;

    vec2 sunScreenPos = sunNDC.xy * 0.5 + 0.5;

    vec2 sunCoords = (sunPosition.xy + 1.0) * 0.5;

    vec3 sunWorldPos = (gbufferModelViewInverse * sunViewPos).xyz;

    vec4 viewSpace = gbufferProjectionInverse * clip;
    //viewSpace.xyz += sunPosition;

    vec3 direction = normalize2(viewSpace.xyz / viewSpace.w);
    //direction += normalize2(sunPosition);

    vec3 transformedDir = (gbufferModelViewInverse * vec4(direction, 0.0)).xyz;

    return transformedDir + normalize2(sunWorldPos) + 0.5f;
}

vec2 moonUVs(vec3 moonDir, vec3 viewDir, float radius) {
    vec3 offset = normalize2(viewDir - dot(viewDir, moonDir) * moonDir);
    vec3 moonRight = normalize2(cross(moonDir, vec3(0.0, 1.0, 0.0)));
    vec3 moonUp = normalize2(cross(moonRight, moonDir));

    float uAngle = dot(offset, moonRight);
    float vAngle = dot(offset, moonUp);

    return vec2(uAngle, vAngle) / radius * 0.5 + 0.5;
}

#include "lib/timeCycle.glsl"
#include "lib/buffers.glsl"

void main() {
    vec3 pos = screenToView(vec3(gl_FragCoord.xy / vec2(viewWidth, viewHeight), 1.0));
    vec2 texCoord = gl_FragCoord.xy / vec2(viewWidth, viewHeight);

    mediump float depth = texture2D(depthtex0, texCoord).r;

    vec2 ndc = texCoord * 2.0 - 1.0;

    vec4 clip = vec4(ndc, -1.0, 1.0);

    vec4 viewSpace = gbufferProjectionInverse * clip;

    vec3 direction = normalize(viewSpace.xyz / viewSpace.w);

    vec3 transformedDir = (gbufferModelViewInverse * vec4(direction, 0.0)).xyz;

    #ifdef SHADER_CLOUDS
        vec4 noiseA = texture2D(noisetex,transformedDir.st * vec2(0.25, 1.0) * vec2(1.0/CLOUD_SCALE_A) + vec2(timeOfDay/6000 * CLOUD_SPEED_A, 0f));
        vec4 noiseB = texture2D(noisetex,transformedDir.st * vec2(0.25, 1.0) * vec2(1.0/CLOUD_SCALE_B) - vec2(timeOfDay/6000 * CLOUD_SPEED_B, 0f));
        vec4 noise = mix2(vec4(0f), noiseB, noiseA.g);
    #else
        vec4 noise = vec4(0.0);
    #endif

    if(isBiomeEnd) {
        dayColorA = vec3(SKY_SE_DAY_A_R,SKY_SE_DAY_A_G,SKY_SE_DAY_A_B);
        dayColorB = vec3(SKY_SE_DAY_B_R,SKY_SE_DAY_B_G,SKY_SE_DAY_B_B);

        dayColorRainA = vec3(SKY_SE_DAY_A_R,SKY_SE_DAY_A_G,SKY_SE_DAY_A_B);
        dayColorRainB = vec3(SKY_SE_DAY_B_R,SKY_SE_DAY_B_G,SKY_SE_DAY_B_B);
        nightColorA = vec3(SKY_SE_NIGHT_A_R,SKY_SE_NIGHT_A_G,SKY_SE_NIGHT_A_B);
        nightColorB = vec3(SKY_SE_NIGHT_B_R,SKY_SE_NIGHT_B_G,SKY_SE_NIGHT_B_B);
        transitionColorA = vec3(SKY_SE_SUNSET_A_R,SKY_SE_SUNSET_A_G,SKY_SE_SUNSET_A_B);
        transitionColorB = vec3(SKY_SE_SUNSET_B_R,SKY_SE_SUNSET_B_G,SKY_SE_SUNSET_B_B);
    } else {
        dayColorA = vec3(SKY_DAY_A_R,SKY_DAY_A_G,SKY_DAY_A_B);
        dayColorB = vec3(SKY_DAY_B_R,SKY_DAY_B_G,SKY_DAY_B_B);

        dayColorRainA = vec3(SKY_DAY_RAIN_A_R,SKY_DAY_RAIN_A_G,SKY_DAY_RAIN_A_B);
        dayColorRainB = vec3(SKY_DAY_RAIN_B_R,SKY_DAY_RAIN_B_G,SKY_DAY_RAIN_B_B);
        nightColorA = vec3(SKY_NIGHT_A_R,SKY_NIGHT_A_G,SKY_NIGHT_A_B);
        nightColorB = vec3(SKY_NIGHT_B_R,SKY_NIGHT_B_G,SKY_NIGHT_B_B);
        transitionColorA = vec3(SKY_SUNSET_A_R,SKY_SUNSET_A_G,SKY_SUNSET_A_B);
        transitionColorB = vec3(SKY_SUNSET_B_R,SKY_SUNSET_B_G,SKY_SUNSET_B_B);
    }

    mediump float dayNightLerp = clamp(quadTime/500,0,1);
    mediump float sunsetLerp = clamp((quadTime - 500)/500,0,1);

    timeFunctionFrag();

    vec4 screenPos = vec4(gl_FragCoord.xy / vec2(viewWidth, viewHeight), gl_FragCoord.z, 1.0);
    vec4 viewPos = gbufferProjectionInverse * (screenPos * 2.0 - 1.0);
    vec4 worldPos = gbufferModelViewInverse * viewPos;
    viewPos /= viewPos.w;
    vec3 nViewPos = normalize(viewPos.xyz);

    mediump float VdotU = dot(nViewPos, upVec);
    mediump float VdotS = dot(nViewPos, sunVec);
    mediump float dither = Bayer8(gl_FragCoord.xy);
    
    vec4 sunViewPos = gbufferProjection * vec4(sunPosition, 1.0);
    vec4 sunClipPos = sunViewPos;

    vec3 sunDirection = normalize2(sunPosition);

    vec3 moonDirection = normalize2(moonPosition);
    
    vec3 sunNDC = sunClipPos.xyz / sunClipPos.w;

    vec2 sunScreenPos = sunNDC.xy * 0.5 + 0.5;

    vec2 sunCoords = (sunPosition.xy + 1.0) * 0.5;

    vec4 moonViewPos = gbufferProjection * vec4(-sunPosition, 1.0);
    vec4 moonClipPos =  moonViewPos;
    
    vec3 moonNDC = moonClipPos.xyz / moonClipPos.w;

    vec2 moonScreenPos = moonNDC.xy * 0.5 + 0.5;

    equalsSky.isSky = vec4(1.0);
    
    pos = screenToView(vec3(texCoord, 1.0));
    vec3 viewDir = normalize2(pos);
    float invertSunMoon = 1.0;
    outputColor = vec4(mix2(pow2(calcSkyColor(normalize(pos), currentColorA, currentColorB, noise),vec3(1/GAMMA)),vec3(0),blindness),1.0);
    mediump float sunMaxDistance = 0.11;
    mediump float distToSun = length((texCoord - sunScreenPos) * vec2(aspectRatio, 1.0));
    float sunAngle = acos(dot(viewDir, sunDirection));
    mediump float sunGradient = 1.0 - smoothstep(0.0, sunMaxDistance, sunAngle);
    mediump float moonMaxDistance = 0.08;
    mediump float distToMoon = length((moonScreenPos - texCoord) * vec2(aspectRatio, 1.0));
    float moonAngle = acos(dot(viewDir, moonDirection));
    mediump float moonGradient = 1.0 - smoothstep(0.0, moonMaxDistance, moonAngle);
    vec3 sunColor = vec3(1.0, 0.9, 0.8);
    vec3 moonColor = vec3(1.0, 1.0, 1.1);
    vec3 finalSunColor = sunColor;
    vec3 outputColorSun = mix2(vec3(0.0), finalSunColor, sunGradient);
    vec2 moonUV = moonUVs(moonDirection, viewDir, moonMaxDistance);
    vec4 outputColorMoon = texture2D(moon,getMoonCoords(1).xy).xyzw;
    outputColorMoon = mix2(vec4(outputColorMoon.xyz, 0.0), outputColorMoon.xyzw, outputColorMoon.w);
    outputColorMoon.xyz = pow2(outputColorMoon.xyz,vec3(1/GAMMA/2)) * max(pow2(moonGradient,1/9.5),0.5);
    outputColorMoon.xyz = clamp(outputColorMoon.xyz,0,1);
    if(moonAngle > moonMaxDistance) outputColorMoon.w = 0.0;
    float detectSunMoon = 1 - dot(sunDirection, viewPos.xyz);
    vec4 outputSunMoon = vec4(sunColor,sunGradient);
    vec4 outputLight = vec4(outputColorSun, sunGradient);
    if(detectSunMoon > 0.99) {
        outputColorMoon.xyz = mix2(outputColorMoon.xyz, vec3(0.8, 0.9, 1.0), 0.5 * moonGradient);
        outputSunMoon = outputColorMoon.xyzw;
        outputLight = vec4(0.0);
    } else {
        gl_FragData[2] = outputLight;
    }
    outputSunMoon *= 1 - rainStrength;
    if(worldTime2%24000 < 12000) {
        gl_FragData[3] = vec4(vec3(distToSun * 5.0),1.0);
    }
    outputColor.rgb = mix2(outputColor.rgb, outputSunMoon.xyz, outputSunMoon.w);
    outputColor = mix2(outputColor, vec4(1.0), step(0.5, starData.a));
    gl_FragData[1] = vec4(0.0, 1.0, 0.0, 1.0);

    imageStore(cimage11, ivec2(gl_FragCoord.xy/vec2(viewWidth, viewHeight) * imageSize(cimage11)), vec4(1.0));
}