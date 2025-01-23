#version 460 compatibility

#include "lib/globalDefines.glsl"

#define WATER_REFRACTION
#define WATER_FOAM

#include "lib/includes2.glsl"
#include "lib/optimizationFunctions.glsl"
#include "program/blindness.glsl"

precision mediump float;

uniform usampler3D cSampler1;

varying vec2 TexCoords;
varying vec4 Normal;
varying vec3 Tangent;
varying vec4 Color;

varying vec2 LightmapCoords;

varying float isWaterBlock;

uniform sampler2D texture;

uniform sampler2D gDepth;

uniform sampler2D noise;

uniform sampler2D colortex0;

uniform sampler2D depthtex1;
uniform sampler2D depthtex0;

uniform mat4 gbufferProjectionInverse;

uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

uniform int worldTime;
uniform int frameCounter;
uniform float frameTime;

uniform float viewWidth;
uniform float viewHeight;

uniform bool isBiomeEnd;

flat in int mat;

in vec3 block_centered_relative_pos;

in vec3 lightmap2;

in vec4 at_midBlock2;

in float isFoliage;

in float isReflective;

in vec3 worldSpaceVertexPosition;

in vec3 normals_face_world;

in vec3 foot_pos;

/* DRAWBUFFERS:01235 */

mat3 tbnNormalTangent(vec3 normal, vec3 tangent) {
    vec3 bitangent = cross(tangent, normal);
    return mat3(tangent, bitangent, normal);
}

void main() {
    //vec4 albedo = texture2D(texture, TexCoords) * Color;

    mediump float isWater = Normal.w;

    vec2 texCoord = gl_FragCoord.xy / vec2(viewWidth,viewHeight);

    vec4 depth = texture2D(depthtex1, TexCoords);
    mediump float depth2 = texture(depthtex0,texCoord).r;

    mediump float discardDepth = 1f;

    if(depth2 != discardDepth) {
        discard;
    }

    vec3 ClipSpace = vec3(TexCoords, depth) * 2.0f - 1.0f;
    vec4 ViewW = gbufferProjectionInverse * vec4(ClipSpace, 1.0f);
    vec3 View = ViewW.xyz / ViewW.w;
    vec4 World = gbufferModelViewInverse * vec4(View, 1.0f);
    
    vec4 noiseMap = texture2D(noise, TexCoords + (sin(TexCoords.xy*32f + ((frameCounter)/90f)*0.0125f)/2 + 1)*2f);
    vec4 noiseMap2 = texture2D(noise, TexCoords - (sin(TexCoords.xy*16f + ((frameCounter)/90f)*0.0125f)/2 + 1)*2f);

    vec4 albedo = texture2D(texture, TexCoords) * Color;

    albedo.a = 0.5f;
    
    vec4 finalNoise = mix2(noiseMap,noiseMap2,0.5f);
    
    if(mat == DH_BLOCK_WATER) {
        albedo.xyz = vec3(0.0f, 0.33f, 0.44f);
        albedo.a = 0.0f;
    }

    vec3 newNormal = tbnNormalTangent(Normal.xyz, Tangent) * Normal.xyz;

    /*if(isBiomeEnd) {
        albedo.xyz = mix2(albedo.xyz, vec3(dot(albedo.xyz, vec3(0.333))),0.5);
    } /*else {
        albedo.xyz = mix2(albedo.xyz,lightColor,0.125f);
    }*/

    //vec4 normalDefine = vec4(noiseMap.xyz * 0.5 + 0.5f, 1.0f);
    //normalDefine = normalDefine + noiseMap;

    vec2 TexCoords2 = texCoord;
    //mediump float Depth = texture2D(depthtex0, texCoord).r;
    //mediump float Depth2 = texture2D(depthtex1, texCoord).r;
    vec3 Albedo;
    mediump float isBlockWater = float(Color.z > Color.y && Color.y > Color.x);
    /*if(depth.r != depth2 && isBlockWater > 0) {
        #ifdef WATER_REFRACTION
            vec4 noiseMap = texture2D(noise, texCoord + sin(texCoord.y*32f + ((frameCounter)/90f)*0.05f) * 0.001f);
            vec4 noiseMap2 = texture2D(noise, texCoord - sin(texCoord.y*16f + ((frameCounter)/90f)*0.05f) * 0.001f);
            vec4 finalNoise = mix2(noiseMap,noiseMap2,0.5f);

            TexCoords2 += finalNoise.xy * vec2(0.125f);
        #endif

        Albedo = mix2(mix2(texture2D(colortex0, TexCoords2).rgb,vec3(0.0f,0.33f,0.55f),clamp((0.5 - (depth.r - depth2)) * 0.5,0,1)), vec3(2.2f));
        #ifdef WATER_FOAM
            if(abs(depth.r - depth2) < 0.0005f) {
                Albedo = mix2(Albedo, vec3(1.0f), clamp(1 - abs(depth.r - depth2),0f,1));
            }
        #endif
        albedo.xyz = Albedo;
        albedo.a = 0.0f;//mix2(0.5f, 0.5f, clamp(1 - abs(depth.r - depth2),0f,1));
    }*/
    float distanceFromCamera = distance(vec3(0), viewSpaceFragPosition);

    if(blindness > 0f) {
        albedo.xyz = blindEffect(albedo.xyz);
    }

    if(mat == DH_BLOCK_WATER) {
        albedo.a = 0.0;
    }

    gl_FragData[0] = albedo;
    gl_FragData[1] = vec4(newNormal, 1.0);
    #ifndef SCENE_AWARE_LIGHTING
        gl_FragData[2] = vec4(LightmapCoords.x, LightmapCoords.x, LightmapCoords.y, 1.0f);
    #else
        #define VOXEL_AREA 128 //[32 64 128]
        #define VOXEL_RADIUS (VOXEL_AREA/2)
        ivec3 voxel_pos = ivec3(block_centered_relative_pos+VOXEL_RADIUS);
        vec3 light_color = vec3(0.0);// = texture3D(cSampler1, vec3(foot_pos+2.0*normals_face_world+fract(cameraPosition) + VOXEL_RADIUS)).rgb;
        if(clamp(voxel_pos,0,VOXEL_AREA) == voxel_pos) {
            vec4 bytes = unpackUnorm4x8(texture3D(cSampler1,vec3(voxel_pos)/vec3(VOXEL_AREA)).r);
            light_color = bytes.xyz;
        }

        gl_FragData[2] = vec4(light_color, 1.0);
    #endif
    gl_FragData[3] = vec4(1.0);
    if(mat == DH_BLOCK_WATER) {
        gl_FragData[4] = vec4(1.0, 0.0, 0.0, 1.0);
    } else {
        gl_FragData[4] = vec4(0.0, 0.0, 0.0, 1.0);
    }
}