
mob/NPC/RetsuUnohana
	icon = 'retsu_unohana.dmi'
	json_id = "unohana"
	respawn_time = 1

	verb/Talk()
		set src in oview(1)
		set category = "Talk"
		if(usr.race == "Shinigami")
			if(usr.hp <= usr.max_hp)
				alert("Unohana: Woopsie! It looks like you are wounded. Maybe I should take a look at your wounds?", src.name)
				switch(alert("Would you like Unohana to heal you?", src.name, "Yes", "No"))
					if("Yes")
						usr:resting = 1
						while(usr.hp < usr.max_hp)
							usr.hp += round(usr.max_hp/100)
							sleep(10/world.fps)
						usr.hp = usr.max_hp
						usr:resting = 0
						alert("Unohana: Your health is restored. But I can only treat your wounds.")
					if("No")
						alert("Unohana: You should be more careful, [usr.name]...")
		else
			alert("You do not feel welcome.")