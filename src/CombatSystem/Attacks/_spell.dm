/datum/spell
	parent_type = /atom/movable
	var/timeout_duration
	var/step_delay=0.25
	var/tmp/last_step = -1#INF
	var/tmp/next_step = -1#INF

/datum/spell/proc/Step(dir, delay=step_delay)
	if(next_step - world.time >= world.tick_lag/10)
		return 0
	if(step(src, dir))
		last_step = world.time
		next_step = last_step + step_delay
		return 1
	else
		return 0