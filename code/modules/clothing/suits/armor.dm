/obj/item/clothing/suit/armor
	allowed = list(/obj/item/weapon/gun/energy,/obj/item/weapon/reagent_containers/spray/pepper,/obj/item/weapon/gun/projectile,/obj/item/ammo_box,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/restraints/handcuffs,/obj/item/device/flashlight/seclite,/obj/item/weapon/melee/classic_baton/telescopic)
	body_parts_covered = CHEST
	cold_protection = CHEST|GROIN
	min_cold_protection_temperature = ARMOR_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT
	strip_delay = 60
	put_on_delay = 40

/obj/item/clothing/suit/armor/vest
	name = "armor"
	desc = "A slim armored vest that protects against most types of damage."
	icon_state = "armor"
	item_state = "armor"
	blood_overlay_type = "armor"
	armor = list(melee = 50, bullet = 15, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)

/obj/item/clothing/suit/armor/vest/sec
	name = "security armor"
	desc = "A slim armored vest that protects against most types of damage. That one has a NT insignia"
	icon_state = "armorsec"
	item_state = "armorsec"

/obj/item/clothing/suit/armor/comissar
	name = "commisar's trenchcoat"
	desc = "A good-quaility trenchcoad with a special alloy for protection and securing their wearer"
	icon_state = "comcoat"
	item_state = "comcoat"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	armor = list(melee =50, bullet = 30, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)
	cold_protection = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS
	strip_delay = 80
	pocket = /obj/item/weapon/storage/internal/pocket

/obj/item/clothing/suit/armor/hos
	name = "armored greatcoat"
	desc = "A greatcoat enchanced with a special alloy for some protection and style for those with a commanding presence."
	icon_state = "hos"
	item_state = "greatcoat"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	armor = list(melee = 65, bullet = 30, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)
	flags_inv = HIDEJUMPSUIT
	cold_protection = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS
	strip_delay = 80
	pocket = /obj/item/weapon/storage/internal/pocket

/obj/item/clothing/suit/armor/hos/trenchcoat
	name = "armored trenchoat"
	desc = "A trenchcoat enchanced with a special lightweight kevlar. The epitome of tactical plainclothes."
	icon_state = "hostrench"
	item_state = "hostrench"
	flags_inv = 0
	strip_delay = 80

/obj/item/clothing/suit/armor/vest/warden
	name = "warden's jacket"
	desc = "A red jacket with silver rank pips and body armor strapped on top."
	icon_state = "warden_jacket"
	item_state = "armor"
	body_parts_covered = CHEST|GROIN|ARMS
	cold_protection = CHEST|GROIN|ARMS|HANDS
	heat_protection = CHEST|GROIN|ARMS|HANDS
	strip_delay = 70
	pocket = /obj/item/weapon/storage/internal/pocket

/obj/item/clothing/suit/armor/vest/warden/alt
	name = "warden's armored jacket"
	desc = "A navy-blue armored jacket with blue shoulder designations and '/Warden/' stitched into one of the chest pockets."
	icon_state = "warden_alt"

/obj/item/clothing/suit/armor/vest/capcarapace
	name = "captain's carapace"
	desc = "An armored vest reinforced with ceramic plates and pauldrons to provide additional protection whilst still offering maximum mobility and flexibility. Issued only to the station's finest, although it does chafe your nipples."
	icon_state = "capcarapace"
	item_state = "armor"
	body_parts_covered = CHEST|GROIN
	armor = list(melee = 50, bullet = 30, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)


/obj/item/clothing/suit/armor/riot
	name = "riot suit"
	desc = "A suit of armor with heavy padding to protect against melee attacks. Looks like it might impair movement."
	icon_state = "riot"
	item_state = "swat_suit"
	slowdown = 1
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	armor = list(melee = 80, bullet = 10, laser = 10, energy = 10, bomb = 0, bio = 0, rad = 0)
	flags_inv = HIDEJUMPSUIT
	strip_delay = 80
	put_on_delay = 60

/obj/item/clothing/suit/armor/bulletproof
	name = "bulletproof armor"
	desc = "A bulletproof vest that excels in protecting the wearer against traditional projectile weaponry and explosives to a minor extent."
	icon_state = "bulletproof"
	item_state = "armor"
	blood_overlay_type = "armor"
	armor = list(melee = 25, bullet = 80, laser = 10, energy = 10, bomb = 40, bio = 0, rad = 0)
	strip_delay = 70
	put_on_delay = 50

/obj/item/clothing/suit/armor/laserproof
	name = "ablative armor vest"
	desc = "A vest that excels in protecting the wearer against energy projectiles, as well as occasionally reflecting them."
	icon_state = "armor_reflec"
	item_state = "armor_reflec"
	blood_overlay_type = "armor"
	armor = list(melee = 10, bullet = 10, laser = 80, energy = 50, bomb = 0, bio = 0, rad = 0)
	var/hit_reflect_chance = 40

/obj/item/clothing/suit/armor/laserproof/IsReflect(var/def_zone)
	if(!(def_zone in list("chest", "groin"))) //If not shot where ablative is covering you, you don't get the reflection bonus!
		hit_reflect_chance = 0
	if (prob(hit_reflect_chance))
		return 1

/obj/item/clothing/suit/armor/vest/det_suit
	name = "armor"
	desc = "An armored vest with a detective's badge on it."
	icon_state = "detective-armor"
	allowed = list(/obj/item/weapon/tank/internals/emergency_oxygen,/obj/item/weapon/reagent_containers/spray/pepper,/obj/item/device/flashlight,/obj/item/weapon/gun/energy,/obj/item/weapon/gun/projectile,/obj/item/ammo_box,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/restraints/handcuffs,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/lighter,/obj/item/device/detective_scanner,/obj/item/device/taperecorder)
	pocket = /obj/item/weapon/storage/internal/pocket


//Reactive armor
//When the wearer gets hit, this armor will teleport the user a short distance away (to safety or to more danger, no one knows. That's the fun of it!)
/obj/item/clothing/suit/armor/reactive
	name = "reactive teleport armor"
	desc = "Someone seperated our Research Director from his own head!"
	var/active = 0.0
	icon_state = "reactiveoff"
	item_state = "reactiveoff"
	blood_overlay_type = "armor"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	action_button_name = "Toggle Armor"
	unacidable = 1

/obj/item/clothing/suit/armor/reactive/IsShield()
	if(active)
		return 1
	return 0

/obj/item/clothing/suit/armor/reactive/attack_self(mob/user as mob)
	src.active = !( src.active )
	if (src.active)
		user << "<span class='notice'>[src] is now active.</span>"
		src.icon_state = "reactive"
		src.item_state = "reactive"
	else
		user << "<span class='notice'>[src] is now inactive.</span>"
		src.icon_state = "reactiveoff"
		src.item_state = "reactiveoff"
		src.add_fingerprint(user)
	return

/obj/item/clothing/suit/armor/reactive/emp_act(severity)
	active = 0
	src.icon_state = "reactiveoff"
	src.item_state = "reactiveoff"
	..()


//All of the armor below is mostly unused


/obj/item/clothing/suit/armor/centcom
	name = "\improper Centcom armor"
	desc = "A suit that protects against some damage."
	icon_state = "centcom"
	item_state = "centcom"
	w_class = 4//bulky item
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	allowed = list(/obj/item/weapon/gun/energy,/obj/item/weapon/melee/baton,/obj/item/weapon/restraints/handcuffs,/obj/item/weapon/tank/internals/emergency_oxygen)
	flags = THICKMATERIAL
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	cold_protection = CHEST | GROIN | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT

/obj/item/clothing/suit/armor/heavy
	name = "heavy armor"
	desc = "A heavily armored suit that protects against moderate damage."
	icon_state = "heavy"
	item_state = "swat_suit"
	w_class = 4//bulky item
	gas_transfer_coefficient = 0.90
	flags = THICKMATERIAL
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	slowdown = 3
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT

/obj/item/clothing/suit/armor/tdome
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	flags = THICKMATERIAL
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS

/obj/item/clothing/suit/armor/tdome/red
	name = "thunderdome suit"
	desc = "Reddish armor."
	icon_state = "tdred"
	item_state = "tdred"

/obj/item/clothing/suit/armor/tdome/green
	name = "thunderdome suit"
	desc = "Pukish armor."	//classy.
	icon_state = "tdgreen"
	item_state = "tdgreen"

/obj/item/clothing/suit/armor/vest/secnew/
	var/icon_badge
	var/icon_nobadge
	verb/toggle()
		set name ="Adjust Badge"
		set category = "Object"
		set src in usr
		if(!usr.canmove || usr.stat || usr.restrained())
			return 0

		if(icon_state == icon_badge)
			icon_state = icon_nobadge
			usr << "You unclip the badge from the vest."
		else if(icon_state == icon_nobadge)
			icon_state = icon_badge
			usr << "You clip the badge to the vest."
		else
			usr << "You can't find a badge for [src]."
			return
		update_icon()

/obj/item/clothing/suit/armor/vest/secnew/kev
	name = "armor vest"
	desc = "A simple kevlar plate carrier."
	icon_state = "kvest"
	item_state = "kvest"
	armor = list(melee = 55, bullet = 25, laser = 50, energy = 25, bomb = 25, bio = 0, rad = 0)
	allowed = list(/obj/item/weapon/gun/energy,/obj/item/weapon/reagent_containers/spray/pepper,/obj/item/weapon/gun/projectile,/obj/item/ammo_box,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/restraints/handcuffs,/obj/item/device/flashlight/seclite,/obj/item/weapon/melee/classic_baton/telescopic)
	body_parts_covered = CHEST
	cold_protection = CHEST|GROIN
	min_cold_protection_temperature = ARMOR_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT
	strip_delay = 60
	put_on_delay = 40

/obj/item/clothing/suit/armor/vest/secnew/officer
	name = "officer armor vest"
	desc = "A simple kevlar plate carrier belonging to Nanotrasen. This one has a security holobadge clipped to the chest."
	icon_state = "officervest_nobadge"
	item_state = "officervest_nobadge"
	icon_badge = "officervest_badge"
	icon_nobadge = "officervest_nobadge"

/obj/item/clothing/suit/armor/vest/secnew/warden
	name = "warden armor vest"
	desc = "A simple kevlar plate carrier belonging to Nanotrasen. This one has a silver badge clipped to the chest."
	icon_state = "wardenvest_nobadge"
	item_state = "wardenvest_nobadge"
	icon_badge = "wardenvest_badge"
	icon_nobadge = "wardenvest_nobadge"
	armor = list(melee = 55, bullet = 35, laser = 60, energy = 25, bomb = 25, bio = 0, rad = 0)

/obj/item/clothing/suit/armor/vest/secnew/hos
	name = "commander armor vest"
	desc = "A simple kevlar plate carrier belonging to Nanotrasen. This one has a gold badge clipped to the chest."
	icon_state = "hosvest_nobadge"
	item_state = "hosvest_nobadge"
	icon_badge = "hosvest_badge"
	icon_nobadge = "hosvest_nobadge"
	armor = list(melee = 60, bullet = 40, laser = 60, energy = 35, bomb = 25, bio = 0, rad = 0)

/obj/item/clothing/suit/armor/vest/secnew/pcrc
	name = "PCRC armor vest"
	desc = "A simple kevlar plate carrier belonging to Proxima Centauri Risk Control. This one has a PCRC crest clipped to the chest."
	icon_state = "pcrcvest_nobadge"
	item_state = "pcrcvest_nobadge"
	icon_badge = "pcrcvest_badge"
	icon_nobadge = "pcrcvest_nobadge"

/obj/item/clothing/suit/armor/vest/secnew/detective
	name = "detective armor vest"
	desc = "A simple kevlar plate carrier in a vintage brown, it has a badge clipped to the chest that reads, 'Private investigator'."
	icon_state = "detectivevest_nobadge"
	item_state = "detectivevest_nobadge"
	icon_badge = "detectivevest_badge"
	icon_nobadge = "detectivevest_nobadge"

/obj/item/clothing/suit/armor/vest/secnew/heavy
	name = "heavy armor vest"
	desc = "A heavy kevlar plate carrier with webbing attached."
	icon_state = "webvest"
	item_state = "webvest"
	armor = list(melee = 65, bullet = 45, laser = 55, energy = 35, bomb = 35, bio = 0, rad = 0)
	slowdown = 1

/obj/item/clothing/suit/armor/vest/secnew/heavy/officer
	name = "officer heavy armor vest"
	desc = "A heavy kevlar plate carrier belonging to Nanotrasen with webbing attached. This one has a security holobadge clipped to the chest."
	icon_state = "officerwebvest_nobadge"
	item_state = "officerwebvest_nobadge"
	icon_badge = "officerwebvest_badge"
	icon_nobadge = "officerwebvest_nobadge"

/obj/item/clothing/suit/armor/vest/secnew/heavy/warden
	name = "warden heavy armor vest"
	desc = "A heavy kevlar plate carrier belonging to Nanotrasen with webbing attached. This one has a silver badge clipped to the chest."
	icon_state = "wardenwebvest_nobadge"
	item_state = "wardenwebvest_nobadge"
	icon_badge = "wardenwebvest_badge"
	icon_nobadge = "wardenwebvest_nobadge"

/obj/item/clothing/suit/armor/vest/secnew/heavy/hos
	name = "commander heavy armor vest"
	desc = "A heavy kevlar plate carrier belonging to Nanotrasen with webbing attached. This one has a gold badge clipped to the chest."
	icon_state = "hoswebvest_nobadge"
	item_state = "hoswebvest_nobadge"
	icon_badge = "hoswebvest_badge"
	icon_nobadge = "hoswebvest_nobadge"
	armor = list(melee = 65, bullet = 50, laser = 65, energy = 40, bomb = 40, bio = 0, rad = 0)

/obj/item/clothing/suit/armor/vest/secnew/heavy/pcrc
	name = "PCRC heavy armor vest"
	desc = "A heavy kevlar plate carrier belonging to Proxima Centauri Risk Control with webbing attached. This one has a PCRC crest clipped to the chest."
	icon_state = "pcrcwebvest_nobadge"
	item_state = "pcrcwebvest_nobadge"
	icon_badge = "pcrcwebvest_badge"
	icon_nobadge = "pcrcwebvest_nobadge"

/obj/item/clothing/suit/armor/vest/secnew/heavy/merc
	name = "heavy armor vest"
	desc = "A high-quality heavy kevlar plate carrier in a fetching tan. The vest is surprisingly flexible, and possibly made of an advanced material."
	icon_state = "mercwebvest"
	item_state = "mercwebvest"
	armor = list(melee = 70, bullet = 80, laser = 70, energy = 55, bomb = 60, bio = 0, rad = 0)
	slowdown = 0
	allowed = list(/obj/item/weapon/gun,/obj/item/ammo_box,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/melee/energy/sword/saber,/obj/item/weapon/restraints/handcuffs,/obj/item/weapon/tank/internals)

