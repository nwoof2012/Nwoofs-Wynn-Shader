#version 460 compatibility

//#define SCENE_AWARE_LIGHTING

struct LightSource {
    int id;
    float brightness;
};

in vec3 vaPosition;
in vec2 vaUV0;
in vec4 vaColor;
in ivec2 vaUV2;

varying vec2 TexCoords;
varying vec3 Normal;
varying vec4 Color;

varying vec2 LightmapCoords;

out vec3 viewSpaceFragPosition;

out vec4 lightSourceData;

in vec4 mc_Entity;

vec4 GenerateLightmap(LightSource source) {
    switch (source.id) {
        case 10005:
            return vec4(1,0,0, source.brightness);
        case 10006:
            return vec4(0,1,0, source.brightness);;
        case 10007:
            return vec4(0,0,1, source.brightness);
        case 10008:
            return vec4(0.5,0,0, source.brightness);
        case 10009:
            return vec4(0,0.5,0, source.brightness);
        case 10010:
            return vec4(0,0,0.5, source.brightness);
        default:
            return vec4(0);
    }
}

void main() {
    gl_Position = ftransform();
        
    TexCoords = gl_MultiTexCoord0.st;

    viewSpaceFragPosition = (gl_ModelViewMatrix * gl_Vertex).xyz;

    LightmapCoords = mat2(gl_TextureMatrix[1]) * gl_MultiTexCoord1.st;

    LightmapCoords = (LightmapCoords * 33.05f / 32.0f) - (1.05f / 32.0f);
    Normal = gl_NormalMatrix * gl_Normal;
    Color = gl_Color;

    #ifdef SCENE_AWARE_LIGHTING
        LightSource source;
        source.id = int(mc_Entity.x);
        source.brightness = LightmapCoords.x;
        lightSourceData = GenerateLightmap(source);
    #endif
}