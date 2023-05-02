/datum/stat
	var/current = 1
	var/value = 1
	var/contents[] = new
	var/locs[] = new

/datum/stat/New(base)
	src.value = base
	Update()

/datum/stat/proc/Update()
	. = current
	current = value
	for(var/datum/stat/s in contents)
		current += s.current
	
	if(. != current)
		for(var/atom/a in locs)
			a.OnStatUpdate(src, ., current)
	
/datum/stat/proc
	operator<(datum/stat/s)
		return src.current < s.current
	operator>(datum/stat/s)
		return src.current > s.current
	operator>=(datum/stat/s)
		return src.current >= s.current
	operator<=(datum/stat/s)
		return src.current <= s.current
	operator+=(datum/stat/s)
		contents += s
		s.locs += src
		Update()

	operator-=(datum/stat/s)
		contents -= s
		s.locs -= src
		Update()

atom/proc/OnStatUpdate(stat/s, old_cur, new_cur)
	//Do stuff by overriding.