
#define DROP_COMBAT_TIME -50
#define PARRY 3
#define BLOCK 2
#define CRITICAL 1

//Cannot deal damage to these types.
//		type1 | type2 | type3 ...
#define IMMUNE_TO_DAMAGE_TYPES /mob/NPC
#define IMMUNE_TO_DAMAGE(x) istype(x, IMMUNE_TO_DAMAGE_TYPES)

#define SYS_COMBAT_DODGE_LIMIT 25
#define SYS_COMBAT_MITIGATION_LIMIT 40
#define SYS_COMBAT_REGENERATION_LIMIT 10