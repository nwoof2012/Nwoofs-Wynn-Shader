#version 460 compatibility

#define DISTANT_HORIZONS

uniform mat4 dhProjection;

out vec4 blockColor;
out vec2 lightmapCoords;
out vec3 viewSpaceFragPosition;

varying float timePhase;
varying float quadTime;
uniform int worldTime;
uniform int frameCounter;
uniform float frameTime;

void main() {
    blockColor = gl_Color;

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
    gl_Position = ftransform();
}