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

float getBrightness(vec2 UVs) {
    vec3 color = texture2D(colortex14, UVs).rgb;
    return dot(color, vec3(0.299, 0.587, 0.114));
}

#define BRIGHTNESS_THRESHOLD_MIN 0.45 // [0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]
#define BRIGHTNESS_THRESHOLD_MAX 0.55 // [0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]

#define GODRAY_SAMPLES 4 // [2 4 8 16 24 32 64 128]
#define GODRAY_DENSITY 0.8 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define GODRAY_DECAY 0.95 // [0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]
#define GODRAY_EXPOSURE 0.3 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

float getBrightnessMask(vec3 sunPos, vec2 UVs, sampler2D depthTex) {
    vec3 normalMap = texture2D(colortex1, UVs).xyz * 2 - 1;
    vec2 ndc = UVs * 2 - 1;
    vec3 clipSpace = normalMap;
    //vec4 viewSpace = gbufferModelView * vec4(clipSpace, 1.0);
    //viewSpace /= viewSpace.w;

    vec4 worldSpace = normalize2(vec4(clipSpace.xyz, 1.0));
    worldSpace /= worldSpace.w;

    vec4 sunWorldPos = normalize2(gbufferModelViewInverse * vec4(sunPos, 1.0));
    sunWorldPos /= sunWorldPos.w;

    float mask = (1 - dot(worldSpace, sunWorldPos)) * step(-sunWorldPos.x, worldSpace.x);

    return mask;
}

vec3 godrays(vec3 sunPos, sampler2D depthTex, vec2 UVs) {
    vec3 sunDir = normalize2(sunPos);
    vec4 sunPos2 = gbufferProjection * vec4(sunDir, 1.0);
    sunPos2 /= sunPos2.w;
    vec2 sunScreenPos = sunPos2.xy * 0.5 + 0.5;

    float depth = texture2D(depthTex, UVs).r;
    float occlusion = step(1.0, depth);

    float brightnessMask = smoothstep(BRIGHTNESS_THRESHOLD_MIN, BRIGHTNESS_THRESHOLD_MAX, getBrightness(UVs));

    vec2 delta = UVs - sunScreenPos;
    float decay = GODRAY_DECAY;
    float exposure = GODRAY_EXPOSURE;
    float density = GODRAY_DENSITY;

    vec3 lightAlbedo = vec3(VL_COLOR_R, VL_COLOR_G, VL_COLOR_B);

    vec3 color = vec3(0.0);
    vec2 sampleUV = UVs;
    for(int i = 0; i < GODRAY_SAMPLES; i++) {
        sampleUV -= delta * density / float(GODRAY_SAMPLES);
        color += step(1.0, texture2D(depthTex, sampleUV).r) * decay * lightAlbedo;
        decay *= decay;
    }
    color *= exposure;
    return color;
}