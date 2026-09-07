#ifdef COMPUTE_SHADER
    #include "/lib/data/settings.glsl"

    #include "/lib/includes2.glsl"

    #include "/lib/optimizationFunctions.glsl"
    #include "/lib/colorFunctions.glsl"

    #define LIGHT_DIAMETER (LIGHT_RADIUS * 2)

    layout (r32ui) uniform uimage3D cimage1;
    layout (rgba8) uniform image3D cimage2;

    uniform ivec3 cameraPositionInt;
	uniform ivec3 previousCameraPositionInt;
    uniform int frameCounter;

    const vec3 TorchColor = vec3(1.0f, 0.25f, 0.08f);
    const float TorchBrightness = 5.0;
    const float TorchFalloff = 0.88;
    const vec3 GlowstoneColor = vec3(1.0f, 0.93f, 0.5f);
    const float GlowstoneBrightness = 5.0;
    const float GlowstoneFalloff = 0.88;
    const vec3 LampColor = vec3(1.0f, 0.75f, 0.4f);
    const float LampBrightness = 5.0;
    const float LampFalloff = 0.88;
    const vec3 LanternColor = vec3(0.8f, 1.0f, 1.0f);
    const float LanternBrightness = 5.0;
    const float LanternFalloff = 0.88;
    const vec3 RedstoneColor = vec3(1.0f, 0.0f, 0.0f);
    const float RedstoneBrightness = 5.0;
    const float RedstoneFalloff = 0.88;
    const vec3 RodColor = vec3(1.0f, 1.0f, 1.0f);
    const float RodBrightness = 5.0;
    const float RodFalloff = 0.88;
    const vec3 PortalColor = vec3(0.75f, 0.0f, 1.0f);
    const float PortalBrightness = 5.0;
    const float PortalFalloff = 0.88;
    const vec3 FireColor = vec3(1.0f, 0.5f, 0.08f);
    const float FireBrightness = 5.0;
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

    const ivec3 workGroups = ivec3(16, 8, 128);

    layout (local_size_x = 8, local_size_y = 16, local_size_z = 1) in;

    void main() {
        #if LIGHTING_MODE > 0 && SCENE_AWARE_LIGHTING > 0
            ivec3 origin_voxel_pos = ivec3(gl_GlobalInvocationID.xyz);
            ivec3 camshift = cameraPositionInt-previousCameraPositionInt;

            ivec3 voxel_pos_old = origin_voxel_pos + camshift;
            ivec3 voxel_pos_new = origin_voxel_pos;
            
            //ivec3 double_buffer_offset_write = mod(frameCounter, 2) == 0? ivec3(0, VOXEL_AREA, 0) : ivec3(0);
            //ivec3 double_buffer_offset_read = mod(frameCounter, 2) != 0? ivec3(0, VOXEL_AREA, 0) : ivec3(0);

            //voxel_pos_new += double_buffer_offset_write;
            //voxel_pos_old += double_buffer_offset_read;

            uint integerValue = imageLoad(cimage1, origin_voxel_pos).r;
            vec4 emitterColor = decodeLightmap(integerValue);

            vec4 lightColor = emitterColor;

            /*ivec3 neighbor = ivec3(1.,0.,0.); //pick neighbor location
            vec4 light = decodeLight(imageLoad(cimage2, voxel_pos_old+neighbor ), MAX_LIGHT);  //load last frame data
            vec4 total_light = light-1./15.; //make the effect fade over distance

            neighbor = ivec3(-1.,0.,0.);
            light = decodeLight(imageLoad(cimage2, voxel_pos_old+neighbor ), MAX_LIGHT);
            total_light = max(total_light,light-1./15.);

            neighbor = ivec3(0.,0.,1.);
            light = decodeLight(imageLoad(cimage2, voxel_pos_old+neighbor ), MAX_LIGHT);
            total_light = max(total_light,light-1./15.);

            neighbor = ivec3(0.,0.,-1.);
            light = decodeLight(imageLoad(cimage2, voxel_pos_old+neighbor ), MAX_LIGHT);
            total_light = max(total_light,light-1./15.);

            total_light = max(total_light,vec4(0.0));*/

            //lightColor = max(lightColor, total_light);

            for(int i = 0; i < 6; i++) {
                ivec3 neighborPos = voxel_pos_old + NEIGHBORS[i];
                vec4 neighborLight = decodeLight(imageLoad(cimage2, neighborPos ), MAX_LIGHT);

                vec4 propagatedLight = neighborLight * 0.88;

                lightColor = mix2(lightColor, propagatedLight, step(lightColor.w, propagatedLight.w));
            }

            //lightColor = mix2(lightColor, lightStepColor(lightColor, emitterColor), lightStep(vec4(0.1), emitterColor));

            imageStore(cimage2, voxel_pos_new, encodeLight(lightColor,MAX_LIGHT));
        #endif
    }
#endif