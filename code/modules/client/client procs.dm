	////////////
	//SECURITY//
	////////////
#define TOPIC_SPAM_DELAY	2		//2 ticks is about 2/10ths of a second; it was 4 ticks, but that caused too many clicks to be lost due to lag
#define UPLOAD_LIMIT		10485760	//Restricts client uploads to the server to 1MB //Could probably do with being lower.
#define MIN_CLIENT_VERSION	0		//Just an ambiguously low version for now, I don't want to suddenly stop people playing.
									//I would just like the code ready should it ever need to be used.
	/*
	When somebody clicks a link in game, this Topic is called first.
	It does the stuff in this proc and  then is redirected to the Topic() proc for the src=[0xWhatever]
	(if specified in the link). ie locate(hsrc).Topic()

	Such links can be spoofed.

	Because of this certain things MUST be considered whenever adding a Topic() for something:
		- Can it be fed harmful values which could cause runtimes?
		- Is the Topic call an admin-only thing?
		- If so, does it have checks to see if the person who called it (usr.client) is an admin?
		- Are the processes being called by Topic() particularly laggy?
		- If so, is there any protection against somebody spam-clicking a link?
	If you have any  questions about this stuff feel free to ask. ~Carn
	*/
/client/Topic(href, href_list, hsrc)
	if(!usr || usr != mob)	//stops us calling Topic for somebody else's client. Also helps prevent usr=null
		return

	//Reduces spamming of links by dropping calls that happen during the delay period
	if(next_allowed_topic_time > world.time)
		return
	next_allowed_topic_time = world.time + TOPIC_SPAM_DELAY

	//Admin PM
	if(href_list["priv_msg"])
		cmd_admin_pm(href_list["priv_msg"],null)
		return

	//Logs all hrefs
	if(config && config.log_hrefs && href_logfile)
		href_logfile << "<small>[time2text(world.timeofday,"hh:mm")] [src] (usr:[usr])</small> || [hsrc ? "[hsrc] " : ""][href]<br>"

	switch(href_list["_src_"])
		if("holder")	hsrc = holder
		if("usr")		hsrc = mob
		if("prefs")		return prefs.process_link(usr,href_list)
		if("vars")		return view_var_Topic(href,href_list,hsrc)

	..()	//redirect to hsrc.Topic()

/client/proc/is_content_unlocked()
	if(!holder)
		return 0
	return 1

/client/proc/handle_spam_prevention(var/message, var/mute_type)
	if(config.automute_on && !holder && src.last_message == message)
		src.last_message_count++
		if(src.last_message_count >= SPAM_TRIGGER_AUTOMUTE)
			src << "<span class='danger'>You have exceeded the spam filter limit for identical messages. An auto-mute was applied.</span>"
			cmd_admin_mute(src, mute_type, 1)
			return 1
		if(src.last_message_count >= SPAM_TRIGGER_WARNING)
			src << "<span class='danger'>You are nearing the spam filter limit for identical messages.</span>"
			return 0
	else
		last_message = message
		src.last_message_count = 0
		return 0

//This stops files larger than UPLOAD_LIMIT being sent from client to server via input(), client.Import() etc.
/client/AllowUpload(filename, filelength)
	if(filelength > UPLOAD_LIMIT)
		src << "<font color='red'>Error: AllowUpload(): File Upload too large. Upload Limit: [UPLOAD_LIMIT/1024]KiB.</font>"
		return 0
/*	//Don't need this at the moment. But it's here if it's needed later.
	//Helps prevent multiple files being uploaded at once. Or right after eachother.
	var/time_to_wait = fileaccess_timer - world.time
	if(time_to_wait > 0)
		src << "<font color='red'>Error: AllowUpload(): Spam prevention. Please wait [round(time_to_wait/10)] seconds.</font>"
		return 0
	fileaccess_timer = world.time + FTPDELAY	*/
	return 1


	///////////
	//CONNECT//
	///////////
#if (PRELOAD_RSC == 0)
var/list/external_rsc_urls
var/next_external_rsc = 0
#endif


/client/New(TopicData)

	TopicData = null							//Prevent calls to client.Topic from connect

	if(connection != "seeker")					//Invalid connection type.
		return null
	if(byond_version < MIN_CLIENT_VERSION)		//Out of date client.
		return null

#if (PRELOAD_RSC == 0)
	if(external_rsc_urls && external_rsc_urls.len)
		next_external_rsc = Wrap(next_external_rsc+1, 1, external_rsc_urls.len+1)
		preload_rsc = external_rsc_urls[next_external_rsc]
#endif

	clients += src
	directory[ckey] = src

	//Admin Authorisation
	holder = admin_datums[ckey]
	if(holder)
		admins += src
		holder.owner = src

	//preferences datum - also holds some persistant data for the client (because we may as well keep these datums to a minimum)
	prefs = preferences_datums[ckey]
	if(!prefs)
		prefs = new /datum/preferences(src)
		preferences_datums[ckey] = prefs
	prefs.last_ip = address				//these are gonna be used for banning
	prefs.last_id = computer_id			//these are gonna be used for banning

	. = ..()	//calls mob.Login()

	if( (world.address == address || !address) && !host )
		host = key
		world.update_status()

	if(holder)
		add_admin_verbs()
		admin_memo_show()
		if((global.comms_key == "default_pwd" || length(global.comms_key) <= 6) && global.comms_allowed) //It's the default value or less than 6 characters long, but it somehow didn't disable comms.
			src << "<span class='danger'>The server's API key is either too short or is the default value! Consider changing it immediately!</span>"

	add_verbs_from_config()
	set_client_age_from_db()

	if (isnum(player_age) && player_age == -1) //first connection
		if (config.panic_bunker && !holder && !(ckey in deadmins))
			log_access("Failed Login: [key] - New account attempting to connect during panic bunker")
			message_admins("<span class='adminnotice'>Failed Login: [key] - New account attempting to connect during panic bunker</span>")
			src << "Sorry but the server is currently not accepting connections from never before seen players."
			del(src)
			return 0

		if (config.notify_new_player_age >= 0)
			message_admins("New user: [key_name_admin(src)] is connecting here for the first time.")

		player_age = 0 // set it from -1 to 0 so the job selection code doesn't have a panic attack

	else if (isnum(player_age) && player_age < config.notify_new_player_age)
		message_admins("New user: [key_name_admin(src)] just connected with an age of [player_age] day[(player_age==1?"":"s")]")


	if (!ticker || ticker.current_state == GAME_STATE_PREGAME)
		spawn (rand(10,150))
			if (src)
				sync_client_with_db()
	else
		sync_client_with_db()

	send_resources()

	if(prefs.lastchangelog != changelog_hash) //bolds the changelog button on the interface so we know there are updates.
		src << "<span class='info'>You have unread updates in the changelog.</span>"
		if(config.aggressive_changelog)
			src.changes()
		else
			winset(src, "rpane.changelogb", "background-color=#eaeaea;font-style=bold")

	//////////////
	//DISCONNECT//
	//////////////
/client/Del()
	if(holder)
		holder.owner = null
		admins -= src
	directory -= ckey
	clients -= src
	return ..()


/client/proc/set_client_age_from_db()
	establish_db_connection()
	if(!dbcon.IsConnected())
		return

	var/sql_ckey = sanitizeSQL(src.ckey)

	var/DBQuery/query = dbcon.NewQuery("SELECT id, datediff(Now(),firstseen) as age FROM erro_player WHERE ckey = '[sql_ckey]'")
	if (!query.Execute())
		return

	while (query.NextRow())
		player_age = text2num(query.item[2])
		return

	//no match mark it as a first connection for use in client/New()
	player_age = -1


/client/proc/sync_client_with_db()
	establish_db_connection()
	if (!dbcon.IsConnected())
		return

	var/sql_ckey = sanitizeSQL(src.ckey)

	var/DBQuery/query_ip = dbcon.NewQuery("SELECT ckey FROM erro_player WHERE ip = '[address]' AND ckey != '[sql_ckey]'")
	query_ip.Execute()
	related_accounts_ip = ""
	while(query_ip.NextRow())
		related_accounts_ip += "[query_ip.item[1]], "

	var/DBQuery/query_cid = dbcon.NewQuery("SELECT ckey FROM erro_player WHERE computerid = '[computer_id]' AND ckey != '[sql_ckey]'")
	query_cid.Execute()
	related_accounts_cid = ""
	while (query_cid.NextRow())
		related_accounts_cid += "[query_cid.item[1]], "


	var/admin_rank = "Player"
	if(src.holder && src.holder.rank)
		admin_rank = src.holder.rank

	var/sql_ip = sanitizeSQL(src.address)
	var/sql_computerid = sanitizeSQL(src.computer_id)
	var/sql_admin_rank = sanitizeSQL(admin_rank)


	var/DBQuery/query_insert = dbcon.NewQuery("INSERT INTO erro_player (id, ckey, firstseen, lastseen, ip, computerid, lastadminrank) VALUES (null, '[sql_ckey]', Now(), Now(), '[sql_ip]', '[sql_computerid]', '[sql_admin_rank]') ON DUPLICATE KEY UPDATE lastseen = VALUES(lastseen), ip = VALUES(ip), computerid = VALUES(computerid), lastadminrank = VALUES(lastadminrank)")
	query_insert.Execute()

/client/proc/add_verbs_from_config()
	if(config.see_own_notes)
		verbs += /client/proc/self_notes


#undef TOPIC_SPAM_DELAY
#undef UPLOAD_LIMIT
#undef MIN_CLIENT_VERSION

//checks if a client is afk
//3000 frames = 5 minutes
/client/proc/is_afk(duration=3000)
	if(inactivity > duration)	return inactivity
	return 0

//send resources to the client. It's here in its own proc so we can move it around easiliy if need be
/client/proc/send_resources()
	//Send nanoui files to client
	SSnano.send_resources(src)
	getFiles(
		'nano/images/uiBackground.png',
		'nano/NTLogoRevised.fla',
		'nano/uiBackground.fla',
		'nano/images/source/uiBackground.xcf',
		'nano/images/source/uiBasicBackground.xcf',
		'nano/images/source/uiIcons16Green.xcf',
		'nano/images/source/uiIcons16Red.xcf',
		'nano/images/source/uiIcons24.xcf',
		'nano/images/source/uiNoticeBackground.xcf',
		'nano/images/source/uiTitleBackground.xcf',
		'nano/images/loading.gif',
		'nano/images/icon-eye.xcf',
		'nano/images/uiBackground.png',
		'nano/images/uiBackground.xcf',
		'nano/images/uiBackground-Syndicate.xcf',
		'nano/images/uiBasicBackground.png',
		'nano/images/nanomap.png',
		'nano/images/nanomap1.png',
		'nano/images/nanomap2.png',
		'nano/images/nanomap3.png',
		'nano/images/nanomap4.png',
		'nano/images/nanomap5.png',
		'nano/images/nanomap6.png',
		'nano/images/nanomapBackground.png',
		'nano/images/uiBackground-Syndicate.png',
		'nano/images/uiIcons16.png',
		'nano/images/uiIcons16Green.png',
		'nano/images/uiIcons16Red.png',
		'nano/images/uiIcons16Orange.png',
		'nano/images/uiIcons24.png',
		'nano/images/uiIcons24.xcf',
		'nano/images/uiLinkPendingIcon.gif',
		'nano/images/uiMaskBackground.png',
		'nano/images/uiNoticeBackground.jpg',
		'nano/images/uiTitleFluff.png',
		'nano/images/uiTitleFluff-Syndicate.png',
		'nano/templates/apc.tmpl',
		'nano/templates/accounts_terminal.tmpl',
		'nano/templates/advanced_airlock_console.tmpl',
		'nano/templates/ame.tmpl',
		'nano/templates/atmos_control.tmpl',
		'nano/templates/atmos_control_map_content.tmpl',
		'nano/templates/atmos_control_map_header.tmpl',
		'nano/templates/comm_console.tmpl',
		'nano/templates/disease_splicer.tmpl',
		'nano/templates/dish_incubator.tmpl',
		'nano/templates/docking_airlock_console.tmpl',
		'nano/templates/door_access_console.tmpl',
		'nano/templates/engines_control.tmpl',
		'nano/templates/escape_pod_berth_console.tmpl',
		'nano/templates/escape_pod_console.tmpl',
		'nano/templates/escape_shuttle_control_console.tmpl',
		'nano/templates/helm.tmpl',
		'nano/templates/isolation_centrifuge.tmpl',
		'nano/templates/layout_default.tmpl',
		'nano/templates/multi_docking_console.tmpl',
		'nano/templates/omni_filter.tmpl',
		'nano/templates/omni_mixer.tmpl',
		'nano/templates/pathogenic_isolator.tmpl',
		'nano/templates/shuttle_control_console.tmpl',
		'nano/templates/shuttle_control_console_exploration.tmpl',
		'nano/templates/simple_airlock_console.tmpl',
		'nano/templates/simple_docking_console.tmpl',
		'nano/templates/simple_docking_console_pod.tmpl',
		'nano/templates/TemplatesGuide.txt',
		'nano/templates/air_alarm.tmpl',
		'nano/templates/atmos_control.tmpl',
		'nano/templates/atmos_gas_pump.tmpl',
		'nano/templates/atmos_control_map_header.tmpl',
		'nano/templates/atmos_control_map_content.tmpl',
		'nano/templates/crew_monitor.tmpl',
		'nano/templates/crew_monitor_map_content.tmpl',
		'nano/templates/crew_monitor_map_header.tmpl',
		'nano/templates/canister.tmpl',
		'nano/templates/chem_dispenser.tmpl',
		'nano/templates/chem_heater.tmpl',
		'nano/templates/crew_monitor.tmpl',
		'nano/templates/cryo.tmpl',
		'nano/templates/dna_modifier.tmpl',
		'nano/templates/freezer.tmpl',
		'nano/templates/geoscanner.tmpl',
		'nano/templates/identification_computer.tmpl',
		'nano/templates/pda.tmpl',
		'nano/templates/smartfridge.tmpl',
		'nano/templates/smes.tmpl',
		'nano/templates/solar_control.tmpl',
		'nano/templates/tanks.tmpl',
		'nano/templates/telescience_console.tmpl',
		'nano/templates/transfer_valve.tmpl',
		'nano/templates/uplink.tmpl',
		'nano/js/libraries/1-jquery.js',
		'nano/js/libraries.min.js',
		'nano/js/libraries/2-doT.js',
		'nano/js/libraries/3-jquery.timers.js',
		'nano/js/pngfix.js',
		'nano/js/nano_template.js',
		'nano/js/nano_base_helpers.js',
		'nano/js/nano_update.js',
		'nano/js/nano_config.js',
		'nano/js/nano_utility.js',
		'nano/js/nano_base_callbacks.js',
		'nano/js/nano_state.js',
		'nano/js/nano_state_manager.js',
		'nano/js/nano_state_default.js',
		'nano/css/layout_basic.css',
		'nano/css/nlayout_default.css',
		'nano/css/layout_default.css',
		'nano/css/icons.css',
		'nano/css/shared.css',
		'nano/templates/helm.tmpl',
		'nano/templates/engines_control.tmpl',
		'html/painew.png',
		'html/loading.gif',
		'html/search.js',
		'html/panels.css',
		'icons/pda_icons/pda_atmos.png',
		'icons/pda_icons/pda_back.png',
		'icons/pda_icons/pda_bell.png',
		'icons/pda_icons/pda_blank.png',
		'icons/pda_icons/pda_boom.png',
		'icons/pda_icons/pda_bucket.png',
		'icons/pda_icons/pda_crate.png',
		'icons/pda_icons/pda_cuffs.png',
		'icons/pda_icons/pda_eject.png',
		'icons/pda_icons/pda_exit.png',
		'icons/pda_icons/pda_flashlight.png',
		'icons/pda_icons/pda_honk.png',
		'icons/pda_icons/pda_mail.png',
		'icons/pda_icons/pda_medical.png',
		'icons/pda_icons/pda_menu.png',
		'icons/pda_icons/pda_mule.png',
		'icons/pda_icons/pda_notes.png',
		'icons/pda_icons/pda_power.png',
		'icons/pda_icons/pda_rdoor.png',
		'icons/pda_icons/pda_reagent.png',
		'icons/pda_icons/pda_refresh.png',
		'icons/pda_icons/pda_scanner.png',
		'icons/pda_icons/pda_signaler.png',
		'icons/pda_icons/pda_status.png',
		'icons/spideros_icons/sos_1.png',
		'icons/spideros_icons/sos_2.png',
		'icons/spideros_icons/sos_3.png',
		'icons/spideros_icons/sos_4.png',
		'icons/spideros_icons/sos_5.png',
		'icons/spideros_icons/sos_6.png',
		'icons/spideros_icons/sos_7.png',
		'icons/spideros_icons/sos_8.png',
		'icons/spideros_icons/sos_9.png',
		'icons/spideros_icons/sos_10.png',
		'icons/spideros_icons/sos_11.png',
		'icons/spideros_icons/sos_12.png',
		'icons/spideros_icons/sos_13.png',
		'icons/spideros_icons/sos_14.png',
		'icons/stamp_icons/large_stamp-law.png',
		'icons/ass/assalien.png',
		'icons/ass/assdrone.png',
		'icons/ass/assfemale.png',
		'icons/ass/assmale.png',
		)

/client/proc/GetHighJob()
	if(src.prefs.job_civilian_low & ASSISTANT)//This gives the preview icon clothes depending on which job(if any) is set to 'high'
		work_chosen = "Unassigned"
	if(src.prefs.job_civilian_high)
		switch(src.prefs.job_civilian_high)
			if(HOP)
				work_chosen = "Head of Personnel"
			if(BARTENDER)
				work_chosen = "Bartender"
			if(BOTANIST)
				work_chosen = "Botanist"
			if(COOK)
				work_chosen = "Chef"
			if(JANITOR)
				work_chosen = "Janitor"
			if(LIBRARIAN)
				work_chosen = "Librarian"
			if(QUARTERMASTER)
				work_chosen = "Quartermaster"
			if(CARGOTECH)
				work_chosen = "Cargotech"
			if(MINER)
				work_chosen = "Miner"
			if(LAWYER)
				work_chosen = "Lewyer"
			if(CHAPLAIN)
				work_chosen = "Chaplain"
			if(CLOWN)
				work_chosen = "Clown"
			if(MIME)
				work_chosen = "Mime"
	else if(src.prefs.job_medsci_high)
		switch(src.prefs.job_medsci_high)
			if(RD)
				work_chosen = "Research Director"
			if(SCIENTIST)
				work_chosen = "Scientist"
			if(CHEMIST)
				work_chosen = "Chemist"
			if(DOCTOR)
				work_chosen = "Medical Doctor"
			if(GENETICIST)
				work_chosen = "Geneticist"
			if(VIROLOGIST)
			if(ROBOTICIST)
				work_chosen = "Roboticist"
	else if(src.prefs.job_engsec_high)
		switch(src.prefs.job_engsec_high)
			if(CAPTAIN)
				work_chosen = "Captain"
			if(HOS)
				work_chosen = "Head of Security"
			if(WARDEN)
				work_chosen = "Warden"
			if(DETECTIVE)
				work_chosen = "Detective"
			if(OFFICER)
				work_chosen = "Security Officer"
			if(CHIEF)
				work_chosen = "Chief Engineer"
			if(ENGINEER)
				work_chosen = "Station Engineer"
			if(ATMOSTECH)
				work_chosen = "Atmospheric Technician"
			if(AI)
				work_chosen = "AI"
			if(CYBORG)
				work_chosen = "Cyborg"
	else
		work_chosen = "Random"
