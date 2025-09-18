#version 460 compatibility

#include "lib/globalDefines.glsl"

#define WATER_REFRACTION
#define WATER_FOAM

#define MIN_LIGHT 0.05f // [0.0f 0.05f 0.1f 0.15f 0.2f 0.25f 0.3f 0.35f 0.4f 0.45f 0.5f]

#define MAX_LIGHT 1.5f // [1.0f 1.1f 1.2f 1.3f 1.4f 1.5f 1.6f 1.7f 1.8f 1.9f 2.0f 2.1f 2.2f 2.3f 2.4f 2.5f 2.6f 2.7f 2.8f 2.9f 3.0f 3.1f 3.2f 3.3f 3.4f 3.5f 3.6f 3.7f 3.8f 3.9f 4.0f 4.1f]

#define GAMMA 2.2 // [1.0 1.2 1.4 1.6 1.8 2.0 2.2 2.4 2.6 2.8 3.0]

#include "lib/includes2.glsl"
#include "lib/optimizationFunctions.glsl"

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

uniform sampler2D water;

uniform int worldTime;
uniform int frameCounter;
uniform float frameTime;

uniform float viewWidth;
uniform float viewHeight;

uniform vec3 shadowLightPosition;

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

in vec3 world_pos;

in float waterShadingHeight;

uniform float near;
uniform float far;
uniform float dhNearPlane;
uniform float dhFarPlane;

layout (rgba8) uniform image2D cimage12;

/* RENDERTARGETS:0,1,2,3,5,12,15,14 */

mat3 tbnNormalTangent(vec3 normal, vec3 tangent) {
    vec3 bitangent = cross(tangent, normal);
    return mat3(tangent, bitangent, normal);
}

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

void main() {
    //vec4 albedo = texture2D(texture, TexCoords) * Color;

    mediump float isWater = Normal.w;

    vec2 texCoord = gl_FragCoord.xy / vec2(viewWidth,viewHeight);

    vec4 depth = texture2D(depthtex1, TexCoords);
    mediump float depth2 = texture(depthtex0,texCoord).r;

    mediump float discardDepth = 1f;

    if(depth2 == discardDepth) {
        vec3 ClipSpace = vec3(TexCoords, depth) * 2.0f - 1.0f;
        vec4 ViewW = gbufferProjectionInverse * vec4(ClipSpace, 1.0f);
        vec3 View = ViewW.xyz / ViewW.w;
        vec4 World = gbufferModelViewInverse * vec4(View, 1.0f);

        vec3 shadowLightDirection = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);

        vec3 worldNormal = (gbufferModelViewInverse * Normal).xyz;

        mediump float lightBrightness = clamp(dot(shadowLightDirection, worldNormal),max(0.2, MIN_LIGHT),MAX_LIGHT);
        
        //vec4 noiseMap = texture2D(noise, TexCoords + (sin(TexCoords.xy*32f + ((frameCounter)/90f)*0.0125f)/2 + 1)*2f);
        //vec4 noiseMap2 = texture2D(noise, TexCoords - (sin(TexCoords.xy*16f + ((frameCounter)/90f)*0.0125f)/2 + 1)*2f);

        vec4 albedo = texture2D(texture, TexCoords) * Color;
        vec3 Albedo = pow2(albedo.xyz, vec3(GAMMA));

        albedo.a = 0.5f;

        mediump float depth = texture2D(depthtex0, texCoord).r;
        mediump float dhDepth = gl_FragCoord.z;
        //mediump float depthLinear = calcDepth(depth, near, far*4);
        //mediump float dhDepthLinear = calcDepth(dhDepth, dhNearPlane, dhFarPlane);
        
        //vec4 finalNoise = mix2(noiseMap,noiseMap2,0.5f);
        
        if(mat == DH_BLOCK_WATER) {
            Albedo = vec3(0.0f, 0.33f, 0.44f);
            albedo.a = 0.0f;
        }

        //vec3 newNormal = tbnNormalTangent(Normal.xyz, Tangent) * Normal.xyz;

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

        /*if(blindness > 0f) {
            Albedo = blindEffect(Albedo);
        }*/

        if(mat == DH_BLOCK_WATER) {
            albedo.a = 0.0;
        }

        gl_FragData[0] = vec4(pow2(Albedo,vec3(1/GAMMA)), albedo.a);
        /*#ifndef SCENE_AWARE_LIGHTING
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
        #endif*/
        gl_FragData[3] = vec4(1.0);
        gl_FragData[6] = vec4(distanceFromCamera, dhDepth, waterShadingHeight, 1.0);

        gl_FragData[7] = vec4(dhDepth, 0.0, 0.0, 1.0);

        imageStore(cimage12, ivec2(gl_FragCoord.xy/10), vec4(dhDepth));

        if(mat == DH_BLOCK_WATER) {
            gl_FragData[4] = vec4(1.0, 0.0, 0.0, 1.0);
        } else {
            gl_FragData[4] = vec4(0.0, 0.0, 0.0, 1.0);
        }

        vec3 bitangent = normalize2(cross(Tangent.xyz, Normal.xyz));

        mat3 tbnMatrix = mat3(Tangent.xyz, bitangent.xyz, Normal.xyz);

        vec4 noiseMapA = triplanarTexture(fract((world_pos + ((frameCounter)/90f)*0.5f) * 0.035f), Normal.xyz, water, 1.0);
        vec4 noiseMapB = triplanarTexture(fract((world_pos - ((frameCounter)/90f)*0.5f) * 0.035f), Normal.xyz, water, 1.0);

        vec4 finalNoise = noiseMapA * noiseMapB;

        vec3 newNormal = Normal.xyz;

        newNormal = (gbufferModelViewInverse * vec4(newNormal,1.0)).xyz;

        albedo.a = 0.75f;
        
        //vec4 finalNoise = mix2(noiseMap,noiseMap2,0.5f);
        
        vec4 Lightmap;

        if(mat == DH_BLOCK_WATER) {
            albedo.xyz = mix2(vec3(0.0f,0.33f,0.55f),vec3(1.0f,1.0f,1.0f),pow2(finalNoise.x,5));
            albedo.a = 0.0f;//mix2(0.5f,1f,pow2(finalNoise.x,5));
            //Lightmap = vec4(LightmapCoords.x, LightmapCoords.y, 0.0, 1.0f);
            if(albedo.a < 0.75f) {
                albedo.a = 0.0;
            }

            //newNormal = tbnMatrix * finalNoise.xyz;

            newNormal = (gbufferModelViewInverse * vec4(newNormal,1.0)).xyz;

            #ifdef WATER_WAVES
                //newNormal = tbnMatrix * normalFromHeight(cSampler4, TexCoords/WATER_CHUNK_RESOLUTION, 1.0, true).xyz * 0.5 + 0.5;
                //newNormal = (gbufferModelViewInverse * vec4(newNormal,1.0)).xyz;
            #endif
        }
        gl_FragData[1] = vec4(newNormal * 0.5 + 0.5, 1.0);
    }
}