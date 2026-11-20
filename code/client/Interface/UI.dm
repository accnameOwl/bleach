
client
	var
		const
			UI_LOGIN = "uilogin"
			UI_CHARACTER = "uichar"
			UI_INVENTORY = "uiinv"
			UI_SPELLBOOK = "uispellb"
			UI_LEADERBOARD = "uileaderb" // redundant?

		list/ui_is_open = list(
			UI_LOGIN = FALSE,
			UI_CHARACTER = FALSE,
			UI_INVENTORY = FALSE,
			UI_SPELLBOOK = FALSE,
			UI_LEADERBOARD = FALSE
		)


	proc

		/**
		*
		*
		*
		*	@params:
		*		npc: mob/NPC object
		*		message:
		*/
		npc_dialogue(mob/NPC/npc, message, title = "", list/options=null)

