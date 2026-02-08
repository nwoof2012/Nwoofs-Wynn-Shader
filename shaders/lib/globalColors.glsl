/*<==========================================================>*/
/*|                                                          |*/
/*|                        [LIGHTING]                        |*/
/*|                                                          |*/
/*<==========================================================>*/

// Gamma (2.2 = SRGB)
#define GAMMA 2.2 // [1.0 1.2 1.4 1.6 1.8 2.0 2.2 2.4 2.6 2.8 3.0]

// Light Mode (0 = Classic, 1 = Fancy)
#define LIGHTING_MODE 1 // [0 1]

// Scene Aware Lighting
#define SCENE_AWARE_LIGHTING 2 // [0 2]

// Ambient Occlusion
#define AO

//<----------------------[Light Colors]---------------------->\\

// Day
vec3 lightDayColor = pow2(vec3(LIGHT_DAY_R, LIGHT_DAY_G, LIGHT_DAY_B), vec3(GAMMA));

// Sunset/Sunrise
vec3 lightSunsetColor = pow2(vec3(LIGHT_SUNSET_R, LIGHT_SUNSET_G, LIGHT_SUNSET_B), vec3(GAMMA));

// Night
vec3 lightNightColor = pow2(vec3(LIGHT_NIGHT_R, LIGHT_NIGHT_G, LIGHT_NIGHT_B), vec3(GAMMA));

// Ambient
vec3 ambientLightColor = pow2(vec3(AMBIENT_LIGHT_R, AMBIENT_LIGHT_G, AMBIENT_LIGHT_B), vec3(GAMMA));

// Silent Expanse
vec3 lightSEColor = pow2(vec3(LIGHT_SE_R, LIGHT_SE_G, LIGHT_SE_B), vec3(GAMMA));

//<------------------[Volumetric Lighting]------------------->\\

// Color
vec3 VLColor = pow2(vec3(VL_COLOR_R, VL_COLOR_G, VL_COLOR_B), vec3(GAMMA));

//<---------------------[Normal Lighting]------------------->\\

// Blocklight Color
vec3 blocklightColor = pow2(vec3(VL_COLOR_R, VL_COLOR_G, VL_COLOR_B), vec3(GAMMA));

/*<==========================================================>*/
/*|                                                          |*/
/*|                          [WORLD]                         |*/
/*|                                                          |*/
/*<==========================================================>*/

//<---------------------------[Fog]-------------------------->\\

// Fog Color (Day)
vec3 fogDayColor = pow2(vec3(FOG_DAY_R, FOG_DAY_G, FOG_DAY_B), vec3(GAMMA));

// Fog Color (Night)
vec3 fogNightColor = pow2(vec3(FOG_NIGHT_R, FOG_NIGHT_G, FOG_NIGHT_B), vec3(GAMMA));

// Fog Color (Sunset)
vec3 fogSunsetColor = pow2(vec3(FOG_SUNSET_R, FOG_SUNSET_G, FOG_SUNSET_B), vec3(GAMMA));

// Fog Color (Silent Expanse)
vec3 fogSEColor = pow2(vec3(FOG_SE_R, FOG_SE_G, FOG_SE_B), vec3(GAMMA));

// Fog Color (Day, Rain)
vec3 fogDayRainColor = pow2(vec3(FOG_DAY_RAIN_R, FOG_DAY_RAIN_G, FOG_DAY_RAIN_B), vec3(GAMMA));

// Fog Color (Night, Rain)
vec3 fogNightRainColor = pow2(vec3(FOG_NIGHT_RAIN_R, FOG_NIGHT_RAIN_G, FOG_NIGHT_RAIN_B), vec3(GAMMA));

// Fog Color (Sunset, Rain)
vec3 fogSunsetRainColor = pow2(vec3(FOG_SUNSET_RAIN_R, FOG_SUNSET_RAIN_G, FOG_SUNSET_RAIN_B), vec3(GAMMA));

// Fog Color (Cave)
vec3 fogCaveColor = pow2(vec3(FOG_CAVE_R, FOG_CAVE_G, FOG_CAVE_B), vec3(GAMMA));

/*<==========================================================>*/
/*|                                                          |*/
/*|                           [SKY]                          |*/
/*|                                                          |*/
/*<==========================================================>*/

//<--------------------------[Clouds]------------------------>\\

// Cloud Ambience
vec3 cloudAmbience = pow2(vec3(SKY_DAY_A_R, SKY_DAY_A_G, SKY_DAY_A_B), vec3(GAMMA));

//<--------------------------[Skybox]------------------------>\\

// Day Horizon (Normal)
vec3 skyDayA = pow2(vec3(SKY_DAY_A_R, SKY_DAY_A_G, SKY_DAY_A_B), vec3(GAMMA));

// Day Atmosphere (Normal)
vec3 skyDayB = pow2(vec3(SKY_DAY_B_R, SKY_DAY_B_G, SKY_DAY_B_B), vec3(GAMMA));


// Day Horizon (Normal, Rain)
vec3 skyDayRainA = pow2(vec3(SKY_DAY_RAIN_A_R, SKY_DAY_RAIN_A_G, SKY_DAY_RAIN_A_B), vec3(GAMMA));

// Day Atmosphere (Normal, Rain)
vec3 skyDayRainB = pow2(vec3(SKY_DAY_RAIN_B_R, SKY_DAY_RAIN_B_G, SKY_DAY_RAIN_B_B), vec3(GAMMA));


// Night Horizon (Normal)
vec3 skyNightA = pow2(vec3(SKY_NIGHT_A_R, SKY_NIGHT_A_G, SKY_NIGHT_A_B), vec3(GAMMA));

// Night Atmosphere (Normal)
vec3 skyNightB = pow2(vec3(SKY_NIGHT_B_R, SKY_NIGHT_B_G, SKY_NIGHT_B_B), vec3(GAMMA));


// Sunset/Sunrise Horizon (Normal)
vec3 skySunsetA = pow2(vec3(SKY_SUNSET_A_R, SKY_SUNSET_A_G, SKY_SUNSET_A_B), vec3(GAMMA));

// Sunset/Sunrise Atmosphere (Normal)
vec3 skySunsetB = pow2(vec3(SKY_SUNSET_B_R, SKY_SUNSET_B_G, SKY_SUNSET_B_B), vec3(GAMMA));


// Day Horizon (Silent Expanse)
vec3 skySEDayA = pow2(vec3(SKY_SE_DAY_A_R, SKY_SE_DAY_A_G, SKY_SE_DAY_A_B), vec3(GAMMA));

// Day Atmosphere (Silent Expanse)
vec3 skySEDayB = pow2(vec3(SKY_SE_DAY_B_R, SKY_SE_DAY_B_G, SKY_SE_DAY_B_B), vec3(GAMMA));


// Night Horizon (Silent Expanse)
vec3 skySENightA = pow2(vec3(SKY_SE_NIGHT_A_R, SKY_SE_NIGHT_A_G, SKY_SE_NIGHT_A_B), vec3(GAMMA));

// Night Atmosphere (Silent Expanse)
vec3 skySENightB = pow2(vec3(SKY_SE_NIGHT_B_R, SKY_SE_NIGHT_B_G, SKY_SE_NIGHT_B_B), vec3(GAMMA));

// Sunset/Sunrise Atmosphere (Silent Expanse)

vec3 skySESunsetB = pow2(vec3(SKY_SE_SUNSET_B_R, SKY_SE_SUNSET_B_G, SKY_SE_SUNSET_B_B), vec3(GAMMA));

/*<==========================================================>*/
/*|                                                          |*/
/*|                          [DEBUG]                         |*/
/*|                                                          |*/
/*<==========================================================>*/