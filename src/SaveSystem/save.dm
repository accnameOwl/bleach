// @TODO
// Saving removes all overlays...
// Don't let this happen.

datum/Write(var/savefile/F, var/list/neversave=null)
	if(neversave != null && istype(neversave, /list) && neversave.len >= 1)
		var/i
		for(var/v in neversave)
			if(!issaved(vars[v]))
				neversave.Remove(v)
			else
				i = initial(vars[v])
				if(i != vars[v])
					neversave[v] = vars[v]
					vars[v] = i
				else
					neversave.Remove(v)
		. = ..(F)
		for(var/v in neversave)
			vars[v] = neversave[v]
		return
	else
		return ..(F)

datum/Read(var/savefile/F, var/list/neversave=null)
	if(neversave != null && istype(neversave,/list) && neversave.len >= 1)
		for(var/v in neversave)
			if(!issaved(vars[v]))
				neversave.Remove(v)
			else
				neversave[v] = vars[v]
		. = ..(F)
		for(var/v in neversave)
			vars[v] = neversave[v]
		return
	else
		return ..(F)

datum/proc/NeverSave(var/list/L)
	return L

atom/NeverSave(var/list/L)
	//deploy list of data not to store
	//L.Add("icon","icon_state","overlays","underlays","debuffs")
	return ..(L)

atom/Write(var/savefile/F,var/list/neversave=null)
	if(neversave==null)
		neversave = src.NeverSave(list())
	var/list/ol
	var/list/ul
	if(src.overlays!=initial(overlays)&&neversave.Find("overlays"))
		ol = overlays.Copy(1,0)
		overlays = initial(overlays)
		neversave.Remove("overlays")
	if(underlays!=initial(underlays)&&neversave.Find("underlays"))
		ul = underlays.Copy(1,0)
		underlays = initial(underlays)
		neversave.Remove("underlays")
	. = ..(F,neversave)
	if(ol!=null && ol.len)
		overlays.Add(ol)
	if(ul!=null && ul.len)
		underlays.Add(ul)

atom/Read(var/savefile/F,var/list/neversave=null)
	if(neversave==null)
		neversave = NeverSave(list())
	return ..(F,neversave)

atom/movable/NeverSave(var/list/L)
	L.Add("screen_loc")
	return ..(L)

mob/NeverSave(var/list/L)
	L = ..(L)
	L.Remove("icon")
	return L
mob/Write(var/savefile/F,var/list/neversave=null)
	. = ..(F,neversave)
	var/ocd = F.cd
	F.cd = "location"
	F << src.x
	F << src.y
	F << src.z
	F.cd = ocd
	return .
mob/Read(var/savefile/F,var/list/neversave=null)
	. = ..(F,neversave)
	var/ocd = F.cd
	F.cd = "location"
	F >> src.x
	F >> src.y
	F >> src.z
	F.cd = ocd
	return .


mob/proc/save()
	var/savefile/F = new/savefile(save_loc)
	F << src
	return TRUE
mob/proc/load()
	if(fexists(save_loc))
		var/savefile/F = new/savefile(save_loc)
		F >> src
		return TRUE
	else
		return FALSE

mob/verb/Save()
	if(save())
		world << Bold(Red("Saved!"))