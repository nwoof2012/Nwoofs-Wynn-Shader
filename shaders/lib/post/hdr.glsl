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
    vec3 calcHDR(vec3 color, float targetLum, float speed, int samples, float sampleRatio) {
        vec4 dataTex = imageLoad(cimage3, ivec2(0, 0));
        float previousExposure = decodeDist(dataTex.r, MAX_LIGHT);

        float measuredLum = max(previousExposure, 0.0001);

        float targetExposure = targetLum / measuredLum;

        targetExposure = clamp(targetExposure, 0.1, 4.0);

        float adaptationSpeed = speed * 0.01;
        
        if(targetExposure > previousExposure) {
            adaptationSpeed *= 1.5;
        }

        float lerpCounter = dataTex.g + frameTime * adaptationSpeed;

        float exposure = mix2(previousExposure, targetExposure, clamp(1.0 - exp(-lerpCounter), 0, 1));

        imageStore(cimage3, ivec2(0,0),vec4(encodeDist(exposure, MAX_LIGHT), clamp(lerpCounter, 0, 1), 0.0, 1.0));

        vec3 exposedColor = color * exposure;

        exposedColor = exposedColor * (1.0 + exposedColor / MAX_LIGHT) / (1.0 + exposedColor);

        return exposedColor;
    }
    
#endif