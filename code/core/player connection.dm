world
	// We want to prevent defult behavior from client/New()'s way of handling mobs
	// instead we want to handle it manually.
	//mob = /mob/player
	mob = 0

client
	authenticate = 1
	New()
		..()

		var/mob/player/new_mob = new()
		if(fexists("saves/[copytext(src.ckey,1,2)]/[src.ckey].sav"))
			// contradictory issues
			// Can't load from savefile, cause key isn't set
			// can't assign mob to client, cause it causes Login() before loading.
			new_mob.load(src.ckey)
			new_mob.name = src.key
			src.mob = new_mob
			chat("log", Bold(Red("Loaded!")))

			//if(find_local_keybinds())
			//	load_keybinds()
		else
			new_mob.init_new_character()
			src.mob = new_mob
			mob.name = input(src, "What would you like to name your Character?", "Name Character")
			dirty_stat("name")

var/const/NO_SAVE = 1

mob
	player
		Login()

			if(copytext(key, 1,7) == "Guest-") 				// deny guest-login
				alert(src, "You need to be logged in on the BYOND pager to play the game.", "Not logged in")
				Logout(NO_SAVE) // no-save

			if(is_banned(src.ckey))
				src << Bold(Red("You are banned!"))
				del client

			global.online_players += src
			Tickers += src
			hud_update()
			//HTML_BrowseLogin()


			if(!admin && (src.ckey in admin_list))
				admin = admin_list[src.ckey]

			if(admin)
				client.chat("world", "<font color=red>(GM)[src.name] has logged on!</font>")
				#ifdef DEBUG
				winset(usr, null, "browser-options=devtools,find")
				#endif DEBUG
			else
				client.chat("world", "<font color=red>[src.name] has logged on!</font>")

			src.get_verbs()
			client.init_chat()

		Logout(no_save = 0)
			online_players -= src
			Tickers -= src
			if(!no_save)
				src.save()
				client?.save_keybinds()
			..()

		proc
			init_new_character()
				make_human()
				loc = locate(NEW_PLAYER_LOC)
				get_vars_from_json(json_data_player["new-player"])

			get_verbs()
				if(admin)
					switch(admin)

						if("host")
							verbs += typesof(/mob/host/verb)

						if("admin")
							verbs += typesof(/mob/host/verb)
							verbs += typesof(/mob/admin/verb)

						if("developer")
							verbs += typesof(/mob/host/verb)
							verbs += typesof(/mob/admin/verb)
							verbs += typesof(/mob/developer/verb)
							verbs += typesof(/mob/castable/verb)
				/*
				switch(race)
					if("Shinigami")
						/* KIDO */
					if("Quincy")
						//give quincy related verbs
					if("Hollow")
						// give hollow related verbs
					if("Arrancar")
						//give arrancar related verbs
					if("Espada")
						//give espada related verbs
				*/