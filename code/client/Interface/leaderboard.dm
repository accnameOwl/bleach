
var/leaderboard_template // set on world.New()

#define Alphabet list("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z")
proc/create_random_name()
	var/len = rand(5,20), n=""
	for(var/i=0, i < len, i++)
		if(i==0)
			n += uppertext(pick(Alphabet))
		else
			n += pick(Alphabet)
	return n

var/list/leaderboard = list()

proc
	#define FILE_LEADERBOARD_JSON "saves/leaderboard.sav"
	save_leaderboard_to_sav()
		var/savefile/sf = new/savefile(FILE_LEADERBOARD_JSON)
		sf << leaderboard
		return 1

	load_leaderboard_from_sav()
		if(!fexists(FILE_LEADERBOARD_JSON)) return 0
		var/savefile/sf = new/savefile(FILE_LEADERBOARD_JSON)
		sf >> leaderboard
		return 1

	add_to_leaderboard(list/entry)
		if(!entry.["name"] || !entry.["level"] || !entry.["kills"] || !entry.["title"]) return
		leaderboard[++leaderboard.len] = entry

	// TODO: Issues when used with anything but "name" property.
	// 		 Cut decrements list length, meaning cutting concecutive times in a loop becomes faulty.
	remove_from_leaderboard(property, value)
		for(var/i=1,i<length(leaderboard), i++)
			if(leaderboard[i][property] == value)
				leaderboard.Cut(i,i+1)

	update_leaderboard_window(client/c)
		if(!c) return
		c << output(url_encode(json_encode(leaderboard)), "leaderboard.browser:sortAndDisplayLeaderboardData")

mob/developer
	verb
		ShowLeaderboardWindow()
			set name = "Leaderboard Open"
			set category = "Admin"
			winshow(usr, "leaderboard", 1)


			usr << output(leaderboard_template, "leaderboard.browser")
			usr << output(url_encode(json_encode(leaderboard)), "leaderboard.browser:sortAndDisplayLeaderboardData")

		LeaderboardCreateTestEntries()
			set name = "Leaderboard Create Entries"
			set category = "Admin"
			var/amount_of_entries = input(src, "How many would you like to add?", "Entries", 1) as num

			for(var/i in 1 to amount_of_entries)
				add_to_leaderboard(list(
					"name"=create_random_name(),
					"level"=rand(1,100),
					"kills"=rand(1,500),
					"title"="none"
					)
				)

			update_leaderboard_window(src)
			world.log << json_encode(leaderboard)

		RemoveFromLadder()
			set name = "Leaderboard Remove Entry"
			set category = "Admin"

			var/list/prop = input(usr, "Which property would you like to remove by?", "Remove entry") in list("name","level","kills","rank","cancel")
			if(prop=="cancel") return

			var/list/selected_entry = input(usr, "Which name would you like to remove from leaderboard?", "Remove entry", "Please type a name from the leaderboard") as text
			remove_from_leaderboard(prop, selected_entry)
			update_leaderboard_window(src.client)

		RemoveFromLadderFromTo()
			set name = "Leaderboard Remove From-To"
			set category = "Admin"
			var/start = input(usr,"Start pos", "Remove Entries", 1) as num
			var/end = input(usr,"End pos", "Remove Entries", 0) as num
			leaderboard.Cut(start, end)
			update_leaderboard_window(src)
