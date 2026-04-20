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
        if(timeOfDay < 500) {
            timePhase = 3;
            quadTime += 500;
        } else if(timeOfDay < 11500) {
            timePhase = 0;
            quadTime -= 500;
        } else if(timeOfDay < 12500) {
            timePhase = 1;
            quadTime -= 11500;
        } else if(timeOfDay < 23500) {
            timePhase = 2;
            quadTime -= 12500;
        } else if(timeOfDay < 24000) {
            timePhase = 3;
            quadTime -= 23500;
        }
    }
#endif
#ifdef FRAGMENT_SHADER
    flat in int timePhase;
    in float quadTime;
    in float timeOfDay;
    void timeFunctionFrag() {
        if(timePhase == 0) {
            noonFunc(quadTime, smoothstep(500, 11500, timeOfDay));
        } else if(timePhase == 1) {
            sunsetFunc(quadTime, smoothstep(11500, 12500, timeOfDay));
        } else if(timePhase == 2) {
            nightFunc(quadTime, smoothstep(12500, 23500, timeOfDay));
        } else if(timePhase == 3) {
            dawnFunc(quadTime, smoothstep(23500, 24500, timeOfDay));
        }
    }
#endif