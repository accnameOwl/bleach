mob/proc/MakeShinigami()
	race = "Shinigami"
	var/datum/item/Clothing/Shihakusho/suit = new /datum/item/Clothing/Shihakusho
	var/datum/item/Zanpaktou/sword = new /datum/item/Zanpaktou
	contents += suit
	contents += sword

mob/proc/MakeBounto()
	race = "Bounto"

mob/proc/MakeHollow()
	race = "Hollow"

mob/proc/MakeArrancar()
	race = "Arrancar"

mob/proc/MakeQuincy()
	race = "Quincy"

mob/proc/MakeVaizard()
	race = "Vaizard"
	
mob/proc/MakeSoul()
	race = "Soul"