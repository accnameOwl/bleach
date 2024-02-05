mob/NPC
	bound_x = 12
	bound_y = 1
	bound_width = 8
	bound_height = 15

// @Barber
mob/NPC/Barber
	icon = 'barber.dmi'
	name = "The famous barber"

	verb/Talk()
		set src in oview(2)

		var/selected_hair = input(usr, "Please select a hairtype!", "Barber") in hairtypes
		var/selected_color = input(usr, "select hair color", "Hair Color") as color
		var/icon/_icon = new(hairtypes[selected_hair])

		_icon.Blend(selected_color, ICON_ADD)

		var/obj/hair/h = new/obj/hair()
		h.icon=_icon
		if(usr.hair)
			usr.overlays.Remove(usr.hair)

		usr.hair = h
		usr.overlays.Add(h)


// @Shopkeeper
mob/NPC/Shopkeeper
	icon = 'shop_keeper.dmi'
	name = "The famous keeper of shops"

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
			"Cape" = new/obj/item/Clothing/cloth_cape,
			"Flower Cape" = new/obj/item/Clothing/cloth_flowercape,
			"Glasses" = new/obj/item/Clothing/cloth_glass,
			"Jacket" = new/obj/item/Clothing/cloth_jacket,
			"Ninja Suit" = new/obj/item/Clothing/cloth_ninja,
			"Pants" = new/obj/item/Clothing/cloth_pants,
			"School Uniform" = new/obj/item/Clothing/cloth_schooluniform,
			"Shirt" = new/obj/item/Clothing/cloth_shirt,
			"Sunglasses" = new/obj/item/Clothing/cloth_sunglasses,
			"Eye Goggles" = new/obj/item/Clothing/cloth_tousengoggles,
			"Green Uniform" = new/obj/item/Clothing/cloth_urahara,
			"Hat" = new/obj/item/Clothing/cloth_urahara_hat)
		var/selected_item = input(usr, "Please select a product!", "Barber") as null|anything in shop_inventory
		var/obj/item/_item = shop_inventory[selected_item]

		switch(selected_item)
			if("Cape","Pants","Shirt")
				var/selected_color = input(usr, "Please pick a color", "Hair Color") as color
				ChangeIconColor(_item,, selected_color)
		usr.add_item(_item)


// @Shopkeeper
mob/NPC/admin_shopkeeper
	icon = 'npcs.dmi'
	icon_state = "The Awesome Shopkeeper"
	name = "The famous keeper of shops"

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
			"Admin Hat" = new/obj/item/Clothing/suit_admin_hat,
			"Admin Suit" = new/obj/item/Clothing/suit_admin,
			"Admin Star" = new/obj/item/Clothing/suit_admin_star,
			"Aizen Suit" = new/obj/item/Clothing/suit_aizen,
			"Arrancar 1 Suit" = new/obj/item/Clothing/suit_arrancar_1,
			"Arrancar 2 Suit" = new/obj/item/Clothing/suit_arrancar_2,
			"Arrancar 3 Suit" = new/obj/item/Clothing/suit_arrancar_3,
			"Arrancar 4 Suit" = new/obj/item/Clothing/suit_arrancar_4,
			"Quincy Suit" = new/obj/item/Clothing/suit_quincy,
			"Shinigami Suit" = new/obj/item/Clothing/suit_shinigami,
			"Black Captain Cloak" = new/obj/item/Clothing/suit_captain_black,
			"Blue Captain Cloak" = new/obj/item/Clothing/suit_captain_blue)
		var/selected_item = input(usr, "Please select a product!", "Barber") as null|anything in shop_inventory
		usr.add_item(shop_inventory[selected_item])

// @ShinigamiTeacher
mob/NPC/ShinigamiTeacher
	icon = 'shinigami_teacher.dmi'

	name = "Kyōraku Akina"
	level = 85

	respawn_time = 1

	New()
		..()
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
		var/_title = "Kyōraku Akina"

		switch(usr.race)
			if("Human")
				alert("Kyōraku Akina: Hello human! I do not know how you arrived here. I will send you back to the world of living. Only 'souls' are allowed to speak to me.", _title)
			if("Shinigami")
				if(racerank == "Captain")
					alert("Kyōraku Akina: I'm honored by your presence, Squad [usr.squad_division] captain [usr.name]!",,"Leave...")
				else
					alert("Kyōraku Akina: Long time no see [usr.name]! I'm glad to see you are well.",,"Exit")
			if("Hollow"||"Menos"||"Adjucha"||"Vasto Lorde"||"Arrancar"||"Quincy")
				alert("Kyōraku Akina: Message to squad 13, there has arrived a [usr.race] at the training facilities!")
				alert("Kyōraku Akina: squad 13:'A message to all units! A [usr.race] has infiltrated Soul Society!'")
				alert("Kyōraku Akina: To long... I will be sending you off myself!")
				src.TakeDamage(src, usr.health)
			if("Vaizard")
				alert("Kyōraku Akina: *Cough*", _title,"Greet")
				alert("Kyōraku Akina: Oh, Hello there esteemed Vaizard! Pardon, but the apprentices are scared by your presence... *Bows*", _title, "I'll be on my leave.", "I don't care")
			if("Soul")
				if(usr.level < LEVELREQ_SHINIGAMI)
					alert("Kyōraku Akina: Hello [usr.name]. You are not strong enough yet to venture the Shinigami path.", _title, "Leave...")
					return
				alert("Kyōraku Akina: Hello [usr.name]. I have been expecting you", _title, "Next")
				alert("Kyōraku Akina: My name is Kyōraku Akina, and I am the official Shinigami Teacher in soul society!", _title, "Next")
				alert("Kyōraku Akina: You may have many questions. But first off, what you know about life is not exactly what you think.",_title,"Next")
				alert("Kyōraku Akina: You are now in 'Soul Society'! A world where souls pass on to in the afterlife.",_title, "Next")
				alert("Kyōraku Akina: Shinigami are the guards of 'Soul Society', who protects and sends off souls from the world of living to 'Soul Society'.",_title, "Next")
				alert("Kyōraku Akina: We Shinigami are also responsible for sending off evil spirits, 'Hollows', who devour and feeds on souls.",_title,"Next")
				switch(alert("Kyōraku Akina: Do you wish to become a Shinigami?",_title, "Yes, i do", "I'll think about it", "Leave"))
					if("Leave")
						alert("Kyōraku Akina: Ok, see ya!",_title)
						return
					if("I'll think about it")
						alert("Kyōraku Akina: I see... I hope you consider it! The ways of us Shinigami is presigeous and righteous. Do not take this opportunity for granted!", _title)
						return
					if("Yes, i do")
						alert("Kyōraku Akina: Great! *Panics* Ehm...! Please wait for just a moment!", _title)
						alert("Kyōraku Akina: Oh no, where did i put it! Oh, here!", _title)
						alert("Kyōraku Akina hands over a rug of clothing and a sword", _title)
						alert("Kyōraku Akina: This is your equipment as a Shinigami. Handle it with care! There are no replacements!", _title)

						var/changeofmind = 0
						var/selected_sword = ""
						var/list/personality_type = list("Brute strength", "Spiritually dominant","Defence is the best offence", "Return...")
						var/list/attack_type = list(
							"Speed and force",
							"Return...")
						var/list/reishi_type = list(
							"Pridefull",
							"Return...")
						var/list/hierro_type = list(
							"I'm severely blind",
							"Return...")
						var/list/__squadlist = list(
							"1st Division" = 1,
							"2nd Division" = 2,
							"3rd Division" = 3,
							"4th Division" = 4,
							"5th Division" = 5,
							"6th Division" = 6,
							"7th Division" = 7,
							"8th Division" = 8,
							"9th Division" = 9,
							"10th Division" = 10,
							"11th Division" = 11,
							"12th Division" = 12,
							"13th Division" = 13)
						do
							// Select sword type
							switch(input("Kyōraku Akina: What is your personality traits?", _title) in personality_type)
								// @Attack
								if("Brute strength")

									switch(input("Kyōraku Akina: Could you be more specific?", _title) in attack_type)
										// @Zangetsu
										if("Speed and force")
											changeofmind = 0
											selected_sword = "Zangetsu"

										if("Return...")
											changeofmind = 1
								// @Reishi
								if("Spiritually dominant")

									switch(input("Kyōraku Akina: Could you be more specific?", _title) in reishi_type)
										// @Zenbonsakura
										if("Pridefull")
											changeofmind = 0

										if("Return...")
											changeofmind = 1
								// @Hierro
								if("Defence is the best offence")

									switch(input("Kyōraku Akina: Could you be more specific?", _title) in hierro_type)
										// @Tousen
										if("I'm severely blind")
											changeofmind = 0
										if("Return...")
											changeofmind = 1
								if("Return...")
									return

							if(!selected_sword)
								changeofmind = 0
								alert("Kyōraku Akina: There seems to be a problem...", _title)
						while(changeofmind)

						// @Select Squad
						var/picksquad = input("Kyōraku Akina: Which division do you wish to attend?", _title) in __squadlist
						picksquad =  __squadlist[picksquad]
						// End
						alert("Kyōraku Akina: Congratulations on becoming a Shinigami!", _title)
						usr.MakeShinigami()
						make_squad_member(usr, picksquad)

mob/NPC/RetsuUnohana
	icon = 'retsu_unohana.dmi'
	name = "Retsu Unohana"
	level = "?"
	respawn_time = 1

	verb/Talk()
		set src in oview(1)
		set category = "Talk"
		if(usr.race == "Shinigami")
			if(usr.health <= usr.max_health)
				alert("Unohana: Woopsie! It looks like you are wounded. Maybe I should take a look at your wounds?", src.name)
				switch(alert("Would you like Unohana to heal you?", src.name, "Yes", "No"))
					if("Yes")
						usr.resting = 1
						while(usr.health < usr.max_health)
							usr.health += round(usr.health/100)
							sleep(10/world.fps)
						usr.health = usr.max_health
						usr.resting = 0
						alert("Unohana: Your health is restored. But I can only treat your wounds.")
					if("No")
						alert("Unohana: You should be more careful, [usr.name]...")
		else
			alert("You do not feel welcome.")


mob/NPC/ByakuyaKuchiki
	icon = 'byakuya_kuchiki.dmi'
	name = "Byakuya Kuchiki"
	level = "?"
	respawn_time = 1

	verb/Talk()
		set src in oview(2)
		set category = "Talk"
		var/mob/player/player = usr
		var/accept_challenge = alert("Do you wish to challange me, [usr.name]", "Challenge Byakuya","Yes","No")
		if(accept_challenge == "No") 
			return 0
		if(player.challenge_list["byakuya"])
			var/no_reward = alert("You already recieved your reward, and will not be awarded once more. Continue?", "Challenge Byakuya", "Yes","No")
			if( no_reward == "No")
				return 0
		else 
			var/with_reward = alert("You will be rewarded a small boost and release mastery", "Challenge Byakuya","Ok","Leave")
			if(with_reward == "Leave")
				return 0
		player << Bold(Yellow(Center("Defeat Byakuya Kuchiki")))
		player << Red(Center("Starting challenge in 5 seconds"))


	// @Aizen
mob/NPC/AizenSoske
	icon = 'aizen_sosuke.dmi'
	name = "Aizen Sōsuke"
	level = "?"
	respawn_time = 1

	verb/Talk()
		set src in oview(2)
		//var/_title = "Aizen Sōsuke"

mob/NPC/KanameTousen
	icon = 'kaname_tousen.dmi'
	name = "Kaname Tousen"
	level = "?"
	respawn_time = 1800


// @Urahara
mob/NPC/UraharaKisuke
	icon = 'npcs.dmi'
	icon_state = "urahara"
	name = "Urahara Kisuke"
	level = "?"
	respawn_time = 1

	New()
		..()
		while(src)
			switch(dir)
				//Walk in a circle
				if(NORTH)
					walk_towards(src, locate(x+2,y,z),1,1)
				if(EAST)
					walk_towards(src, locate(x,y-2,z),1,1)
				if(SOUTH)
					walk_towards(src, locate(x-2,y,z),1,1)
				if(WEST)
					walk_towards(src, locate(x,y+2,z),1,1)
			sleep(rand(60,80))

	verb/Talk()
		set src in oview(2)
		var/_title = "Urahara Kisuke"

		switch(usr.race)
			if("Human")
				alert("Urahara Kisuke: Human text", _title)
			if("Shinigami")
				alert("Urahara Kisuke: Shinigami Text",_title)
			if("Vaizard")
			else
				alert("*Urahara Looks away...* -You do not feel welcome-", _title)

//@ Quincy Elder
mob/NPC/QuincyElder
	icon = 'npcs.dmi'
	icon_state = "quincyelder"
	name = "Sōken Ishida"
	level = "?"
	respawn_time = 1

	verb/Talk()
		set src in oview(2)
		var/_title = "Sōken Ishida"
		if(usr.race == "Human")
			if(usr.level >= LEVELREQ_QUINCY)
				alert("Sōken Ishida: Hello there [usr.name]! I see you have adapt skills with Reishi...", _title)
				alert("Sōken Ishida: I would not be surprised if you where thought right, your future would be ever so bright!", _title)
				alert("Sōken Ishida: Do not fret! What I am suggesting to you is to learn the Quincy way!", _title)
				alert("Sōken Ishida: We, Quincy, are prideful. We use our powers to exterminate hollows, and bring peace to the living.", _title)
				var/choice = alert("Sōken Ishida: How does it sound [usr.name]? We quincies are quite powerful, and you will be rewarded with great tools! Do you wish to become one of us?", _title, "Yes","No")
				switch(choice)
					if("Yes")
						// Become a quincy.
						//Failsafe
						if(usr.race!="Human")
							return
						usr.MakeQuincy()
					if("No")
						return
			else
				alert("Sōken Ishida: Hello there [usr.name]! I hope to see you in the future", _title)