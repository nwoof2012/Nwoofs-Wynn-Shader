#version 460 compatibility

#define DISTANT_HORIZONS

#define PATH_TRACING_GI 0 // [0 1]

#define VERTEX_SHADER

uniform mat4 dhProjection;
uniform mat4 gbufferModelViewInverse;

out vec4 blockColor;
out vec2 lightmapCoords;
out vec3 viewSpaceFragPosition;

out vec3 playerPos;

out float isWaterBlock;

out vec3 Normal;

varying float timePhase;
varying float quadTime;
uniform int worldTime;
uniform int frameCounter;
uniform float frameTime;

in vec4 mc_Entity;

out vec3 lightmap2;

#include "program/pathTracing.glsl"

void main() {
    Normal = gl_NormalMatrix * gl_Normal;

    blockColor = gl_Color;

    #if PATH_TRACING_GI == 1
            lightmap2 = GenerateLightmap(0f,1f);
    #endif
    lightmapCoords = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;

    viewSpaceFragPosition = (gl_ModelViewMatrix * gl_Vertex).xyz;

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

    isWaterBlock = 0f;
	
	if(mc_Entity.x == 8.0 && mc_Entity.x != 10002) {
        isWaterBlock = 1f;
    }

    playerPos = (gbufferModelViewInverse * gl_ModelViewMatrix * gl_Vertex).xyz;

    gl_Position = ftransform();
}