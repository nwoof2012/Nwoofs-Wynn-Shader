uniform int isEyeInWater;

vec3 isInWater(sampler2D mainTex, vec3 color, vec2 coord, vec2 distortionAmount, float colorFactor) {
    if(isEyeInWater != 1) {
        return texture2D(mainTex, coord).rgb;
    }

    vec3 underwaterColor = texture2D(mainTex, coord + distortionAmount).rgb;
    underwaterColor = mix2(underwaterColor, color, colorFactor);
    return underwaterColor;
}

mediump float linearWaterDepth(float depth, float near, float far) {
    return (near * far) / (depth * (near - far) + far);
}

vec3 waterShading(vec2 coords, sampler2D noiseTex, vec3 worldPos) {
    vec3 waterColor = vec3(0.0f, 0.2f, 0.22f);
    mediump float isRain = texture2D(colortex3, TexCoords).r;
    vec2 refractionFactor = vec2(0);
    vec2 TexCoords2 = coords;
    float underwaterDepth = linearWaterDepth(texture2D(depthtex0, coords).x,near,far);
    float underwaterDepth2 = linearWaterDepth(texture2D(depthtex1, coords).x,near,far);
    
    #ifdef WATER_REFRACTION
        if(isRain == 1.0) {
            float noiseA = triplanarTexture(fract((worldTexCoords + ((frameCounter)/90f)*0.5f) * 0.035f), texture2D(colortex1, TexCoords).xyz, noiseTex, 1.0);
            float noiseB = triplanarTexture(fract((worldTexCoords - ((frameCounter)/90f)*0.5f) * 0.035f), texture2D(colortex1, TexCoords).xyz, noiseTex, 1.0);
            refractionFactor = sin(noise.y) * vec2(0.03125f) / max( distanceFromCamera*2f,1);
            TexCoords2 += refractionFactor;
            underwaterDepth = linearWaterDepth(texture2D(depthtex0, TexCoords2).x,near,far);
            underwaterDepth2 = linearWaterDepth(texture2D(depthtex1, TexCoords2).x,near,far);
        }
    #endif

    if(underwaterDepth >= 1.0) {
        waterColor = vec3(0.0f, 0.2f, 0.22f);
        return pow2(clamp(mix2(texture2D(colortex0, TexCoords2).rgb,waterColor,0.85),vec3(0.0f, 0.0f, 0.0f),(texture2D(colortex0, TexCoords2).rgb/0.2 * 0.15) + (waterColor*0.85)), vec3(GAMMA));
    }

    return pow2(mix2(texture2D(colortex0, TexCoords2).rgb,waterColor,clamp(1 - (underwaterDepth2 - underwaterDepth) * 0.125f,0,0.5)), vec3(GAMMA));
}