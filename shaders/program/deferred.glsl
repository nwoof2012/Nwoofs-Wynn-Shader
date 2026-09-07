#ifdef FRAGMENT_SHADER
    #include "/lib/data/settings.glsl"

    #define SHADOWS_ENABLED

    uniform sampler2D colortex0;
    uniform sampler2D colortex1;
    uniform sampler2D colortex2;
    uniform sampler2D depthtex0;
    uniform sampler2D depthtex1;

    uniform mat4 shadowProjectionInverse;
    uniform mat4 shadowModelViewInverse;

    uniform mat4 shadowProjection;
    uniform mat4 shadowModelView;

    uniform sampler2D shadowcolor0;
    uniform sampler2D shadowtex0;
    uniform sampler2D shadowtex1;

    uniform mat4 gbufferModelViewInverse;
    uniform mat4 gbufferProjectionInverse;

    uniform vec3 cameraPosition;

    uniform mat4 gbufferModelView;
    uniform mat4 gbufferProjection;

    uniform vec3 sunPosition;

    in vec2 texcoord;

    #include "/lib/optimizationFunctions.glsl"

    vec2 worldToScreen(vec3 worldPos) {
        vec4 viewSpace = gbufferModelView * vec4(worldPos, 1.0);
        viewSpace /= viewSpace.w;
        vec4 clipSpace = gbufferProjection * viewSpace;
        clipSpace /= clipSpace.w;
        vec2 screenSpace = clipSpace.xy;

        return screenSpace;
    }

    vec3 screenToFoot(vec2 screenPos, float depth) {
        vec3 ClipSpace = vec3(screenPos, depth) * 2.0f - 1.0f;
        vec4 ViewW = gbufferProjectionInverse * vec4(ClipSpace, 1.0f);
        vec3 View = ViewW.xyz / ViewW.w;
        vec4 World = gbufferModelViewInverse * vec4(View, 1.0f);

        return World.xyz;
    }

    mediump float Visibility(in sampler2D ShadowMap, in vec3 SampleCoords) {
        return step(SampleCoords.z - 0.001f, texture2D(ShadowMap, SampleCoords.xy).r);
    }

    mat3 tbnNormalTangent(vec3 normal, vec3 tangent) {
        vec3 bitangent = cross(tangent, normal);
        return mat3(tangent, bitangent, normal);
    }

    vec3 TransparentShadow(in vec3 SampleCoords){
        mediump float ShadowVisibility0 = Visibility(shadowtex0, SampleCoords);
        mediump float ShadowVisibility1 = Visibility(shadowtex1, SampleCoords);
        vec4 ShadowColor0 = texture2D(shadowcolor0, SampleCoords.xy);
        vec3 TransmittedColor = ShadowColor0.rgb * (1.0f - ShadowColor0.a);
        return mix2(TransmittedColor * ShadowVisibility1, vec3(1.0f), ShadowVisibility0);
    }

    #define SHADOW_TAPS 4
    #define PCF_RADIUS 4.0
    #define MIN_PCF_RADIUS 0.5
    #define MAX_PCF_RADIUS 2.0
    #define SHADOW_DIST 12 // [4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32]
    const float GOLDEN_ANGLE = 2.39996323;

    vec4 getNoise(vec2 coord){
        ivec2 screenCoord = ivec2(coord * vec2(viewWidth, viewHeight)); // exact pixel coordinate onscreen
        ivec2 noiseCoord = screenCoord % 64; // wrap to range of noiseTextureResolution
        return texelFetch(noisetex, noiseCoord, 0);
    }

    #include "/program/distort.glsl"

    vec3 GetShadow(float depth, vec3 worldPos, vec3 normal, vec3 worldSpaceSunPos, vec3 lightDir) {
        #ifndef SHADOWS_ENABLED
            return vec3(1.0);
        #endif
        /*vec3 ClipSpace = vec3(texCoord, depth) * 2.0f - 1.0f;
        vec4 ViewW = gbufferProjectionInverse * vec4(ClipSpace, 1.0f);
        vec3 View = ViewW.xyz / ViewW.w;
        vec4 World = gbufferModelViewInverse * vec4(View, 1.0f);*/
        vec4 ShadowSpace = shadowProjection * shadowModelView * vec4(worldPos,1.0);
        ShadowSpace.xy = DistortPosition(ShadowSpace.xy);
        vec3 SampleCoords = ShadowSpace.xyz * 0.5f + 0.5f;
        vec3 ShadowAccum = vec3(0.0);
        float totalWeight = 0.0; 

        #ifdef VARIABLE_PENUMBRA_SHADOWS
            float dist = dot(worldPos.xyz - worldSpaceSunPos, lightDir);
            float radiusScale = mix2(MIN_PCF_RADIUS, MAX_PCF_RADIUS, smoothstep(0, SHADOW_DIST, dist));
            float effectiveRadius = PCF_RADIUS * radiusScale;
        #else
            float effectiveRadius = PCF_RADIUS;
        #endif

        for(int i=0;i<SHADOW_TAPS;i++){
            float fi = float(i);
            
            // Uniform disk sampling
            float r = sqrt((fi + 0.5)/float(SHADOW_TAPS)) * effectiveRadius;
            float theta = fi * GOLDEN_ANGLE;
            
            // Per-fragment rotation
            float rot = fract(sin(dot(worldPos.xy, vec2(12.9898,78.233))) * 43758.5453) * 6.28318;
            mat2 rotMat = mat2(cos(rot), -sin(rot), sin(rot), cos(rot));
            
            vec2 offset = rotMat * vec2(cos(theta), sin(theta)) * r / SHADOW_RES;
            
            vec3 sampleCoord = vec3(SampleCoords.xy + offset, SampleCoords.z);
            ShadowAccum += TransparentShadow(sampleCoord);
            //totalWeight += 1.0;
        }
        ShadowAccum /= SHADOW_TAPS;
        
        return ShadowAccum;
    }

    /* RENDERTARGETS: 0,1,2,14 */
    layout(location = 0) out vec4 outcolor;
    layout(location = 1) out vec4 outnormal;
    layout(location = 2) out vec4 outlight;
    layout(location = 3) out vec4 outshadow;

    void main() {
        outcolor = texture(colortex0, texcoord);
        outnormal = texture(colortex1, texcoord);
        outlight = texture(colortex2, texcoord);

        float depth = texture2D(depthtex0, texcoord).x;
        float depth2 = texture2D(depthtex1, texcoord).x;

        if(depth == 1.0) {
            outshadow = vec4(1.0);
            return;
        }

        vec3 sunWorldPos = mat3(gbufferModelViewInverse) * sunPosition;
        vec3 sunWorldDir = normalize2(sunWorldPos);

        vec3 footPos = screenToFoot(texcoord, depth);
        
        outshadow = vec4(GetShadow(depth2, footPos, outnormal.xyz, sunWorldPos, sunWorldDir),1.0);
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