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

// tex      = light buffer
// worldTex = texture containing world-space positions (RGB = XYZ)
// uv       = current screen-space coordinate
// texSize  = resolution of the render target (for pixel offsets)
// blurRadius = blur kernel radius (in pixels)

vec3 blurLight(sampler2D tex, sampler2D worldTex, sampler2D depthTex, sampler2D normalTex, vec2 uv, vec2 texSize, float lightRadius, float blurRadius, int blurSamples, float depthThreshold, float normalThreshold) {
    vec3 centerWorld = texture2D(worldTex, uv).rgb;
    vec3 centerColor = texture2D(tex, uv).rgb;

    float centerDepth = linearizeDepth(texture2D(depthTex, uv).x,near,far);
    vec3 centerNormal = normalize2(texture2D(normalTex, uv).xyz * 2 - 1);

    float centerLum = luminance(centerColor);

    float minRadius = 1.0;
    float maxRadius = 5.0;

    float lumFactor = smoothstep(0.0, 1.0, centerLum);

    float adaptiveRadius = mix(minRadius, maxRadius, lumFactor);

    vec3 result = vec3(0.0);
    float weightSum = 0.0;

    int sampleSqrt = int(sqrt(blurSamples));

    int kernel = int(adaptiveRadius);

    // Loop over blur kernel
    for (int idx = 0; idx <= blurSamples; idx++) {
        int x = int(mod(idx, sampleSqrt)) - sampleSqrt/2;
        int y = idx/sampleSqrt - sampleSqrt/2;
        vec2 offset = vec2(float(x), float(y)) / texSize * blurSamples;
        vec2 sampleUV = uv + offset*kernel;

        vec3 sampleWorld = texture2D(worldTex, sampleUV).rgb;
        vec3 sampleColor = texture2D(tex, sampleUV).rgb;

        float sampleDepth = linearizeDepth(texture2D(depthTex, sampleUV).x,near,far);
        vec3 sampleNormal = normalize2(texture2D(normalTex, sampleUV).xyz * 2 - 1);

        if(abs(centerDepth - sampleDepth) > depthThreshold || length(centerNormal - sampleNormal) > normalThreshold) continue;

        // World-space distance falloff
        float dist = length(sampleWorld - centerWorld);

        // Gaussian-style weight: smaller with distance in screen + world
        float worldWeight = exp(-dist * dist / (2.0 * adaptiveRadius * adaptiveRadius)); 
        float screenWeight = exp(-(x*x + y*y) * 0.05);

        float weight = worldWeight*lightRadius;

        result += sampleColor * weight;
        weightSum += weight;
    }

    return result / max(weightSum, 1e-5);
}

vec3 contrastBoost(vec3 color, float contrast) {
    return ((color - 0.5) * contrast + 0.5);
}