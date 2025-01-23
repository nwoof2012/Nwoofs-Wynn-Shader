uniform float blindness;

mediump float minBlindnessDistance = 2.5;
mediump float maxBlindDistance = 5;

vec3 blindEffect(vec3 color) {
    if(blindness > 0f) {
        mediump float distanceFromCamera = distance(vec3(0), viewSpaceFragPosition);
        return mix2(color,vec3(0),clamp((distanceFromCamera - minBlindnessDistance)/(maxBlindDistance - minBlindnessDistance) * blindness,0,1));
    }
}