#ifdef DEBUG
var/log_level_exp_req = ""
#endif


proc/inverse_log_req_exp(input)
	return ceil(30 - (19 * log(input) / log(100)))

mob


	proc
		#define AVG_MAX_LEVEL 150
		#define EXP_INCREASE_ALG round( (req_exp/50)*1.33 + inverse_log_req_exp(level) )



		gain_experience(value)
			var/v = round(value)

			exp += v
			total_exp += v

			while(exp >= req_exp)
				++level
				client?.dirty_stat("level")
				client?.chat("log", Bold(Gold("+Level up ") + Silver("[level]") + Gold("!")))

				exp -= req_exp
				var/req_diff = EXP_INCREASE_ALG
				var/inv_log_req_exp = inverse_log_req_exp(level)
				req_exp += req_diff

				#ifdef DEBUG
				log_level_exp_req += "Level [level]\treq_exp:[req_exp](+[req_diff]); log:[inv_log_req_exp]\n"
				#endif
				
				CheckRaceRewards()

				if(exp < 0)
					exp = 0


			client?.dirty_stat("exp","req_exp")