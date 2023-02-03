/proc/Initialize()
	world.log << "World initializing()"
	// if squads_list savefile is empty on world init, create a new one with 13 squad_db_types.
	// one for each squad.
	if(!load_squads_list())
		world.log << "Could not find a squads_list savefile...!"
		world.log << "Creating a new file with data objects"
		for(var/i = 1, i < 13, i++)
			var/datum/squad_db_type/new_db_type = new/datum/squad_db_type
			new_db_type.squad = i
			squads_list.Add(new_db_type)
		save_squads_list()
		if(load_squads_list())
			world.log << "Complete!"
		else
			world.log << "Something went wrong..."	