
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

mob/proc/CheckBountoRewards()

mob/proc/CheckQuincyRewards()

mob/proc/CheckVaizardRewards()