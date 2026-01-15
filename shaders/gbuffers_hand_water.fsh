#version 460 compatibility

#define FRAGMENT_SHADER

#define GAMMA 2.2 // [1.0 1.2 1.4 1.6 1.8 2.0 2.2 2.4 2.6 2.8 3.0]

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

precision mediump float;

varying vec2 TexCoords;
varying vec3 Normal;
varying vec4 Color;

varying vec2 LightmapCoords;

uniform sampler2D texture;

uniform sampler2D noise;

uniform sampler2D depthtex0;

uniform int heldItemId;

uniform int worldTime;
uniform int frameCounter;
uniform float frameTime;

uniform bool isBiomeEnd;

vec3 dayColor = vec3(DAY_R,DAY_G,DAY_B);
vec3 nightColor = vec3(NIGHT_R,NIGHT_G,NIGHT_B);
vec3 transitionColor = vec3(SUNSET_R,SUNSET_G,SUNSET_B);

vec3 currentColor;

vec3 Diffuse;

vec3 baseColor;
vec3 baseDiffuse;

vec3 baseDiffuseModifier;

vec3 baseFog;

vec3 fogAlbedo;

float baseFogDistMin;
float baseFogDistMax;
float fogMin;
float fogMax;

uniform float near;
uniform float far;

uniform int viewWidth;
uniform int viewHeight;

uniform vec3 cameraPosition;

#include "lib/globalDefines.glsl"

#include "lib/includes2.glsl"
#include "lib/optimizationFunctions.glsl"

/* RENDERTARGETS:0,1,2,4,15,6,12,13 */

void noonFunc(float time, float timeFactor) {
    if(isBiomeEnd) {
        fogMin = FOG_SE_DIST_MIN;
        fogMax = FOG_SE_DIST_MAX;
    } else {
        mediump float dayNightLerp = clamp((time+250f)/timeFactor,0,1);
        fogMin = mix2(baseFogDistMin, FOG_DAY_DIST_MIN, dayNightLerp);
        fogMax = mix2(baseFogDistMax, FOG_DAY_DIST_MAX, dayNightLerp);
        baseDiffuseModifier = vec3(DAY_I);
        currentColor = mix2(baseColor,dayColor,dayNightLerp);
        Diffuse = mix2(baseDiffuse, pow2(Diffuse.rgb,vec3(GAMMA)) * baseDiffuseModifier, mod(worldTime/6000f,2f));
        fogAlbedo = mix2(baseFog, vec3(FOG_DAY_R, FOG_DAY_G, FOG_DAY_B), dayNightLerp);
    }
}

void sunsetFunc(float time, float timeFactor) {
    if(isBiomeEnd) {
        fogMin = FOG_SE_DIST_MIN;
        fogMax = FOG_SE_DIST_MAX;
    } else {
        mediump float sunsetLerp = clamp((time+250f)/timeFactor,0,1);
        fogMin = mix2(baseFogDistMin, FOG_SUNSET_DIST_MIN, sunsetLerp);
        fogMax = mix2(baseFogDistMax, FOG_SUNSET_DIST_MAX, sunsetLerp);
        baseDiffuseModifier = vec3(SUNSET_I);
        currentColor = mix2(dayColor, transitionColor, sunsetLerp);
        Diffuse = mix2(baseDiffuse, pow2(Diffuse.rgb,vec3(GAMMA)) * baseDiffuseModifier, mod(worldTime/6000f,2f));
        fogAlbedo = mix2(baseFog, vec3(FOG_SUNSET_R, FOG_SUNSET_G, FOG_SUNSET_B), sunsetLerp);
    }
}

void nightFunc(float time, float timeFactor) {
    if(isBiomeEnd) {
        fogMin = FOG_SE_DIST_MIN;
        fogMax = FOG_SE_DIST_MAX;
    } else {
        mediump float dayNightLerp = clamp((time+250f)/timeFactor,0,1);
        fogMin = mix2(baseFogDistMin, FOG_NIGHT_DIST_MIN, dayNightLerp);
        fogMax = mix2(baseFogDistMax, FOG_NIGHT_DIST_MAX, dayNightLerp);
        baseDiffuseModifier = vec3(NIGHT_I * 0.4f);
        currentColor = mix2(baseColor, nightColor, dayNightLerp);
        Diffuse = mix2(baseDiffuse, pow2(Diffuse.rgb,vec3(GAMMA)) * baseDiffuseModifier,mod(worldTime/6000f,2f));
        fogAlbedo = mix2(baseFog, vec3(FOG_NIGHT_R, FOG_NIGHT_G, FOG_NIGHT_B), dayNightLerp);
    }
}

void dawnFunc(float time, float timeFactor) {
    if(isBiomeEnd) {
        fogMin = FOG_SE_DIST_MIN;
        fogMax = FOG_SE_DIST_MAX;
    } else {
        mediump float sunsetLerp = clamp((time+250f)/timeFactor,0,1);
        baseDiffuseModifier = vec3(SUNSET_I);
        currentColor = mix2(dayColor, transitionColor, sunsetLerp);
        Diffuse = mix2(baseDiffuse, pow2(Diffuse.rgb,vec3(GAMMA)) * baseDiffuseModifier, mod(worldTime/6000f,2f));
        fogAlbedo = mix2(baseFog, vec3(FOG_SUNSET_R, FOG_SUNSET_G, FOG_SUNSET_B), sunsetLerp);
    }
}

#include "lib/timeCycle.glsl"

uniform int dhRenderDistance;

void main() {
    vec4 noiseMap3 = texture2D(noise, TexCoords - sin(TexCoords.y*64f + ((frameCounter)/90f)) * 0.005f);
    
    vec4 albedo = texture2D(texture, TexCoords) * Color;
    mediump float depth = texture2D(depthtex0, TexCoords).r;

    fogMin = FOG_DAY_DIST_MIN;
    fogMax = FOG_DAY_DIST_MAX;

    baseFogDistMin = fogMin;
    baseFogDistMax = fogMax;

    if(worldTime/(timePhase + 1) < 500f) {
        baseFogDistMin = fogMin;
        baseFogDistMax = fogMax;
    }

    timeFunctionFrag();

    mediump float fogStart = fogMin;
    mediump float fogEnd = fogMax;

    mediump float fogAmount = (length(viewSpaceFragPosition)*(far/dhRenderDistance * 0.75) - fogStart)/(fogEnd - fogStart);

    gl_FragData[5] = vec4(0.0, fogAmount, depth, 1.0);

    mediump float a;

    float isCave = LightmapCoords.r;
    gl_FragData[6] = vec4(isCave, 0.0, 0.0, 1.0);

    gl_FragData[7] = vec4(LightmapCoords, 0.0, 1.0);

    if(albedo.a > 0 && heldItemId == 1) {
        a = 1;
    } else {
        a = 0;
    }

    vec3 newNormal = (gbufferModelViewInverse * vec4(Normal,1.0)).xyz;
    
    gl_FragData[0] = albedo;
    gl_FragData[1] = vec4(newNormal * 0.5 + 0.5f, 1.0f);
    #if SCENE_AWARE_LIGHTING == 0
        gl_FragData[2] = vec4(LightmapCoords, 0.0f, 1.0f);
    #endif
    gl_FragData[3] = vec4(a);
    gl_FragData[5] = vec4(1.0);
}