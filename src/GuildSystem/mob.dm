
mob/var/datum/guild/guild=null

mob/verb/CreateGuild()
	set category = "Guild"
	set name = "Create"
	if(level <= 50)
		alert(usr, "Your level is to low.","Create guild","Ok")
		return 0
	if(src.guild)
		switch(alert(usr, "Do you wish to leave the current guild?","leave guild?","Yes","No"))
			if("Yes")
				var/guild_name = input(usr,"What do you wish to call the guild?","Name new guild") as text
				guild = new/datum/guild(guild_name, src)
				src.verbs += typesof(/mob/guild/verb)
				return 1
			if("No")
				return 0
	var/guild_name = input(usr,"What do you wish to call the guild?","Name new guild") as text
	guild = new/datum/guild(guild_name, src)
	src.verbs += typesof(/mob/guild/verb)
	return 1

mob/guild/verb/Invite()
	set category = "Guild"
	var/list/listofplayers
	var/datum/guild/src_guild = src.guild
	for(var/mob/m in OnlinePlayers)
		var/datum/guild/m_guild = m.guild
		var/m_guild_name = m_guild&&m_guild.name
		if(m_guild_name != src_guild.name)
			listofplayers += m
	var/mob/m = input(usr,"Would you like to invite a new player to the guild?", "Guild invite") in listofplayers
	if(!m) return 0
	switch(alert(m, "Do you wish to join the guild: [html_encode(src_guild.name)]?", "Guild invite", "Yes", "no"))
		if("Yes")
			src_guild.members += m
			m.verbs += /mob/guild/verb/Say
			for(var/mob/members in src_guild.members)
				members << "[html_encode(m.name)] as joined the guild!"
		if("No")
			return 0
mob/guild/verb/Say()
	set category = "Guild"
	var/msg = input("What to say to the people:","Guild Say") as text
	for(var/mob/m in guild.members)
		m << Bold(Red("[html_encode(src.name)] Guild Say: ") + White(msg))