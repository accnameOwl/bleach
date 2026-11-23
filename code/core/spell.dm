atom
	var
		spell_immune = FALSE

mob
	var
		spell/active_spell = null
		alist/spell_cooldowns = alist()

	proc
		try_cast(spell/s, atom/target)
			var/error = s.validate(src, target)
			if(error)
				client?.chat("log", error)

			s.cast(src, target)
			if(!s.keep_armed)
				active_spell = null

			return CLICK_HANDLED


		spell_cooldown(st)
			var/t = spell_cooldowns && spell_cooldowns[st]
			return t >= world.time

		spell_cooldown_update(st, dur)
			spell_cooldowns[st] = world.time+dur

spell/var/const
	DESTROY_ON_BUMP
	TRAIL = 2
	DETONATE = 4

spell
	parent_type = /mob
	layer = MOB_LAYER
	bound_width = 32
	bound_height = 32
	var
		id

		duration = 0
		start_time
		end_time = 0

		cooldown = 0
		range = 0
		keep_armed = FALSE // if a spell is kept in hand to be cast.

		list/valid_target_types = list(/mob, /obj, /turf)
		list/blocked_target_types = list(/spell, /item, /obj/hud)


		mob/owner

		move_flags = 0

		damage_type
		damage

		//default is scaled off of physical damage.
		alist/damage_multiplier = alist(PHYSICAL=1, MAGIC=0)

	New(pixloc/loc, Dir, mob/caster, time=world.time)
		. = ..()
		src.pixloc = loc
		src.owner = caster
		dir = Dir

		end_time = (start_time=time)+duration

		set_damage(caster.damage_summary())

	Tick()
		if(expired())
			Destroy()

		if(dir)
			if(src.Step())
				on_move()
				if(move_flags & TRAIL)
					trail()

	on_crossed(atom/movable/obstacle)
		if(ismob(obstacle))
			if(obstacle == owner)
				return 1
			var/mob/m = obstacle
			var/successful = m.take_damage(src.owner, damage, damage_type)
			if(!successful)
				if(m.client)
					m?.client.chat("log", "You parried [owner.name]'s [src.name]")
				owner.client.chat("log", "[m.name] parried [src.name]")
			else
				if(m.client)
					m?.client.chat("log", "[owner.name] hit you for [damage]")
				owner.client.chat("log", "[src] hit [m.name] for [damage]")

			Destroy()

		else
			return

	proc
		type_ok(target_type)
			for(var/t in blocked_target_types)
				if(istype(target_type,t)) return FALSE
			for(var/t in valid_target_types)
				if(istype(target_type, t)) return TRUE
			return FALSE

		validate(mob/caster, atom/target)
			if(!target)
				return "Nothing there."
			if(!type_ok(target.type))
				return "You can't target that with  [name]."
			if(world.time < caster.spell_cooldown(type))
				return "[src.name] no ready"
			if(get_dist(caster,target) > range)
				return "Not in range"
			return null

		// TODO: Not sure how to handle this (?)
		cast()
			return

		rotate_towards(Dir = dir)
			var/vector/spawn_direction = dir2vec(Dir)
			if(spawn_direction.x||spawn_direction.y)
				transform = matrix(atan2(spawn_direction), MATRIX_ROTATE)

		Destroy()
			if(src in Tickers)
				Tickers -= src
			owner = null
			auras = null
			Del()

		expired()
			return (world.time >= end_time)

		time_left()
			return end_time-start_time

		/**
		 * the arguments has to be calculated before passed as arg. Either one could be 0-1#INF, multiplied by damage_multiplier
		 *
		 * @param /list("attack" = 0, "reitsu" = 0)
		 */
		set_damage(alist/dam = null)
			if(isnull(dam))
				world.log << EXCEPTION("Couldn't find content inside dam")
				return
			else
				damage = (dam["PHYSICAL"] * damage_multiplier["PHYSICAL"]) + (dam["MAGIC"] * damage_multiplier["MAGIC"])

		movement_loop()

			Tickers += src

		on_move()
		// move_flag calls
		trail()
		detonate()


		calc_pixloc_from_bounds(pixloc/pl)


// ! Wide projectiles
// Needs adjusted bounds, as 3x1 icons has uneven edges.
spell/wide_projectile

	bound_x = 1
	bound_y = 3
	bound_width=96
	bound_height=22

	New(pixloc/where, Dir, mob/caster, time=world.time)
		var/vector/offset = vector(0,0)

		if(Dir & (EAST|WEST))
			offset.y = -32
		if(Dir & (NORTH|SOUTH))
			offset.x = -48

		where = pixloc(where, offset)

		..(where, Dir, caster, time)

	rotate_towards(Dir)

		var/vector/vDir = dir2vec(Dir)
		var/matrix/m = matrix(atan2(vDir), MATRIX_ROTATE)
		if(Dir & (EAST|WEST))
			m.Translate(-32,32)

			// * Make sure bounds are set.
			var/bh = bound_height
			bound_height = bound_width
			bound_width = bh

		else if(Dir & (NORTH|SOUTH))
			m.Translate(0,0)

		transform = m
