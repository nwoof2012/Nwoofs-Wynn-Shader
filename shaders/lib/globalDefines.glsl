/*<==========================================================>*/
/*|                                                          |*/
/*|                        [LIGHTING]                        |*/
/*|                                                          |*/
/*<==========================================================>*/

// Light Mode (0 = Classic, 1 = Fancy)
#define LIGHTING_MODE 1 // [0 1]

// Scene Aware Lighting
#define SCENE_AWARE_LIGHTING 2 // [0 2]

// Ambient Occlusion
#define AO

//<----------------------[Light Colors]---------------------->\\

// Day
#define LIGHT_DAY_R 1.0
#define LIGHT_DAY_G 0.93
#define LIGHT_DAY_B 0.88
#define LIGHT_DAY_I 1.0

// Sunset/Sunrise
#define LIGHT_SUNSET_R 1.0
#define LIGHT_SUNSET_G 0.78
#define LIGHT_SUNSET_B 0.55

// Night
#define LIGHT_NIGHT_R 0.55
#define LIGHT_NIGHT_G 0.6
#define LIGHT_NIGHT_B 0.95
#define LIGHT_NIGHT_I 0.5

// Ambient
#define AMBIENT_LIGHT_R 0.8 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define AMBIENT_LIGHT_G 0.9 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define AMBIENT_LIGHT_B 1.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

// Silent Expanse
#define LIGHT_SE_R 0.55
#define LIGHT_SE_G 0.50
#define LIGHT_SE_B 0.85

//<----------------------[Light Levels]---------------------->\\

// Minimum Light
#define MIN_LIGHT 0.1f // [0.0f 0.05f 0.1f 0.15f 0.2f 0.25f 0.3f 0.35f 0.4f 0.45f 0.5f]

// Maximum Light
#define MAX_LIGHT 1.5f // [1.0f 1.1f 1.2f 1.3f 1.4f 1.5f 1.6f 1.7f 1.8f 1.9f 2.0f 2.1f 2.2f 2.3f 2.4f 2.5f 2.6f 2.7f 2.8f 2.9f 3.0f 3.1f 3.2f 3.3f 3.4f 3.5f 3.6f 3.7f 3.8f 3.9f 4.0f 4.1f]

// Minimum Foliage Light
#define MIN_FOLIAGE_LIGHT 0.45f // [0.0f 0.05f 0.1f 0.15f 0.2f 0.25f 0.3f 0.35f 0.4f 0.45f 0.5f]

// Shadow Brightness

#define SHADOW_BRIGHTNESS 0.35f // [0.0f 0.05f 0.1f 0.15f 0.2f 0.25f 0.3f 0.35f 0.4f 0.45f 0.5f]

//<-------------[Light Levels (Silent Expanse)]-------------->\\

// Minimum Light
#define SE_MIN_LIGHT 0.5f // [0.0f 0.05f 0.1f 0.15f 0.2f 0.25f 0.3f 0.35f 0.4f 0.45f 0.5f]

// Maximum Light
#define SE_MAX_LIGHT 2.0f // [1.0f 1.1f 1.2f 1.3f 1.4f 1.5f 1.6f 1.7f 1.8f 1.9f 2.0f 2.1f 2.2f 2.3f 2.4f 2.5f 2.6f 2.7f 2.8f 2.9f 3.0f 3.1f 3.2f 3.3f 3.4f 3.5f 3.6f 3.7f 3.8f 3.9f 4.0f 4.1f]

//<------------------[Volumetric Lighting]------------------->\\

// Toggle
#define VOLUMETRIC_LIGHTING

// Volumetric Lighting Samples
#define VL_SAMPLES 32 // [16 32 48 64 80 96 112 128]

// Parameters
#define VL_DECAY 0.95 // [0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]
#define VL_EXPOSURE 0.3 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define VL_WEIGHT 0.15 // [0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5]
#define VL_DENSITY 0.8 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

// Color
#define VL_COLOR_R 1.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define VL_COLOR_G 0.9 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define VL_COLOR_B 0.8 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

//<-------------------------[Voxels]------------------------>\\

// Light Sampling
#define LIGHT_RADIUS 2
#define LIGHT_SAMPLE_COUNT 64

// Texture Parameters
#define VOXEL_AREA 128 //[32 64 128]
#define VOXEL_RADIUS (VOXEL_AREA/2)

//<---------------------[Normal Lighting]------------------->\\

// Blocklight Color
#define LIGHT_COLOR_R 1.0 // [0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]
#define LIGHT_COLOR_G 0.9 // [0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]
#define LIGHT_COLOR_B 0.8 // [0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]

//<---------------------------[Misc]------------------------>\\

#define LIGHT_UPSAMPLE_FACTOR 0.25

#define LIGHT_RESOLUTION 270

/*<==========================================================>*/
/*|                                                          |*/
/*|                         [CAMERA]                         |*/
/*|                                                          |*/
/*<==========================================================>*/

//<------------------------[Exposure]----------------------->\\

// Toggle Exposure
#define AUTO_EXPOSURE

// Exposure (Normal)
#define NORM_EXP 7.0 // [0.5 1.0 1.5 2.0 2.5 3.0 3.5 4.0 4.5 5.0 5.5 6.0 6.5 7.0 7.5 8.0 8.5 9.0 9.5 10.0 10.5 11.0 11.5 12.0 12.5 13.0 13.5 14.0 14.5 15.0 15.5 16.0 16.5 17.0 17.5 18.0 18.5 19.0 19.5 20.0]

// Exposure (Silent Expanse)
#define SE_EXP 14.0 // [0.5 1.0 1.5 2.0 2.5 3.0 3.5 4.0 4.5 5.0 5.5 6.0 6.5 7.0 7.5 8.0 8.5 9.0 9.5 10.0 10.5 11.0 11.5 12.0 12.5 13.0 13.5 14.0 14.5 15.0 15.5 16.0 16.5 17.0 17.5 18.0 18.5 19.0 19.5 20.0]

// Rendering
#define VIGNETTE

//<----------------------[Antialiasing]---------------------->\\

// AA Mode (0 = Off, 1 = Basic AA, 2 = SMAA, 3 = TAA)
#define AA 3 // [0 1 2 3]

// Basic AA
#define BAA_SHARPEN_AMOUNT 0.75 // [0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]
#define BAA_SHARPEN_BLEND 0.45 // [0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]

// SMAA
#define SMAA_EDGE_FACTOR 0.1 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define SMAA_NEAR_THRESHOLD 0.3 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define SMAA_FAR_THRESHOLD 1.0 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

// TAA
#define TAA_BLEND 0.1 // [0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5]

#define BRIGHTNESS 1.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]

/*<==========================================================>*/
/*|                                                          |*/
/*|                          [WATER]                         |*/
/*|                                                          |*/
/*<==========================================================>*/

// Rendering
#define WATER_REFRACTION
#define WATER_FOAM

/*<==========================================================>*/
/*|                                                          |*/
/*|                          [WORLD]                         |*/
/*|                                                          |*/
/*<==========================================================>*/

//<------------------------[Rendering]----------------------->\\

// Screen Space Reflections (0 = Off, 1 = On, 2 = Water Only, 3 = Metal Only)
#define SSR 1 // [0 1 2 3]

// World Curvature
#define WORLD_CURVATURE

//<---------------------------[Fog]-------------------------->\\

// Fog Style
#define FOG_STYLE 1 // [0 1]

// Fog Precision
#define FOG_PRECISION 64 // [4 8 16 32 64 128]

// Fog Color (Day)
#define FOG_DAY_R 0.8 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define FOG_DAY_G 0.9 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define FOG_DAY_B 1.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

// Fog Curve (Day)
#define FOG_DAY_DIST_MIN 0.0 // [0.0 64.0 128.0 192.0 256.0 512.0 768.0 1024.0 2048.0 3072.0 4096.0 5120.0 6144.0 7168.0 8192.0]
#define FOG_DAY_DIST_MAX 4096.0 // [64.0 128.0 192.0 256.0 512.0 768.0 1024.0 2048.0 3072.0 4096.0 5120.0 6144.0 7168.0 8192.0]
#define DH_FOG_DAY_DIST_MAX 4096.0 // [512.0 768.0 1024.0 2048.0 3072.0 4096.0 5120.0 6144.0 7168.0 8192.0]
#define FOG_DAY_INTENSITY 0.1 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5]
#define FOG_DAY_CURVE 2.0 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]

// Fog Color (Night)
#define FOG_NIGHT_R 0.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define FOG_NIGHT_G 0.1 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define FOG_NIGHT_B 0.2 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

// Fog Curve (Night)
#define FOG_NIGHT_DIST_MIN 0.0 // [0.0 64.0 128.0 192.0 256.0 512.0 768.0 1024.0 2048.0 3072.0 4096.0 5120.0 6144.0 7168.0 8192.0]
#define FOG_NIGHT_DIST_MAX 4096.0 // [64.0 128.0 192.0 256.0 512.0 768.0 1024.0 2048.0 3072.0 4096.0 5120.0 6144.0 7168.0 8192.0]
#define DH_FOG_NIGHT_DIST_MAX 4096.0 // [512.0 768.0 1024.0 2048.0 3072.0 4096.0 5120.0 6144.0 7168.0 8192.0]
#define FOG_NIGHT_INTENSITY 0.1 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5]
#define FOG_NIGHT_CURVE 1.3 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]

// Fog Color (Sunset)
#define FOG_SUNSET_R 1.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define FOG_SUNSET_G 0.5 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define FOG_SUNSET_B 0.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

// Fog Curve (Sunset)
#define FOG_SUNSET_DIST_MIN 0.0 // [0.0 64.0 128.0 192.0 256.0 512.0 768.0 1024.0 2048.0 3072.0 4096.0 5120.0 6144.0 7168.0 8192.0]
#define FOG_SUNSET_DIST_MAX 2048.0 // [64.0 128.0 192.0 256.0 512.0 768.0 1024.0 2048.0 3072.0 4096.0 5120.0 6144.0 7168.0 8192.0]
#define DH_FOG_SUNSET_DIST_MAX 4096.0 // [512.0 768.0 1024.0 2048.0 3072.0 4096.0 5120.0 6144.0 7168.0 8192.0]
#define FOG_SUNSET_INTENSITY 0.1 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5]
#define FOG_SUNSET_CURVE 2.0 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]

// Fog Color (Silent Expanse)
#define FOG_SE_R 0.2 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define FOG_SE_G 0.1 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define FOG_SE_B 0.3 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

// Fog Curve (Silent Expanse)
#define FOG_SE_DIST_MIN 0.0 // [0.0 64.0 128.0 192.0 256.0 512.0 768.0 1024.0 2048.0 3072.0 4096.0 5120.0 6144.0 7168.0 8192.0]
#define FOG_SE_DIST_MAX 8192.0 // [64.0 128.0 192.0 256.0 512.0 768.0 1024.0 2048.0 3072.0 4096.0 5120.0 6144.0 7168.0 8192.0]
#define DH_FOG_SE_DIST_MAX 4096.0 // [512.0 768.0 1024.0 2048.0 3072.0 4096.0 5120.0 6144.0 7168.0 8192.0]
#define FOG_SE_INTENSITY 0.1 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5]
#define FOG_SE_CURVE 0.7 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]

// Fog Color (Day, Rain)
#define FOG_DAY_RAIN_R 0.3 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define FOG_DAY_RAIN_G 0.4 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define FOG_DAY_RAIN_B 0.5 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

// Fog Curve (Day, Rain)
#define FOG_DAY_RAIN_DIST_MIN 0.0 // [0.0 64.0 128.0 192.0 256.0 512.0 768.0 1024.0 2048.0 3072.0 4096.0 5120.0 6144.0 7168.0 8192.0]
#define FOG_DAY_RAIN_DIST_MAX 512.0 // [64.0 128.0 192.0 256.0 512.0 768.0 1024.0 2048.0 3072.0 4096.0 5120.0 6144.0 7168.0 8192.0]
#define DH_FOG_DAY_RAIN_DIST_MAX 4096.0 // [512.0 768.0 1024.0 2048.0 3072.0 4096.0 5120.0 6144.0 7168.0 8192.0]
#define FOG_DAY_RAIN_INTENSITY 0.8 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5]
#define FOG_DAY_RAIN_CURVE 1.0 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]

// Fog Color (Night, Rain)
#define FOG_NIGHT_RAIN_R 0.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define FOG_NIGHT_RAIN_G 0.1 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define FOG_NIGHT_RAIN_B 0.2 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

// Fog Curve (Night, Rain)
#define FOG_NIGHT_RAIN_DIST_MIN 0.0 // [0.0 64.0 128.0 192.0 256.0 512.0 768.0 1024.0 2048.0 3072.0 4096.0 5120.0 6144.0 7168.0 8192.0]
#define FOG_NIGHT_RAIN_DIST_MAX 512.0 // [64.0 128.0 192.0 256.0 512.0 768.0 1024.0 2048.0 3072.0 4096.0 5120.0 6144.0 7168.0 8192.0]
#define DH_FOG_NIGHT_RAIN_DIST_MAX 4096.0 // [512.0 768.0 1024.0 2048.0 3072.0 4096.0 5120.0 6144.0 7168.0 8192.0]
#define FOG_NIGHT_RAIN_INTENSITY 0.8 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5]
#define FOG_NIGHT_RAIN_CURVE 1.0 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]

// Fog Color (Sunset, Rain)
#define FOG_SUNSET_RAIN_R 0.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define FOG_SUNSET_RAIN_G 0.1 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define FOG_SUNSET_RAIN_B 0.2 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

// Fog Curve (Sunset, Rain)
#define FOG_SUNSET_RAIN_DIST_MIN 0.0 // [0.0 64.0 128.0 192.0 256.0 512.0 768.0 1024.0 2048.0 3072.0 4096.0 5120.0 6144.0 7168.0 8192.0]
#define FOG_SUNSET_RAIN_DIST_MAX 512.0 // [64.0 128.0 192.0 256.0 512.0 768.0 1024.0 2048.0 3072.0 4096.0 5120.0 6144.0 7168.0 8192.0]
#define DH_FOG_SUNSET_RAIN_DIST_MAX 4096.0 // [512.0 768.0 1024.0 2048.0 3072.0 4096.0 5120.0 6144.0 7168.0 8192.0]
#define FOG_SUNSET_RAIN_INTENSITY 0.8 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5]
#define FOG_SUNSET_RAIN_CURVE 1.0 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]

// Fog Color (Cave)
#define FOG_CAVE_R 0.5 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define FOG_CAVE_G 0.5 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define FOG_CAVE_B 0.5 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

// Fog Curve (Cave)
#define FOG_CAVE_DIST_MIN 0.0 // [0.0 64.0 128.0 192.0 256.0 512.0 768.0 1024.0 2048.0 3072.0 4096.0 5120.0 6144.0 7168.0 8192.0]
#define FOG_CAVE_DIST_MAX 4096.0 // [64.0 128.0 192.0 256.0 512.0 768.0 1024.0 2048.0 3072.0 4096.0 5120.0 6144.0 7168.0 8192.0]
#define DH_FOG_CAVE_DIST_MAX 4096.0 // [512.0 768.0 1024.0 2048.0 3072.0 4096.0 5120.0 6144.0 7168.0 8192.0]
#define FOG_CAVE_INTENSITY 0.1 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5]
#define FOG_CAVE_CURVE 1.0 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]

/*<==========================================================>*/
/*|                                                          |*/
/*|                           [SKY]                          |*/
/*|                                                          |*/
/*<==========================================================>*/

//<--------------------------[Clouds]------------------------>\\

// Cloud Ambience
#define CLOUD_AMBIENCE_R 0.5 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define CLOUD_AMBIENCE_G 0.8 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define CLOUD_AMBIENCE_B 1.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

//<--------------------------[Skybox]------------------------>\\

// Day Horizon (Normal)
#define SKY_DAY_A_R 0.3f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_DAY_A_G 0.6f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_DAY_A_B 1.0f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]

// Day Atmosphere (Normal)
#define SKY_DAY_B_R 0.6f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_DAY_B_G 0.8f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_DAY_B_B 1.0f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]


// Day Horizon (Normal, Rain)
#define SKY_DAY_RAIN_A_R 0.2f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_DAY_RAIN_A_G 0.4f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_DAY_RAIN_A_B 0.6f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]

// Day Atmosphere (Normal, Rain)
#define SKY_DAY_RAIN_B_R 0.4f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_DAY_RAIN_B_G 0.5f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_DAY_RAIN_B_B 0.6f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]


// Night Horizon (Normal)
#define SKY_NIGHT_A_R 0.0f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_NIGHT_A_G 0.1f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_NIGHT_A_B 0.2f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]

// Night Atmosphere (Normal)
#define SKY_NIGHT_B_R 0.1f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_NIGHT_B_G 0.2f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_NIGHT_B_B 0.3f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]


// Sunset/Sunrise Horizon (Normal)
#define SKY_SUNSET_A_R 1.0f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SUNSET_A_G 0.8f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SUNSET_A_B 0.4f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]

// Sunset/Sunrise Atmosphere (Normal)
#define SKY_SUNSET_B_R 0.6f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SUNSET_B_G 0.9f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SUNSET_B_B 1.0f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]


// Day Horizon (Silent Expanse)
#define SKY_SE_DAY_A_R 0.1f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SE_DAY_A_G 0.1f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SE_DAY_A_B 0.1f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]

// Day Atmosphere (Silent Expanse)
#define SKY_SE_DAY_B_R 0.4f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SE_DAY_B_G 0.4f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SE_DAY_B_B 0.4f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]


// Night Horizon (Silent Expanse)
#define SKY_SE_NIGHT_A_R 0.0f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SE_NIGHT_A_G 0.1f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SE_NIGHT_A_B 0.2f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]

#define SKY_SE_NIGHT_B_R 0.1f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SE_NIGHT_B_G 0.2f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SE_NIGHT_B_B 0.3f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]


// Sunset/Sunrise Horizon (Silent Expanse)
#define SKY_SE_SUNSET_A_R 0.0f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SE_SUNSET_A_G 0.8f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SE_SUNSET_A_B 0.4f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]

// Sunset/Sunrise Atmosphere (Silent Expanse)
#define SKY_SE_SUNSET_B_R 0.4f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SE_SUNSET_B_G 0.4f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]
#define SKY_SE_SUNSET_B_B 0.4f // [0.0f, 0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f]


uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferProjection;

uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferModelView;