vec3 applySIAA(vec2 UVs, sampler2D currentTex) {
    float depth = linearizeDepth(texture2D(depthtex0, UVs).r,near,far);
    vec3 ndc = vec3(UVs * 2 - 1, texture2D(depthtex0, UVs).r * 2 - 1);
    vec4 clip = vec4(ndc, 1.0);
    vec4 view = gbufferProjectionInverse * clip;
    view /= view.w;
    vec4 world = gbufferModelViewInverse * view;

    vec4 prevView = gbufferPreviousModelView * world;
    vec4 prevClip = gbufferPreviousProjection * prevView;

    prevClip /= prevClip.w;

    vec2 prevUV = prevClip.xy * 0.5 + 0.5;

    float prevDepth = linearizeDepth(texture2D(depthtex0, prevUV).r,near,far);

    float depthAccum = 0.0;

    vec2 viewSize = vec2(viewWidth, viewHeight);

    for(int x = -1; x <= 1; x++) {
        for(int y = -1; y <= 1; y++) {
            ivec2 iUV = ivec2(UVs*viewSize) + ivec2(x, y);
            vec2 sampleUV = vec2(iUV) / viewSize;

            depthAccum += abs(depth - linearizeDepth(texture2D(depthtex0, sampleUV).r,near,far));
        }
    }

    depthAccum /= 9.0;

    float motionFactor = depthAccum;
    float blend = clamp(motionFactor, 0.0, 1.0);

    vec2 uv = UVs * viewSize;

    vec2 uv_f = fract(uv);

    vec2 uv_00 = floor(uv)/viewSize;
    vec2 uv_01 = vec2(floor(uv.x), ceil(uv.y))/viewSize;
    vec2 uv_10 = vec2(ceil(uv.x), floor(uv.y))/viewSize;
    vec2 uv_11 = ceil(uv)/viewSize;

    vec3 sample_00 = texture2D(currentTex, uv_00).rgb;
    vec3 sample_01 = texture2D(currentTex, uv_01).rgb;
    vec3 sample_10 = texture2D(currentTex, uv_10).rgb;
    vec3 sample_11 = texture2D(currentTex, uv_11).rgb;

    vec3 sample_0 = mix2(sample_00, sample_10,uv_f.x);
    vec3 sample_1 = mix2(sample_01, sample_11,uv_f.x);

    vec3 sampleValue = mix2(sample_0, sample_1, uv_f.y);

    vec3 current = texture2D(currentTex, UVs).rgb;

    return mix2(current, sampleValue, blend);
}