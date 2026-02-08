#ifdef VERTEX_SHADER
    out vec3 viewSpaceFragPosition;
#endif

#ifdef FRAGMENT_SHADER
    in vec3 viewSpaceFragPosition;
#endif

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferProjection;

uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferModelView;