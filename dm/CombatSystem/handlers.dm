
mob
	var
		resting = FALSE
	
	proc
		RemoveHealth(mob/source, value)
			combat_flag.time = world.time
			src.health -= round(value)
			combat_flag.time = world.time

		RestoreHealth(mob/source, amount=0)
			health += round(amount)

		EnterCombat(mob/m, mob/source)
			set background = TRUE
			set waitfor = FALSE

<<<<<<< HEAD
			if(m.combat_flag.in_combat == TRUE)
				return
			if(istype(m, /mob/monster))
				m:TargetState(source)

			m.combat_flag.in_combat = TRUE
=======
mob/proc/TakeDamage(mob/damage_dealer, _damage, damage_type = null, spell_name = null)
	if(NONE_DAMAGEABLE(src)) return
	EnterCombat(src)
	EnterCombat(damage_dealer)
	var/value = round(_damage - src.hierro)
	if(value <= 0)
		value = 0

	spawn
		//DamageText(round(value), target.loc, 20, 16)
		src.RemoveHealth(value)
		src.DeathCheck(damage_dealer)
>>>>>>> refs/remotes/origin/trunk

			var/passed_time = 0
			//TODO: Regenerate a small portion of health in combat
			do
				passed_time = m.combat_flag.time - world.time
				if(passed_time <= DROP_COMBAT_TIME)
					return ExitCombat(m)
				sleep(10/world.tick_lag)
			while(m.combat_flag.in_combat)

		ExitCombat(mob/m)
			m.combat_flag.in_combat = FALSE
			m.combat_flag.trigger_regen = TRUE
			m.combat_flag.time = 0
			m.Target = FALSE
			
		TakeDamage(mob/damage_dealer, _damage, damage_type = null, spell_name = null)
			if(IMMUNE_TO_DAMAGE(src)) // Ignore objects immune to damage 
				return 0
			var/value = round(_damage - src.hierro)
			
			if(value <= 0) // If damage is less than 0, prevent restoring health
				value = 0
			
			EnterCombat(src)
			EnterCombat(damage_dealer)
			
			src.RemoveHealth(damage_dealer, value)
			src.DeathCheck(damage_dealer)
			
			switch(damage_type) //Change damage text color, relative to damage type
				if(null) 
					value = Yellow(value)
				if(MELEE_TYPE)
					value = Melee(value)
				if(MAGIC_TYPE)
					value = Magic(value)
				if(DARKMAGIC_TYPE)
					value = DarkMagic(value)
				if(BLEED_TYPE)
					value = Bleed(value)
				if(BURN_TYPE)
					value = Burn(value)
				if(TOXIC_TYPE)
					value = Toxin(value)
				if(FREEZE_TYPE)
					value = Freeze(value)
			
			if(spell_name)//Text if spell has a name
				damage_dealer << Bold(Red("You damaged [src.name] with [spell_name] for [value]!"))
				src << Bold(Red("[src.name] damaged you with [spell_name] for [value]!"))
			else //Otherwise, text is different
				damage_dealer << Bold(Red("You damaged [src.name] for [value]!"))
				src << Bold(Red("[src.name] damaged you for [value]!"))

		Respawn()
			var/turf/spawn_loc
			var/spawn_delay = respawn_time

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

			health = max_health

			if(!spawn_delay)
				return
			else
				spawn(spawn_delay)
					combat_flag.dead = FALSE
					loc = spawn_loc

		DeathCheck(mob/killer)
			if(src.health>=0) 
				return 0
			ExitCombat(src)
			
			combat_flag.dead = 1
			spawn Respawn()
			src.loc = null

			return 1
			
	player
		DeathCheck(mob/killer)
			.=..()
			if(.)
				switch(src.race)
					if("Soul")
						if(src.race == "Hollow" && level >= LEVELREQ_HOLLOW)
							race = "Hollow"
					if("Human")
						MakeSoul()
				world << Bold(Red("[killer] killed [src.name]."))

	monster
		DeathCheck(mob/killer)
			.=..(killer)
			if(.)
				Reward(killer)
				killer << Bold(Red("You have killed [src.name]."))

		RemoveHealth(mob/source, value)
			..(source, value)

			// AI targeting
			#ifdef change_target
			Target=source
			#else
			if(!Target)
				Target = source
			#endif