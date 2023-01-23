/datum/spell
	parent_type = /atom/movable
	var/timeout_duration = 0
	var/step_delay=0.25
	var/tmp/last_step = -1#INF
	var/tmp/next_step = -1#INF
	var/move_on_init = FALSE

/datum/spell/proc/Initialize(_dir, _loc)
	ASSERT(_dir)
	ASSERT(_loc)
	loc = _loc
	dir=_dir
	spawn(timeout_duration) Del(src)
	if(move_on_init)
		while(src)
			Step(dir)
			sleep(10/world.fps)

/datum/spell/proc/Step(dir, delay=step_delay)
	if(next_step - world.time >= world.tick_lag/10)
		return 0
	if(step(src, dir))
		last_step = world.time
		next_step = last_step + step_delay
		return 1
	else
		return 0