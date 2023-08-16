//#define change_target

/proc/EnterCombat(mob/m = null, mob/source = null)
	/*
	combat_flag.combat_time
		<- refreshes to world.time at:
			takedamage()
			dealdamage()
	*/
	set background = TRUE
	set waitfor = FALSE

	if(m.combat_flag.in_combat == TRUE)
		return
	if(istype(m, /mob/monster))
		m:TargetState(source)

	m.combat_flag.in_combat = TRUE

	var/passed_time = 0
	//TODO: Regenerate a small portion of health in combat
	do
		passed_time = m.combat_flag.time - world.time
		if(passed_time <= DROP_COMBAT_TIME)
			return ExitCombat(m)
		sleep(10/world.tick_lag)
	while(m.combat_flag.in_combat)

/proc/ExitCombat(mob/m)
	m.combat_flag.in_combat = FALSE
	m.combat_flag.trigger_regen = TRUE
	m.combat_flag.time = 0
	m.Target = FALSE
	//TODO: Regenerate a larger portion of health out of combat

mob/proc/DeathCheck(mob/killer)
	if(health>=0) return FALSE
	ExitCombat(src)
		// TODO:race not found
	switch(src.race)
		if("Soul")
			if(killer.race == "Hollow" && level >= LEVELREQ_HOLLOW)
				race = "Hollow"
		if("Human")
			MakeSoul()
	
	combat_flag.dead = TRUE
	spawn Respawn()
	src.loc = null

	return TRUE

mob/player/DeathCheck(mob/killer)
	.=..()
	if(.)
		world << Bold(Red("[killer] killed [src.name]."))


mob/proc/Respawn()
	var/spawn_loc
	var/spawn_delay = respawn_time
	/*
	// Different spawn locations
	switch(race)
		if("Human")
			spawn_loc = locate(SPAWN_LOC_HUMAN)
		if("Soul")
			spawn_loc = locate(SPAWN_LOC_SOUL)
		if("Hollow")
			spawn_loc = locate(SPAWN_LOC_HOLLOW)
		if("Arrancar")
			spawn_loc = locate(SPAWN_LOC_ARRANCAR)
		if("Shinigami")
			spawn_loc = locate(SPAWN_LOC_SHINIGAMI)
		if("Vaizard")
			spawn_loc = locate(SPAWN_LOC_VAIZARD)
		if("Quincy")
			spawn_loc = locate(SPAWN_LOC_QUINCY)
	*/
	spawn_loc = locate(SPAWN_LOC_HUMAN)

	health = max_health

	if(!spawn_delay)
		return
	else
		spawn(spawn_delay)
			combat_flag.dead = FALSE
			loc = spawn_loc
/*
	var/mob/n = src
	if(!n) return
	var
		_loc = loc
		_delay = respawn_time
	if(!_delay)
		n.combat_flag.dead = 1
		n.loc = null
		return
	n.combat_flag.dead = 1
	n.loc = null
	n.Stats[HEALTH_CUR] = n.health_max]
	spawn(_delay)
		n.combat_flag.dead = 0
		n.loc = _loc
		world << Turquoise("Respawn()<br>locate= [locate(respawn_loc)]<br>")


*/

/*
TODO:
runtime error: type mismatch: /datum/stat (/datum/stat) - 230
proc name: DealDamage (/mob/proc/DealDamage)
  usr: 0
  src: Tafe (/mob/player)
  src.loc: the purple (56,23,4) 

*/

mob/proc/TakeDamage(mob/damage_dealer, _damage, damage_type = null, spell_name = null)
	if(damage_dealer == src) return
	if(NONE_DAMAGEABLE(src)) return
	EnterCombat(damage_dealer)
	EnterCombat(src, damage_dealer)
	var/value = round(_damage - src.hierro)
	if(value <= 0)
		value = 0

	spawn
		//DamageText(round(value), target.loc, 20, 16)
		src.RemoveHealth(damage_dealer, value)
		src.DeathCheck(damage_dealer)

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
		if(TOXIC_TYPE)
			value = Toxin(value)
		if(FREEZE_TYPE)
			value = Freeze(value)
	if(spell_name)
		damage_dealer << Bold(Red("You damaged [src.name] with [spell_name] for [value]!"))
		src << Bold(Red("[src.name] damaged you with [spell_name] for [value]!"))
	else
		damage_dealer << Bold(Red("You damaged [src.name] for [value]!"))
		src << Bold(Red("[src.name] damaged you for [value]!"))