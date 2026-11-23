// ============================================================================
// TEST FRAMEWORK - Fluent Assertions for Combat/Game Systems
// ============================================================================

// Global test state
var/list/test_results = list()
var/test_count = 0
var/test_passed = 0

// ============================================================================
// TEST RUNNER
// ============================================================================

/proc/test(name)
	return new /test/case(name)

/proc/test_summary()
	var/total = test_count
	var/passed = test_passed
	var/failed = total - passed
	var/pct = total ? round(passed / total * 100) : 0
	
	world << "\n[repeat("=", 50)]"
	world << "TEST RESULTS: [passed]/[total] passed ([pct]%)"
	if(failed)
		world << "FAILED: [failed] test[failed > 1 ? "s" : ""]"
	world << "[repeat("=", 50)]"
	
	for(var/result in test_results)
		world << result
	
	return passed == total

/proc/repeat(str, count)
	var/out = ""
	for(var/i in 1 to count)
		out += str
	return out

// ============================================================================
// TEST CASE
// ============================================================================

/test/case
	var/name
	var/active_expect

	New(test_name)
		name = test_name
		test_count++

	proc/run(callback)
		call(callback)()
		return src

	proc/expect(value)
		active_expect = new /test/assertion(value)
		return active_expect

	proc/pass(msg)
		test_passed++
		test_results += "✓ [name] - [msg || "passed"]"
		return src

	proc/fail(msg)
		test_results += "✗ [name] - [msg || "failed"]"
		return src

// ============================================================================
// FLUENT ASSERTIONS
// ============================================================================

/test/assertion
	var/value
	var/negated = FALSE
	var/last_matcher = ""  // Track last matcher for context

	New(val)
		value = val

	proc/not()
		negated = !negated
		return src

	// Equality & Identity
	proc/to_equal(expected)
		last_matcher = "to_equal([expected])"
		if((value == expected) != negated)
			return pass("expected [expected]")
		var/desc = "expected [expected] but got [value]"
		if(negated) desc = "expected NOT [expected] but got [value]"
		return fail(desc)

	proc/to_be(expected)
		last_matcher = "to_be([expected])"
		if((value is expected) != negated)
			return pass("is [expected]")
		var/desc = "expected type [expected] but got [value] ([value:type])"
		if(negated) desc = "expected NOT [expected] but got [value]"
		return fail(desc)

	proc/to_be_null()
		last_matcher = "to_be_null()"
		if((value == null) != negated)
			return pass("is null")
		var/desc = "expected null but got [value]"
		if(negated) desc = "expected NOT null but got [value]"
		return fail(desc)

	// Numeric
	proc/to_be_greater_than(n)
		last_matcher = "to_be_greater_than([n])"
		if((value > n) != negated)
			return pass("[value] > [n]")
		var/desc = "expected > [n] but got [value]"
		if(negated) desc = "expected NOT > [n] but got [value]"
		return fail(desc)

	proc/to_be_less_than(n)
		last_matcher = "to_be_less_than([n])"
		if((value < n) != negated)
			return pass("[value] < [n]")
		var/desc = "expected < [n] but got [value]"
		if(negated) desc = "expected NOT < [n] but got [value]"
		return fail(desc)

	proc/to_be_at_least(n)
		last_matcher = "to_be_at_least([n])"
		if((value >= n) != negated)
			return pass("[value] >= [n]")
		var/desc = "expected >= [n] but got [value]"
		if(negated) desc = "expected NOT >= [n] but got [value]"
		return fail(desc)

	proc/to_be_at_most(n)
		last_matcher = "to_be_at_most([n])"
		if((value <= n) != negated)
			return pass("[value] <= [n]")
		var/desc = "expected <= [n] but got [value]"
		if(negated) desc = "expected NOT <= [n] but got [value]"
		return fail(desc)

	// Containment & Collections
	proc/to_contain(item)
		last_matcher = "to_contain([item])"
		var/has_item = (item in value)
		if(has_item != negated)
			return pass("[item] in list")
		var/desc = "expected [value] to contain [item]"
		if(negated) desc = "expected [value] NOT to contain [item]"
		return fail(desc)

	proc/to_have_length(len)
		last_matcher = "to_have_length([len])"
		var/actual_len = length(value)
		if((actual_len == len) != negated)
			return pass("length is [len]")
		var/desc = "expected length [len] but got [actual_len] (list: [value])"
		if(negated) desc = "expected NOT length [len] but got [actual_len]"
		return fail(desc)

	// Game-specific: Health/Status
	proc/to_have_health(expected)
		last_matcher = "to_have_health([expected])"
		if(!ismob(value))
			return fail("[value] is not a mob")
		var/mob/m = value
		if((m.health == expected) != negated)
			return pass("health is [expected]")
		var/desc = "expected health [expected] but [value] has [m.health]"
		if(negated) desc = "expected health NOT [expected] but [value] has [m.health]"
		return fail(desc)

	proc/to_have_status(effect_type)
		last_matcher = "to_have_status([effect_type])"
		if(!ismob(value))
			return fail("[value] is not a mob")
		var/mob/m = value
		var/has_effect = FALSE
		for(var/datum/status_effect/fx in m.effects)
			if(istype(fx, effect_type))
				has_effect = TRUE
				break
		if(has_effect != negated)
			return pass("has [effect_type]")
		var/effects_list = ""
		for(var/datum/status_effect/fx in m.effects)
			effects_list += "[fx:type], "
		var/desc = "expected [effect_type] but [value] has: [effects_list || "no effects"]"
		if(negated) desc = "expected NOT [effect_type] but [value] has it"
		return fail(desc)

	proc/to_have_buff(buff_type)
		return to_have_status(buff_type)

	proc/to_have_debuff(debuff_type)
		return to_have_status(debuff_type)

	// Game-specific: Cooldowns
	proc/to_be_on_cooldown()
		last_matcher = "to_be_on_cooldown()"
		if(!value || !value.cooldown_until)
			return fail("[value] has no cooldown_until property")
		var/time_left = value.cooldown_until - world.time
		if((time_left > 0) != negated)
			return pass("on cooldown ([time_left]ms remaining)")
		var/desc = "expected on cooldown but cooldown expired [abs(time_left)]ms ago"
		if(negated) desc = "expected NOT on cooldown but still has [time_left]ms remaining"
		return fail(desc)

	// Truthiness
	proc/to_be_true()
		last_matcher = "to_be_true()"
		if(value != negated)
			return pass("is truthy")
		var/desc = "expected truthy value but got [value]"
		if(negated) desc = "expected falsy value but got [value]"
		return fail(desc)

	proc/to_be_false()
		last_matcher = "to_be_false()"
		if(!value != negated)
			return pass("is falsy")
		var/desc = "expected falsy value but got [value]"
		if(negated) desc = "expected truthy value but got [value]"
		return fail(desc)

	proc/pass(msg)
		test_passed++
		test_results += "  ✓ [msg]"
		return src

	proc/fail(msg)
		test_results += "  ✗ [msg]"
		return src

// ============================================================================
// EXAMPLE TESTS (delete these once you have your own)
// ============================================================================

/proc/example_tests()
	test("basic math").expect(2 + 2).to_equal(4)
	test("list contains").expect(list(1, 2, 3)).to_contain(2)
	test("negation").expect(5).not().to_equal(3)
	test("greater than").expect(10).to_be_greater_than(5)
	test("null check").expect(null).to_be_null()
	
	// Assuming you have mobs with health:
	/*
	var/mob/M = new()
	M.health = 100
	test("mob health").expect(M).to_have_health(100)
	test("mob damage").expect(M).to_have_health(100)
	M.take_damage(30)
	test("mob health after damage").expect(M).to_have_health(70)
	*/
	
	test_summary()
