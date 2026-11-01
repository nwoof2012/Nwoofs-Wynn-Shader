#ifdef FRAGMENT_SHADER
    uniform sampler2D colortex2;
    uniform sampler2D colortex20;

    #include "/lib/post/bloom.glsl"

    //const bool colortex20Clear = false;
    
    /*
        const bool colortex20MipmapEnabled = true;
    */

    in vec2 texcoord;

    /* RENDERTARGETS: 20 */
    layout(location = 0) out vec4 color;

    void main() {
        color = texture(colortex2, texcoord);
    }
#endif

#ifdef VERTEX_SHADER
    out vec2 texcoord;

    void main() {
        gl_Position = ftransform();
        texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    }
#endif