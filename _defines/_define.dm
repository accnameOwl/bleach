#define DEBUG

#define APPEND_REF(l, ref, val) l[ref] = val
// remove by ref
#define REMOVE_REF(l, ref) l -= ref

#define NEW_BUFFER(l) l = list()

#define NEW_ABUFFER(l) l = alist()

#define assert(a) ASSERT(a)

#ifdef DEBUG
	#define Printlog(x) \
		world.log << x
	#define PrintW(x) \
		world.log << "Warning! [__FILE__]:[__LINE__] - " + x
#elif
	#define Printlog(x);
	#define PrintW(x);
#endif

// Flags related combat
#define BUFF		1<<0
#define DEBUFF		1<<1
#define PASSIVE		1<<2
#define OFFENSIVE	1<<3
#define DEFENSIVE	1<<4
#define NO_REFRESH	0<<5
#define REFRESH		1<<5
#define ATTR_ATTACK	1<<6
#define ATTR_DEFENSE 1<<7
#define ATTR_REIATSU 1<<8


#define ALPHABET list("A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z")
#define NUMBERS list("1","2","3","4","5","6","7","8","9","0")
proc/generate_id() as text
	var/result = ""
	for(var/i in 1 to 8)
		var/number_or_letter = pick(0,1)
		if(number_or_letter)
			var/letter = pick(ALPHABET)
			if(pick(0,1))
				result += lowertext(letter)
			else
				result += letter
		else
			result += pick(NUMBERS)


#define TILE_WIDTH 32
#define TILE_HEIGHT 32

#define banlist_loc "saves/banlist.sav"
#define guilds_save_loc "saves/guilds.sav"
#define squads_save_loc "saves/squads.sav"

#define true TRUE
#define false FALSE

#define PRESERVE_WORLDTIME "worldtime"
#define PRESERVE_REALTIME "realtime"

#define MILLI(x)	ceil(x)
#define SECOND(x)	ceil(10*x)
#define MINUTE(x) 	ceil(600*x)
#define HOUR(x) 	36000*x

#define qassert(val)	ASSERT(val)

proc/ChangeIconColor(atom/object, icon/i, color)
	// ChangeIconColor(object, 'icon.dmi')
	if(i)
		i = new(i)
	else if(object.icon)
		i = new(object.icon)
	if(color)
		i.Blend(color, ICON_ADD)
	object.icon = i


proc/BinaryInsertionSort(list/L, property)
	var/i, j, first, last, len=length(L)
	for(i=2, i<=len, ++i)
		// binary search through sorted items
		first=1; last=1
		while(first < last)
			j = (first+last) >> 1 // midpoint, round down
			if(L[i][property] < L[j][property])
				last = j
			else
				first = j+1
		if(first < i)
			L.Insert(first, L[i])
			L.Cut(i+1, i+2) // Insert increments, which needs to be removed

proc
	dir2vec(Dir)
		var/x=0,y=0
		switch(Dir&(NORTH|SOUTH))
			if(NORTH)
				y = 1
			if(SOUTH)
				y = -1
		switch(Dir&(EAST|WEST))
			if(EAST)
				x = 1
			if(WEST)
				x = -1
		return vector(x,y)

	atan2(vector/v)
		if(v.x == 0)
			if(v.y > 0)
				return 180
			else if(v.y<0)
				return 0
		var/angle = arctan(v.y/v.x)+90
		if(v.x<0)
			angle -= 180

		angle = -angle

		while(angle<0)
			angle += 360
		return angle

