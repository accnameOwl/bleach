mob/proc/DealDamage(mob/target, value, damage_type = null, spell_name = null)
	if(NONE_DAMAGEABLE(target)) return
	EnterCombat(src)
	EnterCombat(target, src)
	value = round(value - target.Stats[HIERRO])
	if(value < 0)
		value = 0

	spawn
		//DamageText(round(value), target.loc, 20, 16)
		target.RemoveHealth(src, value)

	switch(damage_type)
		if(null) 
			value = Yellow(value)
		if(MELEE_TYPE)
			value = Melee(value)
		if(MAGIC_TYPE)
			value = Magic(value)
		if(DARKMAGIC_TYPE)
			value = DarkMagic(value)
		if(BLEED_TYPE)
			value = Bleed(value)
		if(BURN_TYPE)
			value = Burn(value)
		if(TOXIN_TYPE)
			value = Toxin(value)
		if(FREEZE_TYPE)
			value = Freeze(value)
	if(spell_name)
		src << Bold(Red("You damaged [target.name] with [spell_name] for [value]!"))
		target << Bold(Red("[src.name] damaged you with [spell_name] for [value]!"))
	else
		src << Bold(Red("You damaged [target.name] for [value]!"))
		target << Bold(Red("[src.name] damaged you for [value]!"))