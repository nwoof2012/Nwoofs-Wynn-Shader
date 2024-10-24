#ifdef VERTEX_SHADER
    flat out int timePhase;
    out float quadTime;
    out float timeOfDay;
    uniform int worldTime;
    in int frameCounter;
    in float frameTime;
    
    void timeFunctionVert() {
        timeOfDay = mod(worldTime,24000);
        quadTime = timeOfDay;
        if(timeOfDay < 250) {
            timePhase = 3;
            quadTime += 250;
        } else if(timeOfDay < 11750) {
            timePhase = 0;
            quadTime -= 250;
        } else if(timeOfDay < 12250) {
            timePhase = 1;
            quadTime -= 11750;
        } else if(timeOfDay < 23750) {
            timePhase = 2;
            quadTime -= 12250;
        } else if(timeOfDay < 24000) {
            timePhase = 3;
            quadTime -= 23750;
        }
    }
#endif
#ifdef FRAGMENT_SHADER
    flat in int timePhase;
    in float quadTime;
    in float timeOfDay;
    void timeFunctionFrag() {
        if(timePhase == 0) {
            noonFunc(quadTime, 500);
        } else if(timePhase == 1) {
            sunsetFunc(quadTime, 500);
        } else if(timePhase == 2) {
            nightFunc(quadTime, 500);
        } else if(timePhase == 3) {
            dawnFunc(quadTime, 500);
        }
    }
#endif