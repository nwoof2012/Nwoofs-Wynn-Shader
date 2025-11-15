#define BLOOM

#define BLOOM_QUALITY 48 // [4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64]
#define BLOOM_INTENSITY 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
#define BLOOM_THRESHOLD 0.7f // [0.0f 0.1f 0.2f 0.3f 0.4f 0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f 1.6f 1.7f 1.8f 1.9f 2.0f]

vec4 bloom(float waterTest, vec2 specularCoord, vec3 Normal, vec4 Albedo) {
    mediump float radius = 2f;
    vec3 sum = vec3(0.0);
    mediump float blur = radius/viewHeight;
    mediump float hstep = 1f;
    vec2 uv = gl_FragCoord.xy / vec2(viewWidth, viewHeight);
    vec3 lightColor = texture2D(colortex2,uv).rgb * BRIGHTNESS;
    lightColor = mix2(pow2(lightColor,vec3(0.7)), lightColor * 2,1 - step(1.0, texture2D(depthtex0, uv).r));
    float illumination = texture2D(colortex2,uv).a * BRIGHTNESS;
    #ifdef VOLUMETRIC_LIGHTING
        //lightColor += volumetricLight(sunPosition, depthtex1, TexCoords, VL_SAMPLES, VL_DECAY, VL_EXPOSURE, VL_WEIGHT, VL_DENSITY, vec3(VL_COLOR_R, VL_COLOR_G, VL_COLOR_B));
        //lightColor += vec3(VL_COLOR_R, VL_COLOR_G, VL_COLOR_B) * texture2D(colortex14,uv).x;
    #endif

    #ifdef SCENE_AWARE_LIGHTING
        //sum = blurLightmap(waterTest, specularCoord, Normal, Albedo, uv);
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

    /*if(depth2 < 0.1f) {
        return vec4(vec3(0.0), 1.0);
    }*/

    //sum += mix2(vec3(0.0), lightColor3, float(depth >= 1.0));

    /*if(texture2D(colortex2, TexCoords).r < 0.85 || texture2D(colortex2, TexCoords).g < 0.85) {
        GetLightmapColor(texture2D(colortex2, TexCoords).rg);
    }*/

    /*if(abs(sum.r - sum.g) > 0.25) {
        return GetLightmapColor(texture2D(colortex2, TexCoords).rg);
    }*/

    const vec3 TorchColor = vec3(1.0f, 0.25f, 0.08f);

    mediump float depthTolerance = 0.0125;

    //mediump float camDistance = distance(vec3(0.0),viewSpaceFragPosition);

    //lightColor += gaussianBlur(colortex2, uv, radius, vec2(viewWidth, viewHeight)).xyz;

    float weight = 0.0;

    for(int i = 0; i < BLOOM_QUALITY/2; i++) {
        mediump float sampleDepth = mix2(0.0162162162,0.985135135,float(i)/(BLOOM_QUALITY/2));
        vec2 shiftedUVs = vec2(TexCoords.x - (float(i)/BLOOM_QUALITY) * radius * 4f * blur * hstep, TexCoords.y - (float(i)/BLOOM_QUALITY) * radius * 4f * blur * hstep).rg;
        vec2 specularUVs = vec2(specularCoord.x - (float(i)/BLOOM_QUALITY) * radius * 4f * blur * hstep, specularCoord.y - (float(i)/BLOOM_QUALITY) * radius * 4f * blur * hstep).rg;
        //vec3 specularMap = (texture2D(colortex10, specularUVs).rgb + texture2D(colortex11, specularUVs).rgb);
        //specularMap = pow2(specularMap, vec3(100.0));
        vec3 light = GetLightmapColor(texture2D(colortex2, shiftedUVs).rg * vec2(0.6f, 1.0f));
        lightColor3 = texture2D(colortex2,shiftedUVs).rgb * BRIGHTNESS;
        illumination += texture2D(colortex2,shiftedUVs).a * BRIGHTNESS;
        vec2 UVsOffset = vec2((float(i)/BLOOM_QUALITY) * radius * 4f * blur * hstep, (float(i)/BLOOM_QUALITY) * radius * 4f * blur * hstep).rg;
        /*#ifdef VOLUMETRIC_LIGHTING
            light += volumetricLight(sunPosition, depthtex1, shiftedUVs, VL_SAMPLES, VL_DECAY, VL_EXPOSURE, VL_WEIGHT, VL_DENSITY, vec3(VL_COLOR_R, VL_COLOR_G, VL_COLOR_B));
        #endif*/
        /*mediump float normalA = texture2D(depthtex0,shiftedUVs).r;
        mediump float normalB = texture2D(depthtex0,shiftedUVs + UVsOffset).r;
        mediump float isEntity = texture2D(colortex15,shiftedUVs).r;
        mediump float isEntity2 = texture2D(colortex15,shiftedUVs + UVsOffset).r;
        mediump float camDistance = texture2D(colortex15, shiftedUVs).g;*/
        
        /*if(abs(normalA - normalB) >= depthTolerance/camDistance) {
            continue;
        }*/
        /*if(waterTest > 0f) {
            sum += (specularMap + light) * sampleDepth;
            continue;
        }*/
        #ifdef SCENE_AWARE_LIGHTING
            light = lightColor * illumination;
            sum += lightColor * sampleDepth;
        #elif PATH_TRACING_GI == 1
            cameraRight = normalize2(cross(lightDir, vec3(0.0, 1.0, 0.0)));
            cameraUp = cross(cameraRight, lightDir);
            rayDir = normalize2(lightDir + shiftedUVs.x * cameraRight + shiftedUVs.y * cameraUp);
            Ray ray = Ray(viewSpaceFragPosition + vec3(shiftedUVs, 0.0), rayDir);
            vec3 rayColor2 = traceRay(ray,vec2(length(lightmap),1f), Normal,Albedo.a)/vec3(2) * sampleDepth;
            
            /*if(dot((sum + rayColor) * vec3(10.5025),vec3(0.333f)) < BLOOM_THRESHOLD) {
                continue;
            }*/

            sum += rayColor2;
            if(texture2D(colortex2, shiftedUVs).r > 0.0f) {
                sum += vec3(0.6f) * (texture2D(colortex2, shiftedUVs).r);
            }
        #else
            vec3 lightColor2 = vec3(0.6f) * (texture2D(colortex2, shiftedUVs).r);
            /*if(dot((sum + lightColor) * vec3(1.5025),vec3(0.333f)) < BLOOM_THRESHOLD) {
                continue;
            }*/
            if(texture2D(colortex2, shiftedUVs).r > 0.0f) {
                sum += lightColor2;
            }
            lightColor2 = light * sampleDepth;
            /*if(dot((sum + lightColor) * vec3(1.5025),vec3(0.333f)) < BLOOM_THRESHOLD) {
                continue;
            }*/
            sum += lightColor2;
        #endif

        depth = texture2D(depthtex0, shiftedUVs).r;

        weight += length(UVsOffset);

        //sum += mix2(vec3(0.0), lightColor3, float(depth >= 1.0));
    }

    for(int i = 0; i < BLOOM_QUALITY/2; i++) {
        mediump float sampleDepth = mix2(0.0162162162,0.985135135,float(i)/(BLOOM_QUALITY/2));
        vec2 shiftedUVs = vec2(TexCoords.x + (float(i)/BLOOM_QUALITY) * radius * 4f * blur * hstep, TexCoords.y + (float(i)/BLOOM_QUALITY) * radius * 4f * blur * hstep).rg;
        vec2 specularUVs = vec2(specularCoord.x - (float(i)/BLOOM_QUALITY) * radius * 4f * blur * hstep, specularCoord.y - (float(i)/BLOOM_QUALITY) * radius * 4f * blur * hstep).rg;
        //vec3 specularMap = (texture2D(colortex10, specularUVs).rgb + texture2D(colortex11, specularUVs).rgb);
        //specularMap = pow2(specularMap, vec3(100.0));
        vec3 light = GetLightmapColor(texture2D(colortex2, shiftedUVs).rg * vec2(0.6f, 1.0f));
        lightColor3 = texture2D(colortex2,shiftedUVs).rgb * BRIGHTNESS;
        illumination += texture2D(colortex2,shiftedUVs).a * BRIGHTNESS;
        vec2 UVsOffset = -vec2((float(i)/BLOOM_QUALITY) * radius * 4f * blur * hstep, (float(i)/BLOOM_QUALITY) * radius * 4f * blur * hstep).rg;
        /*#ifdef VOLUMETRIC_LIGHTING
            light += volumetricLight(sunPosition, depthtex1, shiftedUVs, VL_SAMPLES, VL_DECAY, VL_EXPOSURE, VL_WEIGHT, VL_DENSITY, vec3(VL_COLOR_R, VL_COLOR_G, VL_COLOR_B));
        #endif*/
        /*mediump float normalA = texture2D(depthtex0,shiftedUVs).r;
        mediump float normalB = texture2D(depthtex0,shiftedUVs + UVsOffset).r;
        mediump float isEntity = texture2D(colortex15,shiftedUVs).r;
        mediump float isEntity2 = texture2D(colortex15,shiftedUVs + UVsOffset).r;
        mediump float camDistance = texture2D(colortex15, shiftedUVs).g;*/

        /*if(abs(normalA - normalB) >= depthTolerance/camDistance) {
            continue;
        }*/
        /*if(waterTest > 0f) {
            sum += (specularMap + light) * sampleDepth;
            continue;
        }*/
        #ifdef SCENE_AWARE_LIGHTING
            light = lightColor * illumination;
            sum += lightColor * sampleDepth;
        #elif PATH_TRACING_GI == 1
            cameraRight = normalize2(cross(lightDir, vec3(0.0, 1.0, 0.0)));
            cameraUp = cross(cameraRight, lightDir);
            rayDir = normalize2(lightDir + shiftedUVs.x * cameraRight + shiftedUVs.y * cameraUp);
            Ray ray = Ray(viewSpaceFragPosition + vec3(shiftedUVs, 0.0), rayDir);
            vec3 rayColor2 = traceRay(ray,vec2(length(lightmap),1f), Normal,Albedo.a)/vec3(2) * sampleDepth;
            
            /*if(dot((sum + rayColor) * vec3(10.5025),vec3(0.333f)) < BLOOM_THRESHOLD) {
                continue;
            }*/

            sum += rayColor2;
            if(texture2D(colortex2, shiftedUVs).r > 0.0f) {
                sum += vec3(0.6f) * (texture2D(colortex2, shiftedUVs).r) * mix2(vec3(1.0), TorchColor,0.4f);
            }
        #else
            vec3 lightColor2 = vec3(0.6f) * (texture2D(colortex2, shiftedUVs).r) * mix2(vec3(1.0), TorchColor,0.4f);
            /*if(dot((sum + lightColor) * vec3(1.5025),vec3(0.333f)) < BLOOM_THRESHOLD) {
                continue;
            }*/
            if(texture2D(colortex2, shiftedUVs).r > 0.0f) {
                sum += lightColor2;
            }
            lightColor2 = light * sampleDepth;
            /*if(dot((sum + lightColor) * vec3(1.5025),vec3(0.333f)) < BLOOM_THRESHOLD) {
                continue;
            }*/
            sum += lightColor2;
        #endif

        depth = texture2D(depthtex0, shiftedUVs).r;

        //sum += mix2(vec3(0.0), lightColor3, float(depth >= 1.0));

        weight += length(UVsOffset);
    }

    sum /= weight;

    /*sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x - 8.0 * blur * hstep, TexCoords.y - 8.0 * blur * hstep)).rg) * 0.0162162162;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x - 7.0 * blur * hstep, TexCoords.y - 7.0 * blur * hstep)).rg) * 0.0540540541;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x - 6.0 * blur * hstep, TexCoords.y - 6.0 * blur * hstep)).rg) * 0.1216216216;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x - 5.0 * blur * hstep, TexCoords.y - 5.0 * blur * hstep)).rg) * 0.1945945946;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x - 4.0 * blur * hstep, TexCoords.y - 4.0 * blur * hstep)).rg) * 0.389189189;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x - 3.0 * blur * hstep, TexCoords.y - 3.0 * blur * hstep)).rg) * 0.583783784;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x - 2.0 * blur * hstep, TexCoords.y - 2.0 * blur * hstep)).rg) * 0.875675676;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x - 1.0 * blur * hstep, TexCoords.y - 1.0 * blur * hstep)).rg) * 0.985135135;

    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x + 8.0 * blur * hstep, TexCoords.y + 8.0 * blur * hstep)).rg) * 0.0162162162;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x + 7.0 * blur * hstep, TexCoords.y + 7.0 * blur * hstep)).rg) * 0.0540540541;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x + 6.0 * blur * hstep, TexCoords.y + 6.0 * blur * hstep)).rg) * 0.1216216216;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x + 5.0 * blur * hstep, TexCoords.y + 5.0 * blur * hstep)).rg) * 0.1945945946;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x + 4.0 * blur * hstep, TexCoords.y + 1.0 * blur * hstep)).rg) * 0.389189189;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x + 3.0 * blur * hstep, TexCoords.y + 2.0 * blur * hstep)).rg) * 0.583783784;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x + 2.0 * blur * hstep, TexCoords.y + 3.0 * blur * hstep)).rg) * 0.875675676;
    sum += GetLightmapColor(texture2D(colortex2, vec2(TexCoords.x + 1.0 * blur * hstep, TexCoords.y + 4.0 * blur * hstep)).rg) * 0.985135135;*/

    /*if(dot(sum, vec3(0.333)) > 2) {
        sum *= mix2(vec3(2),vec3(0.5),clamp(dot(sum, vec3(0.333)),0,1.2));
    }*/

    //sum = mix2(vec3(0.0), sum, 1 - step(1 - length(lightColor),0.1));

    mediump float bloomLerp = 1.0f;
    #if BLOOM_INTENSITY + 0.5 > 0.0
        //bloomLerp = clamp(length((sum * vec3(0.0625))/(BLOOM_THRESHOLD - 0.25)),0,1);
        bloomLerp = 1 - smoothstep(BLOOM_THRESHOLD, 1, 1 - length(sum));
    #endif

    /*if(bloomLerp - 0.25 > 1.0f) {
        bloomLerp -= 1.0f;
    } else {
        bloomLerp = 0;
    }*/

    //bloomLerp = clamp01(bloomLerp);

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

    return vec4(pow2(sum,vec3(GAMMA)), illumination);
}