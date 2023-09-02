/*
	These are simple defaults for your project.
 */
#define TEST_BUILD
#define DEBUG
#define LIB_PATH "G:/Github/dream maker/CharacterAPI"

client
	fps = 25

world
	fps = 25		// 25 frames per second
	icon_size = 32	// 32x32 icon size by default

	view = "12x12"		// show up to 6 tiles outward from center (13x13 view)

	name = "Bleach - Eternal Night"
	version = 0.1

	// Player type for players
	mob = /mob/player
// Make objects move 8 pixels per tick when walking

mob
	density = 1
	icon = 'base.dmi'
	bound_x = 10
	bound_width = 12
	bound_y = 0
	bound_height = 17
