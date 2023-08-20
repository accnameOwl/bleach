mob
	var/guild_name = ""
	var/guild_leader = 0
	var/guild_coleader = 0
	var/guild_member = 0
	var/guild_rank = ""
	var/in_guild = 0
	
	var/guild_caninvite = 0
	var/guild_canannounce = 0
	var/guild_canboot = 0
	var/guild_canchangerank = 0


mob/player/verb/Guild_Create()
	set category = "Guild"
	set name = "Create"

	if(in_guild)
		src << Bold(Red("You are already in a guild!"))
		return 0
	switch(alert("Are you sure you wish to create a Guild?","Create guild", "Yes", "No"))
		if("No")
			return
	Create 
	var/new_guild_name = input("What do you wish to name your Guild?", "Guild name") as text
	if(!new_guild_name)
		alert("No name entered. Ending creation.")
		return

	var/list/blacklisted_tags = list("font size", "b", "i", "u", "li", "ul")
	for(var/x in blacklisted_tags)
		if(findtext(new_guild_name, x))
			alert("You are not allowed to change [x]")
			goto Create
	
	if(length(new_guild_name) > 200)
		alert("Guild name cannot proceed more than 200 characters!")
		goto Create
	
	if(alert("Do you wish to call your guild [new_guild_name]?", "Guild name", "Yes", "No") == "No")
		goto Create
	
	guild_name = new_guild_name
	guild_leader = 1
	guild_rank = "Leader"
	in_guild = 1
	guilds_list.Add(new_guild_name)
	save_guilds_list()
	give_guild_verbs(src)
	verbs -= new/mob/player/verb/Guild_Create

mob/guild_leader/verb/Guild_Invite()
	set category = "Guild"
	var/list/Menu = list()
	for(var/mob/M in OnlinePlayers)
		if(!M.client) continue
		if(M.name != usr.name)
			if(!M.in_guild)
				Menu.Add(M)

	var/mob/M = input("Invite Who?","Guild Invite") as null | anything in Menu
	if(!M)return
	if(istype(M,/mob))
		switch(alert(M,"Would you like to join [usr]'s Guild?","Guild Join","Yes","No"))

			if("Yes")
				M.guild_name = usr.guild_name
				M.guild_member = 1
				M.guild_rank = "Member"
				M.in_guild = 1
				give_guild_verbs(M)
				M.verbs -= new/mob/player/verb/Guild_Create

				for(var/mob/X in world)
					if(X.guild_name == usr.guild_name)
						X << "<font color = #BB0EDA>Guild Information:</font> [M] has joined the Guild!"


			if("No")
				usr << "[M] has declined your Guild Invite"
				return
mob/guild_leader/verb/Guild_Boot()
	set category = "Guild"
	var/list/Menu = list()
	for(var/mob/M in OnlinePlayers)
		if(!M.client) continue
		if(M.name != usr.name)
			if(M.in_guild)
				if(M.guild_name == usr.guild_name)
					Menu.Add(M)

	var/mob/M = input("Boot Who?","Guild Boot") as null | anything in Menu
	if(!M)return
	if(istype(M,/mob))
		if(M.guild_leader)
			alert("You cannot boot the Leader!")
			return

		if(M.guild_coleader)
			alert("You cannot boot the Co-Leader!")
			return

		switch(alert("Would you like to Boot [M] from the Guild?","Guild Boot","Yes","No"))

			if("Yes")
				remove_guild_verbs(M)

				for(var/mob/X in OnlinePlayers)
					if(X.guild_name == M.guild_name)
						X << "<font color = #BB0EDA>Guild Information:</font> [M] has been Booted from the Guild!"

				M.guild_name = "None"
				M.guild_leader = 0
				M.guild_coleader = 0
				M.guild_member = 0

				M.guild_caninvite = 0
				M.guild_canannounce = 0
				M.guild_canboot = 0
				M.guild_canchangerank = 0

				M.guild_rank = ""
				M.in_guild = 0

				M.verbs += new/mob/player/verb/Guild_Create

			if("No")
				usr << "You decided not to Boot [M]"
				return

mob/guild_leader/verb/Guild_Change_Rank()
	set category = "Guild"
	var/list/Menu = list()
	for(var/mob/M in OnlinePlayers)
		if(!M.client) continue
		if(M.name != usr.name)
			if(M.in_guild)
				if(M.guild_name == usr.guild_name)
					Menu.Add(M)

	var/mob/M = input("Change Who's Rank?","Guild Change Rank") as null | anything in Menu
	if(!M)return
	if(istype(M,/mob))
		switch(input("What rank do you wish to give [M]?")in list("Co-Leader","Member","Custom","Cancel"))

			if("Co-Leader")
				M.guild_coleader = 1
				give_guild_verbs(M)

			if("Member")
				M.guild_member = 1
				remove_guild_verbs(M)
				give_guild_verbs(M)

			if("Custom")
				switch(alert("Do you wish to Alter their Custom Rank?","Change Rank","Yes","No"))
					if("Yes")
						var/new_rank = input("What do you wish their Rank to be called?","Custom Rank") as text | null
						if(length(new_rank) > 25)
							usr << "New Rank cannot be more than 25 Characters"
						if(!M)return
						M.guild_rank = new_rank

						for(var/mob/X in OnlinePlayers)
							if(X.guild_name == src.guild_name)
								X << "<font color = #BB0EDA>Guild Information:</font> [M] has been granted the rank of [new_rank]!"

						switch(input("What Permissions do you wish to give them?")in list("Boot","Invite","Announce","Change Rank","Cancel"))
							if("Boot")
								M.guild_canboot = 1
								give_guild_verbs(M)
							if("Invite")
								M.guild_caninvite = 1
								give_guild_verbs(M)
							if("Announce")
								M.guild_canannounce = 1
								give_guild_verbs(M)
							if("Guild Change Rank")
								M.guild_canchangerank = 1
								give_guild_verbs(M)
							if("None")
								return
					if("No")
						switch(input("What Permissions do you wish to give them?")in list("Boot","Invite","Announce","Change Rank","Cancel"))
							if("Boot")
								M.guild_canboot = 1
								give_guild_verbs(M)
							if("Invite")
								M.guild_caninvite = 1
								give_guild_verbs(M)
							if("Announce")
								M.guild_canannounce = 1
								give_guild_verbs(M)
							if("Guild Change Rank")
								M.guild_canchangerank = 1
								give_guild_verbs(M)
							if("None")
								return

			if("Cancel")
				return

mob/guild_leader/verb/Guild_Announce(T as text)
	set category = "Guild"
	set desc = "Announce to the Guild"

	var/list/L
	L = list("font size")

	if(length(T) > 350)
		alert("Message must be less than 350 Characters!")
		return

	if(!T)
		alert("Your message may not be blank.")
		return

	for(var/X in L)
		if(findtext(T,X))
			alert("You may not change your font size.")
			return

	for(var/mob/X in OnlinePlayers)
		if(X.guild_name == usr.guild_name)
			X << "<BR>----- Guild Announce -----<BR><font color=#000066>{<font color=#FFFFFF><font face = Arial>[src.guild_rank]<font color=#000066>}</font> [usr]: [T]<BR>"


mob/Guild_Verbs/verb/Guild_Chat(T as text)
	set category = "Guild"
	set desc = "Chat to the Guild"

	var/list/L
	L = list("font size")

	if(length(T) > 300)
		alert("Message must be less than 300 Characters!")
		return

	if(!T)
		alert("Your message may not be blank.")
		return

	for(var/X in L)
		if(findtext(T,X))
			alert("You may not change your font size.")
			return

	for(var/mob/X in OnlinePlayers)
		if(X.guild_name == usr.guild_name)
			X << {"<pre><strong><font color="#000066">{<font color="#FFFFFF"><font face = Arial>Guild<font color="#000066">}<font color="#000066">{<font color="#FFFFFF"><font face = Arial>[src.guild_rank]<font color="#000066">}</font></font></font></strong></pre> [src.name] Says:<font color = #CCCCCC> [T]"}


mob/Guild_Verbs/verb/Guild_Who()
	set category = "Guild"
	var/count = 0
	usr << "-------------------------------"
	for(var/mob/X in OnlinePlayers)
		if(X.in_guild)
			if(X.guild_name == usr.guild_name)
				count += 1
				usr << "<font color=#000066>{<font color=#FFFFFF><font face = Arial>[X.guild_rank]<font color=#000066>}</font> [X]"
	usr << "Guild Members Online: [count]"
	usr << "-------------------------------"

mob/Guild_Verbs/verb/Guild_Leave()
	set category = "Guild"
	if(!src.guild_leader)
		switch(alert("Are you sure you wish to leave the Guild [src.guild_name]?","Guild Leave","Yes","No"))

			if("Yes")
				remove_guild_verbs(src)

				for(var/mob/X in OnlinePlayers)
					if(X.guild_name == src.guild_name)
						X << "<font color = #BB0EDA>Guild Information:</font> [src] has left the Guild!"

				src.guild_name = ""
				src.guild_leader = 0
				src.guild_coleader = 0
				src.guild_member = 0

				src.guild_caninvite = 0
				src.guild_canannounce = 0
				src.guild_canboot = 0
				src.guild_canchangerank = 0

				src.guild_rank = ""
				src.in_guild = 0

				src.verbs += new/mob/player/verb/Guild_Create

			if("No")
				return
	else
		switch(alert("Are you sure you wish to leave the Guild [src.guild_name]?","Guild Leave","Yes","No"))

			if("Yes")
				var/savefile/F = new(guilds_save_loc)

				remove_guild_verbs(src)

				world << "<font color = #BB0EDA>Guild Information:</font> [src] has Disbanded [src.guild_name]!"

				guilds_list.Remove(src.guild_name)
				F["Guilds"] << guilds_list

				src.guild_name = ""
				src.guild_leader = 0
				src.guild_coleader = 0
				src.guild_member = 0

				src.guild_caninvite = 0
				src.guild_canannounce = 0
				src.guild_canboot = 0
				src.guild_canchangerank = 0

				src.guild_rank = ""
				src.in_guild = 0

				src.verbs += new/mob/player/verb/Guild_Create

			if("No")
				return

proc/give_guild_verbs(mob/m)
	if(m.guild_leader)
		m.verbs += typesof(/mob/guild_leader/verb)
		m.verbs += typesof(/mob/Guild_Verbs/verb)

	if(m.guild_coleader)
		m.verbs += typesof(/mob/guild_leader/verb)
		m.verbs += typesof(/mob/Guild_Verbs/verb)

	if(m.guild_member)
		m.verbs += typesof(/mob/Guild_Verbs/verb)

	if(m.guild_caninvite)
		m.verbs += new/mob/guild_leader/verb/Guild_Invite()

	if(m.guild_canboot)
		m.verbs += new/mob/guild_leader/verb/Guild_Boot()

	if(m.guild_canannounce)
		m.verbs += new/mob/guild_leader/verb/Guild_Announce()

	if(m.guild_canchangerank)
		m.verbs += new/mob/guild_leader/verb/Guild_Change_Rank()

proc/remove_guild_verbs(mob/m)
	if(m.guild_leader)
		m.verbs -= typesof(/mob/guild_leader/verb)
		m.verbs -= typesof(/mob/Guild_Verbs/verb)

	if(m.guild_coleader)
		m.verbs -= typesof(/mob/guild_leader/verb)
		m.verbs -= typesof(/mob/Guild_Verbs/verb)

	if(m.guild_member)
		m.verbs -= typesof(/mob/Guild_Verbs/verb)

	if(m.guild_caninvite)
		m.verbs -= new/mob/guild_leader/verb/Guild_Invite()

	if(m.guild_canboot)
		m.verbs -= new/mob/guild_leader/verb/Guild_Boot()

	if(m.guild_canannounce)
		m.verbs -= new/mob/guild_leader/verb/Guild_Announce()

	if(m.guild_canchangerank)
		m.verbs -= new/mob/guild_leader/verb/Guild_Change_Rank()

//
var/list/guilds_list = list()
proc/save_guilds_list()
	if(fexists(guilds_save_loc))
		fdel(guilds_save_loc)
	var/savefile/f = new/savefile(guilds_save_loc)
	f << guilds_list
proc/load_guilds_list()
	if(!fexists(guilds_save_loc))
		return
	var/savefile/f = new/savefile(guilds_save_loc)
	f >> guilds_list
