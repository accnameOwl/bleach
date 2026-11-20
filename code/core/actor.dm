
atom/movable
	proc
		on_crossed(atom/movable/a)
		on_uncrossed(atom/movable/a)
		on_bump(mob/m, time = world.time)

	Crossed(atom/movable/a)
		..(a)
		on_crossed(a)
		// NOTE: calls on 'a', if 'a' is petal and succesfully crosses with src.
		// This fixes an issue, where you don't need to override to much in /actor/petal/Move()
		if(istype(a, /actor/pedal))
			a.on_crossed(src)
	Uncrossed(atom/movable/a)
		..(a)
		a.on_crossed(src)

actor

	parent_type = /mob



mob
	// acts upon mouseclick from Client.
	// acts as arena for shit like petals, knives, sand, etc.
	var/tmp/list/actor_mouseclick_objects = list()

client
	Click(obj, loc, control, params)
	//	if(race == "Shinigami" && in_shikai)
	//		return
		..(obj, loc, control, params)

	DblClick(obj, loc, control, params)
		..(obj, loc, control, params)

actor/pedal


