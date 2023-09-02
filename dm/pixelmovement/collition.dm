atom/movable
	proc
	proc
		ChangeBounds(x, y, width, height)
			bound_x = x
			bound_y = y
			bound_width = width
			bound_height = height

		CrossedUncrossedBetweenBounds(old_overlap, new_overlap)
			if(old_overlap ~= new_overlap)
				for(var/atom/atom as anything in (old_overlap - new_overlap))
					atom.Uncrossed(src)
				for(var/atom/atom as anything in (new_overlap - old_overlap))
					atom.Crossed(src)

		//Prototype
		CrossedMob(mob/mob)
mob
	Crossed(atom/movable/mover)
		..()
		mover.CrossedMob(src)


