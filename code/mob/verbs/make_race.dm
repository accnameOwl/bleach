mob/proc
	make_human()
		race = "human"
		icon = 'base.dmi'
	make_shinigami()
		race = "Shinigami"

	make_bounto()
		race = "Bounto"

	make_hollow()
		race = "Hollow"

	make_arrancar()
		race = "Arrancar"

	make_quincy()
		race = "Quincy"
	make_vaizard()
		race = "Vaizard"

	make_soul()
		race = "Soul"
		icon = 'soul.dmi'

mob/player/proc
	GiveShikai()
		return has_shikai = 1

	GiveBankai()
		return has_bankai = 1