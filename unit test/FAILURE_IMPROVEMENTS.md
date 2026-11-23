# Detailed Test Failure Descriptions

All test assertions now provide clear, descriptive error messages that tell you what went wrong and why.

## Pattern: "Expected X but got Y"

Every failure follows the pattern:
```
✗ [matcher name] - expected [X] but [Y]
```

### Examples

```dm
test("health").expect(player).to_have_health(100)
// ✗ expected health 100 but player_1 has 80

test("stat").expect(warrior).to_have_stat("strength", 20)
// ✗ expected strength=20 but warrior has 15

test("damage").expect(attacker).to_have_dealt_damage(50)
// ✗ expected attacker to deal 50 damage but dealt 30
```

---

## Context-Aware Failures

When something is missing, the framework shows you what IS there:

### Status Effects
```dm
test("stun").expect(mob).to_have_status(/datum/status_effect/stun)
// ✗ expected /datum/status_effect/stun but mob has: 
//   /datum/status_effect/weakness, /datum/status_effect/slow
```

### Auras
```dm
test("haste aura").expect(mage).to_have_aura(/datum/aura/spell_haste)
// ✗ expected /datum/aura/spell_haste but mage has: 
//   /datum/aura/mana_regen, /datum/aura/crit_chance
```

### Equipment
```dm
test("sword equipped").expect(hero).to_have_equipped(/obj/weapon/sword)
// ✗ expected hero to have equipped /obj/weapon/sword but has: 
//   /obj/armor/chest, /obj/ring/ruby
```

### Events
```dm
test("damage event").expect(manager).to_have_fired_event("on_damage_taken")
// ✗ expected on_damage_taken to be fired but log shows: 
//   spell_cast, buff_applied
```

---

## Why Things Failed

For complex states, failures explain the reason:

### Cannot Act (Shows All Reasons)
```dm
test("can act").expect(mob).to_be_able_to_act()
// ✗ expected mob able to act but: stunned, silenced, dead (health: -20)
```

### Combat Not Active
```dm
test("in combat").expect(fighter).to_be_in_combat()
// ✗ expected fighter in combat but target=null, last combat 45000ms ago
```

### Cooldown Still Active
```dm
test("ready").expect(spell).to_be_castable()
// ✗ expected ability castable but on cooldown for 2350ms
```

### Aura Stacks Wrong
```dm
test("stacked").expect(mob).to_have_aura_stacks(/datum/aura/poison, 3)
// ✗ expected /datum/aura/poison to have 3 stacks but has 2
```

---

## Negation Clarity

When using `.not()`, failures clearly state the negation:

```dm
test("no stun").expect(mob).not().to_have_status(/datum/status_effect/stun)
// ✗ expected NOT /datum/status_effect/stun but mob has it

test("low health").expect(player).not().to_be_able_to_act()
// ✗ expected player_1 NOT able to act but can
```

---

## Matchers With Detailed Failures

### Basic Assertions
| Matcher | Failure Message |
|---------|-----------------|
| `to_equal(X)` | expected X but got Y |
| `to_be_null()` | expected null but got X |
| `to_be_true()` | expected truthy value but got X |
| `to_contain(item)` | expected list to contain X |
| `to_have_length(N)` | expected length N but got M (list: [...]) |

### Game-Specific
| Matcher | Failure Message |
|---------|-----------------|
| `to_have_health(X)` | expected health X but mob has Y |
| `to_have_status(type)` | expected type but mob has: [list of effects] |
| `to_have_aura(type)` | expected type but mob has: [list of auras] |
| `to_have_aura_stacks(type, N)` | expected N stacks but has M |
| `to_be_on_cooldown()` | expected on cooldown but expired Xms ago |

### Combat/Events
| Matcher | Failure Message |
|---------|-----------------|
| `to_have_dealt_damage(X)` | expected to deal X but dealt Y |
| `to_have_triggered_effect(type)` | expected type triggered but: [list of triggered] |
| `to_have_chain_reaction(N)` | expected chain of N events but got M (chain: [...]) |
| `to_have_subscribers(event, N)` | expected N subscribers but has M (all: [...]) |
| `to_have_fired_event(event)` | expected event fired but log shows: [...] |

### Mob State
| Matcher | Failure Message |
|---------|-----------------|
| `to_be_able_to_act()` | expected able to act but: stunned, silenced, dead |
| `to_be_in_combat()` | expected in combat but target=null, last combat Xms ago |
| `to_be_under_threat()` | expected under threat but aggro_list empty |
| `to_have_stat(name, X)` | expected name=X but has Y |
| `to_have_equipped(type)` | expected type equipped but has: [...] |

### Abilities
| Matcher | Failure Message |
|---------|-----------------|
| `to_be_castable()` | expected castable but on cooldown for Xms |
| `to_cost(resource, X)` | expected resource cost X but is Y |
| `to_have_range(X)` | expected range X but has Y |

---

## Debugging with Detailed Failures

When a test fails, you get:

1. **What was expected** — The condition you wanted
2. **What actually happened** — The actual value/state
3. **Full context** — Lists of related items (effects, auras, etc)
4. **Explanation** — Why the condition failed (cooldown, missing effect, etc)

Example failure walkthrough:
```dm
test("thorns should trigger on damage").expect(defender).to_have_triggered_effect(/datum/aura/thorns)

// ✗ expected /datum/aura/thorns to be triggered but triggered: 
//   /datum/status_effect/bleed, /datum/aura/weakness

// This tells you:
// 1. You expected thorns to trigger
// 2. It didn't
// 3. But other effects DID trigger (bleed, weakness)
// 4. So thorns aura exists but didn't respond to the event
```

---

## How to Use These Failures

When a test fails:

1. **Read the expected value** — What should happen
2. **Read the actual value** — What actually happened  
3. **Check the context** — What else is there/happening
4. **Fix the issue** — Either your game logic or your test

Example fix workflows:

### Failure: Health not reduced after damage
```
✗ expected health 70 but player_1 has 80

WORKFLOW:
- Check if damage() was called correctly
- Check if mitigation is too high
- Check if there's a protection buff active
- Check if health clamping is preventing negative
```

### Failure: Effect not triggering
```
✗ expected /datum/aura/thorns triggered but triggered: [nothing]

WORKFLOW:
- Check if aura is subscribed to the right event
- Check if event_manager.fire_event() was called
- Check if aura trigger_type matches event
- Check if cooldown is preventing re-trigger
```

---

## Tips

- **Read the context** — When items are listed, they explain what's there
- **Multiple failures is OK** — Run all tests to see patterns
- **Negations are clear** — `.not()` always states the negation
- **Cooldown times are shown** — Helps debug timing issues
- **Effect lists help debugging** — See what buffs/debuffs are active

All failures now tell a story: what you wanted, what you got, and why it matters.
