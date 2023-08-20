/proc/check_spellcost(mob/m, cost)
	if(m.reiatsu >= cost)
		return 1
	else
		return 0

/proc/consume_reiatsu(mob/m, cost)
	if(cost < 0)
		cost = 0
	m.reiatsu -= cost


mob/player/proc
	CheckSpellCost(cost)
		return src.reiatsu >= cost

	ConsumeReiats(cost)
		if(cost < 0)
			cost = 0
		src.reiatsu -= cost

	GiveExperience(value)
		exp += value
		total_exp += round(value)
		spawn CheckRaceRewards()
		while(exp >= req_exp)

			//Increase level
			#ifdef SYS_LEVELING_BONUS
			++level
			health += LEVELUP_HEALTH_BONUS 
			reiatsu += LEVELUP_REIATSU_BONUS 
			attack += LEVELUP_ATTACK_BONUS
			reishi += LEVELUP_REISHI_BONUS
			hierro += LEVELUP_HIERRO_BONUS
			max_health += LEVELUP_HEALTH_BONUS 
			max_reiatsu += LEVELUP_REIATSU_BONUS 
			#endif

			exp -= req_exp

			#ifdef TEST_BUILD
			if(fexists("level requirements.txt"))
				fdel("level requirements.txt")
			text2file("[level]:\t[req_exp]\t[total_exp]", "level requirements.txt")
			#endif
			
			if(exp < 0)
				exp = 0
			req_exp += round(req_exp/20) ? round(req_exp/20) : 1 // if 0, then 1 instead

			src << Bold(Gold("Leveled up to ") + Silver("[level]") + Gold("!"))
