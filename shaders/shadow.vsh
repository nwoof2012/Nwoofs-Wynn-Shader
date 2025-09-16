#version 460 compatibility

uniform float near;
uniform float far;

uniform int viewWidth;
uniform int viewHeight;

uniform vec3 cameraPosition;

#include "lib/globalDefines.glsl"

#include "lib/includes2.glsl"
#include "lib/optimizationFunctions.glsl"
#include "program/blindness.glsl"
#include "distort.glsl"
#define ENTITY_SHADOWS

precision mediump float;

varying vec2 TexCoords;
varying vec4 Color;

void main() {
    gl_Position = ftransform();
    gl_Position.xy = DistortPosition(gl_Position.xy);
    TexCoords = gl_MultiTexCoord0.st;
    Color = gl_Color;

    /*#ifdef SCENE_AWARE_LIGHTING
        #include "program/voxelizing.glsl"
    #endif*/
}