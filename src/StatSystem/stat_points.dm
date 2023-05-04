statpoint
	//safety
	var/value = 1

statpoint/New(base)
	src.value = base

statpoint/proc
	// +=
	operator+=(val)
		value += val
	// -=
	operator-=(val)
		value -= val
	// ++
	operator++()
		value++
	// --
	operator--()
		value--

mob/player/var/statpoint/stat_points = new(0)

mob/player/proc/AwardStatPoint(amount)
	stat_points += amount

