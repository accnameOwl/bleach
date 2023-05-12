mob/monster
	var/reward_experience = 0
	var/reward_attack = 0
	var/reward_reishi = 0
	var/reward_hierro = 0
	var/reward_health = 0
	var/reward_reiatsu = 0
	step_size = MONSTER_STEP_SIZE

// makes monster move random direction while alive
// called in mob/NPC/Resting()
mob/monster/proc/Reward(mob/killer)
	killer.GiveExperience(reward_experience)
	killer.IncreaseStatBy(attack, reward_attack)
	killer.IncreaseStatBy(reishi, reward_reishi)
	killer.IncreaseStatBy(hierro, reward_hierro)
	killer.IncreaseStatBy(health_max, reward_health)
	killer.IncreaseStatBy(reiatsu_max, reward_reiatsu)
