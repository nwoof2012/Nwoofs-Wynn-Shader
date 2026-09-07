layout(location = 0) out vec4 DEFERRED_DATA;
layout(location = 1) out vec4 DEFERRED_NORMAL;
layout(location = 2) out vec4 TINT_AND_MASK;
layout(location = 3) out vec4 WRITE_DEPTH;
layout(location = 4) out vec4 WRITE_WATER;
layout(location = 5) out vec4 WRITE_DIST;
layout(location = 6) out vec4 WRITE_LIGHT;

uniform vec2 texelSize;

vec3 reconstructFootPos() {
    vec2 uv = gl_FragCoord.xy * texelSize;
    vec3 clip = vec3(uv, gl_FragCoord.z) * 2.0 - 1.0;

    vec4 view = vxProjInv * vec4(clip, 1.0);
    view.xyz /= view.w;

    vec4 foot = vxModelViewInv * view;
    
    return foot.xyz;
}

#include "/lib/data/settings.glsl"

const vec3 TorchColor = vec3(1.0f, 0.25f, 0.08f);
const float TorchBrightness = 5.0;
const vec3 GlowstoneColor = vec3(1.0f, 0.93f, 0.5f);
const float GlowstoneBrightness = 5.0;
const vec3 LampColor = vec3(1.0f, 0.75f, 0.4f);
const float LampBrightness = 5.0;
const vec3 LanternColor = vec3(0.8f, 1.0f, 1.0f);
const float LanternBrightness = 5.0;
const vec3 RedstoneColor = vec3(1.0f, 0.0f, 0.0f);
const float RedstoneBrightness = 5.0;
const vec3 RodColor = vec3(1.0f, 1.0f, 1.0f);
const float RodBrightness = 5.0;
const vec3 PortalColor = vec3(0.75f, 0.0f, 1.0f);
const float PortalBrightness = 5.0;
const vec3 FireColor = vec3(1.0f, 0.5f, 0.08f);
const float FireBrightness = 5.0;

vec3 encodeLight(vec3 light, float maxLight) {
    return log2(light + 1.0) / log2(maxLight + 1.0);
}

void voxy_emitFragment(VoxyFragmentParameters parameters) {

    vec3 normal = vec3( uint((parameters.face >> 1) == 2), uint((parameters.face >> 1) == 0), uint((parameters.face >> 1) == 1) ) * (float(int(parameters.face) & 1) * 2.0 - 1.0);
    normal = normalize(normal);

    vec3 albedo = parameters.sampledColour.rgb * parameters.tinting.rgb;

    vec3 footPos = reconstructFootPos();

    DEFERRED_DATA = vec4(albedo, 1.0);
    DEFERRED_NORMAL = vec4(normal * 0.5 + 0.5, 1.0);

    bool isLava = (parameters.customId == 10013);
    
    if(isLava) {
        TINT_AND_MASK.rgb = encodeLight((FireColor * FireBrightness)/3.25, MAX_LIGHT);
    }
    TINT_AND_MASK.a = 1.0;

    WRITE_DEPTH.r = gl_FragCoord.z;
    WRITE_DEPTH.g = 1.0;

    WRITE_WATER.r = 0.0;
    WRITE_WATER.g = 0.0;
    WRITE_WATER.a = 1.0;

    WRITE_LIGHT.rg = parameters.lightMap.xy;

    WRITE_DIST.y = length(footPos);
    WRITE_DIST.w = 1.0;
}