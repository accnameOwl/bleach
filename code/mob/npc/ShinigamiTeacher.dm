
// @ShinigamiTeacher
mob/NPC/ShinigamiTeacher
	icon = 'shinigami_teacher.dmi'
	json_id = "shinigami_teacher"
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
				src.take_damage(src, usr.hp)
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
						usr.make_shinigami()
						make_squad_member(usr, picksquad)