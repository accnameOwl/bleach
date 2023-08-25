mob/spell/bakudo/verb

	sai()
		set name = "Sai"
		set category = "Attacks"
		
		for(var/mob/a in oview(5))
			var/effect/sai_bind/binding = new(src.key)
			a.AddEffect(binding)

effect/sai_bind
	id = "bakudo"
	sub_id = "sai"
	duration = 50

	Added(mob/target, time=world.time)
		target.block_steps = 1
		world << "[target.name] was bound by Sai"
	Expired(mob/target, time=world.time)
		target.block_steps = 0
		world << "[target.name] was unbound by Sai"
		