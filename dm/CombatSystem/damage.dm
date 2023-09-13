
//static type
var/damage/damage = new

damage
	proc
		Calculate(damage = 0, damage_type = "", defence = 0, dodge = 0, mitigation = 0)
			if(dodge && prob(dodge))
				return "dodge"
			else
				switch(damage_type)
					if(MAGIC_TYPE, POISON_TYPE, FIRE_TYPE, WATER_TYPE, ICE_TYPE)
						defence *= 0.5
					if(DARKMAGIC_TYPE, BLEED_TYPE)
						defence = 0
				var/mitigated = mitigation ? (damage/100)*mitigation : 0
				. = damage - mitigated - defence
				if(. <= 0)
					. = 0

