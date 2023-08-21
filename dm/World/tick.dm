var/list/Tickers = new

ticker
	proc/Tick()

world
	Tick()
		..()
		// "as anything" disables for()'s type filter,
		// so i can treat everything in the list as if it were a /ticker
		for(var/ticker/ticker as anything in Tickers)
			ticker.Tick()

atom/movable
	proc/Tick()

	New()
		..()
		Tickers += src
	
	Del()
		Tickers -= src
		..()