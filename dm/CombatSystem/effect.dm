mob
	var/effect/effects[]
	var/slowed = FALSE
	var/slow_amount = 0.0

effect
	var/by_type = FALSE
	var/damage_type = FALSE
	var/can_stack = FALSE
	var/can_refresh = FALSE
	var/slow = FALSE
	var/slow_by_perc = 0.0 // 1 = 100%
	//damage to deal
	var/damage = 0
	// Initial damage
	var/init_damage = 0 
	//speed of how fast it ticks damage. 1/10 second
	var/tick_speed = 0
	//last_tick, when last tick accured. world time
	var/last_tick = null
	//duration, int
	var/duration = null
	//time of when effect ends, world time
	var/end_time = null
	//stacks, int
	var/stack = 0
	//Bonus damage by each stack. decimal
	var/stack_bonus_damage = 1.0
	var/mob/anchor = null
	
	New(mob/anchor)
		end_time = world.time + duration
		Anchor(anchor)
		UpdateLoop()

	Del()


	proc
		UpdateLoop()
			set waitfor = FALSE
			while(src)
				Update()
				sleep(10/world.fps)
		Update()
			if(Timeout())
				Del()
			if(NewTick())
				OnTrigger()

		Anchor()
			return length(args) ? (src.anchor = args[1]) : src.anchor

		// time related
		Timeout()
			return world.time >= end_time

		NewTick()
			return world.time >= (last_tick + tick_speed)
		
		Stack()
			RefreshDuration()
			if(!can_stack) return FALSE
			src.stack++
			src.damage = init_damage * (init_damage * stack * StackMultiplier())
		
		

		
		OnTrigger()
			Bleed()
			Burn()
			Toxin()

		// Prototype
		StackMultiplier(damage)
			//returns magnitude of how much to increase new damage. 
			// 1 = no magnitude.
			// 
			// Math:
			//		effect.damage = init_damage * (init_damage * stack * StackMultiplier())
			return 1
		Bleed()
		Burn()
		Toxin()
		Freeze()
		Slow()			
		RefreshDuration()