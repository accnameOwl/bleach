// ============================================================================
// CUSTOM MATCHERS - Auras, Events, Combat Systems
// ============================================================================

// ============================================================================
// AURA MATCHERS
// ============================================================================

/test/assertion
	
	// Check if mob has an active aura
	proc/to_have_aura(aura_type)
		if(!ismob(value))
			return fail("[value] is not a mob")
		var/mob/m = value
		var/has_aura = FALSE
		for(var/datum/aura/a in m.auras)
			if(istype(a, aura_type))
				has_aura = TRUE
				break
		if(has_aura != negated)
			return pass("has [aura_type]")
		var/auras_list = ""
		for(var/datum/aura/a in m.auras)
			auras_list += "[a:type], "
		var/desc = "expected [aura_type] but [value] has: [auras_list || "no auras"]"
		if(negated) desc = "expected NOT [aura_type] but [value] has it"
		return fail(desc)

	// Check aura stack count
	proc/to_have_aura_stacks(aura_type, expected_stacks)
		if(!ismob(value))
			return fail("[value] is not a mob")
		var/mob/m = value
		var/datum/aura/target_aura = null
		for(var/datum/aura/a in m.auras)
			if(istype(a, aura_type))
				target_aura = a
				break
		if(!target_aura)
			return fail("expected [aura_type] on [value] but not found (has: [m.auras])")
		if((target_aura.stacks == expected_stacks) != negated)
			return pass("[aura_type] has [expected_stacks] stacks")
		var/desc = "expected [aura_type] to have [expected_stacks] stacks but has [target_aura.stacks]"
		if(negated) desc = "expected [aura_type] NOT to have [expected_stacks] stacks but it does"
		return fail(desc)

	// Check if aura is at max stacks
	proc/to_have_aura_at_max()
		if(!ismob(value))
			return fail("[value] is not a mob")
		var/mob/m = value
		var/is_maxed = FALSE
		var/max_aura_info = ""
		for(var/datum/aura/a in m.auras)
			max_aura_info += "[a:type] ([a.stacks]/[a.max_stacks]), "
			if(a.stacks >= a.max_stacks)
				is_maxed = TRUE
		if(is_maxed != negated)
			return pass("aura at max stacks")
		var/desc = "expected aura at max stacks but found: [max_aura_info || "no auras"]"
		if(negated) desc = "expected aura NOT at max but some are: [max_aura_info]"
		return fail(desc)

	// Check if aura would trigger on condition
	proc/to_trigger_aura_on(trigger_type)
		if(!istype(value, /datum/aura))
			return fail("[value] is not an aura (got [value:type])")
		var/datum/aura/a = value
		if((a.trigger_type == trigger_type) != negated)
			return pass("triggers on [trigger_type]")
		var/desc = "expected aura to trigger on [trigger_type] but triggers on [a.trigger_type]"
		if(negated) desc = "expected aura NOT to trigger on [trigger_type] but it does"
		return fail(desc)

	// Check aura damage multiplier
	proc/to_have_aura_damage_mod(expected_mod)
		if(!ismob(value))
			return fail("[value] is not a mob")
		var/mob/m = value
		var/total_mod = 1
		var/breakdown = ""
		for(var/datum/aura/a in m.auras)
			if(a.damage_multiplier)
				breakdown += "[a:type]=[a.damage_multiplier]x, "
				total_mod *= a.damage_multiplier
		if((total_mod == expected_mod) != negated)
			return pass("aura damage mod is [expected_mod]")
		var/desc = "expected damage mod [expected_mod] but got [total_mod] (from: [breakdown || "no mods"])"
		if(negated) desc = "expected damage mod NOT [expected_mod] but got [total_mod]"
		return fail(desc)

// ============================================================================
// EVENT SUBSCRIPTION MATCHERS
// ============================================================================

/test/assertion

	// Check if object is subscribed to an event
	proc/to_be_subscribed_to(event_type)
		if(!value || !value.subscriptions)
			return fail("[value] has no subscription tracking")
		var/is_subscribed = FALSE
		for(var/sub in value.subscriptions)
			if(sub == event_type)
				is_subscribed = TRUE
				break
		if(is_subscribed != negated)
			return pass("subscribed to [event_type]")
		var/subs_list = ""
		for(var/sub in value.subscriptions)
			subs_list += "[sub], "
		var/desc = "expected subscription to [event_type] but subscribed to: [subs_list || "nothing"]"
		if(negated) desc = "expected NOT subscribed to [event_type] but is"
		return fail(desc)

	// Check if event manager has active subscribers
	proc/to_have_subscribers(event_type, count)
		if(!istype(value, /datum/event/manager))
			return fail("[value] is not an event manager")
		var/datum/event/manager/em = value
		var/sub_count = 0
		if(em.subscriptions && em.subscriptions[event_type])
			sub_count = length(em.subscriptions[event_type])
		if((sub_count == count) != negated)
			return pass("[event_type] has [sub_count] subscribers")
		var/all_events = ""
		if(em.subscriptions)
			for(var/evt in em.subscriptions)
				all_events += "[evt]=[length(em.subscriptions[evt])], "
		var/desc = "expected [event_type] to have [count] subscribers but has [sub_count] (all: [all_events || "no events"])"
		if(negated) desc = "expected [event_type] NOT to have [count] subscribers but does"
		return fail(desc)

	// Check if event was fired (assumes event log exists)
	proc/to_have_fired_event(event_type)
		if(!istype(value, /datum/event/manager))
			return fail("[value] is not an event manager")
		var/datum/event/manager/em = value
		var/was_fired = FALSE
		if(em.event_log)
			for(var/logged_event in em.event_log)
				if(logged_event == event_type)
					was_fired = TRUE
					break
		if(was_fired != negated)
			return pass("[event_type] was fired")
		var/log_list = ""
		if(em.event_log)
			for(var/evt in em.event_log)
				log_list += "[evt], "
		var/desc = "expected [event_type] to be fired but log shows: [log_list || "no events"]"
		if(negated) desc = "expected [event_type] NOT to be fired but it was"
		return fail(desc)

	// Check event fire count
	proc/to_have_fired_event_times(event_type, expected_count)
		if(!istype(value, /datum/event/manager))
			return fail("[value] is not an event manager")
		var/datum/event/manager/em = value
		var/fire_count = 0
		if(em.event_log)
			for(var/logged_event in em.event_log)
				if(logged_event == event_type)
					fire_count++
		if((fire_count == expected_count) != negated)
			return pass("[event_type] fired [fire_count] times")
		var/desc = "expected [event_type] to fire [expected_count] times but fired [fire_count] times"
		if(negated) desc = "expected [event_type] NOT to fire [expected_count] times but did"
		return fail(desc)

// ============================================================================
// COMBAT EVENT MATCHERS
// ============================================================================

/test/assertion

	// Check if last damage event properties
	proc/to_have_dealt_damage(expected_amount)
		if(!ismob(value))
			return fail("[value] is not a mob")
		var/mob/m = value
		if(!m.last_damage_dealt)
			return fail("[value] has no recorded damage (no attacks made)")
		if((m.last_damage_dealt == expected_amount) != negated)
			return pass("dealt [expected_amount] damage")
		var/desc = "expected [value] to deal [expected_amount] damage but dealt [m.last_damage_dealt]"
		if(negated) desc = "expected [value] NOT to deal [expected_amount] damage but did"
		return fail(desc)

	// Check if damage was mitigated/reduced
	proc/to_have_mitigated_damage(expected_reduction)
		if(!ismob(value))
			return fail("[value] is not a mob")
		var/mob/m = value
		if(m.last_damage_mitigated == null)
			return fail("[value] has no mitigation recorded (no damage taken)")
		if((m.last_damage_mitigated == expected_reduction) != negated)
			return pass("mitigated [expected_reduction] damage")
		var/desc = "expected [value] to mitigate [expected_reduction] damage but mitigated [m.last_damage_mitigated]"
		if(negated) desc = "expected [value] NOT to mitigate [expected_reduction] damage but did"
		return fail(desc)

	// Check if effect was triggered by an event
	proc/to_have_triggered_effect(effect_type)
		if(!ismob(value))
			return fail("[value] is not a mob")
		var/mob/m = value
		var/was_triggered = FALSE
		if(m.triggered_effects)
			for(var/eff in m.triggered_effects)
				if(eff == effect_type)
					was_triggered = TRUE
					break
		if(was_triggered != negated)
			return pass("[effect_type] triggered")
		var/triggered_list = ""
		if(m.triggered_effects)
			for(var/eff in m.triggered_effects)
				triggered_list += "[eff], "
		var/desc = "expected [effect_type] to be triggered but triggered: [triggered_list || "nothing"]"
		if(negated) desc = "expected [effect_type] NOT to be triggered but was"
		return fail(desc)

	// Check if a chained action occurred (A hit B, B triggered C)
	proc/to_have_chain_reaction(expected_chain_length)
		if(!ismob(value))
			return fail("[value] is not a mob")
		var/mob/m = value
		var/chain_length = m.last_action_chain ? length(m.last_action_chain) : 0
		if((chain_length == expected_chain_length) != negated)
			return pass("chain reaction with [chain_length] events")
		var/chain_info = ""
		if(m.last_action_chain)
			for(var/action in m.last_action_chain)
				chain_info += "[action], "
		var/desc = "expected chain reaction of [expected_chain_length] events but got [chain_length] (chain: [chain_info || "none"])"
		if(negated) desc = "expected chain reaction NOT of [expected_chain_length] events but was"
		return fail(desc)

// ============================================================================
// MOB STATE MATCHERS
// ============================================================================

/test/assertion

	// Check if mob can act (not stunned, silenced, incapacitated)
	proc/to_be_able_to_act()
		if(!ismob(value))
			return fail("[value] is not a mob")
		var/mob/m = value
		var/can_act = !m.stunned && !m.silenced && m.health > 0
		if(can_act != negated)
			return pass("can act")
		var/reasons = ""
		if(m.stunned) reasons += "stunned, "
		if(m.silenced) reasons += "silenced, "
		if(m.health <= 0) reasons += "dead (health: [m.health]), "
		var/desc = "expected [value] able to act but: [reasons || "unknown reason"]"
		if(negated) desc = "expected [value] NOT able to act but can"
		return fail(desc)

	// Check if mob is in combat
	proc/to_be_in_combat()
		if(!ismob(value))
			return fail("[value] is not a mob")
		var/mob/m = value
		var/in_combat = m.combat_target != null && m.last_combat_time > (world.time - 30000)
		if(in_combat != negated)
			return pass("in combat with [m.combat_target]")
		var/time_since = m.last_combat_time ? (world.time - m.last_combat_time) : "never"
		var/desc = "expected [value] in combat but target=[m.combat_target], last combat [time_since]ms ago"
		if(negated) desc = "expected [value] NOT in combat but is"
		return fail(desc)

	// Check if mob is under threat (has active damage dealers)
	proc/to_be_under_threat()
		if(!ismob(value))
			return fail("[value] is not a mob")
		var/mob/m = value
		var/threat_count = m.aggro_list ? length(m.aggro_list) : 0
		var/under_threat = threat_count > 0
		if(under_threat != negated)
			return pass("under threat from [threat_count] enemies")
		var/desc = "expected [value] under threat but aggro_list is empty"
		if(negated) desc = "expected [value] NOT under threat but has [threat_count] aggressors"
		return fail(desc)

	// Check stat value
	proc/to_have_stat(stat_name, expected_value)
		if(!ismob(value))
			return fail("[value] is not a mob")
		var/mob/m = value
		var/stat_value = 0
		switch(stat_name)
			if("strength")
				stat_value = m.strength
			if("dexterity")
				stat_value = m.dexterity
			if("constitution")
				stat_value = m.constitution
			if("intelligence")
				stat_value = m.intelligence
			else
				return fail("unknown stat: [stat_name]")
		if((stat_value == expected_value) != negated)
			return pass("[stat_name] = [expected_value]")
		var/desc = "expected [stat_name]=[expected_value] but [value] has [stat_value]"
		if(negated) desc = "expected [stat_name] NOT [expected_value] but is"
		return fail(desc)

	// Check equipped item
	proc/to_have_equipped(item_type)
		if(!ismob(value))
			return fail("[value] is not a mob")
		var/mob/m = value
		var/has_item = FALSE
		for(var/obj/item/i in m.equipment)
			if(istype(i, item_type))
				has_item = TRUE
				break
		if(has_item != negated)
			return pass("equipped [item_type]")
		var/equipped_list = ""
		if(m.equipment)
			for(var/obj/item/i in m.equipment)
				equipped_list += "[i:type], "
		var/desc = "expected [value] to have equipped [item_type] but has: [equipped_list || "nothing"]"
		if(negated) desc = "expected [value] NOT to have [item_type] equipped but does"
		return fail(desc)

	// Check inventory item count
	proc/to_have_item_count(item_type, expected_count)
		if(!ismob(value))
			return fail("[value] is not a mob")
		var/mob/m = value
		var/count = 0
		for(var/obj/item/i in m.inventory)
			if(istype(i, item_type))
				count += i.quantity || 1
		if((count == expected_count) != negated)
			return pass("[item_type] count = [expected_count]")
		var/desc = "expected [item_type] count=[expected_count] but [value] has [count]"
		if(negated) desc = "expected [item_type] count NOT [expected_count] but is"
		return fail(desc)

// ============================================================================
// SPELL/ABILITY MATCHERS
// ============================================================================

/test/assertion

	// Check if ability can be cast (not on cooldown, has resources)
	proc/to_be_castable()
		if(!istype(value, /obj/ability))
			return fail("[value] is not an ability (got [value:type])")
		var/obj/ability/a = value
		var/time_left = a.cooldown_until ? (a.cooldown_until - world.time) : 0
		var/can_cast = !a.cooldown_until || a.cooldown_until <= world.time
		if(can_cast != negated)
			return pass("castable")
		var/desc = "expected ability castable but on cooldown for [time_left]ms"
		if(negated) desc = "expected ability NOT castable but is"
		return fail(desc)

	// Check ability resource cost
	proc/to_cost(resource_name, expected_amount)
		if(!istype(value, /obj/ability))
			return fail("[value] is not an ability")
		var/obj/ability/a = value
		var/cost = 0
		switch(resource_name)
			if("mana")
				cost = a.mana_cost
			if("energy")
				cost = a.energy_cost
			if("stamina")
				cost = a.stamina_cost
			else
				return fail("unknown resource: [resource_name]")
		if((cost == expected_amount) != negated)
			return pass("[resource_name] cost = [expected_amount]")
		var/desc = "expected [resource_name] cost [expected_amount] but is [cost]"
		if(negated) desc = "expected [resource_name] cost NOT [expected_amount] but is"
		return fail(desc)

	// Check ability range
	proc/to_have_range(expected_range)
		if(!istype(value, /obj/ability))
			return fail("[value] is not an ability")
		var/obj/ability/a = value
		if((a.range == expected_range) != negated)
			return pass("range = [expected_range]")
		var/desc = "expected range [expected_range] but ability has range [a.range]"
		if(negated) desc = "expected range NOT [expected_range] but is"
		return fail(desc)
