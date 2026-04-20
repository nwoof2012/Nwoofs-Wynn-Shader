/*<==========================================================>*/
/*|                                                          |*/
/*|                        [LIGHTING]                        |*/
/*|                                                          |*/
/*<==========================================================>*/

// Gamma (2.2 = sRGB)
#define GAMMA 2.2 // [1.0 1.2 1.4 1.6 1.8 2.0 2.2 2.4 2.6 2.8 3.0]

// Light Mode (0 = Classic, 1 = Fancy)
#define LIGHTING_MODE 1 // [0 1]

// Scene Aware Lighting
#define SCENE_AWARE_LIGHTING 2 // [0 2]

//<----------------------[Light Colors]---------------------->\\
// Ambient Occlusion Medthod (0 = Off, 1 = SSAO, 2 = GTAO)
#define AO 2 // [0 1 2]

#define AO_SCALE 3 // [0 1 2 3]

// Ambient Occlusion Width
#define AO_WIDTH 0.1 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

//<----------------------[Light Colors]---------------------->\\

// Day
#define LIGHT_DAY_R 1.1 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]
#define LIGHT_DAY_G 0.9 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]
#define LIGHT_DAY_B 0.8 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]
#define LIGHT_DAY_I 1.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]

// Day Natural
#define NATURAL_LIGHT_DAY_R 1.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define NATURAL_LIGHT_DAY_G 0.7 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define NATURAL_LIGHT_DAY_B 0.2 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define NATURAL_LIGHT_DAY_I 1.0 // [0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5]

// Sunset/Sunrise
#define LIGHT_SUNSET_R 1.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]
#define LIGHT_SUNSET_G 0.78 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]
#define LIGHT_SUNSET_B 0.55 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]

// Night
#define LIGHT_NIGHT_R 0.5 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define LIGHT_NIGHT_G 0.75 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define LIGHT_NIGHT_B 1.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define LIGHT_NIGHT_I 0.5 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

// Night Natural
#define NATURAL_LIGHT_NIGHT_R 0.2 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define NATURAL_LIGHT_NIGHT_G 0.7 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define NATURAL_LIGHT_NIGHT_B 1.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define NATURAL_LIGHT_NIGHT_I 0.1 // [0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5]

// Ambient
#define AMBIENT_LIGHT_R 0.5 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]
#define AMBIENT_LIGHT_G 0.75 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]
#define AMBIENT_LIGHT_B 1.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]

// Silent Expanse
#define LIGHT_SE_R 0.55 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]
#define LIGHT_SE_G 0.50 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]
#define LIGHT_SE_B 0.85 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]

//<----------------------[Light Levels]---------------------->\\

// Minimum Light
#define MIN_LIGHT 0.4f // [0.0f 0.05f 0.1f 0.15f 0.2f 0.25f 0.3f 0.35f 0.4f 0.45f 0.5f 0.55f 0.6f 0.65f 0.7f 0.75f 0.8f 0.85f 0.9f 0.95f 1.0f]

// Maximum Light
#define MAX_LIGHT 1.5f // [1.0f 1.1f 1.2f 1.3f 1.4f 1.5f 1.6f 1.7f 1.8f 1.9f 2.0f 2.1f 2.2f 2.3f 2.4f 2.5f 2.6f 2.7f 2.8f 2.9f 3.0f 3.1f 3.2f 3.3f 3.4f 3.5f 3.6f 3.7f 3.8f 3.9f 4.0f 4.1f]

// Minimum Foliage Light
#define MIN_FOLIAGE_LIGHT 1.0f // [0.0f 0.05f 0.1f 0.15f 0.2f 0.25f 0.3f 0.35f 0.4f 0.45f 0.5f 0.55f 0.6f 0.65f 0.7f 0.75f 0.8f 0.85f 0.9f 0.95f 1.0f]

// Shadow Brightness

#define SHADOW_BRIGHTNESS 0.4f // [0.0f 0.05f 0.1f 0.15f 0.2f 0.25f 0.3f 0.35f 0.4f 0.45f 0.5f]

//<-------------[Light Levels (Silent Expanse)]-------------->\\

// Minimum Light
#define SE_MIN_LIGHT 0.75f // [0.0f 0.05f 0.1f 0.15f 0.2f 0.25f 0.3f 0.35f 0.4f 0.45f 0.5f 0.55f 0.6f 0.65f 0.7f 0.75f 0.8f 0.85f 0.9f 0.95f 1.0f]

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
#define LIGHTMAP_QUALITY 8 // [4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80 84 88 92 96 100 104 108 112 116 120 124 128]

// Texture Parameters
#define VOXEL_AREA 128 //[32 64 128]
#define VOXEL_RADIUS (VOXEL_AREA/2)

//<---------------------[Normal Lighting]------------------->\\

// Blocklight Color
#define LIGHT_COLOR_R 1.0 // [0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]
#define LIGHT_COLOR_G 0.9 // [0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]
#define LIGHT_COLOR_B 0.8 // [0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]

//<-------------------------[Shadows]----------------------->\\

// Filter Samples
#define SHADOW_SAMPLES 2

// Texture Resolution
#define SHADOW_RES 4096 // [128 256 512 1024 2048 4096 8192]

// Maximum Distance
#define SHADOW_DIST 12 // [4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32]

// Variable Penumbra
#define VARIABLE_PENUMBRA_SHADOWS

//<---------------------------[Misc]------------------------>\\

#define LIGHT_UPSAMPLE_FACTOR 0.25

#define LIGHT_RESOLUTION 270

#define PATH_TRACING_GI 0 // [0 1]

/*<==========================================================>*/
/*|                                                          |*/
/*|                         [CAMERA]                         |*/
/*|                                                          |*/
/*<==========================================================>*/

//<------------------------[Exposure]----------------------->\\

// Toggle Exposure
#define AUTO_EXPOSURE

// Exposure (Normal)
#define NORM_EXP 2.0 // [0.5 1.0 1.5 2.0 2.5 3.0 3.5 4.0 4.5 5.0 5.5 6.0 6.5 7.0 7.5 8.0 8.5 9.0 9.5 10.0 10.5 11.0 11.5 12.0 12.5 13.0 13.5 14.0 14.5 15.0 15.5 16.0 16.5 17.0 17.5 18.0 18.5 19.0 19.5 20.0]

#define NORM_EXP_BLEND 0.5 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

// Exposure (Silent Expanse)
#define SE_EXP 14.0 // [0.5 1.0 1.5 2.0 2.5 3.0 3.5 4.0 4.5 5.0 5.5 6.0 6.5 7.0 7.5 8.0 8.5 9.0 9.5 10.0 10.5 11.0 11.5 12.0 12.5 13.0 13.5 14.0 14.5 15.0 15.5 16.0 16.5 17.0 17.5 18.0 18.5 19.0 19.5 20.0]

#define SE_EXP_BLEND 1.0 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

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

//<---------------------[Color Grading]---------------------->\\

// Day Tint
#define DAY_R 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
#define DAY_G 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
#define DAY_B 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
#define DAY_I 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]

// Night Tint
#define NIGHT_R 0.9f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
#define NIGHT_G 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
#define NIGHT_B 1.1f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
#define NIGHT_I 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]

// Sunset/Sunrise Tint
#define SUNSET_R 1.1f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
#define SUNSET_G 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
#define SUNSET_B 0.8f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
#define SUNSET_I 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]

// Silent Expanse Tint
#define SE_R 0.7f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
#define SE_G 0.4f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
#define SE_B 0.8f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]
#define SE_I 1.0f // [0.5f 0.6f 0.7f 0.8f 0.9f 1.0f 1.1f 1.2f 1.3f 1.4f 1.5f]

// Silent Expanse Desaturation Factor (0 = Grayscale, 1 = Fully Saturated)
#define MIN_SE_SATURATION 1.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

// Vibrant Mode (0 = Off, 1 = On, 2 = SE Only, 3 = Regular Only)
#define VIBRANT_MODE 1 //[0 1 2 3]

// Vibrant Mode LUTs
#define LUT_NORM 1 // [0 1 2]
#define LUT_SE 0 // [0 1]

/*<==========================================================>*/
/*|                                                          |*/
/*|                          [WATER]                         |*/
/*|                                                          |*/
/*<==========================================================>*/

// Rendering
#define WATER_REFRACTION
#define WATER_FOAM

// Displacement
#define WATER_WAVES

// Style
#define WATER_STYLE 1 // [0 1]

/*<==========================================================>*/
/*|                                                          |*/
/*|                          [WORLD]                         |*/
/*|                                                          |*/
/*<==========================================================>*/

//<------------------------[Rendering]----------------------->\\

// Screen Space Reflections (0 = Off, 1 = On, 2 = Water Only, 3 = Metal Only)
#define SSR 1 // [0 1 2 3]

#if SSR > 0
    /*
        const int colortex2Format = RGBA16F;
    */
#endif
 
// World Curvature
//#define WORLD_CURVATURE

//<---------------------------[Fog]-------------------------->\\

// Fog Style
#define FOG_STYLE 2 // [0 1 2]

// Fog Precision
#define FOG_PRECISION 64 // [4 8 16 32 64 128]

// Fog Color (Day)
#define FOG_DAY_R 0.8 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define FOG_DAY_G 0.9 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define FOG_DAY_B 1.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

// Fog Curve (Day)
#define FOG_DAY_DIST_MIN 256.0 // [0.0 64.0 128.0 192.0 256.0 512.0 768.0 1024.0 2048.0 3072.0 4096.0 5120.0 6144.0 7168.0 8192.0]
#define FOG_DAY_DIST_MAX 8192.0 // [64.0 128.0 192.0 256.0 512.0 768.0 1024.0 2048.0 3072.0 4096.0 5120.0 6144.0 7168.0 8192.0]
#define DH_FOG_DAY_DIST_MAX 4096.0 // [512.0 768.0 1024.0 2048.0 3072.0 4096.0 5120.0 6144.0 7168.0 8192.0]
#define FOG_DAY_INTENSITY 0.2 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5]
#define FOG_DAY_DENSITY 1.0 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4.0 4.1 4.2 4.3 4.4 4.5 4.6 4.7 4.8 4.9 5.0]
#define FOG_DAY_CURVE 1.0 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]

// Fog Color (Night)
#define FOG_NIGHT_R 0.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define FOG_NIGHT_G 0.1 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define FOG_NIGHT_B 0.2 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

// Fog Curve (Night)
#define FOG_NIGHT_DIST_MIN 256.0 // [0.0 64.0 128.0 192.0 256.0 512.0 768.0 1024.0 2048.0 3072.0 4096.0 5120.0 6144.0 7168.0 8192.0]
#define FOG_NIGHT_DIST_MAX 8192.0 // [64.0 128.0 192.0 256.0 512.0 768.0 1024.0 2048.0 3072.0 4096.0 5120.0 6144.0 7168.0 8192.0]
#define DH_FOG_NIGHT_DIST_MAX 4096.0 // [512.0 768.0 1024.0 2048.0 3072.0 4096.0 5120.0 6144.0 7168.0 8192.0]
#define FOG_NIGHT_INTENSITY 0.1 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5]
#define FOG_NIGHT_DENSITY 0.5 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4.0 4.1 4.2 4.3 4.4 4.5 4.6 4.7 4.8 4.9 5.0]
#define FOG_NIGHT_CURVE 1.3 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]

// Fog Color (Sunset)
#define FOG_SUNSET_R 1.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define FOG_SUNSET_G 0.5 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define FOG_SUNSET_B 0.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

// Fog Curve (Sunset)
#define FOG_SUNSET_DIST_MIN 256.0 // [0.0 64.0 128.0 192.0 256.0 512.0 768.0 1024.0 2048.0 3072.0 4096.0 5120.0 6144.0 7168.0 8192.0]
#define FOG_SUNSET_DIST_MAX 8192.0 // [64.0 128.0 192.0 256.0 512.0 768.0 1024.0 2048.0 3072.0 4096.0 5120.0 6144.0 7168.0 8192.0]
#define DH_FOG_SUNSET_DIST_MAX 4096.0 // [512.0 768.0 1024.0 2048.0 3072.0 4096.0 5120.0 6144.0 7168.0 8192.0]
#define FOG_SUNSET_INTENSITY 0.1 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5]
#define FOG_SUNSET_DENSITY 1.0 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4.0 4.1 4.2 4.3 4.4 4.5 4.6 4.7 4.8 4.9 5.0]
#define FOG_SUNSET_CURVE 2.0 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]

// Fog Color (Silent Expanse)
#define FOG_SE_R 0.2 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define FOG_SE_G 0.1 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define FOG_SE_B 0.3 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

// Fog Curve (Silent Expanse)
#define FOG_SE_DIST_MIN 128.0 // [0.0 64.0 128.0 192.0 256.0 512.0 768.0 1024.0 2048.0 3072.0 4096.0 5120.0 6144.0 7168.0 8192.0]
#define FOG_SE_DIST_MAX 8192.0 // [64.0 128.0 192.0 256.0 512.0 768.0 1024.0 2048.0 3072.0 4096.0 5120.0 6144.0 7168.0 8192.0]
#define DH_FOG_SE_DIST_MAX 4096.0 // [512.0 768.0 1024.0 2048.0 3072.0 4096.0 5120.0 6144.0 7168.0 8192.0]
#define FOG_SE_INTENSITY 0.1 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5]
#define FOG_SE_DENSITY 0.5 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4.0 4.1 4.2 4.3 4.4 4.5 4.6 4.7 4.8 4.9 5.0]
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
#define FOG_DAY_RAIN_DENSITY 0.5 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4.0 4.1 4.2 4.3 4.4 4.5 4.6 4.7 4.8 4.9 5.0]
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
#define FOG_NIGHT_RAIN_DENSITY 0.5 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4.0 4.1 4.2 4.3 4.4 4.5 4.6 4.7 4.8 4.9 5.0]
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
#define FOG_SUNSET_RAIN_DENSITY 0.5 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4.0 4.1 4.2 4.3 4.4 4.5 4.6 4.7 4.8 4.9 5.0]
#define FOG_SUNSET_RAIN_CURVE 1.0 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]

// Fog Color (Cave)
#define FOG_CAVE_R 0.5 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define FOG_CAVE_G 0.5 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define FOG_CAVE_B 0.5 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

// Fog Curve (Cave)
#define FOG_CAVE_DIST_MIN 64.0 // [0.0 64.0 128.0 192.0 256.0 512.0 768.0 1024.0 2048.0 3072.0 4096.0 5120.0 6144.0 7168.0 8192.0]
#define FOG_CAVE_DIST_MAX 4096.0 // [64.0 128.0 192.0 256.0 512.0 768.0 1024.0 2048.0 3072.0 4096.0 5120.0 6144.0 7168.0 8192.0]
#define DH_FOG_CAVE_DIST_MAX 4096.0 // [512.0 768.0 1024.0 2048.0 3072.0 4096.0 5120.0 6144.0 7168.0 8192.0]
#define FOG_CAVE_INTENSITY 0.1 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5]
#define FOG_CAVE_DENSITY 5.0 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4.0 4.1 4.2 4.3 4.4 4.5 4.6 4.7 4.8 4.9 5.0]
#define FOG_CAVE_CURVE 1.0 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]

// Fog Color (Mistwoods)
#define FOG_MISTWOODS_R 0.5 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define FOG_MISTWOODS_G 0.7 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define FOG_MISTWOODS_B 0.3 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

// Fog Curve (Mistwoods)
#define FOG_MISTWOODS_DIST_MIN 64.0 // [0.0 64.0 128.0 192.0 256.0 512.0 768.0 1024.0 2048.0 3072.0 4096.0 5120.0 6144.0 7168.0 8192.0]
#define FOG_MISTWOODS_DIST_MAX 1024.0 // [64.0 128.0 192.0 256.0 512.0 768.0 1024.0 2048.0 3072.0 4096.0 5120.0 6144.0 7168.0 8192.0]
#define DH_FOG_MISTWOODS_DIST_MAX 4096.0 // [512.0 768.0 1024.0 2048.0 3072.0 4096.0 5120.0 6144.0 7168.0 8192.0]
#define FOG_MISTWOODS_INTENSITY 1.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5]
#define FOG_MISTWOODS_DENSITY 4.0 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4.0 4.1 4.2 4.3 4.4 4.5 4.6 4.7 4.8 4.9 5.0]
#define FOG_MISTWOODS_CURVE 1.0 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]

// Fog Rain Multiplier
#define FOG_RAIN_MULTIPLIER 1.0

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

/*<==========================================================>*/
/*|                                                          |*/
/*|                          [DEBUG]                         |*/
/*|                                                          |*/
/*<==========================================================>*/

// Debug Toggle (0 = Off, 1 = On)
#define DEBUG 0 // [0 1]

// Debug Mode (0 = Base Color, 1 = Normal, 2 = Lighting, 3 = Buffer A, 4 = Buffer B, 5 = Buffer C, 6 = Depth, 7 = Distance From Camera, 8 = Water Depth)
#define DEBUG_MODE 0 // [0 1 2 3 4 5 6 7 8]

/*<==========================================================>*/
/*|                                                          |*/
/*|                          [MISC]                          |*/
/*|                                                          |*/
/*<==========================================================>*/

// Particle Rain Support
//#define PARTICLE_RAIN_SUPPORT