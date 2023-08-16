
obj/spell
	bala
		name = "Bala"
		icon = 'cero.dmi'
		icon_state = "bala"
		duration = SPELL_TIMEOUT_BALA
		step_size = 8
		move_on_init = TRUE
		density = 1
		damage_type = DARKMAGIC_TYPE

	cero
		name = "Cero"
		icon = 'cero.dmi'
		icon_state = "cero"
		duration = SPELL_TIMEOUT_CERO
		step_size = SPELL_CERO_STEP_SIZE
		move_on_init = TRUE
		density = 1
		damage_type = DARKMAGIC_TYPE
		
		Step(dir,delay=step_delay)
			//store prev x and y loc
			var/prev_x = x
			var/prev_y = y
			//make sure it exists
			//run ..Step()
			. = ..(dir, delay)
			if(.)
				//if moved one tile
				if(prev_x != x || prev_y != y)
					var/obj/spell/cero_trail/left/trail = new/obj/spell/cero_trail(null, src.dir, src.loc, src.step_x, src.step_y)


	cero_trail
		icon = 'cero.dmi'
		icon_state = "cero_trail"
		duration = SPELL_TIMEOUT_CERO/6

		
//Gran rey cero
	granreycero
		name = "Gran Rey Cero"
		step_size = SPELL_GRC_STEP_SIZE
		icon = 'cero.dmi'
		duration = SPELL_TIMEOUT_GRANREYCERO 
		density = 1
		damage_type = DARKMAGIC_TYPE

	granreycero_trail
		step_size = SPELL_GRC_STEP_SIZE
		icon = 'cero.dmi'
		duration = SPELL_TIMEOUT_GRANREYCERO/5

	granreycero/left
		icon_state = "grc_left"
		move_on_init = TRUE

		Step(dir,delay=step_delay)
			var/prev_x = x
			var/prev_y = y
			. = ..(dir, delay)
			if(.)
				//if moved one tile
				if(prev_x != x || prev_y != y)
					var/obj/spell/granreycero_trail/left/trail = new/obj/spell/granreycero_trail/left(null, src.dir, src.loc, src.step_x, src.step_y)
					switch(dir)
						if(NORTH)
							trail.step_y = src.step_y-(TILE_HEIGHT/4)
						if(SOUTH)
							trail.step_y = src.step_y+(TILE_HEIGHT/4)
						if(EAST)
							trail.step_x = src.step_x-(TILE_WIDTH/4)
						if(WEST)
							trail.step_x = src.step_x+(TILE_WIDTH/4)

		granreycero/center
			icon_state = "grc_center"
			move_on_init = TRUE

			Step(dir,delay=step_delay)
				var/prev_x = x
				var/prev_y = y
				//run ..Step()
				. = ..(dir, delay)
				if(.)
					//if moved one tile
					if(prev_x != x || prev_y != y)
					var/obj/spell/granreycero_trail/center/trail = new/obj/spell/granreycero_trail/center(null, src.dir, src.loc, src.step_x, src.step_y)
					switch(dir)
						if(NORTH)
							trail.step_y = src.step_y-(TILE_HEIGHT/4)
						if(SOUTH)
							trail.step_y = src.step_y+(TILE_HEIGHT/4)
						if(EAST)
							trail.step_x = src.step_x-(TILE_WIDTH/4)
						if(WEST)
							trail.step_x = src.step_x+(TILE_WIDTH/4)

	granreycero/right
		icon_state = "grc_right"
		move_on_init = TRUE

		Step(dir,delay=step_delay)
			var/prev_x = x
			var/prev_y = y
			//run ..Step()
			. = ..(dir, delay)
			if(.)
				//if moved one tile
				if(prev_x != x || prev_y != y)
					var/obj/spell/granreycero_trail/right/trail = new/obj/spell/granreycero_trail/right(null, src.dir, src.loc, src.step_x, src.step_y)
					switch(dir)
						if(NORTH)
							trail.step_y = src.step_y-(TILE_HEIGHT/4)
						if(SOUTH)
							trail.step_y = src.step_y+(TILE_HEIGHT/4)
						if(EAST)
							trail.step_x = src.step_x-(TILE_WIDTH/4)
						if(WEST)
							trail.step_x = src.step_x+(TILE_WIDTH/4)


	//Gran rey cero traail
	granreycero_trail/left
		icon_state = "grc_trail_left"
	granreycero_trail/center
		icon_state = "grc_trail_center"
	granreycero_trail/right
		icon_state = "grc_trail_right"