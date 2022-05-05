/obj/effect/proc_holder/changeling/revive
	name = "Revive"
	desc = "We regenerate, healing all damage from our form."
	req_stat = DEAD

//Revive from revival stasis
/obj/effect/proc_holder/changeling/revive/sting_action(var/mob/living/carbon/user)
	user.setToxLoss(0)
	user.setOxyLoss(0)
	user.setCloneLoss(0)
	user.setBrainLoss(0)
	user.setStaminaLoss(0)
	user.SetParalysis(0)
	user.SetStunned(0)
	user.SetWeakened(0)
	user.radiation = 0
	user.nutrition = NUTRITION_LEVEL_FED + 50
	user.bodytemperature = 310
	user.disabilities = 0
	user.eye_blind = 0
	user.eye_blurry = 0
	user.ear_deaf = 0
	user.ear_damage = 0
	user.heal_overall_damage(1000, 1000)
	user.ExtinguishMob()
	user.fire_stacks = 0
	user.suiciding = 0
	if(iscarbon(user))
		var/mob/living/carbon/C = src
		if(C.reagents)
			for(var/datum/reagent/R in C.reagents.reagent_list)
				C.reagents.clear_reagents()
			C.reagents.addiction_list = list()
	for(var/datum/disease/D in user.viruses)
		D.cure(0)
	if(user.stat == DEAD)
		dead_mob_list -= user
		living_mob_list += user
	user.stat = CONSCIOUS
	if(ishuman(user))
		var/mob/living/carbon/human/human_mob = user
		human_mob.restore_blood()
		human_mob.remove_all_embedded_objects()
	user << "<span class='notice'>We have regenerated.</span>"

	user.status_flags &= ~(FAKEDEATH)
	user.update_canmove()
	user.mind.changeling.purchasedpowers -= src
	user.med_hud_set_status()
	user.med_hud_set_health()
	user.update_fire()
	user.regenerate_icons()
