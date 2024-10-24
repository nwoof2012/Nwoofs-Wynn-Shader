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

#include "lib/commonFunctions.glsl"
#include "lib/timeCycle.glsl"

void main() {
    timeFunctionVert();
    vec3 worldSpaceVertexPosition = cameraPosition + (gbufferModelViewInverse * projectionMatrix * modelViewMatrix * vec4(vaPosition,1)).xyz;
    float distanceFromCamera = distance(worldSpaceVertexPosition, cameraPosition);
    gl_Position = ftransform();
    starData = vec4(gl_Color.rgb, float(gl_Color.r == gl_Color.g && gl_Color.g == gl_Color.b && gl_Color.r > 0.0));
    //gl_Position = projectionMatrix * modelViewMatrix * vec4(vaPosition+chunkOffset - .1 * distanceFromCamera, 1);
    TexCoords = vaUV0;

    upVec = normalize(gbufferModelView[1].xyz);
    sunVec = GetSunVector();
}