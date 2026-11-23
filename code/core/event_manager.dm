/*    		EVENTS


raise_event("receive_damage", 	list(src, attacker, damage, damage_type))
raise_event("respawn", 			list(src, world.time))
raise_event("died", 			list(src, world.time))
raise_event("leave_combat", 	list(src, world.time))
raise_event("enter_combat", 	list(src, world.time))
raise_event("aura_applied", 	list(src, new_aura))
raise_event("aura_removed", 	list(src, new_aura))
raise_event("health_changed",	 list(src, hp, max_hp))


*/

callback
	var
		source
		callback

	New(s, cb)
		source=s
		callback = cb

	proc
		Invoke(list/arg_list)
			// if source is no longer available...
			// Skip current, and let gc do it's work.
			if(!source)
				return

			if(!hascall(source, callback))
				return

			if(arg_list.len)
				call(source, callback)(arg_list)
			else
				call(source,callback)()


// ============================================================
// EVENT MANAGER — generic pub/sub bus for combat events
//
// Design goals:
//  - The manager holds NO references to mobs or combat data.
//    It only stores /datum/callback objects, which are owned
//    and created by the subscribers themselves.
//  - Mobs/data are passed purely through proc arguments when
//    an event is raised (raise_event), never stored.
//
// ============================================================
//  HOW TO USE:
//
//	Raise events:
//
//	aura
//		var/mob/owner
//		var/datum/callback/heal_cb
//
//		thorns_of_renewal
//			proc/apply_to(mob/M)
//				owner = M
//				heal_cb = CALLBACK(src, .proc/on_heal)
//				GetEventManager().subscribe("receive_healing", heal_cb)
//
//			proc/on_heal(mob/target, amount, mob/source)
//				if(target != owner)
//					return // this event fired for someone else's heal; ignore it
//				target.visible_message("[target] glows briefly as the healing takes hold.")
//
//
//
// ============================================================

event_manager

	var

		// event name (string) -> list of /datum/callback
		list/subscribers = list()

	proc
		subscribe(event, callback/cb)
			if(!istype(cb))
				return
			if(!subscribers[event])
				subscribers[event] = list()
			subscribers[event] += cb

		unsubsribe(event, callback/cb)
			var/list/l = subscribers[event]
			if(!l)
				return
			l -= cb
			if(!length(l))
				subscribers -= event

		// event_args: plain list of whatever data the event needs to pass along.
		// -> list(attacker_mob, defener_mob, amount)
		raise_event(event, list/event_args)
			var/list/l = subscribers[event]
			if(!l || !length(l))
				return

			// copy, to prevent unwanted unsubs mid-iteration.
			// prevents fuckups from list.len changes
			var/list/to_call = l.Copy()

			for(var/callback/cb in to_call)
				if(event_args)
					cb.Invoke(arglist(event_args))
				else
					cb.Invoke()

// instanciation of the manager.
var/event_manager/event_manager
proc/GetEventManager()
	if(!event_manager)
		event_manager = new/event_manager()
	return event_manager