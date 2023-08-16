/particles/getsuga_tensho_trail
	width = 192
	height = 24
	count = 75
	spawning = 75
	gradient = list("#fcfba7","#ded690","#333333","#808080","#FFFFFF")
	lifespan = 20
	fade = 60
	color = generator("vector", 0.04, 0.05)
	color_change = generator("num", 0.04,0.05)
	velocity = generator("circle", 0, 1, NORMAL_RAND)
	friction = generator("num", 0.1, 0.5)