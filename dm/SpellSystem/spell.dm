obj/spell
	// density = 1
	var
		mob/caster = null /// belongs to caster
		x_offset = 0
		y_offset = 0
		
		// Behaviour flags
		move_on_init = FALSE /// Move in 'dir' at New()
		pierce_objects = FALSE /// pierce dense turfs and objects



		// New spell system
	


	proc



		Lifespan(var/timestamp = 0)
			set waitfor = 0
			while(TRUE)
				if(world.time >= timestamp)
					del(src)
				sleep(10/world.fps)
		

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

	

	/*
	TODO:

		- No mob reference, use key as uid instead
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

		speed = 0

		list/effects = list()
		tmp/effect_registry = list()

	proc
		AddEffect(effect/e, time=world.time)
			e.Add(src,time)
		
		RemoveEffect(effect/e, time=world.time)
			e.Remove(src,time)
		
		Timer(mob/caster, time=world.time)
			set waitfor = 0
			while(active && world.time<start_time+duration)
				sleep(min(10, start_time+duraton-world.time))
			Expire(caster,world.time)

		StepLoop()
			set waitfor = 0
			while(active)
				Step(dir)
				sleep(world.tick_lag/10*speed)
		
		Expire(mob/caster, time=world.time)
			if(active)
				active = 0
				loc = NULL
				Expired(caster, time)
		
		Expired(mob/caster, time=world.time)
	
		Damage(mob/caster)
			//prototype

		SetLocation(mob/target, loc)
			src.loc = loc
			step_x = x_offset+target.step_x
			step_y = y_offset+target.step_y

	New(mob/caster, time=world.time)
		Timer(caster, time)
		StepLoop()

	Step(dir, delay=step_delay)
		if(next_step - world.time >= world.tick_lag/10)
			return 0
		if(step(src, dir))
			last_step = world.time
			next_step = last_step + delay
			return 1
		else
			return 0

