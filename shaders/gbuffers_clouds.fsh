#version 460 compatibility

#define OVERWORLD

precision mediump float;

in vec4 glColor;

in float sunVisibility2;

varying vec2 TexCoords;
varying vec3 Normal;

uniform sampler2D noises;

/* DRAWBUFFERS:063 */

void main() {
    gl_FragData[0] = vec4(0);
}