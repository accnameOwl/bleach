mob/proc/MakeShinigami()
	race = "Shinigami"
	var/obj/item/Clothing/suit_shinigami/suit = new /obj/item/Clothing/suit_shinigami
	var/obj/item/zanpakuto/sword = new /obj/item/zanpakuto
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