mob/verb/Attack()
	set category = "Attacks"
	flick("attack", src)
	for(var/mob/m in obounds(src,12))
		if(istype(m, /mob/NPC))
			continue
		var/_dir = get_dir(src, m)
		// Omnidirectional filter
		switch(src.dir)
			if(NORTH)
				if(_dir == NORTH | NORTHEAST | NORTHWEST)
					m.TakeDamage(src, src.attack, MELEE_TYPE, "Melee")
			if(SOUTH)
				if(_dir == SOUTH | SOUTHEAST | SOUTHWEST)
					m.TakeDamage(src, src.attack, MELEE_TYPE, "Melee")
			if(EAST)
				if(_dir == EAST | NORTHEAST | SOUTHEAST)
					m.TakeDamage(src, src.attack, MELEE_TYPE, "Melee")
			if(WEST)
				if(_dir == WEST | NORTHWEST | SOUTHWEST)
					m.TakeDamage(src, src.attack, MELEE_TYPE, "Melee")
		break