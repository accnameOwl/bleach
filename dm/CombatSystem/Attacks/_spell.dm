/datum/spell
	parent_type = /atom/movable
	var/timeout_duration = 0 //Duration in ticks
	var/move_on_init = FALSE //move on initialize() flag
	var/damage = 0
	var/damage_type = null
	var/mob/caster = null
	
/datum/spell/proc/Initialize(_dir, _loc, x_offset = 0, y_offset = 0)
	loc = _loc
	dir =_dir
	step_x = x_offset
	step_y = y_offset

	spawn(timeout_duration) Del(src)
	
	if(move_on_init)
		spawn while(src)
			Step(dir)
			sleep(world.tick_lag/10)

/datum/spell/Step(dir, delay=step_delay)
	if(next_step - world.time >= world.tick_lag/10)
		return 0
	if(step(src, dir))
		last_step = world.time
		next_step = last_step + step_delay
		return 1
	else
		return 0

/datum/spell/Bump(atom/a)
	if(ismob(a))
		var/mob/hit = a
		#ifdef _TEST_
		ASSERT(caster)
		ASSERT(hit)
		world.log << "[caster] hit [hit] with [src.name]"
		#endif
		caster.DealDamage(hit, damage, damage_type, name)
	Del(src)

/datum/spell/proc/set_damage(value = 0, damage_type = null)
	src.damage = value
	src.damage_type = damage_type

/datum/spell/proc/set_caster(mob/m)
	#ifdef DEBUG
	ASSERT(m)
	#endif
	if(m)
		caster = m