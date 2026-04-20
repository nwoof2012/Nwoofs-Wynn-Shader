#ifdef COMPUTE_SHADER
    #include "/lib/data/settings.glsl"

    #include "/lib/includes2.glsl"

    #include "/lib/optimizationFunctions.glsl"

    #define LIGHT_DIAMETER (LIGHT_RADIUS * 2)

    layout (r32ui) uniform uimage3D cimage1;
    layout (rgba8) uniform image3D cimage2;

    uniform ivec3 cameraPositionInt;
	uniform ivec3 previousCameraPositionInt;
    uniform int frameCounter;

    const vec3 TorchColor = vec3(1.0f, 0.25f, 0.08f);
    const float TorchBrightness = 25.0;
    const vec3 GlowstoneColor = vec3(1.0f, 0.93f, 0.5f);
    const float GlowstoneBrightness = 5.0;
    const vec3 LampColor = vec3(1.0f, 0.75f, 0.4f);
    const float LampBrightness = 25.0;
    const vec3 LanternColor = vec3(0.8f, 1.0f, 1.0f);
    const float LanternBrightness = 25.0;
    const vec3 RedstoneColor = vec3(1.0f, 0.0f, 0.0f);
    const float RedstoneBrightness = 5.0;
    const vec3 RodColor = vec3(1.0f, 1.0f, 1.0f);
    const float RodBrightness = 25.0;
    const vec3 PortalColor = vec3(0.75f, 0.0f, 1.0f);
    const float PortalBrightness = 25.0;
    const vec3 FireColor = vec3(1.0f, 0.5f, 0.08f);
    const float FireBrightness = 25.0;

    vec4 decodeLightmap(uint lightmap) {
        vec4 lighting = vec4(vec3(0.0),1.0);
        if(lightmap == 1)
        {
            lighting.xyz = TorchColor * TorchBrightness;
            lighting.w = TorchBrightness;
        }
        else if(lightmap == 2)
        {
            lighting.xyz = GlowstoneColor * GlowstoneBrightness;
            lighting.w = GlowstoneBrightness;
        } else if(lightmap == 3)
        {
            lighting.xyz = LampColor * LampBrightness;
            lighting.w = LampBrightness;
        } else if(lightmap == 4)
        {
            lighting.xyz = LanternColor * LanternBrightness;
            lighting.w = LanternBrightness;
        } else if(lightmap == 5)
        {
            lighting.xyz = RedstoneColor * RedstoneBrightness;
            lighting.w = RedstoneBrightness;
        } else if(lightmap == 6)
        {
            lighting.xyz = RodColor * RodBrightness;
            lighting.w = RodBrightness;
        } else if(lightmap == 7)
        {
            lighting.xyz = PortalColor * PortalBrightness;
            lighting.w = PortalBrightness;
        } else if(lightmap == 8)
        {
            lighting.xyz = FireColor * FireBrightness;
            lighting.w = FireBrightness;
        } else {
            lighting.w = 0;
        }
        return lighting;
    }

    layout (local_size_x = 8, local_size_y = 16, local_size_z = 1) in;

    void main() {
        #if LIGHTING_MODE > 0 && SCENE_AWARE_LIGHTING == 2
            ivec3 origin_voxel_pos = ivec3(gl_GlobalInvocationID.xyz);
            ivec3 camshift = cameraPositionInt-previousCameraPositionInt;

            ivec3 voxel_pos_old = origin_voxel_pos + camshift;
            ivec3 voxel_pos_new = origin_voxel_pos;
            
            ivec3 double_buffer_offset_write = mod(frameCounter, 2) == 0? ivec3(0, VOXEL_AREA, 0) : ivec3(0);
            ivec3 double_buffer_offset_read = mod(frameCounter, 2) != 0? ivec3(0, VOXEL_AREA, 0) : ivec3(0);

            voxel_pos_new += double_buffer_offset_write;
            voxel_pos_old += double_buffer_offset_read;

            uint integerValue = imageLoad(cimage1, origin_voxel_pos).r;
            vec4 lightColor = decodeLightmap(integerValue);

            vec4 totalLight = lightColor;

            for(int idx = 0; idx < LIGHT_DIAMETER * LIGHT_DIAMETER * LIGHT_DIAMETER; idx++) {
                int x = int(mod(idx, LIGHT_DIAMETER) - LIGHT_RADIUS);
                int y = int(mod(idx/LIGHT_DIAMETER, LIGHT_RADIUS) - LIGHT_RADIUS);
                int z = int(idx/LIGHT_DIAMETER - LIGHT_RADIUS);
                ivec3 neighbor = ivec3(x, y, z);
                
                if(neighbor == ivec3(0)) continue;

                vec4 light = imageLoad(cimage2, origin_voxel_pos+neighbor);
                totalLight += light;
            }

            imageStore(cimage2, voxel_pos_new, vec4(encodeLight(totalLight.xyz,MAX_LIGHT),totalLight.w));
        #endif
    }
#endif