# Custom Matchers Reference

## Aura Matchers

```dm
expect(mob).to_have_aura(/datum/aura/spell_haste)
expect(mob).not().to_have_aura(/datum/aura/stun)

expect(mob).to_have_aura_stacks(/datum/aura/poison, 3)
expect(mob).to_have_aura_at_max()

expect(aura_obj).to_trigger_aura_on("spell_cast")
expect(aura_obj).to_trigger_aura_on("on_damage_taken")

expect(mob).to_have_aura_damage_mod(1.2)  // 20% increase
```

### Common Aura Trigger Types
- `"spell_cast"` — When caster casts a spell
- `"on_damage_dealt"` — When dealing damage
- `"on_damage_taken"` — When taking damage
- `"on_heal"` — When healed
- `"on_crit"` — When crit occurs
- `"on_effect_applied"` — When status applied

---

## Event Subscription Matchers

```dm
expect(mob).to_be_subscribed_to("combat_start")
expect(mob).not().to_be_subscribed_to("world_event")

expect(event_manager).to_have_subscribers("on_damage_taken", 3)
expect(event_manager).to_have_subscribers("spell_cast", 0)

expect(event_manager).to_have_fired_event("on_damage_taken")
expect(event_manager).not().to_have_fired_event("nonexistent_event")

expect(event_manager).to_have_fired_event_times("on_damage_taken", 5)
```

### Common Event Types
- `"combat_start"` / `"combat_end"`
- `"on_damage_dealt"` / `"on_damage_taken"`
- `"on_heal"` / `"on_hurt"`
- `"spell_cast"` / `"ability_used"`
- `"effect_applied"` / `"effect_removed"`
- `"on_kill"` / `"on_death"`

---

## Combat Event Matchers

```dm
expect(attacker).to_have_dealt_damage(25)
expect(attacker).to_have_dealt_damage(30)

expect(defender).to_have_mitigated_damage(10)
expect(defender).not().to_have_mitigated_damage(0)

expect(mob).to_have_triggered_effect(/datum/status_effect/bleed)
expect(mob).not().to_have_triggered_effect(/datum/aura/thorns)

expect(attacker).to_have_chain_reaction(3)  // 3 events in chain
```

---

## Mob State Matchers

```dm
// Combat readiness
expect(mob).to_be_able_to_act()
expect(stunned_mob).not().to_be_able_to_act()

expect(mob).to_be_in_combat()
expect(resting_mob).not().to_be_in_combat()

expect(mob).to_be_under_threat()
expect(safe_mob).not().to_be_under_threat()

// Stats
expect(warrior).to_have_stat("strength", 18)
expect(wizard).to_have_stat("intelligence", 16)
expect(rogue).to_have_stat("dexterity", 17)

// Available stats: "strength", "dexterity", "constitution", "intelligence"

// Equipment
expect(hero).to_have_equipped(/obj/weapon/sword)
expect(hero).not().to_have_equipped(/obj/armor/plate)

expect(hero).to_have_item_count(/obj/consumable/potion, 5)
expect(hero).to_have_item_count(/obj/gem, 0)
```

---

## Ability/Spell Matchers

```dm
// Casting state
expect(fireball).to_be_castable()
expect(ability_on_cd).not().to_be_castable()

// Resource costs
expect(fireball).to_cost("mana", 50)
expect(power_strike).to_cost("stamina", 30)
expect(magic_missile).to_cost("energy", 20)

// Properties
expect(fireball).to_have_range(15)
expect(smash).to_have_range(2)
```

---

## Matcher Patterns

### Setup → Act → Assert
```dm
/proc/test_aura_proc()
	// SETUP
	var/mob/target = new /mob()
	target.apply_aura(/datum/aura/weakness, 8000)
	
	// ACT
	target.take_damage(attacker, 20)
	
	// ASSERT
	test("weakness increases damage").expect(target).to_have_aura(/datum/aura/weakness)
	test("damage dealt").expect(attacker).to_have_dealt_damage(20)
	
	test_summary()
```

### Chain Testing Events
```dm
/proc/test_event_chain()
	var/datum/event/manager/em = new()
	var/mob/caster = new /mob()
	var/mob/target = new /mob()
	
	caster.subscribe_to_event("spell_cast", em)
	target.subscribe_to_event("on_damage_taken", em)
	
	// Fire the chain
	caster.cast_spell(/obj/spell/fireball, target)
	em.fire_event("spell_cast", list("caster" = caster))
	em.fire_event("on_damage_taken", list("target" = target))
	
	test("spell triggered").expect(em).to_have_fired_event("spell_cast")
	test("target took damage").expect(em).to_have_fired_event("on_damage_taken")
	test("events chained").expect(em).to_have_fired_event_times("spell_cast", 1)
	
	test_summary()
```

---

## Adding Custom Matchers

Add to `/test/assertion` proc list:

```dm
/test/assertion
	proc/to_be_enraged()
		if(!ismob(value))
			return fail("[value] is not a mob")
		var/mob/m = value
		if((m.rage_level >= 80) != negated)
			return pass("[value] is enraged")
		return fail("[value] rage: [m.rage_level]%")
```

Then use:
```dm
expect(warrior).to_be_enraged()
```

---

## Testing Patterns for Your Systems

### Pattern 1: Aura Stack Gameplay
```dm
/proc/test_poison_stacking()
	var/mob/poisoned = new /mob()
	
	// Apply same aura multiple times
	for(var/i in 1 to 5)
		poisoned.apply_aura(/datum/aura/poison, 10000)
	
	test("poison stacked").expect(poisoned).to_have_aura_stacks(/datum/aura/poison, 5)
	test("poison active").expect(poisoned).to_have_aura(/datum/aura/poison)
	
	test_summary()
```

### Pattern 2: Event-Driven Reactions
```dm
/proc/test_proc_chain()
	var/datum/event/manager/em = new()
	var/mob/fighter = new /mob()
	var/datum/aura/thorns/t = new()
	
	fighter.apply_aura(t, 10000)
	fighter.subscribe_to_event("on_damage_taken", em)
	
	// Simulate: fighter takes damage
	fighter.take_damage(attacker, 20)
	em.fire_event("on_damage_taken", list("target" = fighter, "damage" = 20))
	
	// Thorns procs and reflects
	test("thorns triggered on damage").expect(fighter).to_have_triggered_effect(/datum/aura/thorns)
	
	test_summary()
```

### Pattern 3: Combat Stat Checks
```dm
/proc/test_buff_stat_changes()
	var/mob/warrior = new /mob()
	warrior.strength = 10
	
	test("base strength").expect(warrior).to_have_stat("strength", 10)
	
	warrior.apply_buff(/datum/buff/strength_boost)  // +6
	test("buffed strength").expect(warrior).to_have_stat("strength", 16)
	
	test_summary()
```

---

## Checklist: What to Test

### Auras
- [ ] Aura applies to mob
- [ ] Aura stacks correctly
- [ ] Max stacks enforced
- [ ] Aura expires properly
- [ ] Aura triggers correct events
- [ ] Multiple auras coexist
- [ ] Aura mods stack/multiply correctly

### Events
- [ ] Subscription created
- [ ] Event manager tracks subscribers
- [ ] Event fires
- [ ] Event payload correct
- [ ] Unsubscribe removes listener
- [ ] Event fires correct number of times
- [ ] Multiple subscribers all receive

### Combat
- [ ] Damage calculated correctly
- [ ] Mitigation applied
- [ ] Overkill handled
- [ ] Chain reactions trigger
- [ ] Procs fire from auras
- [ ] Combat state tracked
- [ ] Cooldowns enforced

