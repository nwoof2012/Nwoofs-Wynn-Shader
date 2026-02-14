float colorDiff(vec3 a, vec3 b) {
    return length(a - b);
}

float depthEdgeFactor(vec2 UVs) {
    float dz = abs(texture2D(depthtex0, UVs).r - texture2D(depthtex0, UVs + vec2(1.0/viewWidth, 0)).r);
    return step(0.01, dz);
}

float computeBlendStrength(vec2 UVs) {
    float depth = depthEdgeFactor(UVs);

    float linearDepth = linearizeDepth(depth, near, far);

    float fadeStart = SMAA_NEAR_THRESHOLD;
    float fadeEnd = SMAA_FAR_THRESHOLD;

    float strength = 1.0 - smoothstep(fadeStart, fadeEnd, 1.0 - linearDepth);

    return strength;
}

float edgeFactor(vec2 UVs, sampler2D tex) {
    float threshold = SMAA_EDGE_FACTOR;

    vec3 center = texture2D(tex, UVs).rgb;
    vec3 right = texture2D(tex, UVs + vec2(1.0/viewWidth, 0.0)).rgb;
    vec3 bottom = texture2D(tex, UVs + vec2(0.0, 1.0/viewHeight)).rgb;

    float horizontalEdge = colorDiff(center, right);
    float verticalEdge = colorDiff(center, bottom);

    return step(threshold, max(horizontalEdge, verticalEdge));
}

vec3 blendSMAA(vec2 UVs, sampler2D tex) {
    vec2 offset = vec2(1.0/viewWidth, 1.0/viewHeight);
    
    vec3 colorLeft = texture2D(tex, UVs - vec2(offset.x, 0)).rgb;
    vec3 colorRight = texture2D(tex, UVs + vec2(offset.x, 0)).rgb;
    vec3 colorUp = texture2D(tex, UVs - vec2(0, offset.y)).rgb;
    vec3 colorDown = texture2D(tex, UVs + vec2(0, offset.y)).rgb;

    vec3 horizontalBlend = mix2(colorLeft, colorRight, 0.5);
    vec3 verticalBlend = mix2(colorUp, colorDown, 0.5);

    float horizontalDiff = length(colorLeft - colorRight);
    float verticalDiff = length(colorUp - colorDown);

    return mix2(horizontalBlend, verticalBlend, step(horizontalDiff, verticalDiff));
}