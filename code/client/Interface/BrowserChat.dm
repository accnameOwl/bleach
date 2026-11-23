


/*
var/list/emojis = json_decode(file2text("dependencies/json/emojis.json"))

client/proc/OpenChatBrowser()
	var/list/chat_log = view_game_log ? game_log_messages : personal_chat_messages

	var/html_log = ""
	for (var/msg in chat_log)
		html_log += "[msg]<br>"

	var/html = {"
    <html>
    <head>
        <meta charset='UTF-8'>
		<style>
		    @import url('https://fonts.googleapis.com/css2?family=Orbitron:wght@500;700&display=swap');
			@import url('https://fonts.googleapis.com/css2?family=Average+Sans:wght@500;700&display=swap');

		    body {
		        margin: 0;
		        padding: 4px;
		        background: radial-gradient(circle, rgb(10 10 15) 0%, rgb(28 31 43) 100%);
		        color: #ccc;
		        font-family: 'Average Sans', monospace;
		        font-size: 14px;
		    }

		    #top_buttons {
		        display: flex;
		        justify-content: flex-end;
		        margin-bottom: 3px;
		    }

		    #top_buttons button, #toggle_button, .emoji-button {
		        background: #1b1d2a;
		        border: 1px solid #FFA500;
		        color: #FFA500;
		        border-radius: 3px;
		        padding: 2px 4px;
		        font-size: 8px;
		        text-transform: uppercase;
		        font-weight: bold;
		        letter-spacing: 0.4px;
		        cursor: pointer;
		        transition: all 0.2s ease;
		    }
		    #top_buttons button:hover, #toggle_button:hover, .emoji-button:hover {
		        background: #FFA50033;
		    }

		    #chat_log {
		        background: #11131a;
		        border: 1px solid #a86018;
		        border-radius: 8px;
		        padding: 3px;
		        height: 150px;
		        overflow-y: auto;
		        margin-bottom: 3px;
		        box-shadow: inset 0 0 8px #4b008222;
		    }

		    .input-row {
		        display: flex;
		        align-items: center;
		        gap: 2px;
		    }

		    #chat_input {
		        flex: 1;
		        background: #0d0f18;
		        border: 1px solid #a86018;
		        border-radius: 3px;
		        padding: 3px;
		        color: #eee;
		        font-size: 12px;
		        font-family: monospace;
		        box-shadow: inset 0 0 4px #FFA50033;
		    }

		    .emoji-button {
		        width: 26px;
		        height: 20px;
		        font-size: 14px;
		        line-height: 20px;
		        text-align: center;
		        padding: 0;
		        background: #0f111a;
		        border: 1px solid #00ffff;
		        color: #00ffff;
		        border-radius: 5px;
		    }

		    .emoji-picker {
		        display: none;
		        position: absolute;
		        bottom: 65px;
		        right: 15px;
		        background: #121522;
		        border: 1px solid #FFA500;
		        border-radius: 8px;
		        padding: 8px;
		        width: 160px;
		        box-shadow: 0 0 10px #FFA50055;
		        z-index: 999;
		    }

		    .emoji-picker input {
		        width: 100%;
		        padding: 5px;
		        margin-bottom: 6px;
		        background: #0c0e17;
		        border: 1px solid #00ffff55;
		        border-radius: 6px;
		        color: #ccc;
		        font-size: 12px;
		        font-family: monospace;
		    }

		    #emoji_list {
		        display: flex;
		        flex-wrap: wrap;
		        gap: 5px;
		        overflow-y: auto;
		        max-height: 90px;
		    }

		    #emoji_list span {
		        cursor: pointer;
		        font-size: 18px;
		        transition: transform 0.2s;
		    }
		    #emoji_list span:hover {
		        filter: brightness(1.5);
		    }
		</style>

    </head>
    <body onload='initChat()'>
        <div id='top_buttons'>
            <button id='log_button' onclick='toggleLogView()'>[src.view_game_log ? "Game Log" : "OOC"]</button>
        </div>
        <div id='chat_log'>
            [html_log]
        </div>
    "}

	if (!src.view_game_log)
		html += {"
			<div class='input-row'>
			    <button id='toggle_button' onclick='toggleChatMode()'>
			        <span id='chat_mode_label'>[src.cur_chat_mode == "Local" ? "Local" : "World"]</span>
			    </button>
			    <input type='text' id='chat_input' onkeydown='if(event.key === \"Enter\") sendChat();' placeholder='Type your message here...'>
			    <button class='emoji-button' onclick='toggleEmojiPicker()'>😊</button>
			</div>

			<div id='emoji_picker' class='emoji-picker' style='display:none; position:absolute; bottom:50px; right:10px; background:#1a1a2f; border:1px solid #00eaff88; padding:10px; border-radius:8px; z-index:999; width:160px;'>
			    <input type='text' id='emoji_search' placeholder='Search emoji...' oninput='filterEmojis()' style='width:95%; margin-bottom:5px; background:#0c0f17; border:1px solid #00eaff55; color:white; padding:5px; border-radius:6px;'>
			    <div id='emoji_list' style='height:100px; overflow-y:auto; display:flex; flex-wrap:wrap; gap:6px;'>
			"}


		var/list/emojis = global.emojis
		for (var/shortcut in emojis)
			var/e = emojis[shortcut]
			html += "<span onclick='insertEmoji(\"[e["char"]]\")' data-keywords='[jointext(e["keywords"], " ")]' data-shortcut='[shortcut]' title='[shortcut]' style='cursor:pointer;font-size:20px;'>[e["char"]]</span>"

	html += "<script>var ref_src = \"" + "\ref[src]" + "\";</script></div></div>"
	html += {"
        <script>
            var chat_mode = '[src.cur_chat_mode]';
            var log_mode = '[src.view_game_log ? "gamelog" : "chat"]';
            var ref_src = \"\ref[src]\";

            function initChat() {
                var log = document.getElementById('chat_log');
                if (log) log.scrollTop = log.scrollHeight;
            }

            function toggleLogView() {
                log_mode = (log_mode === 'chat') ? 'gamelog' : 'chat';
                var button = document.getElementById('log_button');
                if (button) {
                    button.innerText = (log_mode === 'chat') ? 'OOC' : 'Game Log';
                }
                window.location.href = `byond://winset?id=;command=SwitchView ${log_mode}`;
            }

            function toggleChatMode() {
                chat_mode = (chat_mode === 'World') ? 'Local' : 'World';
                var label = document.getElementById('chat_mode_label');
                if (label) {
                    label.innerText = chat_mode;
                }
            }

            function sendChat() {
                let input = document.getElementById('chat_input');
                if (!input || input.value.trim() == '') return;
                window.location.href = `byond://winset?id=;command=ChatSystem "${chat_mode}" "${encodeURIComponent(input.value)}"`;
                input.value = '';
            }

            function updateChat(msg){
                if(log_mode !== "chat") return;
                let log = document.getElementById('chat_log');
                log.innerHTML += msg + "<br>";
                log.scrollTop = log.scrollHeight;
            }

            function updateGameLog(msg){
                if(log_mode !== "gamelog") return;
                let log = document.getElementById('chat_log');
                log.innerHTML += msg + "<br>";
                log.scrollTop = log.scrollHeight;
            }

		    function toggleEmojiPicker() {
		        let picker = document.getElementById('emoji_picker');
		        picker.style.display = picker.style.display === 'block' ? 'none' : 'block';
		    }

		    function insertEmoji(emoji) {
		        let input = document.getElementById('chat_input');
		        if (input) {
		            input.value += emoji;
		            input.focus();
		        }
		        toggleEmojiPicker();
		    }
			function filterEmojis() {
			    var input = document.getElementById('emoji_search').value.toLowerCase();
			    var emojis = document.querySelectorAll('#emoji_list span');
			    emojis.forEach(function(span) {
			        var keywords = (span.getAttribute('data-keywords') || '').toLowerCase();
			        var shortcut = (span.getAttribute('data-shortcut') || '').toLowerCase();
			        var emojiChar = span.innerText.toLowerCase();
			        span.style.display = (
			            keywords.includes(input) ||
			            shortcut.includes(input) ||
			            emojiChar.includes(input)
			        ) ? 'inline-block' : 'none';
			    });
			}

        </script>
    </body>
    </html>
    "}

	src << browse(html, "window=chatWindow.chatBrowser")





// Switch between Chat View and Game Log View
client/verb/SwitchView(view as text)
	set hidden = 1
	if (view == "chat")
		view_game_log = 0
	else if (view == "gamelog")
		view_game_log = 1
	OpenChatBrowser()

// Helper macro to convert list to params (for JavaScript output)
#define LP(str) list2params(list(str))

/*
==================================
Chat System Overview:

- OOC (World/Local chat):
    - Use AddWorldMessage() to broadcast to all players
    - Use AddChatMessage() for personal messages only

- Game Log:
    - Use AddGameLog() to send messages to the game log

Other Notes:
- Anti-advertising checks are included
- Limited saved messages to prevent overflow
==================================
*/

// Additional blocked phrases
var/static/list/blocked_words = list(
	"join my server",
	"free robux",
	"buy gold",
	"www.",
	"https://",
	"http://",
	"discord.gg/",
	"byond://"
)

client
	var
		cur_chat_mode = "World"                 // "World" or "Local" chat mode
		view_game_log = 0                        // 0 = normal chat, 1 = game log
		list/game_log_messages = list()          // Game log messages
		list/personal_chat_messages = list()     // Personal chat messages

	// Sends a message to all players globally (World chat)
	proc/AddWorldMessage(var/text)
		for (var/client/c)
			c.AddChatMessage(text)

	// Adds a personal chat message only for the current player
	proc/AddChatMessage(var/text)
		personal_chat_messages += text

		// Limit saved messages (keep last 80 if over 100)
		if (length(personal_chat_messages) > 100)
			personal_chat_messages = personal_chat_messages.Copy(length(personal_chat_messages) - 80 + 1)

		// Update the chat window (only for this player)
		src << output(LP("<span>" + jointext(text, "<br>") + "</span>"), "chatWindow.chatBrowser:updateChat")

	// Adds a message to the Game Log
	proc/AddGameLog(var/text)
		game_log_messages += text

		// Limit saved messages (keep last 80 if over 100)
		if (length(game_log_messages) > 100)
			game_log_messages = game_log_messages.Copy(length(game_log_messages) - 80 + 1)

		// Update the game log view
		src << output(LP("<span>" + jointext(text, "<br>") + "</span>"), "chatWindow.chatBrowser:updateGameLog")

	// Handles sending a chat message
	verb/ChatSystem(cmd as text, msg as text)
		set hidden = 1
		var/mob/player/m = src.mob

		if (msg) msg = trimtext(msg)

		// Handle !admin special command
		if (msg && findtext(msg, "!admin") != 0)
			var/encoded_message = "--> Admin assistance requested from [m.name]"
			for (var/mob/player/pl in global.online_players)
				pl.client.AddChatMessage(encoded_message)
			return

		// Handle regular chat commands
		if (cmd == "World" || cmd == "Local")
			if (!msg || !length(msg))
				return // Empty message, do nothing

			m.client.cur_chat_mode = cmd
			m.client.Filter_Text(msg, cmd)

		// Always refresh chat window after sending
		OpenChatBrowser()

	// Filters the text before sending (anti-advertising, AFK, formatting)
	proc/Filter_Text(var/msg, var/chat)
		// If AFK, remove AFK status
		if (mob.AFK)
			mob.AFK = 0
			AddChatMessage("<font color=green>You are no longer AFK</font>")

		var/low_msg = lowertext(msg)
/*
		// Basic advertising filter
		if (findtext(low_msg, ".com") || findtext(low_msg, ".net") || findtext(low_msg, ".org") || findtext(low_msg, "http") || findtext(low_msg, "discord.gg") || findtext(low_msg, "://"))
			AddChatMessage("<font color=orange>Advertising is not allowed!</font>")
			return
*/
		for (var/bad in global.blocked_words)
			if (findtext(low_msg, bad))
				AddChatMessage("<font color=orange>Advertising is not allowed!</font>")
				return

		// Formatting the message depending on chat type
		var/formatted_msg
		var
			name = mob.name
			admin_rank = mob.admin


		switch (chat)
			if ("World")
				formatted_msg = "<font color=#FFA500>[name]: <font color=white>[msg]"
			//	if(race)
			//		formatted_msg = "<font color=#FFA500>([race]) " + formatted_msg
			//	if(guild_name)
			//		formatted_msg = "<font color=#FFA500>[guild_name]"
				if(admin_rank != 0)
					formatted_msg = "<font color=#FF0000>(GM)" + formatted_msg
				AddWorldMessage(formatted_msg)

			if ("Local")
				formatted_msg = "<font color=#d9cca3>{[name]}: <font color=white>[msg]"
				for (var/mob/player/p in view())
					p.client.AddChatMessage(formatted_msg) */