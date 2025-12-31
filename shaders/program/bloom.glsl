#define BLOOM

#define BLOOM_QUALITY 32 // [4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64]
#define BLOOM_INTENSITY 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
#define BLOOM_THRESHOLD 0.7f // [0.0f 0.1f 0.2f 0.3f 0.4f 0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f 1.6f 1.7f 1.8f 1.9f 2.0f]

vec4 bloom(float waterTest, vec2 specularCoord, vec3 Normal, vec4 Albedo) {
    mediump float radius = 2f;
    vec3 sum = vec3(0.0);
    mediump float blur = radius/viewHeight;
    mediump float hstep = 1f;
    vec2 uv = gl_FragCoord.xy / vec2(viewWidth, viewHeight);
    vec3 lightColor = textureLod(colortex2,uv, 6).rgb * BRIGHTNESS;
    lightColor = mix2(pow2(lightColor,vec3(0.7)), lightColor * 2,1 - step(1.0, texture2D(depthtex0, uv).r));
    float illumination = clamp(texture2D(colortex2,uv).a * BRIGHTNESS, 0.0, MAX_LIGHT * 0.5);
    //return vec4(pow2(max(lightColor,vec3(MIN_LIGHT)),vec3(GAMMA)), illumination);

    #ifdef SCENE_AWARE_LIGHTING
        sum += lightColor;
    #elif PATH_TRACING_GI == 1
        vec3 lightDir = normalize2(sunPosition);
        vec3 cameraRight = normalize2(cross(lightDir, vec3(0.0, 1.0, 0.0)));
        vec3 cameraUp = cross(cameraRight, lightDir);
        vec3 rayDir = normalize2(lightDir + uv.x * cameraRight + uv.y * cameraUp);
        Ray ray = Ray(viewSpaceFragPosition, rayDir);
        vec3 rayColor = traceRay(ray,vec2(length(lightmap),1f), Normal,Albedo.a)/vec3(2);

        sum += rayColor;
    #else
        sum += lightColor;
    #endif

    vec3 lightColor3 = texture2D(colortex2, uv).rgb;

    float depth = texture2D(depthtex0, uv).r;
    float depth2 = texture2D(depthtex1, uv).r;

    const vec3 TorchColor = vec3(1.0f, 0.25f, 0.08f);

    mediump float depthTolerance = 0.0125;

    float weight = 0.0;

    for(int i = -BLOOM_QUALITY/2; i < BLOOM_QUALITY/2; i++) {
        mediump float sampleDepth = mix2(0.0162162162,0.985135135,abs(float(i)/(BLOOM_QUALITY/2)));
        vec2 shiftedUVs = vec2(TexCoords.x + (float(i)/BLOOM_QUALITY) * radius * 4f * blur * hstep, TexCoords.y + (float(i)/BLOOM_QUALITY) * radius * 4f * blur * hstep).rg;
        vec2 specularUVs = vec2(specularCoord.x + (float(i)/BLOOM_QUALITY) * radius * 4f * blur * hstep, specularCoord.y + (float(i)/BLOOM_QUALITY) * radius * 4f * blur * hstep).rg;
        vec3 light = GetLightmapColor(texture2D(colortex2, shiftedUVs).rg * vec2(0.6f, 1.0f));
        lightColor3 = textureLod(colortex2,uv, 6).rgb * BRIGHTNESS;
        illumination += clamp(texture2D(colortex2,shiftedUVs).a * BRIGHTNESS, 0.0, MAX_LIGHT * 0.5);
        vec2 UVsOffset = vec2((float(i)/BLOOM_QUALITY) * radius * 4f * blur * hstep, (float(i)/BLOOM_QUALITY) * radius * 4f * blur * hstep).rg;
        float sampleWeight = 1 - length(UVsOffset)/blur;
        #ifdef SCENE_AWARE_LIGHTING
            light = lightColor3 * illumination;
            sum += lightColor3 * sampleWeight;
        #elif PATH_TRACING_GI == 1
            cameraRight = normalize2(cross(lightDir, vec3(0.0, 1.0, 0.0)));
            cameraUp = cross(cameraRight, lightDir);
            rayDir = normalize2(lightDir + shiftedUVs.x * cameraRight + shiftedUVs.y * cameraUp);
            Ray ray = Ray(viewSpaceFragPosition + vec3(shiftedUVs, 0.0), rayDir);
            vec3 rayColor2 = traceRay(ray,vec2(length(lightmap),1f), Normal,Albedo.a)/vec3(2) * sampleDepth;

            sum += rayColor2;
            if(texture2D(colortex2, shiftedUVs).r > 0.0f) {
                sum += vec3(0.6f) * (texture2D(colortex2, shiftedUVs).r);
            }
        #else
            vec3 lightColor2 = vec3(0.6f) * (texture2D(colortex2, shiftedUVs).r);
            if(texture2D(colortex2, shiftedUVs).r > 0.0f) {
                sum += lightColor2;
            }
            lightColor2 = light * sampleDepth;

            sum += lightColor2;
        #endif

        depth = texture2D(depthtex0, shiftedUVs).r;

        weight += sampleWeight;
    }

    sum /= weight;

    mediump float bloomLerp = 1.0f;
    #if BLOOM_INTENSITY + 0.5 > 0.0
        bloomLerp = 1 - smoothstep(BLOOM_THRESHOLD, 1, 1 - length(sum));
    #endif

    bloomLerp = smoothstep(0.0,BLOOM_THRESHOLD, length(sum));

    sum *= 0.5f;

    #ifdef SCENE_AWARE_LIGHTING
        sum = mix2(sum,lightColor,bloomLerp);
    #elif PATH_TRACING_GI == 1
        sum = mix2(rayColor,sum,bloomLerp);
    #else
        sum = mix2(lightColor,sum,bloomLerp);
    #endif

    if(depth == 1.0) {
        illumination *= clamp(normalize2(mat3(gbufferModelViewInverse) * sunPosition).z,0,2) * 0.5;
    }

    sum *= BLOOM_INTENSITY + 0.5;

    if(!isBiomeEnd) sum *= 1.2;

    return vec4(pow2(max(sum,vec3(MIN_LIGHT)),vec3(GAMMA)), illumination);
}