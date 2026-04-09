#define AO_THRESHOLD 1.0 // [0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]
#define AO_STRENGTH 1.0 // [0.0 0.5 1.0 1.5 2.0 2.5 3.0 3.5 4.0 4.5 5.0]
#define AO_STRENGTH_PLANT 0.75 // [0.0 0.25 0.5 0.75 1.0 1.25 1.5 1.75 2.0 2.25 2.5 2.75 3.0 3.25 3.5 3.75 4.0 4.25 4.5 4.75 5.0]
#define AO_RADIUS 10 // [5 10 15 20 25]
#define AO_SAMPLES 16 // [4 9 16 25 36 49 64]
#define AO_MIN_INTENSITY 0.05 // [0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5]

#define GTAO_THRESHOLD 0.1 // [0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]
#define GTAO_STRENGTH 1.0 // [0.0 0.5 1.0 1.5 2.0 2.5 3.0 3.5 4.0 4.5 5.0]
#define GTAO_STRENGTH_PLANT 0.75 // [0.0 0.25 0.5 0.75 1.0 1.25 1.5 1.75 2.0 2.25 2.5 2.75 3.0 3.25 3.5 3.75 4.0 4.25 4.5 4.75 5.0]

#define GTAO_NUM_DIRS 4 // [2 4 8 16]
#define GTAO_NUM_STEPS 2 // [1 2 4 8]

#define GTAO_RADIUS 100.0 // [25.0 50.0 75.0 100.0]
#define GTAO_MIN_RADIUS 0.0
#define GTAO_MAX_RADIUS 100.0

#define GTAO_MIN_INTENSITY 0.05 // [0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5]

#define INV_PI sqrt(PI)
#define INV_SQRT_OF_2PI sqrt(2*PI)

const float GTAO_STEP_SCALE = 1.0;

mediump float calcLinearDepth(float depth, float near, float far) {
    mediump float z = depth * 2.0 - 1.0;
    return (2.0 * near * far) / (far + near - z * (far - near));
}

float aoHash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

vec4 smartDeNoise(sampler2D tex, vec2 uv, float sigma, float kSigma, float threshold)
{
    float radius = round(kSigma*sigma);
    float radQ = radius * radius;
    
    float invSigmaQx2 = .5 / (sigma * sigma);
    float invSigmaQx2PI = INV_PI * invSigmaQx2;
    
    float invThresholdSqx2 = .5 / (threshold * threshold);
    float invThresholdSqrt2PI = INV_SQRT_OF_2PI / threshold;
    
    vec4 centrPx = texture(tex,uv);
    
    float zBuff = 0.0;
    vec4 aBuff = vec4(0.0);
    vec2 size = vec2(textureSize(tex, 0));
    
    for(float x=-radius; x <= radius; x++) {
        float pt = sqrt(radQ-x*x);
        for(float y=-pt; y <= pt; y++) {
            vec2 d = vec2(x,y);

            float blurFactor = exp( -dot(d , d) * invSigmaQx2 ) * invSigmaQx2PI; 
            
            vec4 walkPx =  texture(tex,uv+d/size);

            vec4 dC = walkPx-centrPx;
            float deltaFactor = exp( -dot(dC, dC) * invThresholdSqx2) * invThresholdSqrt2PI * blurFactor;
                                 
            zBuff += deltaFactor;
            aBuff += deltaFactor*walkPx;
        }
    }
    return aBuff/zBuff;
}

float gaussianWeight(float dist, float sigma) {
    return exp(-(dist * dist) / (2.0 * sigma * sigma));
}

#define BLTRL_KERNEL 64
#define BLTRL_KERNEL_RADIUS int(sqrt(BLTRL_KERNEL)/2)

vec4 fastBilateral(sampler2D tex, vec2 uv, float sigma, float threshold) {
    vec4 centerColor = texture2D(tex, uv);
    float totalWeight = 0.0;
    vec4 finalColor = vec4(0.0);

    vec2 res = vec2(1080.0 / viewHeight * viewWidth, 1080.0);
    
    for(int x = -BLTRL_KERNEL_RADIUS; x < BLTRL_KERNEL_RADIUS; x++) {
        for(int y = -BLTRL_KERNEL_RADIUS; y < BLTRL_KERNEL_RADIUS; y++) {
            vec2 offset = vec2(x, y) / res;
            vec2 sampleUV = uv + offset;
            vec4 sampleColor = texture2D(tex, sampleUV);

            float spatialDistSq = float(x*x + y*y);
            float spatialWeight = gaussianWeight(sqrt(spatialDistSq),sigma);

            float intensityDiff = distance(centerColor.rgb,sampleColor.rgb);
            float rangeWeight = gaussianWeight(intensityDiff, sigma);

            float combinedWeight = spatialWeight * rangeWeight;
            totalWeight += combinedWeight;
            finalColor += sampleColor * combinedWeight;
        }
    }

    return finalColor / totalWeight;
}

float calcSSAO(vec2 UVs, vec3 footPos, int kernelSize, sampler2D depthMask, sampler2D normalMap) {
    mediump float centerDepth = calcLinearDepth(texture2D(depthMask, UVs).r, near, far);
    vec3 centerNormal = texture2D(normalMap, UVs).rgb * 2.0 - 1.0;

    vec2 res = vec2(1080.0 / viewHeight * viewWidth, 1080.0);

    int samples = AO_SAMPLES;
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

        float noise = fract(sin(dot(UVs + float(i), vec2(12.9898,78.233))) * 43758.5453);

        vec2 jitter = vec2(
            cos(noise * 6.28318),
            sin(noise * 6.28318)
        ) * 0.5;

        vec2 offset = (vec2(x,y) + jitter) * AO_RADIUS / res;

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
    return clamp(ao, AO_MIN_INTENSITY, 1.0);
}

float calcGTAO(vec2 UVs, vec3 footPos, int kernelSize, sampler2D depthMask, sampler2D normalMap) {
    mediump float centerDepth = calcLinearDepth(texture2D(depthMask, UVs).r, near, far);
    mediump float skyTest = texture2D(colortex5, UVs).g;
    if(skyTest > 0.0) return 1.0;
    vec3 centerNormal = texture2D(normalMap, UVs).xyz * 2 - 1;
    float radius = GTAO_RADIUS / (centerDepth + 0.001);
    radius = clamp(radius, GTAO_MIN_RADIUS, GTAO_MAX_RADIUS);

    vec2 screenRes = vec2(1080.0 / viewHeight * viewWidth, 1080.0);

    float ao = 0.0;

    float pixelRotation = aoHash(UVs) * 6.28318;
    for(int d = 0; d < GTAO_NUM_DIRS; d++) {
        float angle = (float(d)/float(GTAO_NUM_DIRS)) * 6.28318 + pixelRotation;
        vec2 dir = vec2(cos(angle), sin(angle));

        float horizonAngle = -1e5;

        for(int s = 1; s <= GTAO_NUM_STEPS; s++) {
            float stepDist = (float(s)/float(GTAO_NUM_STEPS)) * radius / screenRes.y;
            vec2 sampleUV = UVs + dir * stepDist;
            mediump float sampleSkyTest = texture2D(colortex5, sampleUV).g;

            float sampleDepth = calcLinearDepth(texture2D(depthMask, sampleUV).r, near, far);
            float deltaDepth = sampleDepth - centerDepth;

            vec3 sampleNormal = texture2D(normalMap, sampleUV).xyz * 2 - 1;
            float deltaNormal = dot(sampleNormal,centerNormal);

            if(abs(deltaDepth) > 5.0) continue;

            if(deltaNormal > 0.25) continue;

            float angleSample = atan(deltaDepth, stepDist);

            horizonAngle = max(horizonAngle, angleSample);
        }

        float occlusionDir = clamp(sin(horizonAngle), 0.0, 1.0);

        ao += smoothstep(GTAO_THRESHOLD, 1.0, occlusionDir);
    }

    lowp float isFoliage = 1.0 - texture2D(colortex13, UVs).b;
    lowp float isLeaves = 1.0 - texture2D(colortex12, UVs).g;
    lowp float isHand = 1.0 - texture2D(colortex12, UVs).b;
    mediump float aoStrength = mix2(AO_STRENGTH, AO_STRENGTH_PLANT, max(step(isFoliage, 0.5),step(isLeaves, 0.5))) * isHand;

    ao = 1.0 - pow2(ao / float(GTAO_NUM_DIRS), 0.5) * aoStrength;
    return clamp(ao, GTAO_MIN_INTENSITY, 1.0);
}

float calcAO(vec2 UVs, vec3 footPos, int kernelSize, sampler2D depthMask, sampler2D normalMap) {
    #if AO == 0
        return 1.0;
    #elif AO == 1
        return calcSSAO(UVs, footPos, kernelSize, depthMask, normalMap);
    #elif AO == 2
        return calcGTAO(UVs, footPos, kernelSize, depthMask, normalMap);
    #endif
}

float DHcalcSSAO(vec2 UVs, vec3 footPos, int kernelSize, sampler2D depthMask, sampler2D normalMap) {
    mediump float centerDepth = calcLinearDepth(texture2D(depthMask, UVs).b, near, far);
    vec3 centerNormal = texture2D(normalMap, UVs).rgb * 2.0 - 1.0;

    vec2 res = vec2(1080.0 / viewHeight * viewWidth, 1080.0);

    int samples = AO_SAMPLES;
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

        float noise = fract(sin(dot(UVs + float(i), vec2(12.9898,78.233))) * 43758.5453);

        vec2 jitter = vec2(
            cos(noise * 6.28318),
            sin(noise * 6.28318)
        ) * 0.5;

        vec2 offset = (vec2(x,y) + jitter) * AO_RADIUS / res;

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
    mediump float aoStrength = AO_STRENGTH;

    mediump float ao = 1.0 - pow2(depthDifference / float(total), 0.5) * aoStrength;
    return clamp(ao, AO_MIN_INTENSITY, 1.0);
}

float DHcalcAO(vec2 UVs, vec3 footPos, int kernelSize, sampler2D depthMask, sampler2D normalMap) {
    #if AO == 0
        return 1.0;
    #elif AO == 1
        return DHcalcSSAO(UVs, footPos, kernelSize, depthMask, normalMap);
    #elif AO == 2
        return DHcalcSSAO(UVs, footPos, kernelSize, depthMask, normalMap);
    #endif
}
