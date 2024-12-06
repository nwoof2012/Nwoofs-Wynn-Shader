#version 460 compatibility

#define OVERWORLD

in vec4 glColor;

in float sunVisibility2;

#include "lib/optimizationFunctions.glsl"
#include "lib/common.glsl"
#include "lib/colorMultipliers.glsl"
#include "lib/spaceConversion.glsl"

varying vec2 TexCoords;
varying vec3 Normal;

uniform sampler2D noises;

/* DRAWBUFFERS:063 */

void main() {
    vec3 Color = texture2D(noises, TexCoords).rgb;

    //Color = vec3(dot(Color, vec3(0.333f)));

    float cloudNoise = texture2D(colortex0, TexCoords * 55f).g;

    vec4 color = texture2D(noises, TexCoords) * glColor;
    
    vec3 dayDownSkyColor = vec3(1.0);

    vec3 dayMiddleSkyColor = vec3(1.0);

    float sunFactor = sunVisibility2;

    vec4 translucentMult = vec4(mix2(vec3(0.666), color.rgb * (1.0 - pow2(pow2(color.a))), color.a), 1.0);
    vec3 cloudLight = mix2(vec3(0.8, 1.6, 1.5) * sqrt1(nightFactor), mix2(dayDownSkyColor, dayMiddleSkyColor, 0.1), sunFactor);
    color.rgb *= sqrt(cloudLight) * (1.2 + 0.4 * noonFactor * invRainFactor);
    color.rgb *= vec3(1) * 0.01;
    color.rgb *= sqrt(GetAtmColorMult()); // C72380KD - Reduced atmColorMult impact on things
    //color.rgb *= moonPhaseInfluence;
    vec3 screenPos = vec3(gl_FragCoord.xy / vec2(viewWidth, viewHeight), gl_FragCoord.z);
    vec3 viewPos = ScreenToView(screenPos);
    vec3 playerPos = ViewToPlayer(viewPos);

    float xzMaxDistance = max(abs(playerPos.x), abs(playerPos.z));
    float cloudDistance = 375.0;
    cloudDistance = clamp((cloudDistance - xzMaxDistance) / cloudDistance, 0.0, 1.0);
    color.rgb = vec3(1) - color.rgb;
    //color.a *= clamp01(cloudDistance * 3.0);
    color.a = 1.0f;
    gl_FragData[0] = vec4(0);
    gl_FragData[1] = vec4(0.0, 0.0, 0.0, 1.0);
    gl_FragData[2] = vec4(1.0 - translucentMult.rgb, translucentMult.a);

    //gl_FragData[0] = vec4(Color, 1.0f);
}