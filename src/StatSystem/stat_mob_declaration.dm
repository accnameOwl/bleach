mob
	var/tmp/last_time_trained = 0

	var/datum/stat/health = new/datum/stat(1)
	var/datum/stat/reiatsu = new/datum/stat(1)
	var/datum/stat/attack = new/datum/stat(1,1,TRUE)
	var/datum/stat/reishi = new/datum/stat(1,1,TRUE)
	var/datum/stat/hierro = new/datum/stat(1,1,TRUE)

	player
		var/datum/stat/exp = new/datum/stat(1, 10)
		var/fatigue = 1
		var/total_exp = 0
	var/level = 1
	