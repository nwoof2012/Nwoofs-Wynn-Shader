#version 460 compatibility

#include "lib/includes2.glsl"
#include "lib/optimizationFunctions.glsl"
#include "program/blindness.glsl"

//#define SCENE_AWARE_LIGHTING

varying vec2 TexCoords;
varying vec3 Normal;
varying vec3 Tangent;
varying vec4 Color;

varying vec2 LightmapCoords;

uniform sampler2D gtexture;
uniform sampler2D lightmap;

uniform sampler2D depthtex0;
uniform sampler2D depthtex1;

uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjectionInverse;

//flat in vec4 mc_Entity;

in vec4 lightSourceData;

in float isReflective;

in vec3 worldSpaceVertexPosition;

/* RENDERTARGETS:0,1,2,3,5,10*/

void main() {
    vec3 lightColor = texture(lightmap, LightmapCoords).rgb;
    vec4 albedo = texture2D(gtexture, TexCoords) * Color;
    albedo.xyz = pow2(albedo.xyz, vec3(2.2));

    float depth = texture2D(depthtex0, TexCoords).r;
    //albedo.rgb *= lightColor;
    
    if(albedo.a < .1 || depth < 0.1) {
        discard;
    }

    vec3 bitangent = normalize2(cross(Tangent.xyz, Normal.xyz));

    mat3 tbnMatrix = mat3(Tangent.xyz, bitangent.xyz, Normal.xyz);

    vec3 newNormal = Normal;

    newNormal = (gbufferModelViewInverse * vec4(newNormal, 1.0)).xyz;

    /*if(mc_Entity.x < 10005 || mc_Entity.x > 10010) {
        lightColor = vec3(0);
    }*/

    albedo.xyz = pow2(albedo.xyz, vec3(1/2.2));

    float distanceFromCamera = distance(vec3(0), viewSpaceFragPosition);

    if(blindness > 0f) {
        albedo.xyz = blindEffect(albedo.xyz);
    }

    gl_FragData[0] = albedo;
    gl_FragData[1] = vec4(newNormal * 0.5 + 0.5f, 1.0f);
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
    gl_FragData[4] = vec4(0.0,1.0,isReflective,1.0);
    gl_FragData[6] = vec4(worldSpaceVertexPosition, 1.0);
}