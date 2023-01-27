/proc/check_spellcost(mob/source, cost)
	if(source.Stats[REIATSU_CUR] >= cost)
		return 1
	else
		return 0