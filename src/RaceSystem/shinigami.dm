/*** Shinigami squad logics
*
*	a mob is in a squad.
*	squad information is stored pr. mob
*	information of squads is stored in a global list
*	squads global list is saved as savefile
**/

mob
	var/hasShikai = 0
	var/shikaiMastery = 0
	var/hasBankai = 0
	var/bankaiMastery = 0
	


mob/proc/GiveShikai()
	return hasShikai = 1

mob/proc/GiveBankai()
	return hasBankai = 1

/**
	SQUAD STUFF....
*/
