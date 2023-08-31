mob/spell/verb
	shunpo(turf/loc)
		var/ready = spell_cd && spell_cd["shunpo"]
		if(!ready) return 0
		src.loc = loc
		var/shunpo = src.spell_mastery["shunpo"]
		if(!shunpo)
			shunpo = 1
		spell_cd["shunpo"] = SPELL_COOLDOWN_SHUNPO-src.spell_mastery["shunpo"]
		if(shunpo <= 80)

