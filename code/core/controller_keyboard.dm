controller/keyboard

	var
		static/alist/invalid_keys = alist(
			"F1",
			"F2",
			"Home",
			"End",
			"Return",
			"Backspace"
		)

		alist/keybinds = alist(
			"movement" = alist(
				"W"=NORTH,
				"A"=WEST,
				"S"=SOUTH,
				"D"=EAST,
				"North"=NORTH,
				"West"=WEST,
				"East"=EAST,
				"South"=SOUTH
			),
			"actionbar" = alist(
				"1" = "Bala",
				"2" = "Getsuga Tensho",
				"3" = "Getsuga Tensho Black",
				"4" = "Nake",
				"5" = "",
				"q" = "",
				"e" = "",
				"r" = "",
			),
			"interaction" = alist(
				"F" = "Interact",
			),
			"client"=alist(
				"L" = "ShowLeaderboardWindow",
			),
			"communication"=alist(),
			"combat"=alist(),
		)

	proc

		find_local_keybinds(client/c)
			return fexists("config/keybinds/[c.ckey]_keybinds.json")
		
		save(client/c)
			text2file(json_encode(keybinds), "config/[c.key]/keybinds.json") // <- This doesn't support 
		
		load(client/c)
			var/alist/loaded_binds = json_decode(file2text("config/[c.key]/keybinds.json"))
			if(length(loaded_binds))
				keybinds = loaded_binds
			
		// returns a callback-value as string, specified on [key]
		key_callback(key)
			var/callback
			for(var/category in (keybinds - alist("movement")))
				callback = keybindS[category]?[key]
				if(callback)
					return callback
		
		set_keybind(category, key, callback)
			if(!category || !key || !callback)
				return
			
			if(!keybinds[category])
				keybinds[cat] = alist()

			keybinds += alist(category=alist(key=callback))
		
|		is_movement_key(key)
			return (key in keybinds["movement"])

	
	var

		list/active_keys = list()		// actively held keys are in this list
										// added on press, removed on release

	proc
		// params:
		//		key: Key pressed
		//		state: 1 pressed, 0 released
		key_action(client/c, key="", state=0)
			if(is_movement_key(key)) 
			
				var/input_dir = keybinds["movement"][key])
				if(input_dir)
					if(state)
						c.move_dir |= input_dir
						c.move_vector = dir2vec(c.move_dir)
					else
						c.move_dir &= ~input_dir
						c.move_vector &= ~input_dir
			else
				if(state)
					active_keys += key
					call_keyboard_input(c, key)
				else
					active_keys -= key