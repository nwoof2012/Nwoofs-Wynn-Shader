#version 460 compatibility

#define VERTEX_SHADER

const float sunPathRotation = -40.0f;

#include "lib/commonFunctions.glsl"

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

    float timeOfDay = mod(worldTime,24000);
    quadTime = timeOfDay;
    if(timeOfDay < 250) {
        timePhase = 3;
        quadTime += 250;
    } else if(timeOfDay < 11750) {
        timePhase = 0;
        quadTime -= 250;
    } else if(timeOfDay < 12250) {
        timePhase = 1;
        quadTime -= 11750;
    } else if(timeOfDay < 23750) {
        timePhase = 2;
        quadTime -= 12250;
    } else if(timeOfDay < 24000) {
        timePhase = 3;
        quadTime -= 23250;
    }

    sunVisibility2 = timeOfDay/24000;

    upVec = normalize(gbufferModelView[1].xyz);
    sunVec = GetSunVector();

    vec4 position = gbufferModelViewInverse * gl_ModelViewMatrix * gl_Vertex;
    position.xz -= vec2(88.0);
    gl_Position = gl_ProjectionMatrix * gbufferModelView * position;
    Normal = gl_Normal;
}