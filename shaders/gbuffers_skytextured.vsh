#version 460 compatibility

#define VERTEX_SHADER

out vec2 texcoord;
out vec4 glcolor;
flat out vec3 upVec, sunVec;
out vec3 position;

in mat4 gbufferModelView;

const float sunPathRotation = -40.0f;

#include "lib/commonFunctions.glsl"

void main() {
	gl_Position = ftransform();
	texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	glcolor = gl_Color;

    upVec = normalize(gbufferModelView[1].xyz);
    sunVec = GetSunVector();
    position = gl_Position.xyz;
}