obj/item
	layer = MOB_LAYER+1
	var
		equipped
		id
		name
		effect
		damage
		// List of paths that is given to owner at Read() and Equip()
		list/verbs_on_equip = list()

	proc
		loadItems()
			var/json/Data = JsonReader('json/items.json')
			var/json/Array = Data["items"]

			for( var/json/Object/Item in Array)
				var/obj/item/NewItem = obj/item()
				NewItem.id = Item["id"]
				NewItem.name = Item["name"]
				NewItem.type = Item["type"]

				if (Item["effect"])
					NewItem.effect = Item["effect"]
				
				if (Item["damage"])
					NewItem.damage = Item["damage"]

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
