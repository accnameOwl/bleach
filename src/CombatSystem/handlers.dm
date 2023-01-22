//#define change_target

/proc/EnterCombat(mob/m)
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

mob/proc/Death(mob/killer)
	ExitCombat(src)
	switch(race)
		if("Soul")
			if(killer.race == "Hollow" && level >= LEVELREQ_HOLLOW)
				race = "Hollow"
		if("Human")
			MakeSoul()

	world << "[src.name] Killed by [killer]"

	combat_flag.dead = TRUE
	spawn Respawn()
	src.loc = null

	return TRUE

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

	Stats[HEALTH_CUR] = Stats[HEALTH_MAX]

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
	n.Stats[HEALTH_CUR] = n.Stats[HEALTH_MAX]
	spawn(_delay)
		n.combat_flag.dead = 0
		n.loc = _loc
		world << Turquoise("Respawn()<br>locate= [locate(respawn_loc)]<br>")


*/