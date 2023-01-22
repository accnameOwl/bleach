
//Cero
mob/hollow/verb/cero()
	set name = "Cero"
	set category = "Attack"

	//1: Charge cero
		//charge speed depends on cero mastery
	//2: send cero

/datum/spell/cero
	//icon = ''
	//icon_state = ""
	timeout_duration = SPELL_TIMEOUT_CERO
	step_size = 8

/datum/spell/cero_trace
	//icon = ''
	//icon_state = ""
	timeout_duration = SPELL_TIMEOUT_CERO

/datum/spell/cero/Step(dir,delay=step_delay)
	var/prev_tile[2] = list(x,y)
	..(dir, delay)
	if(prev_tile[1] != x)

		//Spawn a cero_trail at the previous x loc 
		//locate(prev_tile[1],y,z)
	if(prev_tile[2] != y)
		//Spawn a cero_trail at the previous y loc
		// locate(x,prev_tile[2],z)

mob/hollow/verb/bala()
	set name = "Bala"
	set category = "Attack"

/datum/spell/bala
	//icon = ''
	//icon_state = ""
	timeout_duration = SPELL_TIMEOUT_BALA
	step_size = 8

mob/hollow/verb/granreycero()
	set name = "Gran Rey Cero"
	set category = "Attack"

/datum/spell/granreycero_trace
	//icon = ''
	//icon_state = ""
	timeout_duration = SPELL_TIMEOUT_GRANREYCERO
/datum/spell/granreycero
	//icon = ''
	//icon_state = ""
	timeout_duration = SPELL_TIMEOUT_GRANREYCERO
	step_size = 8