#define TONEMAP_NORM 8 // [0 1 2 3 4 5 6 7 8 9 10]
#define TONEMAP_SAL 8 // [0 1 2 3 4 5 6 7 8 9 10]

const mat3 LINEAR_REC2020_TO_LINEAR_SRGB = mat3(
  1.6605, -0.1246, -0.0182,
  -0.5876, 1.1329, -0.1006,
  -0.0728, -0.0083, 1.1187
);

const mat3 LINEAR_SRGB_TO_LINEAR_REC2020 = mat3(
  0.6274, 0.0691, 0.0164,
  0.3293, 0.9195, 0.0880,
  0.0433, 0.0113, 0.8956
);

const mat3 AgXInsetMatrix = mat3(
  0.856627153315983, 0.137318972929847, 0.11189821299995,
  0.0951212405381588, 0.761241990602591, 0.0767994186031903,
  0.0482516061458583, 0.101439036467562, 0.811302368396859
);

const mat3 AgXOutsetMatrix = mat3(
  1.1271005818144368, -0.1413297634984383, -0.14132976349843826,
  -0.11060664309660323, 1.157823702216272, -0.11060664309660294,
  -0.016493938717834573, -0.016493938717834257, 1.2519364065950405
);

const float AgxMinEv = -12.47393;
const float AgxMaxEv = 4.026069;

vec3 agxCdl(vec3 color, vec3 slope, vec3 offset, vec3 power, float saturation) {
  color = LINEAR_SRGB_TO_LINEAR_REC2020 * color;

  color = AgXInsetMatrix * color;

  color = max(color, 1e-10);

  color = clamp(log2(color), AgxMinEv, AgxMaxEv);
  color = (color - AgxMinEv) / (AgxMaxEv - AgxMinEv);

  color = clamp(color, 0.0, 1.0);

  vec3 x2 = color * color;
  vec3 x4 = x2 * x2;
  color = + 15.5     * x4 * x2
          - 40.14    * x4 * color
          + 31.96    * x4
          - 6.868    * x2 * color
          + 0.4298   * x2
          + 0.1191   * color
          - 0.00232;

  color = pow(color * slope + offset, power);
  const vec3 lw = vec3(0.2126, 0.7152, 0.0722);
  float luma = dot(color, lw);
  color = luma + saturation * (color - luma);

  color = AgXOutsetMatrix * color;

  color = pow(max(vec3(0.0), color), vec3(2.2));

  color = LINEAR_REC2020_TO_LINEAR_SRGB * color;
	color = clamp(color, 0.0, 1.0);

  return color;
}

vec3 agx(vec3 color) {
  return agxCdl(color, vec3(1.0), vec3(0.0), vec3(1.0), 1.0);
}

vec3 agxGolden(vec3 color) {
  return agxCdl(color, vec3(1.0, 0.9, 0.5), vec3(0.0), vec3(0.8), 1.3);
}

vec3 agxPunchy(vec3 color) {
  return agxCdl(color, vec3(1.0), vec3(0.0), vec3(1.35), 1.4);
}

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

vec3 Uncharted2TonemapSoft(vec3 x)
{
    float A = 0.18;
    float B = 0.09;
    float C = 0.10;
    float D = 0.20;
    float E = 0.02;
    float F = 0.30;
    return ((x*(A*x + C*B) + D*E) / (x*(A*x + B) + D*F)) - E/F;
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

    if(tonemap == 6) return agx(x);

    if(tonemap == 7) return agxGolden(x);

    if(tonemap == 8) return agxPunchy(x);

    if(tonemap == 9) return nwoofa(x);

    if(tonemap == 10) return nwoofb(x);
}