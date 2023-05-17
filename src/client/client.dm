client/Stat()
	usr = mob
	stat("Name: ","[usr.name]")
	stat("Race: ", usr.race)
	if(usr.race == "Shinigami")
		stat("Division: Squad [usr.squad_division]")
	stat("__________")
	stat("Level: ",usr.level)
	stat("Exp: ", "[usr:exp.value] / [usr:exp.limit]")
	stat("")
	stat("Health: ", "[usr.health.value] / [usr.health.limit]")
	stat("Reiatsu: ", "[usr.reiatsu.value] / [usr.reiatsu.limit]")
	stat("")
	stat("Attack: ", usr.attack.value)
	stat("Reishi: ", usr.reishi.value)
	stat("Hierro: ", usr.hierro.value)
	stat("")
	stat("Fatigue: ", round(usr:fatigue))
	
	#if defined(SYS_LEVELING_CLIENT_STATPANEL_SHOW_NEW)
	stat("")
	stat("Extra:")
	stat("Dodge: ", "[round(usr:dodge)]%")
	stat("Mitigation: ", "[round(usr:mitigation)]%")
	stat("Regeneration: ", "[round(usr:regeneration)]%")

	#endif
	
	#if defined(SYS_LEVELING_POINTS)
	stat("")
	stat("Stat points: ", usr:statpoints)
	#elif defined(SYS_LEVELING_POINTS_OVERRULE)
	stat("")
	stat("Stat points: ", usr:statpoints)
	#endif
	
	statpanel("Inventory", usr.contents)

client/New()
	if((.=..()))
		spawn move_loop()