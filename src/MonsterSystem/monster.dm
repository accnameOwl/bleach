mob/monster
	var/reward_experience = 0
	var/reward_attack = 0
	var/reward_reishi = 0
	var/reward_hierro = 0
	var/reward_health = 0
	var/reward_reiatsu = 0

// makes monster move random direction while alive
// called in mob/NPC/Resting()
mob/monster/proc/Reward(mob/killer)
	killer.GiveExperience(reward_experience)
	killer.IncreaseStatBy(ATTACK, reward_attack)
	killer.IncreaseStatBy(REISHI, reward_reishi)
	killer.IncreaseStatBy(HIERRO, reward_hierro)
	killer.IncreaseStatBy(HEALTH_MAX, reward_health)
	killer.IncreaseStatBy(REIATSU_MAX, reward_reiatsu)
