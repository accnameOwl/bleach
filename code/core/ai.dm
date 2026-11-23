/*******
 * Author: Tafe
 * Title: Bleach Next
 * File: mob_monster.dm
 *
 * Desc:
 *      Contains interraction states for monsters.
 *      This file specifically handles the way monsters interact with players.
 *
 * Procs
 *      /mob/monster/proc/
*/


mob/monster
	icon = 'monsters.dmi'
	
	step_size = MONSTER_STEP_SIZE

	var
		trigger/ai_trigger
		aggro_dist=4
		attack_reach = 22 //pixels
		chase_speed = 1 //increased pixels to move

		last_attack_timestamp

		tmp
			turf/home_loc
	
	New(loc)
		..(loc)
		home_loc = loc

		get_vars_from_json(json_data_monsters[json_id])

		step_rand_loop()


	proc/chase_state()
	proc/reset_state()
	proc/resting_state()
	proc/reward(mob/player/killed_by)
	proc/step_rand_loop()
	proc/new_target_state(mob/new_target)

	// called by /datum/trigger object(var/trigger/ai_trigger)
	proc/trigger(mob/triggered_by)


	chase_state()
		if(target)
			in_combat = TRUE
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
							last_attack_timestamp = world.time + SECOND(1)
				else
					. = step(src, _dir, chase_step_size)
					if(!.)
						step_rand(src, chase_step_size)

				if(target.is_dead)
					src.target = null
				if(src.is_dead)
					break

				sleep(10/world.fps)

			#undef chase_step_size

			target = null
			if(is_dead)
				return
		. = reset_state()



	reset_state()

		var/_dist = get_dist(src, home_loc)
		var/_dir = get_dir(src, home_loc)

		while(_dist > 0)
			. = step(src, _dir)

			_dist = get_dist(src, home_loc)
			_dir = get_dir(src, home_loc)
			sleep(world.tick_lag * chase_speed)
		in_combat = FALSE
		. = resting_state()

	resting_state()
		if(!ai_trigger)
			ai_trigger = new/trigger(src)
			ai_trigger.scale(aggro_dist)
		ai_trigger.loc = src.loc
		step_rand_loop()

	reward(mob/player/killed_by)
		killed_by.gain_experience(reward_experience)
		killed_by.stat_attack += reward_attack
		killed_by.stat_reiatsu += reward_stat_reiatsu
		killed_by.stat_defense += reward_defense
		killed_by.hp += reward_health
		killed_by.max_hp += reward_health
		killed_by.mana += reward_reiatsu
		killed_by.max_mana += reward_reiatsu
		killed_by.client?.dirty_stat("hp","max_hp","mana","max_mana","stat_attack","stat_defense","stat_reiatsu","exp","req_exp")

	// There should be a "set_target()" proc with different type & state checks.
	new_target_state(mob/new_target)
		if(!target)
			target = new_target
			ai_trigger.loc = null
			ai_trigger = null
			chase_state()

	trigger(mob/triggered_by)
		if(!triggered_by.client)
			//expect client to be connected.
			return

		else
			// This should probably have some state safeties... :thinking:
			new_target_state(triggered_by)

	step_rand_loop()
		while(src)
			if(in_combat)
				break
			if(is_dead)
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

	on_death()
		target = null
		if(ai_trigger && ai_trigger.loc)
			ai_trigger.loc = null

	respawn()
		var/mob/monster/n = src
		if(!n)
			return

		// make sure respawn_loc exists, if not... default to initial of loc
		// does initial(loc) = null, or is it initialized compiletime through map generation ? not sure
		var/_loc = respawn_loc ? respawn_loc : initial(loc) 

		var/respawn_sleeptime = respawn_time

		if(!respawn_sleeptime)
			n.is_dead = 1
			n.loc = null
			return
		n.is_dead = 1
		n.loc = null
		spawn(respawn_sleeptime)
			n.hp = n.max_hp
			n.is_dead = 0
			n.loc = _loc
			n.resting_state()



trigger
	parent_type = /atom/movable
	icon = 'ai_trigger.dmi'
	#ifndef DEBUG
	invisibility = 101
	#endif
	var/mob/monster/belongs_to

	New(loc, mob/monster/m)
		belongs_to = m
		bound_width = belongs_to.aggro_dist*2
		bound_height = belongs_to.aggro_dist*2
		var/offset_x = (bound_width/2)*-1,offset_y=(bound_height/2)*-1
		src.pixloc = pixloc(loc, offset_x, offset_y)

	Crossed(mob/player/p)
		if(!p?.client) return
		if(p == belongs_to) return
		if(belongs_to.target) return
		else
			belongs_to.trigger(p)
			src.loc = null

	proc
		toggle()
			if(!loc && belongs_to)
				world.log << "/mob/monster/trigger : No belonging found. could not toggle proper pixloc"
				return
			var/offset_x = (bound_width/2)*-1,offset_y=(bound_height/2)*-1
			src.pixloc = pixloc(belongs_to, offset_x, offset_y)
		
		scale(factor)
			var/icon/i = src.icon
			i.Scale(factor, factor)
			icon = i
