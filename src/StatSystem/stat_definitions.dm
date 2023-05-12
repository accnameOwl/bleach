mob
	var/list/Stats
	var/tmp/last_time_trained = 0

	var/stat/health_cur = new
	var/stat/health_max = new
	var/stat/reiatsu_cur = new
	var/stat/reiatsu_max = new
	var/stat/attack = new
	var/stat/reishi = new
	var/stat/hierro = new

	var/stat/exp = new
	var/stat/exp_max = new
	var/fatigue = 1
	var/level = 1
	var/total_exp = 0
		