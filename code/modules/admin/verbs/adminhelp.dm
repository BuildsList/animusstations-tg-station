
/client/verb/adminhelp(msg as text)
	set category = "Admin"
	set name = "Adminhelp"

	if(say_disabled)	//This is here to try to identify lag problems
		usr << "<span class='danger'>Speech is currently admin-disabled.</span>"
		return

	//handle muting and automuting
	if(prefs.muted & MUTE_ADMINHELP)
		src << "<span class='danger'>Error: Admin-PM: You cannot send adminhelps (Muted).</span>"
		return
	if(src.handle_spam_prevention(msg,MUTE_ADMINHELP))
		return

	//remove out adminhelp verb temporarily to prevent spamming of admins.

	//clean the input msg
	if(!msg)	return
	msg = sanitize(copytext(msg,1,MAX_MESSAGE_LEN))
	if(!msg)	return
	var/original_msg = msg

	//generate keywords lookup
	var/list/surnames = list()
	var/list/forenames = list()
	var/list/ckeys = list()
	for(var/mob/M in mob_list)
		var/list/indexing = list(M.real_name, M.name)
		if(M.mind)	indexing += M.mind.name

		for(var/string in indexing)
			var/list/L = text2list(string, " ")
			var/surname_found = 0
			//surnames
			for(var/i=L.len, i>=1, i--)
				var/word = ckey(L[i])
				if(word)
					surnames[word] = M
					surname_found = i
					break
			//forenames
			for(var/i=1, i<surname_found, i++)
				var/word = ckey(L[i])
				if(word)
					forenames[word] = M
			//ckeys
			ckeys[M.ckey] = M

	if(!mob)	return						//this doesn't happen

	var/ref_mob = "\ref[mob]"
	msg = "<span class='adminnotice'><b><font color=red>HELP: </font>[key_name(src, 1)] (<A HREF='?_src_=holder;adminmoreinfo=[ref_mob]'>?</A>) (<A HREF='?_src_=holder;adminplayeropts=[ref_mob]'>PP</A>) (<A HREF='?_src_=vars;Vars=[ref_mob]'>VV</A>) (<A HREF='?_src_=holder;subtlemessage=[ref_mob]'>SM</A>) (<A HREF='?_src_=holder;adminplayerobservejump=[ref_mob]'>JMP</A>) (<A HREF='?_src_=holder;traitor=[ref_mob]'>TP</A>)</b> [msg]</span>"

	//send this msg to all admins

	for(var/client/X in admins)
		if(X.prefs.toggles & SOUND_ADMINHELP)
			X << 'sound/effects/adminhelp.ogg'
		X << msg


	//show it to the person adminhelping too
	src << "<span class='adminnotice'>PM to-<b>Admins</b>: [original_msg]</span>"

	//send it to irc if nobody is on and tell us how many were on
	var/admins_present = 0
	for(var/client/X in admins)
		admins_present++
	log_admin("HELP: [key_name(src)]: [original_msg] - heard by [admins_present] admins.")
	return
