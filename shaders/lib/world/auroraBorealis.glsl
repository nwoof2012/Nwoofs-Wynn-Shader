float auroraHash(vec2 p) {
    p = fract(sin(vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)))) * 43758.5453);
    return fract(p.x + p.y);
}

float auroraNoise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix2(mix2(auroraHash(i + vec2(0.0, 0.0)), auroraHash(i + vec2(1.0, 0.0)), u.x),
               mix2(auroraHash(i + vec2(0.0, 1.0)), auroraHash(i + vec2(1.0, 1.0)), u.x), u.y);
}

float auroraBorealis(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;

    vec2 frequency = vec2(1.0, 8.0);

    for(int i = 0; i < 4; i++) {
        value += amplitude * auroraNoise(p * frequency);
        p += vec2(frameTimeCounter * 0.05, 0.0);
        frequency *= 2.0;
        amplitude *= 0.5;
    }

    return value;
}