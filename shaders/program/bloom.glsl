#define BLOOM

#define BLOOM_QUALITY 16 // [4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64]
#define BLOOM_INTENSITY 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
#define BLOOM_THRESHOLD 0.7f // [0.0f 0.1f 0.2f 0.3f 0.4f 0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f 1.6f 1.7f 1.8f 1.9f 2.0f]

#if LIGHTING_MODE > 0
    vec4 bloom(float waterTest, vec2 specularCoord, vec3 Normal, vec4 Albedo, vec2 refractionFactor) {
        mediump float radius = 2f;
        mediump vec2 blur = vec2(radius)/vec2(1080/viewHeight * viewWidth, 1080);

        mediump vec2 sampleSize = blur/vec2(BLOOM_QUALITY);

        vec2 uv = gl_FragCoord.xy/vec2(viewWidth,viewHeight);

        vec3 sum = vec3(0.0);
        
        vec3 baseLight = texture2D(colortex2,uv).rgb;

        float totalWeight = 0.0;
        
        int bloomSampleDiameter = int(sqrt(BLOOM_QUALITY));
        int bloomSampleRadius = bloomSampleDiameter/2;
        for(int i = 0; i < BLOOM_QUALITY; i++) {
            int x = i/bloomSampleDiameter - bloomSampleRadius;
            int y = int(mod(i, BLOOM_QUALITY)) - bloomSampleRadius;
            
            vec2 offset = vec2(x, y) * sampleSize;

            float weight = length(offset/blur);

            if(weight > 1.0) continue;

            sum += texture2D(colortex2, uv + offset).rgb;
            totalWeight += weight;
        }

        sum /= totalWeight;

        vec3 outLight = sum;

        mediump float bloomLerp = smoothstep(0.0,BLOOM_THRESHOLD, length(outLight));

        outLight = mix2(baseLight, outLight*BLOOM_INTENSITY, bloomLerp);

        float brightness = mix2(length(baseLight), length(outLight)*BLOOM_INTENSITY,bloomLerp);

        return vec4(outLight,brightness*15);
    }
#elif LIGHTING_MODE == 0
    vec3 getLightColor(vec3 lightmap) {
        const vec3 TorchColor = vec3(1.0f, 0.25f, 0.08f);
        vec3 SkyColor = vec3(0.05f, 0.15f, 0.3f);
        return TorchColor * lightmap.x + SkyColor * lightmap.y;
    }
    vec4 bloom(float waterTest, vec2 specularCoord, vec3 Normal, vec4 Albedo) {
        vec2 uv = gl_FragCoord.xy / vec2(viewWidth, viewHeight);
        mediump float radius = 2f;
        vec3 sum = vec3(0.0);
        mediump float blur = radius/viewHeight;
        mediump float hstep = 1f;
        sum += getLightColor(texture2D(colortex2, uv).rgb);

        float weightAccum = 0.0;

        for(int i = -BLOOM_QUALITY/2; i < BLOOM_QUALITY/2; i++) {
            vec2 shiftedUVs = vec2(TexCoords.x + (float(i)/BLOOM_QUALITY) * radius * 4f * blur * hstep, TexCoords.y + (float(i)/BLOOM_QUALITY) * radius * 4f * blur * hstep).rg;
            float weight = 1 - length(shiftedUVs - uv)/blur;
            sum += getLightColor(texture2D(colortex2, shiftedUVs).rgb) * weight;
            weightAccum += weight;
        }
        return vec4(sum/weightAccum * 5,1.0);
    }
#endif