

config
	server
		var
			status = ""
		New()
	reboot
		var
			enabled = FALSE
			interval = HOUR(3)
			warning_time = MINUTE(5)
			save_before_reboot = TRUE
			reconnect_players = TRUE
		New()

	logging
		var
			enabled = TRUE
			chat = TRUE
			admins = TRUE
			combat = FALSE
			debug = FALSE
		New()

	admin
		var
			allow_admin_dm = TRUE
			announce_admin_login = TRUE
			developer_mode = FALSE
		New()

	discord
		var
			enabled = FALSE
			webhook = ""
			announce_restarts = TRUE
		New()

	events
		var
			random_events = TRUE
			event_interval = MINUTE(30)
			holiday_events = FALSE
		New()

	var
		config/server/server
		config/reboot/reboot
		config/logging/logging
		config/admin/admin
		config/discord/discord
		config/events/events

	New()
		server = new
		reboot = new
		logging = new
		admin 	= new
		discord = new
		events = new


	proc

		load()
			set background = 1
			var/list/data = json_decode(file2text("dependencies/json/config.json"))
			for(var/subtype in data)
				for(var/key in data[subtype])
					vars[subtype].vars[key] = data[subtype][key]
			world.log << "<br>Loaded world config: \"./dependencies/json/config.json\"</font>"

		save()
			//TODO: Inversive load functionality to json file.
			// Overwrite prev. file.

		server() return server
		reboot() return reboot
		logging() return logging
		admin() return admin
		discord() return discord
		events() return events

var/config/config = new