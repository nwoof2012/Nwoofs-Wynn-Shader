uniform float blindness;

mediump float minBlindnessDistance = 7.5;
mediump float maxBlindDistance = 10;

#define BLINDNESS_TYPE 1 // [0 1]

vec3 blindEffect(vec3 color) {
    if(blindness > 0f) {
        mediump float distanceFromCamera = distance(vec3(0), viewSpaceFragPosition);
        return mix2(color,vec3(0),clamp((distanceFromCamera - minBlindnessDistance)/(maxBlindDistance - minBlindnessDistance) * blindness,0,1));
    }
}

vec3 blindEffect(vec3 color, vec2 uv) {
    if(blindness > 0f) {
        //mediump float depth = mix2(linearizeDepth(texture2D(depthtex0, uv).x,near,far) / dhFarPlane, texture2D(colortex13, uv).z * 0.475, step(1.0, texture2D(depthtex0, uv).x)) * 32 * dhFarPlane;
        float depth = texture2D(depthtex0, uv).r;
        vec2 ndc = uv * 2.0 - 1.0;

        vec4 clipSpace = vec4(ndc, depth, 1.0);
        vec4 viewSpace = gbufferProjectionInverse * clipSpace;
        viewSpace /= viewSpace.w;

        vec4 worldSpace = gbufferModelViewInverse * viewSpace;
        worldSpace /= worldSpace.w;

        float dist = distance(vec3(0.0), worldSpace.xyz);
        //if(texture2D(depthtex0, uv).x >= 1.0) depth = dhFarPlane;
        return mix2(color,vec3(0),smoothstep(minBlindnessDistance, maxBlindDistance, dist));
    } else {
        return color;
    }
}