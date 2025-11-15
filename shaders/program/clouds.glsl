#define CLOUD_STEPS 16
#define STEP_SIZE 20.0
#define CLOUD_BASE 120.0
#define CLOUD_TOP 400.0
#define CLOUD_THICKNESS 45.0
#define CLOUD_THICKNESS_SAMPLES 4

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

        uv += vec2(frameTimeCounter * 0.001) + sin(float(i) + uv.y + uv.x);

        uv = fract(uv);

        vec3 offset = texture2D(clouddis, uv).rgb * 2 - 1;

        vec3 movePos = pos * 0.075 + offset + vec3(frameTimeCounter, 0, frameTimeCounter);

        float density = calcDensity(movePos);
        //density *= (1.0 - abs(pos.y - centerPos))/cloudHeight;
        //density = pow2(density,(1.0 - abs(pos.y - centerPos))/cloudHeight);
        float densityRain = smoothstep(0.5 * clamp(1 - rainStrength*1.75,0,1), 0.7,texture2D(cloudtex, uv).r);
        //density = smoothstep(i/CLOUD_STEPS * 2 - 1, 1.0, density);
        //density = mix2(density, densityRain, rainStrength);
        /*if(length(texture2D(cloudnormal, uv).xyz) > 0.1) {
            vec3 normalMapA = texture2D(cloudnormal, uv).xyz * length(vec2(frameTimeCounter * 0.001) + float(i));
            vec3 normalMapB = texture2D(cloudnormal, uv + (i * STEP_SIZE)).xyz * length(vec2(frameTimeCounter * 0.001) + float(i) * (1 + STEP_SIZE));
            normalMap = mix2(normalMapA, normalMapB, (length(uv - STEP_SIZE * CLOUD_STEPS)/(STEP_SIZE * CLOUD_STEPS))/length(vec3(1.0)));
        }*/
        
        float light = clamp(dot(sunDir, normalize2(vec3(0, 1, 0))) * 0.5 + 0.5, 0.3, 1.0) * (1 - rainStrength);
        vec3 sunlight = pow2(texture2D(colortex2, texCoord).xyz,vec3(2.0));
        vec3 sampleCol = mix2(vec3(0.8, 0.85, 0.9) * (1 - rainStrength*0.5),vec3(1.0), light);
        //sampleCol = mix2(sunlight * 10, sampleCol, (1 - 0.5 * length(sunlight)) * (1 - dot(rayOrigin, sunDir)));

        float alpha = density * 0.1 * (1.0 - alphaAcc);
        alpha = smoothstep(mix2(-0.2, 0.1, 1 - rainStrength), 1.0, (alpha + pow2(density,1/1.75))/2);
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
        lighting = mix2(lighting, vec3(AMBIENT_LIGHT_R,AMBIENT_LIGHT_G,AMBIENT_LIGHT_B) * MIN_LIGHT, rainStrength);
        //colorAcc = mix2(colorAcc, colorAcc * lighting, (1 - dot(sunDir, normalize2((gbufferModelView * gbufferProjection * vec4(getNormalFrom2DMap(uv, 1.0),1.0)).xyz))) * 0.25);

        pos += rayDir * STEP_SIZE;

        normalMap += normalize2((gbufferProjectionInverse * vec4(calcCloudNormals(movePos) * 2 - 1,1.0)).xyz);
    }

    mat3 tbn = tbnNormalTangent((gbufferProjection * vec4(VertNormal * 2 - 1, 1.0)).xyz, (gbufferProjection * vec4(Tangent,1.0)).xyz);
    normalMap /= CLOUD_STEPS;
    
    //normalMap = tbn * normalMap;
    normalMap = normalize2(normalMap);

    normalMap = normalMap.xzy;

    normalMap.xy *= -1;

    #ifdef VOLUMETRIC_LIGHTING
        lighting = mix2(cloudAmbience, cloudLight, clamp(dot((gbufferModelViewInverse * vec4(sunDir,1.0)).xyz, normalize2(normalMap)),0,1));
    #endif

    colorAcc = pow2(colorAcc/CLOUD_STEPS,vec3(1/8.0));

    colorAcc *= mix2(2.0, 1.0, rainStrength);

    alphaAcc *= 0.25;

    colorAcc = colorAcc * mix2(cloudAmbience, cloudLight, clamp(dot((gbufferModelViewInverse * vec4(sunDir,1.0)).xyz, normalize2(normalMap)),0,1) * (1 - rainStrength));

    vec3 sunColor = mix2(vec3(VL_COLOR_R, VL_COLOR_G, VL_COLOR_B),vec3(0.0), rainStrength);

    lightCalc = vec4(texture2D(colortex2, texCoord).xyz + sunColor*texture2D(colortex2, texCoord).x,1.0)*(1-rainStrength)*smoothstep(0.25, 1, 1 - pow2(alphaAcc/2,0.5) * 2);

    //return vec4(normalMap, 1.0);

    return mix2(vec4(colorAcc*mix2(0.65, 0.5, rainStrength),0.0), vec4(colorAcc*mix2(0.65, 0.5, rainStrength),1.0), smoothstep(0.25, 1, pow2(alphaAcc/2,0.5) * 2)) * vec4(vec3(1.0), smoothstep(0, 0.2, rayDir.y));
}