vec2 Halton(int index)
{
    vec2 result = vec2(0.0);

    float f = 1.0;
    int i = index;

    f /= 2.0;
    while(i > 0)
    {
        result.x += f * float(i % 2);
        i /= 2;
        f /= 2.0;
    }

    f = 1.0;
    i = index;

    f /= 3.0;
    while(i > 0)
    {
        result.y += f * float(i % 3);
        i /= 3;
        f /= 3.0;
    }

    return result;
}

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