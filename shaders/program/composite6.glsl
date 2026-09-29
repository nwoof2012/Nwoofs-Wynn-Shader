#ifdef FRAGMENT_SHADER
    #define COMPOSITE_6
    #include "/lib/includes2.glsl"
    #include "/lib/optimizationFunctions.glsl"
    #include "/lib/data/settings.glsl"
    #include "/lib/colorFunctions.glsl"
    
    uniform sampler2D colortex0;
    uniform sampler2D colortex17;

    uniform sampler2D depthtex1;

    in vec2 texCoord;

    #include "/lib/post/blindness.glsl"

    uniform float frameTime;
    uniform float seFactor;

    #include "/lib/post/hdr.glsl"

    #include "/lib/post/tonemapping.glsl"

    /* RENDERTARGETS: 0 */
    layout(location = 0) out vec4 color;

    void main() {
        color = texture2D(colortex0, texCoord);
        /*#ifndef AUTO_EXPOSURE
            return;
        #endif*/
        //if(texture2D(depthtex1, texCoord).r >= 1.0) return;
        color = pow2(color,vec4(2.2));
        float targetExp = mix2(NORM_EXP, SE_EXP, seFactor);
        float targetSpeed = mix2(NORM_EXP_SPEED, SE_EXP_SPEED, seFactor);
        float targetBlend = mix2(NORM_EXP_BLEND, SE_EXP_BLEND, seFactor);
        float exposure = dot(pow(texture2D(colortex17, texCoord).xyz,vec3(2.2)) * 25, vec3(0.2126, 0.7152, 0.0722))/2;
        vec4 exposedColor = color / exposure;
        exposedColor *= (1.0 + exposedColor / MAX_LIGHT) / (1.0 + exposedColor);
        color.xyz = mix2(color.xyz, exposedColor.xyz * 0.5, targetBlend);
        color.xyz = blindEffect(color.xyz, texCoord);
        color.xyz = pow2(calcTonemap(color.xyz),vec3(1/2.2));
    }
#endif

#ifdef VERTEX_SHADER
    out vec2 texCoord;

    void main() {
        gl_Position = ftransform();
        texCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    }
#endif