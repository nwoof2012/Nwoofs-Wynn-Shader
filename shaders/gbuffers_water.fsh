#version 460 compatibility

#define FRAGMENT_SHADER

#define WATER_WAVES
#define WATER_WAVES_DISTANCE 12 // [4 6 8 10 12 14 16]
#define WATER_CHUNK_RESOLUTION 128 // [32 64 128]

precision mediump float;

varying vec2 TexCoords;
varying vec4 Normal;
varying vec3 Tangent;
varying vec4 Color;

varying vec2 LightmapCoords;

varying float isWaterBlock;

uniform sampler2D texture;

uniform sampler2D gDepth;

uniform sampler2D noise;

uniform sampler2D water;

uniform sampler2D colortex0;
uniform sampler2D depthtex0;
uniform sampler2D depthtex1;

uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

uniform int worldTime;
uniform int frameCounter;
uniform float frameTime;

uniform float viewWidth;
uniform float viewHeight;

in float isWater;

#define LIGHT_RADIUS 3

in vec4 lightSourceData;

in float isReflective;

uniform vec3 cameraPosition;

in vec3 worldSpaceVertexPosition;

in vec3 normals_face_world;

in vec3 block_centered_relative_pos;

in vec3 foot_pos;

in vec3 world_pos;

in vec4 at_midBlock2;

in float waterShadingHeight;

uniform float near;
uniform float far;

in float isGlass;

#include "lib/globalDefines.glsl"

#include "lib/includes2.glsl"
#include "lib/optimizationFunctions.glsl"

vec4 triplanarTexture(vec3 worldPos, vec3 normal, sampler2D tex, float scale) {
    normal = abs(normal);
    normal = normal / (normal.x + normal.y + normal.z + 0.0001);

    vec2 uvXZ = worldPos.xz * scale;
    vec2 uvXY = worldPos.xy * scale;
    vec2 uvZY = worldPos.zy * scale;

    vec4 texXZ = texture2D(tex,uvXZ) * normal.y;
    vec4 texXY = texture2D(tex,uvXY) * normal.z;
    vec4 texZY = texture2D(tex,uvZY) * normal.x;

    return texXZ + texXY + texZY;
}

/* RENDERTARGETS:0,1,2,3,5,10,15*/

void main() {
    vec4 depth = texture2D(depthtex1, TexCoords);
    vec4 depth2 = texture2D(depthtex0, TexCoords);

    vec3 ClipSpace = vec3(TexCoords, depth) * 2.0f - 1.0f;
    vec4 ViewW = gbufferProjectionInverse * vec4(ClipSpace, 1.0f);
    vec3 View = ViewW.xyz / ViewW.w;
    vec4 World = gbufferModelViewInverse * vec4(View, 1.0f);

    vec4 albedo = texture2D(texture, TexCoords) * Color;

    vec3 worldNormal = (gbufferModelViewInverse * Normal).xyz;

    vec3 bitangent = normalize2(cross(Tangent.xyz, Normal.xyz));

    mat3 tbnMatrix = mat3(Tangent.xyz, bitangent.xyz, Normal.xyz);

    vec3 n = normalize2(worldNormal);

    vec3 an = abs(n);
    vec2 uvX = world_pos.zy;
    vec2 uvY = world_pos.xz;
    vec2 uvZ = world_pos.xy;

    vec2 waterUV =
        uvX * step(max(an.y, an.z), an.x) +
        uvY * step(max(an.x, an.z), an.y) +
        uvZ * step(max(an.x, an.y), an.z);

    vec4 noiseMapA = texture2D(water, (waterUV + ((frameCounter)/90f)*0.5f) * 0.035f);
    vec4 noiseMapB = texture2D(water, (waterUV - ((frameCounter)/90f)*0.5f) * 0.035f);

    vec4 finalNoise = noiseMapA * noiseMapB * 2 - 1;

    vec3 newNormal = Normal.xyz;

    //if(isWaterBlock == 1) newNormal = tbnMatrix * finalNoise.xyz;

    newNormal = (gbufferModelViewInverse * vec4(newNormal,1.0)).xyz;

    albedo.a = 0.75f;
    
    vec4 Lightmap;

    if(isWaterBlock > 0.1f) {
        //albedo.a = 0.0f;
        Lightmap = vec4(LightmapCoords.x, LightmapCoords.y, 0.0, 1.0f);

        newNormal = tbnMatrix * finalNoise.xyz;

        newNormal = (gbufferModelViewInverse * vec4(newNormal,1.0)).xyz;
    } else {
        albedo = texture2D(colortex0, TexCoords) * Color;
        Lightmap = vec4(LightmapCoords.x, LightmapCoords.y, 0f, 1.0f);
    }
    mediump float distanceFromCamera = distance(viewSpaceFragPosition,vec3(0));

    gl_FragData[1] = vec4(newNormal * 0.5 + 0.5, 1.0);
    gl_FragData[3] = vec4(1.0,0.0,0.0,1.0);
    gl_FragData[4] = vec4(isWaterBlock, 0.0, 0.0, isWaterBlock);
    gl_FragData[5] = vec4(isGlass, 0.0, 0.0, 1.0);
    gl_FragData[6] = vec4(distanceFromCamera, depth.r, waterShadingHeight, 1.0);
    if(isWaterBlock > 0.1f) return;
    gl_FragData[0] = albedo;
}