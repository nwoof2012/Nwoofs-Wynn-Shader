vec3 last_world_pos_dir = (gbufferModelViewInverse*vec4(view_pos.xyz,1.0)).xyz;

vec4 old_raydir;
old_raydir.xyz = (gbufferPreviousModelView*vec4(last_world_pos_dir.xyz,1.0)).xyz;

old_raydir = gbufferPreviousProjection*vec4(old_raydir.xyz,1.0);
mediump float sz = old_raydir.z;
old_raydir.xyz /= old_raydir.w;
old_raydir.xyz = old_raydir.xyz*0.5 + 0.5;

vec4 ray_color;
if(old_raydir.x >= 0.0 && old_raydir.x < 1.0 && old_raydir.y >= 0.0 && old_raydir.y <= 1.0 && sz > 0.0) {
    ray_color = texture2D(colortex1, old_raydir.xy);
} else {
    ray_color.rgb = color.rgb;
}