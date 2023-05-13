stat
	var/limit = 1
	var/value = 1

stat/New(base)
	src.value = base
	if(args[2])
		src.limit = args[2]
	else
		src.limit = base
	//OnUpdate()

stat/proc/OnUpdate()
	
	// Do override stuff

	#ifdef TEST_BUILD
	world.log << "[src.type]::Update() -> Result([src.value], [src.limit])"
	#endif
	
stat/proc/operator+=(number)
	value += round(number)
	// OnUpdate()

stat/proc/operator-=(number)
	value -= round(number)
	//OnUpdate()

stat/proc/operator<=(number)
	return value <= number

stat/proc/operator>=(number)
	return value >= number

stat/proc/limit(number)
	src.limit += round(number)
	//OnUpdate()
