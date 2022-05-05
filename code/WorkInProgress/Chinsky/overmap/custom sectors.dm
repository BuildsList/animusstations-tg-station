 // station
/obj/effect/mapinfo/sector/station
	obj_type = /obj/effect/map/sector/station
	mapx = 35
	mapy = 48
	New()
		..()
		name = "[station_name()]"
/obj/effect/map/sector/station
	desc = "station."
	icon = 'icons/obj/meteor.dmi'
	icon_state = "station13"
	New()
		..()
		name = "[station_name()]"

//mining
/obj/effect/mapinfo/sector/asteroid
	name = "mining asteroid"
	obj_type = /obj/effect/map/sector/asteroid
	mapx = 35
	mapy = 52
/obj/effect/map/sector/asteroid
	name = "mining asteroid"
	icon = 'icons/obj/meteor.dmi'
	icon_state = "large"

//derelict
/obj/effect/mapinfo/sector/derelict
	name = "derelict station"
	obj_type = /obj/effect/map/sector/derelict
	mapx = 40
	mapy = 48
/obj/effect/map/sector/derelict
	name = "derelict station"
	icon = 'icons/obj/meteor.dmi'
	icon_state = "large"

//telecoms
/obj/effect/mapinfo/sector/telecoms
	name = "old communications satellite"
	obj_type = /obj/effect/map/sector/telecoms
	mapx = 38
	mapy = 50
/obj/effect/map/sector/telecoms
	name = "old communications satellite"
	icon = 'icons/obj/meteor.dmi'
	icon_state = "telecoms"


/obj/effect/mapinfo/ship
	name = "generic ship"
	obj_type = /obj/effect/map/ship
	shipname = "generic_ship"

//спутник
/obj/effect/mapinfo/ship/satellite
	name = "soviet satellite"
	shipname = "soviet satellite"
	obj_type = /obj/effect/map/ship/satellite
	mapx = 41
	mapy = 47

/obj/effect/map/ship/satellite
	name = "soviet satellite"
	shipname = "soviet satellite"
	desc = "circumplanetary satellite."
	icon = 'icons/obj/meteor.dmi'
	icon_state = "satellite"
	vessel_mass = 300


// blackmarketpackers
/obj/effect/mapinfo/sector/blackmarketpackers
	name = "black market"
	obj_type = /obj/effect/map/sector/gen/blackmarketpackers
	mapx = 24
	mapy = 63
/obj/effect/map/sector/gen/blackmarketpackers
	name = "derelict station"
	icon = 'icons/obj/meteor.dmi'


// StationCollision
/obj/effect/mapinfo/sector/stationcollision
	name = "station collision"
	obj_type = /obj/effect/map/sector/gen/stationcollision
	mapx = 80
	mapy = 75
/obj/effect/map/sector/gen/stationcollision
	name = "station collision"
	icon = 'icons/obj/meteor.dmi'


/obj/effect/map/sector/gen
	New()
		..()
		icon_state = "[pick("small","large","sharp","dust","small3")]"
