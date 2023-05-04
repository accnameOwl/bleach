/*
	These are simple defaults for your project.
 */
 #define TEST_BUILD

world
	fps = 25		// 25 frames per second
	icon_size = 32	// 32x32 icon size by default

	view = "20x16"		// show up to 6 tiles outward from center (13x13 view)

	name = "Bleach - Eternal Night"
	version = 0.1

	New()
		..()
		status="[world.name] (version [world.version]) <font color=red>(CLOSED TESTING)</font>"
		Initialize()
		var/err = LoadBanlist()
		if(err)
			world.log << "Could not read banlist."
		
// Make objects move 8 pixels per tick when walking

mob
	density = 1
	icon = 'base.dmi'
	bound_x = 10
	bound_width = 12
	bound_y = 0
	bound_height = 17
