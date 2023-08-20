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
mob/monster/proc/Reward(mob/player/killer)
	killer.GiveExperience(reward_experience)
	killer.attack += reward_attack
	killer.reishi += reward_reishi
	killer.hierro += reward_hierro
	killer.health += reward_health
	killer.reiatsu += reward_reiatsu
