
//@ Quincy trainer
mob/NPC/RyukenIshida
	icon = 'npcs.dmi'
	json_id = "ryuken_ishida"
	respawn_time = 1

	verb/Talk()
		set src in oview(1)

		var/mob/m = usr

		switch(m.race)
			if(HOLLOW, ARRANCAR, ESPADA, SHINIGAMI, VAIZARD)
				m.client?.chat("")