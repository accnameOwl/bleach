/proc/check_spellcost(mob/m, cost)
	if(m.reiatsu.value >= cost)
		return 1
	else
		return 0

/proc/consume_reiatsu(mob/m, cost)
	if(cost < 0)
		cost = 0
	m.reiatsu -= cost


mob/player/proc/GiveExperience(value)
	exp += value
	total_exp += round(value)
	spawn CheckRaceRewards()
	while(exp.value >= exp.limit)

		//Increase level
		#ifdef SYS_LEVELING_BONUS
		++level
		health.limit(LEVELUP_HEALTH_BONUS) 
		reiatsu.limit(LEVELUP_REIATSU_BONUS) 
		attack += LEVELUP_ATTACK_BONUS
		reishi += LEVELUP_REISHI_BONUS
		hierro += LEVELUP_HIERRO_BONUS
		#endif
		
		// award statpoints?
		#ifdef SYS_LEVELING_POINTS 
		AwardStatPoint(6)
		#endif
		#ifdef SYS_LEVELING_POINTS_OVERRULE
		AwardStatPoint(SYS_LEVELING_AWARED_STAT_POINTS)
		#endif

		health.value = health.limit
		reiatsu.value = reiatsu.limit

		exp.value -= exp.limit
		exp.limit(exp.limit/20+1)

		#ifdef TEST_BUILD
		if(fexists("level requirements.txt"))
			fdel("level requirements.txt")
		text2file("[level]:\t[exp.limit]\t[total_exp]", "level requirements.txt")
		#endif
		if(exp.value < 0)
			exp.value = 0

		src << Bold(Gold("Leveled up to ") + Silver("[level]") + Gold("!"))
