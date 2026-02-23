#ifdef FRAGMENT_SHADER
    #include "/lib/globalDefines.glsl"

    #define WATER_REFRACTION
    #define WATER_FOAM

    #include "/lib/includes2.glsl"
    #include "/lib/optimizationFunctions.glsl"

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

    /* RENDERTARGETS:0,1,2,3,5,13,15,14 */

    mat3 tbnNormalTangent(vec3 normal, vec3 tangent) {
        vec3 bitangent = cross(tangent, normal);
        return mat3(tangent, bitangent, normal);
    }

    float remapDHDepth(float depth, float nearPlane, float farPlaneChunks, float farPlaneDH) {
        float z_dh = linearizeDepth(depth, dhNearPlane, farPlaneDH);

        z_dh = clamp(z_dh, farPlaneChunks, farPlaneDH);

        float d_far_chunks = (farPlaneChunks - nearPlane) / (farPlaneDH - nearPlane);
        float t = (z_dh - farPlaneChunks) / (farPlaneDH - farPlaneChunks);
        return mix(d_far_chunks, 1.0, t);
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

    mediump float calcDepth(float depth, float near, float far) {
        return (near * far) / (depth * (near - far) + far);
    }

    void main() {
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

            if(clamp(1.0-length(viewSpaceFragPosition)/clamp(far - 32.0,32.0,far),0.0,1.0) > 0.1) {
                discard;
            }

            vec3 shadowLightDirection = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);

            vec3 worldNormal = (gbufferModelViewInverse * Normal).xyz;

            mediump float lightBrightness = clamp(dot(shadowLightDirection, worldNormal),max(0.2, MIN_LIGHT),MAX_LIGHT);

            vec4 albedo = texture2D(texture, TexCoords) * Color;
            vec3 Albedo = pow2(albedo.xyz, vec3(GAMMA));

            albedo.a = 0.5f;

            mediump float depth = texture2D(depthtex0, texCoord).r;
            mediump float dhDepth = gl_FragCoord.z;
            float dhDepthLinear = calcDepth(dhDepth, dhNearPlane, dhFarPlane);
            
            if(mat == DH_BLOCK_WATER) {
                Albedo = vec3(0.0f, 0.33f, 0.44f);
                albedo.a = 0.0f;
            }

            vec2 TexCoords2 = texCoord;

            mediump float isBlockWater = float(Color.z > Color.y && Color.y > Color.x);

            float distanceFromCamera = distance(vec3(0), viewSpaceFragPosition);

            if(mat == DH_BLOCK_WATER) {
                albedo.a = 0.0;
            }

            gl_FragData[0] = vec4(pow2(Albedo,vec3(1/GAMMA)), albedo.a);

            gl_FragData[5] = vec4(pow2(LightmapCoords,vec2(2.2)), remapDHDepth(dhDepth, near, far, dhFarPlane), 1.0);

            gl_FragData[3] = vec4(1.0);
            gl_FragData[6] = vec4(distanceFromCamera, dhDepth, waterShadingHeight, 1.0);

            gl_FragData[7] = vec4(dhDepth, 0.0, 0.0, 1.0);

            imageStore(cimage12,  ivec2(gl_FragCoord.xy/vec2(viewWidth, viewHeight) * imageSize(cimage12)), vec4(dhDepth));

            if(mat == DH_BLOCK_WATER) {
                gl_FragData[4] = vec4(1.0, 0.0, 0.0, 1.0);
            } else {
                gl_FragData[4] = vec4(0.0, 0.0, 0.0, 1.0);
            }

            vec3 n = normalize2(worldNormal);

            vec3 an = abs(n);
            vec2 uvX = foot_pos.zy;
            vec2 uvY = foot_pos.xz;
            vec2 uvZ = foot_pos.xy;

            vec2 waterUV =
                uvX * step(max(an.y, an.z), an.x) +
                uvY * step(max(an.x, an.z), an.y) +
                uvZ * step(max(an.x, an.y), an.z);

            vec4 noiseMapA = texture2D(water, (waterUV + ((frameCounter)/90f)*0.5f) * 0.035f);
            vec4 noiseMapB = texture2D(water, (waterUV - ((frameCounter)/90f)*0.5f) * 0.035f);

            vec4 finalNoise = noiseMapA * noiseMapB * 2 - 1;

            vec3 bitangent = normalize2(cross(vec3(1, 0, 0), Normal.xyz));

            mat3 tbnMatrix = mat3(vec3(1, 0, 0), bitangent.xyz, Normal.xyz);

            vec3 newNormal = Normal.xyz;

            newNormal = (gbufferModelViewInverse * vec4(newNormal,1.0)).xyz;

            albedo.a = 0.75f;
            
            vec4 Lightmap;

            if(mat == DH_BLOCK_WATER) {
                albedo.xyz = mix2(vec3(0.0f,0.33f,0.55f),vec3(1.0f,1.0f,1.0f),pow2(finalNoise.x,5));
                albedo.a = 0.0f;
                if(albedo.a < 0.75f) {
                    albedo.a = 0.0;
                }

                newNormal = tbnMatrix * finalNoise.xyz;

                newNormal = (gbufferModelViewInverse * vec4(newNormal,1.0)).xyz;
            }
            gl_FragData[1] = vec4(newNormal * 0.5 + 0.5, 1.0);
        } else {
            discard;
        }
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
    #define WATER_CHUNK_RESOLUTION 128 // [32 64 128]

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

    out vec3 viewSpaceFragPosition;

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

    out vec3 world_pos;

    in vec3 at_midBlock;

    in vec3 cameraPosition;

    out float waterShadingHeight;

    uniform float frameTimeCounter;

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

        vec3 view_pos = vec4(gl_ModelViewMatrix * gl_Vertex).xyz;
        foot_pos = (gbufferModelViewInverse * vec4(view_pos, 1.0)).xyz;
        world_pos = foot_pos + cameraPosition;

        viewSpaceFragPosition = (gl_ModelViewMatrix * gl_Vertex).xyz;

        #ifdef WORLD_CURVATURE
            float d = length(playerPos);
            float R = 63710.0;

            float drop = (d * d) / (2.0 * R);

            gl_Position.y -= drop;
        #endif
        
        if(mat == DH_BLOCK_WATER) {
            #ifdef WATER_WAVES
                vec2 waveCycle = vec2(sin((world_pos.x * WAVE_DENSITY_X * 7) + (frameTimeCounter * WAVE_SPEED_X)), -sin((world_pos.z * WAVE_DENSITY_Y * 7) + (frameTimeCounter * WAVE_SPEED_Y)));
                vec2 waveCycle2 = vec2(sin((world_pos.x * WAVE_DENSITY_X * 0.5) + (frameTimeCounter * WAVE_SPEED_X)), -sin((world_pos.z * WAVE_DENSITY_Y * 0.5) + (frameTimeCounter * WAVE_SPEED_Y)));
                float waveHeight = WAVE_AMPLITUDE * ((waveCycle.x + waveCycle.y)/2 + (waveCycle2.x + waveCycle2.y))/3;

                //gl_Position += gbufferProjection * gbufferModelView * vec4(0, waveHeight*0.25f - 0.3f, 0, 0);
                waterShadingHeight = ((waveCycle.x + waveCycle.y)/2 + (waveCycle2.x + waveCycle2.y))/3 + 1;
            #endif
        }
        
        Color = gl_Color;
        LightmapCoords = (LightmapCoords * 33.05f / 32.0f) - (1.05f / 32.0f);
    }
#endif