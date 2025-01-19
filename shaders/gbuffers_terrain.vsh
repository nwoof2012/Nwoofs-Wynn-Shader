#version 460 compatibility

#include "lib/globalDefines.glsl"

#define PATH_TRACING_GI 0 // [0 1]

#define WAVING_FOLIAGE
#define FOLIAGE_SPEED 1.0f // [0.1f 0.2f 0.3f 0.4f 0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f 1.6f 1.7f 1.8f 1.9f 2.0f]
#define FOLIAGE_INTENSITY 1.0f // [0.1f 0.2f 0.3f 0.4f 0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f 1.6f 1.7f 1.8f 1.9f 2.0f]
#define FOLIAGE_WAVE_DISTANCE 4 // [2 4 8 16 32]

struct LightSource {
    int id;
    float brightness;
};

layout (r32ui) uniform uimage3D cimage1;
layout (r32ui) uniform uimage3D cimage2;

in vec3 vaPosition;
in vec2 vaUV0;
in vec4 vaColor;
in ivec2 vaUV2;

varying vec2 TexCoords;
varying vec3 Normal;
varying vec3 Tangent;
varying vec4 Color;

varying vec2 LightmapCoords;

uniform float worldTime;
uniform float frameTimeCounter;

uniform vec3 cameraPosition;
uniform vec3 chunkOffset;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelView;
uniform mat4 gbufferProjection;
uniform mat4 modelViewMatrix;

out vec3 viewSpaceFragPosition;

out vec4 lightSourceData;

out vec3 block_centered_relative_pos;

in vec4 mc_Entity;
attribute vec4 mc_midTexCoord;

in vec4 at_midBlock;

in vec4 at_tangent;

out vec4 at_midBlock2;

out float isFoliage;

out float isReflective;

out vec3 worldSpaceVertexPosition;

out vec3 normals_face_world;

out vec3 foot_pos;

out vec2 signMidCoordPos;
flat out vec2 absMidCoordPos;
flat out vec2 midCoord;

const vec3 TorchColor = vec3(1.0f, 0.25f, 0.08f);
const vec3 GlowstoneColor = vec3(1.0f, 0.85f, 0.5f);
const vec3 LampColor = vec3(1.0f, 0.75f, 0.4f);
const vec3 LanternColor = vec3(0.8f, 1.0f, 1.0f);
const vec3 RedstoneColor = vec3(1.0f, 0.0f, 0.0f);
const vec3 RodColor = vec3(1.0f, 1.0f, 1.0f);
const vec3 PortalColor = vec3(0.75f, 0.0f, 1.0f);

vec3 GetRawWave(in vec3 pos, float wind) {
    float magnitude = sin(wind * 0.0027 + pos.z + pos.y) * 0.04 + 0.04;
    float d0 = sin(wind * 0.0127);
    float d1 = sin(wind * 0.0089);
    float d2 = sin(wind * 0.0114);
    vec3 wave;
    wave.x = sin(wind*0.0063 + d0 + d1 - pos.x + pos.z + pos.y) * magnitude;
    wave.z = sin(wind*0.0224 + d1 + d2 + pos.x - pos.z + pos.y) * magnitude;
    wave.y = sin(wind*0.0015 + d2 + d0 + pos.z + pos.y - pos.y) * magnitude;

    return wave;
}

vec4 GenerateLightmap(LightSource source) {
    switch (source.id) {
        case 10005:
            return vec4(1,0,0, source.brightness);
        case 10006:
            return vec4(0,1,0, source.brightness);
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

    worldSpaceVertexPosition = cameraPosition + (gbufferModelViewInverse * modelViewMatrix * vec4(vaPosition + chunkOffset,1.0)).xyz;

    foot_pos = vec4(gl_ModelViewMatrix * gl_Vertex).xyz;

    vec3 chunkVertexPosition = cameraPosition + (gbufferModelViewInverse * modelViewMatrix * vec4(vaPosition,1.0)).xyz;

	float distanceFromCamera = distance(worldSpaceVertexPosition, cameraPosition);

    LightmapCoords = mat2(gl_TextureMatrix[1]) * gl_MultiTexCoord1.st;

    LightmapCoords = (LightmapCoords * 33.05f / 32.0f) - (1.05f / 32.0f);
    Normal = normalize(gl_NormalMatrix * gl_Normal);
    Tangent = (gl_NormalMatrix * at_tangent.xyz);
    Color = gl_Color;

    normals_face_world = (gbufferModelViewInverse * vec4(Normal,1.0)).xyz;

    float bottomY = at_midBlock.y - 0.5;

    at_midBlock2 = at_midBlock;

    if(mc_Entity.x == 10001 || mc_Entity.x == 10003) {
        isFoliage = 1.0;
    } else {
        isFoliage = 0.0;
    }

    if(mc_Entity.x == 10011) {
        isReflective = 1.0;
    } else {
        isReflective = 0.0;
    }

    midCoord = (gl_TextureMatrix[0] * mc_midTexCoord).st;
    vec2 texMinMidCoord = TexCoords - midCoord;
    absMidCoordPos  = abs(texMinMidCoord);

    #ifdef WAVING_FOLIAGE
        if(isFoliage == 1.0 && distanceFromCamera <= FOLIAGE_WAVE_DISTANCE * 16.0) {
            vec3 waving = vec3(FOLIAGE_INTENSITY * sin(frameTimeCounter * FOLIAGE_SPEED));
            //vec3 waving = GetRawWave(worldSpaceVertexPosition, FOLIAGE_INTENSITY);
            //waving = mix(vec3(0.0), waving, abs(sin(frameTimeCounter * FOLIAGE_SPEED)));
            gl_Position += gbufferProjection * gbufferModelView * (vec4(waving.x,0.0,waving.x,0.0)*(clamp(pow(1.0 - bottomY,1.5),0,1)) * 0.125);
            //LightmapCoords2 += waving;
        }
    #endif

    #ifdef SCENE_AWARE_LIGHTING
        vec3 view_pos = vec4(gl_ModelViewMatrix * gl_Vertex).xyz;
        foot_pos = (gbufferModelViewInverse * vec4(view_pos, 1.0)).xyz;
        vec3 world_pos = foot_pos + cameraPosition;
        #define VOXEL_AREA 128 //[32 64 128]
        #define VOXEL_RADIUS (VOXEL_AREA/2)
        block_centered_relative_pos = foot_pos +at_midBlock.xyz/64.0 + fract(cameraPosition);
        ivec3 voxel_pos = ivec3(block_centered_relative_pos + VOXEL_RADIUS);

        if(mod(gl_VertexID,4) == 0 && clamp(voxel_pos,0,VOXEL_AREA) == voxel_pos) {
            vec4 voxel_data = mc_Entity.x == 10005? vec4(1.0,0.0,0.0,1.0) : mc_Entity.x == 10006? vec4(0.0,1.0,0.0,1.0) : mc_Entity.x == 10007? vec4(0.0,0.0,1.0,1.0) : mc_Entity.x == 10008? vec4(1.0,1.0,0.0,1.0) : mc_Entity.x == 10009? vec4(0.0,1.0,1.0,1.0) : mc_Entity.x == 10010? vec4(1.0,0.0,1.0,1.0) : mc_Entity.x == 10012? vec4(1.0) : vec4(vec3(0.0),1.0);

            /*if(length(voxel_data.xyz) <= 0.0) {
                voxel_data = vec4(at_midBlock.w);
            }*/

            vec4 block_data = vec4(vec3(0.0),1.0);
            if(length(Normal.xyz) > 0.0 && mc_Entity.x != 2 && mc_Entity.x != 10003) block_data = vec4(1.0);

            uint integerValue = packUnorm4x8(voxel_data);
			
			uint integerValue2 = packUnorm4x8(block_data);

            imageAtomicMax(cimage1, voxel_pos, integerValue);

			imageAtomicMax(cimage2, voxel_pos, integerValue2);
        }

        LightSource source;
        source.id = int(mc_Entity.x);
        source.brightness = LightmapCoords.x;
        lightSourceData = GenerateLightmap(source);
    #endif
}