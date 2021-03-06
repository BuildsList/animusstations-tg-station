/mob/Logout()
	SSnano.user_logout(src) // this is used to clean up (remove) this user's Nano UIs
	player_list -= src
	log_access("Logout: [key_name(src)]")
	if(admin_datums[src.ckey])
		message_admins("Admin logout: [key_name(src)]")
	..()

	if(isobj(loc))
		var/obj/Loc=loc
		Loc.on_log()

	return 1