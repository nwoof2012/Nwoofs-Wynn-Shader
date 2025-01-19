#version 460 compatibility
#include "lib/optimizationFunctions.glsl"
#include "distort.glsl"

#define SCENE_AWARE_LIGHTING

#define ENTITY_SHADOWS

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