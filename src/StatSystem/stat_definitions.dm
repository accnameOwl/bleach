mob
	var/list/Stats
	var/tmp/last_time_trained = 0
	var/level = 1
	var/total_exp = 0

	var/datum/stat/health_cur = new
	var/datum/stat/health_max = new
	var/datum/stat/reiatsu_cur = new
	var/datum/stat/reiatsu_max = new
	var/datum/stat/attack = new
	var/datum/stat/reishi = new
	var/datum/stat/hierro = new
	var/datum/stat/exp = new
	var/datum/stat/exp_max = new
	var/fatigue = 1