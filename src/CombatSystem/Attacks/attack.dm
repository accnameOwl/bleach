mob
	verb
		Attack()
			flick("attack", src)
			for(var/mob/m in obounds(src,12))
				if(istype(m, /mob/NPC))
					continue
				var/_dir = get_dir(src, m)
				// Omnidirectional filter
				switch(usr.dir)
					if(NORTH)
						if(_dir == NORTH | NORTHEAST | NORTHWEST)
							DealDamage(m, src.attack)
					if(SOUTH)
						if(_dir == SOUTH | SOUTHEAST | SOUTHWEST)
							DealDamage(m, src.attack)
					if(EAST)
						if(_dir == EAST | NORTHEAST | SOUTHEAST)
							DealDamage(m, src.attack)
					if(WEST)
						if(_dir == WEST | NORTHWEST | SOUTHWEST)
							DealDamage(m, src.attack)