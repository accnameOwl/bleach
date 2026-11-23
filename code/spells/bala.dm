spell/bala
	name = "Bala"
	icon = 'bala.dmi'
	id = "spell_bala"

	duration = SECOND(10)
	damage_multiplier = alist(PHYSICAL=0, MAGIC=0.5)
	damage_type = MAGIC

	step_speed = 30

	bound_y = 2
	bound_x = 3


mob/castable/verb/Bala()
	set category = "Attacks"
	set name = "Bala"
	var/spell/bala/bala = new(pixloc(usr), usr.dir, usr)
	bala.rotate_towards(dir)
	bala.movement_loop()