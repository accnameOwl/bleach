var/list/admin_list = list(
	"tafe"="developer"
)
#define ADMIN_FILE_DEST "saves/admin_list.sav"

proc/save_admins_to_sav()
	if(fexists(ADMIN_FILE_DEST))
		fdel(ADMIN_FILE_DEST)
	var/savefile/sf = new/savefile(ADMIN_FILE_DEST)
	sf << admin_list
	return 1

proc/load_admins_from_sav()
	if(fexists(ADMIN_FILE_DEST))
		var/savefile/sf = new/savefile(ADMIN_FILE_DEST)
		var/l
		sf >> l
		admin_list += l
		world.log << ""
		return 1
	return 0

var
	worldmute = FALSE
	rebooting = FALSE
	list/reports = list()
	list/MuteList=list()
	list/MuteListKey=list()
	list/JailList=list()
	list/afk_check_cleared=list() // list of players who isn't afk, by talking through OOC
	afk_check_running = FALSE
	//Ban list
	list/BanList=list()

proc
	#define FILE_BANLIST "saves/banlist.sav"
	load_banlist_from_sav()
		if(fexists(FILE_BANLIST))
			var/savefile/existing_savefile = new/savefile(FILE_BANLIST)
			existing_savefile >> BanList
			return 1
		else
			return 0

	save_banlist_to_sav()
		var/savefile/new_savefile = new/savefile(FILE_BANLIST)
		new_savefile << BanList
		return 1

proc/is_banned(mob/m)
	//Check if ban is valid
	var/time_of_ban = BanList && BanList[m.ckey]
	world << time_of_ban
	if(time_of_ban <= world.realtime)
		var/ok = RemoveBan(m.ckey)
		if(ok)
			save_banlist_to_sav()
			return 0
	return BanList && BanList[m.ckey] ? BanList[m.ckey] : 0

proc/RemoveBan(ckey)
	var/is_found = BanList && BanList[ckey]
	if(!is_found) return 0
	BanList.Remove(ckey)
	return 1

//mob variables
mob
	var
		watching
		muted
		jailed
		rank = ""
		admin = ""
		admin_tag = "GM"
		godmode = FALSE
	proc
		is_admin()
			return (src.ckey in admin_list) && admin_list[src.ckey]

proc/Admin_Alert(message)
	for(var/mob/M in world)
		if(M.admin)
			M << "[message]"



mob/host/verb
	Reboot()
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
			var/ten_seconds = 10 * SECOND(1) + world.time
			var/twenty_seconds = 20 * SECOND(1) + world.time
			var/thirty_seconds = 30 * SECOND(1) + world.time
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
					for(var/mob/m in online_players)
						if(m.client)
							m.save()
				sleep(10/world.fps)

	Repop()
		set category = "Admin"
		set desc = "Repop the world"
		world << Bold(Red("World Repop()"))
		world.Repop()

	ResetTickLag()
		set category = "Admin"
		set desc = "Change Ticklag"
		set name = "Reset Ticklag"
		//quick maths...
		// tick_lag = 10/world.fps
		//    0.4 = 10/25
		world.tick_lag = 10/world.fps

mob/admin/verb
	CheckIP()
		set category = "Admin"
		set desc = "Check a players IP address"
		set name = "Check IP"
		var/list/online_players = list()
		for(var/mob/M in online_players)
			online_players += M
		var/mob/mob2Check=input("Player","Player") as null|anything in online_players
		if(!mob2Check)	return
		usr <<"<B>Key:</B> [mob2Check.key]"
		usr <<"<B>IP:</B> [mob2Check.client.address]"
		usr <<"<B>CID:</B> [mob2Check.client.computer_id]"

	Warn_Player()
		set category = "Admin"
		set desc = "Create a warning for a player"
		set name = "Warn player"
		var/mob/M = input("Who would you like to warn?\n- Note: They will be the only person seeing the warning","Warn Player") as mob in online_players
		if(!M) return
		var/warning = input("Input your warning to [M]\n- Note: They will be the only person seeing the warning","Warn Player") as text
		if(!warning) return
		M << Small(Red("Warning: ") + html_encode(warning))
		src << Small(Red("[M.name] recieved the warning."))

	Announce()
		set category="Admin"
		set desc = "What would you like to Announce to the world?"
		var/msg = input(src, "Make an announcement", "Enforcer") as text
		if(!msg) return
		world << Bold(Center(Green(H3("Announcement"))))
		world << Bold(Center(Green(H4(msg))))

	Kick()
		set category = "Admin"
		set desc = "Kick a player."
		var/mob/player = input("Please select a player", "Admin") in online_players + "Cancel"
		if(player)
			var/confirmation = alert("Are you sure you want to kick [player.name]?", "Confirmation","Yes", "no")
			if(confirmation == "Yes")
				Del(player)
		else
			return
	AFKCheck()
		set category = "Admin"
		set desc = "Run a check for 30 seconds, that kicks all inactive players."
		if(afk_check_running)
			src << Bold(Red("AFK check already running"))
			return
		afk_check_running = TRUE
		world << Bold(Center(Green(H2("AFK check"))))
		world << Bold(Center(Green(H4("Please say something in OOC in 30 seconds"))))
		spawn(300)
			for(var/mob/m in online_players)
				if(!afk_check_cleared.Find(m.ckey))
					Del(m)
			afk_check_running = FALSE

mob/admin/verb
	TestPixloc()
		set category = "Admin"
		var/pixloc/bound = bound_pixloc(src, src.dir)
		world.log << "dir: [src.dir], x_diff: [bound.x - src.pixloc.x], y_diff: [bound.y - src.pixloc.y]"
		world.log << "bound_x:[bound_x], bound_y:[bound_y], bound_width:[bound_width], bound_height:[bound_height]"
	AdminRoom()
		set category = "Admin"
		loc = locate(11,2,20)

	Teleport()
		set category = "Admin"
		switch(input("What type of Teleport would you like to preform?","Teleport") in list("Manual Teleport","Player Teleport","Monster Teleport","NPC Teleport", "Object Teleport", "Cancel"))
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
				var/list/people = list()
				for(var/mob/M in online_players)
					people += M
				var/mob/M = input("Who would you like to teleport to?","Teleport")as null|anything in people
				if(!M) return
				usr.x = M.x
				usr.y = M.y-1
				usr.z = M.z

			if("Monster Teleport")
				var/list/monsters = list()
				for(var/mob/monster/monster in world)
					monsters += monster
				var/mob/M = input("Who would you like to teleport to?","Teleport")as null|anything in monsters
				if(!M) return
				usr.x = M.x
				usr.y = M.y-1
				usr.z = M.z
			if("NPC Teleport")
				var/list/npcs = list()
				for(var/mob/NPC/npc in world)
					npcs += npc
				var/mob/M = input("Who would you like to teleport to?","Teleport")as null|anything in npcs
				if(!M) return
				usr.x = M.x
				usr.y = M.y-1
				usr.z = M.z

			if("Object Teleport")
				var/list/objects = list()
				for(var/obj/object in world)
					objects += object
				var/mob/M = input("Who would you like to teleport to?","Teleport")as null|anything in objects
				if(!M) return
				usr.x = M.x
				usr.y = M.y-1
				usr.z = M.z

	Summon()
		set category = "Admin"

		var/list/people = list()
		for(var/mob/M in online_players)
			people += M
		var/mob/M = input("Who would you like to summon?","Summon")as null|anything in people
		if(!M) return
		M.x = usr.x
		M.y = usr.y-1
		M.z = usr.z

	Inspect()
		set category = "Admin"
		var/list/players = list()

		if(!usr.watching)
			usr.watching=1
			for(var/mob/M in online_players)
				players += M
			var/mob/M = input("Who would you like to watch","Watch player")as null|anything in players
			if(M)
				client.eye = M

				client.perspective = 255
		else
			usr.watching=0
			client.eye = usr

	World_Mute()
		set category="Admin"
		worldmute = !worldmute
		usr<<output("[usr] has [worldmute ? "" : "un-"]muted the world","Chat")

	Ban()
		set category="Admin"
		set desc = "Choose a player to ban, and decide for how long."
		var/mob/player = input("Choose a player to ban", "Ban player") as mob in online_players
		if(!player)
			return 0
		var/duration = input("How long do you wish to ban [player.name], In hours", "Duration") as num
		player << Bold(Red("You have been banned for [duration] hours!"))
		duration = world.realtime + HOUR(duration)
		BanList[player.ckey] = duration
		var/ok = save_banlist_to_sav()
		if(ok) world << "save_banlist_to_sav() OK"

	UnBan()
		set category="Admin"
		set desc = "Choose a player to unban, and decide for how long."
		var/ckey = input("Choose a player to ban", "Ban player") as text|anything in BanList
		switch(alert("Do you wish to unban [ckey]?","Unban", "Yes", "No"))
			if("Yes")
				src << Bold(Red("Unbanned [ckey]"))
				BanList.Remove(ckey)
				. = save_banlist_to_sav()
				if(.) world << "save_banlist_to_sav() OK"
			if("No")
				return 0
mob/developer
	verb
		GodMode()
			set category = "Admin"
			set desc = "Become God for testing"
			src.density = !density
			src.godmode = !godmode

		ShowDebugWindow()
			set hidden = 1
			debug?.open_window(client)

		StartProfiler()
			set hidden = 1
			debug.start_profiler()
			client.is_profiling = TRUE
			client.next_profile_refresh = world.time + 10

		EndProfiler()
			set hidden = 1
			debug.end_profiler()
			client.is_profiling = FALSE
			client.next_profile_refresh = -1#INF

		Delete(atom/o in world)
			set category = "Admin"
			if(o)
				del o

		NewItem()
			set category = "Admin"
			var/list/ilist = typesof(/item)
			var/selected_item = input("Please select an item") in ilist + list("Cancel")
			if(selected_item == "Cancel")
				return
		//	if(selected_item)
		//		add_item(new selected_item(src))

		Inspect(mob/m in world)
			set category = "Admin"
			src << "[json_encode(global.json_data_monsters[m.json_id])]\n"
			src << Bold(Red("[m.name]"))
			src << Bold(Red("Level: [m.level]"))
			src << Bold(Red("Health: [m.hp]/[m.max_hp]"))
			src << Bold(Red("Reiatsu: [m.mana]/[m.max_mana]"))
			src << Bold(Red("Attack: [m.stat_attack]"))
			src << Bold(Red("Defence: [m.stat_defense]"))
			src << Bold(Red("Reiatsu Power: [m.stat_reiatsu]"))

		Edit(atom/O in world)
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

/*
mob/Creator/verb/Icon_Options()
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
					var/list/players = list()
					for(var/mob/M in online_players)
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
					var/list/players = list()
					for(var/mob/M in online_players)
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
					var/list/players = list()
					for(var/mob/M in online_players)
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
					var/list/players = list()
					for(var/mob/M in online_players)
						if(M.client) players += M
					var/mob/M = input("What overlay do you wish to change","Underlay")as null | anything in players
					if(!M) return
*/


