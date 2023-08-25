obj/spell
	// density = 1
	var
		x_offset = 0
		y_offset = 0
		
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

		active = 0

	proc
		Init(mob/caster, time=world.time)
			Damage(caster, time)
			Timer(caster, time)
			StepLoop(dir, step_delay)
		
		Timer(mob/caster, time=world.time)
			set waitfor = 0
			while(active && world.time<start_time+duration)
				sleep(min(10, start_time+duration-world.time))
			Expire(caster,world.time)

		StepLoop()
			set waitfor = 0
			while(active)
				Step(dir)
				sleep(world.tick_lag/10)
		
		Expire(mob/caster, time=world.time)
			if(active)
				active = 0
				loc = null
				Expired(caster, time)
		

		SetLocation(mob/target, loc)
			src.loc = loc
			step_x = x_offset+target.step_x
			step_y = y_offset+target.step_y
		
		
		Expired(mob/caster, time=world.time)
	
		Damage(mob/caster, time=world.time)

		OnHit(mob/caster, mob/target, time=world.time)


	New(mob/caster, time=world.time)
		src.uid = ckey(caster.key)
		src.active = 1
		Damage(caster)

	Step(dir, delay=step_delay)
		if(next_step - world.time >= world.tick_lag/10)
			return 0
		if(step(src, dir))
			last_step = world.time
			next_step = last_step + delay
			return 1
		else
			return 0

	CrossedMob(mob/m)
		..()
		if(!uid)
			return
		else if(m.key != src.uid) // Stop spell from hitting caster
			var/mob/caster = (src.uid&&OnlinePlayers[src.uid]) ? OnlinePlayers[src.uid] : 0
			if(!caster) return 0 // catch caster
			m.TakeDamage(caster, src.damage, src.damage_type)
			OnHit()