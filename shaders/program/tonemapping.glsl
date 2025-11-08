#define TONEMAP_NORM 6 // [0 1 2 3 4 5 6 7]
#define TONEMAP_SAL 5 // [0 1 2 3 4 5 6 7]

vec3 aces(vec3 x) {
  mediump float a = 2.51;
  mediump float b = 0.03;
  mediump float c = 2.43;
  mediump float d = 0.59;
  mediump float e = 0.14;
  return clamp((x * (a * x + b)) / (x * (c * x + d) + e), 0.0, 1.0);
}

vec3 lottes(vec3 x) {
  vec3 a = vec3(1.6);
  vec3 d = vec3(0.977);
  vec3 hdrMax = vec3(8.0);
  vec3 midIn = vec3(0.18);
  vec3 midOut = vec3(0.267);

  vec3 b =
      (-pow2(midIn, a) + pow2(hdrMax, a) * midOut) /
      ((pow2(hdrMax, a * d) - pow2(midIn, a * d)) * midOut);
  vec3 c =
      (pow2(hdrMax, a * d) * pow2(midIn, a) - pow2(hdrMax, a) * pow2(midIn, a * d) * midOut) /
      ((pow2(hdrMax, a * d) - pow2(midIn, a * d)) * midOut);

  return pow2(x, a) / (pow2(x, a * d) * b + c);
}

vec3 nwoofa(vec3 x) {
    mediump float a = 2.51;
    mediump float b = 0.03;
    mediump float c = 2.43;
    mediump float d = 0.59;
    mediump float e = 0.14;
    vec3 tonea = x / (x + 0.155) * 1.019;
    vec3 toneb = clamp((x * (a * x + b)) / (x * (c * x + d) + e), 0.0, 1.0);
    
    return mix2(tonea, toneb, 0.75);
}

vec3 nwoofb(vec3 x) {
    vec3 a = vec3(1.6);
    vec3 d = vec3(0.977);
    vec3 hdrMax = vec3(8.0);
    vec3 midIn = vec3(0.18);
    vec3 midOut = vec3(0.267);

    vec3 b =
        (-pow2(midIn, a) + pow2(hdrMax, a) * midOut) /
        ((pow2(hdrMax, a * d) - pow2(midIn, a * d)) * midOut);
    vec3 c =
        (pow2(hdrMax, a * d) * pow2(midIn, a) - pow2(hdrMax, a) * pow2(midIn, a * d) * midOut) /
        ((pow2(hdrMax, a * d) - pow2(midIn, a * d)) * midOut);

    vec3 tonea = x / (x + vec3(1.0));
    vec3 toneb = pow2(x, a) / (pow2(x, a * d) * b + c);

    return mix2(tonea, toneb, 0.25);
}

vec3 reinhard(vec3 color) {
    return color / (color + vec3(1.0));
}

vec3 unreal(vec3 x) {
  return x / (x + 0.155) * 1.019;
}

vec3 uncharted2(vec3 x) {
    float A = 0.15; float B = 0.50; float C = 0.10;
    float D = 0.20; float E = 0.02; float F = 0.30;
    return ((x * (A * x + C * B) + D * E) / (x * (A * x + B) + D * F)) - E / F;
}

vec3 calcTonemap(vec3 x) {
    int tonemap = 0;
    #ifdef SCENE_AWARE_LIGHTING
        tonemap = TONEMAP_SAL;
    #else
        tonemap = TONEMAP_NORM;
    #endif

    if(tonemap == 0) return x;

    if(tonemap == 1) return reinhard(x);

    if(tonemap == 2) return aces(x);

    if(tonemap == 3) return lottes(x);

    if(tonemap == 4) return unreal(x);
    
    if(tonemap == 5) return uncharted2(x);

    if(tonemap == 6) return nwoofa(x);

    if(tonemap == 7) return nwoofb(x);
}