#version 460 compatibility

#define VERTEX_SHADER

varying vec2 TexCoords;

uniform vec3 chunkOffset;
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
uniform vec3 cameraPosition;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferModelView;

in vec3 vaPosition;

in vec2 vaUV0;

out vec4 starData;

flat out vec3 upVec, sunVec;

const float sunPathRotation = -40.0f;

#include "lib/timeCycle.glsl"
uniform mat4 gbufferProjection;

flat out int worldTime2;

uniform mat4 gbufferProjectionInverse;

#include "lib/optimizationFunctions.glsl"

vec3 GetSunVector() {
    const vec2 sunRotationData = vec2(cos(sunPathRotation * 0.01745329251994), -sin(sunPathRotation * 0.01745329251994));
    mediump float ang = fract(worldTime / 24000.0 - 0.25);
    ang = (ang + (cos(ang * 3.14159265358979) * -0.5 + 0.5 - ang) / 3.0) * 6.28318530717959;
    return normalize2((gbufferModelView * vec4(vec3(-sin(ang), cos(ang) * sunRotationData) * 2000.0, 1.0)).xyz);
}

void main() {
    timeFunctionVert();
    vec3 worldSpaceVertexPosition = cameraPosition + (gbufferModelViewInverse * projectionMatrix * modelViewMatrix * vec4(vaPosition,1)).xyz;
    float distanceFromCamera = distance(worldSpaceVertexPosition, cameraPosition);
    gl_Position = ftransform();
    starData = vec4(gl_Color.rgb, float(gl_Color.r == gl_Color.g && gl_Color.g == gl_Color.b && gl_Color.r > 0.0));
    TexCoords = vaUV0;

    upVec = normalize(gbufferModelView[1].xyz);
    sunVec = GetSunVector();

    worldTime2 = worldTime;
}