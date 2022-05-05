/obj/item/device/laptop
	name		= "Laptop Computer"
	desc		= "A clamshell portable computer.  It is closed."
	icon		= 'icons/obj/computer3.dmi'
	icon_state	=  "laptop-closed"
	item_state	=  "laptop-inhand"
	pixel_x		= 2
	pixel_y		= -3
	w_class		= 3

	var/obj/machinery/computer3/laptop/stored_computer = null

	verb/open_computer()
		set name = "Open Laptop"
		set category = "Object"
		set src in view(1)

		if(usr.stat || usr.restrained() || usr.lying || !istype(usr, /mob/living))
			usr << "\red You can't do that."
			return

		if(!Adjacent(usr))
			usr << "You can't reach it."
			return

		if(!istype(loc,/turf))
			usr << "[src] is too bulky!  You'll have to set it down."
			return

		if(!stored_computer)
			if(contents.len)
				for(var/obj/O in contents)
					O.loc = loc
			usr << "\The [src] crumbles to pieces."
			spawn(5)
				del src
			return

		if(!stored_computer.manipulating)
			stored_computer.manipulating = 1
			stored_computer.loc = loc
			stored_computer.stat &= ~MAINT
			stored_computer.update_icon()
			loc = null
			usr << "You open \the [src]."

			spawn(5)
				stored_computer.manipulating = 0
				del src
		else
			usr << "\red You are already opening the computer!"


	AltClick()
		if(Adjacent(usr))
			open_computer()

//Quickfix until Snapshot works out how he wants to redo power. ~Z
/obj/item/device/laptop/verb/eject_id()
	set category = "Object"
	set name = "Eject ID Card"
	set src in oview(1)

	if(stored_computer)
		stored_computer.eject_id()

/obj/machinery/computer3/laptop/verb/eject_id()
	set category = "Object"
	set name = "Eject ID Card"
	set src in oview(1)

	var/obj/item/part/computer/cardslot/C = locate() in src.contents

	if(!C)
		usr << "There is no card port on the laptop."
		return

	var/obj/item/weapon/card/id/card
	if(C.reader)
		card = C.reader
	else if(C.writer)
		card = C.writer
	else
		usr << "There is nothing to remove from the laptop card port."
		return

	usr << "You remove [card] from the laptop."
	C.remove(card)


/obj/machinery/computer3/laptop
	name = "Laptop Computer"
	desc = "A clamshell portable computer. It is open."

	icon_state		= "laptop"
	density			= 0
	pixel_x			= 2
	pixel_y			= -3
	var/show_keyboard	= 0
	var/obj/item/weapon/stock_parts/cell/battery

	var/manipulating = 0 // To prevent disappearing bug
	var/obj/item/device/laptop/portable = null

	New(var/L, var/built = 0)
		if(!built && !battery)
			battery = new/obj/item/weapon/stock_parts/cell(src)
		..(L,built)

	verb/close_computer()
		set name = "Close Laptop"
		set category = "Object"
		set src in view(1)

		if(usr.stat || usr.restrained() || usr.lying || !istype(usr, /mob/living))
			usr << "\red You can't do that."
			return

		if(!Adjacent(usr))
			usr << "You can't reach it."
			return

		close_laptop(usr)

	proc/close_laptop(mob/user = null)
		if(istype(loc,/obj/item/device/laptop))
			testing("Close closed computer")
			return
		if(!istype(loc,/turf))
			testing("Odd computer location: [loc] - close laptop")
			return

		if(stat&BROKEN)
			if(user)
				user << "\The [src] is broken!  You can't quite get it closed."
			return

		if(!portable)
			portable=new
			portable.stored_computer = src

		if(!manipulating)
			portable.loc = loc
			loc = portable
			stat |= MAINT
			if(user)
				user << "You close \the [src]."

	auto_use_power()
		if(stat&MAINT)
			return
		if(use_power && istype(battery) && battery.charge > 0)
			if(use_power == 1)
				battery.use(idle_power_usage*CELLRATE) //idle and active_power_usage are in WATTS. battery.use() expects CHARGE.
			else
				battery.use(active_power_usage*CELLRATE)
			return 1
		return 0

	use_power(var/amount, var/chan = -1)
		if(battery && battery.charge > 0)
			battery.use(amount*CELLRATE)

	power_change()
		if( !battery || battery.charge <= 0 )
			stat |= NOPOWER
		else
			stat &= ~NOPOWER

	Del()
		if(istype(loc,/obj/item/device/laptop))
			var/obj/O = loc
			spawn(5)
				if(O)
					del O
		..()


	AltClick()
		if(Adjacent(usr))
			close_computer()




/*
CARD SLOT . used by laptop
*/
/obj/item/part/computer
	name = "computer part"
	desc = "Holy jesus you donnit now"
	gender = PLURAL
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "hdd1"
	w_class = 2.0

	var/emagged = 0
	crit_fail = 0

	// the computer that this device is attached to
	var/obj/machinery/computer3/computer

	// If the computer is attacked by an item it will reference this to decide which peripheral(s) are affected.
	var/list/attackby_types	= list()
	proc/allow_attackby(var/obj/item/I as obj,var/mob/user as mob)

		for(var/typekey in attackby_types)
			if(istype(I,typekey))
				return 1
		return 0

	proc/init(var/obj/machinery/computer/target)
		computer = target
		// continue to handle all other type-specific procedures

/obj/item/part/computer/cardslot
	name = "magnetic card slot"
	desc = "Contains a slot for reading magnetic swipe cards."

	var/obj/item/weapon/card/reader	= null
	var/obj/item/weapon/card/writer	= null	// so that you don't need to typecast dual cardslots, but pretend it's not here
											// alternately pretend they did it to save money on manufacturing somehow
	var/dualslot = 0 // faster than typechecking
	attackby_types = list(/obj/item/weapon/card)

	attackby(var/obj/item/I as obj, var/mob/user as mob)
		if(istype(I,/obj/item/weapon/card))
			insert(I)
			return
		..(I,user)

	// cardslot.insert(card, slot)
	// card: The card obj you want to insert (usually your ID)
	// slot: Which slot to insert into (1: reader, 2: writer, 3: auto), 3 default
	proc/insert(var/obj/item/weapon/card/card, var/slot = 3)
		if(!computer)
			return 0
		// This shouldn't happen, just in case..
		if(slot == 2 && !dualslot)
			usr << "This device has only one card slot"
			return 0

		if(istype(card,/obj/item/weapon/card/emag)) // emag reader slot
			if(!writer)
				usr << "You insert \the [card], and the computer grinds, sparks, and beeps.  After a moment, the card ejects itself."
				computer.emagged = 1
				return 1
			else
				usr << "You are unable to insert \the [card], as the reader slot is occupied"

		var/mob/living/L = usr
		switch(slot)
			if(1)
				if(equip_to_reader(card, L))
					usr << "You insert the card into reader slot"
				else
					usr << "There is already something in the reader slot."
			if(2)
				if(equip_to_writer(card, L))
					usr << "You insert the card into writer slot"
				else
					usr << "There is already something in the reader slot."
			if(3)
				if(equip_to_reader(card, L))
					usr << "You insert the card into reader slot"
				else if (equip_to_writer(card, L) && dualslot)
					usr << "You insert the card into writer slot"
				else if (dualslot)
					usr << "There is already something in both slots."
				else
					usr << "There is already something in the reader slot."


	// Usage of insert() preferred, as it also tells result to the user.
	proc/equip_to_reader(var/obj/item/weapon/card/card, var/mob/living/L)
		if(!reader)
			L.drop_item()
			card.loc = src
			reader = card
			return 1
		return 0

	proc/equip_to_writer(var/obj/item/weapon/card/card, var/mob/living/L)
		if(!writer && dualslot)
			L.drop_item()
			card.loc = src
			writer = card
			return 1
		return 0

	// cardslot.remove(slot)
	// slot: Which slot to remove card(s) from (1: reader only, 2: writer only, 3: both [works even with one card], 4: reader and if empty then writer ), 3 default
	proc/remove(var/slot = 3)
		var/mob/living/L = usr
		switch(slot)
			if(1)
				if (remove_reader(L))
					L << "You remove the card from reader slot"
				else
					L << "There is no card in the reader slot"
			if(2)
				if (remove_writer(L))
					L << "You remove the card from writer slot"
				else
					L << "There is no card in the writer slot"
			if(3)
				if (remove_reader(L))
					if (remove_writer(L))
						L << "You remove cards from both slots"
					else
						L << "You remove the card from reader slot"
				else
					if(remove_writer(L))
						L << "You remove the card from writer slot"
					else
						L << "There are no cards in both slots"
			if(4)
				if (!remove_reader(L))
					if (remove_writer(L))
						L << "You remove the card from writer slot"
					else if (!dualslot)
						L << "There is no card in the reader slot"
					else
						L << "There are no cards in both slots"
				else
					L << "You remove the card from reader slot"


	proc/remove_reader(var/mob/living/L)
		if(reader)
			reader.loc = loc
			if(istype(L) && !L.get_active_hand())
				if(istype(L,/mob/living/carbon/human))
					L.put_in_hands(reader)
				else
					reader.loc = get_turf(computer)
			else
				reader.loc = get_turf(computer)
			reader = null
			return 1
		return 0

	proc/remove_writer(var/mob/living/L)
		if(writer && dualslot)
			writer.loc = loc
			if(istype(L) && !L.get_active_hand())
				if(istype(L,/mob/living/carbon/human))
					L.put_in_hands(writer)
				else
					writer.loc = get_turf(computer)
			else
				writer.loc = get_turf(computer)
			writer = null
			return 1
		return 0

	// Authorizes the user based on the computer's requirements
	proc/authenticate()
		return computer.check_access(reader)

	proc/addfile(var/datum/file/F)
		if(!dualslot || !istype(writer,/obj/item/weapon/card/data))
			return 0
		var/obj/item/weapon/card/data/D = writer
		if(D.files.len > 3)
			return 0
		D.files += F
		return 1

/obj/item/part/computer/cardslot/dual
	name	= "magnetic card reader"
	desc	= "Contains slots for inserting magnetic swipe cards for reading and writing."
	dualslot = 1


