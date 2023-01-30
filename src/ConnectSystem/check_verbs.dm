/proc/check_verbs(mob/m)
	if(m.race == "Shinigami")
		if(m.squad)
			m.verbs += typesof(/mob/squad/verb)
	
	if(m.in_guild)
		give_guild_verbs(src)