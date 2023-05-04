mob
	var/datum/effects[]
	var/slowed = FALSE
	var/slow_amount = 0.0

/datum/effect
	var/by_type = FALSE
	var/damage_type = FALSE
	var/can_stack = FALSE
	var/can_refresh = FALSE
	var/slow = FALSE
	var/slow_by_perc = 0.0 // 1 = 100%
	//damage to deal
	var/damage = 0
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

/datum/effect/New()
	end_time = world.time + duration
	spawn()	while(src)
		//if effect times out
		if(world.time >= end_time)
			Del(src)
		//if it deals tick_damage
		if(damage_type == BLEED_TYPE|BURN_TYPE|TOXIN_TYPE)
			if(world.time >= last_tick+tick_speed)
				new_tick()
		//if it's a slow effect. slow anchored mob
		if(damage_type == FREEZE_TYPE)
			if(slow && !anchor.slowed)
				anchor.slowed=TRUE
				anchor.slow_amount += slow_by_perc

/datum/effect/Del()
	if(slow && anchor)
		anchor.slow_amount -= slow_by_perc
		if(anchor.slow_amount == 0)
			anchor.slowed = FALSE
	del src
		

/datum/effect/proc/new_tick()	
	if(!anchor) return
	if(damage)
		anchor.DealDamage(anchor, stack?(damage*(stack*stack_bonus_damage)) : damage, damage_type)
		last_tick = world.time

/datum/effect/proc/attach_anchor_to(mob/__anchor)
	if(__anchor.effects?[src.type])
		var/datum/effect/already_existing = __anchor.effects[src.type]
		already_existing.refresh_by(src.type)
	else
		anchor = __anchor
		__anchor.effects += src


/datum/effect/proc/refresh_by(datum/effect/_e)
	if(by_type == _e.by_type)
		if(can_stack)
			stack++
		if(can_refresh)
			end_time = world.time + duration

