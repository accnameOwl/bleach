/* INFO: https://www.byond.com/forum/post/2909327

TOPDOWN_MAP cares about:
Plane > Subplane > Layer > Sequence

SIDE_MAP cares about:
Plane > Subplane > Physical Y > Layer > Physical X(Center) > Sequence


*/

//reconfigure the default areas:
#undef AREA_LAYER
#undef TURF_LAYER
#undef OBJ_LAYER
#undef MOB_LAYER

//redefine FLOAT_LAYER to keep float values when (x+FLOAT_LAYER)
#undef FLOAT_LAYER
#define FLOAT_LAYER -1000

#define AREA_LAYER (1 + BACKGROUND_LAYER)
#define TURF_LAYER (2 + BACKGROUND_LAYER)
#define OBJ_LAYER 3
#define MOB_LAYER 3
#define EFFECTS_LAYER 6

#define STATIC_PLANE 	 10
#define ACTOR_PLANE 	 20
#define EFFECTS_PLANE	 30
#define FOREGROUND_PLANE 40


//change the map format:
world
	map_format = SIDE_MAP

//set ATOMs to the new layers.
area
	plane = STATIC_PLANE
	layer = AREA_LAYER
turf
	plane = ACTOR_PLANE
	layer = TURF_LAYER
obj
	plane = ACTOR_PLANE
	layer = OBJ_LAYER | FLOAT_LAYER
mob
	plane = ACTOR_PLANE
	layer = MOB_LAYER | FLOAT_LAYER

obj/spell
	plane = EFFECTS_PLANE