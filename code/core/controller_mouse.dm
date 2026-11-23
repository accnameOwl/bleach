client
	var/controller/mouse/mouse = new

	Click(atom/object, turf/location, control, list/params)
		..(object, location, control, params)
		/**
		 * ! Need to figure out a way to get map pixloc, to handle spells, events, mm
		 */

controller/mouse

	proc
		click_pixloc(mob/source, pixloc/loc)
		click_atom(mob/source, atom/object)
		click_loc(mob/source, turf/loc)
		
		// returns a list of atom/movables within loc.
		in_radius(pixloc/center_pos, range)
			var/list/in_range = list()

			var/vector/delta = vector()

			for(var/atom/movable/a in orange(ceil(radius/32)))
				if(m.z != loc.z)
					continue
				
				var/found_pos = bound_pixloc(a,a.dir)
				if(!found_pos)
					continue
				
				delta = found_pos - center_pos
				if((range<= delta.size))
					l += a
				else
					continue
			
			return in_range