#include "/lib/miplevel.glsl"

const mediump float normalThreshold = 0.05;
const mediump float normalClamp = 0.2;
const mediump float packSizeGN = 128.0;

mediump float getHeightFromAlbedo(vec2 uv, sampler2D tex) {
    vec3 texSample = texture2D(tex, uv).rgb;
    return dot(texSample,texSample);
}

vec4 normalFromDepth(vec2 uv, sampler2D tex, vec2 resolution, float scale) {
    vec2 stepSize = 0.1/resolution;

    mediump float height = getHeightFromAlbedo(uv, tex);

    vec2 dxy = height - vec2(getHeightFromAlbedo(uv + vec2(stepSize.x, 0.0),tex),getHeightFromAlbedo(uv + vec2(0.0, stepSize.y),tex));

    return vec4(normalize2(vec3(dxy * scale / stepSize, 1.0)),height);
}

float getCloudShadow(vec3 worldPos, vec3 sunDir) {
    vec3 lightDir = normalize(-sunDir);

    if (abs(lightDir.y) < 0.01) return 1.0;

    float t = (CLOUD_BASE - worldPos.y) / lightDir.y;
    if (t < 0.0) return 1.0;

    vec3 pos = worldPos + lightDir * t;

    float shadow = 1.0;

    float stepSize = (CLOUD_TOP - CLOUD_BASE) / float(SHADOW_STEPS);

    for (int i = 0; i < SHADOW_STEPS; i++) {
        if (pos.y < CLOUD_BASE || pos.y > CLOUD_TOP)
            break;

        vec3 movePos = pos * 0.075 + vec3(frameTimeCounter, 0.0, frameTimeCounter);

        float density = cloudBilinear(movePos, vec3(STEP_SIZE));

        shadow *= exp(-density * 0.5);

        pos += lightDir * stepSize;
    }

    return clamp(shadow, 0.0, 1.0);
}

void GenerateNormals(inout vec3 normal, vec3 color, sampler2D tex, mat3 tbnMatrix) {
    vec2 midCoordPos2 = TexCoords - absMidCoordPos;
    mediump float lOriginalAlbedo = length(color.rgb);

    mediump float normalMult = max(0.0, 1.0 - mipDelta);

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