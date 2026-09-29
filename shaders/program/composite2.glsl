#ifdef FRAGMENT_SHADER
    #include "/lib/includes2.glsl"
    #include "/lib/optimizationFunctions.glsl"
    #include "/lib/data/settings.glsl"
    #include "/lib/colorFunctions.glsl"

    #define CLOUD_STYLE 1 // [0 1]
    #define BKG_CLOUDS 1 // [0 1]

    #define CLOUD_SPEED 1.0 // [0.25 0.5 0.75 1.0 1.25 1.5 1.75 2.0]
    #define CLOUD_PERMUTATION_SPEED 1.0 // [0.25 0.5 0.75 1.0 1.25 1.5 1.75 2.0]
    #define CLOUD_RESOLUTION_REDUCTION 10 // [1 2 4 10]

    uniform sampler2D colortex0;
    uniform sampler2D colortex1;
    uniform sampler2D colortex2;
    uniform sampler2D colortex5;
    uniform sampler2D colortex13;
    uniform sampler2D colortex16;
    uniform sampler2D colortex18;

    const bool colortex16Clear = false;
    const bool colortex18Clear = false;

    uniform sampler3D cSampler4;

    /*
        const bool colortex16MipmapEnabled = true;
    */

    /*
        const bool colortex18MipmapEnabled = true;
    */

    uniform float frameTimeCounter;
    uniform float frameTime;

    uniform sampler2D depthtex0;
    uniform sampler2D depthtex1;

    uniform sampler2D noiseb;
    uniform sampler2D cloudtex;

    uniform vec3 sunPosition;
    uniform vec3 cameraPosition;

    uniform float rainFactor;

    uniform mat4 gbufferPreviousModelView;
    uniform mat4 gbufferPreviousProjection;

    in vec2 texCoord;

    float linearDepth0;
    float linearDepth1;

    layout (rgba8) uniform image2D cimage9;

    uniform int viewWidth;
    uniform int viewHeight;

    highp float getDepthMask(sampler2D local, sampler2D distant) {
        #ifdef DISTANT_HORIZONS
            return mix2(linearDepth0 / dhFarPlane, texture2D(colortex13, texCoord).z * 0.5, step(1.0, texture2D(depthtex0, texCoord).x)) * 32;
        #elif defined VOXY
            return linearDepth0/far;
        #else
            return texture2D(depthtex0, texCoord).x;
        #endif
    }

    highp float getDepthMask1(sampler2D local, sampler2D distant) {
        #ifdef DISTANT_HORIZONS
            return mix2(linearDepth1 / dhFarPlane, texture2D(colortex13, texCoord).z * 0.5, step(1.0, texture2D(depthtex0, texCoord).x)) * 32;
        #elif defined VOXY
            return linearDepth1;
        #else
            return texture2D(depthtex0, texCoord).x;
        #endif
    }

    vec3 projectAndDivide(mat4 pm, vec3 p) {
        vec4 hp = pm * vec4(p, 1.0);
        return hp.xyz/hp.w;
    }

    mediump float random3D(in vec3 p) {
        return fract(sin(p.x*456.0+p.y*56.0+p.z*741.0)*100.0);
    }

    vec3 smoothUVs3D(in vec3 v) {
        return v*v*(3.0-2.0*v);
    }

    mediump float smooth_noise3D(in vec3 p) {
        vec3 f = smoothUVs3D(fract(p));
        mediump float a = random3D(floor(p));
        mediump float b = random3D(vec3(ceil(p.x),floor(p.y),floor(p.z)));
        mediump float c = random3D(vec3(floor(p.x),ceil(p.y),floor(p.z)));
        mediump float d = random3D(vec3(ceil(p.xy),floor(p.z)));

        mediump float bottom = mix2(mix2(a,b,f.x), mix2(c,d,f.x),f.y);

        mediump float a2 = random3D(vec3(floor(p.x),floor(p.y),ceil(p.z)));
        mediump float b2 = random3D(vec3(ceil(p.x),floor(p.y),ceil(p.z)));
        mediump float c2 = random3D(vec3(floor(p.x),ceil(p.y),ceil(p.z)));
        mediump float d2 = random3D(vec3(ceil(p.xy),ceil(p.z)));

        mediump float top = mix2(mix2(a2,b2,f.x), mix2(c2,d2,f.x),f.y);

        return mix2(bottom, top, f.z);
    }

    mediump float fractal_noise3D(in vec3 p) {
        mediump float total = 0.5;
        mediump float amplitude = 1.0;
        mediump float frequency = 1.0;
        mediump float iterations = 4.0;
        for(float i = 0; i < iterations; i++) {
            total += (smooth_noise3D(p * frequency) - 0.5)*amplitude;
            amplitude *= 0.5;
            frequency *= 2.0;
        }
        return total;
    }

    mediump float get_cloud(vec3 p) {
        return clamp((fractal_noise3D(p) * fractal_noise3D(p * 0.1) * fractal_noise3D(p * 0.3) * (1.0 - (0.3 * (1.0 - rainFactor)))*4 - 0.5) * 1.5 + 0.5, 0.0, 1.0);
    }

    uniform bool isBiomeEnd;
    uniform float seFactor;
    uniform float corruptionFactor;
    uniform float dryFactor;

    vec3 cloudLight;
    vec3 cloudAmbience;

    vec3 sunlightAlbedo;

    vec3 skyInfluenceColor;

    float lightIntensity;

    mediump float timeBlendFactor;

    #include "/lib/world/clouds.glsl"
    
    void noonFunc(float time, float timeFactor) {
        vec3 sunlightAlbedoSE = vec3(LIGHT_SE_R, LIGHT_SE_G, LIGHT_SE_B);
        vec3 sunlightAlbedoCorruption = vec3(LIGHT_SE_R, LIGHT_SE_G, LIGHT_SE_B);
        #ifdef TEMPERATURE_COLOR
            sunlightAlbedo = colorTemperatureToRGB(SUN_TEMP);
        #else
            sunlightAlbedo = vec3(LIGHT_DAY_R, LIGHT_DAY_G, LIGHT_DAY_B);
        #endif
        sunlightAlbedo = mix2(sunlightAlbedo, sunlightAlbedoSE, seFactor);
        sunlightAlbedo = mix2(sunlightAlbedo, sunlightAlbedoCorruption, corruptionFactor);
        mediump float dayNightLerp = timeFactor;
        cloudLight = vec3(VL_COLOR_R, VL_COLOR_G, VL_COLOR_B);
        cloudAmbience = vec3(AMBIENT_LIGHT_R, AMBIENT_LIGHT_G, AMBIENT_LIGHT_B);
        skyInfluenceColor = vec3(SKY_DAY_A_R, SKY_DAY_A_G, SKY_DAY_A_B);
        lightIntensity = LIGHT_DAY_I;
        timeBlendFactor = 0.0;
    }

    void sunsetFunc(float time, float timeFactor) {
        mediump float sunsetLerp = timeFactor;
        vec3 sunlightAlbedoSE = vec3(LIGHT_SE_R, LIGHT_SE_G, LIGHT_SE_B);
        vec3 sunlightAlbedoCorruption = vec3(LIGHT_SE_R, LIGHT_SE_G, LIGHT_SE_B);
        #ifdef TEMPERATURE_COLOR
            sunlightAlbedo = mix3(colorTemperatureToRGB(SUN_TEMP), colorTemperatureToRGB(SUNSET_TEMP), colorTemperatureToRGB(MOON_TEMP), sunsetLerp, 0.5);
        #else
            sunlightAlbedo = mix3(vec3(LIGHT_DAY_R, LIGHT_DAY_G, LIGHT_DAY_B), vec3(LIGHT_SUNSET_R, LIGHT_SUNSET_G, LIGHT_SUNSET_B), vec3(LIGHT_NIGHT_R, LIGHT_NIGHT_G, LIGHT_NIGHT_B), sunsetLerp, 0.5);
        #endif
        sunlightAlbedo = mix2(sunlightAlbedo, sunlightAlbedoSE, seFactor);
        sunlightAlbedo = mix2(sunlightAlbedo, sunlightAlbedoCorruption, corruptionFactor);
        cloudLight = mix3(vec3(VL_COLOR_R, VL_COLOR_G, VL_COLOR_B), vec3(AMBIENT_LIGHT_R, AMBIENT_LIGHT_G, AMBIENT_LIGHT_B), vec3(CLOUD_AMBIENCE_R, CLOUD_AMBIENCE_G, CLOUD_AMBIENCE_B), sunsetLerp, 0.5);
        cloudAmbience = mix2(vec3(AMBIENT_LIGHT_R, AMBIENT_LIGHT_G, AMBIENT_LIGHT_B), vec3(CLOUD_AMBIENCE_R, CLOUD_AMBIENCE_G, CLOUD_AMBIENCE_B), sunsetLerp);
        #ifdef TEMPERATURE_COLOR
            skyInfluenceColor = mix3(vec3(SKY_DAY_A_R, SKY_DAY_A_G, SKY_DAY_A_B), vec3(SKY_SUNSET_A_R, SKY_SUNSET_A_G, SKY_SUNSET_A_B), colorTemperatureToRGB(NIGHT_SKY_TEMP), sunsetLerp, 0.5);
        #else
            skyInfluenceColor = mix3(vec3(SKY_DAY_A_R, SKY_DAY_A_G, SKY_DAY_A_B), vec3(SKY_SUNSET_A_R, SKY_SUNSET_A_G, SKY_SUNSET_A_B), vec3(SKY_NIGHT_A_R, SKY_NIGHT_A_G, SKY_NIGHT_A_B), sunsetLerp, 0.5);
        #endif
        lightIntensity = mix2(LIGHT_DAY_I, LIGHT_NIGHT_I, sunsetLerp);
        timeBlendFactor = sunsetLerp;
    }

    void nightFunc(float time, float timeFactor) {
        vec3 sunlightAlbedoSE = vec3(LIGHT_SE_R, LIGHT_SE_G, LIGHT_SE_B);
        vec3 sunlightAlbedoCorruption = vec3(LIGHT_SE_R, LIGHT_SE_G, LIGHT_SE_B);
        #ifdef TEMPERATURE_COLOR
            sunlightAlbedo = colorTemperatureToRGB(MOON_TEMP);
        #else
            sunlightAlbedo = vec3(LIGHT_NIGHT_R, LIGHT_NIGHT_G, LIGHT_NIGHT_B);
        #endif
        sunlightAlbedo = mix2(sunlightAlbedo, sunlightAlbedoSE, seFactor);
        sunlightAlbedo = mix2(sunlightAlbedo, sunlightAlbedoSE, seFactor);
        sunlightAlbedo = mix2(sunlightAlbedo, sunlightAlbedoCorruption, corruptionFactor);
        mediump float dayNightLerp = timeFactor;
        cloudLight = vec3(CLOUD_AMBIENCE_R, CLOUD_AMBIENCE_G, CLOUD_AMBIENCE_B);
        cloudAmbience = vec3(CLOUD_AMBIENCE_R, CLOUD_AMBIENCE_G, CLOUD_AMBIENCE_B);
        #ifdef TEMPERATURE_COLOR
            skyInfluenceColor = colorTemperatureToRGB(NIGHT_SKY_TEMP);
        #else
            skyInfluenceColor = vec3(SKY_NIGHT_A_R, SKY_NIGHT_A_G, SKY_NIGHT_A_B);
        #endif
        lightIntensity = LIGHT_NIGHT_I;
        timeBlendFactor = 1.0;
    }

    void dawnFunc(float time, float timeFactor) {
        mediump float sunsetLerp = timeFactor;
        //if(worldTime <= 500) sunsetLerp = smoothstep(-500.0, 500.0, worldTime);
        vec3 sunlightAlbedoSE = vec3(LIGHT_SE_R, LIGHT_SE_G, LIGHT_SE_B);
        vec3 sunlightAlbedoCorruption = vec3(LIGHT_SE_R, LIGHT_SE_G, LIGHT_SE_B);
        #ifdef TEMPERATURE_COLOR
            sunlightAlbedo = mix3(colorTemperatureToRGB(MOON_TEMP), colorTemperatureToRGB(SUNSET_TEMP), colorTemperatureToRGB(SUN_TEMP), sunsetLerp, 0.5);
        #else
            sunlightAlbedo = mix3(vec3(LIGHT_NIGHT_R, LIGHT_NIGHT_G, LIGHT_NIGHT_B), vec3(LIGHT_SUNSET_R, LIGHT_SUNSET_G, LIGHT_SUNSET_B), vec3(LIGHT_DAY_R, LIGHT_DAY_G, LIGHT_DAY_B), sunsetLerp, 0.5);
        #endif
        sunlightAlbedo = mix2(sunlightAlbedo, sunlightAlbedoSE, seFactor);
        sunlightAlbedo = mix2(sunlightAlbedo, sunlightAlbedoCorruption, corruptionFactor);
        sunlightAlbedo = mix2(sunlightAlbedo, sunlightAlbedoSE, seFactor);
        cloudLight = mix3(vec3(CLOUD_AMBIENCE_R, CLOUD_AMBIENCE_G, CLOUD_AMBIENCE_B), vec3(AMBIENT_LIGHT_R, AMBIENT_LIGHT_G, AMBIENT_LIGHT_B), vec3(VL_COLOR_R, VL_COLOR_G, VL_COLOR_B), sunsetLerp, 0.5);
        cloudAmbience = mix2(vec3(CLOUD_AMBIENCE_R, CLOUD_AMBIENCE_G, CLOUD_AMBIENCE_B), vec3(AMBIENT_LIGHT_R, AMBIENT_LIGHT_G, AMBIENT_LIGHT_B), sunsetLerp);
        #ifdef TEMPERATURE_COLOR
            skyInfluenceColor = mix3(colorTemperatureToRGB(NIGHT_SKY_TEMP), vec3(SKY_SUNSET_A_R, SKY_SUNSET_A_G, SKY_SUNSET_A_B), vec3(SKY_DAY_A_R, SKY_DAY_A_G, SKY_DAY_A_B), sunsetLerp, 0.5);
        #else
            skyInfluenceColor = mix3(vec3(SKY_NIGHT_A_R, SKY_NIGHT_A_G, SKY_NIGHT_A_B), vec3(SKY_SUNSET_A_R, SKY_SUNSET_A_G, SKY_SUNSET_A_B), vec3(SKY_DAY_A_R, SKY_DAY_A_G, SKY_DAY_A_B), sunsetLerp, 0.5);
        #endif
        lightIntensity = mix2(LIGHT_NIGHT_I, LIGHT_DAY_I, sunsetLerp);
        timeBlendFactor = 1 - sunsetLerp;
    }

    #include "/lib/world/timeCycle.glsl"


    /* RENDERTARGETS: 16,18 */
    layout(location = 0) out vec4 outclouds;
    layout(location = 1) out vec4 outcave;

    void main() {
        timeFunctionFrag();
        vec3 color = pow2(texture2D(colortex0, texCoord).rgb,vec3(GAMMA));
        mediump float depth = texture2D(depthtex0, texCoord).r;
        mediump float depth2 = texture2D(depthtex1, texCoord).r;
        mediump float depth3 = getDepthMask1(depthtex1, colortex13);

        mediump vec4 texBuffer5 = texture2D(colortex5, texCoord);

        vec3 sunWorldPos = mat3(gbufferModelViewInverse) * sunPosition;
        vec3 sunWorldDir = normalize2(sunWorldPos);

        vec4 pos = vec4(texCoord, depth, 1.0) * 2 - 1;
        pos.xyz = projectAndDivide(gbufferProjectionInverse, pos.xyz);
        vec3 viewPos = pos.xyz;
        pos = gbufferModelViewInverse * vec4(pos.xyz, 1.0);
        vec3 footPos = pos.xyz;
        vec3 worldPos = footPos + cameraPosition;

        mediump float detectSky = texBuffer5.g;
        
        vec3 rayDir = normalize2(pos.xyz);
        float rayY = rayDir.y >= 0.0 ? max(rayDir.y, 0.001) : min(rayDir.y, -0.001);

        vec3 last_world_pos_dir = footPos;

        vec4 old_raydir;

        float cloudTime = frameTimeCounter * CLOUD_SPEED;

        vec2 uv = (rayDir.xz*1/rayY) * (CLOUD_HEIGHT/50) + 0.05 * cloudTime + cameraPosition.xz/CLOUD_HEIGHT;
        //vec2 uv2 = rayDir.xz*1/rayY - frameTimeCounter * CLOUD_PERMUTATION_SPEED * 0.05;

        float inCave = mix2(texture2D(colortex18, texCoord).r, texture3D(cSampler4, vec3(0.5)).r, 1.0 - exp(5 * frameTime));
        outcave = vec4(vec3(inCave), 1.0);

        vec3 p = vec3(uv, 0);

        //p.xy -= cloud_time;
        //p.xy = fract(p.xy);

        vec4 clouds = vec4(vec3(1.0),0.0);
        float cloudScale = 0.1;

        float cloudShadingAmount = 0.1;
        float sun_dot = clamp(dot(rayDir, sunWorldDir),0,1);

        float sunset_effect = pow2(1.0 - sunWorldDir.y, 10.0);
        vec3 sun_color = (sunWorldDir.y < 0.5? vec3(1.0) : vec3(0.5, 0.5, 0.7)) * (1.0 - vec3(1.0,1.2,1.3)*sunset_effect);
        
        vec4 clouds2 = vec4(0.0);

        vec3 light = vec3(0.0);

        float cloudShadows = 0.0;
        
        vec3 color2 = color.rgb;

        vec4 finalLight3 = vec4(0.0);

        vec4 lightColorTex = texture2D(colortex2, texCoord);

        //vec3 decodedLight = decodeLight(lightColorTex.xyz,MAX_LIGHT);
        
        #if CLOUD_STYLE == 1
            //clouds = renderVolumetricClouds(p, rayDir, sunWorldPos, cloud_time);
            if(rayDir.y > 0.0) {
                vec3 player = vec3(uv, 0.0);
                //vec3 player2 = vec3(uv2, 0);
                for(float i = 0; i < CLOUD_STEPS; i++) {
                    vec3 ray_pos = player + rayDir*(i-random3D(vec3(texCoord,i))*0.0025)*cloudScale;
                    //ray_pos *= mix2(CLOUD_BASE, CLOUD_TOP, i/CLOUD_STEPS) * 0.005;
                    vec4 cloud = vec4(get_cloud(ray_pos));
                    //cloud.rgba *= 0.65 * (1 - rainFactor) + 0.35;
                    //cloud.rgba = clamp(cloud.rgba, 0, 1);
                    //if(cloud.a <= 0.0) continue;
                    cloud.rgb = vec3(1.0);

                    vec3 ray_s_pos = ray_pos;

                    vec3 lightAmount = sunlightAlbedo;
                    float cloud_top = player.y + CLOUD_STEPS;
                    for(float s = 0; s < 5.0 && ray_s_pos.y < cloud_top; s++) {
                        ray_s_pos = ray_pos + sunWorldDir*(s-random3D(vec3(texCoord,s))*0.0025)*cloudScale;

                        float cloud_shading = pow2(get_cloud(ray_s_pos),1.0);
                        lightAmount *= 1.0 - cloud_shading * vec3(1.1, 1.2, 1.3);
                    }

                    lightAmount += light.r * pow2(sun_dot,1.0+20.0*(light.r));

                    vec3 sky_color_final = skyInfluenceColor;
            
                    for(float s = 0; s < 3.0; s++) {
                        ray_s_pos = ray_pos + vec3(0, 1, 0)*(s-random3D(vec3(texCoord,s))*0.0025)*cloudScale;

                        float cloud_shading = pow2(get_cloud(ray_s_pos),2.0);
                        //lightAmount *= 1.0 - cloud_shading;
                        sky_color_final *= 1.0 - cloud_shading * vec3(1.1, 1.2, 1.3);
                    }
                    //lightAmount += lightAmount.r*pow2(sun_dot,1.0+20.0*lightAmount.r) * (1 - rainFactor);
                    //cloud.a = mix2(cloud.a, pow2(cloud.a, 0.75), rainFactor * timeBlendFactor);
                    //cloud.rgb *= (lightAmount*(0.25 + 0.75 * (1 - rainFactor))+skyInfluenceColor * 0.5 + vec3(AMBIENT_LIGHT_R, AMBIENT_LIGHT_G, AMBIENT_LIGHT_B) * 0.75) * max(rainFactor, 1 - max(seFactor, timeBlendFactor) * 0.75);
                    //cloud = mix2(cloud, pow2(cloud, vec4(0.75)), rainFactor);
                    cloud.rgb *= clamp(lightAmount + sky_color_final*0.5 + 0.4 * skyInfluenceColor, 0.0, 1.0);

                    clouds.rgb = mix2(clouds.rgb, cloud.rgb, (1.0 - clouds.a) * cloud.a);
                    clouds.a = clamp(cloud.a + (1.0 - clouds.a) * cloud.a, 0, 1);
                }
                //clouds.a = smoothstep(0.4 * (1 - rainFactor), 0.6 + 0.4 * rainFactor, clouds.a);
                //clouds.a = pow2(clouds.a, 0.25);
                //clouds.a = clamp(clouds.a, 0, 1);
                //clouds.rgb = vec3(1.0);
                //clouds.rgb *= 1.0 - clamp(clouds.a - 0.5, 0.0, 0.25);
                clouds.rgb *= mix2(vec3(1.0), vec3(AMBIENT_LIGHT_R, AMBIENT_LIGHT_G, AMBIENT_LIGHT_B) * 0.65, timeBlendFactor);
            } else {
                clouds = vec4(0.0);
            }
            //float cloudFog = 1/rayY;
        #endif

        /*#if BKG_CLOUDS == 1
            clouds2 = renderBackgroundClouds_experimental(p, rayDir, sunWorldPos, cloudTime);

            clouds = mix2(clouds2, clouds, smoothstep(0, 0.1, clouds.a));
        #endif*/

        //imageStore(cimage9, ivec2(texCoord * vec2(viewWidth, viewHeight)/CLOUD_RESOLUTION_REDUCTION), clouds);

        old_raydir.xyz = (gbufferPreviousModelView * vec4(last_world_pos_dir, 1.0)).xyz;
        old_raydir = gbufferPreviousProjection * vec4(old_raydir.xyz, 1.0);
        float sz = old_raydir.z;
        old_raydir.xyz /= old_raydir.w;
        old_raydir.xyz = old_raydir.xyz * 0.5 + 0.5;

        vec4 ray_color;

        if(old_raydir.x >= 0 && old_raydir.x < 1.0 && old_raydir.y >= 0 && old_raydir.y <= 1.0 && sz > 0) {
            ray_color = texture2D(colortex16, old_raydir.xy);
        } else {
            ray_color = clouds;
        }

        outclouds = mix2(clouds, ray_color, 0.25);

        //outcolor = vec4(pow2(color,vec3(1/GAMMA)), 1.0);
    }
#endif

#ifdef VERTEX_SHADER
    out vec2 texCoord;

    #include "/lib/world/timeCycle.glsl"

    void main() {
        gl_Position = ftransform();
        texCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;

        timeFunctionVert();
    }
#endif