mob
	var/list/spell_mastery = new
	var/list/spell_cd = new

obj/spell
	// density = 1
	var
<<<<<<< HEAD
=======
		x_offset = 0
		y_offset = 0
>>>>>>> refs/remotes/origin/trunk
		
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
<<<<<<< HEAD
			active = 1
			if(move_on_init) // if supposed to move on init, spawn movement loop
				SetLocation(caster, locate(caster.x, caster.y, caster.z))
				MovementLoop(dir, step_delay)
		
		Timer(mob/caster, time=world.time)
			set waitfor = 0
			while(active && world.time<start_time+duration)
				sleep(min(10, start_time+duration-world.time))
			Expire(caster,world.time)

		MovementLoop()
			set waitfor = 0
			while(active)
				Step(dir)
				sleep(world.tick_lag/10)
		
		Expire(mob/caster, time=world.time)
			if(active)
				active = 0
				loc = null
				Expired(caster, time)
		

		SetLocation(mob/caster, turf/loc)
			src.loc = loc

		StepOffset(x_offset, y_offset)
			step_x = x_offset
			step_y = y_offset
=======
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
		
>>>>>>> refs/remotes/origin/trunk
		
		Expired(mob/caster, time=world.time)
	
		Damage(mob/caster, time=world.time)

		OnHit(mob/caster, mob/target, time=world.time)


	New(mob/caster, time=world.time)
<<<<<<< HEAD
		..()
		src.uid = caster.key
=======
		src.uid = ckey(caster.key)
		src.active = 1
		Damage(caster)
>>>>>>> refs/remotes/origin/trunk

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
<<<<<<< HEAD
		if(!src.uid)
			return
		else if(m.key == src.uid) 
			return 0 // Stop spell from hitting caster
		var/mob/caster = OnlinePlayers[src.uid]
		if(!caster) 
			return 0 // no caster found.
		m.TakeDamage(caster, src.damage, src.damage_type)
		OnHit(caster, m, world.time)
=======
		if(!uid)
			return
		else if(m.key != src.uid) // Stop spell from hitting caster
			var/mob/caster = (src.uid&&OnlinePlayers[src.uid]) ? OnlinePlayers[src.uid] : 0
			if(!caster) return 0 // catch caster
			m.TakeDamage(caster, src.damage, src.damage_type)
			OnHit()
>>>>>>> refs/remotes/origin/trunk
