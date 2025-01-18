#version 460 compatibility

#include "lib/globalDefines.glsl"

#include "lib/optimizationFunctions.glsl"
#include "program/underwater.glsl"

varying vec2 TexCoords;
varying vec3 Normal;
varying vec4 Color;

varying vec2 LightmapCoords;

uniform sampler2D lightmap;
uniform sampler2D texture;

uniform sampler2D noise;

uniform int heldItemId;

uniform int worldTime;
uniform int frameCounter;
uniform float frameTime;

uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjectionInverse;

float AdjustLightmapTorch(in float torch) {
    const float K = 2.0f;
    const float P = 5.06f;
    return K * pow2(torch, P);
}

float AdjustLightmapSky(in float sky){
    float sky_2 = sky * sky;
    return sky_2 * sky_2;
}

vec2 AdjustLightmap(in vec2 Lightmap){
    vec2 NewLightMap;
    NewLightMap.x = AdjustLightmapTorch(Lightmap.x);
    NewLightMap.y = AdjustLightmapSky(Lightmap.y);
    return NewLightMap;
}

vec4 vanillaLight(in vec2 Lightmap) {
    const vec3 TorchColor = vec3(1.0f, 1.0f, 1.0f);
    vec4 lightColor = vec4(TorchColor * Lightmap.x,1.0);
    return lightColor;
}

/* RENDERTARGETS:0,1,2,4,5,15 */

void main() {
    vec4 noiseMap3 = texture2D(noise, TexCoords - sin(TexCoords.y*64f + ((frameCounter)/90f)) * 0.005f);
    
    //vec4 albedo = vec4(isInWater(texture, Color.xyz, TexCoords, noiseMap3.xy, 0.125), texture2D(texture, TexCoords + noiseMap3.xy).a);

    vec4 albedo = texture2D(texture, TexCoords) * Color;
    
    float a;

    if(albedo.a > 0 && heldItemId == 1) {
        a = 1;
    } else {
        a = 0;
    }

    vec3 newNormal = (gbufferModelViewInverse * vec4(Normal,1.0)).xyz;
    
    gl_FragData[0] = albedo;
    gl_FragData[1] = vec4(newNormal * 0.5 + 0.5f, 1.0f);
    #ifdef SCENE_AWARE_LIGHTING
        vec4 vanilla = vanillaLight(AdjustLightmap(LightmapCoords));
        vec4 lighting = mix2( pow2(vanilla * 0.5f,vec4(0.25f)),vec4(vec3(0.0),1.0),clamp(length(max(vec3(1.0) - vanilla.xyz,vec3(0.0))),0,1));
        gl_FragData[2] = vec4(lighting.xyz, 1.0);
    #else
        gl_FragData[2] = vec4(LightmapCoords, 0.0f, 1.0f);
    #endif
    gl_FragData[3] = vec4(a);
    gl_FragData[4] = vec4(0.0, 1.0, 0.0, 1.0);
    gl_FragData[5] = vec4(1.0);
}