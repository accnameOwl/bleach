mob/proc/DealDamage(mob/target, value, damage_type = null)
	if(NONE_DAMAGEABLE(target)) return
	EnterCombat(src)
	value = round(value - target.Stats[HIERRO])
	if(value < 0)
		value = 0

	spawn
		//DamageText(round(value), target.loc, 20, 16)
		target.RemoveHealth(src, value)

	switch(damage_type)
		if(null) 
			value = Yellow(value)
		if(MELEE)
			value = Melee(value)
		if(BLEED)
			value = Bleed(value)
		if(BURN)
			value = Burn(value)
		if(TOXIN)
			value = Toxin(value)
		if(FREEZE)
			value = Freeze(value)
	src << Bold(Yellow("You damaged [target.name] for ") + value + Yellow("!"))
	target << Bold(Yellow("[src.name] damaged you for ") + Red("[value]") + Yellow("!"))