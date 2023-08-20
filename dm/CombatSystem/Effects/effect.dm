mob
	var/effect/effects[]
	var/slowed = FALSE
	var/slow_amount = 0 // ticks added to step_delay

effect
	var/mob/anchor
	var/duration = -1#INF
	var/end_time = -1#INF
	var/last_tick = -1#INF
	var/tick_speed = 0

	var/damage_type = FALSE
	var/damage = 0
	var/init_damage = 0 

	var/stack = 0
	var/stack_bonus_damage = 1.0
	
	New(mob/anchor)
		end_time = world.time + duration
		Anchor(anchor)
		UpdateLoop()

	Del()


	proc
		UpdateLoop()
			set waitfor = FALSE
			while(!Timedout())
				Update()
				sleep(10/world.fps)
			Del()

		Update()
			if(NewTick())
				OnTrigger()
		OnTrigger()
			Bleed()
			Burn()
			Toxin()

		Anchor()
			return length(args) ? (src.anchor = args[1]) : src.anchor

		// TIME RELATED
		Timedout()
			return world.time <= end_time

		NewTick()
			return world.time >= (last_tick + tick_speed)
		
		
		Stack()
			.=CanStack()
			if(.)
				src.stack++
				
		CanStack()
			return FALSE

		StackMultiplier()
			//src.damage = 
			//		init_damage + (init_damage * stack * StackMultiplier())
			return 1

		Bleed()
		Burn()
		Toxin()
		Freeze()
		Slow()			
		RefreshDuration()

		// GETTERS
		RefreshTimer()
			return FALSE