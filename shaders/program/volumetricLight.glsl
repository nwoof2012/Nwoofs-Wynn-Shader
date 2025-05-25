float calcDepth(float depth, float near, float far) {
    return (near * far) / (depth * (near - far) + far);
}

vec3 volumetricLight(vec3 sunPos, sampler2D depth, vec2 UVs, int samples, float decay, float exposure, float weight, float density, vec3 color) {
    vec3 sunDir = normalize2(sunPos); // Sun in view space

    // Project to screen space
    vec4 sunClip = gbufferProjection * vec4(sunDir * 1000.0, 1.0);
    vec2 sunScreen = sunClip.xy / sunClip.w * 0.5 + 0.5;

    // Early out if sun is outside screen
    /*if (sunScreen.x < 0.0 || sunScreen.x > 1.0 || sunScreen.y < 0.0 || sunScreen.y > 1.0)
        return vec3(0.0);*/

    // Compute direction from current UV to sun on screen
    vec2 dir = sunScreen - UVs;
    dir.x *= aspectRatio;

    vec3 result = vec3(0.0);
    float currentWeight = weight;

    // Linearize the depth of current pixel once
    float centerZ = calcDepth(texture2D(depth, UVs).r, near, far);

    vec2 fragCoord = gl_FragCoord.xy/vec2(viewWidth, viewHeight);
    vec2 fragNDC = fragCoord * 2.0 - 1.0;
    vec4 fragView = gbufferProjectionInverse * vec4(fragNDC, texture2D(depth, UVs).r, 1.0);
    fragView.xyz /= fragView.w;

    // Visibility test
    vec3 fragDir = normalize2(fragView.xyz); // from earlier
    float alignment = dot(fragDir, sunDir);
    float threshold = cos(FoV.y); // or 60–90 depending on desired FOV cutoff

    vec4 screenPos = vec4(gl_FragCoord.xy / vec2(viewWidth, viewHeight), gl_FragCoord.z, 1.0);
    vec4 viewPos = gbufferProjectionInverse * (screenPos * 2.0 - 1.0);

    float moonTest = 1 - dot(sunDir, viewPos.xyz);

    if(moonTest > 0.99) return vec3(0.0);

    for (int i = 0; i < samples; i++) {
        float t = float(i) / float(samples);
        vec2 sampleUV = UVs + dir * t * density;

        // Avoid out-of-screen samples
        //if (sampleUV.x < 0.0 || sampleUV.x > 1.0 || sampleUV.y < 0.0 || sampleUV.y > 1.0)
            //continue;

        float sampleZ = calcDepth(texture2D(depth, sampleUV).r, near, far);
        float occlusion = smoothstep(0.98, 1.0, sampleZ / centerZ);

        if(texture2D(depth, sampleUV).r != 1.0) continue;

        //result += vec3(occlusion) * currentWeight;
        result += vec3(occlusion) * currentWeight;
        float currentDecay = decay;
        currentDecay *= clamp(1.0 - length(dir),0,1), step(abs(threshold), alignment);
        currentWeight *= currentDecay;
    }
    
    float depthValue = texture2D(depth,UVs).r;
    if(depthValue != 1.0) result *= dot(normalize2(shadowLightPosition), sunDir) * GetShadow(depthValue);

    result *= exposure;

    /*if (alignment < threshold) {
        float sunDist = length(sunScreen - UVs);
        float distFade = smoothstep(1.0, 0.5, sunDist);
        result *= distFade;
    }*/

    return result * color;
}