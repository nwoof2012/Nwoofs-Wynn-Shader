#version 460 compatibility
#define VERTEX_SHADER
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

#include "lib/timeCycle.glsl"

out vec3 lightmap;

out vec3 vNormal;
out vec3 vViewDir;
out vec3 Tangent;

out vec3 foot_pos;
out vec3 world_pos;

out vec2 FoV;

in vec3 at_tangent;
in vec3 at_midBlock;

#include "program/pathTracing.glsl"

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

    /*#ifdef SCENE_AWARE_LIGHTING
        #include "program/voxelizing.glsl"
        //imageStore(lightData, texCoord, texture2D(lighting,texCoord));
    #endif*/
    
    #if PATH_TRACING_GI == 1
        lightmap = GenerateLightmap(1f,1f);
    #else
        lightmap = lightmapData();
    #endif
    timeFunctionVert();
    /*if(mc_Entity.x == 8.0 || mc_Entity.x == 9.0) {
        vec4 noiseMap = texture2D(noise, TexCoords + sin(gl_Position.y*32f + ((frameCounter)/90f)*0.25f));
        vec4 noiseMap2 = texture2D(noise, TexCoords + sin(gl_Position.y*16f + ((frameCounter)/90f)*0.25f));
        vec4 finalNoise = mix(noiseMap,noiseMap2,0.5f);

        gl_Position.xy += finalNoise.xy;
        //vec3 Normal = normalize(texture2D(colortex1, TexCoords).rgb * 2.0f -1.0f) + finalNoise.xyz;
    }*/
    TexCoords = gl_MultiTexCoord0.st;
}