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

mediump float GetHorizonFactor(float XdotU) {
    #ifdef SUN_MOON_HORIZON
        mediump float horizon = clamp((XdotU + 0.1) * 10.0, 0.0, 1.0);
        horizon *= horizon;
        return horizon * horizon * (3.0 - 2.0 * horizon);
    #else
        mediump float horizon = min(XdotU + 1.0, 1.0);
        horizon *= horizon;
        horizon *= horizon;
        return horizon * horizon;
    #endif
}

void main() {
    gl_FragData[0] = vec4(0.0);
}