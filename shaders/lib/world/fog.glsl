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

vec3 calcFog(vec3 sceneColor, vec3 fogColor, vec3 sunColor, vec3 skyColor, float density, float heightDensity, vec3 viewPos, vec3 worldPos) {
    float dist = length(viewPos)/far;
    float heightFactor = exp(-worldPos.y * heightDensity);
    float fogFactor = 1.0 - exp(-fogDensity * heightFactor * dist);
    
    float detectSky = texture2D(colortex5, TexCoords).g;

    float noise = texture2D(noiseb, worldPos.xz * 0.001).r;
    fogFactor += noise * 0.2 - 0.1;

    if(detectSky >= 1.0 && isBiomeWet) fogFactor = 1.0;

    vec3 fogColorShift = mix2(fogColor, skyColor, clamp(dist, 0.0, 1.0));

    vec3 fogLit = fogColor;

    if(!isBiomeWet) {
        vec3 viewDir = normalize2(viewPos);
        vec3 sunDir = normalize2(sunPosition);

        float viewDotSun = dot(viewDir, sunDir);
        
        float phase = pow2(0.5 + 0.5 * viewDotSun, 4.0);

        fogLit = mix2(fogColor, sunColor, phase * sunsetBlendFactor);
    }
    
    return mix2(sceneColor, fogLit, fogFactor);
}