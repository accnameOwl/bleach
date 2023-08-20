world/Del()
	SAVE_SHINIGAMI_SQUAD()
	SAVE_HOLLOW_SQUAD()
	SAVE_QUINCY_SQUAD()
	..()
	
world/New()
	..()
	status="[world.name] (version [world.version]) <font color=red>(CLOSED TESTING)</font>"
	Initialize()
	var/err = LoadBanlist()
	if(err)
		world.log << "Could not read banlist."
	LOAD_SHINIGAMI_SQUAD()
	LOAD_HOLLOW_SQUAD()
	LOAD_QUINCY_SQUAD()
		