datum/squad_data
	var/key
	var/name
	var/level
	var/squad_division
	var/squad_captain
	var/squad_leutenant

	New(k, n, l, s, c, lt)
		try
			key=k
			name=n
			level=l
			squad_division=s
			squad_captain=c
			squad_leutenant=lt

		catch(var/exception/e)
			Except(e)

mob/player
	proc/UpdateSquadData()
		var/datum/squad_data/sd = new(
				src.key, 
				src.name,
				src.level,
				src.squad_division,
				src.squad_captain,
				src.squad_leutenant)

		switch(src.race)
			if("Shinigami")
				shinigami_squad_members[src.key] = sd
			if("Hollow")
				hollow_espada_members[src.key] = sd
			if("Quincy")
				quincy_sternritter_members[src.key] = sd

	proc/RemoveSquadData()
		shinigami_squad_members[src.key] = null
		hollow_espada_members[src.key] = null
		quincy_sternritter_members[src.key] = null
	
