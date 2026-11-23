var/alist/Guild/guilds = alist()


Guild
	var
		name
		id
		alist/members = alist()
		
	New(name="")
		src.name = name

	proc
		Add(mob/player/m)

		Remove(mob/player/m)