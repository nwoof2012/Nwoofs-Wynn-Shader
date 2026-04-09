#define CLOUD_STEPS 8
#define STEP_SIZE 40.0
#define CLOUD_BASE 120.0
#define CLOUD_TOP 400.0
#define CLOUD_THICKNESS 45.0
#define CLOUD_THICKNESS_SAMPLES 1

#define CLOUD_RES 360.0

#define CLOUD_STEPS_BKG 3
#define CLOUD_BASE_BKG 520.0
#define CLOUD_TOP_BKG 700.0

vec4 lightCalc;

vec3 getNormalFrom2DMap(vec2 uv, float scale) {
    float eps = 1.0 / textureSize(cloudtex, 0).x; // one texel

    float hL = texture(cloudtex, uv - vec2(eps, 0.0)).r;
    float hR = texture(cloudtex, uv + vec2(eps, 0.0)).r;
    float hD = texture(cloudtex, uv - vec2(0.0, eps)).r;
    float hU = texture(cloudtex, uv + vec2(0.0, eps)).r;

    vec3 n = normalize(vec3(hL - hR, hD - hU, scale));
    return n;
}

vec3 getNormalFrom2DMap(float hL, float hR, float hD, float hU, float scale) {
    float eps = 1.0 / textureSize(cloudtex, 0).x; // one texel

    vec3 n = normalize(vec3(hL - hR, hD - hU, scale));
    return n;
}

vec3 getNormalFromDepth(vec2 uv, float depth) {
    float depthC = texture2D(depthtex1, uv).r;
    float depthR = texture2D(depthtex1, uv + vec2(1.0/viewWidth, 0)).r;
    float depthU = texture2D(depthtex1, uv + vec2(0, 1.0/viewHeight)).r;

    vec3 pC = vec3(uv, depthC);
    vec3 pR = vec3(uv + vec2(1.0/viewWidth, 0), depthR);
    vec3 pU = vec3(uv + vec2(0, 1.0/viewHeight), depthU);

    vec3 dx = pR - pC;
    vec3 dy = pU - pC;
    return normalize2(cross(dx, dy));
}

float calcDensity(vec3 pos) {
    float layer = clamp(pos.y / STEP_SIZE, 0.0, CLOUD_STEPS - 1.0);
    float layerFrac = fract(layer);
    float layerBase = floor(layer);
    float layerNext = min(layerBase + 1.0, CLOUD_STEPS - 1.0);

    // sample both slices (bilinear interpolation between slices)
    vec2 uvBase = pos.xz * 0.001; // adjust scale
    float d0 = texture(cloudtex, uvBase + vec2(0.0, layerBase * 0.1)).r;
    float d1 = texture(cloudtex, uvBase + vec2(0.0, layerNext * 0.1)).r;

    return mix2(d0, d1, layerFrac);
}

float cloudBilinear(vec3 pos, vec3 offset) {
    vec2 o00 = floor(offset.xz * CLOUD_RES)/CLOUD_RES;
    vec2 o10 = vec2(ceil(offset.x * CLOUD_RES),floor(offset.z * CLOUD_RES))/CLOUD_RES;
    vec2 o01 = vec2(floor(offset.x * CLOUD_RES),ceil(offset.z * CLOUD_RES))/CLOUD_RES;
    vec2 o11 = ceil(offset.xz * CLOUD_RES)/CLOUD_RES;

    vec2 f = fract(offset.xz);

    vec2 i00 = pos.xz + o00;
    vec2 i10 = pos.xz + o10;
    vec2 i01 = pos.xz + o01;
    vec2 i11 = pos.xz + o11;

    vec3 i00_3 = vec3(i00.x, pos.y, i00.y);
    vec3 i10_3 = vec3(i10.x, pos.y, i10.y);
    vec3 i01_3 = vec3(i01.x, pos.y, i01.y);
    vec3 i11_3 = vec3(i11.x, pos.y, i11.y);

    float c00 =  calcDensity(i00_3);
    float c10 = calcDensity(i10_3);
    float c01 = calcDensity(i01_3);
    float c11 = calcDensity(i11_3);

    float cx0 = mix2(c00, c10, f.x);
    float cx1 = mix2(c01, c11, f.x);

    return mix2(cx0, cx1, f.y);
}

vec3 calcCloudNormals(vec3 pos) {
    float eps = STEP_SIZE;
    float dx = calcDensity(pos + vec3(eps, 0.0, 0.0)) - calcDensity(pos - vec3(eps, 0.0, 0.0));
    float dy = calcDensity(pos + vec3(0.0, eps, 0.0)) - calcDensity(pos - vec3(0.0, eps, 0.0));
    float dz = calcDensity(pos + vec3(0.0, 0.0, eps)) - calcDensity(pos - vec3(0.0, 0.0, eps));
    vec3 n = normalize2(vec3(dx, dy, dz));
    return n;
}

vec3 depthNormals(float c, float l, float r) {
    return normalize2(vec3((c - l),c,(c - r)));
}

float calcThickness(sampler2D tex, vec2 uv, vec2 pos, float thickness, int samples) {
    float baseSample = texture2D(tex, uv).r;

    float outSample = baseSample;

    for(int i = 1; i < CLOUD_THICKNESS_SAMPLES + 1; i++) {
        vec2 sampleUV = uv + vec2(0.0, thickness/CLOUD_THICKNESS_SAMPLES * i * min(distance(vec2(0.0), pos)/1000,1.0));
        float thickSample = texture2D(tex, sampleUV).r;

        outSample = max(outSample, thickSample);
    }

    return outSample;
}

vec3 getCloudNormal(vec3 pos) {
    float e = 0.5;
    float dx = calcDensity(pos + vec3(e,0,0)) - calcDensity(pos - vec3(e,0,0));
    float dy = calcDensity(pos + vec3(0,e,0)) - calcDensity(pos - vec3(0,e,0));
    float dz = calcDensity(pos + vec3(0,0,e)) - calcDensity(pos - vec3(0,0,e));
    return normalize2(vec3(dx, dy, dz));
}

vec4 renderVolumetricClouds(vec3 rayOrigin, vec3 rayDir, vec3 sunDir) {
    float t = max((CLOUD_BASE - rayOrigin.y)/rayDir.y,0.0);
    vec3 pos = rayOrigin + rayDir * t;

    vec3 colorAcc = vec3(0.0);
    float alphaAcc = 0.0;

    vec3 lighting = vec3(0.0);

    float densitySum = 0.0;

    vec3 marchPos = rayOrigin;

    vec3 hitPos = vec3(0.0);

    float depthMask = 0.0;

    float leftDepth = 0.0;
    float rightDepth = 0.0;
    float upDepth = 0.0;
    float downDepth = 0.0;
    
    float aspectRatio = float(viewWidth)/float(viewHeight);
    
    vec3 normalMap = vec3(0.0);

    float centerPos = CLOUD_BASE + (CLOUD_TOP - CLOUD_BASE)/2;
    float cloudHeight = (CLOUD_TOP - CLOUD_BASE);

    for(int i = 0; i < CLOUD_STEPS; i++) {
        if(rayDir.y < 0.0) continue;

        //if(pos.y > CLOUD_TOP) continue;

        vec2 uv = pos.xz * 0.00075;

        uv += vec2(frameTimeCounter * 0.001);

        uv = fract(uv);

        //vec3 offset = texture2D(clouddis, uv).rgb * 2 - 1;

        vec3 movePos = pos * 0.075 + vec3(frameTimeCounter,0.0,frameTimeCounter);
        vec3 movePos2 = pos * 0.075 + vec3(frameTimeCounter, 0.0,frameTimeCounter);

        float density = cloudBilinear(movePos, vec3(STEP_SIZE));
        float density2 = cloudBilinear(movePos2, vec3(STEP_SIZE));
        density = min(density, density2);
        //density *= (1.0 - abs(pos.y - centerPos))/cloudHeight;
        //density = pow2(density,(1.0 - abs(pos.y - centerPos))/cloudHeight);
        float densityRain = smoothstep(0.5 * clamp(1 - rainFactor*1.75,0,1), 0.7,texture2D(cloudtex, uv).r);
        //density = smoothstep(i/CLOUD_STEPS * 2 - 1, 1.0, density);
        //density = mix2(density, densityRain, rainFactor);
        /*if(length(texture2D(cloudnormal, uv).xyz) > 0.1) {
            vec3 normalMapA = texture2D(cloudnormal, uv).xyz * length(vec2(frameTimeCounter * 0.001) + float(i));
            vec3 normalMapB = texture2D(cloudnormal, uv + (i * STEP_SIZE)).xyz * length(vec2(frameTimeCounter * 0.001) + float(i) * (1 + STEP_SIZE));
            normalMap = mix2(normalMapA, normalMapB, (length(uv - STEP_SIZE * CLOUD_STEPS)/(STEP_SIZE * CLOUD_STEPS))/length(vec3(1.0)));
        }*/
        
        float light = clamp(dot(sunDir, normalize2(vec3(0, 1, 0))) * 0.5 + 0.5, 0.3, 1.0) * (1 - rainFactor);
        //vec3 sunlight = pow2(texture2D(colortex2, texCoord).xyz,vec3(2.0));
        vec3 sampleCol = mix2(vec3(0.8, 0.85, 0.9) * (1 - rainFactor*0.5),vec3(1.0), light);
        //sampleCol = mix2(sunlight * 10, sampleCol, (1 - 0.5 * length(sunlight)) * (1 - dot(rayOrigin, sunDir)));

        float alpha = density * 0.1 * (1.0 - alphaAcc);
        alpha = smoothstep(mix2(-0.2, 0.1, 1 - rainFactor), 1.0, (alpha + pow2(density,1/1.75))/2);
        //alpha *= smoothstep(0.0, 1.0, exp(-density * 0.002));
        colorAcc += sampleCol * clamp(alphaAcc * 0.25,0.05,1) * clamp(pow2(1 - (pos.y - CLOUD_BASE)/(CLOUD_TOP - CLOUD_BASE),1/2.2),0,1);
        alphaAcc += alpha;
        densitySum += density;
        /*float d = calcDensity(pos);
        if(d > 0.1 && densitySum < 0.1) {
            hitPos = marchPos;
        } else {
            densitySum += d * STEP_SIZE;
            marchPos += normalize2(rayOrigin) * STEP_SIZE;
        }*/

        float depth = density;
        depthMask = min(depth, depthMask);

        #ifdef VOLUMETRIC_LIGHTING
            lighting = vec3(1.0);
            float cloud_time = frameTimeCounter * 0.001;
            float sun_dot = dot(sunDir, normalize2(vec3(0, 1, 0)));
            for(float s = 0.0; s < CLOUD_SHADING_SAMPLES && alphaAcc < 0.99; s++) {
                vec3 ray_s_pos = pos + sunDir*(s - cloud_time + vec3(texCoord,s))*0.000125;
                vec3 ray_s_pos2 = pos + sunDir*(s + cloud_time*0.5 + vec3(texCoord,s))*0.000125;

                float cloud_shading = clamp(density * 2.0 - 0.5,0.5,1);
                lighting *= 1.0 - cloud_shading;
                lighting = mix2(lighting, vec3(1.0), 1 - step(0.0, alphaAcc));
            }

            lighting.r += lighting.r*pow2(sun_dot,1+20*(1.0 - lighting.r));

            lighting = lighting.r * vec3(VL_COLOR_R, VL_COLOR_G, VL_COLOR_B);
            lighting = mix2(vec3(0.0), lighting, smoothstep(0.2, 0.9, length(lighting)));
            lighting = mix2(lighting * 0.55, lighting, 1 - smoothstep(0.75, 1.0, alphaAcc));
        #endif
        lighting = mix2(lighting, vec3(AMBIENT_LIGHT_R,AMBIENT_LIGHT_G,AMBIENT_LIGHT_B) * MIN_LIGHT, rainFactor);
        //colorAcc = mix2(colorAcc, colorAcc * lighting, (1 - dot(sunDir, normalize2((gbufferModelView * gbufferProjection * vec4(getNormalFrom2DMap(uv, 1.0),1.0)).xyz))) * 0.25);

        pos += rayDir * STEP_SIZE;

        //normalMap += normalize2((gbufferProjectionInverse * vec4(calcCloudNormals(movePos) * 2 - 1,1.0)).xyz);
        /*normalMap += normalize2(vec3(
            calcDensity(movePos + vec3(STEP_SIZE, 0, 0)) - calcDensity(movePos - vec3(STEP_SIZE, 0, 0)),
            calcDensity(movePos + vec3( 0, 0, STEP_SIZE)) - calcDensity(movePos - vec3( 0, 0, STEP_SIZE)),
            calcDensity(movePos + vec3(0, STEP_SIZE, 0)) - calcDensity(movePos - vec3(0, STEP_SIZE, 0))
        )) / float(CLOUD_STEPS);*/

        vec3 uvX_A = movePos + vec3(STEP_SIZE, 0, 0);
        vec3 uvX_B = movePos - vec3(STEP_SIZE, 0, 0);

        vec3 uvX_C = movePos2 + vec3(STEP_SIZE, 0, 0);
        vec3 uvX_D = movePos2 - vec3(STEP_SIZE, 0, 0);

        vec3 uvY_A = movePos + vec3(0, STEP_SIZE, 0);
        vec3 uvY_B = movePos - vec3(0, STEP_SIZE, 0);

        vec3 uvY_C = movePos2 + vec3(0, STEP_SIZE, 0);
        vec3 uvY_D = movePos2 - vec3(0, STEP_SIZE, 0);
        
        vec3 uvZ_A = movePos + vec3(0, 0, STEP_SIZE);
        vec3 uvZ_B = movePos - vec3(0, 0, STEP_SIZE);

        vec3 uvZ_C = movePos2 + vec3(0, 0, STEP_SIZE);
        vec3 uvZ_D = movePos2 - vec3(0, 0, STEP_SIZE);
        
        /*float dX = min(cloudBilinear(uvX_A, vec3(STEP_SIZE)),cloudBilinear(uvX_C, vec3(STEP_SIZE))) - min(cloudBilinear(uvX_B, vec3(STEP_SIZE)),cloudBilinear(uvX_D, vec3(STEP_SIZE)));
        float dY = min(cloudBilinear(uvY_A, vec3(STEP_SIZE)),cloudBilinear(uvY_C, vec3(STEP_SIZE))) - min(cloudBilinear(uvY_B, vec3(STEP_SIZE)),cloudBilinear(uvY_D, vec3(STEP_SIZE)));
        float dZ = min(cloudBilinear(uvZ_A, vec3(STEP_SIZE)),cloudBilinear(uvZ_C, vec3(STEP_SIZE))) - min(cloudBilinear(uvZ_B, vec3(STEP_SIZE)),cloudBilinear(uvZ_D, vec3(STEP_SIZE)));*/

        float dX = min(cloudBilinear(uvX_A, vec3(STEP_SIZE)),cloudBilinear(uvX_C, vec3(STEP_SIZE)))- density;
        float dY = density;
        float dZ = min(cloudBilinear(uvZ_A, vec3(STEP_SIZE)),cloudBilinear(uvZ_C, vec3(STEP_SIZE))) - density;
        normalMap += normalize2(vec3(dX, dY, dZ) * 2 - 1);
    }

    mat3 tbn = tbnNormalTangent(VertNormal, Tangent);
    normalMap /= CLOUD_STEPS;
    //normalMap.y = 1.0;
    //normalMap = normalize2(normalMap);
    
    //normalMap = normalMap * 2 - 1;
    //normalMap = tbn * normalMap;

    //normalMap = normalMap.xzy;

    //normalMap.xz *= -1;

    //normalMap.y *= -1;

    #ifdef VOLUMETRIC_LIGHTING
        //lighting = mix2(cloudAmbience, cloudLight, clamp(dot(sunDir.xyz, normalize2(normalMap)),0,1));
    #endif

    colorAcc = pow2(colorAcc/CLOUD_STEPS,vec3(1/8.0));

    colorAcc *= mix2(1.0, 0.5, rainFactor);

    alphaAcc *= mix2(0.25,1.0,rainFactor);

    normalMap.y *= alphaAcc;

    normalMap = normalize2(normalMap);

    normalMap *= smoothstep(0, 0.1, alphaAcc);

    colorAcc = colorAcc * mix2(cloudAmbience, cloudLight, clamp(dot(sunDir, normalize2(normalMap)),0,1) * (1 - rainFactor));

    vec3 sunColor = mix2(vec3(VL_COLOR_R, VL_COLOR_G, VL_COLOR_B),vec3(0.0), rainFactor);

    //lightCalc = vec4(texture2D(colortex2, texCoord).xyz + sunColor*texture2D(colortex2, texCoord).x,1.0)*(1-rainFactor)*smoothstep(0.25, 1, 1 - pow2(alphaAcc/2,0.5) * 2);

    //return vec4(normalMap, 1.0);

    //return vec4(vec3(dot(-sunDir, normalMap)),1.0);

    //return vec4(lighting, 1.0);

    return mix2(vec4(colorAcc*mix2(0.65, 0.5, rainFactor),0.0), vec4(colorAcc*mix2(0.65, 0.5, rainFactor),1.0), smoothstep(0.25, 1, pow2(alphaAcc/2,0.5) * 2)) * vec4(vec3(1.0), smoothstep(0, 0.2, rayDir.y));
}

vec4 renderBackgroundClouds(vec3 rayOrigin, vec3 rayDir, vec3 sunDir) {
    float t = max((CLOUD_BASE - rayOrigin.y)/rayDir.y,0.0);
    vec3 pos = rayOrigin + rayDir * t;

    vec3 colorAcc = vec3(0.0);
    float alphaAcc = 0.0;

    vec3 lighting = vec3(0.0);

    float densitySum = 0.0;

    vec3 marchPos = rayOrigin;

    vec3 hitPos = vec3(0.0);

    float depthMask = 0.0;

    float leftDepth = 0.0;
    float rightDepth = 0.0;
    float upDepth = 0.0;
    float downDepth = 0.0;
    
    float aspectRatio = float(viewWidth)/float(viewHeight);
    
    vec3 normalMap = vec3(0.0);

    float centerPos = CLOUD_BASE_BKG + (CLOUD_TOP_BKG - CLOUD_BASE_BKG)/2;
    float cloudHeight = (CLOUD_TOP_BKG - CLOUD_BASE_BKG);

    for(int i = 0; i < CLOUD_STEPS_BKG; i++) {
        if(rayDir.y < 0.0) continue;

        //if(pos.y > CLOUD_TOP) continue;

        vec2 uv = pos.xz * 0.00075;

        uv += vec2(frameTimeCounter * 0.001);

        uv = fract(uv);

        //vec3 offset = texture2D(clouddis, uv).rgb * 2 - 1;

        vec3 movePos = pos * 0.75 + vec3(frameTimeCounter,0.0,frameTimeCounter);
        vec3 movePos2 = pos * 0.75 + vec3(frameTimeCounter,0.0,frameTimeCounter);

        float density = calcDensity(movePos);
        float density2 = calcDensity(movePos2);
        density = min(density, density2);
        //density *= (1.0 - abs(pos.y - centerPos))/cloudHeight;
        //density = pow2(density,(1.0 - abs(pos.y - centerPos))/cloudHeight);
        float densityRain = smoothstep(0.5 * clamp(1 - rainFactor*1.75,0,1), 0.7,texture2D(cloudtex, uv).r);
        //density = smoothstep(i/CLOUD_STEPS * 2 - 1, 1.0, density);
        //density = mix2(density, densityRain, rainFactor);
        /*if(length(texture2D(cloudnormal, uv).xyz) > 0.1) {
            vec3 normalMapA = texture2D(cloudnormal, uv).xyz * length(vec2(frameTimeCounter * 0.001) + float(i));
            vec3 normalMapB = texture2D(cloudnormal, uv + (i * STEP_SIZE)).xyz * length(vec2(frameTimeCounter * 0.001) + float(i) * (1 + STEP_SIZE));
            normalMap = mix2(normalMapA, normalMapB, (length(uv - STEP_SIZE * CLOUD_STEPS)/(STEP_SIZE * CLOUD_STEPS))/length(vec3(1.0)));
        }*/
        
        float light = clamp(dot(sunDir, normalize2(vec3(0, 1, 0))) * 0.5 + 0.5, 0.3, 1.0) * (1 - rainFactor);
        //vec3 sunlight = pow2(texture2D(colortex2, texCoord).xyz,vec3(2.0));
        vec3 sampleCol = mix2(vec3(0.8, 0.85, 0.9) * (1 - rainFactor*0.5),vec3(1.0), light);
        //sampleCol = mix2(sunlight * 10, sampleCol, (1 - 0.5 * length(sunlight)) * (1 - dot(rayOrigin, sunDir)));

        float alpha = density * 0.1 * (1.0 - alphaAcc);
        alpha = smoothstep(mix2(-0.2, 0.1, 1 - rainFactor), 1.0, (alpha + pow2(density,1/1.75))/2);
        //alpha *= smoothstep(0.0, 1.0, exp(-density * 0.002));
        colorAcc += sampleCol * clamp(alphaAcc * 0.25,0.05,1) * clamp(pow2(1 - (pos.y - CLOUD_BASE)/(CLOUD_TOP - CLOUD_BASE),1/2.2),0,1);
        alphaAcc += alpha;
        densitySum += density;
        /*float d = calcDensity(pos);
        if(d > 0.1 && densitySum < 0.1) {
            hitPos = marchPos;
        } else {
            densitySum += d * STEP_SIZE;
            marchPos += normalize2(rayOrigin) * STEP_SIZE;
        }*/

        float depth = density;
        depthMask = min(depth, depthMask);

        /*#ifdef VOLUMETRIC_LIGHTING
            lighting = vec3(1.0);
            float cloud_time = frameTimeCounter * 0.001;
            float sun_dot = dot(sunDir, normalize2(vec3(0, 1, 0)));
            for(float s = 0.0; s < CLOUD_SHADING_SAMPLES && alphaAcc < 0.99; s++) {
                vec3 ray_s_pos = pos + sunDir*(s - cloud_time + vec3(texCoord,s))*0.000125;
                vec3 ray_s_pos2 = pos + sunDir*(s + cloud_time*0.5 + vec3(texCoord,s))*0.000125;

                float cloud_shading = clamp(density * 2.0 - 0.5,0.5,1);
                lighting *= 1.0 - cloud_shading;
                lighting = mix2(lighting, vec3(1.0), 1 - step(0.0, alphaAcc));
            }

            lighting.r += lighting.r*pow2(sun_dot,1+20*(1.0 - lighting.r));

            lighting = lighting.r * vec3(VL_COLOR_R, VL_COLOR_G, VL_COLOR_B);
            lighting = mix2(vec3(0.0), lighting, smoothstep(0.2, 0.9, length(lighting)));
            lighting = mix2(lighting * 0.55, lighting, 1 - smoothstep(0.75, 1.0, alphaAcc));
        #endif*/
        lighting = mix2(lighting, vec3(AMBIENT_LIGHT_R,AMBIENT_LIGHT_G,AMBIENT_LIGHT_B) * MIN_LIGHT, rainFactor);
        //colorAcc = mix2(colorAcc, colorAcc * lighting, (1 - dot(sunDir, normalize2((gbufferModelView * gbufferProjection * vec4(getNormalFrom2DMap(uv, 1.0),1.0)).xyz))) * 0.25);

        pos += rayDir * STEP_SIZE;

        //normalMap += normalize2((gbufferProjectionInverse * vec4(calcCloudNormals(movePos) * 2 - 1,1.0)).xyz);
        /*normalMap += normalize2(vec3(
            calcDensity(movePos + vec3(STEP_SIZE, 0, 0)) - calcDensity(movePos - vec3(STEP_SIZE, 0, 0)),
            calcDensity(movePos + vec3( 0, 0, STEP_SIZE)) - calcDensity(movePos - vec3( 0, 0, STEP_SIZE)),
            calcDensity(movePos + vec3(0, STEP_SIZE, 0)) - calcDensity(movePos - vec3(0, STEP_SIZE, 0))
        )) / float(CLOUD_STEPS);*/
    }

    colorAcc = pow2(colorAcc/CLOUD_STEPS_BKG,vec3(1/8.0));

    colorAcc *= mix2(1.0, 0.5, rainFactor);

    alphaAcc *= mix2(0.25,1.0,rainFactor);

    return vec4(colorAcc, alphaAcc);
}