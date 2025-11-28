#version 460 compatibility

varying vec2 TexCoords;
varying vec3 Normal;
varying vec4 Color;

out vec3 view_pos;

varying vec2 LightmapCoords;

void main() {
    gl_Position = ftransform();

    LightmapCoords = mat2(gl_TextureMatrix[1]) * gl_MultiTexCoord1.st;

    view_pos = vec4(gl_ModelViewMatrix * gl_Vertex).xyz;

    TexCoords = gl_MultiTexCoord0.st;
    Normal = gl_NormalMatrix * gl_Normal;
    Color = gl_Color;
}