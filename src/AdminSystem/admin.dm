
var/worldmute = FALSE
var/rebooting = FALSE
var/list/reports = list(/*Phat T*/)
var/list/MuteList=list(/*Phat T*/)
var/list/MuteListKey=list(/*Phat T*/)
var/list/JailList=list(/*Phat T*/)
var/list/OnlinePlayers=list()

mob
	var/watching
	var/muted
	var/jailed
	var/rank = ""
	var/admin = ""
	var/admin_tag = ""

proc/Admin_Alert(message)
	for(var/mob/M in world)
		if(M.admin)
			M << "[message]"

mob/proc/CheckAdmin()
	switch(src.rank)
		if(CREATOR)
			src.verbs += typesof(/mob/Host/verb)
			src.verbs += typesof(/mob/Enforcer/verb)
			src.verbs += typesof(/mob/Admin/verb)
			src.verbs += typesof(/mob/Creator/verb)
			#ifdef __TEST__
			//all verbs for testing
			src.verbs += typesof(/mob/hollow/verb)
			#endif
		if(ADMIN)
			src.verbs += typesof(/mob/Enforcer/verb)
			src.verbs += typesof(/mob/Admin/verb)
		if(ENFORCER)
			src.verbs += typesof(/mob/Enforcer/verb)
		if(HOST)
			src.verbs += typesof(/mob/Host/verb)

mob/Host/verb/Reboot()
	set category = "Admin"
	set desc = "Reboot the server within 30 seconds. Use verb again to cancel the reboot."
	if(rebooting)
		var/reply = alert(src, "World already rebooting! Do you wish to cancel?", "Already rebooting!", "Yes", "No")
		switch(reply)
			if("Yes")
				rebooting = FALSE
				world << Bold(Center(Red(H4("World reboot was canceled!"))))
			if("No")
				return
	else
		rebooting = TRUE
		world << Bold(Center(Red(H2("World Reboot"))))
		world << Bold(Center(Red(H4("World is rebooting in 30 seconds!"))))
		var/ten_seconds = 10 * SECOND + world.time
		var/twenty_seconds = 20 * SECOND + world.time
		var/thirty_seconds = 30 * SECOND + world.time
		while(rebooting)
			if(world.time == ten_seconds)
				world << Bold(Center(Red(H4("World is rebooting in 20 seconds!"))))
			if(world.time == twenty_seconds)
				world << Bold(Center(Red(H4("World is rebooting in 10 seconds!"))))
			if(world.time == thirty_seconds-50)
				world << Bold(Center(Red(H4("World is rebooting in 5..."))))
			if(world.time == thirty_seconds-40)
				world << Bold(Center(Red(H4("World is rebooting in 4..."))))
			if(world.time == thirty_seconds-30)
				world << Bold(Center(Red(H4("World is rebooting in 3..."))))
			if(world.time == thirty_seconds-20)
				world << Bold(Center(Red(H4("World is rebooting in 2..."))))
			if(world.time == thirty_seconds-10)
				world << Bold(Center(Red(H4("World is rebooting in 1..."))))
				spawn(10) world.Reboot()
				//save online players
				for(var/mob/m in OnlinePlayers)
					if(m.client)
						m.Save()
			sleep(10/world.fps)

	
mob/Enforcer/verb/CheckIP(/*Phat T*/)
	set category = "Admin"
	var/list/onlinePlayers = list(/*Phat T*/)
	for(var/mob/M in OnlinePlayers)
		onlinePlayers += M
	var/mob/mob2Check=input("Player","Player") as null|anything in onlinePlayers
	if(!mob2Check)	return
	usr <<"<B>Key:</B> [mob2Check.key]"
	usr <<"<B>IP:</B> [mob2Check.client.address]"
	usr <<"<B>CID:</B> [mob2Check.client.computer_id]"

mob/Enforcer/verb/Warn_Player(/*Phat T*/)
	set category = "Admin"
	var/list/players = list(/*Phat T*/)
	for(var/mob/M in OnlinePlayers)
		players += M
	var/mob/M = input("Who would you like to warn?\n- Note: They will be the only person seeing the warning","Warn Player")as null|anything in players
	if(!M) return
	var/warning = input("Input your warning to [M]\n- Note: They will be the only person seeing the warning","Warn Player")as text|null
	if(!warning) return
	M<< "<font color=red><small>Warning: </font color>[html_encode(warning)] ; from [usr]"
		/************/
		/**ANNOUNCE**/
		/************/
mob/Enforcer/verb/Announce()
	set category="Admin"
	set desc = "What would you like to Announce to the world?"
	var/msg = input(src, "Make an announcement", "Enforcer") as text
	if(!msg) return
	world << Bold(Center(Red(H3("Announcement"))))
	world << Bold(Center(Red(H4(msg))))

mob/Admin/verb/Teleport(/*Phat T*/)
	set category = "Admin"
	switch(input("What type of Teleport would you like to preform?","Teleport") in list("Manual Teleport","Player Teleport","Cancel"))
		if("Cancel") return
		if("Manual Teleport")
			var/x = input("Input X coordinates","X Coordinates")as num|null
			if(!x) return
			var/y = input("Input Y coordinates","Y Coordinates")as num|null
			if(!y) return
			var/z = input("Input Z coordinates","Z Coordinates")as num|null
			if(!z) return
			usr.x = x
			usr.y = y
			usr.z = z

		if("Player Teleport")
			var/list/people = list(/*Phat T*/)
			for(var/mob/M in OnlinePlayers)
				people += M
			var/mob/M = input("Who would you like to teleport to?","Teleport")as null|anything in people
			if(!M) return
			usr.x = M.x
			usr.y = M.y-1
			usr.z = M.z



mob/Admin/verb/Summon(/*Phat T*/)
	set category = "Admin"

	var/list/people = list(/*Phat T*/)
	for(var/mob/M in OnlinePlayers)
		people += M
	var/mob/M = input("Who would you like to summon?","Summon")as null|anything in people
	if(!M) return
	M.x = usr.x
	M.y = usr.y-1
	M.z = usr.z
mob/Admin/verb/View_Reports(/**/)
	set category = "Admin"
	var/html = {"<font size=3><b>Reports: </b></font size>
	<hr>
	<font color=black>
	<font size=2>"}
	if(length(reports))
		for(var/r in reports) html+="[r]<br><br>"
	else html+="<br><b>No Reports</b>"
	html+="<br>---------------------------<br><br><b><u>Current Time</u>:  [world.realtime]</b>"
	usr<<browse(html,"window=who,size=550x600")
mob/Admin/verb/Delete_Reports(/**/)
	set category = "Admin"
	switch(alert("Are you sure you want to delete all reports?","Delete Reports","Yes","No"))
		if("No") return
	reports = new(/**/)
	fdel("Save Files/Reports.sav")
	usr<<output("<font color=red><small>All reports have succesfully been deleted","Chat")


mob/Creator/verb/Delete(atom/o in world)
	set category = "Admin"
	if(o)
		del o

mob/Creator/verb/World_Mute(/**/)
	set category="Admin"
	worldmute = !worldmute
	usr<<output("[usr] has [worldmute ? "" : "un-"]muted the world","Chat")

mob/Creator/verb/Edit(atom/O in world)
	set category = "Admin"
	var/variable = input("Which var?","Var") in O:vars + list("Cancel")
	if(variable == "Cancel") return
	var/default
	var/typeof = O:vars[variable]
	if(isnull(typeof))
		default = "Text"
	else if(isnum(typeof))
		default = "Num"
	else if(istext(typeof))
		default = "Text"
	else if(isloc(typeof))
		default = "Reference"
	else if(isicon(typeof))
		typeof = "\icon[typeof]"
		default = "Icon"
	else if(istype(typeof,/atom) || istype(typeof,/datum))
		default = "Type"
	else if(istype(typeof,/list))
		default = "List"
	else if(istype(typeof,/client))
		default = "Cancel"
	else default = "File"
	var/race = input("What kind of variable?","Variable Type",default) in list("Text","Num","Type","Reference","Icon","File","Restore to default","List","Null","Cancel")
	switch(race)
		if("Cancel") return
		if("Restore to default") O:vars[variable] = initial(O:vars[variable])
		if("Text") O:vars[variable] = input("Enter new text:","Text",O:vars[variable]) as text
		if("Num") O:vars[variable] = input("Enter new number:","Num",O:vars[variable]) as num
		if("Type") O:vars[variable] = input("Enter type:","Type",O:vars[variable]) in typesof(/obj,/mob,/area,/turf)
		if("Reference") O:vars[variable] = input("Select reference:","Reference",O:vars[variable]) as mob|obj|turf|area in world
		if("File") O:vars[variable] = input("Pick file:","File",O:vars[variable]) as file
		if("Icon") O:vars[variable] = input("Pick icon:","Icon",O:vars[variable]) as icon
		if("List") input("This is what's in [variable]") in O:vars[variable] + list("Close")
		if("Null")
			if(alert("Are you sure you want to clear this variable?","Null","Yes","No") == "Yes") O:vars[variable] = null
mob/Creator/verb/Watch(/*Phat T*/)
	set category = "Admin"
	var/list/players = list(/*Phat T*/)

	if(!usr.watching)
		usr.watching=1
		for(var/mob/M in OnlinePlayers)
			players += M
		var/mob/M = input("Who would you like to watch","Watch player")as null|anything in players
		if(M)
			client.eye = M

			client.perspective = 255
	else
		usr.watching=0
		client.eye = usr

mob/Creatorreator/verb/Icon_Options(/**/)
	set category = "Admin"
	switch(input("What would you like to do with this icon?","Icon Options")as null | anything in list("Icon","Icon State","Overlay","Underlay"))
		if("Icon")
			var/i = input("Which icon would you like to add?","Icon")as icon | null
			if(!i) return
			switch(alert("What would you like to do with this icon?","Icon","Change","Change Players"))
				if("Change")
					usr.icon = i
					usr.overlays = null
				if("Change Players")
					var/list/players = list(/*Phat T*/)
					for(var/mob/M in OnlinePlayers)
						if(M.client) players += M
					var/mob/M = input("Whos icon do you wish to Change","Icon")as null | anything in players
					if(!M) return
					M.icon = i
					M.overlays = null
		if("Icon State")
			switch(alert("What would you like to alter in the icon state?","Icon State","Change","Change Players"))
				if("Change")
					var/iconstate = input("Please input the Icon State you wish this person to have.\n- Please be sure this is Case Sensitive","Icon State")as text | null
					usr.icon_state = iconstate
				if("Change Players")
					var/iconstate = input("Please input the Icon State you wish this person to have.\n- Please be sure this is Case Sensitive","Icon State")as text | null
					var/list/players = list(/*Phat T*/)
					for(var/mob/M in OnlinePlayers)
						if(M.client) players += M
					var/mob/M = input("Whos icon state do you wish to Change?","Icon State")as null | anything in players
					if(!M) return
					usr << "<font color=blue>[M]'s Icon State: [iconstate]</font color>"
					M.icon_state = iconstate
		if("Overlay")
			var/i = input("Which overlay would you like to add?","Overlay")as icon|null
			if(!i) return
			switch(alert("What would you like to do with this overlay?","Overlay","Change","Change Players"))
				if("Change") usr.overlays += i
				if("Change Players")
					var/list/players = list(/*Phat T*/)
					for(var/mob/M in OnlinePlayers)
						if(M.client) players += M
					var/mob/M = input("What overlay do you wish to change","Overlay")as null | anything in players
					if(!M) return
					M.overlays += i
		if("Underlay")
			var/i = input("Which Underlay would you like to add?","Underlay")as icon|null
			if(!i) return
			switch(alert("What would you like to do with this Underlay?","Underlay","Change","Change Players"))
				if("Change") usr.underlays += i
				if("Change Players")
					var/list/players = list(/*Phat T*/)
					for(var/mob/M in OnlinePlayers)
						if(M.client) players += M
					var/mob/M = input("What overlay do you wish to change","Underlay")as null | anything in players
					if(!M) return