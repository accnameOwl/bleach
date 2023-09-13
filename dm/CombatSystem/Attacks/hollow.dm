
// Cero
mob/hollow/verb
	cero()
		set name = "Cero"
		set category = "Attacks"
		//Check reiatsu
		if(!check_spellcost(src, SPELL_COST_CERO))
			src << Bold(Red("Insufficient mana to cast Cero"))
			return 0

		//1: Charge cero
		consume_reiatsu(src, SPELL_COST_CERO)
			//charge speed depends on cero mastery

		//2: send cero
		var/obj/spell/cero/cero = new/obj/spell/cero(src,world.time)
		cero.dir = dir
		cero.uid = src.key
		cero.Init(src)

	// Bala
	bala()
		set name = "Bala"
		set category = "Attacks"

		if(!check_spellcost(src, SPELL_COST_BALA))
			src << Bold(Red("Insufficient mana to cast Bala!"))
			return 0

		//1: Charge cero
		consume_reiatsu(src, SPELL_COST_BALA)
		var/obj/spell/bala/bala = new/obj/spell/bala(src,world.time)
		bala.dir = dir
		bala.Init(src)

