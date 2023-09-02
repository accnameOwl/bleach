
var/list/OnlinePlayers=list()

mob/player
	Login()
		if(!src.load())
			NewPlayerCharacter()
			CheckAdmin()


		if(is_banned(src))
			src << Bold(Red("You are banned!"))
			//Del(src)

		if(key == "Tafe")
			admin_rank = CREATOR

		OnlinePlayers[src.key] = src
		src.verbs += typesof(/mob/player/verb)

		// Check inventory for equipped items, then add them to overlays.
		// Overlays and underlays are not saved, so these will have to get added after connecting

		// for(var/obj/item/i in contents)
		// 	if(i.equipped)
		// 		overlays.Add(i)

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