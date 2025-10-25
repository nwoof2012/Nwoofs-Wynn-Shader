#version 460 compatibility
#define PI 3.14159265358979323846f

#define WATER_WAVES
#define WAVE_SPEED_X 1.0 // [0.25 0.5 0.75 1.0 1.25 1.5 1.75 2.0]
#define WAVE_SPEED_Y 1.0 // [0.25 0.5 0.75 1.0 1.25 1.5 1.75 2.0]
#define WAVE_DENSITY_X 1.0 // [0.25 0.5 0.75 1.0 1.25 1.5 1.75 2.0]
#define WAVE_DENSITY_Y 1.0 // [0.25 0.5 0.75 1.0 1.25 1.5 1.75 2.0]
#define WAVE_AMPLITUDE 1.0 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define WATER_CHUNK_RESOLUTION 128 // [32 64 128]

precision mediump float;

varying vec2 TexCoords;
varying vec4 Normal;
varying vec3 Tangent;
varying vec4 Color;

varying vec2 LightmapCoords;

layout (r32ui) uniform uimage3D cimage1;
layout (r32ui) uniform uimage3D cimage2;
layout (r32ui) uniform uimage2D cimage4;

varying float isWaterBlock;

out float isTransparent;

uniform int worldTime;
uniform int frameCounter;
uniform float frameTime;
uniform float frameTimeCounter;

uniform vec3 chunkOffset;

uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

in vec4 at_tangent;

out float isWater;

uniform sampler2D depthtex0;

in vec4 mc_Entity;

out vec4 at_midBlock2;

out float isFoliage;

out float isReflective;

out vec3 worldSpaceVertexPosition;

out vec3 normals_face_world;

out vec3 foot_pos;

out vec3 world_pos;

out vec4 lightSourceData;

out vec3 block_centered_relative_pos;

in vec4 at_midBlock;
attribute vec4 mc_midTexCoord;

uniform vec3 cameraPosition;

out float waterShadingHeight;

#include "lib/globalDefines.glsl"

float rand(vec2 c){
	return fract(sin(dot(c.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float noise(vec2 p, float freq ){
	float unit = TexCoords.s/freq;
	vec2 ij = floor(p/unit);
	vec2 xy = mod(p,unit)/unit;
	//xy = 3.*xy*xy-2.*xy*xy*xy;
	xy = .5*(1.-cos(PI*xy));
	float a = 0f;//rand((ij+vec2(0.,0.)));
	float b = 1f;//rand((ij+vec2(1.,0.)));
	float c = 0f;//rand((ij+vec2(0.,1.)));
	float d = 1f;//rand((ij+vec2(1.,1.)));
	float x1 = mix(a, b, xy.x);
	float x2 = mix(c, d, xy.x);
	return mix(x1, x2, xy.y);
}

float pNoise(vec2 p, int res){
	float persistance = .5;
	float n = 0.;
	float normK = 0.;
	float f = 4.;
	float amp = 1.;
	int iCount = 0;
	for (int i = 0; i<50; i++){
		if (iCount != res)
		{
			n+=amp*noise(p, f);
			f*=2.;
			normK+=amp;
			amp*=persistance;
			iCount++;
		}
	}
	float nf = n/normK;
	return nf*nf*nf*nf;
}

void main() {
	gl_Position = ftransform();
	TexCoords = gl_MultiTexCoord0.st;
	Normal = vec4(normalize(gl_NormalMatrix * gl_Normal), 1.0f);
	Tangent = normalize(gl_NormalMatrix * at_tangent.xyz);
	LightmapCoords = mat2(gl_TextureMatrix[1]) * gl_MultiTexCoord1.st;
	/*if((mc_Entity.x == 8.0 || mc_Entity.x == 9.0) && mc_Entity.x != 10002) {
		float depth = texture2D(depthtex0, TexCoords).r;
		vec3 ClipSpace = vec3(TexCoords, depth) * 2.0f - 1.0f;
		vec4 ViewW = gbufferProjectionInverse * vec4(ClipSpace, 1.0f);
		vec3 View = ViewW.xyz / ViewW.w;
		vec4 World = gbufferModelViewInverse * vec4(View, 1.0f);
		isWater = 0.0f;
		vec4 waterDistort = vec4(clamp(sin(World.x*32f + ((frameCounter)/90f)),0,1)*0.025f);
		vec4 waterDistortScreen = gbufferModelViewInverse * vec4(0,waterDistort.y,0,0);
		waterDistortScreen = gbufferProjection * waterDistortScreen;
		//Normal.xy += waterDistortScreen.xy;

		//LightmapCoords += gl_Position.xy;

		//gl_Position.y /= ViewW.y;
	}*/

	vec3 view_pos = vec4(gl_ModelViewMatrix * gl_Vertex).xyz;
	foot_pos = (gbufferModelViewInverse * vec4(view_pos, 1.0)).xyz;
	world_pos = foot_pos + cameraPosition;

	/*#if SCENE_AWARE_LIGHTING > 0
        #define VOXEL_AREA 128 //[32 64 128]
        #define VOXEL_RADIUS (VOXEL_AREA/2)
        block_centered_relative_pos = foot_pos +at_midBlock.xyz/64.0 + fract(cameraPosition);
        ivec3 voxel_pos = ivec3(block_centered_relative_pos + VOXEL_RADIUS);

        if(mod(gl_VertexID,4) == 0 && clamp(voxel_pos,0,VOXEL_AREA) == voxel_pos) {
            vec4 voxel_data = mc_Entity.x == 10005? vec4(1.0,0.0,0.0,1.0) : mc_Entity.x == 10006? vec4(0.0,1.0,0.0,1.0) : mc_Entity.x == 10007? vec4(0.0,0.0,1.0,1.0) : mc_Entity.x == 10008? vec4(1.0,1.0,0.0,1.0) : mc_Entity.x == 10009? vec4(0.0,1.0,1.0,1.0) : mc_Entity.x == 10010? vec4(1.0,0.0,1.0,1.0) : mc_Entity.x == 10012? vec4(1.0) : mc_Entity.x == 10013? vec4(0.5,0.0,0.0,1.0) : vec4(vec3(0.0),1.0);

			if(mc_Entity.x == 8.0) voxel_data = vec4(0.0);

			vec4 block_data = mc_Entity.x == 1? vec4(0.0) : vec4(1.0);

            uint integerValue = packUnorm4x8(voxel_data);
			
			uint integerValue2 = packUnorm4x8(block_data);

            imageAtomicMax(cimage1, voxel_pos, integerValue);

			imageAtomicMax(cimage2, voxel_pos, integerValue2);
        }
    #endif*/

	//gl_Position.y += sin(((ViewW.x + worldTime/10.0f) + (ViewW.z + worldTime/5.0f) * (180.0f/PI))) * 0.25f;

    //gl_Position.y += sin(TexCoords + (worldTime*0.001f));

	isWaterBlock = 0f;
	
	if(mc_Entity.x == 8.0 && mc_Entity.x != 10002) {
        isWaterBlock = 1f;
		//Distort water
		#ifdef WATER_WAVES
			//vec4 worldPos = gbufferProjectionInverse * gbufferModelViewInverse * gl_Position;
			//worldPos.xyz += foot_pos;
			vec2 waveCycle = vec2(sin((world_pos.x * WAVE_DENSITY_X * 7) + (frameTimeCounter * WAVE_SPEED_X)), -sin((world_pos.z * WAVE_DENSITY_Y * 7) + (frameTimeCounter * WAVE_SPEED_Y)));
			vec2 waveCycle2 = vec2(sin((world_pos.x * WAVE_DENSITY_X * 0.5) + (frameTimeCounter * WAVE_SPEED_X)), -sin((world_pos.z * WAVE_DENSITY_Y * 0.5) + (frameTimeCounter * WAVE_SPEED_Y)));
			float waveHeight = WAVE_AMPLITUDE * ((waveCycle.x + waveCycle.y)/2 + (waveCycle2.x + waveCycle2.y))/3;
			//Normal *= waveHeight;

			//uint integerValue4 = uint(waveHeight * 32767);

			//imageAtomicMax(cimage4, ivec2(world_pos.xy * WATER_CHUNK_RESOLUTION), integerValue4);

			gl_Position += gbufferProjection * gbufferModelView * vec4(0, waveHeight*0.25f - 0.3f, 0, 0);
			waterShadingHeight = ((waveCycle.x + waveCycle.y)/2 + (waveCycle2.x + waveCycle2.y)) + 1;
		#endif
    }

	if(mc_Entity.x == 8.0 || mc_Entity.x == 10002) {
		isTransparent = 1.0;
	} else {
		isTransparent = 0.0;
	}

    Color = gl_Color;
    LightmapCoords = (LightmapCoords * 33.05f / 32.0f) - (1.05f / 32.0f);
}