/proc/check_spellcost(mob/m, cost)
	if(m.Stats[REIATSU_CUR] >= cost)
		return 1
	else
		return 0

/proc/consume_reiatsu(mob/m, cost)
	if(cost < 0)
		cost = 0
	m.Stats[REIATSU_CUR] -= cost

mob/proc/IncreaseStatBy(var/datum/stat/s, value)
	// Increases a certain stat for a mob.
	// Indended for players only.
	if(s == null) return
	s += round(value)

mob/proc/GiveExperience(value)
	exp += value
	total_exp += value
	spawn CheckRaceRewards()
	while(exp >= exp_max)

		//Increase level
		++level
		IncreaseStatBy(health_max, LEVELUP_HEALTH_BONUS)
		IncreaseStatBy(reiatsu_max, LEVELUP_REIATSU_BONUS)
		IncreaseStatBy(attack, LEVELUP_ATTACK_BONUS)
		IncreaseStatBy(reishi, LEVELUP_REISHI_BONUS)
		IncreaseStatBy(hierro, LEVELUP_HIERRO_BONUS)

		health_cur.current = health_max.current
		reiatsu_cur.current = reiatsu_max.current

		exp.current -= exp_max.current
		IncreaseStatBy(exp_max, exp_max.current/20)

		#ifdef TEST_BUILD
		text2file("[level]     [exp_max.current]    [total_exp]", "level requirements.txt")
		#endif

		if(exp.current < 0)
			exp.current = 0

		src << Bold(Gold("Leveled up to ") + Silver("[level]") + Gold("!"))
