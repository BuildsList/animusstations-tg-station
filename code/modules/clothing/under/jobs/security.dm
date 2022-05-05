/*
 * Contains:
 *		Security
 *		Detective
 *		Navy uniforms
 *      Comissar
 */

/*
 * Security
 */

/obj/item/clothing/under/rank/security
	name = "security jumpsuit"
	desc = "A tactical security jumpsuit for officers complete with nanotrasen belt buckle."
	icon_state = "security"
	item_state = "r_suit"
	item_color = "security"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	strip_delay = 50

/obj/item/clothing/under/rank/security/navy
	name = "navy security jumpsuit"
	desc = "A robust security jumpsuit for NT fleet officers complete with nanotrasen belt buckle and additional pouches."
	icon_state = "officernavy"
	item_state = "officernavy"
	item_color = "officernavy"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	strip_delay = 50

/obj/item/clothing/under/rank/warden/navy
	name = "navy warden's jumpsuit"
	desc = "A tactical security jumpsuit for the NT fleet warden with silver desginations and '/Warden/' stiched into the shoulders."
	icon_state = "wardennavy"
	item_state = "wardennavy"
	item_color = "wardennavy"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	strip_delay = 50

/obj/item/clothing/under/rank/warden
	name = "warden's jumpsuit"
	desc = "A tactical security jumpsuit for the warden with silver desginations and '/Warden/' stiched into the shoulders."
	icon_state = "warden"
	item_state = "r_suit"
	item_color = "warden"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	strip_delay = 50

/*
 * Detective
 */
/obj/item/clothing/under/rank/det
	name = "hard-worn suit"
	desc = "Someone who wears this means business."
	icon_state = "detective"
	item_state = "det"
	item_color = "detective"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	strip_delay = 50

/obj/item/clothing/under/rank/det/grey
	name = "noir suit"
	desc = "A hard-boiled private investigator's grey suit, complete with tie clip."
	icon_state = "greydet"
	item_state = "greydet"
	item_color = "greydet"

/obj/item/clothing/under/rank/det/vice
	name = "vice detective suit"
	desc = "An alternate look to your modern day space detective."
	icon_state = "detectivevice"
	item_state = "detectivevice"
	item_color = "detectivevice"

/*
 * Head of Security
 */
/obj/item/clothing/under/rank/head_of_security
	name = "head of security's jumpsuit"
	desc = "A security jumpsuit decorated for those few with the dedication to achieve the position of Head of Security."
	icon_state = "hos"
	item_state = "r_suit"
	item_color = "hos"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	strip_delay = 60

/obj/item/clothing/under/rank/head_of_security/alt
	name = "head of security's turtleneck"
	desc = "A stylish alternative to the normal head of security jumpsuit, complete with tactical pants."
	icon_state = "hosalt"
	item_state = "bl_suit"
	item_color = "hosalt"

/obj/item/clothing/under/rank/head_of_security/navy
	name = "head of security's navy jumpsuit"
	desc = "A tactical uniform to NT fleet head of security"
	icon_state = "hosnavy"
	item_state = "hosnavy"
	item_color = "hosnavy"

/*
 * Navy uniforms
 */

/obj/item/clothing/under/rank/security/navyblue
	name = "security officer's formal uniform"
	desc = "The latest in fashionable security outfits."
	icon_state = "officerblueclothes"
	item_state = "officerblueclothes"
	item_color = "officerblueclothes"

/obj/item/clothing/under/rank/head_of_security/navyblue
	desc = "The insignia on this uniform tells you that this uniform belongs to the Head of Security."
	name = "head of security's formal uniform"
	icon_state = "hosblueclothes"
	item_state = "hosblueclothes"
	item_color = "hosblueclothes"

/obj/item/clothing/under/rank/warden/navyblue
	desc = "The insignia on this uniform tells you that this uniform belongs to the Warden."
	name = "warden's formal uniform"
	icon_state = "wardenblueclothes"
	item_state = "wardenblueclothes"
	item_color = "wardenblueclothes"

/*
 *  Comissar Uniform
 */

/obj/item/clothing/under/rank/comissar
	name = "comissar's jumpsuit"
	desc = "A special uniform, seems to be formal. Made by NT Military Inc."
	icon_state = "comcloth"
	item_state = "b_suit"
	item_color = "comcloth"
	can_adjust = 0