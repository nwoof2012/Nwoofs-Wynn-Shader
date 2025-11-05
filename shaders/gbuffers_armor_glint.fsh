#version 460 compatibility

uniform sampler2D colortex0;
uniform float frameTimeCounter;
varying vec2 TexCoords;

#include "lib/colorFunctions.glsl"

/* RENDERTARGETS:0,2 */

void main() {
    vec4 texColor = texture2D(colortex0, TexCoords);

    vec4 hsv = CalcHSV(texColor.xyz);
    float glintMask = smoothstep(0.6, 0.8, hsv.y) * smoothstep(0.8, 1.0, hsv.w);

    vec3 fallbackGlint = vec3(0.95, 0.8, 0.15);

    float shimmer = 0.5 + 0.5 * sin((TexCoords.y + TexCoords.x) * 20 + frameTimeCounter * 10.0);

    vec3 color = texColor.rgb * (0.8 + 0.2 * shimmer) + fallbackGlint * 0.2 * shimmer;
    color = mix(color, fallbackGlint, glintMask * 0.5);
    vec3 light = texColor.rgb * (0.8 + 0.5 * shimmer) + fallbackGlint * 0.5 * shimmer;

    gl_FragData[0] = vec4(color, texColor.a);
    gl_FragData[1] = vec4(light, 1.0);
}