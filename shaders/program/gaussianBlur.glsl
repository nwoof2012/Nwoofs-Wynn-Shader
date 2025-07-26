vec4 gaussianBlur(sampler2D tex, vec2 pos, float radius, vec2 res) {
    mediump float x, y, rr=radius*radius, d, w, w0;
    w0 = 0.3780/pow2(radius,1.975);
    vec2 p = 0.5*(vec2(1.0)+pos);
    vec4 color = vec4(0.0);
    for(d = 1.0/res.x,x=-radius,p,x+=x*d; x <=radius; x++, p.x+=d) {
        w = w0*exp((-x*x)/(2.0*rr));
        color += texture2D(tex,p) * w;
    }
    for(d = 1.0/res.y,y=-radius,p,y+=y*d; x <=radius; y++, p.y+=d) {
        w = w0*exp((-y*y)/(2.0*rr));
        color += texture2D(tex,p) * w;
    }
    return color;
}

#if CLOUD_STYLE == 1
    vec4 imageBilinear(vec2 uv, ivec2 res) {
        vec2 texCoord = uv * vec2(res);         // texel-space
        ivec2 i0 = ivec2(floor(texCoord));      // bottom-left texel
        vec2 f = fract(texCoord);               // interpolation weights

        // Neighbors
        ivec2 i1 = i0 + ivec2(1, 1);
        ivec2 i10 = i0 + ivec2(1, 0);
        ivec2 i01 = i0 + ivec2(0, 1);

        // Clamp to avoid going out of bounds
        ivec2 maxCoord = res - 1;
        vec4 c00 = texture2D(cSampler9, vec2(clamp(i0, ivec2(0), maxCoord))/vec2(res));
        vec4 c10 = texture2D(cSampler9, vec2(clamp(i10, ivec2(0), maxCoord))/vec2(res));
        vec4 c01 = texture2D(cSampler9, vec2(clamp(i01, ivec2(0), maxCoord))/vec2(res));
        vec4 c11 = texture2D(cSampler9, vec2(clamp(i1, ivec2(0), maxCoord))/vec2(res));

        // Interpolate
        vec4 cx0 = mix2(c00, c10, f.x);
        vec4 cx1 = mix2(c01, c11, f.x);
        return mix2(cx0, cx1, f.y);
    }

    vec4 gaussianBlur(vec2 uv, float radius) {
        ivec2 imageRes = imageSize(cimage9); // Actual image resolution
        vec2 texelSize = 1.0 / vec2(imageRes);

        float rr = radius * radius;
        float w0 = 0.3780 / pow(radius, 1.975);

        vec4 color = vec4(0.0);
        float totalWeight = 0.0;

        // Snap UV to texel center to avoid rounding artifacts
        vec2 centerUV = (floor(uv * vec2(imageRes)) + 0.5) * texelSize;

        for (int y = int(-radius); y <= 0; y++) {
            for (int x = int(-radius); x <= int(radius); x++) {
                float dist2 = float(x * x + y * y);
                float w = w0 * exp(-dist2 / (2.0 * rr));

                vec2 offsetUV = centerUV + vec2(x, y) * texelSize;
                ivec2 coord = ivec2(offsetUV * vec2(imageRes));
                coord = clamp(coord, ivec2(0), imageRes - 1);

                color += imageLoad(cimage9, coord) * w;
                totalWeight += w;
            }
        }

        return color / totalWeight;
    }
#endif