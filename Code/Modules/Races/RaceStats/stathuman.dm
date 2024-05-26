//quarter saiyan is in statsaiyan.dm at the bottom.
//half saiyan is in statsaiyan.dm at the bottom (past quarter)

mob/proc/stathuman()
	RaceDescription="Humans are probably the most well rounded race. They're not as strong in any catagory than any other race- but they're also not really the weakest. That makes them powerful and intuitive for new players. Humans hail from Earth, a lush green planet full of food and monsters. Of the Humans, a special variant is the Uchiha, a secular and rare variant with an eye ability called the Sharingan. Uchiha are more specialized to speed, power and technique, but past that remain the same as most humans."
	if(!genome)
		genome = new/datum/genetics/Human(/datum/genetics/proto/Human)
		//genome.racial_protos["[/datum/genetics/proto/Human]"] = 100
		
		//uchiha rates
		var/SUPA=rand(1,7)
		if(client) if(client.charcreationSpecial&&prob(25*client.charcreationSpecial)) SUPA = min(SUPA,6)
		if(SUPA==7 && canuchiha)
			var/badbre
			for(var/mob/M in player_list)
				if(M.Class=="Uchiha")
					badbre = 1
					break
			if(!badbre)
				Class="Uchiha"
				canuchiha -= 1
				canuchiha = max(0,canuchiha) //canuchiha starts at 2, so only two uchihas ever. Only (b)admins can reset this.
				genome.this_class = "Uchiha"


/datum/genetics/proto/Human
	name = "Human" //Name of race.
	base_icon = 'White Male.dmi' //doesn't really do anything right now, as icons are controlled by other things.
	alternate_icon_flags = list("Human") //These actually do control what racial bodytypes you see. Flags are combined from all parent races.
	special_icon_list = list() //icon 'list' flags. Human gives you human-like bodies, Alien alien. 
	prevalance = 1 //remember that this is multiplying the ratio of a genome.
	m_stats = list(
		"Physical Offense" = 1,//stats
		"Physical Defense" = 1,
		"Ki Offense" = 1,
		"Ki Defense" = 1,
		"Ki Skill" = 1,
		"Technique" = 1.2,
		"Speed" = 1.1,
		"Esoteric Skill" = 1,
		"Skillpoint Mod" = 1.5,
		"Ascension Mod" = 6,
		"Energy Level" = 1.4,//KiMod
		"Battle Power" = 0.95)//BPMod
	misc_stats = list(
		"Lifespan" = 1,//to decide if the resultant person has immortality, it has to be 20 or more. otherwise it dictates lifespan.
		"Potential" = 3,//how much potential does this person have?
		"Regeneration" = 1, //how much regeneration does this person have? regeneration stats are a stepdown. active regen gets the full effect, passive is 1/10th. if its past a low threshold, lopped limbs are considered. past a somewhat higher threshold, and death regen becomes a thing.
		"Breed Type" = 1, //1 for manual, 0 for eggu. 2 for both, 3 for sterile
		"Zanzoken Mod" = 5, //Zanzoken modifier- how fast u zanzo
		"Gravity Mod" = 1, //How fast you adjust and train in gravity.
		"Med Mod" = 4, //How fast you train in meditation.
		"Spar Mod" = 1.65, //How fast you spar.
		"Train Mod" = 1, //How fast you train.
		"Ki Regeneration" = 3,//self explanitory, just really a mod.
		"Anger" = 1.5, //anger stat, this * 100 = final anger.
		"Zenkai" = 1, //zenkai, the hax stat.
		"Space Breath" = 0,//misc stat misc stat, either 0 or 1. limited to only 0 or 1. only does things at 0 and 1. 0 means they die in space.
		"Starting BP" = 10,//starting BP
		"Tech Modifier" = 3)//how naturally good you are at technology
		//gravity mastered is a product of your home planet's gravity. nothing more, nothing less.
	list/Class_Spread = list("Uchiha" = 13,"Human" = 87)
	//format is list("class_name" = weight) //CLASS NAME HERE MUST BE THE SAME AS CLASS NAME BELOW (wont work otherwise.)
	list/class_stats = list(
		"Uchiha" = list(
			"Physical Offense" = 0.8,
			"Physical Defense" = 0.8,
			"Technique" = 1.4,
			"Ki Offense" = 1.3,
			"Ki Defense" = 0.8,
			"Speed" = 1.2,
			"Ascension Mod" = 2.2,
			"Skillpoint Mod" = 1.6,
			"Battle Power" = 0.8,
		)
	)