/datum/item
	parent_type = /obj
	layer = MOB_LAYER+1
	var
		equipped = 0

/datum/hair
	parent_type = /atom/movable
	icon/icon
	layer = HAIR_LAYER

// hair
mob/var/datum/hair/hair


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