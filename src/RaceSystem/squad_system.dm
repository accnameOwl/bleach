mob
	var/in_squad = false
	var/squad_division = 0
	var/squad_captain = false
	var/squad_leutenant = false


mob/squad_leutenant/verb/Squad_Invite()
	set category = "Squad"
	var/list/select_player = list()
	for(var/mob/m in OnlinePlayers)
		if(!m.client) continue
		if(m.name != usr.name)
			if(!m.in_squad)
				select_player.Add(m)
	select_player.Add("Cancel")
	var/mob/m = input("Who would you live to invite?", "Squad Invite") as null | anything in select_player
	if(!m) 
		return

	if(ismob(m))
		switch(alert(m, "Would you like to join Squad [usr.squad_division]?", "Squad Join", "Yes", "No"))
			if("Yes")
				m.squad_division = squad_division
				m.in_squad = true
				give_squad_verbs(m)
				m << Bold(Red("You have joined Gotei's [m.squad_division]\th Division."))
			if("No")
				src << Bold(Red("[m] has declined."))
				return

mob/squad_captain/verb/Squad_Boot()
	set category = "Squad"
	var/list/player_list = list()
	for(var/mob/m in OnlinePlayers)
		if(!m.client) continue
		if(m.name == src.name) continue
		if(m.race != "Shinigami") continue
		if(!m.in_squad || !m.squad_division) continue
		if(m.squad_division == src.squad_division)
			player_list.Add(m)
	
	var/mob/m = input("Who would you like to squad kick?") as null|anything in player_list
	if(!m) return
	if(ismob(m))
		switch(alert("Would you like to boot [m] from your squad?","Squad boot", "Yes","No"))
			if("Yes")
				remove_squad_verbs(m)
				remove_from_squad(m)
			if("No")
				src << "You decided not to boot [m]"
				return

mob/squad_captain/verb/Make_Leutenant()
	set category = "Squad"

	var/list/player_list = list()
	for(var/mob/m in OnlinePlayers)
		if(!m.client) continue
		if(m.race != "Shinigami") continue
		if(!m.in_squad || !m.squad_division) continue
		if(m.name == src.name) continue
		if(m.squad_division == src.squad_division)
			if(m.squad_leutenant) continue
			player_list.Add(m)
		
	var/mob/m = input("Who would you like to make your leutenant?", "make Leutenant") as null|anything in player_list
	if(!m) return
	if(ismob(m))
		m.squad_leutenant = true
		give_squad_verbs(m)


mob/squad_captain/verb/Remove_Leutenant()
	set category = "Squad"

	var/list/player_list = list()
	for(var/mob/m in OnlinePlayers)
		if(!m.client) continue
		if(m.race != "Shinigami") continue
		if(!m.in_squad || !m.squad_division) continue
		if(m.name == src.name) continue
		if(m.squad_division == src.squad_division)
			if(!m.squad_leutenant) continue
			player_list.Add(m)

	var/mob/m = input("Who would you like to make your leutenant?", "make Leutenant") as null|anything in player_list
	if(!m) return
	if(ismob(m))
		m.squad_leutenant = false
		remove_squad_verbs(m)

mob/squad/verb/who()
	set category = "Squad"
	src << Bold(Yellow("Squad who:"))
	for(var/mob/m in OnlinePlayers)
		if(m.squad_division == src.squad_division)
			src << Yellow(m.name)

mob/squad/verb/Say()
	set category = "Squad"
	
	var/msg = input("Say something to your squad", "Squad say") as text
	msg = Cyan("[src.name]: ") + White(msg)
	var/pretext = ""
	if(squad_captain)
		pretext += "(Captain)"
	if(squad_leutenant)
		pretext += "(Leutenant)"
	msg = Bold(Cyan(pretext) + msg)

	for(var/mob/m in OnlinePlayers)
		if(!m.client) continue
		if(m.race == "Shinigami" && m.in_squad)
			if(m.squad_division == src.squad_division)
				m << msg

/********************************/
/*		global squad procs		*/
/*								*/
proc/make_squad_captain(mob/m)
	if(m.race != "Shinigami" || !m.in_squad) 
		return
	if(m.squad_leutenant)
		m.squad_leutenant = false
	if(!m.squad_captain)
		m.squad_captain = true
		m.racerank = "Captain"
		m << Bold(Gold("You have been promoted to ") + Silver("[m.racerank]") + Gold("!"))
		give_squad_verbs(m)
	//Add to squad_list for db purposes
	var/datum/squad_db_type/sq = get_squad(m.squad_division)
	if(sq.cap != m.name)
		sq.cap = m.name
	if(sq.cap_level < m.level)
		sq.cap_level = m.level
	save_squads_list()
proc/remove_squad_captain(mob/m)
	if(m.race != "Shinigami" || !m.in_squad) 
		return
	remove_squad_verbs(m)
	m.squad_captain = false
	m.racerank = ""
	//Add to squad_list for db purposes
	var/datum/squad_db_type/sq = get_squad(m.squad_division)
	if(sq.cap == m.name)
		sq.cap = ""
	if(sq.cap_level == m.level)
		sq.cap_level = ""
	save_squads_list()

proc/make_squad_leutenant(mob/m)
	if(m.race != "Shinigami" || !m.in_squad) 
		return
	if(m.squad_captain)
		m.squad_captain = false

	if(!m.squad_leutenant)
		m.squad_leutenant = true
		m.racerank = "Leutenant"
		m << Bold(Gold("You have been promoted to ") + Silver("[m.racerank]") + Gold("!"))
		give_squad_verbs(m)
	//Add to squad_list for db purposes
	var/datum/squad_db_type/sq = get_squad(m.squad_division)
	if(sq.leut != m.name)
		sq.leut = m.name
	if(sq.leut_level != m.level)
		sq.leut_level = m.level
	save_squads_list()

proc/remove_squad_leutenant(mob/m)
	if(m.race != "Shinigami" || !m.in_squad) 
		return
	remove_squad_verbs(m)
	m.squad_leutenant = false
	m.racerank = ""
	//Add to squad_list for db purposes
	var/datum/squad_db_type/sq = get_squad(m.squad_division)
	if(sq.leut == m.name)
		sq.leut = ""
	if(sq.leut_level == m.level)
		sq.leut_level = ""
	save_squads_list()

proc/make_squad_member(mob/m, squad = null)
	if(!squad) return
	if(m.race == "Shinigami" && !m.in_squad)
		m.in_squad = true
		m.squad_division=squad
		give_squad_verbs(m)
proc/give_squad_verbs(mob/m)
	if(m.client && m.race == "Shinigami" && m.in_squad)
		if(m.squad_captain)
			m.verbs += typesof(/mob/squad_captain/verb)
			m.verbs += typesof(/mob/squad_leutenant/verb)
		if(m.squad_leutenant)
			m.verbs += typesof(/mob/squad_leutenant/verb)
		m.verbs += typesof(/mob/squad/verb)
proc/remove_squad_verbs(mob/m)
	if(m.squad_captain)
		m.verbs -= typesof(/mob/squad_captain/verb)
	if(m.squad_leutenant)
		m.verbs -= typesof(/mob/squad_leutenant/verb)
	if(m.in_squad && !m.squad_captain && !m.squad_leutenant)
		m.verbs -= typesof(/mob/squad/verb)

proc/add_to_squad(mob/m, squad_div)
	if(!squad_div) return
	m.in_squad = true
	m.squad_division = squad_div
proc/remove_from_squad(mob/m)
	m.in_squad = false
	m.squad_division = false
	m.squad_captain = false
	m.squad_leutenant = false
proc/get_squad(squad_div=0)
	for(var/datum/squad_db_type/db_sq in squads_list)
		if(db_sq.squad == squad_div)
			return db_sq
/*********************************/
/*		squad list savefile 	 */
/*							 	 */
/*		Only stores cap & Leut	 */

/datum/squad_db_type
	var/squad = 0
	var/cap = ""
	var/cap_level
	var/leut = ""
	var/leut_level

var/list/squads_list = list()

proc/save_squads_list()
	if(fexists(squads_save_loc))
		fdel(squads_save_loc)
	var/savefile/f = new/savefile(squads_save_loc)
	f << squads_list

proc/load_squads_list()
	if(!fexists(squads_save_loc))
		return 0
	var/savefile/f = new/savefile(squads_save_loc)
	f >> squads_list
	return 1