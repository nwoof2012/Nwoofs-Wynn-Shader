#define AA_SAMPLES 31.0 // [3.0 5.0 7.0 9.0 11.0 13.0 15.0 17.0 19.0 21.0 23.0 25.0 27.0 29.0 31.0]
#ifdef AA
    vec3 antialiasing(in sampler2D texture, in vec2 uv) {
        vec3 finalColor = texture2D(texture, uv).rgb;
        for(int i = 0; i < AA_SAMPLES + 1; i++) {
            finalColor += texture2D(texture, uv - vec2(i/AA_SAMPLES - 0.025)/viewHeight).rgb * mix(1, 0.001, clamp(i/AA_SAMPLES * 5,0,1));
            finalColor += texture2D(texture, uv + vec2(i/AA_SAMPLES  + 0.025)/viewHeight).rgb * mix(1, 0.001, clamp(i/AA_SAMPLES * 5,0,1));
        }
        return finalColor/(AA_SAMPLES);
    }
#endif