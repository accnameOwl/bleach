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
		

	