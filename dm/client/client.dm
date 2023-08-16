client/Stat()
	var/mob/player/player = mob
	stat("Name: ","[player.name]")
	stat("Race: ", player.race)
	if(player.race == "Shinigami")
		stat("Division: Squad [player.squad_division]")
	stat("__________")
	stat("Level: ",player.level)
	stat("Exp: ", "[player.exp] / [player.req_exp]")
	stat("")
	stat("Health: ", "[player.health] / [player.max_health]")
	stat("Reiatsu: ", "[player.reiatsu] / [player.max_reiatsu]")
	stat("")
	stat("Attack: ", player.attack)
	stat("Reishi: ", player.reishi)
	stat("Hierro: ", player.hierro)
	stat("")
	stat("Fatigue: ", round(player.fatigue))
	
	#if defined(SYS_LEVELING_CLIENT_STATPANEL_SHOW_NEW)
	stat("")
	stat("Extra:")
	stat("Dodge: ", "[round(player.dodge)]%")
	stat("Mitigation: ", "[round(player.mitigation)]%")
	stat("Regeneration: ", "[round(player.regeneration)]%")

	#endif
	
	statpanel("Inventory", player.contents)

client/New()
	if((.=..()))
		spawn move_loop()