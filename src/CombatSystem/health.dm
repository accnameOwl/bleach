mob/proc/RemoveHealth(mob/source, value)
	EnterCombat(src)
	combat_flag.time = world.time
	health_cur -= round(value)


	#ifdef change_target
	Target=source
	#else
	if(!Target)
		Target = source
	#endif

	if(health_cur <= 0)
		Death(source)

	combat_flag.time = world.time

mob/proc/RestoreHealth(mob/source, amount=0)
	health_cur += round(amount)

//Resting ??
mob/var/resting = FALSE

mob/player/verb/Rest()
	var/last_tick = 0
	if(combat_flag.in_combat)
		src << Bold(Red("You cannot rest while in combat!"))
		return 0
	if(resting)
		src << Bold(White("You are already Resting..."))
		return 0
	resting = TRUE
	src.icon_state = "rest"
	src << Bold(White("You started to rest!"))
	while(resting)
		if(world.time > last_tick+5)
			if(health_cur < health_max)
				health_cur += round(health_cur/30)
			if(health_cur > health_max)
				health_cur = health_max

			if(reiatsu_cur < reiatsu_max)
				reiatsu_cur += round(reiatsu_max/30)
			if(reiatsu_cur > reiatsu_max)
				reiatsu_cur = reiatsu_max

			if(fatigue > 0)
				fatigue -= 0.666
			if(fatigue < 0)
				fatigue = 0

			if(health_cur >= health_max && reiatsu_cur >= reiatsu_max && fatigue <= 0)
				break
			last_tick = world.time
		sleep(10/world.fps)
	src.icon_state = ""
	resting = FALSE
	src << Bold(White("You finished resting!"))