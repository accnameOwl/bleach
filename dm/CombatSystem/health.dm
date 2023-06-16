mob/proc/RemoveHealth(mob/source, value)
	EnterCombat(src)
	combat_flag.time = world.time
	health -= round(value)


	#ifdef change_target
	Target=source
	#else
	if(!Target)
		Target = source
	#endif

	if(health <= 0)
		Death(source)

	combat_flag.time = world.time

mob/proc/RestoreHealth(mob/source, amount=0)
	health += round(amount)

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
			if(health.value < health.limit)
				health.value += round(health.value/30)
			if(health.value > health.limit)
				health.value = health.limit

			if(reiatsu.value < reiatsu.limit)
				reiatsu.value += round(reiatsu.limit/30)
			if(reiatsu.value > reiatsu.limit)
				reiatsu.value = reiatsu.limit

			if(fatigue > 0)
				fatigue -= 0.666
			if(fatigue < 0)
				fatigue = 0

			if(health >= health.limit && reiatsu >= reiatsu.limit && fatigue <= 0)
				break
			last_tick = world.time
		sleep(10/world.fps)
	src.icon_state = ""
	resting = FALSE
	src << Bold(White("You finished resting!"))