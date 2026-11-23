
client
	var
		// static variable => preferable to keep in scope, rather than global.
		block_move = 0
		block_input = 0
		tmp/move_dir = 0
		tmp/vector/move_vector = vector(0,0)



mob/player
	bound_x = 10
	bound_y = 0
	bound_width = 12
	bound_height = 12

atom/movable
	animate_movement = SLIDE_STEPS
	appearance_flags = LONG_GLIDE
	var
		step_speed = 15
		step_delay = 1
		block_steps = 0

		acceleration = 2
		deceleration = 2
		tmp
			last_step = -1#INF
			next_step = -1#INF

		prevent_movement = FALSE

	proc

		Glide(Dir=src.dir, Dist=step_speed||step_size||world.icon_size, Delay=src.step_delay)
			if(!isnum(Dir))
				Dir = Dir * Dist
			next_step = world.time + Delay
			step_size = ceil(Dist)
			glide_size = floor(Dist / (Delay/world.tick_lag || 1))
			if(!isnum(Dir))
				return step(src, Dir)
			else
				return step(src, Dir, Dist)

		// returns true if ready to take next step
		can_step()
			return next_step <= world.time

		// wrapper function
		// add conditions to 'step()'
		Step( Dir = src.dir, Dist = step_speed||step_size||world.icon_size, Delay = src.step_delay)
			if(can_step())
				if(!Dist)
					if(!isnum(Dir))
						dir = Dir
					else
						dir = vec2dir(Dir)
					return 0
				return Glide(Dir, Dist, Delay)

		StepOffset(x_offset, y_offset)
			step_x = x_offset
			step_y = y_offset

atom/movable
	proc
		OpenGaps(Dir, Dist=0)
			if(istype(Dir,/vector))
				var/v
				Dir= ((v=Dir:x)>0.01 ? EAST : (v<-0.01?WEST:0)) +((v=Dir:y)>0.01 ? NORTH : (v<-0.01 ? SOUTH : 0))
			var/bound_half, bound_gap, near, far
			var/min_pos, max_pos

			switch(Dir)
				if(NORTH, SOUTH)
					bound_half = bound_width / 2
					bound_gap = bound_half / 2

					near = pixloc(src).x
					far = near + bound_width

					min_pos = far; max_pos = near
					for(var/atom/o in obounds(src, -bound_gap, Dir==SOUTH ? -1 : 0, bound_half, 1) - obounds(src))
						if(!o.Cross(src))
							min_pos = min(min_pos, pixloc(o).x)
							max_pos = max(max_pos, pixloc(o, ismovable(o) ? o:bound_width : world.icon_size, 0).x)

					near = bound_width - (min_pos - near)
					far = bound_width - (far - max_pos)

					if(near <= bound_gap)
						*Dist = min(near, *Dist)
						return WEST
					else if(far <= bound_gap)
						*Dist = min(far, *Dist)
						return EAST
				if(EAST, WEST)
					bound_half = bound_height / 2
					bound_gap = bound_half / 2

					near = pixloc(src).y
					far = near + bound_height

					min_pos = far; max_pos = near
					for(var/atom/o in obounds(src, Dir==WEST ? -1 : 0, -bound_gap, 1, bound_half) - obounds(src))
						if(!o.Cross(src))
							min_pos = min(min_pos,pixloc(o).y)
							max_pos = max(max_pos,pixloc(o,0,ismovable(o) ? o:bound_height : world.icon_size).y)

					near = bound_height - (min_pos - near)
					far = bound_height - (far - max_pos)

					if(near <= bound_gap)
						*Dist = min(near,*Dist)
						return SOUTH
					else if(far <= bound_gap)
						*Dist = min(far, *Dist)
						return NORTH

			return Dir

atom/movable
	proc
		OpenSides(Dir)
			var/x = 0, y= 0
			if(istype(Dir, /vector))
				Dir = ((x=Dir:x>0.01 ? EAST: (x<-0.01 ? WEST : 0)) + ((y=Dir:y)>0.01 ? NORTH : (y<-0.01?SOUTH:0)))
				var/list/overlapping = obounds(src)
				#define check_side(side, obstacles) for(var/atom/o in (obstacles)) {if(!o.Cross(src)){Dir&=~(side)}}
				switch(Dir)
					if(NORTH)
						check_side(NORTH, obounds(src,0,1) - overlapping)
					if(SOUTH)
						check_side(SOUTH, obounds(src,0,-1) - overlapping)
					if(EAST)
						check_side(EAST, obounds(src,1,0) - overlapping)
					if(WEST)
						check_side(WEST, obounds(src,-1,0) - overlapping)

					if(NORTHEAST)
						check_side(NORTH, obounds(src,0,1) - overlapping)
						check_side(EAST, obounds(src,1,0) - overlapping)
					if(NORTHWEST)
						check_side(NORTH, obounds(src,0,1) - overlapping)
						check_side(WEST, obounds(src,-1,0) - overlapping)
					if(SOUTHEAST)
						check_side(SOUTH, obounds(src,0,-1) - overlapping)
						check_side(EAST, obounds(src,1,0) - overlapping)
					if(SOUTHWEST)
						check_side(SOUTH, obounds(src,0,-1) - overlapping)
						check_side(WEST, obounds(src,-1,0) - overlapping)
				switch(Dir)
					if(NORTH)
						if(pixloc(src,0,bound_height).y >= (world.maxy+1)*world.icon_size) Dir &= ~NORTH
					if(SOUTH)
						if(pixloc(src).y <=1) Dir &= ~SOUTH
					if(EAST)
						if(pixloc(src, bound_width, 0).x >= (world.maxx+1)*world.icon_size) Dir &= ~EAST
					if(WEST)
						if(pixloc(src).x <= 1) Dir &= ~WEST
					if(NORTHEAST)
						var/pixloc/p = pixloc(src,bound_width,bound_height)
						if(p.y >= (world.maxy+1) * world.icon_size) Dir &= ~NORTH
						if(p.x >= (world.maxx+1) * world.icon_size) Dir &= ~EAST
					if(NORTHWEST)
						var/pixloc/p = pixloc(src,0,bound_height)
						if(p.y >= (world.maxy+1) * world.icon_size) Dir &= ~NORTH
						if(p.x <= 1) Dir &= ~WEST
					if(SOUTHEAST)
						var/pixloc/p = pixloc(src,bound_width,0)
						if(p.y <= 1) Dir &= ~SOUTH
						if(p.x >= (world.maxx+1) * world.icon_size) Dir &= ~EAST
					if(SOUTHWEST)
						var/pixloc/p = pixloc(src)
						if(p.y <= 1) Dir &= ~SOUTH
						if(p.x <= 1) Dir &= ~WEST

				switch(Dir)
					if(NORTHEAST)
						check_side((y>=x ? NORTH : EAST),obounds(src,1,1) - overlapping)
					if(NORTHWEST)
						check_side((y>=x ? NORTH : WEST),obounds(src,-1,1) - overlapping)
					if(SOUTHEAST)
						check_side((y>=x ? SOUTH : EAST),obounds(src,1,-1) - overlapping)
					if(SOUTHWEST)
						check_side((y>=x ? SOUTH : WEST),obounds(src,-1,-1) - overlapping)
				#undef check_side
				return Dir

atom/movable
	proc
		SlideStep(Dir=src.dir, Dist=step_speed||step_size||world.icon_size, Delay=src.step_delay)
			if(can_step())
				var/open = Dir
				if(Dir & (Dir - 1))
					open = OpenSides(Dir)
				else
					open = OpenSides(Dir) || OpenGaps(Dir, &Dist)

				if(!Dist || !open)
					if(isnum(Dir))
						dir = Dir
					else
						dir = vec2dir(Dir)
				else
					return Glide(open, Dist, Delay)

atom/movable
	proc
		get_pixloc_dist(pixloc/a, pixloc/b)
			return sqrt((a.x**2 - b.x**2) + (a.y**2 - b.y**2))