#version 460 compatibility

#include "lib/globalDefines.glsl"

precision mediump float;

uniform float viewWidth;
uniform float viewHeight;

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D colortex3;
uniform sampler2D colortex4;
uniform sampler2D colortex5;
uniform sampler2D colortex6;
uniform sampler2D colortex10;

in vec4 lightSourceData;

varying vec2 TexCoords;

mediump float weight[7] = float[7](1.0, 6.0, 15.0, 20.0, 15.0, 6.0, 1.0);

vec2 view = vec2(viewWidth, viewHeight);

vec3 BloomTile(float lod, vec2 offset, vec2 scaledCoord) {
    vec3 bloom = vec3(0.0);
    mediump float scale = exp2(lod);
    vec2 coord = (scaledCoord - offset) * scale;
    mediump float padding = 0.5 + 0.005 * scale;

    if (abs(coord.x - 0.5) < padding && abs(coord.y - 0.5) < padding) {
        for (int i = -3; i <= 3; i++) {
            for (int j = -3; j <= 3; j++) {
                mediump float wg = weight[i + 3] * weight[j + 3];
                vec2 pixelOffset = vec2(i, j) / view;
                vec2 bloomCoord = (scaledCoord - offset + pixelOffset) * scale;
                bloom += texture2D(colortex0, bloomCoord).rgb * wg;
            }
        }
        bloom /= 4096.0;
    }

    return pow(bloom / 128.0, vec3(0.25));
}

/* RENDERTARGETS:0,1,2,3,4,5,6,10 */

void main() {
    gl_FragData[0] = texture2D(colortex0, TexCoords);
    gl_FragData[1] = texture2D(colortex1, TexCoords);
    gl_FragData[2] = texture2D(colortex2, TexCoords);
    gl_FragData[3] = texture2D(colortex3, TexCoords);
    gl_FragData[4] = texture2D(colortex4, TexCoords);
    gl_FragData[5] = texture2D(colortex5, TexCoords);
    gl_FragData[6] = texture2D(colortex6, TexCoords);
    gl_FragData[7] = texture2D(colortex10,TexCoords);
}