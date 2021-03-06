/datum/game_mode/wizard/raginmages
	name = "ragin' mages"
	config_tag = "raginmages"
	required_players = 20
	use_huds = 1
	var/max_mages = 0
	var/making_mage = 0
	var/mages_made = 1
	var/time_checked = 0

/datum/game_mode/wizard/announce()
	world << "<B>The current game mode is - Ragin' Mages!</B>"
	world << "<B>The <span class='warning'>Space Wizard Federation</span> is pissed, help defeat all the space wizards!</B>"

/datum/game_mode/wizard/raginmages/post_setup()
	..()
	var/playercount = 0
	if(!max_mages)
		for(var/mob/living/player in mob_list)
			if(player.client && player.stat != 2)
				playercount += 1
			max_mages = round(playercount / 8)
			if(max_mages > 20)
				max_mages = 20
			if(max_mages < 1)
				max_mages = 1
/datum/game_mode/wizard/raginmages/greet_wizard(datum/mind/wizard, you_are=1)
	if (you_are)
		wizard.current << "<B>You are the Space Wizard!</B>"
	wizard.current << "<B>The Space Wizards Federation has given you the following tasks:</B>"

	var/obj_count = 1
	wizard.current << "<b>Objective Alpha</b>: Make sure the station pays for its actions against our diplomats"
	for(var/datum/objective/objective in wizard.objectives)
		wizard.current << "<B>Objective #[obj_count]</B>: [objective.explanation_text]"
		obj_count++
	return

/datum/game_mode/wizard/raginmages/check_finished()
	var/wizards_alive = 0
	for(var/datum/mind/wizard in wizards)
		if(!istype(wizard.current,/mob/living/carbon))
			continue
		if(istype(wizard.current,/mob/living/carbon/brain))
			continue
		if(wizard.current.stat==DEAD)
			continue
		if(wizard.current.stat==UNCONSCIOUS)
			if(wizard.current.health < 0)
				wizard.current << "<font size='4'>The Space Wizard Federation is upset with your performance and have terminated your employment.</font>"
				wizard.current.stat = 2
			continue
		wizards_alive++

	if (wizards_alive)
		if(!time_checked) time_checked = world.time
		if(world.time > time_checked + 1500 && (mages_made < max_mages))
			time_checked = world.time
			make_more_mages()
	else
		if(mages_made >= max_mages)
			finished = 1
			return ..()
		else
			make_more_mages()
	return ..()

/datum/game_mode/wizard/raginmages/proc/make_more_mages()

	if(making_mage)
		return 0
	if(mages_made >= max_mages)
		return 0
	making_mage = 1
	mages_made++
	var/list/mob/dead/observer/candidates = list()
	var/mob/dead/observer/theghost = null
	spawn(rand(500, 700))
		message_admins("SWF is still pissed, sending another wizard - [max_mages - mages_made] left.")
		for(var/mob/dead/observer/G in player_list)
			if(G.client && !G.client.holder && !G.client.is_afk() && G.client.prefs.be_special & BE_WIZARD)
				if(!jobban_isbanned(G, "wizard") && !jobban_isbanned(G, "Syndicate"))
					if(age_check(G.client))
						candidates += G
		if(!candidates.len)
			message_admins("No applicable ghosts for the next ragin' mage, asking ghosts instead.")
			var/time_passed = world.time
			for(var/mob/dead/observer/G in player_list)
				if(!jobban_isbanned(G, "wizard") && !jobban_isbanned(G, "Syndicate"))
					if(age_check(G.client))
						spawn(0)
							switch(alert(G, "Do you wish to be considered for the position of Space Wizard Foundation 'diplomat'?","Please answer in 30 seconds!","Yes","No"))
								if("Yes")
									if((world.time-time_passed)>300)//If more than 30 game seconds passed.
										continue
									candidates += G
								if("No")
									continue

			sleep(300)
		if(!candidates.len)
			message_admins("This is awkward, sleeping until another mage check...")
			making_mage = 0
			mages_made--
			return
		else
			shuffle(candidates)
			for(var/mob/i in candidates)
				if(!i || !i.client) continue //Dont bother removing them from the list since we only grab one wizard

				theghost = i
				break

		if(theghost)
			var/mob/living/carbon/human/new_character= makeBody(theghost)
			new_character.mind.make_Wizard()
			making_mage = 0
			return 1

/datum/game_mode/wizard/raginmages/declare_completion()
	if(finished)

		world << "<FONT size=3><B>The crew has managed to hold off the wizard attack! The Space Wizards Federation has been taught a lesson they will not soon forget!</B></FONT>"
	..(1)

/datum/game_mode/wizard/raginmages/proc/makeBody(mob/dead/observer/G_found) // Uses stripped down and bastardized code from respawn character
	if(!G_found || !G_found.key)	return

	//First we spawn a dude.
	var/mob/living/carbon/human/new_character = new(pick(latejoin))//The mob being spawned.

	G_found.client.prefs.copy_to(new_character)
	ready_dna(new_character)
	new_character.key = G_found.key

	return new_character
