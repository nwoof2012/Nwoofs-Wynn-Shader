mediump float CalcSaturation(in vec3 color) {
    vec4 k = vec4(0.0, -1.0/3.0, 2.0/3.0, -1.0);
    vec4 p = mix2(vec4(color.bg, k.wz), vec4(color.gb, k.xy), step(color.b, color.g));
    vec4 q = mix2(vec4(p.xyw, color.r), vec4(color.r, p.yzx), step(p.x, color.r));

    float d = q.x - min(q.w, q.y);
    float e = 10e-10;
    
    vec3 hsv = vec3(abs(q.z + (q.w - q.y) / (6.0 + d + e)), d / (q.x + e), q.x);
    return hsv.g;
}

mediump vec4 CalcHSV(in vec3 color) {
    float maxC = max(max(color.r, color.g), color.b);
    float minC = min(min(color.r, color.g), color.b);
    float delta = maxC - minC;
    float hue = 0.0;
    if(delta > 0.0) {
        if(maxC == color.r) hue = mod(((color.g - color.b) / delta),6.0);
        else if(maxC == color.g) hue = ((color.b - color.r) / delta) + 2.0;
        else hue = ((color.r - color.g) / delta) + 4.0;
        hue /= 6.0;
    }

    float sat = delta / maxC;

    float val = distance(vec3(0.0), color) / length(vec3(1.0));

    return vec4(hue, sat, val, maxC);
}

vec3 rgb2hsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0/3.0, 2.0/3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c) {
    vec3 p = abs(fract(c.xxx + vec3(0.0, 1.0/3.0, 2.0/3.0)) * 6.0 - 3.0);
    return c.z * mix(vec3(1.0), clamp(p - 1.0, 0.0, 1.0), c.y);
}