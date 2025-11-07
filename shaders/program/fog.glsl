vec3 calcFogColor(vec3 viewDir, vec3 sunPos, vec3 albedo, vec3 fogColor, vec3 sunColor, float factor) {
    float viewDotSun = dot(normalize2(viewDir), normalize2(sunPos));
    float phase = 0.5 + pow2(1.5 - viewDotSun, 2.0);
    vec3 fog = mix2(fogColor, sunColor, sunPos.y);
    return mix2(albedo, fogColor, clamp(factor * phase,0,min(fogIntensity,1.0)));
}