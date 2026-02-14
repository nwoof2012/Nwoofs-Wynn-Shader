#ifdef VERTEX_SHADER
    vec3 shadow_view_pos = vec4(gl_ModelViewMatrix * gl_Vertex).xyz;
    vec3 foot_pos = (shadowModelViewInverse * vec4(shadow_view_pos,1.0)).xyz;
    vec3 world_pos = foot_pos + cameraPosition;

    #define VOXEL_AREA 128 // [32 64 128]
    #define VOXEL_RADIUS (VOXEL_AREA/2)
    
    vec3 block_centered_relative_pos = foot_pos + at_midBlock.xyz/64.0 + fract(cameraPosition);
    ivec3 voxel_pos = ivec3(block_centered_relative_pos + VOXEL_RADIUS);


    if(mod(gl_VertexID,4) == 0 && clamp(voxel_pos,0,VOXEL_AREA) == voxel_pos) {
        const vec3 TorchColor = vec3(1.0f, 0.25f, 0.08f);
        const vec3 GlowstoneColor = vec3(1.0f, 0.85f, 0.5f);
        const vec3 LampColor = vec3(1.0f, 0.75f, 0.4f);
        const vec3 LanternColor = vec3(0.8f, 1.0f, 1.0f);
        const vec3 RedstoneColor = vec3(1.0f, 0.0f, 0.0f);
        const vec3 RodColor = vec3(1.0f, 1.0f, 1.0f);

        vec4 voxel_data = mc_Entity.x == 10005? vec4(TorchColor,1.0) : mc_Entity.x == 10006? vec4(GlowstoneColor,1.0) : mc_Entity.x == 10007? vec4(LampColor,1.0) : mc_Entity.x == 10008? vec4(LanternColor,1.0) : mc_Entity.x == 10009? vec4(RedstoneColor,1.0) : mc_Entity.x == 10010? vec4(RodColor,1.0);

        uint integerValue = packUnorm4x8(voxel_data);

        imageAtomicMax(cimage1, voxel_pos, integerValue);
    }
#endif