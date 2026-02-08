vec2 normalize2(vec2 a) {
    return a * inversesqrt(dot(a,a));
}
vec3 normalize2(vec3 a) {
    return a * inversesqrt(dot(a,a));
}
vec4 normalize2(vec4 a) {
    return a * inversesqrt(dot(a,a));
}

mediump float pow2(float a, float b) {
    return exp2(log2(a) * b);
}

vec2 pow2(vec2 a, vec2 b) {
    return exp2(log2(a) * b);
}

vec3 pow2(vec3 a, vec3 b) {
    return exp2(log2(a) * b);
}
vec4 pow2(vec4 a, vec4 b) {
    return exp2(log2(a) * b);
}

mediump float mix2(float a, float b, float c) {
    return (b - a) * c + a;
}

vec2 mix2(vec2 a, vec2 b, float c) {
    return (b - a) * c + a;
}

vec2 mix2(vec2 a, vec2 b, vec2 c) {
    return (b - a) * c + a;
}

vec3 mix2(vec3 a, vec3 b, float c) {
    return (b - a) * c + a;
}

vec3 mix2(vec3 a, vec3 b, vec3 c) {
    return (b - a) * c + a;
}

vec4 mix2(vec4 a, vec4 b, float c) {
    return (b - a) * c + a;
}

vec4 mix2(vec4 a, vec4 b, vec4 c) {
    return (b - a) * c + a;
}

float mix3(float a, float b, float c, float d, float h) {
    float outA = mix2(a, b, smoothstep(0.0, h, d));
    float outB = mix2(b, c, smoothstep(h, 1.0, d));
    return mix2(outA, outB, d);
}

vec2 mix3(vec2 a, vec2 b, vec2 c, float d, float h) {
    vec2 outA = mix2(a, b, smoothstep(0.0, h, d));
    vec2 outB = mix2(b, c, smoothstep(h, 1.0, d));
    return mix2(outA, outB, d);
}

vec3 mix3(vec3 a, vec3 b, vec3 c, float d, float h) {
    vec3 outA = mix2(a, b, smoothstep(0.0, h, d));
    vec3 outB = mix2(b, c, smoothstep(h, 1.0, d));
    return mix2(outA, outB, d);
}

vec4 mix3(vec4 a, vec4 b, vec4 c, float d, float h) {
    vec4 outA = mix2(a, b, smoothstep(0.0, h, d));
    vec4 outB = mix2(b, c, smoothstep(h, 1.0, d));
    return mix2(outA, outB, d);
}

mediump float blockDist(vec3 a, vec3 b) {
    a = abs(a);
    b = abs(b);
    b -= vec3(0.5);
    return sqrt(dot(a - b, a - b));
}


bool isVectorLessThan(vec2 a, vec2 b) {
    return a.x < b.x && a.y < b.y;
}

bool isVectorLessEqual(vec2 a, vec2 b) {
    return a.x <= b.x && a.y <= b.y;
}

bool isVectorGreaterThan(vec2 a, vec2 b) {
    return a.x > b.x && a.y > b.y;
}

bool isVectorGreaterEqual(vec2 a, vec2 b) {
    return a.x >= b.x && a.y >= b.y;
}


bool isVectorLessThan(vec3 a, vec3 b) {
    return a.x < b.x && a.y < b.y && a.z < b.z;
}

bool isVectorLessEqual(vec3 a, vec3 b) {
    return a.x <= b.x && a.y <= b.y && a.z <= b.z;
}

bool isVectorGreaterThan(vec3 a, vec3 b) {
    return a.x > b.x && a.y > b.y && a.z > b.z;
}

bool isVectorGreaterEqual(vec3 a, vec3 b) {
    return a.x >= b.x && a.y >= b.y && a.z >= b.z;
}


bool isVectorLessThan(vec4 a, vec4 b) {
    return a.x < b.x && a.y < b.y && a.z < b.z && a.w < b.w;
}

bool isVectorLessEqual(vec4 a, vec4 b) {
    return a.x <= b.x && a.y <= b.y && a.z <= b.z && a.w <= b.w;
}

bool isVectorGreaterThan(vec4 a, vec4 b) {
    return a.x > b.x && a.y > b.y && a.z > b.z && a.w > b.w;
}

bool isVectorGreaterEqual(vec4 a, vec4 b) {
    return a.x >= b.x && a.y >= b.y && a.z >= b.z && a.w >= b.w;
}

vec2 maxVector(vec2 a, vec2 b) {
    return mix2(b, a, step(length(b) + 1e-6,length(a)));
}

vec3 maxVector(vec3 a, vec3 b) {
    return mix2(b, a, step(length(b) + 1e-6,length(a)));
}

vec4 maxVector(vec4 a, vec4 b) {
    return mix2(b, a, step(length(b) + 1e-6,length(a)));
}

vec2 minVector(vec2 a, vec2 b) {
    return mix2(b, a, 1 - step(length(b) + 1e-6,length(a)));
}

vec3 minVector(vec3 a, vec3 b) {
    return mix2(b, a, 1 - step(length(b) + 1e-6,length(a)));
}

vec4 minVector(vec4 a, vec4 b) {
    return mix2(b, a, 1 - step(length(b) + 1e-6,length(a)));
}

mediump float smoothstep1(float x) {
    return x * x * (3.0 - 2.0 * x);
}
vec2 smoothstep1(vec2 x) {
    return x * x * (3.0 - 2.0 * x);
}
vec3 smoothstep1(vec3 x) {
    return x * x * (3.0 - 2.0 * x);
}
vec4 smoothstep1(vec4 x) {
    return x * x * (3.0 - 2.0 * x);
}

vec3 desaturate(vec3 color, float amount) {
    float lum = dot(color, vec3(0.2126, 0.7152, 0.0722));
    vec3 gray = vec3(lum);
    return mix2(color, gray, amount);
}

float cubicBezier(float t, vec2 p1, vec2 p2) {
    // Cubic Bézier curve: P0 = (0,0), P1 = p1, P2 = p2, P3 = (1,1)
    // Solve for y given t (where t is the x-axis progress)
    float u = 1.0 - t;
    float tt = t * t;
    float uu = u * u;
    float uuu = uu * u;
    float ttt = tt * t;

    // Bézier formula for y(t)
    float y = 
        3.0 * uu * t * p1.y +   // influence of P1.y
        3.0 * u * tt * p2.y +   // influence of P2.y
        ttt;                    // influence of P3.y (1.0)

    return y;
}

float luminance(vec3 color) {
    return dot(color, vec3(0.2126, 0.7152, 0.0722));
}

mediump float linearizeDepth(float depth, float near, float far) {
    return (near * far) / (depth * (near - far) + far);
}

// tex      = light buffer
// worldTex = texture containing world-space positions (RGB = XYZ)
// uv       = current screen-space coordinate
// texSize  = resolution of the render target (for pixel offsets)
// blurRadius = blur kernel radius (in pixels)

vec3 worldReconstruct(vec2 UVs, sampler2D depthTex) {
    vec2 ndc = UVs * 2.0 - 1.0;

    float depth = texture2D(depthTex, UVs).r;

    vec4 clipPos = vec4(ndc, depth * 2.0 - 1.0, 1.0);
    vec4 viewPos = gbufferProjectionInverse * clipPos;
    viewPos /= viewPos.w;

    vec4 worldPos = gbufferModelViewInverse * viewPos;

    return worldPos.xyz;
}

vec2 screenReconstruct(vec3 worldPos) {
    vec4 viewPos = gbufferModelView * vec4(worldPos, 1.0);
    vec4 clipPos = gbufferProjection * viewPos;
    vec3 ndc = clipPos.xyz / clipPos.w;
    return ndc.xy * 0.5 + 0.5;
}

float isLightVisible(vec3 P1, vec3 N1, vec3 P2, vec3 N2)
{
    vec3 dir12 = normalize(P2 - P1);
    float facing1 = max(0.0, dot(N1, dir12));
    float facing2 = max(0.0, dot(N2, -dir12));

    // Smooth mutual visibility factor
    float visibility = facing1 * facing2;

    // Optional: distance attenuation
    float dist2 = dot(P2 - P1, P2 - P1);
    visibility /= (1.0 + dist2 * 0.2);

    return visibility;
}

vec3 blurLight(sampler2D tex, sampler2D depthTex, vec2 UVs, float radius, int samples, float distThreshold, float depthThreshold) {
    // Calculate UVs
    vec3 worldPos = worldReconstruct(UVs, depthTex);
    float depth = texture2D(depthTex, UVs).r;

    // Calculate base color
    vec3 baseColor = texture2D(tex, UVs).xyz;

    vec3 baseNormal = texture2D(colortex1, UVs).xyz * 2 - 1;
    
    // Calculate sample radius
    int sampleRadius = int(sqrt(samples));

    // Calculate aspect ratio
    vec2 aspectRatio = vec2(viewWidth, viewHeight);
    aspectRatio.x = 1080.0/aspectRatio.y * aspectRatio.x;
    aspectRatio.y = 1080.0;
    
    ivec2 baseRes = ivec2(aspectRatio);

    // Output params
    vec3 accum = vec3(0.0);
    float weight = 0.0;

    // Blur loop
    for(int i = 0; i < samples; i++) {
        // Calculate sample offset
        int x = int(mod(i, sampleRadius)) - sampleRadius/2;
        int y = i/sampleRadius - sampleRadius/2;
        vec2 offset = vec2(x, y) * radius;
        //vec2 sampleUV = UVs + offset/vec2(baseRes);

        vec3 offsetWS = vec3(x, 0, y)/sampleRadius * radius;

        // Get sample world position
        vec3 sampleWorld = worldPos + offsetWS;

        vec3 diffWorld = normalize2(worldPos - sampleWorld);

        vec2 sampleUV = screenReconstruct(sampleWorld);

        float sampleDepth = texture2D(depthTex, sampleUV).r;
        vec3 sampleNormal = texture2D(colortex1, sampleUV).xyz * 2 - 1;

        // Test sample distance, if within threshold add to output
        float dist = length(worldPos - sampleWorld);

        float depthDist = linearizeDepth(depth, near, far) - linearizeDepth(sampleDepth, near, far);

        float visibility = isLightVisible(worldPos, baseNormal, sampleWorld, sampleNormal);

        if(visibility < 0.001 && depthDist < depthThreshold && depthDist >= -1.0) {
            vec3 sampleColor = texture2D(tex, sampleUV).rgb * 3;
            float sampleWeight = exp(-(dist * dist) / (2.0 * radius * radius));
            accum += mix2(sampleColor,baseColor, abs(dist/distThreshold)) * sampleWeight;
            weight += sampleWeight;
        }
    }

    return accum/max(weight,1.0);
}

#ifdef AUTO_EXPOSURE
    vec3 autoExposure(vec3 color, float targetLum, float speed) {
        vec4 prevColor = imageLoad(cimage14, ivec2(gl_FragCoord.xy * vec2(viewWidth, viewHeight)));
        float sceneLum = dot(color.rgb, vec3(0.2126, 0.7152, 0.0722));
        float prevAvgLum = dot(prevColor.rgb, vec3(0.2126, 0.7152, 0.0722));
        //thisExposure = prevAvgLum;
        thisLum = sceneLum;
        float smoothedFrame = mix2(timeExposure.delta, frameTime, 0.1);
        float avgLum = sceneLum; //mix2(prevAvgLum, sceneLum, 1.0 - exp(-timeExposure.time * speed));
        float exposure = targetLum * (avgLum + 1e-4);
        thisExposure = exposure;
        imageStore(cimage14, ivec2(gl_FragCoord.xy * vec2(viewWidth, viewHeight)), vec4(color * exposure,1.0));
        return color * exposure;
    }

    float calcExposure(vec3 color, float targetLum, float speed) {
        vec4 prevColor = imageLoad(cimage14, ivec2(gl_FragCoord.xy * vec2(viewWidth, viewHeight)));
        float sceneLum = dot(color.rgb, vec3(0.2126, 0.7152, 0.0722));
        float prevAvgLum = dot(prevColor.rgb, vec3(0.2126, 0.7152, 0.0722));
        return distance(prevAvgLum, sceneLum);
    }

    float currentExposure(vec3 color, float targetLum, float speed) {
        vec4 prevColor = imageLoad(cimage14, ivec2(gl_FragCoord.xy * vec2(viewWidth, viewHeight)));
        float sceneLum = dot(color.rgb, vec3(0.2126, 0.7152, 0.0722));
        float prevAvgLum = dot(prevColor.rgb, vec3(0.2126, 0.7152, 0.0722));
        float avgLum = mix2(prevAvgLum, sceneLum, 1.0 - exp(-timeExposure.time * speed));
        float exposure = targetLum * (avgLum + 1e-4);
        return exposure;
    }

    float calcTargetExposure(vec3 color, float targetLum, float speed) {
        vec4 prevColor = imageLoad(cimage14, ivec2(gl_FragCoord.xy * vec2(viewWidth, viewHeight)));
        float sceneLum = dot(color.rgb, vec3(0.2126, 0.7152, 0.0722));
        return sceneLum;
    }
#endif

vec3 contrastBoost(vec3 color, float contrast) {
    return ((color - 0.5) * contrast + 0.5);
}

vec2 calcRefraction(vec2 uv, float camDist, vec2 noise) {
    return noise.xy * vec2(0.03125f) / max(camDist,1);
}

float encodeDist(float d, float maxDist) {
    return log2(1.0 + d) / log2(1.0 + maxDist);
}

float decodeDist(float x, float maxDist) {
    return (exp2(x * log2(1.0 + maxDist)) - 1.0);
}
