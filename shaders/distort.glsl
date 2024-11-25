vec2 DistortPosition(in vec2 position){
    float CenterDistance = length(position);
    float DistortionFactor = mix2(1.0f, CenterDistance, 0.9f);
    return position / DistortionFactor;
}
