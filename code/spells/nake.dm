spell/wide_projectile/nake
	name = "Nake"
	icon = 'nake.dmi'
	id = "spell_nake"

	duration = SECOND(10)
	damage_multiplier = alist(PHYSICAL=0.5, MAGIC=1.2)
	damage_type = MAGIC

	step_speed = 30


mob/castable/verb/Nake()
	set category = "Attacks"
	set name = "Sing"
	var/spell/wide_projectile/nake/g = new(bound_pixloc(src,usr.dir), src.dir, src)
	g.rotate_towards(dir)
	g.movement_loop()