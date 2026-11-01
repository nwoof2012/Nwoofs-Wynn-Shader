#define CLOUD_STEPS 8 // [3 4 6 8 12 16]

#define CLOUD_BASE 120.0
#define CLOUD_TOP 220.0
#define CLOUD_HEIGHT 120.0
#define STEP_SIZE (CLOUD_TOP - CLOUD_BASE)/CLOUD_STEPS

#define CLOUD_THICKNESS 45.0
#define CLOUD_THICKNESS_SAMPLES 1

#define CLOUD_LAYERS 1

#define CLOUD_RES 360.0

#define CLOUD_STEPS_BKG 6
#define CLOUD_BASE_BKG 920.0
#define CLOUD_TOP_BKG 1320.0
#define STEP_SIZE_BKG (CLOUD_TOP_BKG - CLOUD_BASE_BKG)/CLOUD_STEPS_BKG

vec4 lightCalc = vec4(0.0);

float cloudCoverage;

float safeRayY(vec3 rayDir) {
    return rayDir.y >= 0.0 ? max(rayDir.y, 0.001) : min(rayDir.y, -0.001);
}

vec3 warp(vec3 uv) {
    float w1 = texture2D(noiseb, uv.xz * 0.5).x;
    float w2 = texture2D(noiseb, uv.xz * 0.5 + 17.3).x;

    return vec3(w1, 0.0, w2) * 2.0 - 1.0;
}

vec3 heightWarp(float height) {
    float w1 = texture2D(noiseb, vec2(0.0, height * 0.5)).r;
    float w2 = texture2D(noiseb, vec2(0.0, height * 0.5 + 17.3)).r;

    return vec3(w1, 0.0, w2) * 2.0 + 1.0;
}

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

    return pow2(mix2(cx0, cx1, f.y),1.75);
}

vec3 cloudSample(vec3 pos, int i) {
    float density = cloudBilinear(pos, vec3(STEP_SIZE));

    float alpha = smoothstep(abs((float(i)/CLOUD_STEPS) * 2 - 1), 1.0, density);
    alpha = smoothstep(0.5 - 2 * rainFactor, 1.0, alpha);
    alpha = mix2(alpha, pow2(alpha, 0.5), rainFactor);

    float heightFactor = clamp(pow2(alpha, 6.0),0,1);

    return vec3(mix2(0.5, 2.0, heightFactor), density, alpha);
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

#define SHADOW_STEPS 8
#define SHADOW_STEP_SIZE (CLOUD_TOP - CLOUD_BASE)/float(SHADOW_STEPS)

float getCloudShadow(vec3 rayOrigin, vec3 rayDir, vec3 sunDir, float cloudTime) {
    vec3 dir = normalize2(sunDir);

    float shadow = 1.0;

    float t = max((CLOUD_BASE - rayOrigin.y)/safeRayY(rayDir),0.0);
    vec3 pos = rayOrigin - rayDir * t;
    pos.xz += cameraPosition.xz;

    // Convert world position into "skybox sampling space"
    vec3 skyDir = normalize2(pos); // important!

    float centerPos = CLOUD_BASE + (CLOUD_TOP - CLOUD_BASE)/2;
    float cloudHeight = (CLOUD_TOP - CLOUD_BASE);

    vec3 warpPos = (warp(pos * 0.00075) + warp(pos * 0.00025))/2;

    for(int i = 0; i < SHADOW_STEPS; i++) {
        vec3 sampleDir = pos + dir * (float(i) * 0.02);

        vec2 uv = pos.xz * 0.00075;

        vec3 movePos = (pos + warpPos * 250) * 0.25 + vec3(cloudTime,0.0,cloudTime);

        // SAMPLE SKYBOX CLOUD FIELD (NOT WORLD SPACE)
        //float density0 = texture2D(cloudtex, movePos.xz * 0.5 + 0.5).r;
        //float density1 = texture2D(cloudtex, movePos2.xz * 0.5 + 0.5).r;

        //float density = min(density0, density1);

        float density = smoothstep(clamp(abs((pos.y - centerPos)/cloudHeight),0, 0.9), 1, cloudBilinear(movePos, vec3(STEP_SIZE)));
        
        shadow *= exp(-density * 0.6);

        pos += rayDir * SHADOW_STEP_SIZE;
    }

    return shadow;
}

vec4 renderVolumetricClouds(vec3 rayOrigin, vec3 rayDir, vec3 sunDir, float cloudTime) {
    float t = max((CLOUD_BASE - rayOrigin.y)/safeRayY(rayDir),0.0);
    vec3 pos = rayOrigin + rayDir * t;
    pos.xz *= 12.5;
    //pos.xz += cameraPosition.xz;

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

    float centerPos = CLOUD_BASE + (CLOUD_TOP - CLOUD_BASE)/2;
    float cloudHeight = (CLOUD_TOP - CLOUD_BASE);

    vec3 ambientLight = vec3(0.2,0.5,0.7) * (0.25 + 0.75 * (1 - rainFactor));
    vec3 volumetricLight = vec3(VL_COLOR_R, VL_COLOR_G, VL_COLOR_B) * 5;

    float cloudStep = 0.0;

    vec3 basePos = pos;
    basePos.xz += cameraPosition.xz;

    vec3 warpPos = (warp(basePos * 0.00075) + warp(basePos * 0.00025))/2;

    float heightAcc = 1.0;

    float lightTransmittance = 0.0;

    for(int j = 0; j < CLOUD_LAYERS; j++) {
        float currentAlphaAcc = 0.0;
        float currentDensitySum = 0.0;
        vec3 currentColorAcc = vec3(0.0);
        float currentHeightAcc = 1.0;
        float currentLightTransmittance = 0.0;
        vec3 currentPos = pos;
        currentPos.xz += cameraPosition.xz;
        for(int i = 0; i < CLOUD_STEPS_BKG; i++) {
            if(rayDir.y < 0.0) continue;

            //if(transmittance < 0.02) continue;

            //vec2 uv = pos.xz * 0.00075;

            vec3 movePos = (currentPos + warpPos * 125) * 0.25 + vec3(cloudTime / (j + 1),0.0,cloudTime);
            vec3 movePos2 = (currentPos + warpPos * 125) * 5 - vec3(cloudTime / (j + 1) * 0.5,0.0,cloudTime / (j + 1) * 0.5);
            
            float mapA = cloudBilinear(movePos, vec3(STEP_SIZE));
            float mapB = cloudBilinear(movePos2, vec3(STEP_SIZE));

            float mapC = mapA + (mapB * 0.25 - 0.125);

            float density = smoothstep(clamp(abs((currentPos.y - centerPos)/cloudHeight) * 0.5,0, 0.9), 1, mapC);

            //float density = getCloudDensity(pos, cloudTime);
            
            //float light = clamp(dot(sunDir, normalize2(vec3(0, 1, 0))) * 0.5 + 0.5, 0.3, 1.0) * (1 - rainFactor);
            //vec3 sampleCol = mix2(vec3(0.8, 0.85, 0.9) * (1 - rainFactor*0.5),vec3(1.0), light);

            vec3 sampleCol = vec3(1.0);

            float alpha = density * 0.1 * (1.0 - alphaAcc);
            alpha = smoothstep((float(i)/CLOUD_STEPS) * 2 - 1, 1.0, alpha);
            if(i == 0)
            alpha = smoothstep(0.2 - 0.3 * rainFactor, 1.0, (alpha + pow2(density,1/1.75))/2);
            else
            alpha = smoothstep(0.2, 1.0, (alpha + pow2(density,1/1.75))/2);
            //colorAcc += sampleCol * clamp(alphaAcc * 0.25,0.05,1) * clamp(pow2(1 - (pos.y - CLOUD_BASE)/(CLOUD_TOP - CLOUD_BASE),1/2.2),0,1);
            float heightFactor = clamp(pow2(alpha,6) * 6,0,1);
            currentColorAcc += sampleCol;
            currentAlphaAcc += alpha;
            currentDensitySum += density;
            currentHeightAcc += heightFactor;

            float depth = density;
            depthMask = min(depth, depthMask);

            /*#ifdef VOLUMETRIC_LIGHTING
                /*float lightLevel = 0.0;
                float transmittance = 1.0;
                for(int i = 0; i < 4; i++) {
                    float h = density;
                    float hLight = cloudBilinear(movePos + sunDir * i * 0.01, vec3(STEP_SIZE));

                    float verticalEffect = sunDir.y * (1.0 - h);
                    float horizontalEffect = hLight - h;
                    lightLevel += (horizontalEffect + verticalEffect) * transmittance;
                    transmittance *= 0.7;
                    cloudStep += lightLevel/8;
                }
                lighting += volumetricLight * lightLevel/8;
                float opticalDepth = 0.0;

                vec3 lightPos = movePos;

                for(int k = 0; k < 4; k++) {
                    lightPos += sunDir * 0.1;

                    opticalDepth += cloudBilinear(lightPos, vec3(STEP_SIZE)) * 0.1;
                }

                currentLightTransmittance += 1.0 - exp(-0.5 * opticalDepth);
            #endif*/

            currentPos += rayDir * STEP_SIZE;
        }
        if(j == 0) {
            alphaAcc = currentAlphaAcc;
            densitySum = currentDensitySum;
            colorAcc = currentColorAcc;
            heightAcc = currentHeightAcc;
            lightTransmittance = currentLightTransmittance;
        } else {
            alphaAcc = clamp(alphaAcc + currentAlphaAcc,0,1);
            //alphaAcc = mix2(alphaAcc * 0.95, alphaAcc, clamp(j/CLOUD_LAYERS,0,1));
            densitySum = mix2(densitySum, currentDensitySum, currentAlphaAcc);
            colorAcc = mix2(colorAcc, currentColorAcc, currentAlphaAcc);
            heightAcc = mix2(heightAcc, currentHeightAcc, currentAlphaAcc);
            lightTransmittance = mix2(lightTransmittance * 0.5, currentLightTransmittance, currentAlphaAcc);
        }
        pos -= rayDir * 840 * (j + 1) + vec3(float(j + 1)/CLOUD_LAYERS, 0.0, float(j + 1)/CLOUD_LAYERS);
        centerPos -= rayDir.y * 840 * (j + 1);
        pos.xz *= 0.75;
    }

    colorAcc = pow2(colorAcc/(CLOUD_STEPS),vec3(1/8.0));

    heightAcc /= CLOUD_STEPS;

    colorAcc *= mix2(0.75, 1.5, heightAcc);

    colorAcc *= mix2(1.0, 0.5, rainFactor);

    alphaAcc *= mix2(0.5,1.0,rainFactor);

    densitySum /= (CLOUD_STEPS + CLOUD_LAYERS);

    cloudCoverage = alphaAcc;

    vec3 sunColor = mix2(sunlightAlbedo, vec3(0.2,0.5,0.7) * 8, rainFactor * 0.5);
    
    #ifdef VOLUMETRIC_LIGHTING
        //lighting /= CLOUD_STEPS * 4;
        //lighting = max(lighting, ambientLight);
        //lighting = min(lighting, vec3(MAX_LIGHT));
        //cloudStep = clamp(cloudStep/(CLOUD_STEPS * 32),0,1);
        //float densityStep = densitySum/CLOUD_STEPS;
        /*lighting = mix2(ambientLight + lighting/(CLOUD_STEPS * 16), ambientLight, rainFactor);
        vec3 nightLighting = mix2(ambientLight, cloudLight, densitySum/CLOUD_STEPS);
        lighting = mix2(lighting, nightLighting, timeBlendFactor);*/
        //lighting = mix2(ambientLight, lighting * 0.75, cloudStep);
        //vec3 nightLighting = mix2(ambientLight * 0.5, ambientLight, heightAcc);
        //lighting = mix2(vec3(1.0), nightLighting, timeBlendFactor);
        //lightTransmittance /= CLOUD_STEPS;
        //lightTransmittance /= CLOUD_STEPS;
        vec3 directLight = sunColor * (heightAcc * 0.25 + 0.75) * (1 - timeBlendFactor);
        lighting = mix2(ambientLight + directLight, ambientLight * 0.25 + ambientLight * pow2(heightAcc,0.25), timeBlendFactor);
        
        colorAcc *= lighting;
    #endif

    return mix2(vec4(colorAcc*mix2(0.65, 0.5, rainFactor),0.0), vec4(colorAcc*mix2(0.65, 0.5, rainFactor),1.0), smoothstep(0.25, 1, pow2(alphaAcc/2,0.5) * 2)) * vec4(vec3(1.0), smoothstep(0, 0.2, rayDir.y));
}

mediump float get_background_cloud(vec3 p) {
    return clamp(texture2D(cloudtex, p.xy).r * texture2D(cloudtex, p.xy * 0.1).r * (1.0 - (0.3 * (1.0 - rainFactor)))*4 - 1.5, 0.0, 1.0);
}

vec4 renderBackgroundClouds_experimental(vec3 rayOrigin, vec3 rayDir, vec3 sunDir, float cloudTime) {
    float t = max((CLOUD_BASE - rayOrigin.y)/safeRayY(rayDir),0.0);
    vec3 pos = rayOrigin + rayDir * t;
    //pos.xz *= 12.5;
    //pos.xz += cameraPosition.xz;

    vec3 colorAcc = vec3(0.0);
    float alphaAcc = 0.0;

    vec3 lighting = vec3(0.0);

    vec4 clouds = vec4(0.0);

    vec3 marchPos = rayOrigin;

    vec3 hitPos = vec3(0.0);

    float depthMask = 0.0;

    float leftDepth = 0.0;
    float rightDepth = 0.0;
    float upDepth = 0.0;
    float downDepth = 0.0;
    
    float aspectRatio = float(viewWidth)/float(viewHeight);

    float centerPos = CLOUD_BASE + (CLOUD_TOP - CLOUD_BASE_BKG)/2;
    float cloudHeight = (CLOUD_TOP - CLOUD_BASE_BKG);

    vec3 ambientLight = vec3(0.2,0.5,0.7) * (0.25 + 0.75 * (1 - rainFactor));
    vec3 volumetricLight = vec3(VL_COLOR_R, VL_COLOR_G, VL_COLOR_B) * 5;

    float cloudStep = 0.0;

    vec3 basePos = pos;
    basePos.xz += cameraPosition.xz;

    vec2 uv = pos.xz + cloudTime + cameraPosition.xz/CLOUD_HEIGHT;

    vec3 warpPos = (warp(basePos * 0.00075) + warp(basePos * 0.00025))/2;

    float heightAcc = 1.0;

    float lightTransmittance = 0.0;
    
    float sun_dot = clamp(dot(rayDir, sunDir),0,1);

    if(rayDir.y > 0.0) {
        vec3 player = vec3(uv * 0.001, 0);
        //vec3 player2 = vec3(uv2, 0);
        for(float i = 0; i < CLOUD_STEPS_BKG && clouds.a < 0.99; i++) {
            vec3 ray_pos = player + rayDir*(i-random3D(vec3(texCoord,i))*0.0025);
            //ray_pos *= mix2(CLOUD_BASE, CLOUD_TOP, i/CLOUD_STEPS) * 0.005;
            vec4 cloud = vec4(get_background_cloud(ray_pos));
            cloud.rgba *= 0.65 * (1 - rainFactor) + 0.35;
            //cloud.rgba = clamp(cloud.rgba, 0, 1);
            if(cloud.a <= 0.0) continue;
            cloud.rgb = vec3(1.0);
            
            vec3 lightAmount = sunlightAlbedo;
            for(float s = 0; s < 4.0 && clouds.a < 0.99; s++) {
                vec3 ray_s_pos = ray_pos - sunDir*(s-random3D(vec3(texCoord,i))*0.0025);

                float cloud_shading = pow2(get_background_cloud(ray_s_pos),2);
                lightAmount *= 1.0 - cloud_shading;
            } 
            lightAmount += lightAmount.r*pow2(sun_dot,1.0+20.0*lightAmount.r) * (1 - rainFactor);
            cloud.a = mix2(cloud.a, pow2(cloud.a, 0.75), rainFactor * timeBlendFactor);
            cloud.rgb *= (lightAmount*(0.25 + 0.75 * (1 - rainFactor))+skyInfluenceColor * 0.5 + vec3(AMBIENT_LIGHT_R, AMBIENT_LIGHT_G, AMBIENT_LIGHT_B) * 0.75) * max(rainFactor, 1 - max(seFactor, timeBlendFactor) * 0.75) * 0.5;
            //cloud = mix2(cloud, pow2(cloud, vec4(0.75)), rainFactor);
            clouds.rgb = mix2(clouds.rgb, cloud.rgb, (1.0 - clouds.a) * cloud.a);
            clouds.a += (1.0 - clouds.a) * cloud.a;
        }
        //clouds.a = pow2(clouds.a, 0.25);
        clouds.a = clamp(clouds.a, 0, 1);
        //clouds.rgb = vec3(1.0);
        clouds.rgb *= 1.0 - clamp(clouds.a - 0.5, 0.0, 0.25);
    } else {
        clouds = vec4(0.0);
    }

    return clouds;
}

vec4 renderBackgroundClouds(vec3 rayOrigin, vec3 rayDir, vec3 sunDir, float cloudTime) {
    float t = max((CLOUD_BASE_BKG - rayOrigin.y)/safeRayY(rayDir),0.0);
    vec3 pos = rayOrigin + rayDir * t;
    pos.xz += cameraPosition.xz;

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

    vec3 ambientLight = vec3(AMBIENT_LIGHT_R,AMBIENT_LIGHT_G,AMBIENT_LIGHT_B);
    vec3 volumetricLight = vec3(VL_COLOR_R, VL_COLOR_G, VL_COLOR_B);

    for(int i = 0; i < CLOUD_STEPS_BKG; i++) {
        if(rayDir.y < 0.0) continue;

        //if(pos.y > CLOUD_TOP) continue;

        vec2 uv = pos.xz * 0.00075;

        //uv += vec2(frameTimeCounter * 0.001);

        //uv = fract(uv);

        //vec3 offset = texture2D(clouddis, uv).rgb * 2 - 1;

        vec3 movePos = (pos + warp(pos * 0.000125) * 250) * 0.125 + vec3(cloudTime,0.0,cloudTime);
        //vec3 movePos2 = pos * 0.075 + vec3(cloudTime, 0.0,cloudTime);

        float density = smoothstep(clamp(abs((pos.y - centerPos)/cloudHeight),0, 0.9), 1, cloudBilinear(movePos, vec3(STEP_SIZE_BKG)));
        //float density2 = calcDensity(movePos);
        //density = min(density, density2);
        //density *= (1.0 - abs(pos.y - centerPos))/cloudHeight;
        //density = pow2(density,(1.0 - abs(pos.y - centerPos))/cloudHeight);
        //float densityRain = smoothstep(0.5 * clamp(1 - rainFactor*1.75,0,1), 0.7,cloudBilinear(movePos, vec3(STEP_SIZE)));
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
        alpha = smoothstep(0.1, 1.0, (alpha + pow2(density,1/1.75))/2);
        //alpha *= smoothstep(0.0, 1.0, exp(-density * 0.002));
        colorAcc += sampleCol * clamp(alphaAcc * 0.25,0.05,1) * clamp(pow2(1 - (pos.y - CLOUD_BASE_BKG)/(CLOUD_TOP_BKG - CLOUD_BASE_BKG),1/2.2),0,1);
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
        #ifdef VOLUMETRIC_LIGHTING
            float lightLevel = float(i)/float(CLOUD_STEPS_BKG) * 20;
            /*float transmittance = 1.0;
            for(int i = 0; i < 4; i++) {
                float h = density;
                float hLight = cloudBilinear(movePos + sunDir * i * 0.01, vec3(STEP_SIZE));

                float verticalEffect = sunDir.y * (1.0 - h);
                float horizontalEffect = hLight - h;
                lightLevel += (horizontalEffect + verticalEffect) * transmittance;
                transmittance *= 0.7;
            }*/
            lighting += volumetricLight * lightLevel;
        #endif
        //lighting = mix2(lighting, vec3(AMBIENT_LIGHT_R,AMBIENT_LIGHT_G,AMBIENT_LIGHT_B) * MIN_LIGHT, rainFactor);
        //colorAcc = mix2(colorAcc, colorAcc * lighting, (1 - dot(sunDir, normalize2((gbufferModelView * gbufferProjection * vec4(getNormalFrom2DMap(uv, 1.0),1.0)).xyz))) * 0.25);

        pos += rayDir * STEP_SIZE;

        //normalMap += normalize2((gbufferProjectionInverse * vec4(calcCloudNormals(movePos) * 2 - 1,1.0)).xyz);
        /*normalMap += normalize2(vec3(
            calcDensity(movePos + vec3(STEP_SIZE, 0, 0)) - calcDensity(movePos - vec3(STEP_SIZE, 0, 0)),
            calcDensity(movePos + vec3( 0, 0, STEP_SIZE)) - calcDensity(movePos - vec3( 0, 0, STEP_SIZE)),
            calcDensity(movePos + vec3(0, STEP_SIZE, 0)) - calcDensity(movePos - vec3(0, STEP_SIZE, 0))
        )) / float(CLOUD_STEPS);*/

        /*vec3 uvX_A = movePos + vec3(STEP_SIZE, 0, 0);
        vec3 uvX_B = movePos - vec3(STEP_SIZE, 0, 0);

        vec3 uvY_A = movePos + vec3(0,STEP_SIZE,0);
        vec3 uvY_B = movePos - vec3(0,STEP_SIZE,0);
        
        vec3 uvZ_A = movePos + vec3(0, 0, STEP_SIZE);
        vec3 uvZ_B = movePos - vec3(0, 0, STEP_SIZE);*/
        
        /*float dX = min(cloudBilinear(uvX_A, vec3(STEP_SIZE)),cloudBilinear(uvX_C, vec3(STEP_SIZE))) - min(cloudBilinear(uvX_B, vec3(STEP_SIZE)),cloudBilinear(uvX_D, vec3(STEP_SIZE)));
        float dY = min(cloudBilinear(uvY_A, vec3(STEP_SIZE)),cloudBilinear(uvY_C, vec3(STEP_SIZE))) - min(cloudBilinear(uvY_B, vec3(STEP_SIZE)),cloudBilinear(uvY_D, vec3(STEP_SIZE)));
        float dZ = min(cloudBilinear(uvZ_A, vec3(STEP_SIZE)),cloudBilinear(uvZ_C, vec3(STEP_SIZE))) - min(cloudBilinear(uvZ_B, vec3(STEP_SIZE)),cloudBilinear(uvZ_D, vec3(STEP_SIZE)));*/

        //float dX = cloudBilinear(uvX_A, vec3(STEP_SIZE)) - cloudBilinear(uvX_B, vec3(STEP_SIZE));
        //float dY = cloudBilinear(uvY_A, vec3(STEP_SIZE)) - cloudBilinear(uvY_B, vec3(STEP_SIZE));
        //float dZ = cloudBilinear(uvZ_A, vec3(STEP_SIZE)) - cloudBilinear(uvZ_B, vec3(STEP_SIZE));
        //normalMap += normalize2(vec3(dX, dY + STEP_SIZE/CLOUD_STEPS, dZ) * 2 - 1);
    }

    //mat3 tbn = tbnNormalTangent(VertNormal, Tangent);
    //normalMap /= CLOUD_STEPS;
    //normalMap.y = 1.0;
    //normalMap = normalize2(normalMap);
    
    //normalMap = normalMap * 2 - 1;
    //normalMap = tbn * normalMap;

    //normalMap = normalMap.xzy;

    //normalMap.xz *= -1;

    //normalMap.y *= -1;

    #ifdef VOLUMETRIC_LIGHTING
        //lighting = mix2(cloudAmbience, cloudLight, clamp(dot(sunDir.xyz, normalize2(normalMap)),0,1));
        //lighting *= light;
    #endif

    colorAcc = pow2(colorAcc/CLOUD_STEPS,vec3(1/6.0));

    colorAcc *= mix2(1.0, 0.5, rainFactor);

    alphaAcc *= mix2(0.25,1.0,rainFactor);

    cloudCoverage = alphaAcc;

    //normalMap.y *= alphaAcc;

    //normalMap = normalize2(normalMap);

    //normalMap *= smoothstep(0, 0.1, alphaAcc);

    //colorAcc = colorAcc * mix2(cloudAmbience, cloudLight, clamp(dot(sunDir, normalize2(normalMap)),0,1) * (1 - rainFactor));

    //colorAcc *= cloudAmbience;

    //colorAcc *= mix2(cloudAmbience, cloudLight, light/CLOUD_STEPS);

    vec3 sunColor = mix2(vec3(VL_COLOR_R, VL_COLOR_G, VL_COLOR_B),vec3(0.0), rainFactor);
    
    #ifdef VOLUMETRIC_LIGHTING
        lighting = max(lighting, vec3(0.0));
        lighting = mix2(ambientLight, volumetricLight, densitySum/CLOUD_STEPS);
        lighting = mix2(ambientLight + lighting, ambientLight, rainFactor);
        vec3 nightLighting = mix2(ambientLight, cloudLight, densitySum/CLOUD_STEPS);
        lighting = nightLighting + lighting * (1 - timeBlendFactor);
        colorAcc *= lighting;
    #endif

    //lightCalc = vec4(texture2D(colortex2, texCoord).xyz + sunColor*texture2D(colortex2, texCoord).x,1.0)*(1-rainFactor)*smoothstep(0.25, 1, 1 - pow2(alphaAcc/2,0.5) * 2);

    //return vec4(abs(normalMap), 1.0);

    //return vec4(mix2(vec3(1,0,0), vec3(0,0,1), dot(-sunDir, normalMap)) * alphaAcc,1.0);

    //return vec4(lighting, 1.0);

    return mix2(vec4(colorAcc*mix2(0.65, 0.5, rainFactor),0.0), vec4(colorAcc*mix2(0.65, 0.5, rainFactor),1.0), smoothstep(0.25, 1, pow2(alphaAcc/2,0.5) * 2)) * vec4(vec3(1.0), smoothstep(0, 0.2, rayDir.y));
}
