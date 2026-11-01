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

vec4 lightTrilinear(sampler3D tex, vec3 coords, ivec3 voxel_pos) {
    vec3 p000 = vec3(voxel_pos)/vec3(VOXEL_AREA);
    vec3 p100 = (vec3(voxel_pos) + vec3(1, 0, 0))/vec3(VOXEL_AREA);
    vec3 p010 = (vec3(voxel_pos) + vec3(0, 1, 0))/vec3(VOXEL_AREA);
    vec3 p001 = (vec3(voxel_pos) + vec3(0, 0, 1))/vec3(VOXEL_AREA);
    vec3 p110 = (vec3(voxel_pos) + vec3(1, 1, 0))/vec3(VOXEL_AREA);
    vec3 p101 = (vec3(voxel_pos) + vec3(1, 0, 1))/vec3(VOXEL_AREA);
    vec3 p011 = (vec3(voxel_pos) + vec3(0, 1, 1))/vec3(VOXEL_AREA);
    vec3 p111 = (vec3(voxel_pos) + vec3(1, 1, 1))/vec3(VOXEL_AREA);

    vec3 f = fract(coords + VOXEL_RADIUS);

    vec4 c000 = texture3D(tex, p000).rgba;
    vec4 c100 = texture3D(tex, p100).rgba;
    vec4 c010 = texture3D(tex, p010).rgba;
    vec4 c001 = texture3D(tex, p001).rgba;
    vec4 c110 = texture3D(tex, p110).rgba;
    vec4 c101 = texture3D(tex, p101).rgba;
    vec4 c011 = texture3D(tex, p011).rgba;
    vec4 c111 = texture3D(tex, p111).rgba;

    vec4 c00 = mix2(c000, c100, f.x);
    vec4 c01 = mix2(c001, c101, f.x);
    vec4 c10 = mix2(c010, c110, f.x);
    vec4 c11 = mix2(c011, c111, f.x);
    
    vec4 c0 = mix2(c00, c10, f.y);
    vec4 c1 = mix2(c01, c11, f.y);

    return mix2(c0, c1, f.z);
}

vec3 getSkyColorA(float timeBlendFactor, vec3 viewPos) {
    vec3 outputColor = vec3(0.0);

    vec3 dayColor = vec3(SKY_DAY_A_R,SKY_DAY_A_G,SKY_DAY_A_B);
    vec3 nightColor = vec3(SKY_NIGHT_A_R,SKY_NIGHT_A_G,SKY_NIGHT_A_B);
    vec3 sunsetColor = vec3(SKY_SUNSET_A_R,SKY_SUNSET_A_G,SKY_SUNSET_A_B);

    vec3 dayColorRain = vec3(SKY_DAY_RAIN_A_R, SKY_DAY_RAIN_A_G, SKY_DAY_RAIN_A_B);
    //vec3 nightColorRain = vec3(SKY_NIGHT_RAIN_A_R, SKY_NIGHT_RAIN_A_G, SKY_NIGHT_RAIN_A_B);
    //vec3 sunsetColorRain = vec3(SKY_SUNSET_RAIN_A_R, SKY_SUNSET_RAIN_A_G, SKY_SUNSET_RAIN_A_B);

    if(rainFactor > 0.0) {
        dayColor = mix2(dayColor, dayColorRain, rainFactor);
        //nightColor = mix2(nightColor, nightColorRain, rainFactor);
        //sunsetColor = mix2(nightColor, sunsetColorRain, rainFactor);
    }

    vec3 dayColorSe = vec3(SKY_SE_DAY_A_R,SKY_SE_DAY_A_G,SKY_SE_DAY_A_B);
    vec3 nightColorSe = vec3(SKY_SE_NIGHT_A_R,SKY_SE_NIGHT_A_G,SKY_SE_NIGHT_A_B);
    vec3 sunsetColorSe = vec3(SKY_SE_SUNSET_A_R, SKY_SE_SUNSET_A_G, SKY_SE_SUNSET_A_B);

    if(seFactor > 0.0) {
        dayColor = mix2(dayColor, dayColorSe, seFactor);
        nightColor = mix2(nightColor, nightColorSe, seFactor);
        sunsetColor = mix2(nightColor, sunsetColorSe, seFactor);
    }
    
    vec3 dayColorCorrupt = vec3(SKY_CORRUPTION_DAY_A_R,SKY_CORRUPTION_DAY_A_G,SKY_CORRUPTION_DAY_A_B);
    vec3 nightColorCorrupt = vec3(SKY_CORRUPTION_NIGHT_A_R,SKY_CORRUPTION_NIGHT_A_G,SKY_CORRUPTION_NIGHT_A_B);
    vec3 sunsetColorCorrupt = vec3(SKY_CORRUPTION_SUNSET_A_R,SKY_CORRUPTION_SUNSET_A_G,SKY_CORRUPTION_SUNSET_A_B);

    if(corruptionFactor > 0.0) {
        dayColor = mix2(dayColor, dayColorCorrupt, corruptionFactor);
        nightColor = mix2(nightColor, nightColorCorrupt, corruptionFactor);
        sunsetColor = mix2(nightColor, sunsetColorCorrupt, corruptionFactor);
    }

    if(timeBlendFactor == 0.0) {
        outputColor = dayColor;
    }
    else if(timeBlendFactor == 1.0) {
        outputColor = nightColor;
    }
    else {
        outputColor = mix2(dayColor, nightColor, timeBlendFactor);

        vec3 viewDir = normalize2(viewPos);
        vec3 sunDir = normalize2(sunPosition);

        float viewDotSun = dot(viewDir, sunDir);

        float phase = pow2(0.5 + 0.5 * viewDotSun, 4.0);

        outputColor = mix2(outputColor, sunsetColor, phase * sunsetBlendFactor);
    }

    return outputColor;
}

vec3 getSkyColorB(float timeBlendFactor, vec3 viewPos) {
    vec3 outputColor = vec3(0.0);

    vec3 dayColor = vec3(SKY_DAY_B_R,SKY_DAY_B_G,SKY_DAY_B_B);
    vec3 nightColor = vec3(SKY_NIGHT_B_R,SKY_NIGHT_B_G,SKY_NIGHT_B_B);
    vec3 sunsetColor = vec3(SKY_SUNSET_B_R,SKY_SUNSET_B_G,SKY_SUNSET_B_B);

    vec3 dayColorRain = vec3(SKY_DAY_RAIN_B_R, SKY_DAY_RAIN_B_G, SKY_DAY_RAIN_B_B);
    //vec3 nightColorRain = vec3(SKY_NIGHT_RAIN_B_R, SKY_NIGHT_RAIN_B_G, SKY_NIGHT_RAIN_B_B);
    //vec3 sunsetColorRain = vec3(SKY_SUNSET_RAIN_B_R, SKY_SUNSET_RAIN_B_G, SKY_SUNSET_RAIN_B_B);

    if(rainFactor > 0.0) {
        dayColor = mix2(dayColor, dayColorRain, rainFactor);
        //nightColor = mix2(nightColor, nightColorRain, rainFactor);
        //sunsetColor = mix2(nightColor, sunsetColorRain, rainFactor);
    }

    vec3 dayColorSe = vec3(SKY_SE_DAY_B_R,SKY_SE_DAY_B_G,SKY_SE_DAY_B_B);
    vec3 nightColorSe = vec3(SKY_SE_NIGHT_B_R,SKY_SE_NIGHT_B_G,SKY_SE_NIGHT_B_B);
    vec3 sunsetColorSe = vec3(SKY_SE_SUNSET_B_R, SKY_SE_SUNSET_B_G, SKY_SE_SUNSET_B_B);

    if(seFactor > 0.0) {
        dayColor = mix2(dayColor, dayColorSe, seFactor);
        nightColor = mix2(nightColor, nightColorSe, seFactor);
        sunsetColor = mix2(nightColor, sunsetColorSe, seFactor);
    }
    
    vec3 dayColorCorrupt = vec3(SKY_CORRUPTION_DAY_B_R,SKY_CORRUPTION_DAY_B_G,SKY_CORRUPTION_DAY_B_B);
    vec3 nightColorCorrupt = vec3(SKY_CORRUPTION_NIGHT_B_R,SKY_CORRUPTION_NIGHT_B_G,SKY_CORRUPTION_NIGHT_B_B);
    vec3 sunsetColorCorrupt = vec3(SKY_CORRUPTION_SUNSET_B_R,SKY_CORRUPTION_SUNSET_B_G,SKY_CORRUPTION_SUNSET_B_B);

    if(corruptionFactor > 0.0) {
        dayColor = mix2(dayColor, dayColorCorrupt, corruptionFactor);
        nightColor = mix2(nightColor, nightColorCorrupt, corruptionFactor);
        sunsetColor = mix2(nightColor, sunsetColorCorrupt, corruptionFactor);
    }

    if(timeBlendFactor == 0.0) {
        outputColor = dayColor;
    }
    else if(timeBlendFactor == 1.0) {
        outputColor = nightColor;
    }
    else {
        outputColor = mix2(dayColor, nightColor, timeBlendFactor);

        vec3 viewDir = normalize2(viewPos);
        vec3 sunDir = normalize2(sunPosition);

        float viewDotSun = dot(viewDir, sunDir);

        float phase = pow2(0.5 + 0.5 * viewDotSun, 4.0);

        outputColor = mix2(outputColor, sunsetColor, phase * sunsetBlendFactor);
    }

    return outputColor;
}