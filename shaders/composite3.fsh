#version 460 compatibility

#define CLOUD_STYLE 1 // [0 1]
#define CLOUD_FOG 0.5 // [0.0 0.25 0.5 0.75 1.0]
#define CLOUD_DENSITY 0.5 // [0.0 0.25 0.5 0.75 1.0 1.25 1.5 1.75 2.0]
#define CLOUD_DENSITY_RAIN 0.75 // [0.0 0.25 0.5 0.75 1.0 1.25 1.5 1.75 2.0]
#define CLOUD_SAMPLES 10.0 // [10.0 20.0 30.0 40.0 50.0 100.0]
#define CLOUD_SPEED 1.0 // [0.25 0.5 0.75 1.0 1.25 1.5 1.75 2.0]

#define CLOUD_SHADING_SAMPLES 2.0 // [2.0 3.0 4.0 5.0]
#define CLOUD_SHADING_DISTANCE 128.0 // [32.0 64.0 96.0 128.0 160.0 192.0 224.0 256.0]

#define CLOUD_RESOLUTION_REDUCTION 4 // [1 2 4 10]

precision mediump float;

uniform float frameTimeCounter;
uniform float frameTime;
uniform int worldTime;

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D colortex3;
uniform sampler2D colortex4;
uniform sampler2D colortex5;
uniform sampler2D colortex6;
uniform sampler2D colortex10;
uniform sampler2D colortex12;
uniform sampler2D colortex13;
uniform sampler2D colortex14;
uniform sampler2D depthtex0;
uniform sampler2D noisetex;
uniform mat4 gbufferPreviousModelView;
uniform mat4 gbufferPreviousProjection;
uniform mat4 gbufferPreviousModelViewInverse;
uniform mat4 gbufferPreviousProjectionInverse;

uniform sampler2D cSampler9;

layout (rgba8) uniform image2D cimage9;

uniform float rainStrength;
uniform vec3 sunPosition;

uniform float viewWidth;
uniform float viewHeight;

uniform vec3 shadowLightPosition;
uniform vec3 cameraPosition;

in vec2 texCoord;

uniform sampler2D noiseb;

uniform sampler2D cloudtex;

uniform float near;
uniform float far;

uniform float dhFarPlane;

#include "lib/globalDefines.glsl"
#include "lib/includes2.glsl"
#include "lib/optimizationFunctions.glsl"
#include "program/blindness.glsl"

#include "lib/buffers.glsl"

#include "program/gaussianBlur.glsl"

vec3 projectAndDivide(mat4 pm, vec3 p) {
    vec4 hp = pm * vec4(p, 1.0);
    return hp.xyz/hp.w;
}

mediump float random(in vec2 p) {
    return fract(sin(p.x*456.0+p.y*56.0)*100.0);
}

mediump float random3D(in vec3 p) {
    return fract(sin(p.x*456.0+p.y*56.0+p.z*741.0)*100.0);
}

vec2 smoothUVs(in vec2 v) {
    return v*v*(3.0-2.0*v);
}

vec3 smoothUVs3D(in vec3 v) {
    return v*v*(3.0-2.0*v);
}


mediump float smooth_noise(in vec2 p) {
    vec2 f = smoothUVs(fract(p));
    mediump float a = random(floor(p));
    mediump float b = random(vec2(ceil(p.x),floor(p.y)));
    mediump float c = random(vec2(floor(p.x),ceil(p.y)));
    mediump float d = random(ceil(p));
    return mix2(
        mix2(a,b,f.x),
        mix2(c,d,f.x),
        f.y
    );
}

mediump float smooth_noise3D(in vec3 p) {
    vec3 f = smoothUVs3D(fract(p));
    mediump float a = random3D(floor(p));
    mediump float b = random3D(vec3(ceil(p.x),floor(p.y),floor(p.z)));
    mediump float c = random3D(vec3(floor(p.x),ceil(p.y),floor(p.y)));
    mediump float d = random3D(vec3(ceil(p.xy),floor(p.z)));

    mediump float bottom = mix2(mix2(a,b,f.x), mix2(c,d,f.x),f.y);

    mediump float a2 = random3D(vec3(floor(p.x),floor(p.y),ceil(p.z)));
    mediump float b2 = random3D(vec3(ceil(p.x),floor(p.y),ceil(p.z)));
    mediump float c2 = random3D(vec3(floor(p.x),ceil(p.y),ceil(p.y)));
    mediump float d2 = random3D(vec3(ceil(p.xy),ceil(p.z)));

    mediump float top = mix2(mix2(a,b,f.x), mix2(c,d,f.x),f.y);

    return mix2(bottom, top, f.z);
}

mediump float fractal_noise(in vec2 p) {
    mediump float total = 0.5;
    mediump float amplitude = 1.0;
    mediump float frequency = 1.0;
    mediump float iterations = 4.0;
    for(float i = 0; i < iterations; i++) {
        total += (smooth_noise(p * frequency) - 0.5)*amplitude;
        amplitude *= 0.5;
        frequency *= 2.0;
    }
    return total;
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

vec4 cloudStack(in vec2 uv) {
    vec4 finalNoise = vec4(0.0);
    mediump float cloudLevels = 8.0;
    mediump float cloudHeight = 550/viewHeight;
    mediump float attenuation = 0.125;
    for(float i = 0; i < cloudLevels; i++) {
        vec4 noiseA = texture2D(noiseb,fract(uv * 0.0625f - vec2(0.0, (cloudHeight * i)/cloudLevels) - worldTime));
        vec4 noiseB = texture2D(noiseb,fract(uv * 0.015625f - vec2(0.0, (cloudHeight * i)/cloudLevels) + worldTime));
        noiseA = mix2(pow2(noiseA, vec4(CLOUD_DENSITY)),pow2(noiseA, vec4(CLOUD_DENSITY_RAIN)),rainStrength);
        noiseB = mix2(pow2(noiseA, vec4(CLOUD_DENSITY)),pow2(noiseB, vec4(CLOUD_DENSITY_RAIN)),rainStrength);
        finalNoise += noiseA * noiseB * attenuation;
        attenuation += 0.125;
    }
    finalNoise /= attenuation;

    return finalNoise;
}

mediump float get_cloud(vec3 p) {
    return clamp(texture2D(noiseb,p.xz/p.y).r * texture2D(noiseb,p.xz/p.y * 0.1).r * texture2D(noiseb,p.xz/p.y * 0.05).r * (1.0-(0.3*(1.0 - rainStrength)))*4.0,0,1);
}

mediump float get_cloud(vec3 p, vec3 p2) {
    return mix2(fractal_noise3D(p), fractal_noise3D(p2), 0.5);
}

mediump vec2 get_cloud(vec2 p, vec2 p2) {
    return mix2(texture2D(cloudtex, p).xy, texture2D(cloudtex, p).xy, 0.5);
}

vec4 normalFromHeight(sampler2D noiseTex, vec2 uv, float scale, float noiseType) {
    mediump float moveStep = 1.0/viewHeight;
    mediump float height = texture2D(noiseTex,uv).r;
    vec2 dxy;
    if(noiseType <= 0.0) {
        dxy = vec2(height) - vec2( cloudStack(uv + vec2(moveStep, 0.0)).r,  cloudStack(uv + vec2(0.0, moveStep)).r);
    } else {
        dxy = vec2(height) - vec2( cloudStack(uv + vec2(moveStep, 0.0)).r,  cloudStack(uv + vec2(0.0, moveStep)).r);
    }
    return vec4(normalize(vec3(dxy * scale / moveStep, 1.0)),height);
}

vec4 normalFromHeight(vec3 uv, float scale, float noiseType) {
    mediump float moveStep = 1.0/viewHeight;
    mediump float height = get_cloud(uv).r;
    vec3 dxy;
    if(noiseType <= 0.0) {
        dxy = vec3(height) - vec3( get_cloud(uv + vec3(moveStep, 0.0, 0.0)).r,  get_cloud(uv + vec3(0.0, moveStep,0.0)).r,get_cloud(uv + vec3(0.0, 0.0, moveStep)).r);
    } else {
        dxy = vec3(height) - vec3( get_cloud(uv + vec3(moveStep, 0.0, 0.0)).r,  get_cloud(uv + vec3(0.0, moveStep,0.0)).r,get_cloud(uv + vec3(0.0, 0.0, moveStep)).r);
    }
    return vec4(normalize(dxy * scale / moveStep),height);
}

mediump float invLerp(float from, float to, float value){
  return (value - from) / (to - from);
}

mediump float remap(float origFrom, float origTo, float targetFrom, float targetTo, float value){
  mediump float rel = invLerp(origFrom, origTo, value);
  return mix2(targetFrom, targetTo, rel);
}

mediump vec4 invLerp(vec4 from, vec4 to, vec4 value){
  return (value - from) / (to - from);
}

mediump vec4 remap(vec4 origFrom, vec4 origTo, vec4 targetFrom, vec4 targetTo, vec4 value){
  mediump vec4 rel = invLerp(origFrom, origTo, value);
  return mix2(targetFrom, targetTo, rel);
}

mediump vec2 invLerp(vec2 from, vec2 to, vec2 value){
  return (value - from) / (to - from);
}

mediump vec2 remap(vec2 origFrom, vec2 origTo, vec2 targetFrom, vec2 targetTo, vec2 value){
  mediump vec2 rel = invLerp(origFrom, origTo, value);
  return mix2(targetFrom, targetTo, rel);
}

vec4 blurImage(vec2 UVs, float radius, float strength, int samples, vec2 resolution, vec2 resolutionReduction) {
    vec2 uv = vec2((UVs.x*resolution.x)/CLOUD_RESOLUTION_REDUCTION,(UVs.x*resolution.y)/CLOUD_RESOLUTION_REDUCTION);
    vec4 color = imageLoad(cimage9, ivec2((UVs * resolution)/resolutionReduction));

    for(int i = 0; i < samples; i++) {
        ivec2 uv2 = ivec2(uv + (float(i) * radius/float(samples)));
        ivec2 uv3 = ivec2(uv - (float(i) * radius/float(samples)));
        color += imageLoad(cimage9, uv2) * strength;
        color += imageLoad(cimage9, uv3) * strength;
        color *= (1 - float(i)/float(samples));
    }

    return color;
}

uniform mat4 shadowProjectionInverse;
uniform mat4 shadowModelViewInverse;

uniform mat4 shadowProjection;
uniform mat4 shadowModelView;

uniform sampler2D shadowtex0;
uniform sampler2D shadowtex1;

uniform sampler2D shadowcolor0;

uniform sampler2D depthtex1;

in vec3 Tangent;

varying vec2 LightmapCoords;

uniform sampler2D lightmap;

#define SHADOW_SAMPLES 2
#define SHADOW_RES 4096 // [128 256 512 1024 2048 4096 8192]
#define SHADOW_DIST 16 // [4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32]

#define AMBIENT_LIGHT_R 0.8 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define AMBIENT_LIGHT_G 0.9 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define AMBIENT_LIGHT_B 1.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

#define MIN_LIGHT 0.05f // [0.0f 0.05f 0.1f 0.15f 0.2f 0.25f 0.3f 0.35f 0.4f 0.45f 0.5f]

mediump float AdjustLightmapTorch(in float torch) {
    const mediump float K = 2.0f;
    const mediump float P = 5.06f;
    return K * pow2(torch, P);
}

mediump float AdjustLightmapSky(in float sky){
    mediump float sky_2 = sky * sky;
    return sky_2 * sky_2;
}

vec2 AdjustLightmap(in vec2 Lightmap){
    vec2 NewLightMap;
    NewLightMap.x = AdjustLightmapTorch(Lightmap.x);
    NewLightMap.y = AdjustLightmapSky(Lightmap.y);
    return NewLightMap;
}

const int ShadowSamplesPerSize = 2 * SHADOW_SAMPLES + 1;
const int TotalSamples = ShadowSamplesPerSize * ShadowSamplesPerSize;

#include "distort.glsl"

mediump float Visibility(in sampler2D ShadowMap, in vec3 SampleCoords) {
    return step(SampleCoords.z - 0.001f, texture2D(ShadowMap, SampleCoords.xy).r);
}

vec3 TransparentShadow(in vec3 SampleCoords){
    mediump float ShadowVisibility0 = Visibility(shadowtex0, SampleCoords);
    mediump float ShadowVisibility1 = Visibility(shadowtex1, SampleCoords);
    vec4 ShadowColor0 = texture2D(shadowcolor0, SampleCoords.xy);
    vec3 TransmittedColor = ShadowColor0.rgb * (1.0f - ShadowColor0.a);
    return mix2(TransmittedColor * ShadowVisibility1, vec3(1.0f), ShadowVisibility0);
}

mat3 tbnNormalTangent(vec3 normal, vec3 tangent) {
    vec3 bitangent = cross(tangent, normal);
    return mat3(tangent, bitangent, normal);
}

vec3 GetShadow(float depth) {
    vec3 ClipSpace = vec3(texCoord, depth) * 2.0f - 1.0f;
    vec4 ViewW = gbufferProjectionInverse * vec4(ClipSpace, 1.0f);
    vec3 View = ViewW.xyz / ViewW.w;
    vec4 World = gbufferModelViewInverse * vec4(View, 1.0f);
    vec4 ShadowSpace = shadowProjection * shadowModelView * World;
    ShadowSpace.xy = DistortPosition(ShadowSpace.xy);
    vec3 worldSpaceSunPos = (gbufferProjection * vec4(sunPosition,1.0)).xyz;
    vec3 lightDir = normalize2(worldSpaceSunPos);
    vec3 normal = texture2D(colortex1, texCoord).rgb;
    normal = tbnNormalTangent(normal, Tangent) * normal;
    vec3 normalClip = normal * 2.0f - 1.0f;
    vec4 normalViewW = gbufferProjectionInverse * vec4(normalClip, 1.0);
    vec3 normalView = normalViewW.xyz/normalViewW.w;
    vec4 normalWorld = gbufferModelViewInverse * vec4(normalView, 1.0f);
    vec3 fragPos = texture2D(colortex10, texCoord).rgb;
    #if RAY_TRACED_SHADOWS == 1
        return computeShadows(lightDir, vec3(0.0), normal, World.xyz);
    #else
        vec3 SampleCoords = ShadowSpace.xyz * 0.5f + 0.5f;
        vec3 ShadowAccum = vec3(0.0f);
        for(int x = -SHADOW_SAMPLES; x <= SHADOW_SAMPLES; x++){
            for(int y = -SHADOW_SAMPLES; y <= SHADOW_SAMPLES; y++){
                vec2 Offset = vec2(x, y) / SHADOW_RES;
                vec3 CurrentSampleCoordinate = vec3(SampleCoords.xy + Offset, SampleCoords.z);
                ShadowAccum += TransparentShadow(CurrentSampleCoordinate);
            }
        }
        ShadowAccum /= TotalSamples;
        return ShadowAccum;
    #endif
}

#include "program/bloom.glsl"

/* RENDERTARGETS:0,1,2,3,4,5,6,14 */
layout(location = 0) out vec4 outcolor;
layout(location = 1) out vec4 outnormal;

void main() {
    vec3 color = pow2(texture2D(colortex0, texCoord).rgb,vec3(2.2));
    vec3 sky_color = textureLod(colortex0, texCoord,6).rgb;
    mediump float depth = texture2D(depthtex0, texCoord).r;
    mediump float depth2 = texture2D(depthtex1, texCoord).r;

    vec3 Normal = normalize2(texture2D(colortex1, texCoord).rgb * 2.0f -1.0f);

    vec3 worldGeoNormal = mat3(gbufferModelViewInverse) * Normal;

    vec3 shadowLightDirection = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);
    
    shadowLightDirection = abs(shadowLightDirection);

    mediump float cloud_time = fract(CLOUD_SPEED * float(worldTime)/12000);

    vec4 finalLight = vec4(0.0);

    float lightMask = dot(normalize2(mat3(gbufferModelViewInverse) * shadowLightPosition), texture2D(colortex1,texCoord).xyz * 2 + 1);
    lightMask = max(lightMask, 0.0);

    float sunlightMask = dot(normalize2(mat3(gbufferModelViewInverse) * sunPosition), texture2D(colortex1,texCoord).xyz * 2 + 1);
    sunlightMask = max(sunlightMask, 0.0);

    vec3 sunLight = vec3(VL_COLOR_R, VL_COLOR_G, VL_COLOR_B) * sunlightMask;

    vec2 lightmap = 1 - texture2D(colortex13, texCoord).rg;
    float isCave = smoothstep(0.0, 0.9, lightmap.g);

    vec3 sunWorldPos = mat3(gbufferModelViewInverse) * sunPosition;

    float timeDistance = abs(worldTime - 6000);
    float maxTimeDistance = 6000.0;
    float timeBlendFactor = smoothstep(0.75,1.0,clamp(timeDistance/maxTimeDistance, 0, 1));

    float lightBlend = (1 - timeBlendFactor) * isCave;

    vec3 totalSunlight = mix2(sunLight*lightMask*0.016, vec3(AMBIENT_LIGHT_R, AMBIENT_LIGHT_G, AMBIENT_LIGHT_B)*MIN_LIGHT,lightBlend);

    //rain_data rainData = transitionRain.data;
    float rainLerp = rainStrength;
    /*if(rainData.firstInit != true) {
        rainData.startState = rainStrength > 0.0;
        rainData.activeState = false;
        rainData.firstInit = true;
        rainData.previousRainStrength = 0;
    }

    if(rainStrength != rainData.previousRainStrength) {
        rainData.startState = rainData.previousRainStrength > 0.0;
        rainData.timer = 0;
        rainData.previousRainStrength = rainStrength;
        rainData.activeState = true;
    }

    if(rainData.activeState) {
        rainData.timer += frameTime;
        rainLerp = mix2(1 - rainStrength, rainStrength, clamp(rainData.timer,0,1));
        if(rainData.timer >= 1.0) {
            rainData.activeState = false;
        }
    }

    transitionRain.data = rainData;

    outcolor = vec4(vec3(rainData.timer),0.0);
    return;*/
    
    vec4 cloudsNormal;
    if(depth == 1.0) {
        #if CLOUD_STYLE == 1
            vec4 pos = vec4(texCoord, depth, 1.0) * 2.0 - 1.0;
            pos.xyz = projectAndDivide(gbufferProjectionInverse,pos.xyz);
            vec3 view_pos = pos.xyz;
            pos = gbufferModelViewInverse * vec4(pos.xyz, 1.0);
            vec3 rayDir = normalize2(pos.xyz);

            vec2 uv = rayDir.xz*0.25/rayDir.y;
            vec2 uv2 = pos.xz*0.001+frameTimeCounter*0.1;

            mediump float detectSky = texture2D(colortex12, texCoord).g;

            vec3 p = vec3(uv, 0);
            vec3 p2 = vec3(uv, 0);

            p.xy -= cloud_time;
            p.xy = fract(p.xy);

            p2.xy += cloud_time * 0.5;
            p2.xy = fract(p.xy);
            
            float scaleVar = smoothstep(0.1, 1.0, get_cloud(fract(p/rayDir.y*2.2/rayDir.y)));

            float scaleMix = sin((length(p/rayDir.y) + scaleVar)) * 0.5 + 0.5;

            vec4 clouds = vec4(0.0);

            vec3 light = vec3(0.0);

            if(rayDir.y > 0.0) {
                mediump float starting_distance = 1.0/rayDir.y;

                mediump float scale = 0.05;
                mediump float cloud_shading_amount = 0.1;
                mediump float cloud_offset = mix2(-1, 1, scaleMix);

                vec3 sunDir = normalize2(vec4(gbufferModelViewInverse * vec4(sunPosition,1.0)).xyz);
                float sun_dot = clamp(dot(rayDir, sunDir),0,1);

                if(texCoord.x <= 1.0 || texCoord.x >= 0.0 || texCoord.y <= 1.0 || texCoord.y >= 0.0) {
                    if(detectSky != 1.0) {
                        vec3 player = vec3(uv*starting_distance+0.05 + cloud_time * CLOUD_SPEED, 0.0);
                        vec3 player2 = vec3(uv*starting_distance * 1.5f - cloud_time,0.0);
                        mediump float sky_density = 0.1;
                        for(float s = 0.0; s < CLOUD_SAMPLES && clouds.a < 0.99; s++) {
                            vec3 ray_pos = player + rayDir*(s - cloud_time + vec3(texCoord,s))*scale;
                            vec3 ray_pos2 = player + rayDir*(s + cloud_time*0.5 + vec3(texCoord,s))*scale;
                            vec4 cloud = vec4(get_cloud(fract((ray_pos.xyz - vec3(0.0, s/CLOUD_SAMPLES * scale,0.0))/rayDir.y * 0.05) * 20 + 1,fract((ray_pos2.xyz*0.5 - vec3(0.0, s/CLOUD_SAMPLES * scale,0.0))/rayDir.y * 0.05) * 40 + 1));

                            vec4 cloudB = remap(vec4(0.0),vec4(1.0),vec4(1.0),vec4(-1.0),cloud);
                            cloudB.a = smoothstep(0.1,1.0,pow2(cloudB.a, 0.5));

                            cloud.a = smoothstep(0.1,1.0,pow2(cloud.a, 0.25));
                            cloud = mix2(cloudB, cloud, rainLerp);

                            light = vec3(0.0);

                            cloud.a = pow2(cloud.a * abs(s/CLOUD_SAMPLES*2.0 - 0.5), 1/mix2(CLOUD_DENSITY,CLOUD_DENSITY_RAIN,rainStrength));
                            cloud.a = clamp(cloud.a, 0.0, 1.0);
                            
                            #ifdef VOLUMETRIC_LIGHTING
                                light = vec3(1.0);
                                for(float s = 0.0; s < CLOUD_SHADING_SAMPLES && clouds.a < 0.99; s++) {
                                    vec3 ray_s_pos = ray_pos + sunDir*(s - cloud_time + vec3(texCoord,s))*scale;
                                    vec3 ray_s_pos2 = ray_pos + sunDir*(s + cloud_time*0.5 + vec3(texCoord,s))*scale;

                                    float cloud_shading = clamp(get_cloud((ray_s_pos.xyz*0.01)/rayDir.y, (ray_s_pos2.xyz*0.005)/rayDir.y) * 2.0 - 0.5,0.5,1);
                                    light *= 1.0 - cloud_shading;
                                    light = mix2(light, vec3(1.0), 1 - step(0.0, cloud.a));
                                }

                                light.r += light.r*pow2(sun_dot,1+20*(1.0 - light.r));

                                light = light.r * vec3(VL_COLOR_R, VL_COLOR_G, VL_COLOR_B);
                                light = mix2(vec3(0.0), light, smoothstep(0.2, 0.9, length(light)));
                                light = mix2(light * 0.55, light, 1 - smoothstep(0.75, 1.0, clouds.a));
                            #endif
                            light = max(light, vec3(0.0));
                            light *= 1 - rainStrength;
                            clouds.rgb *= clamp(light+sky_color*0.5,0,1);
                            
                            clouds.rgb = mix2(clouds.rgb,cloud.rgb,(1.0 - clouds.a) * cloud.a);
                            clouds.a = clamp(clouds.a +(1.0 - clouds.a) * cloud.a,0.0,1.0);
                        }
                        clouds.rgb = mix(clouds.rgb,sky_color,pow(1.0 - rayDir.y,4.0));
                    } else {
                        clouds = vec4(0.0);
                        cloudsNormal = vec4(0.0);
                    }


                    mediump float cloudFog = clamp(rayDir.y,0.0,0.25) * 4.0;
                    
                    clouds.a = remap(0.0,1.0, -50.0, 10.0,clouds.a);
                    clouds.a = clamp(clouds.a, 0.0, 1.0);
                    clouds.rgb *= 1 - clamp((clouds.a-0.5)*0.1,0.0,0.25);
                    clouds.rgb *= clouds.a;
                    clouds.rgb = clamp(clouds.rgb,vec3(0.0),normalize2(clouds.rgb)*1.75f);
                    imageStore(cimage9, ivec2((texCoord.x*viewWidth)/CLOUD_RESOLUTION_REDUCTION,(texCoord.y*viewHeight)/CLOUD_RESOLUTION_REDUCTION), clouds);
                    vec2 uv3 = vec2((texCoord.x*viewWidth)/CLOUD_RESOLUTION_REDUCTION,(texCoord.y*viewHeight)/CLOUD_RESOLUTION_REDUCTION);

                    clouds = imageBilinear(texCoord, imageSize(cimage9));
                    if(rayDir.y > 0.0 || detectSky != 1.0) {
                        color.rgb = mix2(color.rgb, clouds.rgb,clouds.a*(cloudFog * CLOUD_FOG));
                    }
                    #include "lib/reprojection.glsl"
                }
            }
            #if SCENE_AWARE_LIGHTING > 0 && defined BLOOM
                if(detectSky == 1.0) {
                    vec3 shadowLerp = GetShadow(depth2);
                    shadowLerp = mix2(shadowLerp, vec3(0.0), rainStrength);
                    vec2 lightmap = 1 - texture2D(colortex13, texCoord).rg;
                    finalLight = vec4(texture2D(colortex2, texCoord).xyz + mix2(totalSunlight, vec3(AMBIENT_LIGHT_R, AMBIENT_LIGHT_G, AMBIENT_LIGHT_B)*MIN_LIGHT,isCave),1.0);
                } else {
                    #ifdef VOLUMETRIC_LIGHTING
                        finalLight = vec4(mix2(light, texture2D(colortex2, texCoord).xyz + light, 1 - clouds.a),1.0);
                    #else
                        finalLight = vec4(mix2(vec3(0.0), texture2D(colortex2, texCoord).xyz, 1 - clouds.a),1.0);
                    #endif
                }
            #elif defined BLOOM
                #ifdef VOLUMETRIC_LIGHTING
                    finalLight = vec4(mix2(light, texture2D(colortex2, texCoord).xyz + light, 1 - clouds.a),1.0);
                #else
                    finalLight = vec4(mix2(vec3(0.0), texture2D(colortex2, texCoord).xyz, 1 - clouds.a),1.0);
                #endif
            #endif
        #elif defined BLOOM
            vec3 light = vec3(0.0);
            vec4 clouds = vec4(0.0);
            #ifdef VOLUMETRIC_LIGHTING
                vec4 pos = vec4(texCoord, depth, 1.0) * 2.0 - 1.0;
                pos.xyz = projectAndDivide(gbufferProjectionInverse,pos.xyz);
                vec3 view_pos = pos.xyz;
                pos = gbufferModelViewInverse * vec4(pos.xyz, 1.0);
                vec3 rayDir = normalize2(pos.xyz);

                vec2 uv = rayDir.xz*0.25/rayDir.y;
                vec2 uv2 = pos.xz*0.001+frameTimeCounter*0.1;

                vec3 p = vec3(uv, 0);
                vec3 p2 = vec3(uv, 0);

                float scaleVar = smoothstep(0.1, 1.0, get_cloud(fract(p/rayDir.y*2.2/rayDir.y)));

                float scaleMix = sin((length(p/rayDir.y) + scaleVar)) * 0.5 + 0.5;

                mediump float starting_distance = 1.0/rayDir.y;
                mediump float scale = 0.05;
                mediump float cloud_shading_amount = 0.1;
                mediump float cloud_offset = mix2(-1, 1, scaleMix);

                vec3 sunDir = normalize2(vec4(gbufferModelViewInverse * vec4(sunPosition,1.0)).xyz);
                float sun_dot = clamp(dot(rayDir, sunDir),0,1);
                
                vec3 player = vec3(uv*starting_distance+0.05 + cloud_time * CLOUD_SPEED, 0.0);
                vec3 player2 = vec3(uv*starting_distance * 1.5f - cloud_time,0.0);
                vec3 ray_pos = player + rayDir*(cloud_time + vec3(texCoord,0))*scale;
                vec3 ray_pos2 = player + rayDir*(cloud_time*0.5 + vec3(texCoord,0))*scale;
                light = vec3(1.0);
                for(float s = 0.0; s < CLOUD_SHADING_SAMPLES && clouds.a < 0.99; s++) {
                    vec3 ray_s_pos = ray_pos + sunDir*(s - cloud_time + vec3(texCoord,s))*scale;
                    vec3 ray_s_pos2 = ray_pos + sunDir*(s + cloud_time*0.5 + vec3(texCoord,s))*scale;

                    float cloud_shading = clamp(get_cloud((ray_s_pos.xyz*0.01)/rayDir.y, (ray_s_pos2.xyz*0.005)/rayDir.y) * 2.0 - 0.5,0.5,1);
                    light *= 1.0 - cloud_shading;
                    light = mix2(light, vec3(1.0), 1 - step(0.0, clouds.a));
                }

                light.r += light.r*pow2(sun_dot,1+20*(1.0 - light.r));

                light = light.r * vec3(VL_COLOR_R, VL_COLOR_G, VL_COLOR_B);
                light = mix2(vec3(0.0), light, smoothstep(0.2, 0.9, length(light)));
                light = mix2(light * 0.55, light, 1 - smoothstep(0.75, 1.0, clouds.a));
                vec3 totalSunlight = mix2(sunLight*lightMask*0.016, vec3(AMBIENT_LIGHT_R, AMBIENT_LIGHT_G, AMBIENT_LIGHT_B)*MIN_LIGHT,lightBlend);
                finalLight = vec4(pow2(mix2(totalSunlight,texture2D(colortex2, texCoord).xyz,0.5),vec3(0.75)), 1.0);
            #else
                finalLight = vec4(texture2D(colortex2, texCoord).xyz, 1.0);
            #endif
        #endif
    } else {
        #if SCENE_AWARE_LIGHTING > 0
            vec3 dynamicLight = texture2D(colortex2, texCoord).xyz;
            #if SCENE_AWARE_LIGHTING == 1
                dynamicLight = blurLight(colortex2, depthtex1, texCoord, 3.0, 64, 3.0, 1.0);
            #elif SCENE_AWARE_LIGHTING == 2
                dynamicLight = blurLight(colortex2, depthtex1, texCoord, 1.0, 25, 1.0, 0.1);
            #endif
            vec3 shadowLerp = mix2(GetShadow(depth2),vec3(0.0),timeBlendFactor);
            shadowLerp = mix2(shadowLerp, vec3(0.0), rainStrength);
            float lightBlend2 = 1 - min(1 - isCave, length(shadowLerp));
            finalLight = vec4(dynamicLight + mix2(totalSunlight, vec3(AMBIENT_LIGHT_R, AMBIENT_LIGHT_G, AMBIENT_LIGHT_B)*MIN_LIGHT,lightBlend2),1.0);
            lightMask *= length(shadowLerp) * isCave;
        #endif
    }
    
    color.xyz = blindEffect(color.xyz, texCoord);
    outcolor = vec4(pow2(color,vec3(1/2.2)), 1.0);
    gl_FragData[2] = finalLight;
    gl_FragData[3] = texture2D(colortex3, texCoord);
    gl_FragData[4] = texture2D(colortex4, texCoord);
    gl_FragData[5] = texture2D(colortex5, texCoord);
    gl_FragData[6] = texture2D(colortex6, texCoord);
    gl_FragData[7] = vec4(lightMask * vec3(VL_COLOR_R, VL_COLOR_G, VL_COLOR_B), 1.0);
}