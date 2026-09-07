#define BLOOM

#define BLOOM_QUALITY 8 // [4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64]
#define BLOOM_INTENSITY 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
#define BLOOM_THRESHOLD 0.7f // [0.0f 0.1f 0.2f 0.3f 0.4f 0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f 1.6f 1.7f 1.8f 1.9f 2.0f]

#if LIGHTING_MODE > 0
    vec2 vogelDisk(int i, int count) {
        float fi = float(i) + 0.5;
        float r = sqrt(fi / float(count));
        float a = fi * 2.39996323;
        return vec2(cos(a), sin(a)) * r;
    }

    vec3 extractBloom(vec3 color) {
        float lum = dot(color, vec3(0.2126, 0.7152, 0.0722));
        float mask = smoothstep(BLOOM_THRESHOLD, BLOOM_THRESHOLD * 1.5, lum);
        return color * mask;
    }

    vec4 getNoise(vec2 coord){
        ivec2 screenCoord = ivec2(coord * vec2(viewWidth, viewHeight)); // exact pixel coordinate onscreen
        ivec2 noiseCoord = screenCoord % 64; // wrap to range of noiseTextureResolution
        return texelFetch(noisetex, noiseCoord, 0);
    }

    float getGaussianWeight(float x, float sigma) {
        float sigma2 = sigma * sigma;
        return (1.0 / sqrt(2.0 * PI * sigma2)) * exp(-(x * x) / (2.0 * sigma2));
    }

    vec4 bloom(float waterTest, vec2 specularCoord, vec3 Normal, vec4 Albedo, vec2 refractionFactor) {
        vec2 uv = gl_FragCoord.xy/vec2(viewWidth,viewHeight) + refractionFactor;

        float depthMask = linearizeDepth(texture2D(depthtex1, uv).x, near, far) * 0.5;
        float radius = 256.0;

        vec2 resolution = vec2(1080/viewHeight * viewWidth, 1080);

        float sampleSize = radius/BLOOM_QUALITY;
        vec2 texel = sampleSize / resolution;

        vec3 baseLightColor = decodeLight(texture2D(colortex2, uv).xyz,MAX_LIGHT);

        vec3 lightColor = baseLightColor;

        float luma = luminance(baseLightColor);
        float x = max(luma - BLOOM_THRESHOLD, 0.0);
        float bloomFactor = x / (0.5 + x);

        int bloomSampleDiameter = int(sqrt(BLOOM_QUALITY));
        int bloomSampleRadius = bloomSampleDiameter/2;

        float totalWeight = 0.0;

        vec2 uvRes = uv * resolution;

        for(int i = 0; i < BLOOM_QUALITY; i++) {
            float t = (float(i) / float (BLOOM_QUALITY - 1)) * 2.0 - 1.0;

            float x = t * radius;

            float offset = x + sign(x) * 0.5;
            float weight = exp(-x * x * 0.001);

            vec2 vogel = vogelDisk(i, BLOOM_QUALITY);

            vec2 f = fract((vogel)/offset);

            vec2 s_00 = uvRes + floor(vogel/offset) * offset;
            vec2 s_10 = uvRes + vec2(ceil(vogel.x/offset), floor(vogel.y/offset)) * offset;
            vec2 s_01 = uvRes + vec2(floor(vogel.x/offset), ceil(vogel.y/offset)) * offset;
            vec2 s_11 = uvRes + ceil(vogel/offset) * offset;

            vec3 c_00 = texture2D(colortex2, s_00/resolution).xyz;
            vec3 c_10 = texture2D(colortex2, s_10/resolution).xyz;
            vec3 c_01 = texture2D(colortex2, s_01/resolution).xyz;
            vec3 c_11 = texture2D(colortex2, s_11/resolution).xyz;

            vec3 cx_0 = mix2(c_00, c_10, f.x);
            vec3 cx_1 = mix2(c_01, c_11, f.x);

            vec3 c = mix2(cx_0, cx_1, f.y);

            lightColor += c * weight;
            totalWeight += weight; 
        }

        lightColor /= BLOOM_QUALITY;

        float blurLuma = luminance(lightColor);

        float bloomMask = smoothstep(BLOOM_THRESHOLD, BLOOM_THRESHOLD * 1.5, blurLuma);

        vec3 outLight = baseLightColor + (lightColor * bloomMask * BLOOM_INTENSITY);
        float brightness = luma + blurLuma * bloomMask * BLOOM_INTENSITY;

        return vec4(outLight, brightness * 150);
    }

    vec4 bloom(sampler2D lightTex, vec2 uv) {
        vec2 resolution = vec2(1080/viewHeight * viewWidth, 1080);

        float radius = 16.0;
        vec2 texel = radius / resolution;

        vec3 baseLightColor = decodeLight(texture2D(colortex2, uv).xyz,MAX_LIGHT);

        vec3 lightColor = baseLightColor;

        float totalWeight = 0.0;

        for(int i = 0; i < BLOOM_QUALITY; i++) {
            vec2 vogel = vogelDisk(i, BLOOM_QUALITY);

            vec2 offsetPos = vogel * texel;

            float t = (float(i) / float (BLOOM_QUALITY - 1)) * 2.0 - 1.0;

            float x = t * radius;

            float weight = 1 - exp(-x * x * 0.001);

            vec3 lightSample = decodeLight(texture2D(lightTex, uv + offsetPos).xyz,MAX_LIGHT);

            lightColor += lightSample * weight;
            totalWeight += weight;
        }

        lightColor /= BLOOM_QUALITY;

        float blurLuma = luminance(lightColor);

        float bloomMask = smoothstep(BLOOM_THRESHOLD, BLOOM_THRESHOLD * 1.5, blurLuma);

        vec3 outLight = baseLightColor + (lightColor * bloomMask * BLOOM_INTENSITY);

        return vec4(outLight, 1.0);
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