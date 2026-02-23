/*<==========================================================>*/
/*|                                                          |*/
/*|                        [FRAGMENT]                        |*/
/*|                                                          |*/
/*<==========================================================>*/

#ifdef FRAGMENT_SHADER
    #define PATH_TRACING_GI 0 // [0 1]

    #define TERRAIN

    #define WAVING_FOLIAGE
    #define FOLIAGE_SPEED 1.0f // [0.1f 0.2f 0.3f 0.4f 0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f 1.6f 1.7f 1.8f 1.9f 2.0f]
    #define FOLIAGE_INTENSITY 1.0f // [0.1f 0.2f 0.3f 0.4f 0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f 1.6f 1.7f 1.8f 1.9f 2.0f]
    #define FOLIAGE_WAVE_DISTANCE 4 // [2 4 8 16 32]

    #define DAY_R 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
    #define DAY_G 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
    #define DAY_B 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
    #define DAY_I 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]

    #define NIGHT_R 0.9f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
    #define NIGHT_G 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
    #define NIGHT_B 1.1f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
    #define NIGHT_I 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]

    #define SUNSET_R 1.1f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
    #define SUNSET_G 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
    #define SUNSET_B 0.8f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
    #define SUNSET_I 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]

    #define SE_R 0.7f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
    #define SE_G 0.4f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
    #define SE_B 0.8f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
    #define SE_I 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]

    //vec3 dayColor = vec3(1.0f,1.0f,1.0f);
    vec3 dayColor = vec3(DAY_R,DAY_G,DAY_B);
    //vec3 nightColor = vec3(0.9f,1.0f,1.1f);
    vec3 nightColor = vec3(NIGHT_R,NIGHT_G,NIGHT_B);
    //vec3 transitionColor = vec3(1.1f, 1.0f, 0.8f);
    vec3 transitionColor = vec3(SUNSET_R,SUNSET_G,SUNSET_B);

    vec3 seColor = vec3(SE_R,SE_G,SE_B);

    vec3 currentColor;

    vec3 Diffuse;

    vec3 baseColor;
    vec3 baseDiffuse;

    vec3 baseDiffuseModifier;

    vec3 baseFog;

    vec3 fogAlbedo;

    uniform int worldTime;

    varying vec2 TexCoords;
    varying vec3 Normal;
    varying vec3 Tangent;
    varying vec4 Color;
    varying vec2 LightmapCoords;

    uniform sampler2D gtexture;
    uniform sampler2D lightmap;
    uniform sampler2D depthtex0;
    uniform sampler2D depthtex1;

    uniform usampler3D cSampler1;
    uniform usampler3D cSampler2;

    uniform ivec2 atlasSize;
    uniform vec3 sunPosition;

    in vec4 lightSourceData;

    in float isReflective;

    uniform vec3 cameraPosition;

    in vec3 worldSpaceVertexPosition;
    in vec3 normals_face_world;
    in vec3 block_centered_relative_pos;
    in vec3 foot_pos;
    in vec3 worldPos;
    in vec3 view_pos;
    in vec4 at_midBlock2;
    in vec2 signMidCoordPos;
    flat in vec2 absMidCoordPos;
    flat in vec2 midCoord;

    in float isFoliage;
    in float isGrass;

    uniform bool isBiomeEnd;

    uniform float frameTimeCounter;

    uniform vec3 shadowLightPosition;

    uniform int viewWidth;
    uniform int viewHeight;

    uniform int renderDistance;

    uniform float far;
    uniform float near;

    #ifdef DISTANT_HORIZONS
        uniform float dhFarPlane;
        uniform float dhRenderDistance;
    #else
        float dhFarPlane = far;
        float dhRenderDistance = renderDistance;
    #endif

    in float isLeaves;

    flat in uint lightData;

    #include "/lib/globalDefines.glsl"
    #include "/lib/includes2.glsl"
    #include "/lib/optimizationFunctions.glsl"
    #include "/lib/post/gaussianBlur.glsl"

    const vec3 TorchColor = vec3(1.0f, 0.25f, 0.08f);
    const float TorchBrightness = 1.0;
    const vec3 GlowstoneColor = vec3(1.0f, 0.93f, 0.5f);
    const float GlowstoneBrightness = 1.5;
    const vec3 LampColor = vec3(1.0f, 0.75f, 0.4f);
    const float LampBrightness = 1.0;
    const vec3 LanternColor = vec3(0.8f, 1.0f, 1.0f);
    const float LanternBrightness = 1.0;
    const vec3 RedstoneColor = vec3(1.0f, 0.0f, 0.0f);
    const float RedstoneBrightness = 1.0;
    const vec3 RodColor = vec3(1.0f, 1.0f, 1.0f);
    const float RodBrightness = 1.0;
    const vec3 PortalColor = vec3(0.75f, 0.0f, 1.0f);
    const float PortalBrightness = 1.0;
    const vec3 FireColor = vec3(1.0f, 0.5f, 0.08f);
    const float FireBrightness = 1.0;

    //#include "program/generateNormals.glsl"

    #if LIGHTING_MODE == 2
        #include "/lib/lighting/pathTracing.glsl"
    #endif

    mediump float AdjustLightmapTorch(in float torch) {
        const mediump float K = 2.0f;
        const mediump float P = 5.06f;
        return K * pow2(torch, P);
    }

    mediump float AdjustLightmapSky(in float sky){
        mediump float sky_2 = sky * sky;
        return sky_2 * sky_2;
    }

    vec2 AdjustLightmap(in vec2 Lightmap){
        vec2 NewLightMap;
        NewLightMap.x = AdjustLightmapTorch(Lightmap.x);
        NewLightMap.y = AdjustLightmapSky(Lightmap.y);
        return NewLightMap;
    }

    vec4 vanillaLight(in vec2 Lightmap) {
        const vec3 TorchColor = vec3(1.0f, 1.0f, 1.0f);
        vec4 lightColor = vec4(TorchColor * Lightmap.x,1.0);
        return lightColor;
    }

    vec4 maxVec(vec4 a, vec4 b) {
        mediump float magA = length(a.xyz);
        mediump float magB = length(b.xyz);
        if(magA < magB) {
            return b;
        }
        return a;
    }

    /*vec3 smoothUVs3D(in vec3 v) {
        return v*v*(3.0-2.0*v);
    }*/

    vec4 decodeLightmap(uint lightmap) {
        vec4 lighting = vec4(vec3(0.0),1.0);
        if(lightmap == 1)
        {
            lighting.xyz = TorchColor;
            lighting.w = TorchBrightness;
        }
        else if(lightmap == 2)
        {
            lighting.xyz = GlowstoneColor;
            lighting.w = GlowstoneBrightness;
        } else if(lightmap == 3)
        {
            lighting.xyz = LampColor;
            lighting.w = LampBrightness;
        } else if(lightmap == 4)
        {
            lighting.xyz = LanternColor;
            lighting.w = LanternBrightness;
        } else if(lightmap == 5)
        {
            lighting.xyz = RedstoneColor;
            lighting.w = RedstoneBrightness;
        } else if(lightmap == 6)
        {
            lighting.xyz = RodColor;
            lighting.w = RodBrightness;
        } else if(lightmap == 7)
        {
            lighting.xyz = PortalColor;
            lighting.w = PortalBrightness;
        } else if(lightmap == 8)
        {
            lighting.xyz = FireColor;
            lighting.w = FireBrightness;
        } else {
            lighting.w = 0;
        }
        return lighting;
    }

    /*vec4 smooth_light(vec3 p) {
        vec3 f = smoothUVs3D(p);
        vec4 bytes = unpackUnorm4x8(texture3D(cSampler1,floor(p)).r);
        vec4 a = decodeLightmap(bytes);
        bytes = unpackUnorm4x8(texture3D(cSampler1,vec3(ceil(p.x), floor(p.y), floor(p.z))).r);
        vec4 b = decodeLightmap(bytes);
        bytes = unpackUnorm4x8(texture3D(cSampler1,vec3(floor(p.x), ceil(p.y), floor(p.z))).r);
        vec4 c = decodeLightmap(bytes);
        bytes = unpackUnorm4x8(texture3D(cSampler1,vec3(ceil(p.xy), floor(p.z))).r);
        vec4 d = decodeLightmap(bytes);

        vec4 bottom = mix2(mix2(a,b,f.x),mix2(c,d,f.x),f.y);

        bytes = unpackUnorm4x8(texture3D(cSampler1,vec3(floor(p.x),floor(p.y),ceil(p.z))).r);
        vec4 a2 = decodeLightmap(bytes);
        bytes = unpackUnorm4x8(texture3D(cSampler1,vec3(ceil(p.x), floor(p.y), ceil(p.z))).r);
        vec4 b2 = decodeLightmap(bytes);
        bytes = unpackUnorm4x8(texture3D(cSampler1,vec3(floor(p.x), ceil(p.y), ceil(p.z))).r);
        vec4 c2 = decodeLightmap(bytes);
        bytes = unpackUnorm4x8(texture3D(cSampler1,ceil(p)).r);
        vec4 d2 = decodeLightmap(bytes);

        vec4 top = mix2(mix2(a2,b2,f.x),mix2(c2,d2,f.x),f.y);

        return mix2(bottom, top, f.z);
    }*/

    bool pointsIntersect(vec3 origin, vec3 dir, vec3 solidTex) {
        vec3 oc = origin - solidTex;
        mediump float b = dot(oc, dir);
        mediump float c = dot(oc, oc);
        mediump float h = b * b - c;
        if(h > 0.0) {
            return true;
        }
        return false;
    }

    float baseFogDistMin;
    float baseFogDistMax;
    float fogMin;
    float fogMax;

    void noonFunc(float time, float timeFactor) {
        if(isBiomeEnd) {
            fogMin = FOG_SE_DIST_MIN;
            fogMax = FOG_SE_DIST_MAX;
        } else {
            mediump float dayNightLerp = clamp((time+250f)/timeFactor,0,1);
            fogMin = mix2(baseFogDistMin, FOG_DAY_DIST_MIN, dayNightLerp);
            fogMax = mix2(baseFogDistMax, FOG_DAY_DIST_MAX, dayNightLerp);
            baseDiffuseModifier = vec3(DAY_I);
            currentColor = mix2(baseColor,dayColor,dayNightLerp);
            Diffuse = mix2(baseDiffuse, pow2(Diffuse.rgb,vec3(GAMMA)) * baseDiffuseModifier, mod(worldTime/6000f,2f));
            fogAlbedo = mix2(baseFog, vec3(FOG_DAY_R, FOG_DAY_G, FOG_DAY_B), dayNightLerp);
        }
    }

    void sunsetFunc(float time, float timeFactor) {
        if(isBiomeEnd) {
            fogMin = FOG_SE_DIST_MIN;
            fogMax = FOG_SE_DIST_MAX;
        } else {
            mediump float sunsetLerp = clamp((time+250f)/timeFactor,0,1);
            fogMin = mix2(baseFogDistMin, FOG_SUNSET_DIST_MIN, sunsetLerp);
            fogMax = mix2(baseFogDistMax, FOG_SUNSET_DIST_MAX, sunsetLerp);
            baseDiffuseModifier = vec3(SUNSET_I);
            currentColor = mix2(dayColor, transitionColor, sunsetLerp);
            Diffuse = mix2(baseDiffuse, pow2(Diffuse.rgb,vec3(GAMMA)) * baseDiffuseModifier, mod(worldTime/6000f,2f));
            fogAlbedo = mix2(baseFog, vec3(FOG_SUNSET_R, FOG_SUNSET_G, FOG_SUNSET_B), sunsetLerp);
        }
    }

    void nightFunc(float time, float timeFactor) {
        if(isBiomeEnd) {
            fogMin = FOG_SE_DIST_MIN;
            fogMax = FOG_SE_DIST_MAX;
        } else {
            mediump float dayNightLerp = clamp((time+250f)/timeFactor,0,1);
            fogMin = mix2(baseFogDistMin, FOG_NIGHT_DIST_MIN, dayNightLerp);
            fogMax = mix2(baseFogDistMax, FOG_NIGHT_DIST_MAX, dayNightLerp);
            baseDiffuseModifier = vec3(NIGHT_I * 0.4f);
            currentColor = mix2(baseColor, nightColor, dayNightLerp);
            Diffuse = mix2(baseDiffuse, pow2(Diffuse.rgb,vec3(GAMMA)) * baseDiffuseModifier,mod(worldTime/6000f,2f));
            fogAlbedo = mix2(baseFog, vec3(FOG_NIGHT_R, FOG_NIGHT_G, FOG_NIGHT_B), dayNightLerp);
        }
    }

    void dawnFunc(float time, float timeFactor) {
        if(isBiomeEnd) {
            fogMin = FOG_SE_DIST_MIN;
            fogMax = FOG_SE_DIST_MAX;
        } else {
            mediump float sunsetLerp = clamp((time+250f)/timeFactor,0,1);
            baseDiffuseModifier = vec3(SUNSET_I);
            currentColor = mix2(dayColor, transitionColor, sunsetLerp);
            Diffuse = mix2(baseDiffuse, pow2(Diffuse.rgb,vec3(GAMMA)) * baseDiffuseModifier, mod(worldTime/6000f,2f));
            fogAlbedo = mix2(baseFog, vec3(FOG_SUNSET_R, FOG_SUNSET_G, FOG_SUNSET_B), sunsetLerp);
        }
    }

    #include "/lib/world/timeCycle.glsl"

    /* RENDERTARGETS:0,1,2,13,5,10,6,12*/

    void main() {
        vec3 lightColor = texture(lightmap, LightmapCoords).rgb;
        vec4 albedo = texture2D(gtexture, TexCoords) * Color;
        albedo.xyz = pow2(albedo.xyz, vec3(GAMMA));

        mediump float depth = texture2D(depthtex0, TexCoords).r;
        mediump float depth2 = texture2D(depthtex1, TexCoords).r;
        
        if(albedo.a >= .1 && depth >= 0.1) {
            vec3 newNormal = Normal;
            newNormal = (gbufferModelViewInverse * vec4(newNormal, 1.0)).xyz;

            albedo.xyz = pow2(albedo.xyz, vec3(1/GAMMA));
            mediump float distanceFromCamera = distance(vec3(0), viewSpaceFragPosition);

            gl_FragData[0] = albedo;
            gl_FragData[1] = vec4(newNormal * 0.5 + 0.5f, 1.0f);
            #if LIGHTING_MODE == 0
                gl_FragData[2] = vec4(LightmapCoords, 0.0f, 1.0f);

                Diffuse = albedo.xyz;

                baseColor = currentColor;
                baseDiffuse = Diffuse;

                baseDiffuseModifier = vec3(0.0);

                baseFog = vec3(0.0);

                fogMin = FOG_DAY_DIST_MIN;
                fogMax = FOG_DAY_DIST_MAX;

                baseFogDistMin = fogMin;
                baseFogDistMax = fogMax;

                if(worldTime/(timePhase + 1) < 500f) {
                    baseFogDistMin = fogMin;
                    baseFogDistMax = fogMax;
                }
                
                timeFunctionFrag();

                mediump float fogStart = fogMin;
                mediump float fogEnd = fogMax;

                mediump float fogAmount = (length(view_pos) - fogStart)/(fogEnd - fogStart);

                mediump float fogBlend = pow2(smoothstep(0.9,1.0,fogAmount),4.2);

                gl_FragData[6] = vec4(0.0, distanceFromCamera, linearizeDepth(depth, near, far), 1.0);
            #elif LIGHTING_MODE > 0
                ivec3 voxel_pos = ivec3(block_centered_relative_pos+VOXEL_RADIUS);
                vec3 light_color = vec3(0.0);
                if(clamp(voxel_pos,0,VOXEL_AREA) == voxel_pos) {
                    vec4 bytes = unpackUnorm4x8(texture3D(cSampler1,vec3(voxel_pos)/vec3(VOXEL_AREA)).r);
                    light_color = bytes.xyz;
                }
                
                vec4 lighting = vec4(0.0);
                float lightBrightness = 0.0;

                vec3 SkyColor = vec3(0.05f, 0.15f, 0.3f);
                SkyColor = currentColor;

                vec3 currentColor = dayColor;

                Diffuse = albedo.xyz;

                baseColor = currentColor;
                baseDiffuse = Diffuse;

                baseDiffuseModifier = vec3(0.0);

                baseFog = vec3(0.0);

                fogMin = FOG_DAY_DIST_MIN;
                fogMax = FOG_DAY_DIST_MAX;

                baseFogDistMin = fogMin;
                baseFogDistMax = fogMax;

                if(worldTime/(timePhase + 1) < 500f) {
                    baseFogDistMin = fogMin;
                    baseFogDistMax = fogMax;
                }

                timeFunctionFrag();

                mediump float fogStart = fogMin;
                mediump float fogEnd = fogMax;

                mediump float fogAmount = (length(view_pos)*(far/dhRenderDistance) - fogStart)/(fogEnd - fogStart);

                #ifdef DISTANT_HORIZONS
                    gl_FragData[6] = vec4(depth, encodeDist(distanceFromCamera, dhFarPlane), length(foot_pos)/(dhRenderDistance*16), 1.0);
                #else
                    gl_FragData[6] = vec4(depth, encodeDist(distanceFromCamera, far), length(foot_pos)/(renderDistance*16), 1.0);
                #endif

                vec3 lightNormal = vec3(0.0);
                float NdotL = 1.0;

                vec3 rawLight;

                if(lighting.w <= 0.0 && distance(vec3(0.0), foot_pos) <= VOXEL_RADIUS) {
                    lowp vec3 block_centered_relative_pos3 = foot_pos +at_midBlock2.xyz/64.0 + vec3(-LIGHT_RADIUS - 1) + fract(cameraPosition);

                    ivec3 voxel_pos3 = ivec3(block_centered_relative_pos3 + VOXEL_RADIUS);

                    int side = 2 * LIGHT_RADIUS;
                    int totalLightRadius = int(pow2(side, 3));

                    lowp vec3 sphereCoords = vec3(gl_FragCoord.xy, gl_FragCoord.z) - vec3(LIGHT_RADIUS);
                    
                    lowp float voxel_open = 1.0;

                    float weight;

                    #if SCENE_AWARE_LIGHTING > 0
                        for (int idx = 0; idx < totalLightRadius; idx++) {
                            if(isLeaves > 0.5) continue;

                            int x = int(idx / (side * side) - LIGHT_RADIUS);
                            int y = int(mod(idx/side, side) - LIGHT_RADIUS);
                            int z = int(mod(idx, side) - LIGHT_RADIUS);

                            if(x * x + y * y + z * z > LIGHT_RADIUS * LIGHT_RADIUS) continue;

                            lowp vec3 block_centered_relative_pos2 = foot_pos + at_midBlock2.xyz / 64.0 + vec3(x, z, y) + fract(cameraPosition);
                            
                            if (distance(vec3(0.0), block_centered_relative_pos2) > VOXEL_RADIUS) continue;

                            ivec3 voxel_pos2 = ivec3(block_centered_relative_pos2 + VOXEL_RADIUS);

                            uint bytes = texture3D(cSampler1, vec3(voxel_pos2) / vec3(VOXEL_AREA)).r;

                            if(bytes == 0u) continue;

                            if (bytes != 0) {
                                lowp vec3 world_pos2 = foot_pos + vec3(x, z, y) + cameraPosition;
                                lowp vec3 world_pos3 = foot_pos + cameraPosition;

                                lowp vec3 foot_pos3 = vec3(0.0);
                                lowp vec3 block_centered_relative_pos4 = block_centered_relative_pos2 - foot_pos;

                                block_centered_relative_pos4 = mat3(gbufferModelView) * block_centered_relative_pos4;

                                lightNormal = normalize2(voxel_pos2 - block_centered_relative_pos2);
                                NdotL = dot(lightNormal, newNormal);

                                float dist = float((foot_pos + fract(cameraPosition) - block_centered_relative_pos2) * (foot_pos + fract(cameraPosition) - block_centered_relative_pos2));
                                float sampleWeight = distance(foot_pos + fract(cameraPosition), block_centered_relative_pos2);
                                lighting += decodeLightmap(bytes) / (1 + LIGHT_RADIUS * LIGHT_RADIUS * LIGHT_RADIUS * smoothstep(0, LIGHT_RADIUS * LIGHT_RADIUS, sampleWeight*sampleWeight)) * vanillaLight(AdjustLightmap(LightmapCoords));
                                
                                weight += sampleWeight * LIGHT_RADIUS * LIGHT_RADIUS;

                                lightBrightness = decodeLightmap(bytes).w * clamp(1.0 - blockDist(foot_pos3, block_centered_relative_pos4) / float(LIGHT_RADIUS), 0.0, 1.0) * NdotL;
                            }
                        }
                        lighting /= max(weight,1.0);
                        lighting *= 25;
                        lighting = min(lighting, normalize2(lighting) * MAX_LIGHT);
                    #endif
                }
                #if LIGHTING_MODE > 0 && SCENE_AWARE_LIGHTING == 0
                    lighting = vanillaLight(AdjustLightmap(LightmapCoords));
                #endif
                vec4 finalLighting = lighting;
                float isCave = LightmapCoords.g;
                gl_FragData[7] = vec4(isCave, 0.0, isLeaves, 1.0);
                #if LIGHTING_MODE == 1
                    finalLighting.xyz /= 3;
                #endif
                vec4 finalLighting2 = vanillaLight(AdjustLightmap(LightmapCoords));
                if(isBiomeEnd) finalLighting2 = max(finalLighting2, vec4(SE_MIN_LIGHT * 0.1)); else finalLighting2 = max(finalLighting2, vec4(MIN_LIGHT * 0.1));
                finalLighting = mix2(finalLighting * 4.0, finalLighting2 * 0.75, max(float(any(notEqual(clamp(voxel_pos,0,VOXEL_AREA), voxel_pos))), float(1 - smoothstep(0,0.5,finalLighting * 2.0))))/2.25;
                uint integerValue = packUnorm4x8(vec4(lighting.xyz, lightBrightness));
                gl_FragData[2] = encodeLight(finalLighting,MAX_LIGHT);
            #endif
            gl_FragData[3] = vec4(LightmapCoords, isGrass, 1.0);
            gl_FragData[4] = vec4(0.0, 1.0, isReflective, 1.0);
            gl_FragData[5] = vec4(1.0, 0.0, 0.0, 1.0);
        }
    }

#endif

/*<==========================================================>*/
/*|                                                          |*/
/*|                         [VERTEX]                         |*/
/*|                                                          |*/
/*<==========================================================>*/

#ifdef VERTEX_SHADER
    #include "/lib/globalDefines.glsl"
    #include "/lib/includes2.glsl"

    #define PATH_TRACING_GI 0 // [0 1]

    #define WAVING_FOLIAGE
    #define FOLIAGE_SPEED 1.0f // [0.1f 0.2f 0.3f 0.4f 0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f 1.6f 1.7f 1.8f 1.9f 2.0f]
    #define FOLIAGE_INTENSITY 1.0f // [0.1f 0.2f 0.3f 0.4f 0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f 1.6f 1.7f 1.8f 1.9f 2.0f]
    #define FOLIAGE_WAVE_DISTANCE 4 // [2 4 8 16 32]

    struct LightSource {
        int id;
        mediump float brightness;
    };

    layout (r32ui) uniform uimage3D cimage1;

    in vec3 vaPosition;
    in vec2 vaUV0;
    in vec4 vaColor;
    in ivec2 vaUV2;

    varying vec2 TexCoords;
    varying vec3 Normal;
    varying vec3 Tangent;
    varying vec4 Color;

    varying vec2 LightmapCoords;

    uniform float frameTimeCounter;

    uniform vec3 cameraPosition;
    uniform vec3 chunkOffset;
    uniform mat4 modelViewMatrix;

    out vec4 lightSourceData;

    out vec3 block_centered_relative_pos;

    in vec4 mc_Entity;
    attribute vec4 mc_midTexCoord;

    uniform bool isBiomeEnd;

    in vec4 at_midBlock;

    in vec4 at_tangent;

    out vec4 at_midBlock2;

    out float isFoliage;
    out float isGrass;

    out float isReflective;

    out vec3 worldSpaceVertexPosition;

    out vec3 normals_face_world;

    out vec3 foot_pos;

    out vec3 view_pos;

    out vec3 worldPos;

    out vec2 signMidCoordPos;
    flat out vec2 absMidCoordPos;
    flat out vec2 midCoord;

    out float isLeaves;

    flat out uint lightData;

    const vec3 TorchColor = vec3(1.0f, 0.25f, 0.08f);
    const vec3 GlowstoneColor = vec3(1.0f, 0.85f, 0.5f);
    const vec3 LampColor = vec3(1.0f, 0.75f, 0.4f);
    const vec3 LanternColor = vec3(0.8f, 1.0f, 1.0f);
    const vec3 RedstoneColor = vec3(1.0f, 0.0f, 0.0f);
    const vec3 RodColor = vec3(1.0f, 1.0f, 1.0f);
    const vec3 PortalColor = vec3(0.75f, 0.0f, 1.0f);
    const vec3 FireColor = vec3(1.0f, 0.25f, 0.08f);

    vec3 GetRawWave(in vec3 pos, float wind) {
        mediump float magnitude = sin(wind * 0.0027 + pos.z + pos.y) * 0.04 + 0.04;
        mediump float d0 = sin(wind * 0.0127);
        mediump float d1 = sin(wind * 0.0089);
        mediump float d2 = sin(wind * 0.0114);
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

    #if FOG_STYLE == 2
        float minFog = 0.0;
        float maxFog = 0.0;
        void noonFunc(float time, float timeFactor) {
            if(isBiomeEnd) {
                minFog = FOG_SE_DIST_MIN;
                maxFog = FOG_SE_DIST_MAX;
            } else {
                mediump float dayNightLerp = clamp((time+250f)/timeFactor,0,1);
                minFog = mix(FOG_SUNSET_DIST_MIN, FOG_DAY_DIST_MIN, dayNightLerp);
                maxFog = mix(FOG_SUNSET_DIST_MAX, FOG_DAY_DIST_MAX, dayNightLerp);
            }
        }

        void sunsetFunc(float time, float timeFactor) {
            if(isBiomeEnd) {
                minFog = FOG_SE_DIST_MIN;
                maxFog = FOG_SE_DIST_MAX;
            } else {
                mediump float sunsetLerp = clamp((time+250f)/timeFactor,0,1);
                minFog = mix(FOG_DAY_DIST_MIN, FOG_SUNSET_DIST_MIN, sunsetLerp);
                maxFog = mix(FOG_DAY_DIST_MAX, FOG_SUNSET_DIST_MAX, sunsetLerp);
            }
        }

        void nightFunc(float time, float timeFactor) {
            if(isBiomeEnd) {
                minFog = FOG_SE_DIST_MIN;
                maxFog = FOG_SE_DIST_MAX;
            } else {
                mediump float dayNightLerp = clamp((time+250f)/timeFactor,0,1);
                minFog = mix(FOG_SUNSET_DIST_MIN, FOG_NIGHT_DIST_MIN, dayNightLerp);
                maxFog = mix(FOG_SUNSET_DIST_MAX, FOG_NIGHT_DIST_MAX, dayNightLerp);
            }
        }

        void dawnFunc(float time, float timeFactor) {
            if(isBiomeEnd) {
                minFog = FOG_SE_DIST_MIN;
                maxFog = FOG_SE_DIST_MAX;
            } else {
                mediump float sunsetLerp = clamp((time+250f)/timeFactor,0,1);
                minFog = mix(FOG_NIGHT_DIST_MIN, FOG_SUNSET_DIST_MIN, sunsetLerp);
                maxFog = mix(FOG_NIGHT_DIST_MAX, FOG_SUNSET_DIST_MAX, sunsetLerp);
            }
        }
    #endif

    #include "/lib/world/timeCycle.glsl"

    void main() {
        gl_Position = ftransform();

        TexCoords = gl_MultiTexCoord0.st;

        viewSpaceFragPosition = (gl_ModelViewMatrix * gl_Vertex).xyz;

        worldSpaceVertexPosition = cameraPosition + (gbufferModelViewInverse * modelViewMatrix * vec4(vaPosition + chunkOffset,1.0)).xyz;

        foot_pos = (gbufferModelViewInverse * vec4(viewSpaceFragPosition,1.0)).xyz;

        worldPos = foot_pos + cameraPosition;

        vec3 chunkVertexPosition = cameraPosition + (gbufferModelViewInverse * modelViewMatrix * vec4(vaPosition,1.0)).xyz;

        mediump float distanceFromCamera = distance(worldSpaceVertexPosition, cameraPosition);

        LightmapCoords = mat2(gl_TextureMatrix[1]) * gl_MultiTexCoord1.st;

        LightmapCoords = (LightmapCoords * 33.05f / 32.0f) - (1.05f / 32.0f);
        Normal = normalize(gl_NormalMatrix * gl_Normal);
        Tangent = (gl_NormalMatrix * at_tangent.xyz);
        Color = gl_Color;

        mediump float bottomY = at_midBlock.y - 0.5;

        at_midBlock2 = at_midBlock;

        if(mc_Entity.x == 10001) {
            isFoliage = 1.0;
        } else {
            isFoliage = 0.0;
        }

        if(mc_Entity.x == 10001) {
            isGrass = 1.0;
        } else {
            isGrass = 0.0;
        }

        if(mc_Entity.x == 10011) {
            isReflective = 1.0;
        } else {
            isReflective = 0.0;
        }

        timeFunctionVert();

        #ifdef WORLD_CURVATURE
            float d = length(foot_pos);
            float R = 63710.0;

            float drop = (d * d) / (2.0 * R);

            gl_Position.y -= drop;
        #endif

        midCoord = (gl_TextureMatrix[0] * mc_midTexCoord).st;
        vec2 texMinMidCoord = TexCoords - midCoord;
        absMidCoordPos  = abs(texMinMidCoord);

        view_pos = vec4(gl_ModelViewMatrix * gl_Vertex).xyz;
        foot_pos = (gbufferModelViewInverse * vec4(view_pos, 1.0)).xyz;
        vec3 world_pos = foot_pos + cameraPosition;
        block_centered_relative_pos = foot_pos +at_midBlock.xyz/64.0 + fract(cameraPosition);
        ivec3 voxel_pos = ivec3(block_centered_relative_pos + VOXEL_RADIUS);

        isLeaves = mc_Entity.x == 10003? 1.0 : 0.0;

        #ifdef WAVING_FOLIAGE
            vec4 foliage_data = isFoliage == 1.0? vec4(1.0) : vec4(vec3(0.0),1.0);

            if((isFoliage == 1.0 || isLeaves == 1.0) && distanceFromCamera <= FOLIAGE_WAVE_DISTANCE * 16f) {
                float windPhase = world_pos.x * 0.2 + world_pos.z * 0.2;
                float wind = sin(windPhase + frameTimeCounter * 1.2 * FOLIAGE_SPEED) + 0.5 * sin(windPhase * 2.3 + frameTimeCounter * 2.0 * FOLIAGE_SPEED);
                float heightMask = clamp(1 - bottomY, 0.0, 1.0);
                float swayAmount = FOLIAGE_INTENSITY * 0.1;
                vec2 offsetXZ = vec2(wind * swayAmount * heightMask);
                vec3 offset = vec3(offsetXZ.x, 0.0, offsetXZ.y);
                gl_Position += gbufferProjection * gbufferModelView * vec4(offset,0.0);
                //vec3 waving = vec3(FOLIAGE_INTENSITY * sin(frameTimeCounter * FOLIAGE_SPEED));
                //gl_Position += gbufferProjection * gbufferModelView * (vec4(waving.x,0.0,waving.x,0.0)*(clamp(pow(1 - bottomY,1.5),0,1)) * 0.125);
            }
        #endif

        #if (SCENE_AWARE_LIGHTING > 0 && LIGHTING_MODE > 0) || LIGHTING_MODE == 2
            if(mod(gl_VertexID,4) == 0 && clamp(voxel_pos,0,VOXEL_AREA) == voxel_pos) {
                vec4 voxel_data = mc_Entity.x == 10005? vec4(1.0,0.0,0.0,1.0) : mc_Entity.x == 10006? vec4(0.0,1.0,0.0,1.0) : mc_Entity.x == 10007? vec4(0.0,0.0,1.0,1.0) : mc_Entity.x == 10008? vec4(1.0,1.0,0.0,1.0) : mc_Entity.x == 10009? vec4(0.0,1.0,1.0,1.0) : mc_Entity.x == 10010? vec4(1.0,0.0,1.0,1.0) : mc_Entity.x == 10012? vec4(1.0) : mc_Entity.x == 10013? vec4(0.5,0.0,0.0,1.0) : mc_Entity.x == 10003? vec4(0.0) : vec4(vec3(0.0),1.0);

                uint voxel_data2 = mc_Entity.x == 10005? 1 : mc_Entity.x == 10006? 2 : mc_Entity.x == 10007? 3 : mc_Entity.x == 10008? 4 : mc_Entity.x == 10009? 5 : mc_Entity.x == 10010? 6 : mc_Entity.x == 10012? 7 : mc_Entity.x == 10013? 8 : 0;

                uint voxel_data3 = mc_Entity.x == 10005? 1 : mc_Entity.x == 10006? 2 : mc_Entity.x == 10007? 3 : mc_Entity.x == 10008? 4 : mc_Entity.x == 10009? 5 : mc_Entity.x == 10010? 6 : mc_Entity.x == 10012? 7 : mc_Entity.x == 10013? 8 : 0;

                vec4 block_data = vec4(vec3(0.0),1.0);
                if(length(Normal.xyz) > 0.0 && mc_Entity.x != 2 && mc_Entity.x != 10003) block_data = vec4(1.0);

                uint integerValue = packUnorm4x8(voxel_data);

                lightData = voxel_data2;

                imageAtomicMax(cimage1, voxel_pos, voxel_data2);
            }

            #if FOG_STYLE == 2
                uint intValue = uint(clamp(length(foot_pos),minFog, maxFog) * FOG_PRECISION);
            #endif
        #endif
    }
#endif