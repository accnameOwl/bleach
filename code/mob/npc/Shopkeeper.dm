
// @Shopkeeper
mob/NPC/Shopkeeper
	icon = 'npcs.dmi'
	icon_state = "The Awesome Shopkeeper"
	json_id = "admin_shop"

	New()
		while(src)
			switch(dir)
				//Walk in a circle
				if(NORTH)
					walk_towards(src, locate(x+1,y,z),0,1)
				if(EAST)
					walk_towards(src, locate(x,y-1,z),0,1)
				if(SOUTH)
					walk_towards(src, locate(x-1,y,z),0,1)
				if(WEST)
					walk_towards(src, locate(x,y+1,z),0,1)
			sleep(rand(60,80))

	verb/Talk()
		set src in oview(2)
		var/list/shop_inventory = list(
			"Admin Hat" = new/item/clothing/suit_admin_hat,
			"Admin Suit" = new/item/clothing/suit_admin,
			"Admin Star" = new/item/clothing/suit_admin_star,
			"Aizen Suit" = new/item/clothing/suit_aizen,
			"Arrancar 1 Suit" = new/item/clothing/suit_arrancar_1,
			"Arrancar 2 Suit" = new/item/clothing/suit_arrancar_2,
			"Arrancar 3 Suit" = new/item/clothing/suit_arrancar_3,
			"Arrancar 4 Suit" = new/item/clothing/suit_arrancar_4,
			"Quincy Suit" = new/item/clothing/suit_quincy,
			"Shinigami Suit" = new/item/clothing/suit_shinigami,
			"Black Captain Cloak" = new/item/clothing/suit_captain_black,
			"Blue Captain Cloak" = new/item/clothing/suit_captain_blue)
		debug.warn("This is the data:<br>[list2params(shop_inventory)]")
	//	var/selected_item = input(usr, "Please select a product!", "Barber") as null|anything in shop_inventory
