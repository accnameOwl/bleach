atom/movable
	proc
		//Prototype
		CrossedMob(mob/mob)
mob
	Crossed(atom/movable/mover)
		..()
		mover.CrossedMob(src)

obj/spell
	CrossedMob(mob/mob)
		..()
		mob.TakeDamage(src.caster, src.damage, src.damage_type)
		ApplyEffects(mob)
		OnHit()