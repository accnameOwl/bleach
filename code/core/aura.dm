
// aura's are constructed to NOT reference mobs directly, but instead
// interract with reference to mob as arguments.
// This to make sure they are garbage collected correctly.
aura
	var/name = "Aura"
	var/duration = 100 // deciseconds
	var/end_time = -1#INF // world.time of when aura overtimes
	var/is_debuff = FALSE
	var/multiplier = 0.0 // normalized.

	proc
		on_apply(mob/m)
			if(duration)
				end_time = world.time + duration
			return
		on_remove(mob/m)
			return
		on_before_damage(mob/m, dmg, type)
			return
		is_overtime()
			return end_time ? (world.time > end_time) : 0
		on_calculate_damage(damage=0, damage_type = PHYSICAL)
			return

	buff/example_defense_boost
		name = "I only boost defense"
		on_apply(mob/m)
			m.stat_defense *= 1.2
		on_remove(mob/m)
			m.stat_defense /= 1.2

	buff/example_buff_all
		name = "I buff everytin'"
		var/buff_hp_amount
		on_apply(mob/m)
			src.buff_hp_amount = m.max_hp * 0.5
			m.hp += buff_hp_amount
			m.max_hp += buff_hp_amount
			m.stat_defense *= 1.5
			m.stat_attack *= 1.5
			m.stat_reiatsu *= 1.5
		on_remove(mob/m)
			m.hp -= buff_hp_amount
			m.max_hp -= buff_hp_amount
			m.stat_defense /= 1.5
			m.stat_attack /= 1.5
			m.stat_reiatsu /= 1.5

	buff/example_enhanced_magicpower
		on_calculate_damage(damage=0, damage_type = PHYSICAL)
			if(damage_type == MAGIC)
				return damage * 0.25 // 25% damage
			else
				return 0

	buff/example_absorb_on_hit
		var/amount = 0
		on_apply(mob/m)
			..(m)
			src.amount = m.hp*0.10 // gives 10% absorbs when applied.
		on_before_damage(mob/m, dmg, damage_type = PHYSICAL)
			var/d = max(src.amount - dmg,0)
			dmg -= src.amount
			src.amount = d
			if(!src.amount)
				m.remove_aura(src)

	debuff/example_dot
		name = "Example DoT"
		is_debuff = TRUE
		duration = 50 // 5s dot, dealing damage every second.

		var/next_dam_tick = -1#INF

		on_apply(mob/m)
			..(m)
			end_time = world.time + duration
			while(src)
				if(next_dam_tick <= world.time)
					m.take_damage(1, MAGIC)
					next_dam_tick = world.time + 10
				sleep(10/world.fps)
