#include "/lib/miplevel.glsl"

const float normalThreshold = 0.05;
const float normalClamp = 0.2;
const float packSizeGN = 128.0;

float getHeightFromAlbedo(vec2 uv, sampler2D tex) {
    vec3 texSample = texture2D(tex, uv).rgb;
    return dot(texSample,texSample);
}

vec4 normalFromDepth(vec2 uv, sampler2D tex, vec2 resolution, float scale) {
    vec2 stepSize = 0.1/resolution;

    float height = getHeightFromAlbedo(uv, tex);

    vec2 dxy = height - vec2(getHeightFromAlbedo(uv + vec2(stepSize.x, 0.0),tex),getHeightFromAlbedo(uv + vec2(0.0, stepSize.y),tex));

    return vec4(normalize2(vec3(dxy * scale / stepSize, 1.0)),height);
}

float GetDif(float lOriginalAlbedo, vec2 offsetCoord, sampler2D tex) {
    #ifndef GBUFFERS_WATER
        float lNearbyAlbedo = length(texture2D(tex, offsetCoord).rgb);
    #else
        vec4 textureSample = texture2D(tex, offsetCoord);
        float lNearbyAlbedo = length(textureSample.rgb * textureSample.a * 1.5);
    #endif

    #ifdef GBUFFERS_ENTITIES
        lOriginalAlbedo = abs(lOriginalAlbedo - 1.0);
        lNearbyAlbedo = abs(lNearbyAlbedo - 1.0);
    #endif

    float dif = lOriginalAlbedo - lNearbyAlbedo;

    #ifdef GBUFFERS_ENTITIES
        dif = -dif;
    #endif

    #ifndef GBUFFERS_WATER
        if (dif > 0.0) dif = max(dif - normalThreshold, 0.0);
        else           dif = min(dif + normalThreshold, 0.0);
    #endif

    return clamp(dif, -normalClamp, normalClamp);
}

void GenerateNormals(inout vec3 normal, vec3 color, sampler2D tex, mat3 tbnMatrix) {

    vec2 midCoordPos2 = TexCoords - absMidCoordPos;
    float lOriginalAlbedo = length(color.rgb);

    float normalMult = max(0.0, 1.0 - mipDelta);

    vec2 offsetR = 16.0 / atlasSizeM;

    vec2 midCoord = TexCoords - midCoordPos;
    vec2 maxOffsetCoord = midCoord + absMidCoordPos;
    vec2 minOffsetCoord = midCoord + absMidCoordPos;
    if(normalMult > 0.0) {
        vec3 normalMap = vec3(0.0, 0.0, 1.0);

        vec2 offsetCoord = TexCoords + vec2(0.0, offsetR.y);
        if(offsetCoord.y < maxOffsetCoord.y) {
            normalMap.y += GetDif(lOriginalAlbedo, offsetCoord, tex);
        }
        offsetCoord = TexCoords + vec2(offsetR.x, 0.0);
        if(offsetCoord.x < maxOffsetCoord.x) {
            normalMap.x += GetDif(lOriginalAlbedo, offsetCoord, tex);
        }
        offsetCoord = TexCoords + vec2(0.0, -offsetR.y);
        if(offsetCoord.y > minOffsetCoord.y) {
            normalMap.y += GetDif(lOriginalAlbedo, offsetCoord, tex);
        }
        offsetCoord = TexCoords + vec2(-offsetR.x, 0.0);
        if(offsetCoord.x > minOffsetCoord.x) {
            normalMap.x += GetDif(lOriginalAlbedo, offsetCoord, tex);
        }

        normalMap.xy *= normalMult;
        normalMap.xy = clamp(normalMap.xy, vec2(-1.0),vec2(1.0));

        if(normalMap.xy != vec2(0.0)) {
            normal = clamp(normalize(normalMap * tbnMatrix),vec3(-1.0),vec3(1.0));
        }
    }
}