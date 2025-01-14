#version 460 compatibility

#include "lib/globalDefines.glsl"

#include "lib/includes2.glsl"
#include "lib/optimizationFunctions.glsl"
#include "program/blindness.glsl"

varying vec2 TexCoords;
varying vec4 Normal;
varying vec3 Tangent;
varying vec4 Color;

varying vec2 LightmapCoords;

varying float isWaterBlock;

uniform sampler2D texture;

uniform sampler2D gDepth;

uniform sampler2D noise;

uniform sampler2D colortex0;
uniform sampler2D depthtex0;
uniform sampler2D depthtex1;

uniform mat4 gbufferProjectionInverse;

uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

uniform int worldTime;
uniform int frameCounter;
uniform float frameTime;

uniform float viewWidth;
uniform float viewHeight;

in float isWater;

//attribute vec4 mc_Entity;

/* DRAWBUFFERS:01235 */

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

    vec3 newNormal = Normal.xyz;

    newNormal = (gbufferModelViewInverse * vec4(newNormal,1.0)).xyz;

    albedo.a = 0.75f;
    
    vec4 finalNoise = mix2(noiseMap,noiseMap2,0.5f);
    
    vec4 Lightmap;

    if(isWater < 0.1f && isWaterBlock == 1) {
        albedo.xyz = mix2(vec3(0.0f,0.33f,0.55f),vec3(1.0f,1.0f,1.0f),pow2(finalNoise.x,5));
        albedo.a = 0.0f;//mix2(0.5f,1f,pow2(finalNoise.x,5));
        Lightmap = vec4(LightmapCoords.x, LightmapCoords.y, 0.0, 1.0f);
        if(albedo.a < 0.75f) {
            albedo.a = 0.0;
        }
    } else {
        albedo = texture2D(colortex0, TexCoords);
        //albedo.xyz *= gl_Color.xyz;
        Lightmap = vec4(LightmapCoords.x, LightmapCoords.y, 0f, 1.0f);
    }

    //vec4 normalDefine = vec4(noiseMap.xyz * 0.5 + 0.5f, 1.0f);
    //normalDefine = normalDefine + noiseMap;
    float distanceFromCamera = distance(viewSpaceFragPosition,vec3(0));
    
    if(blindness > 0f) {
        albedo.xyz = blindEffect(albedo.xyz);
    }

    gl_FragData[0] = albedo;
    gl_FragData[1] = vec4(newNormal,1.0);
    #ifndef SCENE_AWARE_LIGHTING
        gl_FragData[2] = Lightmap;
    #else
        gl_FragData[2] = vec4(0.0);
    #endif
    gl_FragData[3] = vec4(1.0);
    gl_FragData[4] = vec4(isWaterBlock, 1.0, 1.0, 1.0);
}