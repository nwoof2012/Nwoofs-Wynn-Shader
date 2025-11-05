#define CLOUD_STEPS 16
#define STEP_SIZE 20.0
#define CLOUD_BASE 120.0
#define CLOUD_TOP 400.0

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

vec4 renderVolumetricClouds(vec3 rayOrigin, vec3 rayDir, vec3 sunDir) {
    float t = max((CLOUD_BASE - rayOrigin.y)/rayDir.y,0.0);
    vec3 pos = rayOrigin + rayDir * t;

    vec3 colorAcc = vec3(0.0);
    float alphaAcc = 0.0;

    vec3 lighting = vec3(0.0);

    for(int i = 0; i < CLOUD_STEPS; i++) {
        if(rayDir.y < 0.0) continue;
        //if(pos.y > CLOUD_TOP) continue;

        vec2 uv = pos.xz * 0.000075;

        uv += vec2(frameTimeCounter * 0.001 / (float(i + 1))) + float(i) * 0.05;

        float density = texture2D(cloudtex, uv).r * 2 - 1;
        float densityRain = smoothstep(0.5 * clamp(1 - rainStrength*1.75,0,1), 0.7,texture2D(cloudtex, uv).r);
        density = smoothstep(0.5 * (1 - rainStrength*1.75), 0.7, density);
        density = mix2(density, densityRain, rainStrength);
        
        float light = clamp(dot(sunDir, normalize2(vec3(0, 1, 0))) * 0.5 + 0.5, 0.3, 1.0) * (1 - rainStrength);
        vec3 sunlight = pow2(texture2D(colortex2, texCoord).xyz,vec3(2.0));
        vec3 sampleCol = mix2(vec3(0.8, 0.85, 0.9) * (1 - rainStrength*0.5),vec3(1.0), light);
        //sampleCol = mix2(sunlight * 10, sampleCol, (1 - 0.5 * length(sunlight)) * (1 - dot(rayOrigin, sunDir)));

        float alpha = density * 0.1 * (1.0 - alphaAcc);
        alpha = smoothstep(mix2(-0.2, 0.1, 1 - rainStrength), 1.0, (alpha + pow2(texture2D(cloudtex, uv * 2).g,1/1.2))/2);
        colorAcc += sampleCol * clamp(alphaAcc * 0.25,0.05,1) * clamp(pow2(1 - (pos.y - CLOUD_BASE)/(CLOUD_TOP - CLOUD_BASE),1/2.2),0,1);
        alphaAcc += alpha;

        #ifdef VOLUMETRIC_LIGHTING
            lighting = mix2(vec3(AMBIENT_LIGHT_R,AMBIENT_LIGHT_G,AMBIENT_LIGHT_B), vec3(VL_COLOR_R, VL_COLOR_G, VL_COLOR_B), clamp(dot((gbufferProjectionInverse * vec4(sunDir,1.0)).xyz, normalize2(getNormalFrom2DMap(uv, 1.0))) * 1.25,0,1));
        #endif

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
        lighting = mix2(lighting, vec3(1.0), rainStrength);
        colorAcc = mix2(colorAcc, colorAcc * lighting, (1 - dot(sunDir, normalize2((gbufferModelView * gbufferProjection * vec4(getNormalFrom2DMap(uv, 1.0),1.0)).xyz))) * 0.25);

        pos += rayDir * STEP_SIZE + vec3(0.0, 1 - alpha, 0.0);
    }

    vec3 sunColor = mix2(vec3(VL_COLOR_R, VL_COLOR_G, VL_COLOR_B),vec3(0.0), rainStrength);

    lightCalc = vec4(texture2D(colortex2, texCoord).xyz + sunColor*texture2D(colortex2, texCoord).x,1.0)*(1-rainStrength)*clamp(1-alphaAcc*10,0,1);

    return mix2(texture2D(colortex0, texCoord), vec4(colorAcc*mix2(0.65, 0.5, rainStrength),1.0), clamp(alphaAcc * 4, 0, 1)) * vec4(vec3(1.0), smoothstep(0, 0.2, rayDir.y));
}