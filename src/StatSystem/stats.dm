mob
	var/list/Stats
	var/tmp/last_time_trained = 0
	var/level = 1
	var/total_exp = 0

mob/proc/initialize_stats()
	// Initializes mob.Stats with proper size and name-convention.
	// Used to store values related to combat for all mobs.
	//
	// New stats can be initialized for special cases.
	Stats = list(\
		""				= 0,
		HEALTH_MAX		= 10,
		HEALTH_CUR 		= 10,
		REIATSU_MAX 	= 10,
		REIATSU_CUR 	= 10,
		ATTACK			= 1,
		CRIT			= 1,
		REISHI			= 1,
		HIERRO			= 1,
		EXP_MAX			= 100,
		EXP_CUR			= 1,
		FATIGUE			= 1)

mob/proc/IncreaseStatBy(stat, value)
	// Increases a certain stat for a mob.
	// Indended for players only.
	if(!Stats[stat] || !EXP_CUR)
		return
	Stats[stat] += round(value)

mob/proc/GiveExperience(value)
	Stats[EXP_CUR] += value
	total_exp += value
	spawn CheckRaceRewards()
	while(Stats[EXP_CUR] >= Stats[EXP_MAX])

		//Increase level
		++level
		IncreaseStatBy(HEALTH_MAX, LEVELUP_HEALTH_BONUS)
		IncreaseStatBy(REIATSU_MAX, LEVELUP_REIATSU_BONUS)
		IncreaseStatBy(ATTACK, LEVELUP_ATTACK_BONUS)
		IncreaseStatBy(REISHI, LEVELUP_REISHI_BONUS)
		IncreaseStatBy(HIERRO, LEVELUP_HIERRO_BONUS)

		Stats[HEALTH_CUR] = Stats[HEALTH_MAX]
		Stats[REIATSU_CUR] = Stats[REIATSU_MAX]

		Stats[EXP_CUR] -= Stats[EXP_MAX]
		IncreaseStatBy(EXP_MAX, Stats[EXP_MAX]/20)

		#ifdef TEST_BUILD
		text2file("[level]     [Stats[EXP_MAX]]    [total_exp]", "level requirements.txt")
		#endif

		if(Stats[EXP_CUR] < 0)
			Stats[EXP_CUR] = 0

		src << Bold(Gold("Leveled up to ") + Silver("[level]") + Gold("!"))

