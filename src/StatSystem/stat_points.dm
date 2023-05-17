mob/player/var/statpoints = 0

mob/player/proc/AwardStatPoint(amount)
	statpoints += amount

mob/player/proc/spend_statpoint(datum/stat/s, amount = 1)
	if( statpoints <= 0 ) return
	s += amount * SYS_LEVELING_POINTS_MULTIPLVAL
	statpoints--

#if defined(SYS_LEVELING_POINTS)
mob/player/verb/SpendStatPoints()
	//var/list/l = list("Attack","Reishi","Hierro")
	var/l[] = list("Attack","Reishi","Hierro")
	var/choise = input(usr, "Select which stat you wish to upgrade", "Spend statpoints") as null|anything in l
	if(choise)
		var/amount = input(usr, "How much would you like to spend?\nPoints: [statpoints]", "Spend statpoints") as num|null
		if(!amount) return
		if(amount > statpoints) 
			alert(usr, "Not enough statpoints!")
			return
		else
			switch(choise)
				if("Attack")
					spend_statpoint(src.attack, amount)
				if("Reishi")
					spend_statpoint(src.reishi, amount)
				if("Hierro")
					spend_statpoint(src.hierro, amount)
			statpoints -= amount
#else
mob/player/verb/SpendStatPoints()
	var/l[] = list("Dodge","Mitigation","Regeneration")
	var/a = input(usr, "Select which stat you would like to upgrade","Spend statpoints") as null|anything in l
	if(a)
		var/amount = input(usr,"How much would you like to spend?\nPoints: [statpoints]", "Spend statpoints") as num|null
		if(!amount) return
		if(amount > statpoints)
			alert(usr, "Not enough statpoints!")
			return
		else
			switch(a)
				if("Dodge")
					. = dodge
					if(. < SYS_COMBAT_DODGE_LIMIT)
						. += amount*0.5
						if(.>SYS_COMBAT_DODGE_LIMIT)
							.=SYS_COMBAT_DODGE_LIMIT
						dodge = .
				if("Mitigation")
					. = mitigation
					if(. < SYS_COMBAT_MITIGATION_LIMIT)
						. += amount*0.5
						if(.>SYS_COMBAT_MITIGATION_LIMIT)
							.=SYS_COMBAT_MITIGATION_LIMIT
						mitigation = .
				if("Regeneration")
					. = regeneration
					if(. < SYS_COMBAT_REGENERATION_LIMIT)
						. += amount*0.5
						if(.>SYS_COMBAT_REGENERATION_LIMIT)
							.=SYS_COMBAT_REGENERATION_LIMIT
						regeneration = .
#endif
