#version 460 compatibility
#define PI 3.14159265358979323846f

#define WATER_WAVES
#define WAVE_SPEED_X 1.0 // [0.25 0.5 0.75 1.0 1.25 1.5 1.75 2.0]
#define WAVE_SPEED_Y 1.0 // [0.25 0.5 0.75 1.0 1.25 1.5 1.75 2.0]
#define WAVE_DENSITY_X 1.0 // [0.25 0.5 0.75 1.0 1.25 1.5 1.75 2.0]
#define WAVE_DENSITY_Y 1.0 // [0.25 0.5 0.75 1.0 1.25 1.5 1.75 2.0]
#define WAVE_AMPLITUDE 1.0 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define WAVE_FALLOFF_START 8 // [2 4 6 8 10 12 16 20 24 28 32 48 64]
#define WAVE_FALLOFF_END 10 // [2 4 6 8 10 12 16 20 24 28 32 48 64]
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

	vec3 view_pos = vec4(gl_ModelViewMatrix * gl_Vertex).xyz;
	foot_pos = (gbufferModelViewInverse * vec4(view_pos, 1.0)).xyz;
	world_pos = foot_pos + cameraPosition;

	isWaterBlock = 0f;

	float distanceFromCamera = distance(viewSpaceFragPosition,vec3(0));
	
	if(mc_Entity.x == 8.0 && mc_Entity.x != 10002) {
        isWaterBlock = 1f;
		isWater = 0f;
		#ifdef WATER_WAVES
			vec2 waveCycle = vec2(sin((world_pos.x * WAVE_DENSITY_X * 7) + (frameTimeCounter * WAVE_SPEED_X)), -sin((world_pos.z * WAVE_DENSITY_Y * 7) + (frameTimeCounter * WAVE_SPEED_Y)));
			vec2 waveCycle2 = vec2(sin((world_pos.x * WAVE_DENSITY_X * 0.5) + (frameTimeCounter * WAVE_SPEED_X)), -sin((world_pos.z * WAVE_DENSITY_Y * 0.5) + (frameTimeCounter * WAVE_SPEED_Y)));
			float waveHeight = WAVE_AMPLITUDE * ((waveCycle.x + waveCycle.y)/2 + (waveCycle2.x + waveCycle2.y))/3;

			gl_Position += gbufferProjection * gbufferModelView * vec4(0, mix(waveHeight*0.25f - 0.3f, 0f, smoothstep(WAVE_FALLOFF_START * 16, WAVE_FALLOFF_END * 16, distanceFromCamera)), 0, 0);
			waterShadingHeight = ((waveCycle.x + waveCycle.y)/2 + (waveCycle2.x + waveCycle2.y))/3 + 1;
		#endif
    } else {
		isWater = 1f;
	}

	if(mc_Entity.x == 8.0 || mc_Entity.x == 10002) {
		isTransparent = 1.0;
	} else {
		isTransparent = 0.0;
	}

    Color = gl_Color;
    LightmapCoords = (LightmapCoords * 33.05f / 32.0f) - (1.05f / 32.0f);
}