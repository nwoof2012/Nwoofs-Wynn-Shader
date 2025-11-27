#ifdef SCENE_AWARE_LIGHTING
    vec3 calcLighting(vec3 Albedo, vec3 LightmapColor, int isDistant, float minLight, float maxLight, vec3 foot_pos, vec3 shadowLerp) {
        vec3 rawLight = LightmapColor;
        if(maxLight < 4.1f) {
            float lightMagnitude = length(LightmapColor);
            lightMagnitude = clamp(lightMagnitude, minLight, maxLight);
            LightmapColor = clamp(LightmapColor, vec3(0.0),normalize2(LightmapColor) * lightMagnitude);
        }

        vec3 Normal = texture2D(colortex1, TexCoords).xyz * 2 - 1;
        
        float aoValue = calcAO(TexCoords, foot_pos, 100, depthtex0, colortex1);

        if(isDistant == 1) shadowLerp = vec3(1.0);
        
        vec3 worldSpaceSunPos = (gbufferModelViewInverse * vec4(sunPosition,1.0)).xyz;
        mediump float NdotL = max(dot(Normal, normalize2(worldSpaceSunPos)), 0.2f);

        vec3 Diffuse3 = mix2(Albedo * (LightmapColor + NdotL * shadowLerp + Ambient) * aoValue,Albedo * (NdotL * shadowLerp + Ambient) * aoValue,0.25);
        Diffuse3 = mix2(Diffuse3, LightmapColor*0.025, clamp(pow2(smoothstep(MIN_LIGHT, 1.0, length(rawLight)) * 0.5,1.75),0,0.125));

        return Diffuse3;
    }
#endif