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

