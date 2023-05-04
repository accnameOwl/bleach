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
			icon_state = "zaraki"

			name = "Zaraki Kenpachi"
			level = 85

			aggro_dist=10
			attack_reach = 1
			chase_speed = 2

			Stats = list(
				HEALTH_MAX		= 1000,
				HEALTH_CUR 		= 1000,
				REIATSU_MAX 	= 500,
				REIATSU_CUR 	= 500,
				ATTACK			= 10,
				CRIT			= 10,
				REISHI			= 10,
				HIERRO			= 10)
			respawn_time = 10

			reward_experience = 3500
			reward_attack = 310
			reward_reishi = 35
			reward_hierro = 115
			reward_health = 1520
			reward_reiatsu = 750


			Death(mob/killer)
				..(killer)
				Reward(killer)

		// @Byakuya
		Byakuya
			icon_state = "byakuya"

			name = "Kuchiki Byakuya"
			level = 85

			aggro_dist=10
			attack_reach = 1
			chase_speed = 4

			Stats = list(
				HEALTH_MAX		= 1000,
				HEALTH_CUR 		= 1000,
				REIATSU_MAX 	= 500,
				REIATSU_CUR 	= 500,
				ATTACK			= 10,
				CRIT			= 10,
				REISHI			= 10,
				HIERRO			= 10)
			respawn_time = 10

			reward_experience = 100000
			reward_attack = 42
			reward_reishi = 370
			reward_hierro = 48
			reward_health = 1250
			reward_reiatsu = 1000


			Death(mob/killer)
				..(killer)
				Reward(killer)

		// @Demihollow
		Demihollow
			icon_state = "demihollow"

			name = "Demi"
			level = 6

			aggro_dist=10
			attack_reach = 1
			chase_speed = 4

			Stats = list(
				HEALTH_MAX		= 860,
				HEALTH_CUR 		= 860,
				REIATSU_MAX 	= 300,
				REIATSU_CUR 	= 300,
				ATTACK			= 230,
				CRIT			= 0,
				REISHI			= 41,
				HIERRO			= 60)
			respawn_time = 60

			reward_experience = 32
			reward_attack = 5
			reward_reishi = 3
			reward_hierro = 3
			reward_health = 17
			reward_reiatsu = 8


			Death(mob/killer)
				..(killer)
				Reward(killer)
		// @Hollow
		Hollow
			icon_state = "hollow"

			name = "Hollow"
			level = 15

			aggro_dist=10
			attack_reach = 1
			chase_speed = 2

			Stats = list(
				HEALTH_MAX		= 1200,
				HEALTH_CUR 		= 1200,
				REIATSU_MAX 	= 300,
				REIATSU_CUR 	= 300,
				ATTACK			= 320,
				CRIT			= 0,
				REISHI			= 230,
				HIERRO			= 230)
			respawn_time = 120

			reward_experience = 56
			reward_attack = 11
			reward_reishi = 11
			reward_hierro = 11
			reward_health = 28
			reward_reiatsu = 18


			Death(mob/killer)
				..(killer)
				Reward(killer)

		// @Large Hollow
		LargeHollow
			icon_state = "largehollow"

			New()
				..()
				var/obj/overlay/largehollow/upleft/ul = new
				var/obj/overlay/largehollow/upright/ur = new
				var/obj/overlay/largehollow/up/u = new
				var/obj/overlay/largehollow/downleft/dl = new
				var/obj/overlay/largehollow/downright/dr = new
				overlays += ul
				overlays += u
				overlays += ur
				overlays += dl
				overlays += dr

			name = "Hollow"
			level = 24

			aggro_dist=10
			attack_reach = 1
			chase_speed = 2

			bounds = "1,1 to 32,32"

			Stats = list(
				HEALTH_MAX		= 2500,
				HEALTH_CUR 		= 2500,
				REIATSU_MAX 	= 300,
				REIATSU_CUR 	= 300,
				ATTACK			= 813,
				CRIT			= 20,
				REISHI			= 271,
				HIERRO			= 542)
			respawn_time = 10

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

			Death(mob/killer)
				..(killer)
				Reward(killer)

		// @Menos Grande
		MenosGrande
			icon_state = "menos"
			New()
				..()
				var/obj/overlay/menosgrande/upup/two = new
				var/obj/overlay/menosgrande/up/one = new
				overlays += one
				overlays += two

			name = "Menos Grande"
			level = 35

			aggro_dist=10
			attack_reach = 1
			chase_speed = 2

			bounds = "1,1 to 32,32"

			Stats = list(
				HEALTH_MAX		= 12000,
				HEALTH_CUR 		= 12000,
				REIATSU_MAX 	= 300,
				REIATSU_CUR 	= 300,
				ATTACK			= 2200,
				CRIT			= 20,
				REISHI			= 2200,
				HIERRO			= 2000)
			respawn_time = 60

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

			Death(mob/killer)
				..(killer)
				Reward(killer)

		// @AttackArrancar
		AttackArrancar
			icon_state = "arrancarattack"

			name = "Arrancar"
			level = 100

			aggro_dist=10
			attack_reach = 1
			chase_speed = 3

			Stats = list(
				HEALTH_MAX		= 155000,
				HEALTH_CUR 		= 155000,
				REIATSU_MAX 	= 60000,
				REIATSU_CUR 	= 60000,
				ATTACK			= 80000,
				CRIT			= 20,
				REISHI			= 22000,
				HIERRO			= 50000)
			respawn_time = 600

			reward_experience = 5800
			reward_attack = 630
			reward_reishi = 65
			reward_hierro = 249
			reward_health = 1750
			reward_reiatsu = 680


			Death(mob/killer)
				..(killer)
				Reward(killer)
		// @ReishiArrancar
		ReishiArrancar
			icon_state = "arrancarreishi"

			name = "Arrancar"
			level = 100

			aggro_dist=10
			attack_reach = 1
			chase_speed = 3

			Stats = list(
				HEALTH_MAX		= 155000,
				HEALTH_CUR 		= 155000,
				REIATSU_MAX 	= 60000,
				REIATSU_CUR 	= 60000,
				ATTACK			= 80000,
				CRIT			= 20,
				REISHI			= 22000,
				HIERRO			= 50000)
			respawn_time = 600

			reward_experience = 5800
			reward_attack = 65
			reward_reishi = 630
			reward_hierro = 249
			reward_health = 1750
			reward_reiatsu = 680


			Death(mob/killer)
				..(killer)
				Reward(killer)

		// @Grimjow
		Grimjow
			icon_state = "grimjow"

			name = "Grimjow Jaggerjack"
			level = 120

			aggro_dist=10
			attack_reach = 1
			chase_speed = 4

			Stats = list(
				HEALTH_MAX		= 225000,
				HEALTH_CUR 		= 225000,
				REIATSU_MAX 	= 60000,
				REIATSU_CUR 	= 60000,
				ATTACK			= 120000,
				CRIT			= 20,
				REISHI			= 22000,
				HIERRO			= 80000)
			respawn_time = 600

			reward_experience = 12000
			reward_attack = 2000
			reward_reishi = 600
			reward_hierro = 1000
			reward_health = 17500
			reward_reiatsu = 8500


			Death(mob/killer)
				..(killer)
				Reward(killer)


		// @Ulquiorra
		Ulquiorra
			icon_state = "ulquiorra"

			name = "Ulquiorra Cifer"
			level = 120

			aggro_dist=10
			attack_reach = 1
			chase_speed = 4

			Stats = list(
				HEALTH_MAX		= 2200000,
				HEALTH_CUR 		= 2200000,
				REIATSU_MAX 	= 1000000,
				REIATSU_CUR 	= 1000000,
				ATTACK			= 73000,
				CRIT			= 20,
				REISHI			= 40000,
				HIERRO			= 56000)
			respawn_time = 10

			reward_experience = 12000
			reward_attack = 600
			reward_reishi = 2000
			reward_hierro = 1000
			reward_health = 17500
			reward_reiatsu = 8500


			Death(mob/killer)
				..(killer)
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