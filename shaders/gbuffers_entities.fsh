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

/* RENDERTARGETS:0,1,2,15,5 */

void main() {
    vec4 albedo = texture2D(texture, TexCoords) * Color;

    float a;

    if(albedo.a > 0) {
        a = 1;
    } else {
        a = 0;
    }

    float distanceFromCamera = distance(vec3(0), viewSpaceFragPosition);

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
    gl_FragData[3] = vec4(1.0, distanceFromCamera, 0.0, 0.0);
    gl_FragData[4] = vec4(0.0,0.0,0.0,1.0);
    //gl_FragData[3] = vec4(a);
}