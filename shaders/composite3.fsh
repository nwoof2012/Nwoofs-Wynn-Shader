#version 150 compatibility

#define CLOUD_STYLE 0 // [0 1]
#define CLOUD_FOG 0.5 // [0.0 0.25 0.5 0.75 1.0]
#define CLOUD_DENSITY 1.5 // [0.0 0.25 0.5 0.75 1.0 1.25 1.5 1.75 2.0]
#define CLOUD_DENSITY_RAIN 1.0 // [0.0 0.25 0.5 0.75 1.0 1.25 1.5 1.75 2.0]

#include "lib/optimizationFunctions.glsl"

uniform float frameTimeCounter;
uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex12;
uniform sampler2D colortex13;
uniform sampler2D colortex14;
uniform sampler2D depthtex0;
uniform sampler2D noisetex;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform float rainStrength;

uniform float viewHeight;

uniform vec3 shadowLightPosition;
uniform vec3 cameraPosition;

in vec2 texCoord;

vec3 projectAndDivide(mat4 pm, vec3 p) {
    vec4 hp = pm * vec4(p, 1.0);
    return hp.xyz/hp.w;
}

float random(in vec2 p) {
    return fract(sin(p.x*456.0+p.y*56.0)*100.0);
}

float random3D(in vec3 p) {
    return fract(sin(p.x*456.0+p.y*56.0+p.z*741.0)*100.0);
}

vec2 smoothUVs(in vec2 v) {
    return v*v*(3.0-2.0*v);
}

vec3 smoothUVs3D(in vec3 v) {
    return v*v*(3.0-2.0*v);
}


float smooth_noise(in vec2 p) {
    vec2 f = smoothUVs(fract(p));
    float a = random(floor(p));
    float b = random(vec2(ceil(p.x),floor(p.y)));
    float c = random(vec2(floor(p.x),ceil(p.y)));
    float d = random(ceil(p));
    return mix2(
        mix2(a,b,f.x),
        mix2(c,d,f.x),
        f.y
    );
}

float smooth_noise3D(in vec3 p) {
    vec3 f = smoothUVs3D(fract(p));
    float a = random3D(floor(p));
    float b = random3D(vec3(ceil(p.x),floor(p.y),floor(p.z)));
    float c = random3D(vec3(floor(p.x),ceil(p.y),floor(p.y)));
    float d = random3D(vec3(ceil(p.xy),floor(p.z)));

    float bottom = mix2(mix2(a,b,f.x), mix2(c,d,f.x),f.y);

    float a2 = random3D(vec3(floor(p.x),floor(p.y),ceil(p.z)));
    float b2 = random3D(vec3(ceil(p.x),floor(p.y),ceil(p.z)));
    float c2 = random3D(vec3(floor(p.x),ceil(p.y),ceil(p.y)));
    float d2 = random3D(vec3(ceil(p.xy),ceil(p.z)));

    float top = mix2(mix2(a,b,f.x), mix2(c,d,f.x),f.y);

    return mix2(bottom, top, f.z);
}

float fractal_noise(in vec2 p) {
    float total = 0.5;
    float amplitude = 1.0;
    float frequency = 1.0;
    float iterations = 4.0;
    for(float i = 0; i < iterations; i++) {
        total += (smooth_noise(p * frequency) - 0.5)*amplitude;
        amplitude *= 0.5;
        frequency *= 2.0;
    }
    return total;
}

float fractal_noise3D(in vec3 p) {
    float total = 0.5;
    float amplitude = 1.0;
    float frequency = 1.0;
    float iterations = 4.0;
    for(float i = 0; i < iterations; i++) {
        total += (smooth_noise3D(p * frequency) - 0.5)*amplitude;
        amplitude *= 0.5;
        frequency *= 2.0;
    }
    return total;
}

vec4 cloudStack(in vec2 uv) {
    vec4 finalNoise = vec4(0.0);
    float cloudLevels = 8.0;
    float cloudHeight = 550/viewHeight;
    float attenuation = 0.125;
    for(float i = 0; i < cloudLevels; i++) {
        vec4 noiseA = texture2D(colortex13,uv * 0.0625f - vec2(0.0, (cloudHeight * i)/cloudLevels) - frameTimeCounter * 0.00125);
        vec4 noiseB = texture2D(colortex14,uv * 0.015625f - vec2(0.0, (cloudHeight * i)/cloudLevels) + frameTimeCounter * 0.005);
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

vec4 normalFromHeight(sampler2D noiseTex, vec2 uv, float scale, float noiseType) {
    float moveStep = 1.0/viewHeight;
    float height = texture2D(noiseTex,uv).r;
    vec2 dxy;
    if(noiseType <= 0.0) {
        dxy = vec2(height) - vec2( cloudStack(uv + vec2(moveStep, 0.0)).r,  cloudStack(uv + vec2(0.0, moveStep)).r);
    } else {
        dxy = vec2(height) - vec2( cloudStack(uv + vec2(moveStep, 0.0)).r,  cloudStack(uv + vec2(0.0, moveStep)).r);
    }
    return vec4(normalize(vec3(dxy * scale / moveStep, 1.0)),height);
}

/*float remap(in float value, in float oldMin, in float oldMax, in float newMin, in float newMax) {
    return newMin + (value - oldMin) * (newMax - newMin)/(oldMax - oldMin);
}*/

float invLerp(float from, float to, float value){
  return (value - from) / (to - from);
}

float remap(float origFrom, float origTo, float targetFrom, float targetTo, float value){
  float rel = invLerp(origFrom, origTo, value);
  return mix2(targetFrom, targetTo, rel);
}

/* DRAWBUFFERS:01 */
layout(location = 0) out vec4 outcolor;
layout(location = 1) out vec4 outnormal;

void main() {
    vec3 color = texture2D(colortex0, texCoord).rgb;
    float depth = texture2D(depthtex0, texCoord).r;

    vec3 Normal = normalize(texture2D(colortex1, texCoord).rgb * 2.0f -1.0f);

    vec3 worldGeoNormal = mat3(gbufferModelViewInverse) * Normal;

    vec3 shadowLightDirection = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);
    
    shadowLightDirection = abs(shadowLightDirection);
    
    vec4 cloudsNormal;
    if(depth == 1.0) {
        vec4 pos = vec4(texCoord, depth, 1.0) * 2.0 - 1.0;
        pos.xyz = projectAndDivide(gbufferProjectionInverse,pos.xyz);
        pos = gbufferModelViewInverse * vec4(pos.xyz, 1.0);
        vec3 rayDir = normalize(pos.xyz);
        //pos = fract(pos);

        vec4 noiseA = texture2D(colortex13,rayDir.xz/rayDir.y * 0.0625f - frameTimeCounter * 0.00125);
        vec4 noiseB = texture2D(colortex14,rayDir.xz/rayDir.y * 0.015625f + frameTimeCounter * 0.005);
        noiseA.rgb = mix2(pow2(noiseA.rgb, vec3(CLOUD_DENSITY)),pow2(noiseA.rgb, vec3(CLOUD_DENSITY_RAIN)),rainStrength);
        noiseB.rgb = mix2(pow2(noiseA.rgb, vec3(CLOUD_DENSITY)),pow2(noiseB.rgb, vec3(CLOUD_DENSITY_RAIN)),rainStrength);
        vec4 finalNoise = cloudStack(rayDir.xz/rayDir.y);
        //finalNoise = (finalNoise + 1.0)/2.0;
        /*if(rayDir.y > 0)
        {
            /*float samples = 256.0;
            float rayScale = 1.0;
            vec3 playerPos = vec3(rayDir.xz/rayDir.y, 1.0);
            for(float s = 0.0; s < samples; s++) {
                vec3 rayPos = playerPos + rayDir*rayScale;
                vec4 cloud = vec4(fractal_noise3D(rayPos) * fractal_noise3D(rayPos));

                finalNoise.rgb = mix2(finalNoise.rgb, cloud.rgb,(1 - finalNoise.a) * cloud.a);
                finalNoise.a += (1 - finalNoise.a) * cloud.a;
            }
            finalNoise = noiseA * noiseB;
        } else {
            finalNoise = vec4(0.0);
        }*/

        vec4 noiseNormalA = normalFromHeight(colortex13,rayDir.xz/rayDir.y,1.0, 0.0);
        vec4 noiseNormalB = normalFromHeight(colortex14,rayDir.xz/rayDir.y,1.0, 1.0);
        noiseNormalA = mix2(pow2(noiseA, vec4(CLOUD_DENSITY)),pow2(noiseA, vec4(CLOUD_DENSITY_RAIN)),rainStrength);
        noiseNormalB = mix2(pow2(noiseA, vec4(CLOUD_DENSITY)),pow2(noiseB, vec4(CLOUD_DENSITY_RAIN)),rainStrength);
        vec4 finalNoiseNormal = normalFromHeight(colortex13,rayDir.xz/rayDir.y,1.0, 0.0);

        float lightBrightness = clamp(dot(shadowLightDirection, finalNoiseNormal.xyz),0.75,1.0);

        vec4 clouds;
        
        float detectSky = texture2D(colortex12, texCoord).g;
        
        if(rayDir.y > 0 && detectSky != 1.0) {
            clouds = vec4(finalNoise.r);
            cloudsNormal = vec4(vec3(finalNoiseNormal),1.0);
        } else {
            clouds = vec4(0.0);
            cloudsNormal = vec4(0.0);
        }

        //clouds.a /= 2;

        float cloudFog = clamp(rayDir.y,0.0,1.0);

        clouds.rgb -= clamp(clouds.a - 0.5,0.0,0.25);
        clouds.rgb *= mix2(75.5,1.0, rainStrength);
        //clouds.a = (clouds.a - 0.125) * 1.0;
        /*if(clouds.a - 3.45 > 0.0) {
            clouds.a = pow2(clouds.a - 3.45,4.0) + 3.45;
        } else if(clouds.a - 3.45 < 0.0) {
            clouds.a = pow2(clouds.a - 3.45,1/4.0) + 3.45;
        }*/
        clouds.a = remap(0.0,1.0, -5.0, 10.0,clouds.a);
        clouds.a = clamp(clouds.a, 0.0, 1.0);
        /*if(dot(clouds, vec4(0.333)) < 0.001) {
            clouds.a = 0.0;
        }*/
        //clouds.a = clamp((clouds.a - (0.3*(1 - rainStrength)))*4.0, 0.0, 2.0);
        //clouds.rgb = vec3(1.0);
        clouds.rgb = clamp(clouds.rgb, -abs(noiseA.xyz * noiseB.xyz)*8.0, abs(noiseA.xyz * noiseB.xyz)*8.0);
        clouds.rgb = abs(clouds.rgb);
        clouds.rgb *= lightBrightness;
        if(rayDir.y > 0.0 || detectSky != 1.0) {
            color.rgb = mix2(color.rgb, clouds.rgb,clouds.a*(cloudFog * CLOUD_FOG));
        }
        //color.rgb = vec3(clouds.a);
    }

    outcolor = vec4(color, 1.0);
    //outnormal = cloudsNormal;
}