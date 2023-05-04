
/datum/combat_flag
	var/dead = FALSE
	var/can_respawn = TRUE
	var/respawn_time = 50
	var/in_combat = FALSE
	var/time = 0
	var/trigger_regen = FALSE
	var/invinsible = FALSE

mob/var/datum/combat_flag/combat_flag = new /datum/combat_flag