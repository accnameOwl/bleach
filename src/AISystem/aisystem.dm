

mob/monster
	step_size = MONSTER_STEP_SIZE
	var/mob/target = null
	var/datum/trigger/ai_trigger
	var/tmp/turf/home_loc
	var/aggro_dist=4
	var/attack_reach = 22 //pixels
	var/chase_speed = 1 //increased pixels to move

	var/last_attack_timestamp

mob/monster/New()
	..()
	home_loc = loc
	respawn_loc = loc
	RestingState()

mob/monster/Trigger(mob/m)
	if(m.client)
		TargetState(m)

mob/monster/Attack()
	for(var/mob/m in obounds(src, attack_reach))
		if(m.client)
			DealDamage(m, attack.value)

mob/monster/Death(mob/killer)
	..(killer)
	target = null
	if(ai_trigger && ai_trigger.loc)
		ai_trigger.loc = null

mob/monster/Respawn()
	var/mob/monster/n = src
	if(!n) 
		return
	
	var/_loc = respawn_loc
	var/_delay = respawn_time
	
	if(!_delay)
		n.combat_flag.dead = 1
		n.loc = null
		return
	n.combat_flag.dead = 1
	n.loc = null
	spawn(_delay)
		n.health.value = n.health.limit
		n.combat_flag.dead = 0
		n.loc = _loc
		n.RestingState()



mob/monster/proc/RestingState()
	if(!ai_trigger)
		ai_trigger = new/datum/trigger(src)
		ai_trigger.Scale(aggro_dist, aggro_dist)
		ai_trigger.ChangeBounds((aggro_dist * world.icon_size/2)*-1, (aggro_dist * world.icon_size / 2)*-1, aggro_dist, aggro_dist)
	ai_trigger.loc = src.loc
	step_rand_loop()

mob/monster/proc/TargetState(mob/new_target)
	if(!target)
		target = new_target
		ai_trigger.loc = null
		ai_trigger = null
		ChaseState()

mob/monster/proc/ChaseState()
	if(target)
		combat_flag.in_combat = TRUE
		walk(src, 0)
		
		var/_dist 	= get_dist(src, target)
		var/_dir	= get_dir(src, target)
		
		#define chase_step_size step_size+chase_speed

		while(_dist <= aggro_dist && target)

			_dist = get_dist(src, target)
			_dir = get_dir(src, target)

			if(_dist <= 1)
				dir = _dir
				var/_bounds_dist = bounds_dist(src, target)
				if(_bounds_dist > attack_reach)
					. = step(src, _dir, chase_step_size)
					if(!.)
						step_rand(src,chase_step_size)
				else
					if(!last_attack_timestamp)
						last_attack_timestamp = world.time
					if(world.time > last_attack_timestamp)
						Attack()
						last_attack_timestamp = world.time + SECOND
			else
				. = step(src, _dir, chase_step_size)
				if(!.)
					step_rand(src, chase_step_size)

			if(target.combat_flag.dead)
				src.target = null
			if(src.combat_flag.dead)
				break

			sleep(10/world.fps)

		#undef chase_step_size

		target = null
		if(combat_flag.dead)
			return
	. = ResetState()

mob/monster/proc/ResetState()
	
	var/_dist = get_dist(src, home_loc)
	var/_dir = get_dir(src, home_loc)
	
	while(_dist > 0)
		. = step(src, _dir)

		_dist = get_dist(src, home_loc)
		_dir = get_dir(src, home_loc)
		sleep(world.tick_lag * chase_speed)
	combat_flag.in_combat = FALSE
	. = RestingState()



mob/monster/proc/step_rand_loop()
	while(src)
		if(combat_flag.in_combat)
			break
		if(combat_flag.dead)
			break
		var/_locToWalk
		dir = pick( NORTH, SOUTH, EAST, WEST)
		switch(dir)
			if(NORTH)
				_locToWalk = locate(x,y+2,z)
			if(SOUTH)
				_locToWalk = locate(x,y-2,z)
			if(EAST)
				_locToWalk = locate(x+2,y,z)
			if(WEST)
				_locToWalk = locate(x-2,y,z)
		walk_towards(src, _locToWalk,2,step_size)
		if(ai_trigger)
			ai_trigger.loc = loc
		sleep(rand(50,110))
