#version 460 compatibility
#define PI 3.14159265358979323846f

layout (r32ui) uniform uimage3D cimage1;

varying vec2 TexCoords;
varying vec4 Normal;
varying vec3 Tangent;
varying vec4 Color;

varying vec2 LightmapCoords;

varying float isWaterBlock;

uniform int worldTime;
uniform int frameCounter;
uniform float frameTime;

uniform vec3 chunkOffset;

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferProjection;

uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferModelView;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

uniform sampler2D depthtex0;

flat out int mat;

in vec4 at_tangent;

out vec3 block_centered_relative_pos;

out vec3 lightmap2;

out vec4 at_midBlock2;

out float isFoliage;

out float isReflective;

out vec3 worldSpaceVertexPosition;

out vec3 normals_face_world;

out vec3 foot_pos;

in vec3 at_midBlock;

in vec3 cameraPosition;


//in vec4 mc_Entity;

mediump float rand(vec2 c){
	return fract(sin(dot(c.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

mediump float noise(vec2 p, float freq ){
	mediump float unit = TexCoords.s/freq;
	vec2 ij = floor(p/unit);
	vec2 xy = mod(p,unit)/unit;
	//xy = 3.*xy*xy-2.*xy*xy*xy;
	xy = .5*(1.-cos(PI*xy));
	mediump float a = 0f;//rand((ij+vec2(0.,0.)));
	mediump float b = 1f;//rand((ij+vec2(1.,0.)));
	mediump float c = 0f;//rand((ij+vec2(0.,1.)));
	mediump float d = 1f;//rand((ij+vec2(1.,1.)));
	mediump float x1 = mix(a, b, xy.x);
	mediump float x2 = mix(c, d, xy.x);
	return mix(x1, x2, xy.y);
}

mediump float pNoise(vec2 p, int res){
	mediump float persistance = .5;
	mediump float n = 0.;
	mediump float normK = 0.;
	mediump float f = 4.;
	mediump float amp = 1.;
	int iCount = 0;
	for (int i = 0; i<50; i++){
		n+=amp*noise(p, f);
		f*=2.;
		normK+=amp;
		amp*=persistance;
		if (iCount == res) break;
		iCount++;
	}
	mediump float nf = n/normK;
	return nf*nf*nf*nf;
}

void main() {
	gl_Position = ftransform();
	TexCoords = gl_MultiTexCoord0.st;
	Normal = vec4(normalize(gl_NormalMatrix * gl_Normal), 1.0f);
	Tangent = normalize(gl_NormalMatrix * at_tangent.xyz);
	LightmapCoords = mat2(gl_TextureMatrix[1]) * gl_MultiTexCoord1.st;

	mat = dhMaterialId;
	/*if(mc_Entity.x == 8.0 || mc_Entity.x == 9.0) {
		mediump float depth = texture2D(depthtex0, TexCoords).r;
		vec3 ClipSpace = vec3(TexCoords, depth) * 2.0f - 1.0f;
		vec4 ViewW = gbufferProjectionInverse * vec4(ClipSpace, 1.0f);
		vec3 View = ViewW.xyz / ViewW.w;
		vec4 World = gbufferModelViewInverse * vec4(View, 1.0f);
		Normal.w = 0.0f;
		vec4 waterDistort = vec4(clamp(sin(World.x*32f + ((frameCounter)/90f)),0,1)*0.025f);
		vec4 waterDistortScreen = gbufferModelViewInverse * vec4(0,waterDistort.y,0,0);
		waterDistortScreen = gbufferProjection * waterDistortScreen;
		Normal.xy += waterDistortScreen.xy;

		LightmapCoords += gl_Position.xy;*/
		
		//isWaterBlock = 1;

		//gl_Position.y /= ViewW.y;
	/*} else {
		isWaterBlock = 0;
	}*/

	//gl_Position.y += sin(((ViewW.x + worldTime/10.0f) + (ViewW.z + worldTime/5.0f) * (180.0f/PI))) * 0.25f;

    //gl_Position.y += sin(TexCoords + (worldTime*0.001f));

    Color = gl_Color;
    LightmapCoords = (LightmapCoords * 33.05f / 32.0f) - (1.05f / 32.0f);

	/*#ifdef SCENE_AWARE_LIGHTING
        vec3 view_pos = vec4(gl_ModelViewMatrix * gl_Vertex).xyz;
        foot_pos = (gbufferModelViewInverse * vec4(view_pos, 1.0)).xyz;
        vec3 world_pos = foot_pos + cameraPosition;
        #define VOXEL_AREA 128 //[32 64 128]
        #define VOXEL_RADIUS (VOXEL_AREA/2)
        block_centered_relative_pos = foot_pos +at_midBlock.xyz/64.0 + fract(cameraPosition);
        ivec3 voxel_pos = ivec3(block_centered_relative_pos + VOXEL_RADIUS);

        if(mod(gl_VertexID,4) == 0 && clamp(voxel_pos,0,VOXEL_AREA) == voxel_pos) {
            vec4 voxel_data = mc_Entity.x == 10005? vec4(1.0) : mc_Entity.x == 10006? vec4(1.0) : mc_Entity.x == 10007? vec4(1.0) : mc_Entity.x == 10008? vec4(1.0) : mc_Entity.x == 10009? vec4(1.0) : mc_Entity.x == 10010? vec4(1.0) : mc_Entity.x == 10012? vec4(1.0) : vec4(vec3(0.0),1.0);

            /*if(length(voxel_data.xyz) <= 0.0) {
                voxel_data = vec4(at_midBlock.w);
            }

            vec4 block_data = vec4(vec3(0.0),1.0);
            if(length(Normal.xyz) > 0.0 && mc_Entity.x != 2 && mc_Entity.x != 10003) block_data = vec4(1.0);

            uint integerValue = packUnorm4x8(voxel_data);
			
			//uint integerValue2 = packUnorm4x8(block_data);

            imageAtomicMax(cimage1, voxel_pos, integerValue);

			//imageAtomicMax(cimage2, voxel_pos, integerValue2);
        }
    #endif*/
}