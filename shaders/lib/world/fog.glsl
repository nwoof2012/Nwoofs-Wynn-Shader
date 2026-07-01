#define CLOUD_BASE 120.0
#define CLOUD_TOP 400.0

float cloudShadows(vec3 worldPos, vec3 sunDir) {
    float cloudCoverage = texture2D(colortex14, TexCoords).y;

    float shadow = 1.0 - cloudCoverage;

    return shadow;
}

vec3 calcFogColor(vec3 viewDir, vec3 sunPos, vec3 albedo, vec3 fogColor, vec3 sunColor, float factor) {
    float viewDotSun = dot(normalize2(viewDir), normalize2(sunPos));
    float phase = 0.5 + pow2(1.5 - viewDotSun, 2.0);
    vec3 fog = mix2(fogColor, sunColor, sunPos.y);
    return mix2(albedo, fogColor, clamp(factor * phase,0,min(fogIntensity,1.0)));
}

vec3 applyHeightFog(vec3 sceneColor, vec3 rayOrigin, vec3 worldPos, vec3 fogColor, float fogDensity, float heightFalloff) {
    rayOrigin.y += 96.0;
    vec3 rayVec = worldPos - rayOrigin;
    float dist = length(rayVec);
    vec3 dir = rayVec/dist;

    float fogAmount = fogDensity * exp(-rayOrigin.y * heightFalloff) * (1.0 - exp(-dist * dir.y * heightFalloff)) / (dir.y * heightFalloff);

    fogAmount = clamp(fogAmount, 0, 1);
    return mix2(sceneColor, fogColor, fogAmount);
}

float volumetricDensity(vec3 rayDir, vec3 worldPos, float maxDist, float density, float heightDensity) {
    float outDensity = 0.0;
    float transmittance = 1.0;
    vec3 sunDir = normalize2(sunPosition);
    vec3 sunWorldDir = normalize2((gbufferModelViewInverse * vec4(sunPosition, 1.0)).xyz);

    vec2 UVs = worldToScreen(worldPos);

    for(int i = 0; i < VL_FOG_STEPS; i++) {
        float t = (float(i) + 0.5) / float(VL_FOG_STEPS);
        float dist = t * maxDist;

        vec3 samplePos = cameraPosition + rayDir * dist;
        float heightFactor = exp(-worldPos.y * heightDensity);

        float shadow = texture2D(colortex14, UVs).x;

        float phase = pow2(max(dot(rayDir, sunDir),0.0), 6.0);

        float sampleDensity = shadow * phase;

        outDensity += sampleDensity;

        transmittance *= exp(-density * VL_FOG_STEP_SIZE);
    }
    
    outDensity /= VL_FOG_STEPS;

    float cloudCoverage = cloudShadows(worldPos, sunWorldDir);

    outDensity *= cloudCoverage;

    return outDensity;
}

vec3 volumetricFog(vec3 rayDir, vec3 worldPos, float maxDist, vec3 sunColor, vec3 fogColor, float density, float heightDensity) {

    vec3 scattering = vec3(0.0);
    float transmittance = 1.0;
    vec3 sunDir = normalize2(sunPosition);
    vec3 sunWorldDir = normalize2((gbufferModelViewInverse * vec4(sunPosition, 1.0)).xyz);

    vec2 UVs = worldToScreen(worldPos);

    for(int i = 0; i < VL_FOG_STEPS; i++) {
        float t = (float(i) + 0.5) / float(VL_FOG_STEPS);
        float dist = t * maxDist;

        vec3 samplePos = cameraPosition + rayDir * dist;
        float heightFactor = exp(-worldPos.y * heightDensity);

        float shadow = texture2D(colortex14, UVs).x;

        float phase = pow2(max(dot(rayDir, sunDir),0.0), 6.0);

        vec3 light = sunColor * shadow * phase;

        scattering += transmittance * light * density;

        transmittance *= exp(-density * VL_FOG_STEP_SIZE);
    }

    scattering /= VL_FOG_STEPS;
    
    float cloudCoverage = cloudShadows(worldPos, sunWorldDir);

    scattering *= cloudCoverage;

    return scattering;
}

#define FOG_LIGHT_SAMPLE_DIAMETER sqrt(FOG_LIGHT_SAMPLES)
#define FOG_LIGHT_SAMPLE_RADIUS (FOG_LIGHT_SAMPLE_DIAMETER/2.0)

#define FOG_LIGHT_SCREEN_RADIUS (1000.0/FOG_LIGHT_SAMPLE_RADIUS)

const vec2 normalizedScreenSize = vec2(1080.0/viewHeight * viewWidth, 1080.0);

vec3 calcFog(vec3 sceneColor, vec3 fogColor, vec3 sunColor, vec3 skyColor, float density, float heightDensity, vec3 viewPos, vec3 worldPos) {
    float dist = length(viewPos)/far;
    float heightFactor = exp(-worldPos.y * heightDensity);
    float fogFactor = 1.0 - exp(-fogDensity * heightFactor * dist);
    
    float detectSky = texture2D(colortex5, TexCoords).g;

    float noise = texture2D(noiseb, worldPos.xz * 0.001).r;
    fogFactor += noise * 0.2 - 0.1;

    float centerDepth = linearizeDepth(texture2D(depthtex0, TexCoords).r,near,far);

    float lightWorldRadius = FOG_LIGHT_SCREEN_RADIUS/(centerDepth * 1.5);

    vec3 lightColor = vec3(0.0);
    float lightStrength = 0.0;
    
    float lightWeight = 0.0;

    #if FOG_LIGHTING == 1
        for(int i = 0; i < FOG_LIGHT_SAMPLES; i++) {
            float idx = mod(i, FOG_LIGHT_SAMPLE_DIAMETER) - FOG_LIGHT_SAMPLE_RADIUS;
            float idy = mod(i/FOG_LIGHT_SAMPLE_DIAMETER, FOG_LIGHT_SAMPLE_DIAMETER) - FOG_LIGHT_SAMPLE_RADIUS;

            vec2 sampleOffset = vec2(idx, idy);
            vec2 i00 = lightWorldRadius * floor(sampleOffset)/normalizedScreenSize;
            vec2 i10 = lightWorldRadius * vec2(ceil(sampleOffset.x), floor(sampleOffset.y))/normalizedScreenSize;
            vec2 i01 = lightWorldRadius * vec2(floor(sampleOffset.x), ceil(sampleOffset.y))/normalizedScreenSize;
            vec2 i11 = lightWorldRadius * ceil(sampleOffset)/normalizedScreenSize;

            vec2 f = fract(sampleOffset);

            float sampleDepth = linearizeDepth(texture2D(depthtex0, TexCoords + lightWorldRadius * sampleOffset/normalizedScreenSize).r,near,far);

            if(sampleDepth > centerDepth) continue;
            
            vec3 c_00 = texture2D(colortex2, TexCoords + i00).rgb;
            float s_00 = texture2D(colortex14,TexCoords + i00).g;

            vec3 c_10 = texture2D(colortex2, TexCoords + i10).rgb;
            float s_10 = texture2D(colortex14,TexCoords + i10).g;

            vec3 c_01 = texture2D(colortex2, TexCoords + i01).rgb;
            float s_01 = texture2D(colortex14,TexCoords + i01).g;

            vec3 c_11 = texture2D(colortex2, TexCoords + i11).rgb;
            float s_11 = texture2D(colortex14,TexCoords + i11).g;

            vec3 cx_0 = mix2(c_00, c_10, f.x);
            vec3 cx_1 = mix2(c_01, c_11, f.x);

            float sx_0 = mix2(s_00, s_10, f.x);
            float sx_1 = mix2(s_01, s_11, f.x);

            vec3 colorSample = mix2(cx_0, cx_1, f.y);
            float strengthSample = mix2(sx_0, sx_1, f.y);

            float sampleWeight = max(1 - length(lightWorldRadius * sampleOffset/normalizedScreenSize)/1000.0,0.0);
            
            lightColor += colorSample;
            lightStrength += strengthSample;

            lightWeight += sampleWeight;
        }

        lightColor /= FOG_LIGHT_SAMPLES;
        lightStrength /= FOG_LIGHT_SAMPLES;

        fogFactor = mix2(fogFactor, DYNAMIC_FOG_LIGHT_STRENGTH, lightStrength);
    #endif

    //vec3 fogColorShift = mix2(fogColor, skyColor, clamp(dist, 0.0, 1.0));

    if(detectSky >= 1.0) fogFactor = mix2(smoothstep(0.25, 1.0, 1 - dot(Normal, vec3(0.0, 1.0, 0.0))), 1.0, mistwoodsFactor);

    vec3 fogLit = fogColor;

    if(!isBiomeWet) {
        vec3 viewDir = normalize2(viewPos);
        vec3 sunDir = normalize2(sunPosition);

        float viewDotSun = dot(viewDir, sunDir);
        
        float phase = pow2(0.5 + 0.5 * viewDotSun, 4.0);

        fogLit = mix2(fogColor, sunColor, phase * sunsetBlendFactor);

        //vec3 rayDir = viewDir;

        //vec3 fogSunColor = volumetricFog(rayDir, worldPos, far, sunColor, fogLit, density, heightDensity);

        //float fogSunDensity = volumetricDensity(rayDir, worldPos, far, density, heightDensity);

        //fogFactor = max(fogFactor, fogSunDensity);

        //fogLit = max(fogLit, fogSunColor);
    }

    #if FOG_LIGHTING == 1
        fogLit = mix2(fogLit, clamp(lightColor,0,1), smoothstep(0, 0.05, lightStrength));
    #endif
    
    return mix2(sceneColor, fogLit, fogFactor);
}