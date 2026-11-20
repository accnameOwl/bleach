// ============================================================================
// CUSTOM MATCHER EXAMPLES
// ============================================================================

/proc/test_aura_system()
	world << "\n[repeat("=", 50)]"
	world << "AURA SYSTEM TESTS"
	world << "[repeat("=", 50)]"
	
	var/mob/mage = new /mob()
	
	// No auras initially
	test("no auras at start").expect(mage.auras).to_have_length(0)
	
	// Apply an aura
	mage.apply_aura(/datum/aura/spell_haste, 10000)
	test("aura applied").expect(mage).to_have_aura(/datum/aura/spell_haste)
	
	// Apply same aura again (stack)
	mage.apply_aura(/datum/aura/spell_haste, 10000)
	test("aura stacked").expect(mage).to_have_aura_stacks(/datum/aura/spell_haste, 2)
	
	// Apply different aura
	mage.apply_aura(/datum/aura/mana_regen, 8000)
	test("multiple auras").expect(mage.auras).to_have_length(2)
	
	// Check aura properties
	for(var/datum/aura/a in mage.auras)
		if(istype(a, /datum/aura/spell_haste))
			test("haste triggers on cast").expect(a).to_trigger_aura_on("spell_cast")
	
	test_summary()


/proc/test_event_subscription()
	world << "\n[repeat("=", 50)]"
	world << "EVENT SUBSCRIPTION TESTS"
	world << "[repeat("=", 50)]"
	
	var/datum/event/manager/em = new()
	var/mob/subscriber = new /mob()
	
	// Subscribe to event
	subscriber.subscribe_to_event("combat_start", em)
	test("subscribed to event").expect(subscriber).to_be_subscribed_to("combat_start")
	
	// Event manager tracks subscribers
	test("manager tracks subscriber").expect(em).to_have_subscribers("combat_start", 1)
	
	// Add another subscriber
	var/mob/subscriber2 = new /mob()
	subscriber2.subscribe_to_event("combat_start", em)
	test("multiple subscribers").expect(em).to_have_subscribers("combat_start", 2)
	
	// Fire an event
	em.fire_event("combat_start", list("attacker" = subscriber, "defender" = subscriber2))
	test("event was fired").expect(em).to_have_fired_event("combat_start")
	
	// Fire event multiple times
	em.fire_event("combat_start", list("attacker" = subscriber, "defender" = subscriber2))
	em.fire_event("combat_start", list("attacker" = subscriber2, "defender" = subscriber))
	test("event fire count").expect(em).to_have_fired_event_times("combat_start", 3)
	
	test_summary()


/proc/test_event_driven_auras()
	world << "\n[repeat("=", 50)]"
	world << "EVENT-DRIVEN AURA TESTS"
	world << "[repeat("=", 50)]"
	
	var/datum/event/manager/em = new()
	var/mob/attacker = new /mob()
	var/mob/defender = new /mob()
	
	// Setup: Attacker has a thorns aura that triggers on being hit
	attacker.apply_aura(/datum/aura/thorns, 10000)
	test("thorns aura active").expect(attacker).to_have_aura(/datum/aura/thorns)
	
	// Setup: Defender subscribes to damage events
	defender.subscribe_to_event("on_damage_taken", em)
	test("defender subscribed").expect(defender).to_be_subscribed_to("on_damage_taken")
	
	// ACT: Defender attacks attacker
	attacker.take_damage(defender, 20)
	em.fire_event("on_damage_taken", list("target" = attacker, "damage" = 20))
	
	// ASSERT: Thorns aura triggers reflection
	test("thorns triggered").expect(attacker).to_have_triggered_effect(/datum/aura/thorns)
	test("damage event fired").expect(em).to_have_fired_event("on_damage_taken")
	
	test_summary()


/proc/test_damage_chain_reactions()
	world << "\n[repeat("=", 50)]"
	world << "DAMAGE CHAIN REACTION TESTS"
	world << "[repeat("=", 50)]"
	
	var/mob/attacker = new /mob()
	var/mob/defender = new /mob()
	
	attacker.damage = 25
	defender.health = 100
	
	// Simple damage
	defender.take_damage(attacker, 25)
	test("damage dealt").expect(attacker).to_have_dealt_damage(25)
	
	// With mitigation (armor/resistance)
	defender.defense = 10
	var/before_mitigation = 25
	var/after_mitigation = before_mitigation - defender.defense
	defender.take_damage(attacker, before_mitigation)
	test("damage mitigated").expect(defender).to_have_mitigated_damage(10)
	
	// Chain: A hits B, B procs on-hit effect that hits C
	var/mob/third = new /mob()
	attacker.trigger_chain_reaction(list(defender, third))
	test("chain reaction").expect(attacker).to_have_chain_reaction(3)  // attacker -> defender -> third
	
	test_summary()


/proc/test_combat_state()
	world << "\n[repeat("=", 50)]"
	world << "COMBAT STATE TESTS"
	world << "[repeat("=", 50)]"
	
	var/mob/fighter = new /mob()
	fighter.health = 100
	
	// Can act normally
	test("can act at start").expect(fighter).to_be_able_to_act()
	
	// Apply stun
	fighter.apply_effect(/datum/status_effect/stun, 5000)
	test("stunned cannot act").expect(fighter).not().to_be_able_to_act()
	
	// Remove stun
	fighter.remove_effect(/datum/status_effect/stun)
	test("can act after stun removed").expect(fighter).to_be_able_to_act()
	
	// Take lethal damage
	fighter.take_damage(null, 150)
	test("dead cannot act").expect(fighter).not().to_be_able_to_act()
	
	test_summary()


/proc/test_combat_engagement()
	world << "\n[repeat("=", 50)]"
	world << "COMBAT ENGAGEMENT TESTS"
	world << "[repeat("=", 50)]"
	
	var/mob/fighter1 = new /mob()
	var/mob/fighter2 = new /mob()
	
	// Not in combat at start
	test("not in combat initially").expect(fighter1).not().to_be_in_combat()
	
	// Enter combat
	fighter1.combat_target = fighter2
	fighter1.last_combat_time = world.time
	test("in combat after engagement").expect(fighter1).to_be_in_combat()
	
	// Not under threat initially
	test("no threat initially").expect(fighter1).not().to_be_under_threat()
	
	// Add aggro
	fighter1.aggro_list = list(fighter2)
	test("under threat").expect(fighter1).to_be_under_threat()
	
	test_summary()


/proc/test_stat_system()
	world << "\n[repeat("=", 50)]"
	world << "STAT SYSTEM TESTS"
	world << "[repeat("=", 50)]"
	
	var/mob/warrior = new /mob()
	warrior.strength = 18
	warrior.dexterity = 14
	warrior.constitution = 16
	
	test("strength stat").expect(warrior).to_have_stat("strength", 18)
	test("dexterity stat").expect(warrior).to_have_stat("dexterity", 14)
	test("constitution stat").expect(warrior).to_have_stat("constitution", 16)
	
	// Buff changes stat
	warrior.apply_buff(/datum/buff/strength_boost)
	test("stat buffed").expect(warrior).to_have_stat("strength", 24)
	
	test_summary()


/proc/test_equipment_system()
	world << "\n[repeat("=", 50)]"
	world << "EQUIPMENT SYSTEM TESTS"
	world << "[repeat("=", 50)]"
	
	var/mob/hero = new /mob()
	var/obj/weapon/sword = new()
	var/obj/armor/chest = new()
	
	// Equip items
	hero.equip(sword)
	hero.equip(chest)
	
	test("sword equipped").expect(hero).to_have_equipped(/obj/weapon)
	test("armor equipped").expect(hero).to_have_equipped(/obj/armor)
	
	// Unequip
	hero.unequip(sword)
	test("sword unequipped").expect(hero).not().to_have_equipped(/obj/weapon/sword)
	
	test_summary()


/proc/test_ability_system()
	world << "\n[repeat("=", 50)]"
	world << "ABILITY SYSTEM TESTS"
	world << "[repeat("=", 50)]"
	
	var/obj/ability/fireball = new()
	fireball.mana_cost = 50
	fireball.range = 15
	fireball.cooldown_until = 0
	
	// Ability properties
	test("mana cost").expect(fireball).to_cost("mana", 50)
	test("range").expect(fireball).to_have_range(15)
	
	// Can cast when ready
	test("castable at start").expect(fireball).to_be_castable()
	
	// On cooldown after cast
	fireball.cooldown_until = world.time + 3000
	test("not castable on cooldown").expect(fireball).not().to_be_castable()
	
	// Ready after cooldown expires
	fireball.cooldown_until = world.time - 1
	test("castable after cooldown").expect(fireball).to_be_castable()
	
	test_summary()


/proc/test_full_custom_suite()
	world << "\n"
	world << "╔════════════════════════════════════════════════════════╗"
	world << "║         RUNNING FULL CUSTOM MATCHER TEST SUITE        ║"
	world << "╚════════════════════════════════════════════════════════╝"
	
	test_aura_system()
	test_event_subscription()
	test_event_driven_auras()
	test_damage_chain_reactions()
	test_combat_state()
	test_combat_engagement()
	test_stat_system()
	test_equipment_system()
	test_ability_system()
