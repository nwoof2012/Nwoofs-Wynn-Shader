#version 460 compatibility

#define VERTEX_SHADER

const float sunPathRotation = -40.0f;

varying vec2 TexCoords;
varying vec3 Normal;

uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;

varying float timePhase;
varying float quadTime;
uniform int worldTime;
uniform int frameCounter;
uniform float frameTime;

flat out vec3 upVec, sunVec;

out vec4 glColor;

out float sunVisibility2;

void main() {
    TexCoords = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;

    glColor = gl_Color;
    gl_Position = gl_ProjectionMatrix * gbufferModelView * gl_Vertex;
    Normal = gl_Normal;
}