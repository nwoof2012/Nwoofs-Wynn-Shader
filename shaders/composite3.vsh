#version 460 compatibility

out vec2 texCoord;

out vec3 Tangent;
in vec3 at_tangent;

varying vec2 LightmapCoords;

void main() {
    gl_Position = ftransform();
    texCoord = gl_MultiTexCoord0.st;
    Tangent = normalize(gl_NormalMatrix * at_tangent.xyz);

    LightmapCoords = mat2(gl_TextureMatrix[1]) * gl_MultiTexCoord1.st;

    //LightmapCoords = (LightmapCoords * 33.05f / 32.0f) - (1.05f / 32.0f);
}