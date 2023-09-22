mob
	var/list/spell_mastery = new
	var/list/spell_cd = new

obj/spell
	// density = 1
	var
		
		// Behaviour flags
		move_on_init = FALSE /// Move in 'dir' at New()
		pierce_objects = FALSE /// pierce dense turfs and objects

	/*
	TODO:

		- No mob reference, use caster's key as uid instead
		- use id & sub_id
	*/

	var
		id = ""
		sub_id = ""
		uid = ""

		damage = 0
		damage_type = "" 

		duration = -1#INF
		start_time = 0

		x_offset = 0
		y_offset = 0

		active = 0

	proc
		Init(mob/caster, time=world.time)
			active = 1
			Damage(caster, time)
			Timer(caster, time)
			if(move_on_init) // if supposed to move on init, spawn movement loop
				SetLocation(locate(caster.x, caster.y, caster.z))
				MovementLoop(dir, step_delay)
			
			var/x_offset = caster.step_x + src.x_offset
			var/y_offset = caster.step_y + src.y_offset
			
			StepOffset(x_offset, y_offset)
		
		Timer(mob/caster, time=world.time)
			set waitfor = 0
			while(active && world.time<start_time+duration)
				sleep(min(10, start_time+duration-world.time))
			if(caster)
				Expire(caster,world.time)

		MovementLoop()
			set waitfor = 0
			while(active)
				Step(dir)
				sleep(10/world.fps)
		
		Expire(mob/caster, time=world.time)
			if(active)
				active = 0
				loc = null
				Expired(caster, time)
		
		SetLocation(turf/loc)
			src.loc = loc

		StepOffset(x_offset, y_offset)
			step_x = x_offset
			step_y = y_offset
		
		Expired(mob/caster, time=world.time)
	
		Damage(mob/caster, time=world.time)

		OnHit(mob/caster, mob/target, time=world.time)


	New(mob/caster, time=world.time)
		..()
		src.uid = caster.key
		src.dir = caster.dir

	Step(dir, delay=step_delay)
		if(next_step - world.time >= world.tick_lag/10)
			return 0
		if(step(src, dir))
			last_step = world.time
			next_step = last_step + delay
			world << "[src.name] steps"
			return 1
		else
			return 0

	CrossedMob(mob/m)
		..()
		var/mob/caster = src.uid ? OnlinePlayers[src.uid] : null
		if(!caster) 
			return 0 // no caster found.
		if(caster.key != src.uid)
			m.TakeDamage(caster, src.damage, src.damage_type)
			OnHit(caster, m, world.time)

