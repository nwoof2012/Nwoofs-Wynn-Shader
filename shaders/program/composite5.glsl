#ifdef FRAGMENT_SHADER
    #include "/lib/includes2.glsl"
    #include "/lib/optimizationFunctions.glsl"
    #include "/lib/data/settings.glsl"
    #include "/lib/colorFunctions.glsl"
    
    uniform sampler2D colortex0;
    uniform sampler2D colortex17;

    in vec2 texCoord;

    uniform float frameTime;
    uniform float seFactor;

    const bool colortex17Clear = false;

    /*
        const bool colortex17MipmapEnabled = true;
    */

    /* RENDERTARGETS: 17 */
    layout(location = 0) out vec4 outcolor;

    void main() {
        float targetExp = mix2(NORM_EXP, SE_EXP, seFactor);
        float targetSpeed = mix2(NORM_EXP_SPEED, SE_EXP_SPEED, seFactor);
        #ifdef AUTO_EXPOSURE
            vec4 prevColor = pow2(texture2D(colortex17, texCoord),vec4(2.2)) * 25;
            vec4 color = pow2(texture2D(colortex0, texCoord),vec4(2.2));
            float prevExp = dot(prevColor.xyz, vec3(0.2126, 0.7152, 0.0722));
            float logLum = log(max(prevExp, 1e-4));
            float avgLum = exp(logLum);
            if(prevExp > targetExp) targetSpeed *= 1.5;
            prevColor /= 25;
            float expValue = targetExp/prevExp;
            float expDiff = abs(log2(expValue));
            if(expDiff < 0.05) targetExp = prevExp;
            vec4 expColor = color/25 * expValue;
            outcolor = mix2(prevColor, expColor, clamp(1 - exp(-targetSpeed * frameTime * 0.5), 0, 1));
        #else
            outcolor = texture2D(colortex0, texCoord)/25 * exp2(targetExp);
        #endif
        outcolor.xyz = pow2(outcolor.xyz, vec3(1/2.2));
    }
#endif

#ifdef VERTEX_SHADER
    out vec2 texCoord;

    out float exposureMultiplier;

    void main() {
        gl_Position = ftransform();
        texCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    }
#endif