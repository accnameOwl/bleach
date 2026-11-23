

// @Urahara
mob/NPC/UraharaKisuke
	icon = 'npcs.dmi'
	icon_state = "urahara"
	json_id = "urahara"
	respawn_time = 1

	New()
		..()
		while(src)
			switch(dir)
				//Walk in a circle
				if(NORTH)
					walk_towards(src, locate(x+2,y,z),1,1)
				if(EAST)
					walk_towards(src, locate(x,y-2,z),1,1)
				if(SOUTH)
					walk_towards(src, locate(x-2,y,z),1,1)
				if(WEST)
					walk_towards(src, locate(x,y+2,z),1,1)
			sleep(rand(60,80))

	verb/Talk()
		set src in oview(2)
		var/_title = "Urahara Kisuke"

		switch(usr.race)
			if("Human")
				alert("Urahara Kisuke: Human text", _title)
			if("Shinigami")
				alert("Urahara Kisuke: Shinigami Text",_title)
			if("Vaizard")
			else
				alert("*Urahara Looks away...* -You do not feel welcome-", _title)


// @Urahara
mob/NPC/UraharaKisuke2
	icon = 'npcs.dmi'
	icon_state = "urahara"
	json_id = "urahara"
	respawn_time = 1

	verb/Talk()
		set src in oview(2)
		var/_title = "Urahara Kisuke"

		switch(usr.race)
			if("Shinigami")
				alert("Urahara Kisuke: Hurry, Enter the Senkaimon before it is too late!",_title)
			else
				alert("*Urahara Looks away...* -You do not feel welcome-", _title)
