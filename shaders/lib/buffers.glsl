//SE Transition
struct transition_data {
    float transitionStartTime;
    float transitionTimer;
    float transitionAmount;
    bool transitionInit;
    bool transitionActive;
    bool prevIsBiomeEnd;
    bool entering;
    bool transitionCompleted;
    vec3 prevDiffuse;
    bool prevDiffuseInit;
};

layout(std430, binding = 0) buffer seTransition {
    transition_data data;
} transitionSE;

//Rain Transition
layout(std430, binding = 1) buffer rainTransition {
    bool firstInit;
    float previousRainStrength;
    float startTime;
    float timer;
    float amount;
    bool init;
    bool activeState;
    bool startState;
    vec4 startColor;
    vec4 endColor;
} transitionRain;