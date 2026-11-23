mob/player/verb/Rest()
	if(in_combat)
		client.chat("log", Bold(Red("You cannot rest while in combat!")))
		return 0
	if(resting)
		resting = FALSE
		client.chat("log", Bold(White("You woke up from your rest.")))
		return 0

	resting = TRUE
	prevent_movement = TRUE

	src.icon_state = "rest"
	client.chat("log", Bold(White("You started to rest!")))

	var/next_tick = world.time
	while(resting)
		if(world.time > next_tick)
			client?.dirty_stat("fatigue")

			if(hp < max_hp)
				hp += round(max_hp/30)
			if(hp > max_hp)
				hp= max_hp

			if(mana < max_mana)
				mana += round(max_mana/30)
			if(mana > max_mana)
				mana = max_mana

			if(fatigue > 0)
				fatigue -= 5
			if(fatigue < 0)
				fatigue = 0

			if( (hp >= max_hp) && (mana >= max_mana) && (fatigue <= 0) )
				break

			next_tick = world.time + 10

		sleep(10/world.fps)

	src.icon_state = ""
	resting = FALSE
	prevent_movement = FALSE
	client.chat("log", Bold(White("You finished resting!")))