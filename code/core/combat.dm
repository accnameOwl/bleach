


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


// Damage type
var/global/const/PHYSICAL = 1
var/global/const/MAGIC = 2

mob
	var/static/MIN_PARRY_CHANCE = 2
	var/static/MAX_PARRY_CHANCE = 42
	var/static/PARRY_LEVEL_DIFFERENCE = 70

	var/combat_timestamp = -1#INF // Used to clock combat time.
	var/static/const/time_to_outofcombat = 50 // 50 deciseconds
	var/in_combat = FALSE
	var/is_dead = FALSE
	var/can_respawn = TRUE
	var/respawn_time = 50
	var/trigger_regen = FALSE
	var/invinsible = FALSE

mob
	// Primary stats
	var/hp = 100
	var/max_hp = 100
	var/mana = 10
	var/max_mana = 10

	var/stat_attack = 1
	var/stat_reiatsu = 1
	var/stat_defense = 1
	var/stat_versatility = 0

	// Secondary stats
	var/stat_parry_chance = 14
	var/stat_block_chance = 34
	var/stat_crit_chance = 21
	var/stat_cooldown_reduction = 25
	var/stat_hp_regen = 1.0 // normalized
	var/stat_mana_regen = 1.0 // normalized

	// Aura buffer
	var/tmp/alist/auras = alist()

// Defenitions
mob/proc
	enter_combat()
		in_combat = TRUE

		////GetEventManager().raise_event("enter_combat", list(src, world.time))


	leave_combat()
		in_combat = FALSE

		////GetEventManager().raise_event("leave_combat", list(src, world.time))

	on_death()

	combat_timestamp(time = world.time)
		combat_timestamp = time

	can_attack(mob/m)
		if(src == m) return 0
		else if(!ismob(m)) return 0
		else if(m.invinsible) return 0
		return 1

	death_check()
		if(is_dead())
			hp = 0
			is_dead = TRUE
			loc = locate(0,0,0)
			leave_combat()
			////GetEventManager().raise_event("died", list(src, world.time))
			spawn(respawn_time) respawn()
			return 1
			// Do something related to death...		Respawn()
		return 0

	respawn()
		if(istype(src, /mob/player))
			var/turf/spawn_loc

			switch(race)
				if("Human")
					spawn_loc = locate(SPAWN_LOC_HUMAN)
				if("Soul")
					spawn_loc = locate(SPAWN_LOC_SOUL)
				if("Hollow")
					spawn_loc = locate(SPAWN_LOC_HOLLOW)
				if("Arrancar")
					spawn_loc = locate(SPAWN_LOC_ARRANCAR)
				if("Shinigami")
					spawn_loc = locate(SPAWN_LOC_SHINIGAMI)
				if("Vaizard")
					spawn_loc = locate(SPAWN_LOC_VAIZARD)
				if("Quincy")
					spawn_loc = locate(SPAWN_LOC_QUINCY)


			if(!respawn_time)
				return
			else
				spawn(respawn_time)
					hp += max_hp
					is_dead = FALSE
					loc = spawn_loc
					////GetEventManager().raise_event("respawn", list(src, world.time))
		else
			if(vars["home_loc"])
				spawn(respawn_time)
					loc = src:home_loc

	take_damage(mob/attacker, damage_amount, damage_type = PHYSICAL)
		if(!in_combat)
			enter_combat()
		combat_timestamp()
		// 1. Check Parry

		if(damage_type == PHYSICAL && prob(parry_probability(attacker)))
			return 0

		// 2. Check block -> Mitigate
		if(prob(stat_block_chance))
			if(damage_type == MAGIC)
				damage_amount *= 0.75 // half the
			else
				damage_amount *= 0.5

		// 3. Aura pre-processor (buffs/debuffs that trigger 'before' damage)
		for(var/aura/a in auras)
			damage_amount += a.on_before_damage(src, damage_amount, damage_type)

		// 4. Finalize with absolute defense
		damage_amount = max(damage_amount - stat_defense, 1)
		damage_amount -= damage_amount * stat_absolute_defense()

		var/is_crit = prob(attacker.stat_crit_chance)
		world.log << (damage_amount = round(damage_amount))

		// 5. Application
		remove_hp(damage_amount, damage_type, attacker, is_crit)

		f_damage(src.loc, damage_amount, damage_type, is_crit)

		// 6. raise event
		////GetEventManager().raise_event("receive_damage", list(src, attacker, damage_amount, damage_type))

		if(src.death_check())
			if(istype(src, /mob/monster))
				src:reward(attacker)

		return damage_amount



	// Calculations

	damage_summary() as /alist
		return alist(
			PHYSICAL=calculate_damage(stat_attack, PHYSICAL),
			MAGIC=calculate_damage(stat_reiatsu, MAGIC),
			)

	calculate_damage(damage_amount = 0, damage_type = PHYSICAL)
		var/aura_bonus = 0
		// 1. Apply aura bonuses
		for(var/aura/a in auras)
			aura_bonus += a.on_calculate_damage(damage_amount, damage_type)

		damage_amount += aura_bonus

		return damage_amount

	stat_absolute_defense()
		var
			defense_to_mitigation_percent = 0.0006
			_step_size = 9000
			decay_per_step = 0.1
			min_factor = 0.15
			max_factor = 1.0

			total_mitigation = 0.0
			remaining_defense = stat_defense

		for (var/_step = 0; remaining_defense > 0; _step++)

			var/defense_this_step = min(remaining_defense, _step_size)
			var/factor = clamp(max_factor - (_step * decay_per_step), min_factor, max_factor)

			total_mitigation += defense_this_step * defense_to_mitigation_percent * factor
			remaining_defense -= defense_this_step

		return total_mitigation



	parry_probability(mob/attacker)
		//a = Attacker's level
		//d = defender's level
		var
			level_diff = clamp(src.level-attacker.level, -PARRY_LEVEL_DIFFERENCE, PARRY_LEVEL_DIFFERENCE)
			chance = 5 + (level_diff/PARRY_LEVEL_DIFFERENCE) * MAX_PARRY_CHANCE
		return clamp(chance, MIN_PARRY_CHANCE, MAX_PARRY_CHANCE)





	// auras
	apply_aura(aura_type)
		var/aura/new_aura = new aura_type(src)
		src.auras += new_aura
		new_aura.on_apply(src)

	remove_aura(aura/aura)
		src.auras -= aura
		src.auras -= aura
		aura = null

	get_aura_by_type(aura_type, list/aura_list = auras) as /aura
							//	aura_list is intended if you want to fetch very specific buffs.
							//  you can use lists as filters
		for(var/aura/_a in aura_list)
			if(_a.type == aura_type)
				return _a

	buffs()
		var/alist/r = alist()
		for(var/aura/buff/a in auras)
			r += a
		return r

	debuffs()
		var/alist/r = alist()
		for(var/aura/debuff/a in auras)
			r += a
		return r

	/*
	// DEPRECATED ??

	remove_health(var/amt, mob/s=null)
		// amt: amount of damage
		// s: person who did damage
		hp -= max( hp - round(amt), 0)
		if(death_check())
			if(istype(src,/mob/player))
				s.kills++
				s:GiveExperience(reward_experience)
				s.money += round(reward_money)
				s.client.AddGameLog("You have defeated [src:name]!<font color=purple>+[reward_experience] exp!\n+[reward_money] money!</font>")
	*/


	remove_hp(damage, damage_type=PHYSICAL, mob/source, crit)
		src.hp -= damage


		//GetEventManager().raise_event("health_changed", list(src, hp, max_hp))
		//GetEventManager().raise_event("receive_damage", list(src, source, damage, damage_type))

		if(client)
			client?.dirty_stat("hp")

	restore_hp(heal_amount, mob/source)
		src.hp += heal_amount

		//GetEventManager().raise_event("health_changed", list(src, heal_amount, source))
		//GetEventManager().raise_event("receive_healing", list(src, source, heal_amount))

		Printlog("mob.restore_hp() : [src]([src.type]): value = [heal_amount], hp = [hp]")

		if(hp >= max_hp)
			hp = max_hp

		// combat_maptext
		else
			if(heal_amount >= 1000000)
				heal_amount = "[round(heal_amount/1000000,0.005)]M"
			else if(heal_amount>=1000)
				heal_amount = "[round(heal_amount/1000,0.005)]K"
			heal_amount="<font color=#66F>[heal_amount]</font>"

		combat_maptext(heal_amount, null)

		if(client)
			client?.dirty_stat("hp")

	combat_maptext(damage, damage_type = PHYSICAL)
		var/obj/o = new()
		o.maptext = damage
		o.alpha = 255
		o.filters += filter(type="drop_shadow", x=0, y=0, size=2, offset=0, color=rgb(0,0,0))
		o.pixel_y = 18
		o.pixel_x = rand(-8,8)//pick random offset
		o.plane = EFFECTS_PLANE

		vis_contents += o

		// create animation
		var/dur = 15
		//var/matrix/m = matrix() // not entirely sure what i wanted to here....

		// change color if reiatsu based.
		if(damage_type == MAGIC)
			o.color = rgb(80,80,255,255)
		// TODO: IF CRIT
		/*
		m.Scale(1.2,1.2)
		animate(o, transform=m)
		*/

		// translate over time, by 16 pixels in y direction.
		animate(o, pixel_y=46, time=dur,easing=CIRCULAR_EASING|EASE_OUT)
		animate(o, alpha=0,time=dur, easing=CIRCULAR_EASING|EASE_IN)
		// remove after duration.
		spawn(dur)
			vis_contents -= o
			o = null


// Get mobs within radius of "R"
atom
	proc
		// if src is within Radius from Source, as center
		// returns: TRUE, FALSE
		in_radius_to(atom/source=null, radius=0)
			// check both null and truthy
			if(isnull(source) || !source)
				return

			var/pixloc/center_pos = bound_pixloc(source, source.dir)
			var/pixloc/src_pos = bound_pixloc(src, dir)

			var/vector/delta = src_pos - center_pos
			if(delta.size <= radius)
				return TRUE
			else
				return FALSE

		// Gather mobs within radius, in pixels
		// Return list of mobs within range of radius
		mobs_in_radius(radius=0, atom/center = src)
			if(!center || radius <= 0)
				return

			var/list/found = list()

			var/pixloc/center_pos = bound_pixloc(src,src.dir)
			var/pixloc/mob_pos

			var/vector/delta
			var/distance = 0

			for(var/mob/m in orange(ceil(radius/32)))				// we have to `ceil(radius/32)` to convert to tile-size, and promise 1 or more.
				if(m.z != src.z)
					continue

				mob_pos = bound_pixloc(m,m.dir)
				if(!mob_pos)
					continue

				delta = mob_pos - center_pos
				if((distance=delta.size))
					found += m
				else
					continue

			return found

