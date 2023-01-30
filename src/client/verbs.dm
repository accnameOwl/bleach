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