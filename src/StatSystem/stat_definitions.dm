mob
	var/tmp/last_time_trained = 0

	var/stat/health = new/stat(1)
	var/stat/reiatsu = new/stat(1)
	var/stat/attack = new/stat(1)
	var/stat/reishi = new/stat(1)
	var/stat/hierro = new/stat(1)

	player
		var/stat/exp = new/stat(1, 10)
		var/fatigue = 1
		var/total_exp = 0
	var/level = 1
		