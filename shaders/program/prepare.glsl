#ifdef COMPUTE_SHADER
    #include "/lib/data/settings.glsl"

    #include "/lib/includes2.glsl"

    #include "/lib/optimizationFunctions.glsl"
    #include "/lib/colorFunctions.glsl"

    #define LIGHT_DIAMETER (LIGHT_RADIUS * 2)

    #define WORLD_TOP 319

    layout (r32ui) uniform uimage3D cimage1;
    layout (r32ui) uniform uimage3D cimage6;
    layout (rgba8) uniform image3D cimage2;
    layout (r32ui) uniform uimage3D cimage3;
    layout (rgba8) uniform image3D cimage4;

    uniform ivec3 cameraPositionInt;
	uniform ivec3 previousCameraPositionInt;
    uniform int frameCounter;

    const vec3 TorchColor = vec3(1.0f, 0.25f, 0.08f);
    const float TorchBrightness = 2.0;
    const float TorchFalloff = 0.88;
    const vec3 GlowstoneColor = vec3(1.0f, 0.93f, 0.5f);
    const float GlowstoneBrightness = 2.0;
    const float GlowstoneFalloff = 0.88;
    const vec3 LampColor = vec3(1.0f, 0.75f, 0.4f);
    const float LampBrightness = 2.0;
    const float LampFalloff = 0.88;
    const vec3 LanternColor = vec3(0.8f, 1.0f, 1.0f);
    const float LanternBrightness = 2.0;
    const float LanternFalloff = 0.88;
    const vec3 RedstoneColor = vec3(1.0f, 0.0f, 0.0f);
    const float RedstoneBrightness = 2.0;
    const float RedstoneFalloff = 0.88;
    const vec3 RodColor = vec3(1.0f, 1.0f, 1.0f);
    const float RodBrightness = 2.0;
    const float RodFalloff = 0.88;
    const vec3 PortalColor = vec3(0.75f, 0.0f, 1.0f);
    const float PortalBrightness = 2.0;
    const float PortalFalloff = 0.88;
    const vec3 FireColor = vec3(1.0f, 0.5f, 0.08f);
    const float FireBrightness = 2.0;
    const float FireFalloff = 0.88;

    vec4 decodeLightmap(uint lightmap) {
        vec4 lighting = vec4(vec3(0.0),1.0);
        if(lightmap == 1)
        {
            lighting.xyz = TorchColor * TorchBrightness;
            lighting.w = TorchFalloff;
        }
        else if(lightmap == 2)
        {
            lighting.xyz = GlowstoneColor * GlowstoneBrightness;
            lighting.w = GlowstoneFalloff;
        } else if(lightmap == 3)
        {
            lighting.xyz = LampColor * LampBrightness;
            lighting.w = LampFalloff;
        } else if(lightmap == 4)
        {
            lighting.xyz = LanternColor * LanternBrightness;
            lighting.w = LanternFalloff;
        } else if(lightmap == 5)
        {
            lighting.xyz = RedstoneColor * RedstoneBrightness;
            lighting.w = RedstoneFalloff;
        } else if(lightmap == 6)
        {
            lighting.xyz = RodColor * RodBrightness;
            lighting.w = RodFalloff;
        } else if(lightmap == 7)
        {
            lighting.xyz = PortalColor * PortalBrightness;
            lighting.w = PortalFalloff;
        } else if(lightmap == 8)
        {
            lighting.xyz = FireColor * FireBrightness;
            lighting.w = FireFalloff;
        } else {
            lighting.w = 0;
        }
        return lighting;
    }

    const ivec3 NEIGHBORS[6] = ivec3[](
        ivec3( 1,  0,  0),
        ivec3(-1,  0,  0),
        ivec3( 0,  1,  0),
        ivec3( 0, -1,  0),
        ivec3( 0,  0,  1),
        ivec3( 0,  0, -1)
    );

    bool isSolid(ivec3 voxel) {
        uint returnValue = imageLoad(cimage6, voxel).r;
        return returnValue == uint(1);
    }

    #define SKY_DETECT_STEPS 8

    bool rayHitsSky(ivec3 start, vec3 direction)
    {
        ivec3 voxel = start;

        for (int i = 0; i < SKY_DETECT_STEPS; i++)
        {
            if (isSolid(voxel))
                return false;

            voxel += ivec3(direction);
            
            if (voxel.y >= WORLD_TOP)
                return true;
        }

        return true;
    }

    const ivec3 workGroups = ivec3(16, 8, 128);

    layout (local_size_x = 8, local_size_y = 16, local_size_z = 1) in;

    void main() {
        #if LIGHTING_MODE > 0
            ivec3 origin_voxel_pos = ivec3(gl_GlobalInvocationID.xyz);
            ivec3 camshift = cameraPositionInt-previousCameraPositionInt;

            ivec3 voxel_pos_old = origin_voxel_pos + camshift;
            ivec3 voxel_pos_new = origin_voxel_pos;

            voxel_pos_old = clamp(voxel_pos_old, ivec3(0), ivec3(VOXEL_AREA));
            voxel_pos_new = clamp(voxel_pos_new, ivec3(0), ivec3(VOXEL_AREA));

            uint integerValue = imageLoad(cimage1, origin_voxel_pos).r;
            vec4 emitterColor = decodeLightmap(integerValue);

            uint integerValue_Sunlight = imageLoad(cimage3, origin_voxel_pos).r;
            float sunlightValue = float(integerValue_Sunlight)/240.0;

            vec4 lightColor = emitterColor;
            #if SCENE_AWARE_LIGHTING > 0
                for(int i = 0; i < 6; i++) {
                    ivec3 neighborPos = voxel_pos_old + NEIGHBORS[i];
                    vec4 neighborLight = decodeLight(imageLoad(cimage2, neighborPos ), MAX_LIGHT);

                    vec4 propagatedLight = neighborLight * 0.88;

                    lightColor = mix2(lightColor, propagatedLight, step(lightColor.w, propagatedLight.w));
                }
            #endif

            float exposure = sunlightValue;
            float propagatedSunlight = 0.0;

            //if(!rayHitsSky(origin_voxel_pos, vec3(0, 1, 0))) {
            //exposure = 0.0;
            for(int i = 0; i < 6; i++) {
                ivec3 neighborPos = voxel_pos_old + NEIGHBORS[i];
                neighborPos = clamp(neighborPos, ivec3(0), ivec3(VOXEL_AREA));
                float neighborExposure = imageLoad(cimage4, neighborPos).x;

                propagatedSunlight = max(propagatedSunlight, neighborExposure * 0.88);
            }
            //}

            //exposure = max(exposure, propagatedSunlight);

            #if SCENE_AWARE_LIGHTING > 0
                imageStore(cimage2, voxel_pos_new, encodeLight(lightColor,MAX_LIGHT));
            #endif

            //lightColor = mix2(lightColor, lightStepColor(lightColor, emitterColor), lightStep(vec4(0.1), emitterColor));

            imageStore(cimage4, voxel_pos_new, vec4(exposure, 0.0, 0.0, 1.0));
        #endif
    }
#endif