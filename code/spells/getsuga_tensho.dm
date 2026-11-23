spell/wide_projectile/getsuga_tensho
	name = "Getsuga Tensho"
	icon = 'getsugatensho_96x32.dmi'
	id = "spell_getsuga"

	duration = SECOND(10)
	damage_multiplier = alist(PHYSICAL=1.5, MAGIC=0)
	damage_type = PHYSICAL

	step_speed = 36

// TODO: COmbine both bankai and shikai abilities within same verb, with a "in_bankai" switch.
mob/castable/verb/GetsugaTensho()
	set category = "Attacks"
	set name = "Getsuga Tensho"	

	var/spell/wide_projectile/getsuga_tensho/g = new
	if(spell_cooldown(g.type))
		return
	else
		g = new(bound_pixloc(usr,usr.dir), usr.dir, usr)
		g.rotate_towards(dir)
		g.movement_loop()
		spell_cooldown_update(g.type, g.cooldown)

spell/wide_projectile/getsuga_tensho_black
	name = "Getsuga Tensho"
	icon = 'getsugatensho_black_96x32.dmi'
	id = "spell_getsuga"

	duration = SECOND(10)
	damage_multiplier = alist(PHYSICAL=1.5, MAGIC=0)
	damage_type = PHYSICAL

	step_speed = 36

mob/castable/verb/GetsugaTenshoBlack()
	set category = "Attacks"
	set name = "Getsuga Tensho Black"
	var/spell/wide_projectile/getsuga_tensho_black/g = new
	if(spell_cooldown(g.type))
		return
	else
		g = new(bound_pixloc(usr,usr.dir), usr.dir, usr)
		g.rotate_towards(dir)
		g.movement_loop()
		spell_cooldown_update(g.type, g.cooldown)