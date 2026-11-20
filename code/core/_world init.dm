

world
	New()
		..()
		config.load()

		////////////////////////////////////
		////// LOADING FROM SAVEFILES //////
		////////////////////////////////////
		var/loaded_squads = load_squads_list()
		if(!loaded_squads)
			// Initialize new list
			for(var/i = 1, i < 13, i++)
				var/datum/squad_db_type/new_db_type = new/datum/squad_db_type
				// set squad number equal to index
				new_db_type.squad = i
				squads_list.Add(new_db_type)
		var/log_message = ""
		log_message += "Loaded squads: [loaded_squads ? "OK" : "Error"]<br>"
		log_message += "Loaded bans: [load_banlist_from_sav() ? "OK" : "Error"]<br>"
		log_message += "Loaded leaderboard: [load_leaderboard_from_sav() ? "OK" : "Error"]<br>"
		log_message += "Loaded admins: [load_admins_from_sav() ? "OK" : "Error"]<br>"


		///////////////////////////////////////
		////// SET GLOBAL HTML TEMPLATES //////
		///////////////////////////////////////
		leaderboard_template = file2text("dependencies/html/templates/leaderboard.html")
		keybinds_template = file2text("dependencies/html/templates/keybinds.html")
		log_message += "leaderboard template: [length(leaderboard_template) ? "OK" : "Error"]<br>"
		log_message += "keybinds template: [length(keybinds_template) ? "OK" : "Error"]<br>"
		world.log << log_message

	Del()
		save_leaderboard_to_sav()
		save_admins_to_sav()
		save_banlist_to_sav()
		save_squads_list()

		#ifdef DEBUG
		text2file(log_level_exp_req, "log/level requirements.txt")
		#endif

		..()