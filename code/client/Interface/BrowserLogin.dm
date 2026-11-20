


client
	proc
		HTML_BrowseLogin()
			usr << browse(global.browser_html_content["login"],"window=window_info.browser")
			if(!ui_is_open[UI_LOGIN])
				winset(usr, "main.child_info", "is-visible=1;")
				ui_is_open[UI_LOGIN] = TRUE
	verb

		HTML_Login(username as text, password as text)
			set hidden = 1
			//search for account savefile
	/*		if(fexists("accounts/ckey.sav"))
				var/savefile/_savefile = new/savefile('accounts/[ckey].sav')

				//===================
				// Protect user info
				//===================
				password = sha1(password)
				username = sha1(username)

				if(username!=_savefile["username"])
					//Do callback function.
					//display wrong username as text
					return 0
				if(password != _savefile["password"])
					//Do callback function.
					//display wrong password as text
					return 0

				// success
				return 1
	*/