atom/movable
	step_size = 6
	var/cached_step_size = 6
	var/step_delay=0.25
	var/tmp/last_step = -1#INF
	var/tmp/next_step = -1#INF

atom/movable/proc/Step(dir, delay=step_delay)
	if(next_step - world.time >= world.tick_lag/10)
		return 0
	else
		if(step(src, dir))
			last_step = world.time
			next_step = last_step + step_delay
			return 1
		else
			return 0

mob
	step_size = MOB_STEP_SIZE
	monster
		step_size = MONSTER_STEP_SIZE
	
	Step(dir, delay=step_delay)
		if(next_step - world.time >= world.tick_lag/10)
			return 0
		if(step(src, dir))
			last_step = world.time
			next_step = last_step + step_delay
			return 1
		else
			return 0

obj
	step_size = OBJ_STEP_SIZE

client
	Move(atom/loc, dir)
		if(mob.resting)
			return 0
		walk(usr,0)
		return mob.Step(dir)

	proc
		move_loop()
			set waitfor = 0
			var/list/k = keybinds
			while(src)
				var/move_dir = k["DpadU"].getValue() + k["DpadD"].getValue() + k["DpadL"].getValue() + k["DpadR"].getValue()
				if((move_dir&3)==3) move_dir -= 3
				if((move_dir&12)==12) move_dir -= 12
				if(move_dir)
					mob.Step(/*src.mob,*/ move_dir, mob.step_size)
				sleep(10/world.fps)