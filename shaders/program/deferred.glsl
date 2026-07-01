#ifdef FRAGMENT_SHADER
    #include "/lib/data/settings.glsl"

    uniform sampler2D colortex0;
    uniform sampler2D colortex1;
    uniform sampler2D colortex2;
    uniform sampler2D depthtex0;

    uniform mat4 gbufferModelViewInverse;
    uniform mat4 gbufferProjectionInverse;

    uniform vec3 cameraPosition;

    uniform mat4 gbufferModelView;
    uniform mat4 gbufferProjection;

    in vec2 texcoord;

    vec2 worldToScreen(vec3 worldPos) {
        vec4 viewSpace = gbufferModelView * vec4(worldPos, 1.0);
        viewSpace /= viewSpace.w;
        vec4 clipSpace = gbufferProjection * viewSpace;
        clipSpace /= clipSpace.w;
        vec2 screenSpace = clipSpace.xy;

        return screenSpace;
    }

    vec3 screenToFoot(vec2 screenPos, float depth) {
        vec2 ndc = screenPos * 2.0 - 1.0;

        vec4 clipSpace = vec4(ndc, depth, 1.0);
        vec4 viewSpace = gbufferProjectionInverse * clipSpace;
        viewSpace /= viewSpace.w;

        vec4 worldSpace = gbufferModelViewInverse * viewSpace;
        worldSpace /= worldSpace.w;

        return worldSpace.xyz;
    }

    /* RENDERTARGETS: 0,1,2 */
    layout(location = 0) out vec4 outcolor;
    layout(location = 1) out vec4 outnormal;
    layout(location = 2) out vec4 outlight;

    const int light_size = (LIGHT_RADIUS * 2) * (LIGHT_RADIUS * 2) * (LIGHT_RADIUS * 2);

    void main() {
        outcolor = texture(colortex0, texcoord);
        outnormal = texture(colortex1, texcoord);
        outlight = texture(colortex2, texcoord);
    }
#endif

#ifdef VERTEX_SHADER
    #include "/lib/data/settings.glsl"
    
    uniform mat4 gbufferModelViewInverse;

    out vec2 texcoord;
    
    in vec4 at_midBlock;

    void main() {
        gl_Position = ftransform();
        texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    }
#endif