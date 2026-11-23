client
	verb
		HTML_BrowseNewAccount()
			set hidden = 1
			winset(usr, "main.child_info", "is-visible=1;")
			usr << browse(global.browser_html_content["new-account"],"window_login.browser")

		HTML_NewAccount(username as text, password as text)
			set hidden = 1
			//hash login info
			username = sha1(username)
			password = sha1(password)
			/*
			if(!fexists('accounts/[ckey].sav'))
				var/savefile/_savefile = new/savefile('accounts/[ckey].sav')
				//do wizard shit, dispaying 'account already exists'
			else
				var/savefile/_savefile = new/savefile('accounts/[ckey].sav')
				_savefile["username"] << username
				_savefile["password"] << password
			*/