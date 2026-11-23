var/alist
	json_data_monsters = json_decode(file2text('./dependencies/json/monsters.json'))
	json_data_player = json_decode(file2text('./dependencies/json/player.json'))
	json_data_npc = json_decode(file2text('./dependencies/json/npc.json'))


atom
	var
		json_id = ""

mob/proc
	get_vars_from_json(list/data)
		for(var/d in data)
			vars[d] = data[d]