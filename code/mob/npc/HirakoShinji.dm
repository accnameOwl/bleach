

// @Urahara
mob/NPC/HirakoShinji
	icon = 'npcs.dmi'
	icon_state = "shinji"
	json_id = "shinji"
	respawn_time = 1


	verb/Talk()
		set src in oview(2)
		var/_title = "Hirako Shinji"

		switch(usr.race)
			if("Human")
				alert("[name]: Human text", _title)
			if("Shinigami")
				alert("[name]: Shinigami Text",_title)

				//TODO:
				// We need to add conditions to how or when someone can become a vaizard.
				// There also needs to be a test.
			if("Hollow")
				alert("[name]: Get lost, Hollow... *Unsheathes sword*", _title)

			else
				alert("*[name] Looks away...* -You do not feel welcome-", _title)
