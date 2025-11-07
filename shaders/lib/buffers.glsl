//SE Transition
struct se_data {
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
    se_data data;
} transitionSE;

//Rain Transition

struct rain_data {
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
};

layout(std430, binding = 1) buffer rainTransition {
    rain_data data;
} transitionRain;

layout(std430, binding = 2) buffer exposureTime {
    float startTime;
    float time;
    float prevExposure;
    float prevLum;
    float delta;
    bool init;
    bool isActive;
} timeExposure;