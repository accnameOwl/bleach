datum/item/zanpakuto/zangetsu
	icon = 'shikai_ichigo.dmi'

	Equip()
		if(..()) // was equippped
			src.verbs += typesof(/mob/player/zanpakuto/ichigo/verb)
		else // was removed
			src.verbs -= typesof(/mob/player/zanpakuto/ichigo/verb)

mob/player/zanpakuto/ichigo/verb
	getsuga_tensho()
		set name = "Getsuga Tensho"
		set category = "Attacks"

		var/datum/spell/getsuga_tensho/one/one = new
		var/datum/spell/getsuga_tensho/center/center = new
		var/datum/spell/getsuga_tensho/two/two = new

		one.set_caster(src)
		center.set_caster(src)
		two.set_caster(src)

		var/damage = (0.4 * attack.value) + (1 * reishi.value)
		one.set_damage( damage )
		center.set_damage( damage )
		two.set_damage( damage )

		#ifdef _TEST_
		ASSERT(one)
		ASSERT(center)
		ASSERT(two)
		world.log << "[src]: mob/player/zanpakuto/ichigo/verb/getsuga_tensho()"
		world.log << "created /datum/spell/getsuga_tensho/one"
		world.log << "created /datum/spell/getsuga_tensho/center"
		world.log << "created /datum/spell/getsuga_tensho/two"
		#endif

		one.Initialize(src.dir, src.loc, src.step_x, src.step_y)
		center.Initialize(src.dir, src.loc, src.step_x, src.step_y)
		two.Initialize(src.dir, src.loc, src.step_x, src.step_y)
		

datum/spell/getsuga_tensho
	timeout_duration = 50
	damage_type = MAGIC_TYPE
	move_on_init = TRUE
	name = "Getsuga Tensho"
	icon = 'zangetsu_getsuga.dmi'

datum/spell/getsuga_tensho/one
	icon_state = "1"
datum/spell/getsuga_tensho/center
	icon_state = ""
datum/spell/getsuga_tensho/two
	icon_state = "2"
