#if defined FRAGMENT_SHADER && defined COMPOSITE_3
    #if LIGHTING_MODE > 0
        vec3 calcLighting(vec3 Albedo, vec4 LightmapColor, int isDistant, float minLight, float maxLight, vec3 foot_pos, vec3 shadowLerp, float timeBlendFactor) {
            vec3 rawLight = LightmapColor.xyz;

            vec3 Normal = texture2D(colortex1, TexCoords).xyz * 2 - 1;
            
            float aoValue = 1.0;
            #ifdef AO
                if(isDistant == 1) aoValue = DHcalcAO(TexCoords, foot_pos, 25, colortex6, colortex1);
                else aoValue = calcAO(TexCoords, foot_pos, 25, depthtex0, colortex1);
            #endif

            if(isDistant == 1) {
                shadowLerp = vec3(1.0 - timeBlendFactor);
                LightmapColor.xyz *= mix2(1.0, 0.5, timeBlendFactor);
            }
            
            vec3 worldSpaceSunPos = (gbufferModelViewInverse * vec4(sunPosition,1.0)).xyz;
            mediump float NdotL = max(dot(Normal, normalize2(worldSpaceSunPos)), 0.2f);

            vec3 worldPos = screenToFoot(TexCoords,texture2D(depthtex0, TexCoords).x);
            vec3 dirFromSun = normalize2(abs(worldSpaceSunPos - 3.5) - abs(worldPos - 3.5));
            
            float sunDist = smoothstep(0.2, 0.5, dirFromSun.b);

            float aoLight = MIN_LIGHT * mix2(1.0, 0.01, timeBlendFactor);
            
            LightmapColor.xyz = mix2(LightmapColor.xyz, vec3(AMBIENT_LIGHT_R,AMBIENT_LIGHT_G,AMBIENT_LIGHT_B)*aoLight, 1 - aoValue);

            vec3 Diffuse3 = mix2(Albedo * (LightmapColor.xyz*4 + NdotL * shadowLerp + Ambient),Albedo * (NdotL * shadowLerp + Ambient),0.25);
            Diffuse3 = mix2(Diffuse3, LightmapColor.xyz*0.025, clamp(pow2(smoothstep(MIN_LIGHT, 1.0, length(LightmapColor)) * 0.5,1.75),0,0.125));
            //vec3 Diffuse4 = mix2(Albedo, vec3(VL_COLOR_R, VL_COLOR_G, VL_COLOR_B) * 0.1,clamp(sunDist, 0, 0.75));

            //Diffuse3 = mix2(Diffuse3, Diffuse4, clamp(sunDist, 0, 0.75));

            return Diffuse3;
        }
    #endif
#elif defined FRAGMENT_SHADER && defined COMPOSITE_2
    #define FLICKER_INTENSITY 0.01
    #define FLICKER_SPEED 0.06

    vec3 calcRim(vec3 viewDir, vec3 normal, vec3 worldColor, vec3 rimTint) {
        float normalViewDir = dot(normal, viewDir);
        float rim = smoothstep(0.8,1.1,pow2(1 - clamp(1 + normalViewDir, 0, 1),0.5));
        return mix2(worldColor, rimTint, rim);
    }
    vec3 calcSpec(vec3 viewDir, vec3 lightDir, vec3 normal, vec3 worldColor, vec3 specTint, float specIntensity) {
        float normalViewDir = dot(viewDir + lightDir, normal);
        float gloss = smoothstep(0.75,1.1,pow2(1 - normalViewDir, 0.5)) * specIntensity;
        return mix2(worldColor, specTint, gloss);
    }

    float specFactor(vec3 viewPos, vec3 lightPos, vec3 normal, float shine, float intensity) {
        vec3 R = reflect(lightPos, normal);

        float spec = pow2(max(dot(viewPos, R),0.0),shine);

        return spec * intensity;
    }
    
    vec3 lightFlicker(vec3 light) {
        vec2 lightUVs = vec2(frameTimeCounter * FLICKER_SPEED);
        vec2 lightNoise = vec2(texture2D(randnoisea, texCoord + lightUVs).r, texture2D(randnoiseb, texCoord + lightUVs).r);
        return light * (1 - mix2(lightNoise.x, lightNoise.y, fract(lightUVs.x)) * FLICKER_INTENSITY);
    }
#endif