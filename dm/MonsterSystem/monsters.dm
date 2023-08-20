mob
	monster

		icon = 'monsters.dmi'

		verb
			Bala()
				//small, weak, no traces
			Cero()
				//Normal Cero, leaving traces
			GranReyCero()
				//3xCero, leaving traces
			Sonido()
				//Step behind target

		// @Zaraki
		Zaraki
			name = "Zaraki Kenpachi"
			icon_state = "zaraki"

			aggro_dist=10
			attack_reach = 1
			chase_speed = 2
			respawn_time = 10

			level = 85
			health = 1000
			reiatsu =500
			attack = 10
			reishi = 10
			hierro = 10

			reward_experience = 3500
			reward_attack = 310
			reward_reishi = 35
			reward_hierro = 115
			reward_health = 1520
			reward_reiatsu = 750


			DeathCheck(mob/killer)
				.=..(killer)
				if(.)
					Reward(killer)

		// @Byakuya
		Byakuya
			name = "Kuchiki Byakuya"
			icon_state = "byakuya"

			aggro_dist=10
			attack_reach = 1
			chase_speed = 4
			respawn_time = 10

			level = 85
			health = 1000
			reiatsu =500
			attack = 10
			reishi = 10
			hierro = 10

			reward_experience = 100000
			reward_attack = 42
			reward_reishi = 370
			reward_hierro = 48
			reward_health = 1250
			reward_reiatsu = 1000


			DeathCheck(mob/killer)
				.=..(killer)
				if(.)
					Reward(killer)

		// @Demihollow
		Demihollow
			name = "Demi hollow"
			icon_state = "demihollow"

			aggro_dist=10
			attack_reach = 1
			chase_speed = 4
			respawn_time = 60

			level = 6
			health = 860
			reiatsu =300
			attack = 230
			reishi = 41
			hierro = 60

			reward_experience = 32
			reward_attack = 5
			reward_reishi = 3
			reward_hierro = 3
			reward_health = 17
			reward_reiatsu = 8


			DeathCheck(mob/killer)
				.=..(killer)
				if(.)
					Reward(killer)
		// @Hollow
		Hollow
			icon_state = "hollow"

			name = "Hollow"
			level = 15
			race = "Hollow"

			aggro_dist=10
			attack_reach = 1
			chase_speed = 2
			respawn_time = 120

			health = 1200
			reiatsu =300
			attack = 320
			reishi = 230
			hierro = 230

			reward_experience = 56
			reward_attack = 11
			reward_reishi = 11
			reward_hierro = 11
			reward_health = 28
			reward_reiatsu = 18


			DeathCheck(mob/killer)
				.=..(killer)
				if(.)
					Reward(killer)

		// @Large Hollow
		LargeHollow
			name = "Hollow"
			icon_state = "largehollow"

			aggro_dist=10
			attack_reach = 1
			chase_speed = 2
			respawn_time = 10

			bounds = "1,1 to 32,32"

			level = 24
			health = 2500
			reiatsu =300
			attack = 813
			reishi = 271
			hierro = 542

			reward_experience = 120
			reward_attack = 24
			reward_reishi = 24
			reward_hierro = 24
			reward_health = 64
			reward_reiatsu = 32

			step_rand_loop()
				while(src)
					if(combat_flag.in_combat)
						break
					if(combat_flag.dead)
						break
					var/_locToWalk
					dir = pick( NORTH, SOUTH, EAST, WEST)
					switch(dir)
						if(NORTH)
							_locToWalk = locate(x,y+2,z)
						if(SOUTH)
							_locToWalk = locate(x,y-2,z)
						if(EAST)
							_locToWalk = locate(x+2,y,z)
						if(WEST)
							_locToWalk = locate(x-2,y,z)
					walk_towards(src, _locToWalk,0,1)
					if(ai_trigger)
						ai_trigger.loc = loc
					sleep(rand(50,110))

			DeathCheck(mob/killer)
				.=..(killer)
				if(.)
					Reward(killer)

			var/obj/overlay/largehollow/upleft/ul = new
			var/obj/overlay/largehollow/upright/ur = new
			var/obj/overlay/largehollow/up/u = new
			var/obj/overlay/largehollow/downleft/dl = new
			var/obj/overlay/largehollow/downright/dr = new

			New()
				..()
				overlays += ul
				overlays += u
				overlays += ur
				overlays += dl
				overlays += dr

		// @Menos Grande
		MenosGrande
			name = "Menos Grande"
			icon_state = "menos"

			aggro_dist=10
			attack_reach = 1
			chase_speed = 2
			respawn_time = 60

			bounds = "1,1 to 32,32"

			level = 35
			health = 12000
			reiatsu =300
			attack = 2200
			reishi = 2200
			hierro = 2000

			reward_experience = 120 * 3
			reward_attack = 24 * 3
			reward_reishi = 24 * 3
			reward_hierro = 24 * 3
			reward_health = 64 * 3
			reward_reiatsu = 32 * 3

			step_rand_loop()
				while(src)
					if(combat_flag.in_combat)
						break
					if(combat_flag.dead)
						break
					var/_locToWalk
					dir = pick( NORTH, SOUTH, EAST, WEST)
					switch(dir)
						if(NORTH)
							_locToWalk = locate(x,y+2,z)
						if(SOUTH)
							_locToWalk = locate(x,y-2,z)
						if(EAST)
							_locToWalk = locate(x+2,y,z)
						if(WEST)
							_locToWalk = locate(x-2,y,z)
					walk_towards(src, _locToWalk,0,1)
					if(ai_trigger)
						ai_trigger.loc = loc
					sleep(rand(50,110))

			DeathCheck(mob/killer)
				.=..(killer)
				if(.)
					Reward(killer)

			var/obj/overlay/menosgrande/upup/two = new
			var/obj/overlay/menosgrande/up/one = new

			New()
				..()
				overlays += one
				overlays += two

		// @AttackArrancar
		AttackArrancar
			name = "Arrancar"
			icon_state = "arrancarattack"

			aggro_dist=10
			attack_reach = 1
			chase_speed = 3
			respawn_time = 600

			level = 100
			health = 155000
			reiatsu =60000
			attack = 80000
			reishi = 22000
			hierro = 50000

			reward_experience = 5800
			reward_attack = 630
			reward_reishi = 65
			reward_hierro = 249
			reward_health = 1750
			reward_reiatsu = 680

			DeathCheck(mob/killer)
				.=..(killer)
				if(.)
					Reward(killer)

		// @ReishiArrancar
		ReishiArrancar
			name = "Arrancar"
			icon_state = "arrancarreishi"

			aggro_dist=10
			attack_reach = 1
			chase_speed = 3
			respawn_time = 600

			level = 100
			health = 155000
			reiatsu =60000
			attack = 80000
			reishi = 22000
			hierro = 50000

			reward_experience = 5800
			reward_attack = 65
			reward_reishi = 630
			reward_hierro = 249
			reward_health = 1750
			reward_reiatsu = 680

			DeathCheck(mob/killer)
				.=..(killer)
				if(.)
					Reward(killer)

		// @Grimjow
		Grimjow
			name = "Grimjow Jaggerjack"
			icon_state = "grimjow"

			aggro_dist=10
			attack_reach = 1
			chase_speed = 4
			respawn_time = 600

			level = 120
			health = 225000
			reiatsu =60000
			attack = 120000
			reishi = 22000
			hierro = 80000

			reward_experience = 12000
			reward_attack = 2000
			reward_reishi = 600
			reward_hierro = 1000
			reward_health = 17500
			reward_reiatsu = 8500

			DeathCheck(mob/killer)
				.=..(killer)
				if(.)
					Reward(killer)

		// @Ulquiorra
		Ulquiorra
			name = "Ulquiorra Cifer"
			icon_state = "ulquiorra"

			aggro_dist=10
			attack_reach = 1
			chase_speed = 4
			respawn_time = 10

			level = 120
			health = 2200000
			reiatsu =1000000
			attack = 73000
			reishi = 40000
			hierro = 56000

			reward_experience = 12000
			reward_attack = 600
			reward_reishi = 2000
			reward_hierro = 1000
			reward_health = 17500
			reward_reiatsu = 8500

			DeathCheck(mob/killer)
				.=..(killer)
				if(.)
					Reward(killer)

obj/overlay/largehollow
	icon = 'monsters.dmi'
	upleft
		icon_state = "largehollowupleft"
		pixel_y = 32
		pixel_x = -32
	up
		icon_state = "largehollowup"
		pixel_y = 32
	upright
		icon_state = "largehollowupright"
		pixel_y = 32
		pixel_x = 32
	downleft
		icon_state = "largehollowdownleft"
		pixel_x = -32
	downright
		icon_state = "largehollowdownright"
		pixel_x = 32

obj/overlay/menosgrande
	icon = 'monsters.dmi'
	upup
		icon_state = "menos2"
		pixel_y = 64
	up
		icon_state = "menos1"
		pixel_y = 32