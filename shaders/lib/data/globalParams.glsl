// Forest of Eyes
bool seZone0 = cameraPosition.x >= 773 && cameraPosition.x <= 1083 && cameraPosition.z >= -544 && cameraPosition.z <= -293;

// Sinister Forest
bool seZone1 = cameraPosition.x >= 775 && cameraPosition.x <= 1099 && cameraPosition.z >= -669 && cameraPosition.z <= -466;

// Lutho
bool seZone2 = cameraPosition.x >= 896 && cameraPosition.x <= 1067 && cameraPosition.z >= -794 && cameraPosition.z <= -614;

// Paths of Sludge
bool seZone3 = cameraPosition.x >= 852 && cameraPosition.x <= 1080 && cameraPosition.z >= -910 && cameraPosition.z <= -727;

// Toxic Drip
bool seZone4 = cameraPosition.x >= 853 && cameraPosition.x <= 1126 && cameraPosition.z >= -1032 && cameraPosition.z <= -836;

// Toxic Caves
bool seZone5 = cameraPosition.x >= 804 && cameraPosition.x <= 1057 && cameraPosition.z >= -1106 && cameraPosition.z <= -953;

// Gateway to Nothing
bool seZone6 = cameraPosition.x >= 1080 && cameraPosition.x <= 1284 && cameraPosition.z >= -1098 && cameraPosition.z <= -842;

// Void Valley
bool seZone7 = cameraPosition.x >= 1042 && cameraPosition.x <= 1290 && cameraPosition.z >= -1201 && cameraPosition.z <= -1038;

// Final Step
bool seZone8 = cameraPosition.x >= 1214 && cameraPosition.x <= 1428 && cameraPosition.z >= -972 && cameraPosition.z <= -829;

// Bizarre Passage
bool seZone9 = cameraPosition.x >= 1147 && cameraPosition.x <= 1428 && cameraPosition.z >= -720 && cameraPosition.z <= -490;

// The Gate
bool seZone10 = cameraPosition.x >= 1225 && cameraPosition.x <= 1390 && cameraPosition.z >= -560 && cameraPosition.z <= -370;

// Grey Ruins
bool seZone11 = cameraPosition.x >= 422 && cameraPosition.x <= 723 && cameraPosition.z >= -659 && cameraPosition.z <= -475;

// Worm Tunnel
bool seZone12 = cameraPosition.x >= 503 && cameraPosition.x <= 681 && cameraPosition.z >= -807 && cameraPosition.z <= -600;

// Forgotten Town
bool seZone13 = cameraPosition.x >= 440 && cameraPosition.x <= 774 && cameraPosition.z >= -533 && cameraPosition.z <= -315;

bool isBiomeEnd=seZone0 || seZone1 || seZone2 || seZone3 || seZone4 || seZone5 || seZone6 || seZone7 || seZone8 || seZone9 || seZone10 || seZone11 || seZone12 || seZone13;

float seFactor = isBiomeEnd? clamp(exp(-frameTime), 0, 1) : clamp(1.0 - exp(-frameTime), 0, 1);