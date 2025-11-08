#ifdef AUTO_EXPOSURE
    vec3 calcHDR(vec3 color, float targetLum, float speed, int samples, float sampleRatio) {
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