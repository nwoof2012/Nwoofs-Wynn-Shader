mediump float CalcSaturation(in vec3 color) {
    vec4 k = vec4(0.0, -1.0/3.0, 2.0/3.0, -1.0);
    vec4 p = mix2(vec4(color.bg, k.wz), vec4(color.gb, k.xy), step(color.b, color.g));
    vec4 q = mix2(vec4(p.xyw, color.r), vec4(color.r, p.yzx), step(p.x, color.r));

    float d = q.x - min(q.w, q.y);
    float e = 10e-10;
    
    vec3 hsv = vec3(abs(q.z + (q.w - q.y) / (6.0 + d + e)), d / (q.x + e), q.x);
    return hsv.g;
}