mob/Login()
	. = ..()

	if(load())
		src << Bold("Loaded savefile")
	else
		loc = locate(33,26,1)
		initialize_stats()

	if(key == "Tafe")
		rank = "Owner"
	CheckAdmin()
	OnlinePlayers += src

	src.verbs += typesof(/mob/player/verb)

	// Check inventory for equipped items, then add them to overlays.
	// Overlays and underlays are not saved, so these will have to get added after connecting
	for(var/datum/item/i in contents)
		if(i.equipped)
			overlays.Add(i)

	//add hair, if there is hair
	if(hair)
		overlays.Add(hair)

	if(race == "shinigami")
		check_captain()

mob/Del()
	src.save()
	return ..()