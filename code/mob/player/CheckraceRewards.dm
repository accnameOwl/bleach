
//@CheckRace
//Called on GiveExperience()[src\StatSystem\stats.dm]
mob
	proc
		CheckRaceRewards()
			switch(race)
				if("Human" || "Soul")
					reward_check_human()
				if("Shinigami")
					reward_check_shinigami()
				if("Hollow")
					reward_check_hollow()
				if("Bounto")
					reward_check_bounto()
				if("Quincy")
					reward_check_quincy()
				if("Vaizard")
					reward_check_vaizard()

		reward_check_human()
		reward_check_shinigami()
			if(level >= LEVELREQ_SHIKAI && !has_shikai)
				has_shikai = 1
			if(level >= LEVELREQ_BANKAI && !has_bankai && shikai_mastery == 100)
				has_bankai = 1
			if(level >= LEVELREQ_SHINIGAMI_CAPTAIN)
				//check current captain
				var/datum/squad_db_type/db = get_squad(src.squad_division)
				if( db.cap != src.name || db.cap_level < src.level)
					make_squad_captain(src)
		reward_check_hollow()
		reward_check_bounto()
		reward_check_quincy()
		reward_check_vaizard()