// the power cell
// charge from 0 to 100%
// fits in APC to provide backup power

/obj/item/weapon/stock_parts/cell/New()
	..()
	charge = maxcharge
	desc = "This cell has a power rating of [maxcharge], and you should not swallow it."

	updateicon()

/obj/item/weapon/stock_parts/cell/proc/updateicon()
	overlays.Cut()

	if(charge < 0.01)
		return
	else if(charge/maxcharge >=0.995)
		overlays += image('icons/obj/power.dmi', "cell-o2")
	else
		overlays += image('icons/obj/power.dmi', "cell-o1")

/obj/item/weapon/stock_parts/cell/proc/percent()		// return % charge of cell
	return 100.0*charge/maxcharge

// use power from a cell
/obj/item/weapon/stock_parts/cell/proc/use(var/amount)
	if(rigged && amount > 0)
		explode()
		return 0

	if(charge < amount)	return 0
	charge = (charge - amount)
	return 1

// recharge the cell
/obj/item/weapon/stock_parts/cell/proc/give(var/amount)
	if(rigged && amount > 0)
		explode()
		return 0

	if(maxcharge < amount)	return 0
	var/power_used = min(maxcharge-charge,amount)
	if(crit_fail)	return 0
	if(!prob(reliability))
		minor_fault++
		if(prob(minor_fault))
			crit_fail = 1
			return 0
	charge += power_used
	return power_used


/obj/item/weapon/stock_parts/cell/examine(mob/user)
	..()
	if(crit_fail || rigged)
		user << "<span class='danger'>This power cell seems to be faulty!</span>"
	else
		user << "The charge meter reads [round(src.percent() )]%."


/obj/item/weapon/stock_parts/cell/attackby(obj/item/W, mob/user, params)
	..()
	if(istype(W, /obj/item/weapon/reagent_containers/syringe))
		var/obj/item/weapon/reagent_containers/syringe/S = W

		user << "<span class='notice'>You inject the solution into the power cell.</span>"

		if(S.reagents.has_reagent("plasma", 5))

			rigged = 1

		S.reagents.clear_reagents()


/obj/item/weapon/stock_parts/cell/proc/explode()
	var/turf/T = get_turf(src.loc)
/*
 * 1000-cell	explosion(T, -1, 0, 1, 1)
 * 2500-cell	explosion(T, -1, 0, 1, 1)
 * 10000-cell	explosion(T, -1, 1, 3, 3)
 * 15000-cell	explosion(T, -1, 2, 4, 4)
 * */
	if (charge==0)
		return
	var/devastation_range = -1 //round(charge/11000)
	var/heavy_impact_range = round(sqrt(charge)/60)
	var/light_impact_range = round(sqrt(charge)/30)
	var/flash_range = light_impact_range
	if (light_impact_range==0)
		rigged = 0
		corrupt()
		return
	//explosion(T, 0, 1, 2, 2)
	explosion(T, devastation_range, heavy_impact_range, light_impact_range, flash_range)

	qdel(src)

/obj/item/weapon/stock_parts/cell/proc/corrupt()
	charge /= 2
	maxcharge /= 2
	if (prob(10))
		rigged = 1 //broken batterys are dangerous

/obj/item/weapon/stock_parts/cell/emp_act(severity)
	charge -= 1000 / severity
	if (charge < 0)
		charge = 0
	if(reliability != 100 && prob(50/severity))
		reliability -= 10 / severity
	..()

/obj/item/weapon/stock_parts/cell/ex_act(severity, target)
	..()
	if(!gc_destroyed)
		switch(severity)
			if(2)
				if(prob(50))
					corrupt()
			if(3)
				if(prob(25))
					corrupt()


/obj/item/weapon/stock_parts/cell/blob_act()
	ex_act(1)

/obj/item/weapon/stock_parts/cell/proc/get_electrocute_damage()
	if(charge >= 1000)
		return Clamp(round(charge/10000), 10, 90) + rand(-5,5)
	else
		return 0