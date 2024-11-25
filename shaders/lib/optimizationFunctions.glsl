vec2 normalize2(vec2 a) {
    return a * inversesqrt(dot(a,a));
}
vec3 normalize2(vec3 a) {
    return a * inversesqrt(dot(a,a));
}
vec4 normalize2(vec4 a) {
    return a * inversesqrt(dot(a,a));
}

float pow2(float a, float b) {
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

float mix2(float a, float b, float c) {
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