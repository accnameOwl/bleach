
// @Clothing
mob/NPC/Clothing
	icon = 'shop_keeper.dmi'
	json_id = "clothing"


	var/static/list/shop_inventory = list(
		"Cape" = new/item/clothing/cloth_cape,
		"Flower Cape" = new/item/clothing/cloth_flowercape,
		"Glasses" = new/item/clothing/cloth_glass,
		"Jacket" = new/item/clothing/cloth_jacket,
		"Ninja Suit" = new/item/clothing/cloth_ninja,
		"Pants" = new/item/clothing/cloth_pants,
		"School Uniform" = new/item/clothing/cloth_schooluniform,
		"Shirt" = new/item/clothing/cloth_shirt,
		"Sunglasses" = new/item/clothing/cloth_sunglasses,
		"Eye Goggles" = new/item/clothing/cloth_tousengoggles,
		"Green Uniform" = new/item/clothing/cloth_urahara,
		"Hat" = new/item/clothing/cloth_urahara_hat)

	var/list/colorable_items = list("Cape","Pants","Shirt")

	verb/Talk()
		set src in oview(2)
		var/selected_item = input(usr, "Please select a product!", "Barber") as null|anything in shop_inventory
		var/item/_item = shop_inventory[selected_item]

		if(selected_item in colorable_items)
			var/selected_color = input(usr, "Please pick a color", "Hair Color") as color
			ChangeIconColor(_item,, selected_color)
