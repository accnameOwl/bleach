var/const
	CLICK_PASS = 0
	CLICK_HANDLED = 1

client
	var
		next_click = 0


	Click(atom/object, atom/location, control, params)

		if(!mob || !istype(object, /atom))
			return ..(object, location, control, params)

		if(world.time < next_click)
			return

		next_click = world.time+1

		/**
		 * @params
		 * 	icon-x, icon-y
		 * left, middle, right
		 * button
		 * ctrl, shift, alt
		 * drag-cell, drop-cell
		 * drag
		 * link
		 * vis-x, vis-y
		 */
		var/list/p = params2list(params)

		if(mob.dispatch_click(object, location, control, p) == CLICK_HANDLED)
			return

		return ..(object, location, control, params)

mob
	proc
		dispatch_click(atom/target, atom/location, control, list/params)
			if(params["right"] && active_spell)
				// You canceled a cast.
				active_spell = null
				return CLICK_HANDLED

			if(active_spell & params["left"])
				return try_cast(active_spell, target)

			if(params["left"])
				return target.on_click(src, params)

			return CLICK_PASS

atom/proc/on_click(mob/user, list/params)
	return CLICK_PASS
