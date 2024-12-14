uniform float blindness;

float minBlindnessDistance = 2.5;
float maxBlindDistance = 5;

vec3 blindEffect(vec3 color) {
    if(blindness > 0f) {
        float distanceFromCamera = distance(vec3(0), viewSpaceFragPosition);
        return mix2(color,vec3(0),clamp((distanceFromCamera - minBlindnessDistance)/(maxBlindDistance - minBlindnessDistance) * blindness,0,1));
    }
}