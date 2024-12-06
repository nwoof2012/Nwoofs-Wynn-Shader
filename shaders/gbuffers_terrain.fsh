#version 460 compatibility

#include "lib/optimizationFunctions.glsl"

//#define SCENE_AWARE_LIGHTING

varying vec2 TexCoords;
varying vec3 Normal;
varying vec4 Color;

varying vec2 LightmapCoords;

uniform sampler2D gtexture;
uniform sampler2D lightmap;

uniform sampler2D depthtex0;
uniform sampler2D depthtex1;

uniform float blindness;

//flat in vec4 mc_Entity;

in vec3 viewSpaceFragPosition;

float minBlindnessDistance = 2.5;
float maxBlindDistance = 5;

in vec4 lightSourceData;

/* DRAWBUFFERS:01235*/

void main() {
    vec3 lightColor = texture(lightmap, LightmapCoords).rgb;
    vec4 albedo = texture2D(gtexture, TexCoords) * Color;
    albedo.xyz = pow2(albedo.xyz, vec3(2.2));

    float depth = texture2D(depthtex0, TexCoords).r;
    //albedo.rgb *= lightColor;
    
    if(albedo.a < .1 || depth < 0.1) {
        discard;
    }

    /*if(mc_Entity.x < 10005 || mc_Entity.x > 10010) {
        lightColor = vec3(0);
    }*/

    albedo.xyz = pow2(albedo.xyz, vec3(1/2.2));

    float distanceFromCamera = distance(vec3(0), viewSpaceFragPosition);

    if(blindness > 0f) {
        albedo.xyz = mix2(albedo.xyz,vec3(0),(distanceFromCamera - minBlindnessDistance)/(maxBlindDistance - minBlindnessDistance) * blindness);
    }

    gl_FragData[0] = albedo;
    gl_FragData[1] = vec4(Normal * 0.5 + 0.5f, 1.0f);
    #ifndef SCENE_AWARE_LIGHTING
        gl_FragData[2] = vec4(LightmapCoords, 0f, 1.0f);
    #else
        lightColor = vec3(0);
        const vec3 TorchColor = vec3(1.0f, 0.25f, 0.08f);
        const vec3 GlowstoneColor = vec3(1.0f, 0.85f, 0.5f);
        const vec3 LampColor = vec3(1.0f, 0.75f, 0.4f);
        const vec3 LanternColor = vec3(0.8f, 1.0f, 1.0f);
        const vec3 RedstoneColor = vec3(1.0f, 0.0f, 0.0f);
        const vec3 RodColor = vec3(1.0f, 1.0f, 1.0f);
        if(lightSourceData.x > 0.5) {
            lightColor = TorchColor;
        }
        else if(lightSourceData.y > 0.5) {
            lightColor = GlowstoneColor;
        }
        else if(lightSourceData.z > 0.5) {
            lightColor = LampColor;
        }
        else if(lightSourceData.x > 0.0) {
            lightColor = LanternColor;
        }
        else if(lightSourceData.y > 0.0) {
            lightColor = RedstoneColor;
        }
        else if(lightSourceData.z > 0.0) {
            lightColor = RodColor;
        }
        vec4 lighting = max(vec4(LightmapCoords.x,0.0,0.0,1.0),vec4(lightColor,lightSourceData.w + 1.0));
        /*if(lighting.x == LightmapCoords.x) {
            lighting.x *= 2.0;
        }*/
        gl_FragData[2] = lighting;
    #endif
    //gl_FragData[3] = vec4(LightmapCoords, 0.0f, 1.0f);
    gl_FragData[3] = vec4(distanceFromCamera);
    gl_FragData[4] = vec4(0.0,1.0,1.0,1.0);
}