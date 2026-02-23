#define AO_THRESHOLD 1.0 // [0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]
#define AO_STRENGTH 1.0 // [0.0 0.5 1.0 1.5 2.0 2.5 3.0 3.5 4.0 4.5 5.0]
#define AO_STRENGTH_PLANT 0.75 // [0.0 0.25 0.5 0.75 1.0 1.25 1.5 1.75 2.0 2.25 2.5 2.75 3.0 3.25 3.5 3.75 4.0 4.25 4.5 4.75 5.0]
#define AO_RADIUS 100 // [25 50 75 100 125 150 175 200]

mediump float random(in vec2 p) {
    return fract(sin(p.x*456.0+p.y*56.0)*100.0);
}

mediump float calcLinearDepth(float depth, float near, float far) {
    mediump float z = depth * 2.0 - 1.0;
    return (2.0 * near * far) / (far + near - z * (far - near));
}

float calcAO(vec2 UVs, vec3 footPos, int kernelSize, sampler2D depthMask, sampler2D normalMap) {
    mediump float centerDepth = calcLinearDepth(texture2D(depthMask, UVs).r, near, far);
    vec3 centerNormal = texture2D(normalMap, UVs).rgb * 2.0 - 1.0;

    vec2 res = vec2(1080.0 / viewHeight * viewWidth, 1080.0);

    int samples = kernelSize;
    mediump float sampleSize = AO_RADIUS/kernelSize;
    int N = int(floor(sqrt(float(samples))));
    N = max(N, 1);
    int total = N * N;

    mediump float depthDifference = 0.0;

    mediump float depthScale = mix2(0.25, 2.0, clamp(centerDepth / 64.0, 0.0, 1.0));

    for (int i = 0; i < total; i++)
    {
        int ix = i % N;
        int iy = i / N;

        mediump float x = float(ix) - float(N - 1) * 0.5;
        mediump float y = float(iy) - float(N - 1) * 0.5;

        vec2 offset = vec2(x, y) / res * sampleSize / ((centerDepth + 2.0) * 0.125);

        vec2 UVs2 = (UVs + offset) * res;

        vec2 f = fract(UVs2);

        vec2 i0 = vec2(floor(UVs2))/res;
        vec2 i1 = vec2(ceil(UVs2))/res;
        vec2 i10 = vec2(ceil(UVs2.x), floor(UVs2.y))/res;
        vec2 i01 = vec2(floor(UVs2.x), ceil(UVs2.y))/res;

        float c00_D = texture2D(depthMask, i0).r;
        float c10_D = texture2D(depthMask, i10).r;
        float c01_D = texture2D(depthMask, i01).r;
        float c11_D = texture2D(depthMask, i1).r;
        
        float cx0_D = mix2(c00_D, c10_D, f.x);
        float cx1_D = mix2(c10_D, c11_D, f.x);

        mediump float offsetDepth = calcLinearDepth(mix2(cx0_D, cx1_D, f.y), near, far);

        vec3 c00_N = texture2D(normalMap, i0).rgb * 2.0 - 1.0;
        vec3 c10_N = texture2D(normalMap, i10).rgb * 2.0 - 1.0;
        vec3 c01_N = texture2D(normalMap, i01).rgb * 2.0 - 1.0;
        vec3 c11_N = texture2D(normalMap, i1).rgb * 2.0 - 1.0;
        
        vec3 cx0_N = mix2(c00_N, c10_N, f.x);
        vec3 cx1_N = mix2(c10_N, c11_N, f.x);
        vec3 offsetNormal = mix2(cx0_N, cx1_N, f.y);

        mediump float dd = abs(centerDepth - offsetDepth) / depthScale;

        if(dd > 5.0) continue;

        mediump float weight = 1.0 - smoothstep(AO_THRESHOLD, 1.0, dd);

        mediump float nd = clamp(dot(centerNormal, offsetNormal), 0.0, 1.0);
        mediump float normalFactor = 1.0 - nd;
        normalFactor *= normalFactor;
        normalFactor = mix2(0.25, 1.0, normalFactor);

        depthDifference += weight * normalFactor;
    }

    lowp float isFoliage = 1.0 - texture2D(colortex13, UVs).b;
    lowp float isLeaves = 1.0 - texture2D(colortex12, UVs).g;
    lowp float isHand = 1.0 - texture2D(colortex12, UVs).b;
    mediump float aoStrength = mix2(AO_STRENGTH, AO_STRENGTH_PLANT, max(step(isFoliage, 0.5),step(isLeaves, 0.5))) * isHand;

    mediump float ao = 1.0 - pow2(depthDifference / float(total), 0.5) * aoStrength;
    return clamp(ao, MIN_LIGHT, 1.0);
}

float DHcalcAO(vec2 UVs, vec3 footPos, int kernelSize, sampler2D depthMask, sampler2D normalMap) {
    mediump float centerDepth = calcLinearDepth(texture2D(depthMask, UVs).b, near, far);
    vec3 centerNormal = texture2D(normalMap, UVs).rgb * 2.0 - 1.0;

    vec2 res = vec2(1080.0 / viewHeight * viewWidth, 1080.0);

    int samples = kernelSize;
    mediump float sampleSize = AO_RADIUS/kernelSize;
    int N = int(floor(sqrt(float(samples))));
    N = max(N, 1);
    int total = N * N;

    mediump float depthDifference = 0.0;

    mediump float depthScale = mix2(0.25, 2.0, clamp(centerDepth / 64.0, 0.0, 1.0));

    for (int i = 0; i < total; i++)
    {
        int ix = i % N;
        int iy = i / N;

        mediump float x = float(ix) - float(N - 1) * 0.5;
        mediump float y = float(iy) - float(N - 1) * 0.5;

        vec2 offset = vec2(x, y) / res * sampleSize / ((centerDepth + 2.0) * 0.125);

        vec2 UVs2 = (UVs + offset) * res;

        vec2 f = fract(UVs2);

        vec2 i0 = vec2(floor(UVs2))/res;
        vec2 i1 = vec2(ceil(UVs2))/res;
        vec2 i10 = vec2(ceil(UVs2.x), floor(UVs2.y))/res;
        vec2 i01 = vec2(floor(UVs2.x), ceil(UVs2.y))/res;

        float c00_D = texture2D(depthMask, i0).b;
        float c10_D = texture2D(depthMask, i10).b;
        float c01_D = texture2D(depthMask, i01).b;
        float c11_D = texture2D(depthMask, i1).b;
        
        float cx0_D = mix2(c00_D, c10_D, f.x);
        float cx1_D = mix2(c10_D, c11_D, f.x);

        mediump float offsetDepth = calcLinearDepth(mix2(cx0_D, cx1_D, f.y), near, far);

        vec3 c00_N = texture2D(normalMap, i0).rgb * 2.0 - 1.0;
        vec3 c10_N = texture2D(normalMap, i10).rgb * 2.0 - 1.0;
        vec3 c01_N = texture2D(normalMap, i01).rgb * 2.0 - 1.0;
        vec3 c11_N = texture2D(normalMap, i1).rgb * 2.0 - 1.0;
        
        vec3 cx0_N = mix2(c00_N, c10_N, f.x);
        vec3 cx1_N = mix2(c10_N, c11_N, f.x);
        vec3 offsetNormal = mix2(cx0_N, cx1_N, f.y);

        mediump float dd = abs(centerDepth - offsetDepth) / depthScale;

        if(dd > 5.0) continue;

        mediump float weight = 1.0 - smoothstep(AO_THRESHOLD, 1.0, dd);

        mediump float nd = clamp(dot(centerNormal, offsetNormal), 0.0, 1.0);
        mediump float normalFactor = 1.0 - nd;
        normalFactor *= normalFactor;
        normalFactor = mix2(0.25, 1.0, normalFactor);

        depthDifference += weight * normalFactor;
    }

    lowp float isFoliage = 1.0 - texture2D(colortex13, UVs).b;
    lowp float isLeaves = 1.0 - texture2D(colortex12, UVs).g;
    lowp float isHand = 1.0 - texture2D(colortex12, UVs).b;
    mediump float aoStrength = AO_STRENGTH;

    mediump float ao = 1.0 - pow2(depthDifference / float(total), 0.5) * aoStrength;
    return clamp(ao, MIN_LIGHT, 1.0);
}
