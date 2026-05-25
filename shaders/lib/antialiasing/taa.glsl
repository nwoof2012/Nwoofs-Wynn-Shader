vec3 rgb2ycocg(vec3 rgb) {
    float y  =  rgb.r/4.0 + rgb.g/2.0 + rgb.b/4.0;
    float co =  rgb.r/2.0 - rgb.b/2.0;
    float cg = -rgb.r/4.0 + rgb.g/2.0 - rgb.b/4.0;
    return vec3(y, co, cg);
}

float taaLuminance(vec3 c) {
    return dot(c, vec3(0.299, 0.587, 0.114));
}

vec3 applyTAA_experimental(vec2 UVs, sampler2D currentTex) {
    vec3 current = texture2D(currentTex, UVs).rgb;

    float depth = texture2D(depthtex0, UVs).r;

    vec4 view = gbufferProjectionInverse * vec4(UVs * 2 - 1, depth * 2 - 1, 1.0);
    view /= view.w;
    vec4 world = gbufferModelViewInverse * view;
    
    vec4 prevView = gbufferPreviousModelView * world;
    prevView /= prevView.w;
    vec4 prevNDC = gbufferPreviousProjection * prevView;
    vec2 prevUV = prevNDC.xy * 0.5 + 0.5;

    vec2 velocity = UVs - prevUV;

    vec2 historyUV = UVs - velocity;

    vec3 history = imageLoad(cimage7, ivec2(historyUV*vec2(viewWidth, viewHeight))).xyz;

    float center = luminance(current);

    float edge = 0.0;

    vec3 minColor = current;
    vec3 maxColor = current;
    for(int x = -1; x <= 1; x++) {
        for(int y = -1; y <= 1; y++) {
            if(x == 0 && y == 0) continue;

            vec2 offset = vec2(x, y)/vec2(viewWidth, viewHeight);

            vec3 neighbour = texture2D(currentTex, UVs + offset).rgb;

            float sampleLum = luminance(neighbour);

            edge = max(edge, abs(center - sampleLum));
            
            minColor = min(minColor, neighbour);
            maxColor = max(maxColor, neighbour);
        }
    }

    //return vec3(edge);

    history = clamp(history, minColor, maxColor);

    vec3 diff = abs(current - history);

    float threshold = smoothstep(0, TAA_EDGE_FACTOR, edge);

    #if DEBUG == 1 && DEBUG_MODE == 9
        return vec3(threshold);
    #endif

    return mix2(current, history, threshold * TAA_BLEND);
}

vec3 applyTAA(vec2 UVs, sampler2D currentTex) {
    return applyTAA_experimental(UVs, currentTex);
    vec3 current = texture2D(currentTex, UVs).rgb;
    vec4 history = imageLoad(cimage7, ivec2(UVs*vec2(viewWidth, viewHeight)));

    float alpha = TAA_BLEND;
    vec3 finalColor = current;
    if(length(history) > 0.0) {
        vec3 finalColor = mix2(current, history.rgb, alpha);
    }
    imageStore(cimage7, ivec2(UVs*vec2(viewWidth, viewHeight)), vec4(finalColor, 1.0));
    return finalColor;
}