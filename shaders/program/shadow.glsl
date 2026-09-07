#ifdef FRAGMENT_SHADER
    #define SHADOWS_ENABLED
    //#define ENTITY_SHADOWS
    #define SHADOW_DIST 12 // [4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32]

    varying vec2 TexCoords;
    varying vec4 Color;

    uniform sampler2D texture;

    uniform vec3 chunkOffset;
    uniform mat4 modelViewMatrix;
    uniform mat4 projectionMatrix;
    uniform vec3 cameraPosition;

    uniform int entityId;

    uniform float rainFactor;

    in vec3 vaPosition;

    layout (rgba8) uniform image3D cimage2;
    uniform usampler3D cSampler1;

    #include "/lib/globalDefines.glsl"

    #include "/lib/includes2.glsl"
    #include "/lib/optimizationFunctions.glsl"

    //flat in vec3 mc_Entity;

    void main() {
        #ifdef SHADOWS_ENABLED
            vec3 worldSpaceVertexPosition = cameraPosition + (gbufferModelViewInverse * projectionMatrix * modelViewMatrix * vec4(vaPosition,1)).xyz;
            mediump float distanceFromCamera = distance(worldSpaceVertexPosition, cameraPosition);
            
            if(distanceFromCamera < SHADOW_DIST * 16) {
                #ifndef ENTITY_SHADOWS
                    /*if(entityId == 10006 || mc_Entity.x == 10005) {
                        discard;
                    }*/
                    gl_FragData[0] = texture2D(texture, TexCoords) * Color;
                #else
                    gl_FragData[0] = texture2D(texture, TexCoords) * Color;
                #endif
            }
        #endif
    }
#endif

#ifdef VERTEX_SHADER
    uniform float near;
    uniform float far;

    uniform int viewWidth;
    uniform int viewHeight;

    uniform vec3 cameraPosition;

    layout (r32ui) uniform uimage3D cimage1;

    in vec4 at_midBlock;
    in vec4 mc_Entity;

    uniform mat4 shadowModelViewInverse;

    #include "/lib/globalDefines.glsl"

    #include "/lib/includes2.glsl"
    #include "/lib/optimizationFunctions.glsl"
    #include "distort.glsl"
    //#define ENTITY_SHADOWS

    uniform float frameTimeCounter;

    varying vec2 TexCoords;
    varying vec4 Color;

    void main() {
        gl_Position = ftransform();
        gl_Position.xy = DistortPosition(gl_Position.xy);
        TexCoords = gl_MultiTexCoord0.st;
        Color = gl_Color;

        #if LIGHTING_MODE > 0 && SCENE_AWARE_LIGHTING > 0
            vec3 shadow_view_pos = vec4(gl_ModelViewMatrix * gl_Vertex).xyz;
	        vec3 foot_pos = (shadowModelViewInverse * vec4( shadow_view_pos ,1.) ).xyz;
            vec3 world_pos = foot_pos + cameraPosition;
            vec3 block_centered_relative_pos = foot_pos +at_midBlock.xyz/64.0 + fract(cameraPosition);
            ivec3 voxel_pos = ivec3(block_centered_relative_pos + VOXEL_RADIUS);

            uint voxel_data = mc_Entity.x == 10005? 1 : mc_Entity.x == 10006? 2 : mc_Entity.x == 10007? 3 : mc_Entity.x == 10008? 4 : mc_Entity.x == 10009? 5 : mc_Entity.x == 10010? 6 : mc_Entity.x == 10012? 7 : mc_Entity.x == 10013? 8 : 0;

            if(frameTimeCounter < 1. && distance(vec3(voxel_pos),vec3(VOXEL_RADIUS))< 3.)
            {
                voxel_data = 0;
            }
            
            if(mod(gl_VertexID,2)==0) imageAtomicMax(cimage1, voxel_pos, voxel_data);
        #endif     
    }
#endif