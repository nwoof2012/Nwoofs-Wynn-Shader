#version 460 compatibility

#define SCENE_AWARE_LIGHTING

#include "lib/includes2.glsl"
#include "lib/optimizationFunctions.glsl"
#include "program/blindness.glsl"

varying vec2 TexCoords;
varying vec3 Normal;
varying vec4 Color;

varying vec2 LightmapCoords;

uniform sampler2D texture;
uniform sampler2D depthtex0;

uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjectionInverse;

uniform vec3 cameraPosition;

/* RENDERTARGETS:0,1,2,15,5,10 */

void main() {
    vec4 albedo = texture2D(texture, TexCoords) * Color;
    float depth = texture2D(depthtex0, TexCoords).r;

    float a;

    if(albedo.a > 0) {
        a = 1;
    } else {
        a = 0;
    }

    float distanceFromCamera = distance(vec3(0), viewSpaceFragPosition);

    vec3 worldPosition = cameraPosition + (gbufferModelViewInverse * vec4(viewSpaceFragPosition, depth)).xyz;

    if(blindness > 0f) {
        albedo.xyz = blindEffect(albedo.xyz);
    }

    gl_FragData[0] = albedo;
    gl_FragData[1] = vec4(Normal * 0.5 + 0.5f, 1.0f);

    #ifdef SCENE_AWARE_LIGHTING
        gl_FragData[2] = vec4(LightmapCoords, 0.0f, 1.0f);
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