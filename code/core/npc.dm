mob/NPC
	icon = 'npcs.dmi'


	New()
		..()
		get_vars_from_json(json_data_npc[json_id])

	proc/step_rand_loop()
		while(src && !is_dead)
			var/_locToWalk
			dir = pick( NORTH, SOUTH, EAST, WEST)
			switch(dir)
				if(NORTH)
					_locToWalk = locate(x,y+2,z)
				if(SOUTH)
					_locToWalk = locate(x,y-2,z)
				if(EAST)
					_locToWalk = locate(x+2,y,z)
				if(WEST)
					_locToWalk = locate(x-2,y,z)
			walk_towards(src, _locToWalk,2,1)
			sleep(rand(50,110))
