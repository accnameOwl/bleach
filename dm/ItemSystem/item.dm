datum/item
	parent_type = /obj
	layer = MOB_LAYER+1
	var
		equipped = 0
		id = ""


datum/item/verb/Equip()
	if(equipped)
		usr.overlays.Add(src)
		equipped = 0
	else
		usr.overlays.Add(src)
		equipped = 1
	. = equipped
datum/item/verb/Drop()
	src.loc = usr.loc

datum/item/verb/PickUp()
	set src in oview(1)
	usr << src


/datum/hair
	parent_type = /atom/movable
	icon/icon
	layer = HAIR_LAYER

// hair
mob/var/icon/hair 


var/list/hairtypes = list(
	"Aizen" = 'hairaizen.dmi',
	"Byakuya" = 'hairbyakuya.dmi',
	"Hitsugaya" = 'hairhitsugaya.dmi',
	"Ichigo" = 'hairichigo.dmi',
	"Ichimaru" = 'hairichimaru.dmi',
	"Kariya" = 'hairkariya.dmi',
	"Kira" = 'hairkira.dmi',
	"Nanao" = 'hairnanao.dmi',
	"Nnoitora" = 'hairnnoitora.dmi',
	"Renji" = 'hairrenji.dmi',
	"Rukia" = 'hairrukia.dmi',
	"Sado" = 'hairsado.dmi',
	"Soifon" = 'hairsoifong.dmi',
	"Ukitake" = 'hairukitake.dmi',
	"Urahara" = 'hairurahara.dmi',
	"Uryuu" = 'hairuryuu.dmi',
	"Zaraki" = 'hairzaraki.dmi'
)