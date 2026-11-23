var/keybinds_template // set on world.New()


client
	

	
	proc

		update_keybinds_window()
			if(!winget(src, "keybinds", "is-visible")) return debug.error("Window is not being displayed!")
			src << output(url_encode(json_encode(keybinds)), "keybinds.browser:setKeybinds")
			src << output(url_encode(json_encode(verbs)), "keybinds.browser:setVerbs")
			src << output(null, "keybinds.browser:renderAll")

mob/developer
	verb
		ShowKeybindsWindow()
			set name = "Keybinds window"
			set category = "Admin"

			winshow(usr, "keybinds", 1)
			usr << browse(keybinds_template, "keybinds.browser")
			usr.client.update_keybinds_window()
