client/verb
//	OOC(t as text)
//		AddWorldMessage(t)
//	Say(t as text)
//		for(var/client/c in view(15))
//			c.AddChatMessage(t)

	Who()
		var/message	= ""
		for(var/mob/m in online_players)
			message += "[m.name]([m.level]) - [m.guild]"
		chat("log", message)
