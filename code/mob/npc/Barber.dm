
// @Barber
mob/NPC/Barber
	icon = 'barber.dmi'
	name = "The famous barber"
	json_id = "barber"

	verb/Talk()
		set src in oview(2)

		var/selected_hair = input(usr, "Please select a hairtype!", "Barber") in hairtypes
		var/selected_color = input(usr, "select hair color", "Hair Color") as color
		var/icon/_icon = new(hairtypes[selected_hair])

		_icon.Blend(selected_color, ICON_ADD)

		var/obj/hair/h = new/obj/hair()
		h.icon=_icon
		if(usr.hair)
			usr.overlays.Remove(usr.hair)

		usr.hair = h
		usr.overlays.Add(h)