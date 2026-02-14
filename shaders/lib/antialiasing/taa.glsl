vec3 applyTAA(vec2 UVs, sampler2D currentTex) {
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