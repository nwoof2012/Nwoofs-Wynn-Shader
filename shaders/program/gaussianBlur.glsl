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