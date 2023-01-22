obj/vaizardmask
	icon = 'vaizardmasks.dmi'
	layer = MOB_LAYER+1
	one
		icon_state = "1"
	two
		icon_state = "2"
	three
		icon_state = "3"
	four
		icon_state = "4"
	five
		icon_state = "5"
	six
		icon_state = "6"
	seven
		icon_state = "7"
	eight
		icon_state = "8"
mob/verb
	One()
		set category = "masks"
		set name = "1"
		overlays += /obj/vaizardmask/one
	Two()
		set category = "masks"
		set name = "2"
		overlays += /obj/vaizardmask/two
	Three()
		set category = "masks"
		set name = "3"
		overlays += /obj/vaizardmask/three
	Four()
		set category = "masks"
		set name = "4"
		overlays += /obj/vaizardmask/four
	Five()
		set category = "masks"
		set name = "5"
		overlays += /obj/vaizardmask/five
	Six()
		set category = "masks"
		set name = "6"
		overlays += /obj/vaizardmask/six
	Seven()
		set category = "masks"
		set name = "7"
		overlays += /obj/vaizardmask/seven
	Eight()
		set category = "masks"
		set name = "8"
		overlays += /obj/vaizardmask/eight
	Remov()
		set category = "masks"
		overlays = null