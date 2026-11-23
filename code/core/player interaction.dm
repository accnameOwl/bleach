interactive
	verb
		Interact(mob/m)

mob
	verb
		Interact()
			set name = "Interact"
			if(resting)
				return
			for(var/interactive/i as obj|mob in oview(1))
				i?.Interact(src)