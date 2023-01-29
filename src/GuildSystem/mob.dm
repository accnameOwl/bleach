
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
				return 1
			if("No")
				return 0
	var/guild_name = input(usr,"What do you wish to call the guild?","Name new guild") as text
	. = guild = new/datum/guild(guild_name, src)

mob/guild/verb/Invite()
	var/list/listofplayers
	var/datum/guild/g = src.guild
	for(var/mob/m in OnlinePlayers)
		var/datum/guild/m_guild = m.guild
		var/m_guild_name = m_guild&&m_guild.name
		if(m_guild_name != g.name)
			listofplayers += m
	var/mob/m = input(usr,"Would you like to invite a new player to the guild?", "Guild invite") in listofplayers
	if(!m) return 0
	switch(alert(m, "Do you wish to join the guild: [html_encode(g.name)]?", "Guild invite", "Yes", "no"))
		if("Yes")
			g.members += m
			m.verbs += /mob/guild/verb/Say
			for(var/mob/gmember in g.members)
				gmember << "[html_encode(m.name)] as joined the guild!"
		if("No")
			return 0
mob/guild/verb/Say()
	var/msg = input("What to say to the people:","Guild Say") as text
	for(var/mob/m in guild.members)
		m << Bold(Red("[html_encode(src.name)]:") + White(msg))