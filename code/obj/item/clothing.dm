


item/clothing

	suit_admin_star
		pixel_y=32
	layer = CLOTHING_LAYER

#define CLOTHING(a, b, c, d) item/clothing/a{icon=b; name=c; id=d;}

CLOTHING(CaptainCloak,'suit_captain_black.dmi', "Shinigami Haori","suit_captain_black")
CLOTHING(EspadaNumber,null, "Numero Espada","suit-captain_black")
CLOTHING(cloth_cape,'cloth_cape.dmi', "Cape","cloth-cape")
CLOTHING(cloth_flowercape,'cloth_flowercape.dmi',"Flower Cape","cloth_flowercape")
CLOTHING(cloth_glass,'cloth_glass.dmi', "Glasses", "cloth_glass")
CLOTHING(cloth_jacket,'cloth_jacket.dmi',"Leather Jacket","cloth_jacket")
CLOTHING(cloth_ninja,'cloth_ninja.dmi', "Ninja Suit", "cloth_ninja")
CLOTHING(cloth_pants,'cloth_pants.dmi',"Pants","cloth_pants")
CLOTHING(cloth_schooluniform,'cloth_schooluniform.dmi',"School Uniform","cloth_schooluniform")
CLOTHING(cloth_shirt,'cloth_shirt.dmi',"Shirt","cloth_shirt")
CLOTHING(cloth_sunglasses,'cloth_sunglass.dmi',"Sunglasses","cloth_sunglasses")
CLOTHING(cloth_tousengoggles,'cloth_tousengoggles.dmi', "Goggles", "cloth_tousengoggles")
CLOTHING(cloth_urahara,'cloth_urahara.dmi', "Suit", "suit_urahara")
CLOTHING(cloth_urahara_hat,'cloth_urahara_hat.dmi', "Hat", "cloth_urahara_hat")
CLOTHING(suit_aizen,'suit_aizen.dmi', "Suit", "suit_aizen")
CLOTHING(suit_arrancar_1,'suit_arrancar_1.dmi', "Suit", "suit_arrancar_1")
CLOTHING(suit_arrancar_2,'suit_arrancar_2.dmi', "Suit", "suit_arrancar_2")
CLOTHING(suit_arrancar_3,'suit_arrancar_3.dmi', "Suit", "suit_arrancar_3")
CLOTHING(suit_arrancar_4,'suit_arrancar_4.dmi', "Suit", "suit_arrancar_4")
CLOTHING(suit_captain_black,'suit_captain_black.dmi', "Cloak", "suit_captain_black")
CLOTHING(suit_captain_blue,'suit_captain_blue.dmi', "Cloak", "suit_captain_blue")
CLOTHING(suit_quincy,'suit_quincy.dmi', "Suit", "suit_quincy")
CLOTHING(suit_shinigami,'suit_shinigami.dmi', "Shihakusho", "suit_shinigami")
CLOTHING(suit_admin,'suit_admin.dmi', "Admin Suit", "suit_admin")
CLOTHING(suit_admin_star,'suit_admin_star.dmi',"Admin","suit_admin_star")
CLOTHING(suit_admin_hat,'suit_admin_hat.dmi',"Admin Hat","suit_admin_hat")

#undef CLOTHING

item/equipment
	captain_cloak
		icon = 'suit_captain.dmi'
		name = "Shinigami Haori"
		id = "clothing_captain_black"

		gain_stats = list(
			"max_hp" = 25000,
			"hp" = 25000,
			"mana"= 17500,
			"max_mana" = 17500,
			"defense" = 900,
		)

	zanpakuto

		grant_stats = list(
			"attack" = 100,
			"reiatsu" = 100,
		)

		on_equip(mob/player/m = usr)
			..()
			var/update_hud = FALSE
			
			if(m.has_shikai)
				m.verbs += /mob/castable/verb/Shikai
				update_hud = TRUE
			
			if(m.has_bankai)
				m.verbs += /mob/castable/verb/Bankai
				update_hud = TRUE
			
			if(update_hud) 
				m.hud_update()	