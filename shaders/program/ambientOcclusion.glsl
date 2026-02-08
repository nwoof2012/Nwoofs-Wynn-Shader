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

        vec2 offset = vec2(x, y) / res * sampleSize / (centerDepth * 0.125);

        mediump float offsetDepth = calcLinearDepth(texture2D(depthMask, UVs + offset).r, near, far);
        vec3 offsetNormal = texture2D(normalMap, UVs + offset).rgb * 2.0 - 1.0;

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
    float centerDepth = calcLinearDepth(texture2D(depthMask, UVs).b, near, far);
    vec3 centerNormal = texture2D(normalMap, UVs).rgb * 2.0 - 1.0;

    vec2 res = vec2(1080.0 / viewHeight * viewWidth, 1080.0);

    int samples = kernelSize;
    float sampleSize = AO_RADIUS/kernelSize;
    int N = int(floor(sqrt(float(samples))));
    N = max(N, 1);
    int total = N * N;

    float depthDifference = 0.0;

    float depthScale = mix2(0.25, 2.0, clamp(centerDepth / 64.0, 0.0, 1.0));

    for (int i = 0; i < total; i++)
    {
        int ix = i % N;
        int iy = i / N;

        float x = float(ix) - float(N - 1) * 0.5;
        float y = float(iy) - float(N - 1) * 0.5;

        vec2 offset = vec2(x, y) / res * sampleSize;

        float offsetDepth = calcLinearDepth(texture2D(depthMask, UVs + offset).b, near, far);
        vec3 offsetNormal = texture2D(normalMap, UVs + offset).rgb * 2.0 - 1.0;

        float dd = abs(centerDepth - offsetDepth) / depthScale;

        float weight = 1.0 - smoothstep(0.0, AO_THRESHOLD, dd);

        float nd = clamp(dot(centerNormal, offsetNormal), 0.0, 1.0);
        float normalFactor = 1.0 - nd;
        normalFactor *= normalFactor;
        normalFactor = mix2(0.25, 1.0, normalFactor);

        depthDifference += weight * normalFactor;
    }

    float isFoliage = 1.0 - texture2D(colortex13, UVs).b;
    float aoStrength = mix2(AO_STRENGTH, AO_STRENGTH_PLANT, step(isFoliage, 0.5));

    //if(!isBiomeEnd) aoStrength *= 0.5; else aoStrength *= 0.25;

    float ao = 1.0 - pow2(depthDifference / float(total), 0.5) * aoStrength;
    return clamp(ao, MIN_LIGHT, 1.0);
}
