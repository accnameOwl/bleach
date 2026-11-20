#define STATUS_TICK_DELAY 5

var/list/Tickers = list()

// interface type
ticker/proc/Tick()

atom/movable/proc/Tick()
client/proc/Tick()

world
	Tick()
		..()
		// "as anything" disables for()'s type filter,
		// so i can treat everything in the list as if it were a /ticker
		for(var/ticker/ticker as anything in Tickers)
			ticker.Tick()

mob
	//various timestamps, making sure to distribute tasks over time.
	var/tmp/aura_timestamp = -1#INF
	Tick()
		// ! This happens FIRST ( or last?? )
		client?.Tick()

		if(combat_timestamp >= world.time + time_to_outofcombat)
			leave_combat()
		

client
	var/stats_tick = -1#INF
	var/list/status_buffer

	var/is_profiling = FALSE
	var/next_profile_refresh = -1#INF

	Tick()
		// # MOVEMENT
		if(move_vector.size && !mob?.prevent_movement)
			mob.Step(move_vector.Normalize())

		// # UPDATE CHAT
		if(has_pending_messages())
			push_messages()

		// # UPDATE DIRTY STATS
		if(ui_is_open[UI_CHARACTER])
			if(has_dirty_stats())
				push_dirty_stats()

			

		// ! ADMIN DEBUGGING
		/*
		if(mob.admin)
			if(is_profiling && next_profile_refresh < world.time)
				if(!usr)
					usr = src
				debug.output_profiler(src)
				next_profile_refresh = world.time+20
	 	*/