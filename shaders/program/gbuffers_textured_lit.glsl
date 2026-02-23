#ifdef FRAGMENT_SHADER
    varying vec2 TexCoords;

    varying vec4 Color;

    uniform sampler2D colortex0;
    uniform sampler2D texture;

    varying vec3 Normal;
    varying vec2 LightmapCoords;

    uniform float near;
    uniform float far;

    uniform int viewWidth;
    uniform int viewHeight;

    uniform vec3 cameraPosition;

    #include "/lib/globalDefines.glsl"

    #include "/lib/includes2.glsl"
    #include "/lib/optimizationFunctions.glsl"

    /* RENDERTARGETS:0,1,2,6,5 */
    void main() {
        vec4 color = texture2D(texture, TexCoords) * Color;

        mediump float a;

        mediump float distanceFromCamera = distance(vec3(0), viewSpaceFragPosition);
        
        gl_FragData[0] = color;
        gl_FragData[1] = vec4((mat3(gbufferModelViewInverse) * Normal) * 0.5 + 0.5, 1.0);
        #if LIGHTING_MODE == 1
            gl_FragData[2] = vec4(color.xyz * 0.5f, 1.0f);
        #else
            gl_FragData[2] = vec4(LightmapCoords, 0.0f, 1.0f);
        #endif
        gl_FragData[3] = vec4(a, 0.0, 0.0, 1.0);
        gl_FragData[4] = vec4(0.0,1.0,1.0,1.0);
    }
#endif

#ifdef VERTEX_SHADER
    varying vec2 TexCoords;

    varying vec4 Color;

    varying vec3 Normal;
    varying vec2 LightmapCoords;

    out vec3 viewSpaceFragPosition;

    void main() {
        gl_Position = ftransform();
        LightmapCoords = mat2(gl_TextureMatrix[1]) * gl_MultiTexCoord1.st;

        viewSpaceFragPosition = (gl_ModelViewMatrix * gl_Vertex).xyz;

        TexCoords = gl_MultiTexCoord0.st;
        Normal = gl_NormalMatrix * gl_Normal;
        Color = gl_Color;
        LightmapCoords = (LightmapCoords * 33.05f / 32.0f) - (1.05f / 32.0f);
    }
#endif