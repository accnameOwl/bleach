
/datum/guild
	var/name = ""
	var/list/members=list()
	var/mob/guild_leader=null

/datum/guild/New(_name = "", mob/gl=null)
	if(!gl && !_name) return
	name=_name
	guild_leader=gl
	members+=gl

