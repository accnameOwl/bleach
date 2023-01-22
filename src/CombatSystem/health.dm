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

