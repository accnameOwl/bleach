world/Del()
	// Do stuff
	..()
	
world/New()
	..()
	status="[world.name] (version [world.version]) <font color=red>(CLOSED TESTING)</font>"
	Initialize()
	var/err = LoadBanlist()
	if(err)
		world.log << "Could not read banlist."