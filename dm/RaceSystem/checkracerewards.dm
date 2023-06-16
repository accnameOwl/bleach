
//@CheckRace
//Called on GiveExperience()[src\StatSystem\stats.dm]
mob/proc/CheckRaceRewards()
	switch(race)
		if("Human" || "Soul")
			CheckHumanRewards()
		if("Shinigami")
			CheckShinigamiRewards()
		if("Hollow")
			CheckHollowRewards()
		if("Bounto")
			CheckBountoRewards()
		if("Quincy")
			CheckQuincyRewards()
		if("Vaizard")
			CheckVaizardRewards()

mob/proc/CheckHumanRewards()

mob/proc/CheckHollowRewards()

mob/proc/CheckShinigamiRewards()
	if(level >= LEVELREQ_SHIKAI && !hasShikai)
		GiveShikai()
	if(level >= LEVELREQ_BANKAI && !hasBankai && shikaiMastery == 100)
		GiveBankai()
	if(level >= LEVELREQ_SHINIGAMI_CAPTAIN)
		//check current captain
		var/datum/squad_db_type/db = get_squad(src.squad_division)
		if( db.cap != src.name || db.cap_level < src.level)
			make_squad_captain(src)

mob/proc/CheckBountoRewards()

mob/proc/CheckQuincyRewards()

mob/proc/CheckVaizardRewards()