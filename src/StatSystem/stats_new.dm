stat
	var/current = 1
	var/value = 1
	var/contents[] = new
	var/locs[] = new

stat/New(base)
	src.value = base
	Update()

stat/proc/Update()
	. = value
	current = value
	for(var/stat/s in contents)
		current += s.current
	
	if(. != current)
		for(var/atom/a in locs)
			a.OnStatUpdate(src, ., current)
		
	value = current
	
stat/proc
	operator<(stat/s)
		return src.current < s.current
	operator>(stat/s)
		return src.current > s.current
	operator>=(stat/s)
		return src.current >= s.current
	operator<=(stat/s)
		return src.current <= s.current
	operator+=(stat/s)
		contents += s
		s.locs += src
		Update()

	operator-=(stat/s)
		contents -= s
		s.locs -= src
		Update()

atom/proc/OnStatUpdate(stat/s, old_cur, new_cur)
	//Do stuff by overriding.

mob/OnStatUpdate(stat/s)
	#ifdef TEST_BUILD
	world.log << "[src.type]::Update() -> Result([s.current])"
	#endif