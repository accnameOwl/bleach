mob/player/var/statpoints = 0

mob/player/proc/AwardStatPoint(amount)
	statpoints += amount

mob/player/proc/SpendStatPoint(stat/s)
	if( statpoints <= 0 ) return
	s += 1 * SYS_LEVELING_POINTS_MULTIPLVAL
	statpoints--

