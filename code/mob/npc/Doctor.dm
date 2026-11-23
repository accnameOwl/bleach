mob/NPC/Doctor
	icon = 'npcs.dmi'
	icon_state="doctor"
	json_id = "doctor"
	respawn_time = 1


	verb/Talk()
		set src in oview(2)

		if(!usr) return



		if(usr:hp >= usr:max_hp)
			alert(usr, "Sir, your vitals seems to be in order. Maybe come back another time when you require our services.", src.name, "Ok!")
			return

		switch(alert(usr, "Would you like me to heal your injuries?", src.name, "Yes, please!", "No, thank you."))
			if("Yes, please!")
				usr:hp = usr:max_hp
			else
				return


mob/NPC/Doctor_nointeraction
	icon = 'npcs.dmi'
	icon_state="rantao"
	json_id = "doctor"
	respawn_time = 1


	New()
		..()
		Tickers += src
		icon_state = pick("doctor","rantao")


	var/next_step_occurance = -1#INF

	Tick()
		if(!src.loc) return
		if(next_step_occurance > world.time) return
		next_step_occurance = world.time + rand(60,150)
		var/vector/rand_dir = vector(src.x + rand(-1,1), src.y + rand(-1,1))
		walk_towards(src, locate(rand_dir.x, rand_dir.y, src.z), 0, 2)

