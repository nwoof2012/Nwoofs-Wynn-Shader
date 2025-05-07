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