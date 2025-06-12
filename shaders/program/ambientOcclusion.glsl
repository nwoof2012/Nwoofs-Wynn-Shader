#define AO_THRESHOLD 0.25 // [0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]
#define AO_STRENGTH 3.0 // [1.0 1.5 2.0 2.5 3.0 3.5 4.0 4.5 5.0]

mediump float random(in vec2 p) {
    return fract(sin(p.x*456.0+p.y*56.0)*100.0);
}

float calcLinearDepth(float depth, float near, float far) {
    float z = depth * 2.0 - 1.0;
    return (2.0 * near * far) / (far + near - z * (far - near));
}

float calcAO(vec2 UVs, vec3 footPos, int kernelSize, sampler2D depthMask, sampler2D normalMap) {
    float centerDepth = calcLinearDepth(texture2D(depthMask, UVs).r, near, far);
    float depthDifference = 0f;
    float kernel = kernelSize;
    for(int i = 0; i < kernelSize; i++) {
        float x = (i / sqrt(kernel)) - sqrt(kernel)/2; // Integer division for x
        float y = mod((i / sqrt(kernel)), sqrt(kernel)) - sqrt(kernel)/2; // Integer division for y
        vec2 offset = vec2(x,y)/1080;
        float offsetDepth = calcLinearDepth(texture2D(depthMask, UVs + offset).r, near, far);
        //float depthDist = abs(centerDepth - offsetDepth) * distance(vec3(0.0), footPos) * 50;
        if(abs(centerDepth - offsetDepth) > 1) continue;
        depthDifference += abs(centerDepth - offsetDepth);
        //depthDifference += mix2(depthDist * (1 - smoothstep(0.0, AO_THRESHOLD, depthDist)),0.0, step(offsetDepth, 0.999));
    }

    return clamp(1 - pow2((depthDifference/kernel),0.5)*AO_STRENGTH, MIN_LIGHT, 1);
}