#ifdef FRAGMENT_SHADER
    #include "/lib/data/settings.glsl"
    uniform sampler2D lightmap;
    uniform sampler2D gtexture;

    uniform mat4 gbufferModelView;
    uniform mat4 gbufferProjection;
    uniform mat4 gbufferModelViewInverse;
    uniform mat4 gbufferProjectionInverse;

    in vec2 LmCoord;
    in vec2 TexCoords;
    in vec4 GlColor;
    in vec3 Normal;

    #include "/lib/optimizationFunctions.glsl"
 
    layout(location = 0) out vec4 color;
    layout(location = 1) out vec4 outnormal;
    layout(location = 2) out vec4 outlight;
    layout(location = 3) out vec4 outbufferA;

    /* RENDERTARGETS: 0,1,2,5 */
    void main() {
        color = texture2D(gtexture, TexCoords) * GlColor;
        //color.a = 1 - step(color.a, 0.5);
        outnormal = vec4((gbufferModelViewInverse * vec4(Normal, 1.0)).xyz * 0.5 + 0.5,1.0);

        outlight = encodeLight(color * 1.5, MAX_LIGHT);

        outbufferA = vec4(0.0, 0.0, 0.0, step(0.5,color.a));

        //if(color.a < 0.5) discard;
    }
#endif

#ifdef VERTEX_SHADER
    out vec2 LmCoord;
    out vec2 TexCoords;
    out vec4 GlColor;
    out vec3 Normal;

    void main() {
        gl_Position = ftransform();

        TexCoords = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
        LmCoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;

        GlColor = gl_Color;
        Normal = gl_NormalMatrix * gl_Normal;
    }
#endif