// ============================================================================
// COMBAT SYSTEM TESTS - Example Usage
// ============================================================================

/proc/test_combat_damage()
	world << "\n[repeat("=", 50)]"
	world << "COMBAT DAMAGE TESTS"
	world << "[repeat("=", 50)]"
	
	var/mob/attacker = new /mob()
	var/mob/defender = new /mob()
	
	attacker.damage = 10
	defender.health = 100
	
	// Simple damage test
	test("initial state").expect(defender).to_have_health(100)
	
	// Apply damage
	defender.take_damage(attacker, 15)
	test("after damage").expect(defender).to_have_health(85)
	
	// Multiple hits
	defender.take_damage(attacker, 20)
	defender.take_damage(attacker, 15)
	test("after multiple hits").expect(defender).to_have_health(50)
	
	// Health can't go below 0
	defender.take_damage(attacker, 100)
	test("health floor").expect(defender).to_be_at_least(0)
	
	test_summary()


/proc/test_status_effects()
	world << "\n[repeat("=", 50)]"
	world << "STATUS EFFECT TESTS"
	world << "[repeat("=", 50)]"
	
	var/mob/target = new /mob()
	
	// No effects initially
	test("no effects at start").expect(target.effects).to_have_length(0)
	
	// Apply a stun
	var/datum/status_effect/stun/s = target.apply_effect(/datum/status_effect/stun, 5000)
	test("effect applied").expect(target.effects).to_have_length(1)
	test("has stun effect").expect(target).to_have_status(/datum/status_effect/stun)
	
	// Apply a dot
	target.apply_effect(/datum/status_effect/burn, 3000)
	test("multiple effects").expect(target.effects).to_have_length(2)
	test("has burn effect").expect(target).to_have_status(/datum/status_effect/burn)
	
	// Remove effect
	s.remove()
	test("after removal").expect(target).not().to_have_status(/datum/status_effect/stun)
	test("other effect remains").expect(target).to_have_status(/datum/status_effect/burn)
	
	test_summary()


/proc/test_cooldowns()
	world << "\n[repeat("=", 50)]"
	world << "COOLDOWN TESTS"
	world << "[repeat("=", 50)]"
	
	var/obj/ability/A = new /obj/ability()
	
	// No cooldown initially
	test("ability ready").expect(A).not().to_be_on_cooldown()
	
	// Use ability (sets cooldown)
	A.cooldown_until = world.time + 5000
	test("ability on cooldown").expect(A).to_be_on_cooldown()
	
	test_summary()


/proc/test_spell_projectile()
	world << "\n[repeat("=", 50)]"
	world << "PROJECTILE TESTS"
	world << "[repeat("=", 50)]"
	
	var/obj/effect/spell/proj = new()
	proj.lifespan = 5000
	proj.created_at = world.time
	
	test("projectile created").expect(proj).to_be_true()
	test("has lifespan").expect(proj.lifespan).to_be_greater_than(0)
	test("damage value").expect(proj.damage).to_be_at_least(0)
	
	test_summary()


/proc/test_damage_scaling()
	world << "\n[repeat("=", 50)]"
	world << "DAMAGE SCALING TESTS"
	world << "[repeat("=", 50)]"
	
	var/mob/caster = new /mob()
	var/mob/target = new /mob()
	
	caster.spell_power = 150  // 50% bonus
	target.health = 100
	
	var/base_damage = 20
	var/scaled = base_damage * (caster.spell_power / 100)  // 30
	
	test("scaling calculation").expect(scaled).to_equal(30)
	
	target.take_scaled_damage(caster, base_damage)
	test("scaled damage applied").expect(target.health).to_equal(70)
	
	test_summary()


/proc/test_combat_suite()
	world << "\n"
	world << "╔════════════════════════════════════════════════════════╗"
	world << "║           RUNNING FULL COMBAT TEST SUITE              ║"
	world << "╚════════════════════════════════════════════════════════╝"
	
	test_combat_damage()
	test_status_effects()
	test_cooldowns()
	test_spell_projectile()
	test_damage_scaling()
