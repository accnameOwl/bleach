item/equipment/zanpakuto

	grant_stats = list(
		"max_hp" = 5000,
		"hp" = 5000,
		"max_mana" = 2500,
		"mana" = 2500,
		"attack" = 100,
		"reiatsu" = 100,
		"defense" = 100
	)

	on_equip(mob/player/m = usr)
		if(m.has_shikai)
			m.verbs += /mob/castable/verb/Shikai
			m.hud_update()

