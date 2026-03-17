// =====================================================
// Minimal Voxy Translucent Template
// =====================================================

//
// Required Voxy matrices & uniforms (provided by Voxy)
//

uniform vec2 texelSize;

//
// Outputs expected by Voxy
//
layout(location = 0) out vec4 FORWARD_RENDERED_COLOR;
layout(location = 1) out vec4 NORMAL;
layout(location = 2) out vec4 TINT_AND_MASK;
layout(location = 3) out vec4 WRITE_DEPTH;
layout(location = 4) out vec4 WRITE_WATER;
layout(location = 5) out vec4 WRITE_DIST;
layout(location = 6) out vec4 WRITE_LIGHT;

//
// Provided by Voxy
//
struct VoxyFragmentParameters {
    vec4 sampledColour;
    vec2 tile;
    vec2 uv;
    uint face;
    uint modelId;
    vec2 lightMap;
    vec4 tinting;
    uint customId;
};

//
// Helper: decode face normal
//
vec3 decodeFaceNormal(uint face) {
    return normalize(
        vec3(
            uint((face >> 1) == 2),
            uint((face >> 1) == 0),
            uint((face >> 1) == 1)
        ) * (float(int(face) & 1) * 2.0 - 1.0)
    );
}

//
// Helper: convert screen depth → view position
//
vec3 reconstructViewPos() {
    vec2 uv = gl_FragCoord.xy * texelSize;
    vec3 clip = vec3(uv, gl_FragCoord.z) * 2.0 - 1.0;

    vec4 view = vxProjInv * vec4(clip, 1.0);
    return view.xyz / view.w;
}

vec3 reconstructFootPos() {
    vec2 uv = gl_FragCoord.xy * texelSize;
    vec3 clip = vec3(uv, gl_FragCoord.z) * 2.0 - 1.0;

    vec4 view = vxProjInv * vec4(clip, 1.0);
    view.xyz /= view.w;

    vec4 foot = vxModelViewInv * view;
    
    return foot.xyz / foot.w;
}

//
// MAIN VOXY ENTRY POINT
//
void voxy_emitFragment(VoxyFragmentParameters parameters) {

    // -----------------------------------------
    // 1. Reset outputs
    // -----------------------------------------
    FORWARD_RENDERED_COLOR = vec4(0.0);
    TINT_AND_MASK = vec4(0.0);
    WRITE_DEPTH = vec4(0.0);

    // -----------------------------------------
    // 2. Basic material detection
    // -----------------------------------------
    bool isWater = (parameters.customId == 8); // adjust if needed
    float materialMask = isWater ? 1.0 : 0.7;

    // -----------------------------------------
    // 3. Surface data
    // -----------------------------------------
    vec3 normal = vec3( uint((parameters.face >> 1) == 2), uint((parameters.face >> 1) == 0), uint((parameters.face >> 1) == 1) ) * (float(int(parameters.face) & 1) * 2.0 - 1.0);
    normal = normalize(normal);
    vec3 viewNormal = normalize((vxModelView * vec4(normal, 0.0)).xyz);

    vec2 uv = gl_FragCoord.xy * texelSize;

    vec4 albedo = parameters.sampledColour * parameters.tinting;

    // Optional: linearize if your shader is linear workflow
    // albedo.rgb = pow(albedo.rgb, vec3(2.2));

    // -----------------------------------------
    // 4. Reconstruct positions
    // -----------------------------------------
    vec3 viewPos = reconstructViewPos();

    vec3 footPos = reconstructFootPos();

    // -----------------------------------------
    // 5. Define water normals
    // -----------------------------------------
    vec3 waterNormal = texture(water, fract(footPos.xz + cameraPosition.xz + ((frameCounter)/90f)*0.5f) * 0.035f).yzx * texture(water, fract(footPos.xz - cameraPosition.xz + ((frameCounter)/90f)*0.5f) * 0.035f).yzx * 2 - 1;
    if(isWater) normal = waterNormal;

    // -----------------------------------------
    // 6. Basic lighting (replace with your own)
    // -----------------------------------------
    vec3 lightDir = normalize(vec3(0.3, 1.0, 0.2));
    float NdotL = max(dot(normal, lightDir), 0.0);

    vec3 diffuse = albedo.rgb * NdotL;
    vec3 ambient = albedo.rgb * 0.2;

    vec3 finalColor = diffuse;

    // -----------------------------------------
    // 7. Write outputs
    // -----------------------------------------
    FORWARD_RENDERED_COLOR.rgb = finalColor;
    FORWARD_RENDERED_COLOR.a = isWater? 0.0 : albedo.a;

    WRITE_DEPTH.r = gl_FragCoord.z;
    WRITE_DEPTH.g = 1.0;
    
    NORMAL = vec4(normal*0.5 + 0.5,1.0);

    WRITE_WATER.r = isWater? 1.0 : 0.0;
    WRITE_WATER.g = 0.0;
    WRITE_WATER.a = 1.0;

    WRITE_DIST.y = length(footPos);
    WRITE_DIST.w = 1.0;

    WRITE_LIGHT.rg = parameters.lightMap.xy;
}
