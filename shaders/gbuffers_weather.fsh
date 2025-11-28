#version 460 compatibility

#define TILTED_RAIN

precision mediump float;

uniform sampler2D lightmap;
uniform sampler2D gtexture;

in vec2 lmcoord;
in vec2 texcoord;
in vec4 glcolor;

uniform float rainStrength;

uniform float near;
uniform float far;

uniform int viewWidth;
uniform int viewHeight;

uniform vec3 cameraPosition;

/* DRAWBUFFERS:035 */
layout(location = 0) out vec4 color;
layout(location = 1) out vec4 isRain;
layout(location = 2) out vec4 isWater;

void main() {
    #ifdef TILTED_RAIN
        color = texture2D(gtexture, vec2(texcoord.x - texcoord.y, texcoord.y)) * glcolor;
    #else
        color = texture2D(gtexture, texcoord) * glcolor;
    #endif
    color *= texture2D(lightmap, lmcoord);
    
	if (color.a >= 0.1) {
		if(color.b > color.g && color.b > color.a) {
            isWater = vec4(1f, 1f, 1f, 1f);
            isRain = vec4(vec3(0f),1.0);
        } else {
            isWater = vec4(0f, 1f, 1f, 1f);
            isRain = vec4(0f);
        }
	}
}