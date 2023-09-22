obj/item/zanpakuto/zangetsu
	icon = 'shikai_ichigo.dmi'
	name = "Zangetsu"
	verbs_on_equip = list(/mob/player/zanpakuto/ichigo/verb/getsuga_tensho)

// @GetsugaTensho
mob/player/zanpakuto/ichigo/verb/getsuga_tensho() 
	set name = "Getsuga Tensho"
	set category = "Attacks"

	var/icon/effect = new('getsuga_charge.dmi')
	src.overlays += effect
	flick("attack",src)
	sleep(3)
	src.overlays-=effect

	var/obj/spell/getsuga_tensho/spell_object = new/obj/spell/getsuga_tensho(src)
	spell_object.dir = src.dir	
	spell_object.Init(src)
	

obj/spell
	getsuga_charge
		id="aura"
		sub_id="getsuga_charge"
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
			.=..(caster, time)
			// ! Error
			// 		Issue not calling Crossed() for mobs in bounds()
			// x Fix
			// 		get bounds() before ChangeBounds(), then compare with
			//		CrossedBounds()
			var/list/old_overlap = bounds()
					
			switch(dir)
				if(SOUTH)
					ChangeBounds(1,1,160,65)
					x-=2
				if(NORTH)
					ChangeBounds(1,97,160,63)
					x-=2
				if(EAST)
					ChangeBounds(97,1,63,160)
					y-=2
				if(WEST)
					ChangeBounds(1,64,63,160)
					y-=2

			var/list/new_overlap = bounds()
			CrossedUncrossedBetweenBounds(old_overlap, new_overlap)

		Damage(mob/caster, time=world.time)
			src.damage = (caster.attack * 0.5) + caster.reiatsu
			