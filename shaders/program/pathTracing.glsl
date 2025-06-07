#if PATH_TRACING_GI == 1
    #ifdef VERTEX_SHADER
        vec3 GenerateLightmap(in float sunlight, in float blocklight) {
            /*if(mc_Entity.x == 10005) {
                return vec3(blocklight,0,0);
            }
            if(mc_Entity.x == 10006) {
                return vec3(-blocklight,0,0);
            }
            if(mc_Entity.x == 10007) {
                return vec3(0,blocklight,0);
            }
            if(mc_Entity.x == 10008) {
                return vec3(0,-blocklight,0);
            }
            if(mc_Entity.x == 10009) {
                return vec3(0,0,blocklight);
            }
            if(mc_Entity.x == 10010) {
                return vec3(0,0,-blocklight);
            }*/
            if(mc_Entity.x >= 10005 && mc_Entity.x <= 10010) {
                return vec3(blocklight);
            }
            return vec3(0f);
        }
    #endif
    #ifdef FRAGMENT_SHADER
        struct Ray {
            vec3 origin;
            vec3 direction;
        };

        bool checkBlockHit(in Ray ray, in vec3 Normal, float isWater) {
            if(dot(ray.direction, Normal) < 1.0) {
                return true;
            }
            return false;
        }
        
        vec3 traceRay(in Ray ray, in vec2 lightmap, in vec3 Normal, in float albedoAlpha) {
            vec3 color = vec3(0.0);
            vec3 attenuation = vec3(1.0);
            if(lightmap.x > 0f) {
                attenuation = vec3(500.0);
            }

            const vec3 TorchColor = vec3(1.0f, 0.25f, 0.08f);
            const vec3 GlowstoneColor = vec3(1.0f, 0.85f, 0.5f);
            const vec3 LampColor = vec3(1.0f, 0.75f, 0.4f);
            const vec3 LanternColor = vec3(0.8f, 1.0f, 1.0f);
            const vec3 RedstoneColor = vec3(1.0f, 0.0f, 0.0f);
            const vec3 RodColor = vec3(1.0f, 1.0f, 1.0f);
            vec3 SkyColor = vec3(0.05f, 0.15f, 0.3f);

            int maxBounces = 5;

            bool blockHitCheck = true;
            for (int bounce = 0; bounce < maxBounces; ++bounce) {
                if(blockHitCheck) {
                    blockHitCheck = checkBlockHit(ray, Normal, albedoAlpha);
                    // Simulate ray-scene intersection (replace with actual intersection logic)
                    mediump float t = 0.5 * (1.0 + ray.direction.y);
                    vec3 hitColor = mix2(vec3(1.0, 1.0, 1.0), vec3(0.5, 0.7, 1.0), t);
                    
                    // Update color based on intersection
                    vec3 lightmapColor = SkyColor;

                    /*if(lightmap.x > 0f) {
                        lightmapColor = TorchColor;
                    }*/
                    color += attenuation * lightmapColor * hitColor;

                    // Update attenuation (e.g., based on material properties)
                    if(lightmap.x > 0f) {
                        attenuation *= 0.8f;
                    } else {
                        attenuation *= 0.1;
                    }

                    // Generate new ray direction (replace with actual reflection/refraction logic)
                    ray.origin = ray.origin + t * ray.direction;
                    ray.direction = normalize2(reflect(ray.direction, vec3(0.0, 1.0, 0.0)));
                }
            }

            return color;
        }
    #endif
#endif

#if RAY_TRACED_SHADOWS == 1
    #define RT_SHADOW_SAMPLES 64
    #ifdef FRAGMENT_SHADER
        bool intersect(vec3 origin, vec3 dir, vec3 solidTex) {
            vec3 oc = origin - solidTex;
            mediump float b = dot(oc, dir);
            mediump float c = dot(oc, oc);
            mediump float h = b * b - c;
            if(h > 0.0) {
                return true;
            }
            return false;
        }

        bool isShadowed(vec3 lightDir, vec3 fragPos, vec2 UVs) {
            for(int i = 0; i < RT_SHADOW_SAMPLES; i++) {
                vec2 shiftedUVs = UVs * 2 - 1;
                shiftedUVs += vec2(1.0/RT_SHADOW_SAMPLES * i);
                vec3 solidTex = texture2D(colortex10,shiftedUVs).rgb;
                if(intersect(fragPos, lightDir, solidTex)) {
                    return true;
                }
            }
            return false;
        }

        vec3 computeShadows(vec3 lightDir, vec3 ambientLight, vec3 normal, vec3 fragPos) {
            vec3 color = ambientLight;
            if(!isShadowed(lightDir, fragPos, fragPos.xy)) {
                mediump float diff = max(dot(normal, lightDir), 0.0);
                color += vec3(diff);
            }
            return clamp(color, 0.0, 1.0);
        }
    #endif
#endif