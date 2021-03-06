/obj/item/clothing/head/helmet
	name = "helmet"
	desc = "Standard Security gear. Protects the head from impacts."
	icon_state = "helmet"
	flags = HEADCOVERSEYES | HEADBANGPROTECT
	item_state = "helmet"
	armor = list(melee = 50, bullet = 15, laser = 50,energy = 10, bomb = 25, bio = 0, rad = 0)
	flags_inv = HIDEEARS|HIDEEYES
	cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = HELMET_MAX_TEMP_PROTECT
	strip_delay = 60
	var/obj/machinery/camera/portable/helmetCam = null
	var/spawnWithHelmetCam = 0
	var/canAttachCam = 0


/obj/item/clothing/head/helmet/New()
	..()
	if(spawnWithHelmetCam)
		helmetCam = new /obj/machinery/camera/portable(src)
		helmetCam.c_tag = "Helmet-Mounted Camera (No User)([rand(1,999)])"
		helmetCam.network = list("SS13")
		update_icon()

/obj/item/clothing/head/helmet/emp_act(severity)
	if(helmetCam) //Transfer the EMP to the camera so you can still disable it this way.
		helmetCam.emp_act(severity)
	..()

/obj/item/clothing/head/helmet/sec
	spawnWithHelmetCam = 1
	canAttachCam = 1
	can_flashlight = 1

/obj/item/clothing/head/helmet/alt
	name = "bulletproof helmet"
	desc = "A bulletproof combat helmet that excels in protecting the wearer against traditional projectile weaponry and explosives to a minor extent."
	icon_state = "helmetalt"
	item_state = "helmetalt"
	armor = list(melee = 25, bullet = 80, laser = 10, energy = 10, bomb = 40, bio = 0, rad = 0)

/obj/item/clothing/head/helmet/riot
	name = "riot helmet"
	desc = "It's a helmet specifically designed to protect against close range attacks."
	icon_state = "riot"
	item_state = "helmet"
	toggle_message = "You pull the visor down on"
	alt_toggle_message = "You push the visor up on"
	can_toggle = 1
	flags = HEADCOVERSEYES|HEADCOVERSMOUTH|HEADBANGPROTECT
	armor = list(melee = 82, bullet = 15, laser = 5,energy = 5, bomb = 5, bio = 2, rad = 0)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE
	strip_delay = 80
	action_button_name = "Toggle Helmet Visor"
	visor_flags = HEADCOVERSEYES|HEADCOVERSMOUTH
	visor_flags_inv = HIDEMASK|HIDEEYES|HIDEFACE
	toggle_cooldown = 0

/obj/item/clothing/head/helmet/attack_self()
	if(usr.canmove && !usr.stat && !usr.restrained() && can_toggle)
		if(world.time > cooldown + toggle_cooldown)
			cooldown = world.time
			if(up)
				up = !up
				flags |= (visor_flags)
				flags_inv |= (visor_flags_inv)
				icon_state = initial(icon_state)
				usr << "[toggle_message] \the [src]."
				usr.update_inv_head(0)
			else
				up = !up
				flags &= ~(visor_flags)
				flags_inv &= ~(visor_flags_inv)
				icon_state = "[initial(icon_state)]up"
				usr << "[alt_toggle_message] \the [src]"
				usr.update_inv_head(0)
				while(up)
					playsound(src.loc, "[activation_sound]", 100, 0, 4)
					sleep(15)

/obj/item/clothing/head/helmet/justice
	name = "helmet of justice"
	desc = "WEEEEOOO. WEEEEEOOO. WEEEEOOOO."
	icon_state = "justice"
	toggle_message = "You turn off the lights on"
	alt_toggle_message = "You turn on the lights on"
	action_button_name = "Toggle Justice Lights"
	can_toggle = 1
	toggle_cooldown = 14
	activation_sound = 'sound/items/WEEOO1.ogg'

/obj/item/clothing/head/helmet/justice/escape
	name = "alarm helmet"
	desc = "WEEEEOOO. WEEEEEOOO. STOP THAT MONKEY. WEEEOOOO."
	icon_state = "justice2"
	toggle_message = "You turn off the light on"
	alt_toggle_message = "You turn on the light on"
	action_button_name = "Toggle Alarm Lights"

/obj/item/clothing/head/helmet/swat
	name = "\improper SWAT helmet"
	desc = "An extremely robust, space-worthy helmet with the Nanotrasen logo emblazoned on the top."
	icon_state = "swat"
	item_state = "swat"
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 25, bomb = 50, bio = 10, rad = 0)
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = SPACE_HELM_MAX_TEMP_PROTECT
	strip_delay = 80

/obj/item/clothing/head/helmet/thunderdome
	name = "\improper Thunderdome helmet"
	desc = "<i>'Let the battle commence!'</i>"
	icon_state = "thunderdome"
	item_state = "thunderdome"
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 10, bomb = 25, bio = 10, rad = 0)
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = SPACE_HELM_MAX_TEMP_PROTECT
	strip_delay = 80

/obj/item/clothing/head/helmet/roman
	name = "roman helmet"
	desc = "An ancient helmet made of bronze and leather."
	flags = HEADCOVERSEYES
	armor = list(melee = 25, bullet = 0, laser = 25, energy = 10, bomb = 10, bio = 0, rad = 0)
	icon_state = "roman"
	item_state = "roman"
	strip_delay = 100

/obj/item/clothing/head/helmet/roman/legionaire
	name = "roman legionaire helmet"
	desc = "An ancient helmet made of bronze and leather. Has a red crest on top of it."
	icon_state = "roman_c"
	item_state = "roman_c"

/obj/item/clothing/head/helmet/gladiator
	name = "gladiator helmet"
	desc = "Ave, Imperator, morituri te salutant."
	icon_state = "gladiator"
	flags = HEADCOVERSEYES|BLOCKHAIR
	item_state = "gladiator"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES

obj/item/clothing/head/helmet/redtaghelm
	name = "red laser tag helmet"
	desc = "They have chosen their own end."
	icon_state = "redtaghelm"
	flags = HEADCOVERSEYES
	item_state = "redtaghelm"
	armor = list(melee = 30, bullet = 10, laser = 20,energy = 10, bomb = 20, bio = 0, rad = 0)
	// Offer about the same protection as a hardhat.
	flags_inv = HIDEEARS|HIDEEYES

obj/item/clothing/head/helmet/bluetaghelm
	name = "blue laser tag helmet"
	desc = "They'll need more men."
	icon_state = "bluetaghelm"
	flags = HEADCOVERSEYES
	item_state = "bluetaghelm"
	armor = list(melee = 30, bullet = 10, laser = 20,energy = 10, bomb = 20, bio = 0, rad = 0)
	// Offer about the same protection as a hardhat.
	flags_inv = HIDEEARS|HIDEEYES

//LightToggle

/obj/item/clothing/head/helmet/update_icon()

	var/state = "[initial(icon_state)]"
	if(helmetCam)
		state += "-cam" //"helmet-cam"
	if(F)
		if(F.on)
			state += "-flight-on" //"helmet-flight-on" // "helmet-cam-flight-on"
		else
			state += "-flight" //etc.

	icon_state = state

	if(istype(loc, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = loc
		H.update_inv_head(0)

	return

/obj/item/clothing/head/helmet/ui_action_click()
	toggle_helmlight()
	..()

/obj/item/clothing/head/helmet/attackby(var/obj/item/A as obj, mob/user as mob, params)
	if(istype(A, /obj/item/device/flashlight/seclite))
		var/obj/item/device/flashlight/seclite/S = A
		if(can_flashlight)
			if(!F)
				user.drop_item()
				user << "<span class='notice'>You click [S] into place on [src].</span>"
				if(S.on)
					SetLuminosity(0)
				F = S
				A.loc = src
				update_icon()
				update_helmlight(user)
				verbs += /obj/item/clothing/head/helmet/proc/toggle_helmlight
		return

	if(istype(A, /obj/item/weapon/screwdriver))
		if(F)
			for(var/obj/item/device/flashlight/seclite/S in src)
				user << "<span class='notice'>You unscrew the seclite from [src].</span>"
				F = null
				S.loc = get_turf(user)
				update_helmlight(user)
				S.update_brightness(user)
				update_icon()
				usr.update_inv_head(0)
				verbs -= /obj/item/clothing/head/helmet/proc/toggle_helmlight
			return


	if(istype(A, /obj/item/weapon/camera_assembly))
		if(!canAttachCam)
			user << "<span class='warning'>You can't attach [A] to [src]!</span>"
			return
		if(helmetCam)
			user << "<span class='notice'>[src] already has a mounted camera.</span>"
			return
		user.drop_item()
		helmetCam = new /obj/machinery/camera/portable(src)
		helmetCam.assembly = A
		A.loc = helmetCam
		helmetCam.c_tag = "Helmet-Mounted Camera (No User)([rand(1,999)])"
		helmetCam.network = list("SS13")
		update_icon()
		user.visible_message("[user] attaches [A] to [src].","<span class='notice'>You attach [A] to [src].</span>")
		return

	if(istype(A, /obj/item/weapon/crowbar))
		if(!helmetCam)
			..()
			return
		user.visible_message("[user] removes [helmetCam] from [src].","<span class='notice'>You remove [helmetCam] from [src].</span>")
		helmetCam.assembly.loc = get_turf(src)
		helmetCam.assembly = null
		qdel(helmetCam)
		helmetCam = null
		update_icon()
		return

	..()
	return

/obj/item/clothing/head/helmet/proc/toggle_helmlight()
	set name = "Toggle Helmetlight"
	set category = "Object"
	set desc = "Click to toggle your helmet's attached flashlight."

	if(!F)
		return

	var/mob/living/carbon/human/user = usr
	if(!isturf(user.loc))
		user << "<span class='warning'>You cannot turn the light on while in this [user.loc]!</span>"
	F.on = !F.on
	user << "<span class='notice'>You toggle the helmetlight [F.on ? "on":"off"].</span>"

	playsound(user, 'sound/weapons/empty.ogg', 100, 1)
	update_helmlight(user)
	return

/obj/item/clothing/head/helmet/proc/update_helmlight(var/mob/user = null)
	if(F)
		action_button_name = "Toggle Helmetlight"
		if(F.on)
			if(loc == user)
				user.AddLuminosity(F.brightness_on)
			else if(isturf(loc))
				SetLuminosity(F.brightness_on)
		else
			if(loc == user)
				user.AddLuminosity(-F.brightness_on)
			else if(isturf(loc))
				SetLuminosity(0)
		update_icon()
	else
		action_button_name = null
		if(loc == user)
			user.AddLuminosity(-5)
		else if(isturf(loc))
			SetLuminosity(0)
		return

/obj/item/clothing/head/helmet/pickup(mob/user)
	if(F)
		if(F.on)
			user.AddLuminosity(F.brightness_on)
			SetLuminosity(0)


/obj/item/clothing/head/helmet/equipped(mob/user)
	if(helmetCam)
		spawn(10) //Gives time for the game to set a name (lol rhyme) to roundstart officers.
			helmetCam.c_tag = "Helmet-Mounted Camera ([user.name])([rand(1,999)])"

/obj/item/clothing/head/helmet/dropped(mob/user)
	if(F)
		if(F.on)
			user.AddLuminosity(-F.brightness_on)
			SetLuminosity(F.brightness_on)

	if(helmetCam)
		helmetCam.c_tag = "Helmet-Mounted Camera (No User)([rand(1,999)])"

/obj/item/clothing/head/helmet/tachelm
	name = "tactical helmet"
	desc = "A tan combat helmet with the red S letter on the side. Protects much better than syndicate combat spacesuit."
	icon_state = "tachelm"
	item_state = "tachelm"
	armor = list(melee = 55, bullet = 80, laser = 55, energy = 50, bomb = 40, bio = 0, rad = 0)