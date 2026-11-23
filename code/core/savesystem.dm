
mob
	proc
		save()
			var/savefile/F = new/savefile("saves/[copytext(src.ckey,1,2)]/[src.ckey].sav")
			src.Write(F)
			return TRUE

		load(target_key=null)
			var/savefile/F = new/savefile("saves/[copytext(target_key,1,2)]/[target_key].sav")
			src.Read(F)
			src.key = target_key


			//bugs with hair. short workaround
			if(hair)
				overlays.Add(hair)

	verb
		Save()
			if(src.client)
				src.save()
				client.chat("log", Bold(Red("Saved!")))

	player
		Write(var/savefile/F)
			. = ..(F)
		//	F.dir.Remove("key")
			F.cd = "location"
			F << pixloc(src)
			F.cd = ".."
			return .

		Read(var/savefile/F)
			. = ..(F)
			F.cd = "location"
			F >> src.pixloc
			F.cd = ".."
			return .