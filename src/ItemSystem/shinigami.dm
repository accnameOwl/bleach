/datum/item
	verb
		Equip()
			if(equipped)
				usr.overlays.Add(src)
				equipped = 0
			else
				usr.overlays.Add(src)
				equipped = 1
		Drop()
			src.loc = usr.loc

		PickUp()
			set src in oview(1)
			usr << src

	Zanpaktou
		layer = SWORD_LAYER
		icon = 'sword.dmi'


	Clothing
		layer = CLOTHING_LAYER

		//Shinigami clothing
		Shihakusho
			icon = 'shinigamicloth.dmi'
			name = "Shihakusho"