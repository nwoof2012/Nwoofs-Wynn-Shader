#version 460 compatibility

#define VERTEX_SHADER

precision mediump float;

out vec2 texcoord;
out vec4 glcolor;
flat out vec3 upVec, sunVec;
out vec3 position;

uniform int worldTime;

uniform mat4 gbufferModelView;
uniform mat4 gbufferProjection;

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;

const float sunPathRotation = -40.0f;

#include "lib/optimizationFunctions.glsl"

vec3 GetSunVector() {
    const vec2 sunRotationData = vec2(cos(sunPathRotation * 0.01745329251994), -sin(sunPathRotation * 0.01745329251994));
    mediump float ang = fract(worldTime / 24000.0 - 0.25);
    ang = (ang + (cos(ang * 3.14159265358979) * -0.5 + 0.5 - ang) / 3.0) * 6.28318530717959;
    return normalize2((gbufferModelView * vec4(vec3(-sin(ang), cos(ang) * sunRotationData) * 2000.0, 1.0)).xyz);
}

void main() {
	gl_Position = ftransform();
	texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	glcolor = gl_Color;

    upVec = normalize(gbufferModelView[1].xyz);
    sunVec = GetSunVector();
    position = gl_Position.xyz;
}