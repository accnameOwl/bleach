
#define DAMAGETEXT_WIDTH 64

#define COLOR_REI "#03c2fc"
#define COLOR_REI_CRIT "#b503fc"
#define COLOR_ATK "#fc4503"
#define COLOR_ATK_CRIT "#d2fc03"
#define COLOR_DEF "#839196"

proc/damage_text_color(text, damage_color="")
	return "<font color=[damage_color]>[text]</font>"

obj/damage_text
	var/timeout

	density = 0
	maptext_width = 64

	layer = EFFECTS_LAYER

	New(turf/loc, text, damage_type=0, crit = 0)
		..(loc)
		timeout = world.time + 10

		step_x += rand(-10,10)

		if(damage_type == MAGIC)
			maptext = crit ? damage_text_color(text, COLOR_REI_CRIT) : damage_text_color(text, COLOR_REI)

		if(damage_type == PHYSICAL)
			maptext = crit ? damage_text_color(text, COLOR_ATK_CRIT) : damage_text_color(text, COLOR_ATK)
		maptext = Bold(maptext)
		animate(src, maptext_y=32, time=20, easing = SINE_EASING)

proc
	f_damage(turf/location, damage_text, damage_type=0, crit=0)
		set waitfor = 0

		if(damage_text >= 1000000)
			damage_text = "[round(damage_text/1000000,0.005)]M"
		else if(damage_text>=1000)
			damage_text = "[round(damage_text/1000,0.005)]K"

		var/obj/damage_text/dt = new(location, damage_text, damage_type, crit)
		spawn(20) dt.Del()

