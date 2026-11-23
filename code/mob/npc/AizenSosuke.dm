
	// @Aizen
mob/NPC/AizenSosuke
	icon = 'aizen_sosuke.dmi'
	json_id = "aizen"
	respawn_time = 1

	verb/Talk()
		set src in oview(2)
		//var/_title = "Aizen Sōsuke"