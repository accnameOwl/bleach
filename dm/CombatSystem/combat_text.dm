obj/damage_text
	var/timeout
	New(text, crit = FALSE)
		..()
		timeout = world.time + 5
		maptext = crit ? Red(text) : Yellow(text)
		while(src)
			step(src, NORTH, 1)
			if(timeout >= world.time)
				del src


#define DAMAGETEXT_WIDTH 64
/proc/DamageText(text, location, offset_x, offset_y)

	var/obj/dt = new

	dt.layer = MOB_LAYER+2
	dt.loc = location
	dt.step_x = rand(-10,10) + offset_x - DAMAGETEXT_WIDTH/2
	dt.step_y += rand(-2,2) + offset_y
	dt.maptext_width = DAMAGETEXT_WIDTH
	dt.maptext = "<CENTER>[text]</CENTER>"
	spawn(12)
		del dt
	while(dt)
		step(dt, NORTH, 1)
		sleep(world.tick_lag/world.fps)
