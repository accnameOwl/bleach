/**
 * These are all called from client.Tick()
 * When a stat has been flagged as "dirty", they get output to character panel on Tick().
 * ! Only the latest state of stat is being updated by the end of current world.tick.
 */

client
	var/alist/dirty_stats = alist()

	proc

		// ! uses `args` as list
		dirty_stat()
			if(!args || isnull(args) )
				return
			
			#ifdef DEBUG
			for(var/var_name in args)
				ASSERT(var_name in mob?.vars)
			#endif

			dirty_stats |= args


		has_dirty_stats()
			return (dirty_stats && dirty_stats.len)
			
		push_dirty_stats()
			if(isnull(src.mob) || !src.mob)
				return

			var/alist/L = alist()
			for(var/i in dirty_stats)
				L[i] = mob.vars[i]

			var/encoded = url_encode(json_encode(L))

			src << output(encoded, "characterWindow.browser:TickUpdate")
			dirty_stats = list()

