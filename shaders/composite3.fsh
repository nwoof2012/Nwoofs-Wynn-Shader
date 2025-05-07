#version 460 compatibility

#define CLOUD_STYLE 1 // [0 1]
#define CLOUD_FOG 0.5 // [0.0 0.25 0.5 0.75 1.0]
#define CLOUD_DENSITY 0.5 // [0.0 0.25 0.5 0.75 1.0 1.25 1.5 1.75 2.0]
#define CLOUD_DENSITY_RAIN 0.75 // [0.0 0.25 0.5 0.75 1.0 1.25 1.5 1.75 2.0]
#define CLOUD_SAMPLES 20.0 // [10.0 20.0 30.0 40.0 50.0 100.0]
#define CLOUD_SPEED 1.0 // [0.25 0.5 0.75 1.0 1.25 1.5 1.75 2.0]

#define CLOUD_SHADING_SAMPLES 2.0 // [2.0 3.0 4.0 5.0]
#define CLOUD_SHADING_DISTANCE 128.0 // [32.0 64.0 96.0 128.0 160.0 192.0 224.0 256.0]

#include "lib/includes2.glsl"
#include "lib/optimizationFunctions.glsl"
#include "program/blindness.glsl"

precision mediump float;

uniform float frameTimeCounter;
uniform float worldTime;

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D colortex10;
uniform sampler2D colortex12;
uniform sampler2D colortex13;
uniform sampler2D colortex14;
uniform sampler2D depthtex0;
uniform sampler2D noisetex;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferPreviousModelView;
uniform mat4 gbufferPreviousProjection;
uniform mat4 gbufferPreviousModelViewInverse;
uniform mat4 gbufferPreviousProjectionInverse;

uniform float rainStrength;
uniform vec3 sunPosition;

uniform float viewHeight;

uniform vec3 shadowLightPosition;
uniform vec3 cameraPosition;

in vec2 texCoord;

/*
const bool colortex2MipmapEnabled = true;
*/

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
        vec4 noiseA = texture2D(colortex13,uv * 0.0625f - vec2(0.0, (cloudHeight * i)/cloudLevels) - frameTimeCounter * 0.00125);
        vec4 noiseB = texture2D(colortex13,uv * 0.015625f - vec2(0.0, (cloudHeight * i)/cloudLevels) + frameTimeCounter * 0.005);
        noiseA = mix2(pow2(noiseA, vec4(CLOUD_DENSITY)),pow2(noiseA, vec4(CLOUD_DENSITY_RAIN)),rainStrength);
        noiseB = mix2(pow2(noiseA, vec4(CLOUD_DENSITY)),pow2(noiseB, vec4(CLOUD_DENSITY_RAIN)),rainStrength);
        finalNoise += noiseA * noiseB * attenuation;
        attenuation += 0.125;
    }
    //finalNoise.xyz /= cloudLevels*cloudLevels;
    //finalNoise = clamp(finalNoise, 0, 1);
    //finalNoise = 1 - finalNoise;
    finalNoise /= attenuation;
    //finalNoise.a = clamp(pow2(finalNoise.a, 0.9)/(cloudLevels*cloudLevels),0,1);

    return finalNoise;
}

mediump float get_cloud(vec3 p) {
    return clamp(texture2D(colortex13,p.xz/p.y).r * texture2D(colortex13,p.xz/p.y * 0.1).r * texture2D(colortex13,p.xz/p.y * 0.05).r * (1.0-(0.3*(1.0 - rainStrength)))*4.0,0,1);
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

/*mediump float remap(in float value, in float oldMin, in float oldMax, in float newMin, in float newMax) {
    return newMin + (value - oldMin) * (newMax - newMin)/(oldMax - oldMin);
}*/

mediump float invLerp(float from, float to, float value){
  return (value - from) / (to - from);
}

mediump float remap(float origFrom, float origTo, float targetFrom, float targetTo, float value){
  mediump float rel = invLerp(origFrom, origTo, value);
  return mix2(targetFrom, targetTo, rel);
}

/* RENDERTARGETS:0,1,2,10 */
layout(location = 0) out vec4 outcolor;
layout(location = 1) out vec4 outnormal;

void main() {
    vec3 color = pow2(texture2D(colortex0, texCoord).rgb,vec3(2.2));
    vec3 sky_color = textureLod(colortex0, texCoord,6).rgb;
    mediump float depth = texture2D(depthtex0, texCoord).r;

    vec3 Normal = normalize(texture2D(colortex1, texCoord).rgb * 2.0f -1.0f);

    vec3 worldGeoNormal = mat3(gbufferModelViewInverse) * Normal;

    vec3 shadowLightDirection = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);
    
    shadowLightDirection = abs(shadowLightDirection);

    mediump float cloud_time = worldTime;
    
    vec4 cloudsNormal;
    if(depth == 1.0) {
        vec4 pos = vec4(texCoord, depth, 1.0) * 2.0 - 1.0;
        pos.xyz = projectAndDivide(gbufferProjectionInverse,pos.xyz);
        vec3 view_pos = pos.xyz;
        pos = gbufferModelViewInverse * vec4(pos.xyz, 1.0);
        vec3 rayDir = normalize2(pos.xyz);
        //rayDir -= normalize2(vec3(1.0));
        //pos = fract(pos);

        /*vec4 noiseA = texture2D(colortex13,rayDir.xz/rayDir.y * 0.0625f - frameTimeCounter * 0.00125);
        vec4 noiseB = texture2D(colortex14,rayDir.xz/rayDir.y * 0.015625f + frameTimeCounter * 0.005);
        noiseA.rgb = mix2(pow2(noiseA.rgb, vec3(CLOUD_DENSITY)),pow2(noiseA.rgb, vec3(CLOUD_DENSITY_RAIN)),rainStrength);
        noiseB.rgb = mix2(pow2(noiseA.rgb, vec3(CLOUD_DENSITY)),pow2(noiseB.rgb, vec3(CLOUD_DENSITY_RAIN)),rainStrength);
        vec4 finalNoise = cloudStack(rayDir.xz/rayDir.y);*/

        vec4 clouds = vec4(vec3(1.0),0.0);

        if(rayDir.y < 1.0) {
            //finalNoise = (finalNoise + 1.0)/2.0;
            /*if(rayDir.y > 0)
            {
                /*mediump float samples = 256.0;
                mediump float rayScale = 1.0;
                vec3 playerPos = vec3(rayDir.xz/rayDir.y, 1.0);
                for(mediump float s = 0.0; s < samples; s++) {
                    vec3 rayPos = playerPos + rayDir*rayScale;
                    vec4 cloud = vec4(fractal_noise3D(rayPos) * fractal_noise3D(rayPos));

                    finalNoise.rgb = mix2(finalNoise.rgb, cloud.rgb,(1 - finalNoise.a) * cloud.a);
                    finalNoise.a += (1 - finalNoise.a) * cloud.a;
                }
                finalNoise = noiseA * noiseB;
            } else {
                finalNoise = vec4(0.0);
            }*/

            /*vec4 noiseNormalA = normalFromHeight(colortex13,rayDir.xz/rayDir.y,1.0, 0.0);
            vec4 noiseNormalB = normalFromHeight(colortex14,rayDir.xz/rayDir.y,1.0, 1.0);
            noiseNormalA = mix2(pow2(noiseA, vec4(CLOUD_DENSITY)),pow2(noiseA, vec4(CLOUD_DENSITY_RAIN)),rainStrength);
            noiseNormalB = mix2(pow2(noiseA, vec4(CLOUD_DENSITY)),pow2(noiseB, vec4(CLOUD_DENSITY_RAIN)),rainStrength);
            vec4 finalNoiseNormal = normalFromHeight(colortex13,rayDir.xz/rayDir.y,1.0, 0.0);*/

            //mediump float lightBrightness = clamp(dot(shadowLightDirection, finalNoiseNormal.xyz),0.75,1.0);

            mediump float starting_distance = 1.0/rayDir.y;

            //vec3 sky_color = color;
            mediump float scale = 0.25;
            mediump float cloud_shading_amount = 0.1;
            vec3 sunDir = normalize2(sunPosition);
            
            mediump float detectSky = texture2D(colortex12, texCoord).g;

            if(texCoord.x <= 1.0 || texCoord.x >= 0.0 || texCoord.y <= 1.0 || texCoord.y >= 0.0) {
                if(rayDir.y > 0 && detectSky != 1.0) {
                    vec3 player = vec3(rayDir.xz*starting_distance+0.05 + cloud_time * CLOUD_SPEED * 0.00125, 0.0);
                    vec3 player2 = vec3(rayDir.xz*starting_distance * 1.5f - frameTimeCounter * 0.005,0.0);
                    mediump float sky_density = 0.1;
                    for(float s = 0.0; s < CLOUD_SAMPLES && clouds.a < 0.99; s++) {
                        vec3 ray_pos = player + rayDir*(s - frameTimeCounter + vec3(texCoord,s))*scale;
                        //vec3 ray_pos2 = player2*0.0125 + rayDir*(s - random3D(frameTimeCounter + vec3(texCoord,s)))*scale;
                        vec4 cloud = vec4(get_cloud(rayDir*vec3(0.05,1.0,0.05) - vec3(0.0, s/CLOUD_SAMPLES * scale, 0.0)));

                        //clouds.a = clamp((clouds.a-(0.3*(1.0-rainStrength)))*4.0,sky_density,2.0);
                        //cloud.rgb = mix(vec3(1.0),sky_color,min(1.0,s / CLOUD_SAMPLES) + sky_density * 1.0 - clouds.a);
                        cloud.rgb = vec3(1.0);

                        cloud.a = pow2(cloud.a * abs(s/CLOUD_SAMPLES*2.0 - 0.5), 1/mix2(CLOUD_DENSITY,CLOUD_DENSITY_RAIN,rainStrength));

                        mediump float light = 1.0;

                        for(float s = 0.0; s < CLOUD_SHADING_SAMPLES && clouds.a < 0.99; s++) {
                            vec3 ray_s_pos = ray_pos + sunDir*(s - vec3(normalFromHeight(frameTimeCounter*0.001 + vec3(texCoord,s), 1.0, 1.0)))*scale;
                            mediump float cloud_shading = get_cloud(ray_s_pos);
                            light *= 1.0 - cloud_shading;

                            if(distance(viewSpaceFragPosition.xz,ray_s_pos.xz) > CLOUD_SHADING_DISTANCE) {
                                continue;
                            }
                        }

                        clouds.rgb *= light+mix2(vec3(0.25),sky_color,0.125);
                        
                        clouds.rgb = mix2(clouds.rgb,cloud.rgb,(1.0 - clouds.a) * cloud.a);
                        clouds.a = clamp(clouds.a +(1.0 - clouds.a) * cloud.a,0.0,1.0);
                    }
                    //cloudsNormal = vec4(normalFromHeight(clouds.x,rayDir.xz/rayDir.y,1.0, 1.0),1.0);
                    clouds.rgb = mix(clouds.rgb,sky_color,pow(1.0 - rayDir.y,4.0));
                } else {
                    clouds = vec4(0.0);
                    cloudsNormal = vec4(0.0);
                }

                //clouds.a /= 2;

                mediump float cloudFog = clamp(rayDir.y,0.0,0.25) * 4.0;
                
                //clouds.rgb = vec3(1.0);
                //clouds.rgb -= clamp(clouds.a - 0.5,0.0,0.25);
                //clouds.rgb *= mix2(75.5,1.0, rainStrength);
                //clouds.a = (clouds.a - 0.125) * 1.0;
                /*if(clouds.a - 3.45 > 0.0) {
                    clouds.a = pow2(clouds.a - 3.45,4.0) + 3.45;
                } else if(clouds.a - 3.45 < 0.0) {
                    clouds.a = pow2(clouds.a - 3.45,1/4.0) + 3.45;
                }*/
                clouds.a = remap(0.0,1.0, -50.0, 10.0,clouds.a);
                clouds.a = clamp(clouds.a, 0.0, 1.0);
                clouds.rgb *= 1 - clamp((clouds.a-0.5)*0.1,0.0,0.25);
                /*if(dot(clouds, vec4(0.333)) < 0.001) {
                    clouds.a = 0.0;
                }*/
                //clouds.a = clamp((clouds.a - (0.3*(1 - rainStrength)))*4.0, 0.0, 2.0);
                //clouds.rgb = vec3(1.0);
                //clouds.rgb = clamp(clouds.rgb, -abs(noiseA.xyz * noiseB.xyz)*8.0, abs(noiseA.xyz * noiseB.xyz)*8.0);
                //clouds.rgb = abs(clouds.rgb);
                //clouds.rgb *= lightBrightness;
                clouds.rgb = clamp(clouds.rgb,vec3(0.0),normalize2(clouds.rgb)*1.75f);
                if(rayDir.y > 0.0 || detectSky != 1.0) {
                    color.rgb = mix2(color.rgb, clouds.rgb,clouds.a*(cloudFog * CLOUD_FOG));
                }
                //color.rgb = vec3(clouds.a);
                #include "lib/reprojection.glsl"
                /*if(detectSky != 1.0) {
                    color = mix(color, ray_color.xyz,0.9);
                }*/
            }
        }
        gl_FragData[2] = vec4(mix2(vec3(0.0), texture2D(colortex2, texCoord).xyz, 1 - clouds.a),1.0);
    } else {
        gl_FragData[2] = vec4(texture2D(colortex2, texCoord).xyz,1.0);
    }

    if(blindness > 0.0f) {
        color.rgb = blindEffect(color.rgb);
    }

    outcolor = vec4(pow2(color,vec3(1/2.2)), 1.0);
    gl_FragData[3] = vec4(texture2D(colortex10, texCoord).xyz,1.0);
    //outnormal = cloudsNormal;
}