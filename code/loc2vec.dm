proc/loc2vec()
	if(istype(args[1], /atom/movable))
		var/atom/a = args[1]
		return vector(a.x, a.y, a.z)