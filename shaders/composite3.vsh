#version 460 compatibility

#define VERTEX_SHADER
#define COMPOSITE_1

#define PATH_TRACING_GI 0 // [0 1]

#define PATH_TRACING_GI

uniform sampler2D lighting;

varying vec2 TexCoords;
varying vec2 LightmapCoords;

in ivec2 vaUV2;

in vec4 mc_Entity;

out vec3 viewSpaceFragPosition;

uniform sampler2D noise;

uniform vec3 cameraPosition;

uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjection;

uniform float aspectRatio;

#include "lib/world/timeCycle.glsl"

out vec3 lightmap;

out vec3 vNormal;
out vec3 vViewDir;
out vec3 Tangent;

out vec3 foot_pos;
out vec3 world_pos;

out vec2 FoV;

in vec3 at_tangent;
in vec3 at_midBlock;

out float isLeaves;

#include "lib/lighting/pathTracing.glsl"

vec3 lightmapData() {
    vec3 TorchColor = vec3(1.0f, 0.0f, 0.0f);
    vec3 GlowstoneColor = vec3(-1.0f, 0.0f, 0.0f);
    vec3 LampColor = vec3(0.0f, 1.0f, 0.0f);
    vec3 LanternColor = vec3(0.0f, -1.0f, 0.0f);
    vec3 RedstoneColor = vec3(0.0f, 0.0f, 1.0f);
    vec3 RodColor = vec3(0.0f, 0.0f, -1.0f);

    if(mc_Entity.x == 10005) {
        return TorchColor;
    } else if(mc_Entity.x == 10006) {
        return GlowstoneColor;
    } else if(mc_Entity.x == 10007) {
        return LampColor;
    } else if(mc_Entity.x == 10008) {
        return LanternColor;
    } else if(mc_Entity.x == 10010) {
        return RodColor;
    } else if(mc_Entity.x == 10009 || mc_Entity.x == 10011) {
        return RedstoneColor;
    } else {
        return vec3(0.0);
    }
}

void main() {
    vNormal = normalize(gl_NormalMatrix * gl_Normal);
    Tangent = normalize(gl_NormalMatrix * at_tangent.xyz);
    gl_Position = ftransform();
    vec4 viewPos = gl_ModelViewMatrix * vec4(gl_Position.xyz, 1.0);
    vViewDir = normalize(-viewPos.xyz);
    viewSpaceFragPosition = (gl_ModelViewMatrix * gl_Vertex).xyz;
    LightmapCoords = vaUV2;

    FoV = vec2(1.0);
    FoV.y = 2.0 * atan(1.0 / gbufferProjection[1][1]);
    FoV.x = 2.0 * atan(tan(FoV.y/2.0) * aspectRatio);

    vec3 view_pos = vec4(gl_ModelViewMatrix * gl_Vertex).xyz;
    foot_pos = (gbufferModelViewInverse * vec4(view_pos, 1.0)).xyz;
    world_pos = foot_pos + cameraPosition;

    isLeaves = mc_Entity.x == 10003? 1.0 : 0.0;
    
    #if PATH_TRACING_GI == 1
        lightmap = GenerateLightmap(1f,1f);
    #else
        lightmap = lightmapData();
    #endif
    timeFunctionVert();
    TexCoords = gl_MultiTexCoord0.st;
}