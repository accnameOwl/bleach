mob/player/verb/OOC()
	var/msg = input(usr, "Say something OOC", "OOC") as text
	if(!msg) return 0
	if(afk_check_running)
		var/found_in_list = afk_check_cleared.Find(src.ckey)
		if(!found_in_list)
			afk_check_cleared.Add(src.ckey)
			src << Bold(Red("AFK check submitted"))
			return 
	var/pretext = "([src.race])[src.name] OOC: "
	if(racerank)
		splicetext(pretext, 1,0, "([racerank])")
	if(admin)
		splicetext(pretext, 1,0, "(GM)")
	if(guild != null)
		splicetext(pretext, 1,0, "([guild.name])")
	
	msg = Bold(Red(pretext) + White(msg))

	for(var/mob/m in OnlinePlayers)
		m << msg