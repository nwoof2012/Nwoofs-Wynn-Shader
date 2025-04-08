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