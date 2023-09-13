mob

	var
		health = 0
		reiatsu = 0
		attack = 0
		reishi = 0
		hierro = 0
		max_health = 0
		max_reiatsu = 0
		attack_buff_multipl = 1
		reishi_buff_multipl = 1
		hierro_buff_multipl = 1
			
		tmp/last_time_trained = -1#INF // world.time

		//Special attributes. (They don't require to be /datum/stat types)
		//dodge:	Max 25% -> 1sp=.5%
		dodge = 0
		//mitigation: max 40% -> 1sp=.5%
		mitigation = 0
		//regeneration: max 10% -> 1sp=.5%
		regeneration = 0

	player
		var/exp = 0
		var/req_exp = 100
		var/fatigue = 0
		var/total_exp = 0
		

	var/level = 1
	