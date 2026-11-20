
obj/hud
	New()
		..()
	Del()
		..()
	proc
		Build()

vis_child
    parent_type = /atom/movable
    vis_flags = VIS_INHERIT_ICON | VIS_INHERIT_PLANE | VIS_INHERIT_LAYER | VIS_INHERIT_ID

    New(icon_state=src.icon_state, dir=src.dir)
        src.icon_state = icon_state
        src.dir = dir
        ..()

obj/hud/button
	icon = 'hud_buttons.dmi'
	layer=FLOAT_LAYER
	plane = (100+FOREGROUND_PLANE)

	var
		obj/hud/button/background/background
		obj/hud/button/foreground/foreground
		obj/hud/button/foreground/masque

	New()
		Build()
		vis_contents.Add(background,foreground,masque)
		..()

	Del()
		vis_contents.Remove(background,foreground,masque)
		..()

		
	background
		icon_state="bg"
		parent_type = /vis_child
		
	foreground
		parent_type = /vis_child

	masque
		icon_state="masque"
		parent_type = /vis_child

		
// interractive objects for client.screen
mob/player
	var
		obj/hud/button/Who/ui_elem_who
		obj/hud/button/Whisper/ui_elem_whisper
		obj/hud/button/Rest/ui_elem_rest
		obj/hud/button/Ooc/ui_elem_ooc
		obj/hud/button/Say/ui_elem_say
		obj/hud/button/Save/ui_elem_save
		obj/hud/button/Help/ui_elem_help
		obj/hud/button/Character/ui_elem_character
		obj/hud/button/Skillbook/ui_elem_skillbook
		obj/hud/button/Inventory/ui_elem_inventory
		obj/hud/button/Options/ui_elem_options
		obj/hud/button/Shikai/ui_elem_shikai
		obj/hud/button/Shikai/ui_elem_bankai
	proc
		hud_update()
			//remove existing elements
		//	client.screen.Remove(ui_elem_who, ui_elem_ooc,ui_elem_say,ui_elem_whisper,ui_elem_save,ui_elem_help)
			//create new elements
			ui_elem_who = new/obj/hud/button/Who()
			ui_elem_whisper = new/obj/hud/button/Whisper()
			ui_elem_rest = new/obj/hud/button/Rest()
			ui_elem_save = new/obj/hud/button/Save()
			ui_elem_help = new/obj/hud/button/Help()
			ui_elem_character = new/obj/hud/button/Character()
			ui_elem_skillbook = new/obj/hud/button/Skillbook()
			ui_elem_options = new/obj/hud/button/Options()
			ui_elem_inventory = new/obj/hud/button/Inventory()
			//add them to screen
			client.screen.Add(
				ui_elem_who,
				ui_elem_whisper,
				ui_elem_rest,
				ui_elem_save,
				ui_elem_help,
				ui_elem_character,
				ui_elem_skillbook,
				ui_elem_inventory,
				ui_elem_options
			)
			if(race=="shinigami")
				if(has_shikai)
					ui_elem_shikai = new/obj/hud/button/Shikai()
					client.screen.Add(ui_elem_shikai)
				if(has_bankai)
					ui_elem_bankai = new/obj/hud/button/Bankai()
					client.screen.Add(ui_elem_bankai)




/**
 *
 *
 * This is the Dirty stat section
 *
 *
*/

mob/player
	var/list/dirty_stats = list()
	proc
		dirty_stat()
			if(!args.len)
				return
			else
				for(var/stat in args)
					if(!(stat in vars))
						return world.Error(EXCEPTION("Dirty stat: [stat] is not a valid stat for [src]"))
					if(!(stat in dirty_stats))
						dirty_stats += stat

client
	var/tmp/alist/pending_dirty_stats = list()

	var/static/paired_stats = list("exp"="rex_exp", "hp"="max_hp", "stamina"="max_stamina", "mana"="max_mana")

	proc
		collect_dirty_stats()
			var/mob/player/p = src.mob
			if(!p || !p.dirty_stats.len)
				return
			for(var/stat_name in p.dirty_stats)
				pending_dirty_stats[stat_name] = p.vars[stat_name]

				var/paired_stat = paired_stats[stat_name]
				if(paired_stat)
					pending_dirty_stats[paired_stat] = p.vars[paired_stat]

			p.dirty_stats.Cut()
			return TRUE