#ifdef AUTO_EXPOSURE
    vec3 averageColor(sampler2D tex) {
        vec3 c = texture2D(tex, vec2(0.5, 0.5)).rgb;
        for(int x = -2; x <= 2; x++) {
            for(int y = -2; y <= 2; y++) {
               c += texture2D(tex, vec2(0.125) + vec2(x, y) * 0.125).rgb;
            }
        }
        c /= 16;
        return c;
    }
    vec3 calcHDR_experimental(vec3 color, float targetLum, float speed, int samples, float sampleRatio) {
        vec3 sampleColor = averageColor(colortex0);
        float averageBrightness = 0.7;
        
        float previousExposure = imageLoad(cimage3, ivec2(0, 0)).r;

        float exposure = mix2(previousExposure, targetLum/averageBrightness, 0.35);
        
        return color * exposure * (exposure/MAX_LIGHT+1.0)/(exposure + 1.0);

        imageStore(cimage3, ivec2(0, 0), vec4(exposure));
    }
    vec3 calcHDR(vec3 color, float targetLum, float speed, int samples, float sampleRatio) {
        return calcHDR_experimental(color, targetLum, speed, samples, sampleRatio);
        float minLum = targetLum/sampleRatio;
        float maxLum = targetLum * sampleRatio;

        vec3 sum = vec3(0.0);

        for(int i = 0; i < samples; i++) {
            float lum = mix2(minLum, maxLum, clamp(float(i + 1)/float(samples),0.0,1.0));
            vec3 sampleCol = autoExposure(color, lum, speed);
            sum += sampleCol;
        }

        return sum/samples;
    }
#endif