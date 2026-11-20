var/list/online_players = list()

mob

	#ifdef DEBUG
	density = 0
	#endif

	var
		tmp
			last_time_trained = -1#INF // world.time
			AFK = 0
			combat_state = 0
			mob/target = null
			respawn_loc = ""
		list
			spell_mastery = list()
			spell_cd = list()


		level = 0

		can_block = FALSE
		block_chance = 0
		block_amount = 0 // normalized nummber: 1.0 = 100%
		block_flags = 0
			// CombatUtil.DEFENCE -> adds a  wierd thing to mitigation value.


		attack_buff_multipl = 1
		stat_reiatsu_buff_multipl = 1
		defense_buff_multipl = 1

		// CombatUtil Flags


		reward_experience
		reward_money
		reward_attack
		reward_stat_reiatsu
		reward_defense
		reward_health
		reward_reiatsu

		title = ""
		kills = 0
		money = 0
		//Special attributes. (They don't require to be /datum/stat types)
		//dodge:	Max 25% -> 1sp=.5%
		dodge = 0
		//regeneration: max 10% -> 1sp=.5%
		regeneration = 0

		icon/hair
		race = "Soul"
		racerank = ""

		in_bankai = FALSE
		in_shikai = FALSE

		exp = 0
		req_exp = 100
		fatigue = 0
		total_exp = 0
		zan_name = ""
		has_shikai = 0
		shikai_mastery = 0
		has_bankai = 0
		bankai_mastery = 0
		resting = 0
		realm = "Earth"
		Guild/guild
		list
			challenge_list = list()
			known_spells_list = list()

		alist/kido_list = alist(
			INDEX_KIDO_BYAKURAI=0,  //byakurai
			INDEX_KIDO_SHAKKAHO=0, //shakkaho
			INDEX_KIDO_SOKATSUI=0, //sokatsui
			INDEX_KIDO_RAIKOHO=0, //raikoho
			INDEX_KIDO_HIRYUGEKIZOKUSHINTENRAIHO=0, //hiryu Gekizoku Shinten Raiho
			INDEX_KIDO_KUROHITSUGI=0, //kurohitsugi
			INDEX_KIDO_SENJUKOTENTAIHO=0, //senju koten Taiho
			INDEX_KIDO_ITTOKASO=0, //itto kaso
			INDEX_KIDO_GORYUTENMETSU=0  //Goryutenmetsu
		)


	proc
		is_dead()
			return hp <= 0