
#define DROP_COMBAT_TIME -50
#define PARRY 3
#define BLOCK 2
#define CRITICAL 1

//Cannot deal damage to these types.
//	-Follow them as : '/mop/npc | /mob/Monster/ | /mob/immune'
#define NONE_DAMAGEABLE_MOB_TYPES /mob/NPC
#define NONE_DAMAGEABLE(x) istype(x, NONE_DAMAGEABLE_MOB_TYPES)
