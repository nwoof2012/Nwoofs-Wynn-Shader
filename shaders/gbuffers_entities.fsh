#version 460 compatibility

#include "lib/globalDefines.glsl"

#include "lib/includes2.glsl"
#include "lib/optimizationFunctions.glsl"
#include "program/blindness.glsl"

#define MIN_LIGHT 0.05f // [0.0f 0.05f 0.1f 0.15f 0.2f 0.25f 0.3f 0.35f 0.4f 0.45f 0.5f]

#define SE_MIN_LIGHT 0.05f // [0.0f 0.05f 0.1f 0.15f 0.2f 0.25f 0.3f 0.35f 0.4f 0.45f 0.5f]

#define MAX_LIGHT 1.5f // [1.0f 1.1f 1.2f 1.3f 1.4f 1.5f 1.6f 1.7f 1.8f 1.9f 2.0f 2.1f 2.2f 2.3f 2.4f 2.5f 2.6f 2.7f 2.8f 2.9f 3.0f 3.1f 3.2f 3.3f 3.4f 3.5f 3.6f 3.7f 3.8f 3.9f 4.0f 4.1f]

#define SE_MAX_LIGHT 2.0f // [1.0f 1.1f 1.2f 1.3f 1.4f 1.5f 1.6f 1.7f 1.8f 1.9f 2.0f 2.1f 2.2f 2.3f 2.4f 2.5f 2.6f 2.7f 2.8f 2.9f 3.0f 3.1f 3.2f 3.3f 3.4f 3.5f 3.6f 3.7f 3.8f 3.9f 4.0f 4.1f]

precision mediump float;

varying vec2 TexCoords;
varying vec3 Normal;
varying vec4 Color;

varying vec2 LightmapCoords;

uniform sampler2D texture;
uniform sampler2D depthtex0;

uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjectionInverse;

uniform vec3 cameraPosition;

uniform bool isBiomeEnd;

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

vec4 vanillaLight(in vec2 Lightmap) {
    const vec3 TorchColor = vec3(1.0f, 1.0f, 1.0f);
    vec4 lightColor = vec4(TorchColor * Lightmap.x,1.0);
    return lightColor;
}

/* RENDERTARGETS:0,1,2,15,5,10 */

void main() {
    vec4 albedo = texture2D(texture, TexCoords) * Color;
    mediump float depth = texture2D(depthtex0, TexCoords).r;

    mediump float a;

    if(albedo.a > 0) {
        a = 1;
    } else {
        a = 0;
    }

    mediump float distanceFromCamera = distance(vec3(0), viewSpaceFragPosition);

    vec3 worldPosition = cameraPosition + (gbufferModelViewInverse * vec4(viewSpaceFragPosition, depth)).xyz;

    if(blindness > 0f) {
        albedo.xyz = blindEffect(albedo.xyz);
    }

    gl_FragData[0] = albedo;
    gl_FragData[1] = vec4(Normal * 0.5 + 0.5f, 1.0f);

    #ifdef SCENE_AWARE_LIGHTING
        vec4 vanilla = vanillaLight(AdjustLightmap(LightmapCoords));
        vec4 lighting = mix2(pow2(vanilla * 0.5f,vec4(0.25f)),vec4(vec3(0.0),1.0),1 - clamp(length(max(vanilla.xyz,vec3(0.0))),0,0.5));
        if(isBiomeEnd) lighting.xyz = max(lighting.xyz, vec3(SE_MIN_LIGHT * 0.1)); else lighting.xyz = max(lighting.xyz, vec3(MIN_LIGHT * 0.1));
        gl_FragData[2] = vec4(lighting.xyz, 1.0);
    #else
        gl_FragData[2] = vec4(LightmapCoords, 0.0f, 1.0f);
    #endif
    gl_FragData[3] = vec4(1.0, distanceFromCamera, 0.0, 1.0);
    gl_FragData[4] = vec4(0.0,0.0,0.0,1.0);
    #ifdef ENTITY_SHADOWS
        gl_FragData[5] = vec4(worldPosition, 1.0);
    #else
        gl_FragData[5] = vec4(0.0);
    #endif
    //gl_FragData[3] = vec4(a);
}