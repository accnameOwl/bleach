
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
	var/obj/spell/cero/cero = new/obj/spell/cero(src,src.dir,src.loc,src.step_x,src.step_y)
	cero.damage = src.reishi*SPELL_MULTIPL_CERO

// Bala
mob/hollow/verb/bala()
	set name = "Bala"
	set category = "Attack"

	if(!check_spellcost(src, SPELL_COST_BALA))
		src << Bold(Red("insufficient mana to cast Bala!"))
		return

	//1: Charge cero
	consume_reiatsu(src, SPELL_COST_BALA)
	var/obj/spell/bala/bala = new/obj/spell/bala(src,src.dir,src.loc,src.step_x,src.step_y)
	bala.damage = src.reishi*SPELL_MULTIPL_BALA

