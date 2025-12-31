#version 460 compatibility

#include "lib/globalDefines.glsl"

#define DISTANT_HORIZONS

#define PATH_TRACING_GI 0 // [0 1]

#define VERTEX_SHADER

layout (r32ui) uniform uimage3D cimage3;

uniform mat4 dhProjection;

out vec4 blockColor;
out vec2 lightmapCoords;
out vec3 viewSpaceFragPosition;

out vec3 playerPos;

out float isWaterBlock;

out vec3 Normal;
out vec3 Tangent;

varying float timePhase;
varying float quadTime;
uniform int worldTime;
uniform int frameCounter;
uniform float frameTime;

in vec4 mc_Entity;

in vec3 at_tangent;

out vec3 block_centered_relative_pos;

out vec3 lightmap2;

out vec4 at_midBlock2;

out float isFoliage;

out float isReflective;

out vec3 worldSpaceVertexPosition;

out vec3 normals_face_world;

out vec3 foot_pos;

out vec3 view_pos;

in vec3 at_midBlock;

in vec3 cameraPosition;

#include "program/pathTracing.glsl"

void main() {
    Normal = (gl_NormalMatrix * gl_Normal);

    Tangent = at_tangent.xyz;

    blockColor = gl_Color;

    #if PATH_TRACING_GI == 1
            lightmap2 = GenerateLightmap(0f,1f);
    #endif
    lightmapCoords = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    //lightmapCoords = (lightmapCoords * 33.05f / 32.0f) - (1.05f / 32.0f);

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

    isWaterBlock = 0f;
	
	if(mc_Entity.x == 8.0 && mc_Entity.x != 10002) {
        isWaterBlock = 1f;
    }

    playerPos = (gbufferModelViewInverse * gl_ModelViewMatrix * gl_Vertex).xyz;

    gl_Position = ftransform();

    #ifdef WORLD_CURVATURE
        float d = length(playerPos);
        float R = 63710.0;

        float drop = (d * d) / (2.0 * R);

        gl_Position.y -= drop;
    #endif

    #if SCENE_AWARE_LIGHTING > 0
        view_pos = vec4(gl_ModelViewMatrix * gl_Vertex).xyz;
        foot_pos = (gbufferModelViewInverse * vec4(view_pos, 1.0)).xyz;
        vec3 world_pos = foot_pos + cameraPosition;
        block_centered_relative_pos = foot_pos +at_midBlock.xyz/64.0 + fract(cameraPosition);
        ivec3 voxel_pos = ivec3(block_centered_relative_pos + VOXEL_RADIUS);

        if(mod(gl_VertexID,4) == 0 && clamp(voxel_pos,0,VOXEL_AREA) == voxel_pos) {
            vec4 voxel_data = dhMaterialId == DH_BLOCK_ILLUMINATED? vec4(1.0) : vec4(vec3(0.0),1.0);

            /*if(length(voxel_data.xyz) <= 0.0) {
                voxel_data = vec4(at_midBlock.w);
            }*/

            vec4 block_data = vec4(vec3(0.0),1.0);
            if(length(Normal.xyz) > 0.0 && mc_Entity.x != 2 && mc_Entity.x != 10003) block_data = vec4(1.0);

            uint integerValue = packUnorm4x8(voxel_data);
			
			//uint integerValue2 = packUnorm4x8(block_data);

            imageAtomicMax(cimage3, voxel_pos, integerValue);

			//imageAtomicMax(cimage2, voxel_pos, integerValue2);
        }
    #endif

    
}