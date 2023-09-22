#define TILE_WIDTH 32
#define TILE_HEIGHT 32

#define banlist_loc "saves/banlist.sav"
#define save_loc "saves/[copytext(src.ckey,1,2)]/[src.ckey].sav"
#define guilds_save_loc "saves/guilds.sav"
#define squads_save_loc "saves/squads.sav"

#define true TRUE
#define false FALSE

#define PRESERVE_WORLDTIME "worldtime"
#define PRESERVE_REALTIME "realtime"

#define MILLI(x)	x
#define SECOND(x)	10*x
#define MINUTE(x) 	600*x
#define HOUR(x) 	36000*x

proc/ChangeIconColor(atom/object, icon/i, color)
	// ChangeIconColor(object, 'icon.dmi')
	if(i)	
		i = new(i)
	else if(object.icon) 
		i = new(object.icon)
	if(color)
		i.Blend(color, ICON_ADD)
	object.icon = i
