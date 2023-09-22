obj/item
	layer = MOB_LAYER+1
	var
		equipped = 0
		id = ""
		// List of paths that is given to owner at Read() and Equip()
		list/verbs_on_equip = list()

	proc
		RemoveVerbsOnEquip(mob/m)
			m.verbs -= verbs_on_equip

		AddVerbsOnEquip(mob/m)
			m.verbs += verbs_on_equip

	verb
		Equip()
			.=equipped
			if(.) // unequip
				usr.overlays.Remove(src)
				if(verbs_on_equip.len) 
					RemoveVerbsOnEquip(usr)
				equipped = 0
			else // equip
				usr.overlays.Add(src)
				if(verbs_on_equip)
					AddVerbsOnEquip(usr)
				equipped = 1
			.=equipped

		Drop()
			src.loc = usr.loc

		PickUp()
			set src in oview(1)
			usr << src

	// Read() ...
	// 	When player loads form a savefile, each item calls Read() when Read from 
	// 	said savefile. This is where you implement functionality for items.
	Read()
		..()
		if(equipped)
			// If item is supposed to give verbs to it's owner
			if(verbs_on_equip.len)
				AddVerbsOnEquip(usr)

mob/proc/add_item()
	for(var/obj/item/i in args)
		i.loc = src
