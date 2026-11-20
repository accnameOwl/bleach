

client

	var/static/chat_template = file2text("dependencies/html/templates/chat.html")

	var/alist/pending_messages = list()
	var/alist/message_log = list()

	proc
		init_chat()
			set background = 1
			set waitfor = 0

			src << output(chat_template, "main.chat")
			await_response("chat")
			world.log << page_ready["chat"]
			if(message_log && (message_log.len > 1))
				src << output(list2params(message_log), "main.chat:addMessages")
			if(mob.is_admin())
				world.log << "is admin!"
				src << output(null,"main.chat:addAdminChannel")





	verb
		ChatMessage(channel as text, message as text)
			if(!channel || !message)
				return

			if(!(channel in channels))
				return

			else
				chat(channel, message)

	proc
		// # called on cient.Tick()
		has_pending_messages()
			if(length(pending_messages))
				return TRUE
			else return FALSE

		push_messages()
			message_log += pending_messages

			if(message_log.len >= 350)
				var/oversize = message_log.len - 350
				message_log.Cut(1,oversize)

			src << output(json_encode(pending_messages), "main.chat:addMessages")

			pending_messages = list()




	var/static/list/blacklist_words = json_decode(file2text("dependencies/json/chat_blacklist.json"))
	var/static/list/ignore_characters = list("!","@","#","$","%","^","&","*","(",")","-","_","+","=","[","]","{","}","<",">","/","\\","|","~","`","'","\"",";",":",",",".","?")

	proc
		// ! THIS IS NOT USED YET.
		// The message should be filtered from:
		// 		client/verb/ChatMessage() => {...;chat(channel, filter_message(message))};
		//
		// ? Maybe we shouldn't use it...? NO FILTER YOU FUCK
		filter_message(msg)

			var/normalized_word = ""
			var/list/word_position = list()

			for(var/i= 1, i <= length(msg) + 1, i++)
				var/char = i <= length(msg) ? copytext(msg, i, i+1) : " "

				if(char == " ")
					if(normalized_word && (normalized_word in blacklist_words))
						for(var/position in word_position)
							msg = copytext(msg,1,position) + "*" + copytext(msg, position+1)

					normalized_word = ""
					word_position.Cut()

					continue

				if(char in ignore_characters)
					continue

				normalized_word += lowertext(char)
				word_position += i
			return msg



	var/list/chat_log = list()
	var/static/emojis = json_decode(file2text("dependencies/json/emojis.json"))
	var/static/channels = list("say", "ooc", "whisper", "admin", "log")

	proc
		get_prefix(channel)
			var/prefix = ""

			if(mob.admin && channel == "ooc")
				prefix += "<font color=red>(GM)</font>"

			switch(channel)
				if("say")
					prefix += "[mob.name]: "

				if("ooc")
					var/g = ""
					if(mob.guild != null)
						g = mob.guild
					prefix += "[g] <font color=darkred>[mob.name]  OOC:</font> "

				else
					prefix = ""

			return prefix

		#define newline "<br>"
		chat(channel, msg)

			if(!(channel in channels))
				return

			var/mob/character = src.mob
			switch(channel)
				if("world")
					for(var/client/c)
						c.pending_messages += Red(msg) + newline

				if("say")
					world.log << "[channel]: [msg]"
					for(var/mob/m in view(8, character))
						m.client?.pending_messages += White(get_prefix(channel) + msg) + newline

				if("ooc")
					for(var/client/c)
						c.pending_messages += Grey(get_prefix(channel) + msg) + newline

				if("whisper")
					// First find the player name, which would be the first word of the message received.
					var/list/i = splittext(msg, "%20") // Have to look for encoded spaces, i.e %20
					var/receiver = i[1]

					// ! No message is found.
					if(i.len <= 1)
						return

					// start message from second position, leaving out the name.
					// Join text with spaces.
					msg = jointext(i, "%20", 2)
					for(var/client/c)
						var/mob/m = c.mob
						if(m && (m.name == receiver))
							c.pending_messages += Purple("From [src.mob]: " + msg) + newline
							src.pending_messages += Purple("To [m]: " + msg) + newline
							return
					src.pending_messages += Red("Player not found.") + newline

				if("admin")
					for(var/client/c)
						if(c.mob.admin)
							c.pending_messages += Bold(Turquoise(get_prefix(channel) + msg)) + newline
				if("log")
					src.pending_messages += Bold(Red(msg)) + newline

				// # NPC Dialogue.
				// ! REDUNDANT! Using "proc/npc_dialogue" for maptext object text(I THINK)
				//
				//	The messages are parsed and formated by client.chat(), and doesn't need to be formated for each mob.
				// 	Simply write dialoguies by passing client?.chat("dialogue", "[Name] Then every other word from the message")
				//
				// @params:
				// First pos word: Name
				// ... pos words: Message
				if("dialogue")
					var/words = splittext(msg, " ")
					var/__npc_name = words[1]
					msg = jointext(words, " ", 2)
					src.pending_messages += Bold(Yellow(__npc_name) + " Says: " + Grey(msg)) + newline

		#undef newline
