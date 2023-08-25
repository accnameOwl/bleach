obj/item/zanpakuto/zangetsu
	icon = 'shikai_ichigo.dmi'
	name = "Zangetsu"
	verbs_on_equip = list(/mob/player/zanpakuto/ichigo/verb/getsuga_tensho)

// @GetsugaTensho
mob/player/zanpakuto/ichigo/verb/getsuga_tensho() 
	set name = "Getsuga Tensho"
	set category = "Attacks"

	var/obj/spell/getsuga_charge/effect = new(usr)
	src.vis_contents += effect
	flick("attack",src)
	sleep(10/world.fps * 3)
	src.vis_contents -= effect

	var/obj/spell/getsuga_tensho/spell_object = new(usr)
	var/obj/spell/getsuga_tensho_flail/trace_one = new(usr)
	var/obj/spell/getsuga_tensho_flail/trace_two = new(usr)

	spell_object.SetLocation(usr, locate(usr.x,usr.y,usr.z))
	trace_one.SetLocation(usr, locate(usr.x,usr.y,usr.z))
	trace_two.SetLocation(usr, locate(usr.x,usr.y,usr.z))

	switch(dir)
		if(NORTH)
			trace_one.dir = NORTHEAST
			trace_two.dir = NORTHWEST
		if(SOUTH)
			trace_one.dir = SOUTHEAST
			trace_two.dir = SOUTHWEST
		if(EAST)
			trace_one.dir = NORTHEAST
			trace_two.dir = SOUTHEAST
		if(WEST)
			trace_one.dir = NORTHWEST
			trace_two.dir = SOUTHWEST
	spell_object.dir = src.dir	
	
	spell_object.Init(usr)
	trace_one.Init(usr)
	trace_two.Init(usr)


obj/spell
	getsuga_charge
		id="aura"
		sub_id="getsuga_charge"
		icon = 'getsuga_charge.dmi'
		layer = AURA_LAYER

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
		step_size = 10
		step_delay = 0.25

		move_on_init = TRUE
		pierce_objects = TRUE
		duration = SPELL_TIMEOUT_GETSUGATENSHO
		damage_type = MAGIC_TYPE 

		New(mob/caster, dir, loc, x_delta=0, y_delta=0)
			..()
			switch(dir)
				if(NORTH)
					ChangeBounds(1,1,160,73)
					x -=2
					step_y -= round(bound_height/2)
				if(SOUTH)
					ChangeBounds(1,1,160,73)
					x-=2
					step_y -= round(bound_height/2)
				if(EAST)
					ChangeBounds(1,1,73,160)
					y-=2
					step_x -= round(bound_width/2)
				if(WEST)
					ChangeBounds(1,1,73,160)
					y-=2
					step_x -= round(bound_width/2)

		Damage(mob/caster, time=world.time)
			src.damage = (caster.attack * 0.5) + caster.reiatsu
			