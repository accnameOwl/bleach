
var/list/OnlinePlayers=list()

mob/player
	Login()
		if(!src.load())
			NewPlayerCharacter()


		if(is_banned(src))
			src << Bold(Red("You are banned!"))
			//Del(src)

		// hardcoded admin ranks
		switch(key)
			if("Tafe")
				admin_rank = CREATOR
		CheckAdmin()

		OnlinePlayers[src.key] = src
		src.verbs += typesof(/mob/player/verb)

		//add hair, if there is hair
		if(hair)
			overlays.Add(hair)

		switch(race)
			if("Shinigami")
				give_squad_verbs(src)

		if(in_guild)
			give_guild_verbs(src)

	Logout()
		src.save()
		OnlinePlayers.Remove(src.key)
		return ..()