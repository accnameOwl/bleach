mob
	var
		list/effects = list()
		tmp
			list/effect_registry = list()
		
	proc
		AddEffect(effect/e, time=world.time)
			e.Add(src,time)
		
		RemoveEffect(effect/e, time=world.time)
			e.Remove(src,time)
	
	Read(savefile/F)
		..()
		var
			list/l = effects
			time_offset = (world.time /*- save_worldtime*/)
			real_offset = (world.realtime /*- save_realtime*/) + time_offset
		
		effects = list()
		for(var/effect/e in l)
			switch(e.preserve)
				if(PRESERVE_WORLDTIME)
					e.Add(src,e.start_time+time_offset)
				if(PRESERVE_REALTIME)
					e.Add(src, e.start_time+real_offset)

effect
	var
		id
		sub_id = "global"

		active = 0
		start_time = 0

		duration = 1#INF

		tick_delay
		ticks = 0

		stacks = 1
		max_stacks = 1

		preserve = PRESERVE_WORLDTIME
	
	proc

		Add(mob/target, time=world.time)
			set hidden = 0
			if(world.time-time > duration)
				return 0
			var/list/registry = target.effect_registry
			var/uid
			if(id&&sub_id)
				uid = "[id].[sub_id]" //unique id

				var/effect/e = registry[uid]
				
				// If we found an effect matching our uniqueid, we tell this
				// effect to attempt to override it. If it fails, we return 0
				if(e && !Override(target, e, time)) 
					return 0
				if(id)
					var/list/group = registry[id] //get current ID group
					if(!group)
						registry[id] = src
					else if(istype(group))
						group += src
					else if(istype(group, /effect))
						registry[id] = list(group, src)
					else
						return 0
			if(uid)
				registry[uid] = src
			target.effects += src

			active = 1
			start_time = time
			Added(target,time)

			if(active)
				if(duration<1#INF)
					if(tick_delay)
						Ticker(target,time)
					else
						Timer(target, time)
				else if(tick_delay)
					Ticker(target,time)

			else
				Remove()
				return 0
			
			return 1

		Override(mob/target, effect/overriding, time=world.time)
			// Check if the max number of stacks match between the two and are 
			// greater than 1
			if(max_stacks>1 && max_stacks==overriding.max_stacks) 
				Stack(target,overriding)
			overriding.Overridden(target, src, time)
			overriding.Cancel(target,time)
			return 1
		
		Stack(mob/target, effect/overriding)
			// Set this element's stacks to the old effect's stacks, 
			// then replace it
			stacks = min(stacks + overriding.stacks, max_stacks)
		
		Timer(mob/target, time=world.time)
			set waitfor = 0
			while(active && world.time < start_time+duration)
				// wait a maximum of 1 second.
				// This is to prevent already-canceled effects from hanging out
				// in the scheduler for too long.
				sleep(min(10,start_time+duration-world.time))
			Expire(target, world.time)
		
		Ticker(mob/target, time=world.time)
			set waitfor = 0
			while(active && world.time < start_time+duration)
				// call the Ticked() hook.
				// This is another override that allows you to define what
				// these ticker effects will do every time they tick.
				Ticked(target, ++ticks, world.time)
				// Sleep for a minimum period
				sleep(min(tick_delay, start_time+duration-world.time))
			Expire(target, world.time)
		
		Reset(mob/target, time=world.time)
			start_time = time
		
		Cancel(mob/target, time=world.time)
			if(active)
				active = 0
				Canceled(target, time)
				if(!active)
					Remove(target, time)
		
		Remove(mob/target, time=world.time)
			var/list/registry = target.effect_registry
			if(id && sub_id)
				var/uid = "[id].[sub_id]"

				// Some complex logic to test whether this object is actually in
				// the registry. Fail out if the data isn't right.
				if(registry[uid]==src)
					registry -= uid
			
			if(id)
				var/list/group = registry[id]
				group -= src
				if(group.len==1)
					registry[id] = group[1]
				else if(group.len==0)
					registry -= id
				else if(group==src)
					registry -= id

			target.effects -= src

			Removed(target,time)
			active=0
			return 1
		
		Expire(mob/target, time=world.time)
			if(active)
				active = 0
				Expired(target, time)
				if(!active)
					Remove(target,time)
		
		Added(mob/target, time=world.time)
		Ticked(mob/target, tick, time=world.time)
		Removed(mob/target, time=world.time)
		Overridden(mob/target,effect/override, time=world.time)
		Expired(mob/target, time=world.time)
		Canceled(mob/target, time=world.time)
