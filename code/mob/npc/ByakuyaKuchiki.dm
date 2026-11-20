

mob/NPC/ByakuyaKuchiki
	icon = 'byakuya_kuchiki.dmi'
	json_id = "byakuya"
	respawn_time = 1

	verb/Talk()
		set src in oview(2)
		set category = "Talk"
		var/mob/player/player = usr
		var/accept_challenge = alert("Do you wish to challange me, [usr.name]", "Challenge Byakuya","Yes","No")
		if(accept_challenge == "No")
			return 0
		if(player.challenge_list["byakuya"])
			var/no_reward = alert("You already recieved your reward, and will not be awarded once more. Continue?", "Challenge Byakuya", "Yes","No")
			if( no_reward == "No")
				return 0
		else
			var/with_reward = alert("You will be rewarded a small boost and release mastery", "Challenge Byakuya","Ok","Leave")
			if(with_reward == "Leave")
				return 0
		player << Bold(Yellow(Center("Defeat Byakuya Kuchiki")))
		player << Red(Center("Starting challenge in 5 seconds"))