//All functions are in the airlock.dm

/obj/item/device/hacktool
	icon = 'icons/obj/hacktool.dmi'
	name = "hacktool"
	desc = "An item of dubious origins, with wires and antennas protruding out of it."
	icon_state = "hacktool"
	var/is_used = 0
	flags = FPRINT | CONDUCT
	force = 5.0
	w_class = 2.0
	throwforce = 5.0
	throw_range = 15
	throw_speed = 3
	m_amt = 50
	g_amt = 20
	origin_tech = "magnets=1;engineering=1"