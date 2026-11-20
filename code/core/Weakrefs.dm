datum
	var/tmp
		weakref	//if this object has a live weak reference, this will be its ref string

	//call to get a weak reference to this object
	proc/Weakref()
		if(weakref)
			//if we already have a weak reference, return the same one
			return locate(weakref)
		else
			//otherwise, create a new weak reference to be returned
			. = new/weakref("\ref[src]")

			//store its ref string
			weakref = "\ref[.]"
			return .

weakref
	var/tmp
		refid	//this was the last known refstring for the object being referenced

	//convert the weak reference to a hard reference
	//returns null if invalid (object no longer exists)
	proc/Object()
		if(refid)
			//the refid might still be valid, so validate it
			var/datum/d = locate(refid)

			if(d && d.weakref=="\ref[src]")
				//if we got an object back, and it still points to this weak reference, return it
				return d
			else
				//otherwise invalidate the reference id
				refid = null

		//return null on failure
		return null

	//when a weakref is no longer used, allow it to be cleaned up
	Del()
		//we need to clear the object's weakref pointer so it doesn't get used again
		if(refid)
			Object()?:weakref = null
		..()