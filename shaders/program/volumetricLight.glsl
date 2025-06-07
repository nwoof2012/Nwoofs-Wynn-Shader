float calcDepth(float depth, float near, float far) {
    return (near * far) / (depth * (near - far) + far);
}

float linearDepth(float depth, float near, float far) {
    float z = depth * 2.0 - 1.0;
    return (2.0 * near * far) / (far + near - z * (far - near));
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
    float centerZ = linearDepth(texture2D(depth, UVs).r, near, far);

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

    float moonTest = dot(sunDir, viewPos.xyz);

    float moonFade = smoothstep(-0.2, 0.1, moonTest) * 0.5 + 0.5;

    if(moonFade <= 0.5) return vec3(0.0);

    for (int i = 0; i < samples; i++) {
        float t = float(i) / float(samples);
        vec2 sampleUV = UVs + dir * t * density;

        // Avoid out-of-screen samples
        //if (sampleUV.x < 0.0 || sampleUV.x > 1.0 || sampleUV.y < 0.0 || sampleUV.y > 1.0)
            //continue;

        float sampleZ = linearDepth(texture2D(depth, sampleUV).r, near, far);
        float occlusion = smoothstep(0.98, 1.0, sampleZ / centerZ);

        if(texture2D(depth, sampleUV).r != 1.0) continue;

        //result += vec3(occlusion) * currentWeight;
        result += vec3(occlusion) * currentWeight;
        float currentDecay = decay;
        currentDecay *= clamp(1.0 - length(dir),0,1), step(abs(threshold), alignment);
        currentWeight *= currentDecay;
    }
    
    float depthValue = texture2D(depth,UVs).r;
    //if(depthValue != 1.0) result *= dot(normalize2(shadowLightPosition), sunDir) * GetShadow(depthValue);

    float dhTest = texture2D(colortex5, TexCoords).g;

    float depthTest = 1 - step(1.0, depthValue);
    float isDh = 1 - step(1.0, dhTest);

    float mask = clamp(depthTest + isDh,0.0, 1.0);

    vec3 shadowLighting = max(dot(normalize2(texture2D(colortex1, TexCoords).rgb * 2 - 1), sunDir) * GetShadow(depthValue),MIN_LIGHT);

    /*if(depthValue != 1.0 || dhTest < 1.0)*/ result *= mix2(vec3(1.0), shadowLighting, mask);

    result *= exposure;

    result *= moonFade;

    /*if (alignment < threshold) {
        float sunDist = length(sunScreen - UVs);
        float distFade = smoothstep(1.0, 0.5, sunDist);
        result *= distFade;
    }*/

    return result * color;
}