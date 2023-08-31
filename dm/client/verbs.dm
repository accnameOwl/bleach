mob/player/verb/OOC()
	var/msg = input(usr, "Say something OOC", "OOC") as text
	if(!msg) return 0
	if(afk_check_running)
		var/found_in_list = afk_check_cleared.Find(src.ckey)
		if(!found_in_list)
			afk_check_cleared.Add(src.ckey)
			src << Bold(Red("AFK check submitted"))
			return 
	msg = Red("([src.race])[src.name] OOC: ") +  White(msg)
	
	var/pretext = ""
	if(guild_name)
		pretext += "[guild_name] "
	if(admin)
		pretext += "(GM)"
	if(racerank)
		pretext += "([racerank])"
	
	msg = Bold(Red(pretext) + msg)

	for(var/mob/m in OnlinePlayers)
		m << msg

mob/player/verb/Check_Ranks()
	for(var/i = 1, i < squads_list.len, i++)
		var/datum/squad_db_type/squad = get_squad(i)
		if(!squad) continue
		src << Yellow(Bold("Squad: [squad.squad]"))
		src << Small("\tCaptain: [squad.cap] [squad.cap_level]")
		src << Small("\tLeutenant:[squad.leut] [squad.leut_level]")

mob/player/verb/Rest()
	var/last_tick = 0
	if(combat_flag.in_combat)
		src << Bold(Red("You cannot rest while in combat!"))
		return 0
	if(resting)
		src << Bold(White("You are already Resting..."))
		return 0
	resting = TRUE
	src.icon_state = "rest"
	src << Bold(White("You started to rest!"))
	while(resting)
		if(world.time > last_tick+5)
			if(health < max_health)
				health += round(max_health/30)
			if(health > max_health)
				health = max_health

			if(reiatsu < max_reiatsu)
				reiatsu += round(max_reiatsu/30)
			if(reiatsu > max_reiatsu)
				reiatsu = max_reiatsu

			if(fatigue > 0)
				fatigue -= 0.666
			if(fatigue < 0)
				fatigue = 0

			if(health >= max_health && reiatsu >= max_reiatsu && fatigue <= 0)
				break
			last_tick = world.time
		sleep(10/world.fps)
	src.icon_state = ""
	resting = FALSE
	src << Bold(White("You finished resting!"))
