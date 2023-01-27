/proc/check_spellcost(mob/m, cost)
	if(m.Stats[REIATSU_CUR] >= cost)
		return 1
	else
		return 0

/proc/consume_reiatsu(mob/m, cost)
	if(cost < 0)
		cost = 0
	m.Stats[REIATSU_CUR] -= cost
