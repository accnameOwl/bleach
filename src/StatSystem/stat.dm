/datum/stat
	var/limit = 1
	var/value = 1
	// Flag
	var/onupdate_operator_change_limit = FALSE

/datum/stat/New(base)
	value = base
	if(args[2])
		limit = args[2]
	else
		limit = base

	if(args[3] && (args[3] == TRUE))
		onupdate_operator_change_limit = TRUE

	//OnUpdate()

/datum/stat/proc/OnUpdate(x = null)
	
	// Do override stuff
	if(onupdate_operator_change_limit)
		if(x && isnum(x))
			limit += round(x)

	// #ifdef TEST_BUILD
	// world.log << "[src.type]::Update() -> Result([src.value], [src.limit])"
	// #endif
	
/datum/stat/proc/operator+=(x)
	value += round(x)
	OnUpdate(x)

/datum/stat/proc/operator-=(x)
	value -= round(x)
	OnUpdate(x)

/datum/stat/proc/operator<=(x)
	return limit <= x

/datum/stat/proc/operator>=(x)
	return value >= x

/datum/stat/proc/limit(x)
	src.limit += round(x)
	//OnUpdate()
