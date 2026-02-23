#ifdef FRAGMENT_SHADER
    #define OVERWORLD

    in vec4 glColor;

    varying vec2 TexCoords;
    varying vec3 Normal;

    /* DRAWBUFFERS:0 */

    void main() {
        gl_FragData[0] = vec4(0);
    }
#endif

#ifdef VERTEX_SHADER
    const float sunPathRotation = -40.0f;

    varying vec2 TexCoords;
    varying vec3 Normal;

    uniform mat4 gbufferModelView;
    uniform mat4 gbufferModelViewInverse;

    flat out vec3 upVec, sunVec;

    out vec4 glColor;

    void main() {
        TexCoords = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;

        glColor = gl_Color;
        gl_Position = gl_ProjectionMatrix * gbufferModelView * gl_Vertex;
        Normal = gl_Normal;
    }
#endif