// ============================================================================
// FAILURE OUTPUT EXAMPLES
// ============================================================================
// This shows what the improved test output looks like with descriptive failures

/*

EXAMPLE 1: Simple Value Mismatch
==========================================================
✗ damage calculated wrong - expected 50 but got 30

EXAMPLE 2: Health Assertion
==========================================================
✗ mob health after damage - expected health 70 but player_1 has 80

EXAMPLE 3: Effect Not Found
==========================================================
✗ stun applied - expected /datum/status_effect/stun but player_1 has: 
  /datum/status_effect/slow, /datum/status_effect/weakness

EXAMPLE 4: Aura Stack Mismatch
==========================================================
✗ poison stacked - expected /datum/aura/poison to have 3 stacks but has 2

EXAMPLE 5: Event Not Fired
==========================================================
✗ event fired - expected on_damage_taken to be fired but log shows: 
  spell_cast, buff_applied

EXAMPLE 6: Cooldown Timing
==========================================================
✗ ability ready - expected ability castable but on cooldown for 2350ms

EXAMPLE 7: Mob Cannot Act (Multiple Reasons)
==========================================================
✗ can act - expected player_1 able to act but: stunned, silenced, dead (health: -20)

EXAMPLE 8: Stat Mismatch
==========================================================
✗ strength check - expected strength=20 but warrior has 15

EXAMPLE 9: Event Count Mismatch
==========================================================
✗ event fired multiple times - expected on_hit to fire 3 times but fired 1 times

EXAMPLE 10: Equipment Missing
==========================================================
✗ sword equipped - expected player_1 to have equipped /obj/weapon/sword but has: 
  /obj/armor/chest, /obj/ring/ruby

*/

/proc/demo_detailed_failures()
	world << "\n"
	world << "╔════════════════════════════════════════════════════════╗"
	world << "║     DETAILED TEST FAILURE EXAMPLES                    ║"
	world << "╚════════════════════════════════════════════════════════╝"
	
	// Example 1: Simple math failure
	world << "\n[repeat("=", 50)]"
	world << "EXAMPLE 1: Math Calculation"
	world << "[repeat("=", 50)]"
	test("damage calc").expect(10 + 20).to_equal(50)
	test_summary()
	
	// Example 2: Health mismatch
	world << "\n[repeat("=", 50)]"
	world << "EXAMPLE 2: Health Assertion"
	world << "[repeat("=", 50)]"
	var/mob/player = new /mob()
	player.health = 80
	test("health check").expect(player).to_have_health(70)
	test_summary()
	
	// Example 3: Missing effect
	world << "\n[repeat("=", 50)]"
	world << "EXAMPLE 3: Effect Not Found"
	world << "[repeat("=", 50)]"
	var/mob/affected = new /mob()
	affected.apply_effect(/datum/status_effect/weakness, 5000)
	test("stun applied").expect(affected).to_have_status(/datum/status_effect/stun)
	test_summary()
	
	// Example 4: Cooldown check
	world << "\n[repeat("=", 50)]"
	world << "EXAMPLE 4: Cooldown Timing"
	world << "[repeat("=", 50)]"
	var/obj/ability/spell = new()
	spell.cooldown_until = world.time + 2350
	test("spell ready").expect(spell).to_be_castable()
	test_summary()
	
	// Example 5: Wrong negation
	world << "\n[repeat("=", 50)]"
	world << "EXAMPLE 5: Negation Mismatch"
	world << "[repeat("=", 50)]"
	test("should NOT have health").expect(player).not().to_have_health(80)
	test_summary()
	
	// Example 6: List comparison
	world << "\n[repeat("=", 50)]"
	world << "EXAMPLE 6: List Length Mismatch"
	world << "[repeat("=", 50)]"
	var/list/inventory = list("sword", "shield", "potion")
	test("inventory full").expect(inventory).to_have_length(5)
	test_summary()
	
	// Example 7: Stat check
	world << "\n[repeat("=", 50)]"
	world << "EXAMPLE 7: Stat Mismatch"
	world << "[repeat("=", 50)]"
	var/mob/warrior = new /mob()
	warrior.strength = 15
	test("strong warrior").expect(warrior).to_have_stat("strength", 20)
	test_summary()

// ============================================================================
// KEY IMPROVEMENTS IN FAILURE MESSAGES:
// ============================================================================

/*

BEFORE (Old Output):
  ✗ expected 50 but got 30
  ✗ health ([m.health]) != [expected]
  ✗ missing /datum/status_effect/stun

AFTER (New Output with Context):
  ✗ expected 50 but got 30
  ✗ expected health 70 but player_1 has 80
  ✗ expected /datum/status_effect/stun but player_1 has: 
    /datum/status_effect/weakness, /datum/status_effect/slow

IMPROVEMENTS:
  ✓ Shows actual value clearly
  ✓ Shows expected value clearly
  ✓ For missing items: lists what IS there as context
  ✓ For complex objects: shows relevant properties (health, cooldown, etc)
  ✓ For negations: tells you when assertion is inverted
  ✓ For lists/events: lists contents when assertion fails
  ✓ Better formatting with "expected X but got Y"

*/
