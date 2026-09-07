// Calculate Saturation
mediump float CalcSaturation(in vec3 color) {
    vec4 k = vec4(0.0, -1.0/3.0, 2.0/3.0, -1.0);
    vec4 p = mix2(vec4(color.bg, k.wz), vec4(color.gb, k.xy), step(color.b, color.g));
    vec4 q = mix2(vec4(p.xyw, color.r), vec4(color.r, p.yzx), step(p.x, color.r));

    float d = q.x - min(q.w, q.y);
    float e = 10e-10;
    
    vec3 hsv = vec3(abs(q.z + (q.w - q.y) / (6.0 + d + e)), d / (q.x + e), q.x);
    return hsv.g;
}

// Calculate HSV
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

// Convert RGB to HSV
vec3 rgb2hsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0/3.0, 2.0/3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

// Convert RGB to RGB
vec3 hsv2rgb(vec3 c) {
    vec3 p = abs(fract(c.xxx + vec3(0.0, 1.0/3.0, 2.0/3.0)) * 6.0 - 3.0);
    return c.z * mix(vec3(1.0), clamp(p - 1.0, 0.0, 1.0), c.y);
}

// Calculate Luminance
float luminance(vec3 color) {
    return dot(color, vec3(0.2126, 0.7152, 0.0722));
}

// Desaturate Color
vec3 desaturate(vec3 color, float amount) {
    float lum = luminance(color);
    vec3 gray = vec3(lum);
    return mix2(color, gray, amount);
}

// Color from Temperature
vec3 colorTemperatureToRGB(float k) {
    float t = clamp(k, 1000.0, 40000.0) / 100.0;
    vec3 col;
    
    // Red approximation
    col.r = (t <= 66.0) ? 1.0 : clamp(pow(t - 60.0, -0.1332047592) * 1.29293618606, 0.0, 1.0);
    // Green approximation
    col.g = (t <= 66.0) ? clamp(log(t) * 0.39008157877 - 0.63184144379, 0.0, 1.0) 
                        : clamp(pow(t - 60.0, -0.0755148492) * 1.1298908609, 0.0, 1.0);
    // Blue approximation
    col.b = (t >= 66.0) ? 1.0 : ((t <= 19.0) ? 0.0 : clamp(log(t - 10.0) * 0.5432067891 - 1.1962540823, 0.0, 1.0));
    
    return col;
}

vec4 lightStepColor(vec4 a, vec4 b) {
    return mix2(b, a, step(luminance(a.xyz), luminance(b.xyz)));
}

vec3 lightStepColor(vec3 a, vec3 b) {
    return mix2(b, a, step(luminance(a.xyz), luminance(b.xyz)));
}

float lightStep(vec4 a, vec4 b) {
    return step(luminance(a.xyz), luminance(b.xyz));
}

float lightStep(vec3 a, vec3 b) {
    return step(luminance(a.xyz), luminance(b.xyz));
}

vec4 maxLum(vec4 a, vec4 b) {
    float a_lum = luminance(a.xyz);
    float b_lum = luminance(b.xyz);

    if(a_lum > b_lum) return a;
    
    return b;
}

vec3 maxLum(vec3 a, vec3 b) {
    float a_lum = luminance(a.xyz);
    float b_lum = luminance(b.xyz);

    if(a_lum > b_lum) return a;
    
    return b;
}