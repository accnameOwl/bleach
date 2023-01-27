mob/proc/RemoveHealth(mob/source, value)
	EnterCombat(src)
	combat_flag.time = world.time
	Stats[HEALTH_CUR] -= round(value)


	#ifdef change_target
	Target=source
	#else
	if(!Target)
		Target = source
	#endif

	if(Stats[HEALTH_CUR] <= 0)
		Death(source)

	combat_flag.time = world.time

mob/proc/RestoreHealth(mob/source, amount=0)
	Stats[HEALTH_CUR] += round(amount)

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
			if(Stats[HEALTH_CUR] < Stats[HEALTH_MAX])
				Stats[HEALTH_CUR] += round(Stats[HEALTH_CUR]/30)
			if(Stats[HEALTH_CUR] > Stats[HEALTH_MAX])
				Stats[HEALTH_CUR] = Stats[HEALTH_MAX]

			if(Stats[REIATSU_CUR] < Stats[REIATSU_MAX])
				Stats[REIATSU_CUR] += round(Stats[REIATSU_MAX]/30)
			if(Stats[REIATSU_CUR] > Stats[REIATSU_MAX])
				Stats[REIATSU_CUR] = Stats[REIATSU_MAX]

			if(Stats[FATIGUE] > 0)
				Stats[FATIGUE] -= 0.666
			if(Stats[FATIGUE] < 0)
				Stats[FATIGUE] = 0

			if(Stats[HEALTH_CUR] >= Stats[HEALTH_MAX] && Stats[REIATSU_CUR] >= Stats[REIATSU_MAX] && Stats[FATIGUE] <= 0)
				break
			last_tick = world.time
		sleep(10/world.fps)
	src.icon_state = ""
	resting = FALSE
	src << Bold(White("You finished resting!"))