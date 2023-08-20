effect/debuff

	slow
		var/slow_tick_delay = 5

		duration = 50 // 5 seconds
		tick_speed = 10

		New(mob/anchor)
			. = ..()
			if(.) 
				Slow()
		
		Del()
			anchor.slow_amount -= src.slow_tick_delay*stack

		Slow()
			anchor.slowed = TRUE
			anchor.slow_amount += src.slow_tick_delay

		OnTrigger()
			if(stack < 4)
				Stack()
		Stack()
			.=..()
			if(.)
				Slow()
				
		CanStack()
			return TRUE