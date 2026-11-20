mob
	var
		list/equipped_items = list()
		list/inventory = list()

	verb
		RespondItem(item_id as text, command as text)
			set hidden = 1

			var/item/item = inventory[item_id]
			if(!item)
				return

			switch(command)
				if("drop")
				if("use")

				// ... equipment ...
				if("equip")
					if(item in equipped_items)
						return
					else
						equipped_items += item
						item.on_equip()

				if("unequip")
					if(!(item in equipped_items))
						return
					else
						equipped_items -= item
						item.on_unequip()


item
	parent_type = /obj
	layer = MOB_LAYER+1

	var
		// ... system ...
		id					// random string, generated on New()
		ticker=FALSE		// used by browser as hadle to objects.

		// ... gameplay ...
		equipped = FALSE
		effect = null
		damage = 0

		// ... appliances ...
		list/grant_verbs = list()		// Special items give verbs to users.

		list/grant_stats = list()		// stats given by item.
										// /list("<stat_name>"=value, ...)

		list/grant_auras = list()		// auras given by item, on equip.
										// /list(/aura/buff/hot, /aura/buff/shield_on_damage_taken)

	verb
		Get()
			set src in oview(1)

			var/mob/m = usr
			if(!m || usr) return

			src.loc = m
			m.inventory += src


	Tick()
		if(ticker)
			on_tick()
	proc
		// ... functional wrappers ...
		on_pickup(mob/wielder)

		on_drop(mob/wielder)

		on_equip(mob/wielder)
			apply_stats(wielder)
			apply_verbs(wielder)
			apply_auras(wielder)

		on_unequip()

		on_use()

		on_tick()



		// ... stats ...
		apply_stats(mob/m)
			if(!m || !grant_stats || (grant_stats.len < 1))
				return
			for(var/k,v in grant_stats)
				if(k in m.vars)
					m.vars[k] = v
				else
					continue

		remove_stats(mob/m)
			if(!m || !grant_stats || (grant_stats.len < 1))
				return
			for(var/k,v in grant_stats)
				if(k in m.vars)
					m.vars[k] = v
				else
					continue

		// ... verbs ...
		apply_verbs(mob/m)
			if(!m || !grant_verbs || (grant_verbs.len < 1))
				return
			m.verbs += grant_verbs

		remove_verbs(mob/m)
			if(!m || !grant_verbs || (grant_verbs.len < 1))
				return
			m.verbs -= grant_verbs

		// ... auras ...
		apply_auras(mob/m)
			if(!m || !grant_auras || (grant_auras.len < 1))
				return
			for(var/aura_type in grant_auras)
				m.apply_aura(aura_type) 		// no need to pass instantiated object yet.
												// calling mob.apply_aura() does that for us.

		remove_auras(mob/m)
			if(!m || !grant_auras || (grant_auras.len < 1))
				return
			for(var/aura_type in grant_auras)
				m.remove_aura(m.get_aura_by_type(aura_type))		// manual handle for aura of type "aura_type"

	equipment
		verb/Equip(mob/m = usr)
			return

	potion
		verb/Drink()

	consumable
		verb/Use()


// # Equipment
item/equipment
	zanpakuto
		layer = SWORD_LAYER
		icon = 'sword.dmi'
		name = "Zanpakuto"
