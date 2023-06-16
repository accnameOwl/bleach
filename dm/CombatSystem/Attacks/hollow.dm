
// Cero
mob/hollow/verb/cero()
	set name = "Cero"
	set category = "Attack"
	//Check reiatsu
	if(!check_spellcost(src, SPELL_COST_CERO))
		src << Bold(Red("insufficient mana to cast Cero!"))
		return

	//1: Charge cero
	consume_reiatsu(src, SPELL_COST_CERO)
		//charge speed depends on cero mastery

	//2: send cero
	var/datum/spell/cero/cero = new()
	cero.set_caster(src)
	cero.set_damage(src.reishi.value*SPELL_MULTIPL_CERO, DARKMAGIC_TYPE)
	cero.Initialize(dir, locate(x,y,z), src.step_x, src.step_y)

/datum/spell/cero
	name = "Cero"
	icon = 'cero.dmi'
	icon_state = "cero"
	timeout_duration = SPELL_TIMEOUT_CERO
	step_size = SPELL_CERO_STEP_SIZE
	move_on_init = TRUE
	density = 1

/datum/spell/cero_trail
	icon = 'cero.dmi'
	icon_state = "cero_trail"
	timeout_duration = SPELL_TIMEOUT_CERO/6


/datum/spell/cero/Step(dir,delay=step_delay)
	//store prev x and y loc
	var/prev_x = x
	var/prev_y = y
	//make sure it exists
	//run ..Step()
	. = ..(dir, delay)
	if(.)
		//if moved one tile
		if(prev_x != x || prev_y != y)
			var/datum/spell/cero_trail/trail = new()
			switch(dir)
				if(NORTH)
					trail.Initialize(dir, locate(x,y,z), src.step_x, src.step_y-(TILE_HEIGHT/4))
				if(SOUTH)
					trail.Initialize(dir, locate(x,y,z), src.step_x, src.step_y+(TILE_HEIGHT/4))
				if(EAST)
					trail.Initialize(dir, locate(x,y,z), src.step_x-(TILE_WIDTH/4), src.step_y)
				if(WEST)
					trail.Initialize(dir, locate(x,y,z), src.step_x+(TILE_WIDTH/4), src.step_y)

// Bala
mob/hollow/verb/bala()
	set name = "Bala"
	set category = "Attack"

	if(!check_spellcost(src, SPELL_COST_BALA))
		src << Bold(Red("insufficient mana to cast Bala!"))
		return

	//1: Charge cero
	consume_reiatsu(src, SPELL_COST_BALA)
	var/datum/spell/bala/bala = new()
	bala.set_caster(src)
	bala.set_damage(src.reishi.value*SPELL_MULTIPL_BALA, MAGIC_TYPE)
	bala.Initialize(dir, locate(x,y,z), src.step_x, src.step_y)

/datum/spell/bala
	name = "Bala"
	icon = 'cero.dmi'
	icon_state = "bala"
	timeout_duration = SPELL_TIMEOUT_BALA
	step_size = 8
	move_on_init = TRUE
	density = 1


// Gran Rey Cero
mob/hollow/verb/granreycero()
	set name = "Gran Rey Cero"
	set category = "Attack"

	if(!check_spellcost(src, SPELL_COST_GRC))
		src << Bold(Red("insufficient mana to cast Gran Rey Cero!"))
		return

	//1: Charge cero
	consume_reiatsu(src, SPELL_COST_GRC)

	var/datum/spell/granreycero/left/left = new()
	var/datum/spell/granreycero/center/center = new()
	var/datum/spell/granreycero/right/right = new()

	left.set_caster(src)
	center.set_caster(src)
	right.set_caster(src)

	left.set_damage(src.reishi*SPELL_MULTIPL_GRC, DARKMAGIC_TYPE)
	center.set_damage(src.reishi*SPELL_MULTIPL_GRC, DARKMAGIC_TYPE)
	right.set_damage(src.reishi*SPELL_MULTIPL_GRC, DARKMAGIC_TYPE)

	switch(dir)
		if(NORTH)
			left.Initialize(dir, locate(x-1,y,z), src.step_x, src.step_y)
			center.Initialize(dir, locate(x,y,z), src.step_x, src.step_y)
			right.Initialize(dir, locate(x+1,y,z), src.step_x, src.step_y)
		if(SOUTH)
			left.Initialize(dir, locate(x+1,y,z), src.step_x, src.step_y)
			center.Initialize(dir, locate(x,y,z), src.step_x, src.step_y)
			right.Initialize(dir, locate(x-1,y,z), src.step_x, src.step_y)
		if(EAST)
			left.Initialize(dir, locate(x,y-1,z), src.step_x, src.step_y)
			center.Initialize(dir, locate(x,y,z), src.step_x, src.step_y)
			right.Initialize(dir, locate(x,y+1,z), src.step_x, src.step_y)
		if(WEST)
			left.Initialize(dir, locate(x,y+1,z), src.step_x, src.step_y)
			center.Initialize(dir, locate(x,y,z), src.step_x, src.step_y)
			right.Initialize(dir, locate(x,y-1,z), src.step_x, src.step_y)

//Gran rey cero
/datum/spell/granreycero
	name = "Gran Rey Cero"
	step_size = SPELL_GRC_STEP_SIZE
	icon = 'cero.dmi'
	timeout_duration = SPELL_TIMEOUT_GRANREYCERO 
	density = 1
/datum/spell/granreycero_trail
	step_size = SPELL_GRC_STEP_SIZE
	icon = 'cero.dmi'
	timeout_duration = SPELL_TIMEOUT_GRANREYCERO/5

/datum/spell/granreycero/left
	icon_state = "grc_left"
	move_on_init = TRUE

	Step(dir,delay=step_delay)
		var/prev_x = x
		var/prev_y = y
		. = ..(dir, delay)
		if(.)
			//if moved one tile
			if(prev_x != x || prev_y != y)
				var/datum/spell/granreycero_trail/left/trail = new()
				switch(dir)
					if(NORTH)
						trail.Initialize(dir, locate(x,y,z), src.step_x, src.step_y-(TILE_HEIGHT/4))
					if(SOUTH)
						trail.Initialize(dir, locate(x,y,z), src.step_x, src.step_y+(TILE_HEIGHT/4))
					if(EAST)
						trail.Initialize(dir, locate(x,y,z), src.step_x-(TILE_WIDTH/4), src.step_y)
					if(WEST)
						trail.Initialize(dir, locate(x,y,z), src.step_x+(TILE_WIDTH/4), src.step_y)

/datum/spell/granreycero/center
	icon_state = "grc_center"
	move_on_init = TRUE

	Step(dir,delay=step_delay)
		var/prev_x = x
		var/prev_y = y
		//run ..Step()
		. = ..(dir, delay)
		if(.)
			//if moved one tile
			if(prev_x != x || prev_y != y)
				var/datum/spell/granreycero_trail/center/trail = new()
				switch(dir)
					if(NORTH)
						trail.Initialize(dir, locate(x,y,z), src.step_x, src.step_y-(TILE_HEIGHT/4))
					if(SOUTH)
						trail.Initialize(dir, locate(x,y,z), src.step_x, src.step_y+(TILE_HEIGHT/4))
					if(EAST)
						trail.Initialize(dir, locate(x,y,z), src.step_x-(TILE_WIDTH/4), src.step_y)
					if(WEST)
						trail.Initialize(dir, locate(x,y,z), src.step_x+(TILE_WIDTH/4), src.step_y)

/datum/spell/granreycero/right
	icon_state = "grc_right"
	move_on_init = TRUE

	Step(dir,delay=step_delay)
		var/prev_x = x
		var/prev_y = y
		//run ..Step()
		. = ..(dir, delay)
		if(.)
			//if moved one tile
			if(prev_x != x || prev_y != y)
				var/datum/spell/granreycero_trail/right/trail = new()
				switch(dir)
					if(NORTH)
						trail.Initialize(dir, locate(x,y,z), src.step_x, src.step_y-(TILE_HEIGHT/4))
					if(SOUTH)
						trail.Initialize(dir, locate(x,y,z), src.step_x, src.step_y+(TILE_HEIGHT/4))
					if(EAST)
						trail.Initialize(dir, locate(x,y,z), src.step_x-(TILE_WIDTH/4), src.step_y)
					if(WEST)
						trail.Initialize(dir, locate(x,y,z), src.step_x+(TILE_WIDTH/4), src.step_y)


//Gran rey cero traail
/datum/spell/granreycero_trail/left
	icon_state = "grc_trail_left"
/datum/spell/granreycero_trail/center
	icon_state = "grc_trail_center"
/datum/spell/granreycero_trail/right
	icon_state = "grc_trail_right"