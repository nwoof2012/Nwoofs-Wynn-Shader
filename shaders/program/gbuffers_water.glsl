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

    in vec4 at_midBlock;
    attribute vec4 mc_midTexCoord;

    uniform vec3 cameraPosition;

    out float waterShadingHeight;

    out float isGlass;

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

    vec3 waterDisplace(vec3 worldPos) {
        float wave1 = sin(worldPos.x + frameTimeCounter * 0.8);
        float wave2 = sin(worldPos.z * 1.3 + frameTimeCounter * 1.1);

        float waveHeight = (wave1 + wave2) * 0.1 - 0.2;

        return worldPos + vec3(0.0, waveHeight, 0.0) - cameraPosition;
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
            isWater = 1f;
            #ifdef WATER_WAVES
                vec3 waterHeight = waterDisplace(world_pos);
                vec4 waterDisplacementAmount = gbufferProjection * gbufferModelView * vec4(waterHeight,1.0);
                waterShadingHeight = distance(foot_pos, waterHeight);
                gl_Position = waterDisplacementAmount;
            #endif
        } else {
            isWater = 1f;
            isWaterBlock = 0f;
        }

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