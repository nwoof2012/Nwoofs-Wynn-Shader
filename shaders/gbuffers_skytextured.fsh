#version 460 compatibility

precision mediump float;

uniform sampler2D gtexture;

in vec2 texcoord;
in vec4 glcolor;

flat in vec3 upVec, sunVec;

uniform float near;
uniform float far;

in float viewWidth, viewHeight;
in vec3 position;

uniform vec3 cameraPosition;

#include "lib/globalDefines.glsl"
#include "lib/includes2.glsl"
#include "lib/optimizationFunctions.glsl"

/* DRAWBUFFERS:0 */

uniform float rainFactor;

mediump float SdotU = dot(sunVec, upVec);
mediump float sunVisibility = clamp(SdotU + 0.0625, 0.0, 0.125) / 0.125;
mediump float sunVisibility2 = sunVisibility * sunVisibility;

#include "lib/commonFunctions.glsl"

void main() {
	vec4 color = texture(gtexture, texcoord) * glcolor;
	if (color.a >= 0.1) {
		vec4 screenPos = vec4(gl_FragCoord.xy / vec2(viewWidth, viewHeight), gl_FragCoord.z, 1.0);
        vec4 viewPos = gbufferProjectionInverse * (screenPos * 2.0 - 1.0);
        viewPos /= viewPos.w;
        vec3 nViewPos = normalize2(viewPos.xyz);

        mediump float VdotS = dot(nViewPos, sunVec);
        mediump float VdotU = dot(nViewPos, upVec);

        if (VdotS > 0.0) { // Sun
            color.rgb *= dot(color.rgb, color.rgb) * 3.2;
            color.rgb *= 0.25 + (0.75 - 0.25 * rainFactor) * sunVisibility2;
            color.a = smoothstep1(clamp01(length(sunVec - position)));
        } else { // Moon
            color.rgb *= smoothstep1(min1(length(color.rgb))) * 1.3;
            color.a = smoothstep1(clamp01(length(abs(sunVec - position))));
        }

        color.rgb *= GetHorizonFactor(VdotU);
        color.a = 0;

        gl_FragData[0] = color;
	}
}