
/datum/guild
	var/name = ""
	var/list/members=list()
	var/mob/guild_leader=null

/datum/guild/New(_name = "", mob/gl=null)
	name=_name
	guild_leader=gl
	members+=guild_leader
	guild_leader.verbs += /mob/guild/verb/Invite
	guild_leader.verbs += /mob/guild/verb/Say

