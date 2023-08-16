obj/spell
	// density = 1
	var
		id
		duration = 0
		damage = 0
		damage_type = "" 
		mob/caster = null /// belongs to caster
		x_offset = 0
		y_offset = 0
		
		// Behaviour flags
		move_on_init = FALSE /// Move in 'dir' at New()
		pierce_objects = FALSE /// pierce dense turfs and objects

	proc
		Lifespan(var/timestamp = 0)
			set waitfor = 0
			while(TRUE)
				if(world.time >= timestamp)
					del(src)
				sleep(10/world.fps)
		
		StepLoop()
			set waitfor = 0
			if(move_on_init)
				while(src)
					Step(dir)
					sleep(world.tick_lag/10)

		ApplyEffects(mob/mob)
			//Prototype
		OnHit()
			// Prototype

	New(mob/caster, dir, loc, x_delta=0, y_delta=0)
		src.caster = caster
		src.dir = dir
		src.loc = loc
		step_x += x_delta+x_offset
		step_y += y_delta+y_offset
	
		// Kills the object after duration is elapsed
		Lifespan(world.time + duration)
		//Conditional flags

	
	Step(dir, delay=step_delay)
		if(next_step - world.time >= world.tick_lag/10)
			return 0
		if(step(src, dir))
			last_step = world.time
			next_step = last_step + delay
			return 1
		else
			return 0

	//TODO: 
	// Does not work properly
	// // Bump(atom/movable/a)
	// Bump(atom/movable/a)	
	// 	.=..()
	// 	if(ismob(a))
	// 		if(a==caster)
	// 			return
	// 		if(istype(a,/mob/NPC)) 
	// 			return
	// 		var/mob/target = a
	// 		target.TakeDamage(caster, damage, damage_type, name)

	// 	//TODO
	// 	// As it stands, objects get deleted when hitting a turf with density
	// 	//	It should instead go 'through' the turf if that happens, if 
	// 	// piercing is enabled
	// 	else
	// 		if(!pierce_objects)
	// 			del(src)
