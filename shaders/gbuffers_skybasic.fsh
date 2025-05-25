#version 460 compatibility

#define FRAGMENT_SHADER

#define SKY_DAY_A_R 0.3f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_DAY_A_G 0.6f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_DAY_A_B 1.0f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]

#define SKY_DAY_B_R 0.6f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_DAY_B_G 0.8f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_DAY_B_B 1.0f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]

#define SKY_DAY_RAIN_A_R 0.2f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_DAY_RAIN_A_G 0.4f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_DAY_RAIN_A_B 0.6f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]

#define SKY_DAY_RAIN_B_R 0.4f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_DAY_RAIN_B_G 0.5f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_DAY_RAIN_B_B 0.6f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]

#define SKY_NIGHT_A_R 0.0f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_NIGHT_A_G 0.1f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_NIGHT_A_B 0.2f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]

#define SKY_NIGHT_B_R 0.1f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_NIGHT_B_G 0.2f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_NIGHT_B_B 0.3f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]


#define SKY_SUNSET_A_R 1.0f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SUNSET_A_G 0.8f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SUNSET_A_B 0.4f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]

#define SKY_SUNSET_B_R 0.6f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SUNSET_B_G 0.9f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SUNSET_B_B 1.0f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]


#define SKY_SE_DAY_A_R 0.1f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SE_DAY_A_G 0.1f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SE_DAY_A_B 0.1f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]

#define SKY_SE_DAY_B_R 0.4f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SE_DAY_B_G 0.4f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SE_DAY_B_B 0.4f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]


#define SKY_SE_NIGHT_A_R 0.0f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SE_NIGHT_A_G 0.1f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SE_NIGHT_A_B 0.2f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]

#define SKY_SE_NIGHT_B_R 0.1f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SE_NIGHT_B_G 0.2f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SE_NIGHT_B_B 0.3f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]


#define SKY_SE_SUNSET_A_R 0.0f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SE_SUNSET_A_G 0.8f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SE_SUNSET_A_B 0.4f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]

#define SKY_SE_SUNSET_B_R 0.4f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SE_SUNSET_B_G 0.4f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SE_SUNSET_B_B 0.4f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]

#define SHADER_CLOUDS

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

#define GAMMA 2.2 // [1.0 1.2 1.4 1.6 1.8 2.0 2.2 2.4 2.6 2.8 3.0]

#include "lib/includes2.glsl"
#include "lib/optimizationFunctions.glsl"
#include "program/blindness.glsl"

precision mediump float;

varying vec2 TexCoords;

uniform float viewWidth;
uniform float viewHeight;

uniform int worldTime;
uniform int frameCounter;
uniform float frameTime;
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferProjection;
uniform vec3 fogColor;
uniform vec3 skyColor;

uniform bool isBiomeEnd;
uniform bool isBiomeDry;

uniform sampler2D colortex11;

uniform float rainStrength;

uniform sampler2D noisetex;

uniform sampler2D depthtex0;

in vec4 starData;

flat in vec3 upVec, sunVec;

uniform vec3 sunPosition;

uniform float aspectRatio;

#include "lib/dither.glsl"

//vec3 dayColor = vec3(1.0f,1.0f,1.0f);
vec3 dayColorA;
vec3 dayColorB;

vec3 dayColorRainA;
vec3 dayColorRainB;
//vec3 nightColor = vec3(0.9f,1.0f,1.1f);
vec3 nightColorA;
vec3 nightColorB;
//vec3 transitionColor = vec3(1.1f, 1.0f, 0.8f);
vec3 transitionColorA;
vec3 transitionColorB;

vec3 currentColorA;
vec3 currentColorB;

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

#include "lib/timeCycle.glsl"

void main() {
    vec3 pos = screenToView(vec3(gl_FragCoord.xy / vec2(viewWidth, viewHeight), 1.0));
    vec2 texCoord = gl_FragCoord.xy / vec2(viewWidth, viewHeight);

    mediump float depth = texture2D(depthtex0, texCoord).r;

    vec3 ClipSpace = vec3(TexCoords, depth) * 2.0f - 1.0f;
    vec4 ViewW = gbufferProjectionInverse * vec4(ClipSpace, 1.0f);
    vec3 View = ViewW.xyz / ViewW.w;
    vec4 World = gbufferModelViewInverse * vec4(View, 1.0f);

    vec2 ndc = texCoord * 2.0 - 1.0;

    vec4 clip = vec4(ndc, -1.0, 1.0);

    vec4 viewSpace = gbufferProjectionInverse * clip;

    vec3 direction = normalize(viewSpace.xyz / viewSpace.w);

    vec3 transformedDir = (gbufferModelViewInverse * vec4(direction, 0.0)).xyz;

    //texCoord2.xyz *= texCoord2.w;
    //texCoord2 = gbufferProjection * texCoord2;
    //texCoord2 = (texCoord2 + 1.0f)/2.0f;
    //texCoord2.y = fogify(texCoord2.y, texCoord2.w);

    vec4 noiseA = texture2D(noisetex,transformedDir.st * vec2(0.25, 1.0) * vec2(1.0/CLOUD_SCALE_A) + vec2(timeOfDay/6000 * CLOUD_SPEED_A, 0f));
    vec4 noiseB = texture2D(noisetex,transformedDir.st * vec2(0.25, 1.0) * vec2(1.0/CLOUD_SCALE_B) - vec2(timeOfDay/6000 * CLOUD_SPEED_B, 0f));
    vec4 noise = mix2(vec4(0f), noiseB, noiseA.g);

    if(isBiomeEnd) {
        //vec3 dayColor = vec3(1.0f,1.0f,1.0f);
        dayColorA = vec3(SKY_SE_DAY_A_R,SKY_SE_DAY_A_G,SKY_SE_DAY_A_B);
        dayColorB = vec3(SKY_SE_DAY_B_R,SKY_SE_DAY_B_G,SKY_SE_DAY_B_B);

        dayColorRainA = vec3(SKY_SE_DAY_A_R,SKY_SE_DAY_A_G,SKY_SE_DAY_A_B);
        dayColorRainB = vec3(SKY_SE_DAY_B_R,SKY_SE_DAY_B_G,SKY_SE_DAY_B_B);
        //vec3 nightColor = vec3(0.9f,1.0f,1.1f);
        nightColorA = vec3(SKY_SE_NIGHT_A_R,SKY_SE_NIGHT_A_G,SKY_SE_NIGHT_A_B);
        nightColorB = vec3(SKY_SE_NIGHT_B_R,SKY_SE_NIGHT_B_G,SKY_SE_NIGHT_B_B);
        //vec3 transitionColor = vec3(1.1f, 1.0f, 0.8f);
        transitionColorA = vec3(SKY_SE_SUNSET_A_R,SKY_SE_SUNSET_A_G,SKY_SE_SUNSET_A_B);
        transitionColorB = vec3(SKY_SE_SUNSET_B_R,SKY_SE_SUNSET_B_G,SKY_SE_SUNSET_B_B);
    } else {
        //vec3 dayColor = vec3(1.0f,1.0f,1.0f);
        dayColorA = vec3(SKY_DAY_A_R,SKY_DAY_A_G,SKY_DAY_A_B);
        dayColorB = vec3(SKY_DAY_B_R,SKY_DAY_B_G,SKY_DAY_B_B);

        dayColorRainA = vec3(SKY_DAY_RAIN_A_R,SKY_DAY_RAIN_A_G,SKY_DAY_RAIN_A_B);
        dayColorRainB = vec3(SKY_DAY_RAIN_B_R,SKY_DAY_RAIN_B_G,SKY_DAY_RAIN_B_B);
        //vec3 nightColor = vec3(0.9f,1.0f,1.1f);
        nightColorA = vec3(SKY_NIGHT_A_R,SKY_NIGHT_A_G,SKY_NIGHT_A_B);
        nightColorB = vec3(SKY_NIGHT_B_R,SKY_NIGHT_B_G,SKY_NIGHT_B_B);
        //vec3 transitionColor = vec3(1.1f, 1.0f, 0.8f);
        transitionColorA = vec3(SKY_SUNSET_A_R,SKY_SUNSET_A_G,SKY_SUNSET_A_B);
        transitionColorB = vec3(SKY_SUNSET_B_R,SKY_SUNSET_B_G,SKY_SUNSET_B_B);
    }

    /*if(timePhase > 3) {
        timePhase = 0;
    }*/
    //vec3 baseColorA = currentColorA;
    //vec3 baseColorB = currentColorB;

    //vec3 baseOutputColorModifier;
    
    /*if(quadTime < 500f) {
        baseColorA = currentColorA;
        baseColorB = currentColorB;
    }*/

    mediump float dayNightLerp = clamp(quadTime/500,0,1);
    mediump float sunsetLerp = clamp((quadTime - 500)/500,0,1);

    /*if(worldTime > 500 && worldTime <= 11500) {
        //baseOutputColorModifier = vec3(DAY_I);
        if(rainStrength < 0.2f) {
            currentColorA = dayColorA;
            currentColorB = mix2(transitionColorB,dayColorB,dayNightLerp);
        } else if(!isBiomeDry) {
            currentColorA = dayColorRainA;//mix2(baseColorA,dayColorA,dayNightLerp);
            currentColorB = mix2(transitionColorB,dayColorRainB,dayNightLerp);//mix2(baseColorB,dayColorB,dayNightLerp);   
        }
        //outputColor = mix2(baseOutputColor, baseOutputColor * baseOutputColorModifier, mod(worldTime/6000f,2f));
        
    } else if(worldTime > 11500 && worldTime <= 12500) {
        currentColorA = mix2(dayColorA, nightColorA, sunsetLerp);
        currentColorB = mix2(dayColorB, transitionColorB, sunsetLerp);
    } else if((worldTime > 12500 && worldTime <= 23500)) {
        //baseOutputColorModifier = vec3(NIGHT_I * 0.4f);
        currentColorA = nightColorA;//mix2(baseColorA, nightColorA, dayNightLerp);
        currentColorB = mix2(transitionColorB,nightColorB,dayNightLerp);//mix2(baseColorB, nightColorB, dayNightLerp);
        //outputColor = mix2(baseOutputColor, baseOutputColor * baseOutputColorModifier,mod(worldTime/6000f,2f));
    } else if(worldTime > 23500 || worldTime <= 500) {
        //baseOutputColorModifier = vec3(SUNSET_I);
        currentColorA = mix2(nightColorA, dayColorA, sunsetLerp);
        currentColorB = mix2(nightColorB, transitionColorB, sunsetLerp);
        //outputColor = mix2(baseOutputColor, baseOutputColor * baseOutputColorModifier, mod(worldTime/6000f,2f));
    }*/

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
    
    vec3 sunNDC = sunClipPos.xyz / sunClipPos.w;

    vec2 sunScreenPos = sunNDC.xy * 0.5 + 0.5;

    vec2 sunCoords = (sunPosition.xy + 1.0) * 0.5;

    vec4 moonViewPos = gbufferProjection * vec4(-sunPosition, 1.0);
    vec4 moonClipPos =  moonViewPos;
    
    vec3 moonNDC = moonClipPos.xyz / moonClipPos.w;

    vec2 moonScreenPos = moonNDC.xy * 0.5 + 0.5;

    vec2 fragCoord = gl_FragCoord.xy / vec2(viewWidth, viewHeight);
    
    //vec3 outputColor;
    if(starData.a > 0.5) {
        outputColor = vec4(1.0);
    } else {
        pos = screenToView(vec3(gl_FragCoord.xy / vec2(viewWidth, viewHeight), 1.0));
        float invertSunMoon = 1.0;
        //mediump float upDot = dot(pos, gbufferModelView[1].xyz);
        //gl_FragData[0] = vec4(upDot);
        outputColor = vec4(mix2(pow2(calcSkyColor(normalize(pos), currentColorA, currentColorB, noise),vec3(1/GAMMA)),vec3(0),blindness),1.0);
        mediump float sunMaxDistance = 0.06;
        mediump float distToSun = length((fragCoord - sunScreenPos) * vec2(aspectRatio, 1.0));
        mediump float sunGradient = 1.0 - smoothstep(0.0, sunMaxDistance, distToSun);
        mediump float moonMaxDistance = 0.03;
        mediump float distToMoon = length((moonScreenPos - fragCoord) * vec2(aspectRatio, 1.0));
        mediump float moonGradient = 1.0 - pow2(smoothstep(0.0, moonMaxDistance, distToMoon),GAMMA);
        if(distToMoon > moonMaxDistance) {
            moonGradient = 0;
        }
        if(distToSun > sunMaxDistance) {
            moonGradient = 0;
        }
        vec3 sunColor = vec3(1.0, 0.9, 0.8);
        mediump float noise = texture2D(noisetex, transformedDir.rg).g;
        vec3 moonColor = vec3(1.0, 1.0, 1.1);
        vec3 finalSunColor = sunColor * max(sunGradient * 2f, 1.0);
        vec3 finalMoonColor = mix2(pow2(moonColor * clamp(noise + 3.0, 3.0, 4.0) * 0.25f,vec3(1/1.2)), vec3(0.0), pow2(distToMoon/0.04,4.2));
        vec3 outputColorSun = mix2(vec3(0.0), finalSunColor, sunGradient);
        //vec3 outputColorMoon = mix2(vec3(0.0), finalMoonColor, moonGradient);
        vec4 outputColorMoon = texture2D(colortex11, getMoonCoords(1).xy).xyzw;
        outputColorMoon = mix2(vec4(outputColorMoon.xyz, 0.0), outputColorMoon.xyzw, outputColorMoon.w);
        outputColorMoon.xyz += 0.6;
        outputColorMoon.xyz *= clamp(pow2(moonGradient,1/GAMMA) + 0.25,0.25,1);
        outputColorMoon.xyz = clamp(outputColorMoon.xyz,0,1);
        if(distToMoon > moonMaxDistance) outputColorMoon.w = 0.0;
        float detectSunMoon = 1 - dot(sunDirection, viewPos.xyz);
        vec4 outputSunMoon = vec4(outputColorSun,sunGradient);
        vec4 outputLight = vec4(outputColorSun, sunGradient);
        if(detectSunMoon > 0.99) {
            outputSunMoon = outputColorMoon.xyzw;
            outputLight = vec4(0.0);
        } else {
            gl_FragData[2] = outputLight;
        }
        if(worldTime%24000 < 12000) {
            //outputColor.rgb = mix2(outputColor.rgb, finalSunColor, sunGradient);
            gl_FragData[3] = vec4(vec3(distToSun * 5.0),1.0);
        } else {
            //outputColor.rgb = mix2(outputColor.rgb, finalMoonColor, moonGradient);
        }
        outputColor.rgb = mix2(outputColor.rgb, outputSunMoon.xyz, outputSunMoon.w);
        //discard;
    }

    if(blindness > 0.0) {
        outputColor.rgb = blindEffect(outputColor.rgb);
    }
    gl_FragData[1] = vec4(0.0, 1.0, 0.0, 1.0);

    /*if(timePhase < 4 && timePhase > 2) {
        outputColor.xyz *= vec3(0.1f);
    }*/

    //outputColor.xyz = unreal(outputColor.xyz);

    //gl_FragData[0] = vec4(outputColor, 1.0);
}