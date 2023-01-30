mob
	var/hasShikai = 0
	var/shikaiMastery = 0
	var/hasBankai = 0
	var/bankaiMastery = 0
	var/squad = 0

mob/proc/GiveShikai()
	return hasShikai = 1

mob/proc/GiveBankai()
	return hasBankai = 1

/**
	SQUAD STUFF....
*/


//Checks for captain requirements.
mob/proc/CheckCaptainReq()
	if(level >= 100 && race == "shinigami")
		var/datum/shinigami_squad/s = squadlist && squadlist[squad]
		if(s)
			var/mob/_capt = s.captain
			if(_capt && (_capt.level <= level))
				squadlist[squad].MakeCaptain(src)

//returns if player is captain or not.
//If there is a new captain, remove rank.
mob/proc/check_captain()
	if(src.rank == "captain")
		if(squadlist[squad] && squadlist[squad].captain)
			var/mob/_capt = squadlist[squad].captain
			if(_capt!=src)
				src.rank = "member"
				return FALSE
		else
			return TRUE


mob/verb/checkSquadCaptains()
	set name = "captains"
	src << Bold(Yellow("Soul society divisions:"))
	for(var/i = 1, i < 13, i++)
		var/datum/shinigami_squad/sq =  squadlist && squadlist[i]
		src << Bold(Silver("Squad [sq.name]: "))
		
		var/cn = sq.captain ? sq.captain.name : ""
		var/cl = sq.captain ? sq.captain.level : ""
		var/ln = sq.leutenant ? sq.leutenant.name : ""
		var/ll = sq.leutenant ? sq.leutenant.level : ""

		src << Bold(Silver("     Captain: [cn] - [cl]"))
		src << Bold(Silver("     Leutenant: [ln] - [ll]"))

mob/squad/verb/Say()
	set category = "Squad"

	var/datum/shinigami_squad/sq = squadlist && squadlist[squad]
	var/msg = input("What do you whish to say to your squad", "Squad")
	
	for(var/mob/m in sq.members)
		m << Bold(Red("[html_encode(src.name)] Squad Say: ") + Grey(msg))
//TODO
mob/squad/captain/verb/MakeLeutenant()
	set category = "Squad"
	set name = "Make Leutenant"

var/list/squadlist = list()
	
// Called in world/New()
proc/squadlist_init()
	if(!squadlist.len) return
	squadlist = list(
		1 = new/datum/shinigami_squad(1),
		2 = new/datum/shinigami_squad(2),
		3 = new/datum/shinigami_squad(3),
		4 = new/datum/shinigami_squad(4),
		5 = new/datum/shinigami_squad(5),
		6 = new/datum/shinigami_squad(6),
		7 = new/datum/shinigami_squad(7),
		8 = new/datum/shinigami_squad(8),
		9 = new/datum/shinigami_squad(9),
		10 = new/datum/shinigami_squad(10),
		11 = new/datum/shinigami_squad(11),
		12 = new/datum/shinigami_squad(12),
		13 = new/datum/shinigami_squad(13)
	)

/datum/shinigami_squad
	var/name
	var/list/members = list()
	var/mob/leutenant
	var/mob/captain

/datum/shinigami_squad/New(nr = 0)
		name = nr

/datum/shinigami_squad/Del()

/datum/shinigami_squad/proc/MakeCaptain(mob/new_captain)
	captain = new_captain
	new_captain.rank = "captain"

/datum/shinigami_squad/proc/MakeLeutenant(mob/new_leutenant)
	leutenant = new_leutenant
	new_leutenant.rank = "leutenant"

/datum/shinigami_squad/proc/NewMember(mob/member)
	members.Add(member)
	member.rank = "member"
