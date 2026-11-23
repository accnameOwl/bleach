/*
	These are simple defaults for your project.
 */
#define TEST_BUILD 0.4
#define LIB_PATH "G:/Github/dream maker/CharacterAPI"
#define SYS_LEVELING_POINTS

#if DM_VERSION < 516 && DM_BUILD < 1664
#error Compiler outdated. Required DM version: 516.1664
#elif DM_VERSION > 516
#warn You are using a newer DM build than requried. Issues may occur...
#endif

client
	tick_lag = 0.01

world
	fps = 10
	icon_size = 32
	movement_mode = PIXEL_MOVEMENT_MODE

	view = "25x14"		// show up to 6 tiles outward from center (13x13 view)

	// port: 61354
	#ifdef TEST_BUILD
	name = "Bleach: Next (Alpha)"
	#else
	name = "Bleach: Next"
	#endif
	version = TEST_BUILD
	hub = "Tafe.BleachNext"
	hub_password = "wSJjrtCAv4ssDvKj"

// Make objects move 8 pixels per tick when walking

mob
	density = 1
	icon = 'base.dmi'
	bound_x = 10
	bound_width = 12
	bound_y = 0
	bound_height = 17
