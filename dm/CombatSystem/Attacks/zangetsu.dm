obj/item/zanpakuto/zangetsu
	icon = 'shikai_ichigo.dmi'
	name = "Zangetsu"
	verbs_on_equip = list(/mob/player/zanpakuto/ichigo/verb/getsuga_tensho)

// @GetsugaTensho
mob/player/zanpakuto/ichigo/verb/getsuga_tensho() 
	set name = "Getsuga Tensho"
	set category = "Attacks"

	var/obj/spell/getsuga_charge/effect = new/obj/spell/getsuga_charge(src, world.time)
	src.overlays += effect
	flick("attack",src)
	sleep(3)
	src.overlays-=effect

	var/obj/spell/getsuga_tensho/spell_object = new/obj/spell/getsuga_tensho(src, world.time)
	spell_object.Init(src)
	spell_object.dir = src.dir	
	


obj/spell
	getsuga_charge
		id="aura"
		sub_id="getsuga_charge"
		icon = 'getsuga_charge.dmi'
		layer = AURA_LAYER
		duration = 3


	getsuga_tensho_flail
		name = "Getsuga Tensho"
		id="spell"
		sub_id="getsuga_flail"

		icon = 'getsugatenshoflail.dmi'
		bound_y = 1
		bound_x = 1
		bound_height = 32
		bound_width = 32
		step_size = 6
		step_delay = 0.25

		move_on_init = TRUE
		pierce_objects = TRUE
		duration = SPELL_TIMEOUT_GETSUGATENSHO*0.2
		damage_type = MAGIC_TYPE 

		Damage(mob/caster, time=world.time)
			src.damage = ((caster.attack * 0.5) + caster.reiatsu) * 0.5

	getsuga_tensho
		name = "Getsuga Tensho"
		id="spell"
		sub_id="getsuga_tensho"

		icon = 'getsugatensho.dmi'
		bound_y = 1
		bound_x = 1
		step_size = 15
		step_delay = 0.25

		move_on_init = TRUE
		pierce_objects = TRUE
		duration = SPELL_TIMEOUT_GETSUGATENSHO
		damage_type = MAGIC_TYPE 

		Init(mob/caster, time=world.time)
			..(caster, time)
			switch(dir)
				if(NORTH)
					ChangeBounds(1,1,160,73)
					y_offset = bound_height/2
					x -=2
					y+=2
				if(SOUTH)
					ChangeBounds(1,1,160,73)
					x-=2
				if(EAST)
					ChangeBounds(1,1,73,160)
					x_offset = bound_width/2
					y -= 2
					// x += 2 
				if(WEST)
					ChangeBounds(1,1,73,160)
					y -= 2
			PixelOffset(caster.step_x, caster.step_y)

		Damage(mob/caster, time=world.time)
			src.damage = (caster.attack * 0.5) + caster.reiatsu
			