#ifdef FRAGMENT_SHADER
    #define WATER_WAVES
    #define WATER_WAVES_DISTANCE 12 // [4 6 8 10 12 14 16]
    #define WATER_CHUNK_RESOLUTION 128 // [32 64 128]

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

    uniform sampler3D cSampler4;

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
    flat in ivec3 voxel_pos;

    in vec3 foot_pos;

    in vec3 world_pos;

    in vec4 at_midBlock2;

    uniform float caveFactor;

    in float waterShadingHeight;

    uniform float near;
    uniform float far;

    in float isGlass;

    in float isStainedGlass;

    #include "/lib/globalDefines.glsl"

    #include "/lib/includes2.glsl"
    #include "/lib/optimizationFunctions.glsl"

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

    vec4 lightTrilinear(sampler3D tex, vec3 coords, ivec3 voxel_pos) {
        vec3 p000 = vec3(voxel_pos)/vec3(VOXEL_AREA);
        vec3 p100 = (vec3(voxel_pos) + vec3(1, 0, 0))/vec3(VOXEL_AREA);
        vec3 p010 = (vec3(voxel_pos) + vec3(0, 1, 0))/vec3(VOXEL_AREA);
        vec3 p001 = (vec3(voxel_pos) + vec3(0, 0, 1))/vec3(VOXEL_AREA);
        vec3 p110 = (vec3(voxel_pos) + vec3(1, 1, 0))/vec3(VOXEL_AREA);
        vec3 p101 = (vec3(voxel_pos) + vec3(1, 0, 1))/vec3(VOXEL_AREA);
        vec3 p011 = (vec3(voxel_pos) + vec3(0, 1, 1))/vec3(VOXEL_AREA);
        vec3 p111 = (vec3(voxel_pos) + vec3(1, 1, 1))/vec3(VOXEL_AREA);

        vec3 f = fract(coords + VOXEL_RADIUS);

        vec4 c000 = texture3D(tex, p000).rgba;
        vec4 c100 = texture3D(tex, p100).rgba;
        vec4 c010 = texture3D(tex, p010).rgba;
        vec4 c001 = texture3D(tex, p001).rgba;
        vec4 c110 = texture3D(tex, p110).rgba;
        vec4 c101 = texture3D(tex, p101).rgba;
        vec4 c011 = texture3D(tex, p011).rgba;
        vec4 c111 = texture3D(tex, p111).rgba;

        vec4 c00 = mix2(c000, c100, f.x);
        vec4 c01 = mix2(c001, c101, f.x);
        vec4 c10 = mix2(c010, c110, f.x);
        vec4 c11 = mix2(c011, c111, f.x);
        
        vec4 c0 = mix2(c00, c10, f.y);
        vec4 c1 = mix2(c01, c11, f.y);

        return mix2(c0, c1, f.z);
    }

    /* RENDERTARGETS:0,1,2,3,5,10,15,13*/

    void main() {
        vec4 depth = texture2D(depthtex1, TexCoords);
        vec4 depth2 = texture2D(depthtex0, TexCoords);

        vec3 ClipSpace = vec3(TexCoords, depth) * 2.0f - 1.0f;
        vec4 ViewW = gbufferProjectionInverse * vec4(ClipSpace, 1.0f);
        vec3 View = ViewW.xyz / ViewW.w;
        vec4 World = gbufferModelViewInverse * vec4(View, 1.0f);

        vec4 albedo = vec4(0.0);

        vec3 worldNormal = (gbufferModelViewInverse * Normal).xyz;

        vec3 bitangent = normalize2(cross(Tangent.xyz, Normal.xyz));

        mat3 tbnMatrix = mat3(Tangent.xyz, bitangent.xyz, Normal.xyz);

        vec3 newNormal = Normal.xyz;

        //if(isWaterBlock == 1) newNormal = tbnMatrix * finalNoise.xyz;
        
        vec4 Lightmap;

        if(isWaterBlock > 0.1f) {
            //albedo.a = 0.0f;
            //Lightmap = vec4(LightmapCoords.x, LightmapCoords.y, 0.0, 1.0f);

            #if WATER_STYLE == 1
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
                newNormal = tbnMatrix * finalNoise.xyz;

                newNormal = (gbufferModelViewInverse * vec4(newNormal,1.0)).xyz;
            #endif
        } else {
            albedo = texture2D(colortex0, TexCoords) * Color;
            //Lightmap = vec4(LightmapCoords.x, LightmapCoords.y, 0f, 1.0f);
            newNormal = worldNormal;

            //albedo.a = min(albedo.a, 0.75f);
        }
        mediump float distanceFromCamera = distance(viewSpaceFragPosition,vec3(0));

        gl_FragData[1] = vec4(newNormal * 0.5 + 0.5, 1.0);
        gl_FragData[3] = vec4(0.0,0.0,0.0,1.0);
        gl_FragData[4] = vec4(isWaterBlock, 0.0, 0.0, 1.0);
        gl_FragData[5] = vec4(isGlass, 0.0, isStainedGlass, 1.0);
        gl_FragData[6] = vec4(distanceFromCamera, depth.r, waterShadingHeight, 1.0);
        float skylightLevel = 0.0;
        #if LIGHTING_MODE > 0
            float skylightLevel2 = 1 - LightmapCoords.y;
            if(distance(vec3(0.0), foot_pos) > VOXEL_RADIUS - 1) {
                skylightLevel2 *= 1 - caveFactor;
            }
            skylightLevel2 = 1 - skylightLevel;
            skylightLevel = smoothstep(0, 0.25, lightTrilinear(cSampler4, foot_pos + fract(cameraPosition) - block_centered_relative_pos + 0.5, clamp(voxel_pos, ivec3(0.0), ivec3(VOXEL_AREA))).x) * skylightLevel2;
            skylightLevel = max(skylightLevel, skylightLevel2);
        #endif
        gl_FragData[7] = vec4(LightmapCoords.x, skylightLevel, 0.0, 1.0);
        #if WATER_STYLE == 1
            if(isWaterBlock > 0.1f) return;
        #endif
        gl_FragData[0] = albedo;
    }
#endif

#ifdef VERTEX_SHADER
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
    flat out ivec3 voxel_pos;

    in vec4 at_midBlock;
    attribute vec4 mc_midTexCoord;

    uniform vec3 cameraPosition;

    out float waterShadingHeight;

    out float isGlass;

    out float isStainedGlass;

    #include "/lib/globalDefines.glsl"

    #include "/lib/includes2.glsl"
    #include "/lib/optimizationFunctions.glsl"

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

    mediump float random(in vec2 p) {
        return fract(sin(p.x*456.0+p.y*56.0)*100.0);
    }

    vec2 smoothUVs(in vec2 v) {
        return v*v*(3.0-2.0*v);
    }

    mediump float smooth_noise(in vec2 p) {
        vec2 f = smoothUVs(fract(p));
        mediump float a = random(floor(p));
        mediump float b = random(vec2(ceil(p.x),floor(p.y)));
        mediump float c = random(vec2(floor(p.x),ceil(p.y)));
        mediump float d = random(ceil(p));
        return mix2(
            mix2(a,b,f.x),
            mix2(c,d,f.x),
            f.y
        );
    }

    vec3 waterDisplace(vec3 worldPos) {
        float wave1 = smooth_noise(worldPos.xz * 0.75 + frameTimeCounter * 0.8);
        float wave2 = smooth_noise(worldPos.xz * 0.975 + frameTimeCounter * 1.1);

        float waveHeight = (wave1 + wave2) * 0.2 - 0.4;

        return vec3(0.0, waveHeight, 0.0);
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
        block_centered_relative_pos = foot_pos +at_midBlock.xyz/64.0 + fract(cameraPosition);
        voxel_pos = ivec3(block_centered_relative_pos + VOXEL_RADIUS);

        isWaterBlock = 0f;

        float distanceFromCamera = distance(viewSpaceFragPosition,vec3(0));
        
        if(mc_Entity.x == 8.0 && mc_Entity.x != 10002) {
            isWaterBlock = 1f;
            isWater = 1f;
            #ifdef WATER_WAVES
                vec3 waterHeight = waterDisplace(world_pos);
                vec4 wavePos = vec4(view_pos + (gbufferModelView * vec4(waterHeight,0.0)).xyz,1.0);
                gl_Position = gbufferProjection * wavePos;
                waterShadingHeight = distance(view_pos, wavePos.xyz);
            #endif
        } else {
            isWater = 1f;
            isWaterBlock = 0f;
        }

        isStainedGlass = mc_Entity.x == 10002 ? 1.0 : 0.0;

        isGlass = mc_Entity.x == 10014? 0.0 : 1.0;

        if(mc_Entity.x == 8.0 || mc_Entity.x == 10002) {
            isTransparent = 1.0;
        } else {
            isTransparent = 0.0;
        }

        Color = gl_Color;
        LightmapCoords = (LightmapCoords * 33.05f / 32.0f) - (1.05f / 32.0f);
    }
#endif