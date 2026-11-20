client
	var
		static/alist/keybind_blacklist = alist(
			"F1",
			"F2",
			"Home",
			"End",
			"Return",
			"backspace"
		)

		alist/keybinds = alist(
			"movement" = alist(
				"W"=NORTH,
				"A"=WEST,
				"S"=SOUTH,
				"D"=EAST,
				"North"=NORTH,
				"West"=WEST,
				"South"=SOUTH,
				"East"=EAST,
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
		find_local_keybinds()
			return fexists("config/keybinds.json")

		save_keybinds()
			text2file(json_encode(keybinds), "config/keybinds.json")

		load_keybinds()
			var/list/loaded_binds
			loaded_binds = json_decode(file2text("config/keybinds.json"))
			if(length(loaded_binds))
				keybinds = loaded_binds

	proc
		get_keybind_from_key(key)
			if(key in keybind_blacklist)
				return
			for(var/cat in keybinds)
				// ignore movement
				if(cat == "movement")
					continue
				else
					var/callback = keybinds[cat]?[key]
					if(callback)
						debug.info("get_keybind_from_key() -> key:[key]; callback:[callback];")
						return callback

		set_keybind(category, key, callback)
			if(!category || !key || !callback)
				return debug.error("set_new_keybind(): Could not properly get all arguments: args = [list2params(args)]")

			var/alist/cat = keybinds && keybinds[category]
			// if category doesn't exist, create it.
			if(!cat)
				keybinds[cat] = alist()
			// set key to callback
			keybinds[cat][key] = callback
			debug.info("set_keybind() -> (keybinds\[[category]\].\[[key]\]=[callback];)")
			return 1

		call_keyboard_input(key)
			var/callback = get_keybind_from_key(key)
			if(!callback) return
			call(src.mob, callback)()

	verb
		KeyStatus(key as text, state as num)
			set hidden = 1
			//movement direction
			var/input_dir = keybinds["movement"]?[key]
			if(input_dir)
				if(state)
					move_dir |= input_dir
					move_vector = dir2vec(move_dir)
				else
					move_dir &= ~input_dir
					move_vector = dir2vec(move_dir)
			// anything else
			else
				if(state)
					call_keyboard_input(key)
			//	else
			//		var/alist/__movement_keys = keybinds["movement"]


/*

			vector/velocity = new/vector(0,0)
			var/vector/desired_velocity

			if(Dir)
				// Dir = Dir * Dist
				var/vector/direction = Dir.Normalize()
				desired_velocity = direction * Dist
			else
				desired_velocity = new /vector(0,0)

			var/vector/delta = desired_velocity - velocity
			var/vector/delta_size = delta.size
			if(delta_size)
				var/amount = acceleration
				if(!Dir)
					amount = deceleration

			if(delta_size <= amount)
				velocity = desired_velocity
			else
				velocity += delta.Normalize() * amount

			if(!velocity.size)
				mob.next_step = world.time + mob.Delay
*/