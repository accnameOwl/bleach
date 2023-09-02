atom/movable
	proc
		ChangeBounds(x, y, width, height)
			bound_x = x
			bound_y = y
			bound_width = width
			bound_height = height
			 
			//if there's changes to bounds() contents
			//  call Uncrossed and Crossed

		CompareCrossedBounds(old_overlap, new_overlap)
			if(old_overlap != new_overlap)
				for(var/atom/atom as anything in (old_overlap - new_overlap))
					atom.Uncrossed(src)
				for(var/atom/atom as anything in (new_overlap - old_overlap))
					atom.Crossed(src)