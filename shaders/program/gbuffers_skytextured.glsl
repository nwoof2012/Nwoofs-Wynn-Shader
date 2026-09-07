#ifdef FRAGMENT_SHADER
    uniform sampler2D gtexture;

    in vec2 TexCoords;
    in vec4 Color;

    uniform float alphaTestRef = 0.1;

    #include "/lib/data/settings.glsl"

    /* RENDERTARGETS: 0 */
    layout(location = 0) out vec4 outcolor;

    void main() {
        #if SUN_STYLE == 1
            outcolor = vec4(0.0);
        #elif SUN_STYLE == 0
            outcolor = texture2D(gtexture, TexCoords) * Color;
            if (outcolor.a < alphaTestRef) {
                discard;
            }
        #endif
    }
#endif

#ifdef VERTEX_SHADER
    out vec2 TexCoords;
    out vec4 Color;
    
    void main() {
        gl_Position = ftransform();
        TexCoords = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
        Color = gl_Color;
    }
#endif