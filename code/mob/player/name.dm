mob/player
	proc
		namechange(v=null)
			if(!v)
				return
			if(v in client.blacklist_words)
				return
			
			else
				src.name = v
				dirty_stat("name")


	verb
		Namechange(v as text)
			namechange(v)