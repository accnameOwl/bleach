/datum/item/zanpakuto/zangetsu
	icon = 'shikai_ichigo.dmi'

	Equip()
		if(..()) // was equippped
			src.verbs += typesof(/mob/player/zanpakuto/ichigo/verb)
		else // was removed
			src.verbs -= typesof(/mob/player/zanpakuto/ichigo/verb)

mob/player/zanpakuto/ichigo/verb
	getsuga_tensho() 
		//FIXME 
		/**
		runtime error: undefined variable /datum/item/zanpakuto/zangetsu/var/attack
		proc name: Getsuga Tensho (/mob/player/zanpakuto/ichigo/verb/getsuga_tensho)
			usr: Tafe (/mob/player)
			src: the zangetsu (/datum/item/zanpakuto/zangetsu)
			usr.loc: the tr (6,51,3) (/turf/earth/outside/dirt/tr)
			src.loc: Tafe (/mob/player)
		call stack:
		the zangetsu (/datum/item/zanpakuto/zangetsu): Getsuga Tensho()
		*/
		set name = "Getsuga Tensho"
		set category = "Attacks"

		var/datum/spell/getsuga_tensho/one/one = new()
		var/datum/spell/getsuga_tensho/center/center = new()
		var/datum/spell/getsuga_tensho/two/two = new()

		one.set_caster(src)
		center.set_caster(src)
		two.set_caster(src)

		var/damage = (0.4 * attack.value) + (1 * reishi.value)
		one.set_damage( damage, MAGIC_TYPE )
		center.set_damage( damage, MAGIC_TYPE )
		two.set_damage( damage, MAGIC_TYPE )
		
		center.Initialize(src.dir, locate(x,y,z), src.step_x, src.step_y)
		switch(dir)
			if(NORTH)
				one.Initialize(src.dir,locate(x+1,y,z), src.step_x, src.step_y)
				two.Initialize(src.dir, locate(x-1,y,z), src.step_x, src.step_y)
			if(SOUTH)
				one.Initialize(src.dir,locate(x-1,y,z), src.step_x, src.step_y)
				two.Initialize(src.dir, locate(x+1,y,z), src.step_x, src.step_y)
			if(EAST)
				one.Initialize(src.dir,locate(x,y-1,z), src.step_x, src.step_y)
				two.Initialize(src.dir, locate(x,y+1,z), src.step_x, src.step_y)
			if(WEST)
				one.Initialize(src.dir,locate(x,y+1,z), src.step_x, src.step_y)
				two.Initialize(src.dir, locate(x,y-1,z), src.step_x, src.step_y)

		

/datum/spell/getsuga_tensho
	timeout_duration = SPELL_TIMEOUT_GETSUGATENSHO
	move_on_init = TRUE
	name = "Getsuga Tensho"
	icon = 'zangetsu_getsuga.dmi'

/datum/spell/getsuga_tensho/one
	icon_state = "1"
/datum/spell/getsuga_tensho/center
	icon_state = ""
/datum/spell/getsuga_tensho/two
	icon_state = "2"
