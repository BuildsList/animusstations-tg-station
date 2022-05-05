/obj/structure/memorial
	name = "memorial statue"
	desc = "A statue is well-designed image of a remarkably generic person. A plaque on the postment is blank."
	icon = 'icons/obj/statue.dmi'
	icon_state = "monkey"
	anchored = 1
	density = 1
	var/list/spacemen = list("Cassian Graham" = "N/A",
							 "Kristina Waldon" = "N/A",
							 "Evelin Black" = "Head of Security",
							 "Lorenzo Shere" = "Captain",
							 "Graham Maclagan" = "Security Officer",
							 "Mark Kirov" = "Surgeon",
							 "Golan Singularovich" = "N/A",
							 "Smoke Gadov" = "Assistant",
							 "Sasha Brown" = "N/A",
							 "Leroy Woodward" = "Atmospheric Technican",
							 "Kadji Heel" = "Tajaran Engineer",
							 "Saddam Maxwell" = "Chief Engineer",
							 "Lumino" = "AI",
							 "Urist McMechanic" = "Cargo Technican",
							 "Quinn Tei" = "Medical Doctor",
							 "Alan Wake" = "Station Engineer",
							 "Sofia Taro" = "Medical Doctor",
							 "Preston Gardner" = "Head Of Security",
							 "Albert Xill" = "Senior Bureaucrat",
							 "Shawn Walker" = "Detective",
							 "Airen Jon" = "Scientist",
							 "Robert Boon" = "Assistant",
							 "Richard Dickson" = "Scientist",
							 "Felicia Stoker" = "Bartender",
							 "Lorenzo Shire" = "Medical Doctor",
							 "John Travolto" = "Chief Medical Officer",
							 "Morgan James" = "Assistant",
							 "Atarabashi Nihonjin" = "RD")

	var/list/act_sec = list("aiming with taser",
						     "aiming with laser",
						     "standing at attention",
						     "spinning a handcuffs on their finger",
						     "reading a through documents",
						     "munching a donut",
						     "standing in threatening pose",
						     "jubilating")

	var/list/act_med = list("examining a corpse (?) moulage",
							 "preparing a syringe",
							 "consuming beaker contents",
							 "loading a syringe into syringe gun",
							 "spinning a scalpel in their hands",
							 "working with sleeper console",
							 "puting a sterile mask on")

	var/list/act_sci = list("pettig a slime",
							 "examining an unknown weapon",
							 "constructing machinery",
							 "welding a circuit board",
							 "connecting plasma and oxygen tanks with valve",
							 "making some notes",
							 "standing in inquisitive pose")

	var/list/act_tech = list("constructing wall segment",
							  "lighting cigar with welding tool",
							  "sliding an ID card through door control circuit",
							  "assembling flamethrower",
							  "kicking a floorbot",
							  "throwing a clown through the airlock",
							  "fixing APC malfunction",
							  "pushing a button on their hardhat light",
							  "welding cracked pipe",
							  "worshiping the singularity",
							  )

	var/list/act_generic = list("drinking some cofee",
								"smoking a cigarette",
								"reading a newspaper",
								"smiling",
								"removing kebab",
								"kicking Robust Softdrinks vending machine",
								"riding a horse",
								"riding an assistant",
								"wearing a strange robe",
								"dancing",
								"...dancing?",
								"playing around with fire alarm",
								"lockpicking",
								"praying",
								"honking")

	var/list/surrounders = list("slimes", "Russians", "assistants", "security officers", "medbots", "floorbots", "cleanbots", "Syndicate Scum", "medical doctor", "clowns", "mouses", "cats", "corgis", "cyborgs")
	var/list/moods = list("content", "happy", "drowsy", "grumpy", "sad", "miserable", "depressed", "scared", "horrified", "jubilous", "in good mood", "thoughtful", "playful")

	New()
		var/select_chance = 1/spacemen.len
		var/action
		var/char_name
		var/char_prof

		do
			for(char_name in spacemen)
				char_prof = spacemen[char_name]
				if (prob(select_chance*100)) break
		while(char_name == "")

		if (prob(50))
			switch(char_prof)
				if("Head of Security")
					action = pick(act_sec)
					icon_state = "hos"
				if("Security Officer")
					action = pick(act_sec)
					icon_state = "sec"
				if("Captain")
					action = pick(act_sec)
					icon_state = "cap"

				if("Chief Medical Officer")
					action = pick(act_med)
					icon_state = "cmo"
				if("Medical Doctor", "Surgeon")
					action = pick(act_med)
					icon_state = "md"

				if("Scientist")
					action = pick(act_sci)
					icon_state = "sci"

				if("Station Engineer")
					action = pick(act_tech)
					icon_state = "eng"
				if("Chief Engineer")
					action = pick(act_tech)
					icon_state = "ce"
				if("Tajaran Engineer")
					action = pick(act_tech)
					icon_state = "eng"
				if("Cargo Technican")
					action = pick(act_tech)
					icon_state = "human_male"
				if("Atmospheric Technican")
					action = pick(act_tech)
					icon_state = "eng"

				if("AI")
					action = "flickering"
					icon_state = "ai"
					luminosity = 5

				if("Assistant", "N/A")
					action = pick(act_generic)
					icon_state = "assist"

				else
					action = pick(act_generic)
					icon_state = "human_male"
		else
			action = pick(act_generic)

		desc = "This statue is well-desighned image of [char_name], the [char_prof]. [char_name] is [action]."
		if(prob(50))
			desc +=" [char_name] is surrounded by [pick(surrounders)]."
		if(prob(50))
			desc +=" [char_name] seems [pick(moods)]."

		desc += " This artwork is dedicated to [char_name], the [char_prof]."
