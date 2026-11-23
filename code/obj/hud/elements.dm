
//elements
obj/hud/button

	Who
		screen_loc = "LEFT+1,TOP"
		Build()
			background = 	new/obj/hud/button/background("bg",SOUTHWEST)
			foreground = 	new/obj/hud/button/foreground("who")
			masque 	=	 	new/obj/hud/button/masque()

	Ooc
		screen_loc = "LEFT+2,TOP"
		Build()
			background = 	new/obj/hud/button/background("bg", SOUTH)
			foreground = 	new/obj/hud/button/foreground("ooc")
			masque 	= 		new/obj/hud/button/masque()

	Say
		screen_loc = "LEFT+3,TOP"
		Build()
			background = new/obj/hud/button/background("bg", SOUTH)
			foreground = new/obj/hud/button/foreground("say")
			masque =	 new/obj/hud/button/masque()

	Whisper
		screen_loc = "LEFT+2,TOP"
		Build()
			background = new/obj/hud/button/background("bg", SOUTH)
			foreground = new/obj/hud/button/foreground("whisper")
			masque =	 new/obj/hud/button/masque()

	Rest
		screen_loc = "LEFT+3,TOP"
		Build()
			background = new/obj/hud/button/background("bg", SOUTH)
			foreground = new/obj/hud/button/foreground("rest")
			masque =	 new/obj/hud/button/masque()

		Click()
			var/mob/player/m = usr
			m.Rest()

	Save
		screen_loc = "LEFT+4,TOP"
		Build()
			background = new/obj/hud/button/background("bg", SOUTH)
			foreground = new/obj/hud/button/foreground("save")
			masque =	 new/obj/hud/button/masque()

		Click()
			usr.Save()

	Help
		screen_loc = "LEFT+5,TOP"
		Build()
			background = 	new/obj/hud/button/background("bg",SOUTHEAST)
			foreground = 	new/obj/hud/button/foreground("help")
			masque = 		new/obj/hud/button/masque()

	Character
		screen_loc = "RIGHT-4,BOTTOM"
		Build()
			background = 	new/obj/hud/button/background("bg",NORTHWEST)
			foreground = 	new/obj/hud/button/foreground("stats")
			masque = 		new/obj/hud/button/masque()

		Click()
			usr?.client:OpenCharacterPanel()

	Skillbook
		screen_loc = "RIGHT-3,BOTTOM"
		Build()
			background = 	new/obj/hud/button/background("bg",NORTH)
			foreground = 	new/obj/hud/button/foreground("skillbook")
			masque = 		new/obj/hud/button/masque()

		Click()
			usr.client.OpenSpellbookPanel()

	Inventory
		screen_loc = "RIGHT-2,BOTTOM"
		Build()
			background = 	new/obj/hud/button/background("bg",NORTH)
			foreground = 	new/obj/hud/button/foreground("inventory")
			masque = 		new/obj/hud/button/masque()

		Click()
			usr.client.OpenInventoryPanel()

	Options
		screen_loc = "RIGHT-1,BOTTOM"
		Build()
			background = 	new/obj/hud/button/background("bg",NORTHEAST)
			foreground = 	new/obj/hud/button/foreground("options")
			masque = 		new/obj/hud/button/masque()

	Shikai
		screen_loc = "LEFT+6,TOP"
		Build()
			background = 	new/obj/hud/button/background("bg",NORTHEAST)
			foreground = 	new/obj/hud/button/foreground("shikai")
			masque =		new/obj/hud/button/masque()

		Click()
			call(usr, "Shikai")()

	Bankai
		screen_loc = "LEFT+7,TOP"
		Build()
			background = 	new/obj/hud/button/background("bg",NORTHEAST)
			foreground = 	new/obj/hud/button/foreground("shikai")
			masque =		new/obj/hud/button/masque()

		Click()
			call(usr, "Bankai")()

	//Arrancar Ressurection
	Ressurection
	//Espada Segunda
	Segunda
	//espada primera
	Primera
	//Quincy bow
	Bow
	//Quincy glove
	Glove
	//Quincy blut
	Blutvein