
//@ Quincy Elder
mob/NPC/QuincyElder
	icon = 'npcs.dmi'
	icon_state = "quincyelder"
	json_id = "soken_ishida"
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
						usr.make_quincy()
					if("No")
						return
			else
				alert("Sōken Ishida: Hello there [usr.name]! I hope to see you in the future", _title)