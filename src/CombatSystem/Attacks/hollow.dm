
// Cero
mob/hollow/verb/cero()
	set name = "Cero"
	set category = "Attack"

	//1: Charge cero
		//charge speed depends on cero mastery

	//2: send cero
	var/datum/spell/cero/cero = new()
	cero.Initialize(dir, loc)

/datum/spell/cero
	icon = 'cero.dmi'
	icon_state = "cero"
	timeout_duration = SPELL_TIMEOUT_CERO
	step_size = 8

/datum/spell/cero_trail
	icon = 'cero.dmi'
	icon_state = "cero_trail"
	timeout_duration = SPELL_TIMEOUT_CERO

/datum/spell/cero/Step(dir,delay=step_delay)
	//store prev x and y loc
	var/cached_loc = new/list("x" = x, "y" = y)
	//make sure it exists
	ASSERT(cached_loc)
	//run ..Step()
	..(dir, delay)
	//Look up if x cord changed
	if(cached_loc[1] != x)
		//if changed, spawn trail in prev x cord
		var/datum/spell/cero_trail/trail = new/datum/spell/cero_trail()
		trail.loc = locate(cached_loc["x"], y,z)
		trail.Initialize()
	//look up if y cord changed
	if(cached_loc[2] != y)
		//if changed, spawn trail in prev y cord
		var/datum/spell/cero_trail/trail = new()
		trail.loc = locate(x, cached_loc["y"],z)
		trail.Initialize()



// Bala
mob/hollow/verb/bala()
	set name = "Bala"
	set category = "Attack"

/datum/spell/bala
	//icon = ''
	//icon_state = ""
	timeout_duration = SPELL_TIMEOUT_BALA
	step_size = 8


// Gran Rey Cero
mob/hollow/verb/granreycero()
	set name = "Gran Rey Cero"
	set category = "Attack"
	var/datum/spell/granreycero/left/left = new()
	var/datum/spell/granreycero/center/center = new()
	var/datum/spell/granreycero/right/right = new()
	left.Initialize(dir, loc)
	center.Initialize(dir, loc)
	right.Initialize(dir, loc)

//Gran rey cero
/datum/spell/granreycero/left
	icon = 'cero.dmi'
	icon_state = "grx_left"
	timeout_duration = SPELL_TIMEOUT_GRANREYCERO
	move_on_init = TRUE
	step_size = 8
	Step(dir,delay=step_delay)
		//store prev x and y loc
		var/cached_loc = new/list("x" = x, "y" = y)
		//make sure it exists
		ASSERT(cached_loc)
		//run ..Step()
		..(dir, delay)
		//Look up if x cord changed
		if(cached_loc[1] != x)
			//if changed, spawn trail in prev x cord
			var/datum/spell/granreycero/trail/left/trail = new()
			trail.loc = locate(cached_loc["x"], y,z)
			trail.Initialize()
		//look up if y cord changed
		if(cached_loc[2] != y)
			//if changed, spawn trail in prev y cord
			var/datum/spell/granreycero/trail/left/trail = new()
			trail.loc = locate(x, cached_loc["y"],z)
			trail.Initialize()
/datum/spell/granreycero/center
	icon = 'cero.dmi'
	icon_state = "grc_center"
	timeout_duration = SPELL_TIMEOUT_GRANREYCERO
	move_on_init = TRUE
	step_size = 8
	Step(dir,delay=step_delay)
		//store prev x and y loc
		var/cached_loc = new/list("x" = x, "y" = y)
		//make sure it exists
		ASSERT(cached_loc)
		//run ..Step()
		..(dir, delay)
		//Look up if x cord changed
		if(cached_loc[1] != x)
			//if changed, spawn trail in prev x cord
			var/datum/spell/granreycero/trail/center/trail = new()
			trail.loc = locate(cached_loc["x"], y,z)
		//look up if y cord changed
		if(cached_loc[2] != y)
			//if changed, spawn trail in prev y cord
			var/datum/spell/granreycero/trail/center/trail = new()
			trail.loc = locate(x, cached_loc["y"],z)
/datum/spell/granreycero/right
	icon = 'cero.dmi'
	icon_state = "grc_right"
	timeout_duration = SPELL_TIMEOUT_GRANREYCERO
	move_on_init = TRUE
	step_size = 8
	Step(dir,delay=step_delay)
		//store prev x and y loc
		var/cached_loc = new/list("x" = x, "y" = y)
		//make sure it exists
		ASSERT(cached_loc)
		//run ..Step()
		..(dir, delay)
		//Look up if x cord changed
		if(cached_loc[1] != x)
			//if changed, spawn trail in prev x cord
			var/datum/spell/granreycero/trail/right/trail = new()
			trail.loc = locate(cached_loc["x"], y,z)
		//look up if y cord changed
		if(cached_loc[2] != y)
			//if changed, spawn trail in prev y cord
			var/datum/spell/granreycero/trail/right/trail = new()
			trail.loc = locate(x, cached_loc["y"],z)

//Gran rey cero traail
/datum/spell/granreycero/trail/left
	icon = 'cero.dmi'
	icon_state = "grc_trail_left"
	timeout_duration = SPELL_TIMEOUT_GRANREYCERO
/datum/spell/granreycero/trail/center
	icon = 'cero.dmi'
	icon_state = "grc_trail_center"
	timeout_duration = SPELL_TIMEOUT_GRANREYCERO
/datum/spell/granreycero/trail/right
	icon = 'cero.dmi'
	icon_state = "grc_trail_right"
	timeout_duration = SPELL_TIMEOUT_GRANREYCERO