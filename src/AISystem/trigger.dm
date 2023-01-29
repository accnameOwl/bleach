/datum/trigger
	parent_type = /obj

	#ifdef __TEST__
	icon = 'trigger.dmi'
	#endif

	var/mob/anchored_to

/datum/trigger/New(mob/anchor)
	anchored_to = anchor

/datum/trigger/Crossed(mob/m)
	if(!ismob(m)) return
	anchored_to.Trigger(m)

/datum/trigger/proc/ChangeBounds(x_offset = 0, y_offset = 0, extra_width = 0, extra_height = 0)
	pixel_x -= x_offset
	pixel_y -= y_offset
	bound_width = extra_width * world.icon_size
	bound_height = extra_height * world.icon_size

	step_x = (bound_width / 2)*-1
	step_y = (bound_height / 2)*-1

/datum/trigger/proc/Scale(_x, _y)
	transform = new/matrix().Scale(_x+1,_y+1)

/datum/trigger/proc/SetStep(mob/m)
	step_x = ((bound_width/2)-m.step_x)*-1
	step_y = ((bound_height/2)-m.step_y)*-1

mob/proc/Trigger()