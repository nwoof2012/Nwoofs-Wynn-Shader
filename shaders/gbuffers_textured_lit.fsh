#version 460 compatibility

#include "lib/globalDefines.glsl"

#include "lib/includes2.glsl"
#include "lib/optimizationFunctions.glsl"
#include "program/blindness.glsl"

precision mediump float;

varying vec2 TexCoords;

varying vec4 Color;

uniform sampler2D colortex0;
uniform sampler2D texture;

varying vec3 Normal;
varying vec2 LightmapCoords;

/* DRAWBUFFERS:01265 */
void main() {
    vec4 color = texture2D(texture, TexCoords) * Color;

    //Color = vec3(dot(Color, vec3(0.333f)));

    mediump float a;

    /*if(color.a > 0) {
        a = 1;
    } else {
        a = 0;
    }*/

    mediump float distanceFromCamera = distance(vec3(0), viewSpaceFragPosition);

    if(blindness > 0f) {
        color.xyz = blindEffect(color.xyz);
    }
    
    gl_FragData[0] = color;
    gl_FragData[1] = vec4(Normal, 1.0);
    #ifdef SCENE_AWARE_LIGHTING
        gl_FragData[2] = vec4(color.xyz, 1.0f);
    #else
        gl_FragData[2] = vec4(LightmapCoords, 0.0f, 1.0f);
    #endif
    //gl_FragData[3] = vec4(a);
    gl_FragData[4] = vec4(0.0,1.0,1.0,1.0);
}