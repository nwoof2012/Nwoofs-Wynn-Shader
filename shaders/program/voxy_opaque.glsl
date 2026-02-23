#include "/lib/includes2.glsl"

layout(location = 0) out vec4 DEFERRED_DATA;
layout(location = 1) out vec4 DEFERRED_NORMAL;

void voxy_emitFragment(VoxyFragmentParameters parameters) {

    vec3 normal = vec3( uint((parameters.face >> 1) == 2), uint((parameters.face >> 1) == 0), uint((parameters.face >> 1) == 1) ) * (float(int(parameters.face) & 1) * 2.0 - 1.0);

    normal = normalize(normal);

    vec3 albedo = parameters.sampledColour.rgb * parameters.tinting.rgb;

    DEFERRED_DATA = vec4(albedo, 1.0);
    DEFERRED_NORMAL = vec4(normal, 1.0);
}