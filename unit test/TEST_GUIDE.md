# DreamMaker Fluent Test Framework

## Quick Start

```dm
test("test name").expect(value).to_equal(expected)
test_summary()  // Print results
```

## Basic Assertions

```dm
// Equality
expect(5).to_equal(5)
expect(list(1,2,3)).to_equal(list(1,2,3))

// Identity (type checking)
expect(obj).to_be(/type/path)

// Null
expect(null).to_be_null()
expect(value).not().to_be_null()

// Boolean
expect(TRUE).to_be_true()
expect(FALSE).to_be_false()
```

## Numeric Comparisons

```dm
expect(10).to_be_greater_than(5)
expect(3).to_be_less_than(10)
expect(5).to_be_at_least(5)
expect(5).to_be_at_most(5)
```

## Lists & Collections

```dm
expect(list(1, 2, 3)).to_contain(2)
expect(list(1, 2, 3)).to_have_length(3)

// Negation
expect(list(1, 2, 3)).not().to_contain(99)
```

## Game-Specific (Combat Focus)

### Health
```dm
expect(mob).to_have_health(100)
expect(mob).not().to_have_health(50)
```

### Status Effects
```dm
expect(mob).to_have_status(/datum/status_effect/stun)
expect(mob).to_have_buff(/datum/status_effect/haste)
expect(mob).to_have_debuff(/datum/status_effect/weakness)
```

### Cooldowns
```dm
ability.cooldown_until = world.time + 5000
expect(ability).to_be_on_cooldown()
```

## Negation

Chain `.not()` to negate any assertion:

```dm
expect(5).not().to_equal(10)
expect(mob).not().to_have_status(/datum/status_effect/stun)
expect(list()).not().to_have_length(5)
```

## Writing Tests

### Pattern: Arrange, Act, Assert

```dm
/proc/test_mob_damage()
	// ARRANGE
	var/mob/attacker = new /mob()
	var/mob/defender = new /mob()
	attacker.damage = 20
	defender.health = 100
	
	// ACT
	defender.take_damage(attacker, 20)
	
	// ASSERT
	test("damage applied").expect(defender).to_have_health(80)
	test_summary()
```

### Multiple Assertions in One Test

```dm
/proc/test_spell_cast()
	var/mob/caster = new /mob()
	var/obj/spell/s = new()
	
	test("spell validation")
		.expect(s.damage).to_be_greater_than(0)
		.expect(s.cooldown).to_be_at_most(10000)
		.expect(caster).not().to_have_status(/datum/status_effect/silenced)
	
	test_summary()
```

## Tips

1. **One test per behavior** — test a single thing per `test()` call
2. **Clear names** — use descriptive test names (`test("health restored after potion")`)
3. **Game state isolation** — create fresh mobs/objects for each test
4. **Fluent chaining** — build readable assertions without temp variables
5. **Negation clarity** — `expect(x).not().to_equal(y)` reads better than `expect(x != y)`

## Running Tests

Add to your world startup or call manually:

```dm
world/New()
	..()
	test_combat_suite()  // Or your own test proc
```

## Common Game Assertions Checklist

- [ ] Damage applied correctly
- [ ] Health clamped at 0 (no negatives)
- [ ] Effects apply/remove properly
- [ ] Cooldowns work
- [ ] Scaling calculations correct
- [ ] Stat bonuses stack
- [ ] Dead mobs can't act
- [ ] Immune mobs take no damage
- [ ] Buff/debuff durations expire

## Extending the Framework

Add custom assertions by extending `/test/assertion`:

```dm
/test/assertion
	proc/to_be_alive()
		if((value.health > 0) != negated)
			return pass("[value] is alive")
		return fail("[value] is dead")
```

Then use:
```dm
expect(mob).to_be_alive()
```
