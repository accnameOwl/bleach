obj/item/zanpakuto/zangetsu
	icon = 'shikai_ichigo.dmi'
	name = "Zangetsu"
	verbs_on_equip = list(/mob/player/zanpakuto/ichigo/verb/getsuga_tensho)

// @GetsugaTensho
mob/player/zanpakuto/ichigo/verb/getsuga_tensho() 
	set name = "Getsuga Tensho"
	set category = "Attacks"

	var/obj/spell/getsuga_charge/effect = new
	src.overlays += effect
	flick("attack",src)
	sleep(10/world.fps * 3)
	src.overlays -= effect

	var/obj/spell/getsuga_tensho/spell_object = \
			new/obj/spell/getsuga_tensho(src, src.dir, src.loc, src.step_x, src.step_y)

	var/obj/spell/trace_one
	var/obj/spell/trace_two

	
	switch(dir)
		if(NORTH)
			trace_one=new/obj/spell/getsuga_tensho_flail(src, NORTHEAST, src.loc, src.step_x, src.step_y)
			trace_two=new/obj/spell/getsuga_tensho_flail(src, NORTHWEST, src.loc, src.step_x, src.step_y)
		if(SOUTH)
			trace_one=new/obj/spell/getsuga_tensho_flail(src, SOUTHEAST, src.loc, src.step_x, src.step_y)
			trace_two=new/obj/spell/getsuga_tensho_flail(src, SOUTHWEST, src.loc, src.step_x, src.step_y)
		if(EAST)
			trace_one=new/obj/spell/getsuga_tensho_flail(src, NORTHEAST, src.loc, src.step_x, src.step_y)
			trace_two=new/obj/spell/getsuga_tensho_flail(src, SOUTHEAST, src.loc, src.step_x, src.step_y)
		if(WEST)
			trace_one=new/obj/spell/getsuga_tensho_flail(src, NORTHWEST, src.loc, src.step_x, src.step_y)
			trace_two=new/obj/spell/getsuga_tensho_flail(src, SOUTHWEST, src.loc, src.step_x, src.step_y)
	
	var/damage = src.attack + src.reishi
	spell_object.damage = damage
	trace_one.damage = damage*0.3
	trace_two.damage = damage*0.3
	spell_object.StepLoop()
	trace_one.StepLoop()
	trace_two.StepLoop()


obj/spell
	getsuga_charge
		icon = 'getsuga_charge.dmi'
		layer = AURA_LAYER

	getsuga_tensho_flail
		name = "Getsuga Tensho"
		id="getsugatenshoflail"

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

	getsuga_tensho
		name = "Getsuga Tensho"
		id="getsugatensho"

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
