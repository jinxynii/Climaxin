/datum/skill/tree/uchiha
	name="Human/Uchiha Racials"
	desc="Given to all Uchihas at the start."
	maxtier=4
	tier=0
	allowedtier=4
	enabled=1
	can_refund = FALSE
	compatible_races = list("Human")
	var/gotSharingan
	var/gotMkyo
	constituentskills = list(new/datum/skill/uchiha/Super_Speed,new/datum/skill/uchiha/Supreme_Skill,\
	new/datum/skill/sharingan,new/datum/skill/msharingan)
	effector()
		..()
		if(savant)
			if(!gotSharingan&&savant.uchihaskill<=1&&(savant.Emotion=="Very Angry"||savant.Emotion=="Angry"))
				usr << "You have unlocked the Sharingan!"
				gotSharingan=1
				enableskill(/datum/skill/sharingan)
			if(!TurnOffAscension||savant.AscensionAllowed)
				switch(savant.Emotion)
					if("Very Angry")
						var/datum/skill/sharingan/S = locate(/datum/skill/sharingan) in savant.learned_skills
						if(S.level==1&&savant.uchihaskill>=2&&!gotMkyo)
							usr << "You have unlocked the Mangekyo Sharingan!"
							gotMkyo = 1
							enableskill(/datum/skill/msharingan)
/datum/skill/uchiha/Super_Speed
	skilltype = "Physical"
	name = "Super Speed"
	desc = "Your lineage as a Uchiha echoes within your veins, giving you better technique and speed. Perhaps if you meditate on your lineage... Tech++, Spd+++"
	can_forget = FALSE
	common_sense = FALSE
	skillcost = 1
	tier = 1
	maxlevel = 1
	expbarrier = 12000
	after_learn()
		savant<<"Your speed and technique increases."
		savant.techniqueBuff += 0.1
		savant.speedBuff += 0.1
	before_forget()
		savant<<"Your speed and technique decreases."
		switch(level)
			if(0)
				savant.techniqueBuff -= 0.1
				savant.speedBuff -= 0.1
			if(1)
				savant.techniqueBuff -= 0.2
				savant.speedBuff -= 0.2

/datum/skill/uchiha/Super_Speed/effector()
	..()
	switch(level)
		if(0)
			if(levelup)
				levelup = 0
			if(savant.med)
				exp+=1
		if(1)
			if(levelup)
				levelup = 0
				savant << "Your speed and technique increases further!"
				savant.techniqueBuff += 0.1
				savant.speedBuff += 0.1
			if(savant.med)
				exp+=1
/*	Commented out in case we want to reimplement it
/datum/skill/uchiha/Super_Speed_II
	skilltype = "Physical"
	name = "Super Speed II"
	desc = "Gain additional technique, and speed.."
	can_forget = TRUE
	common_sense = FALSE
	skillcost = 1
	prereqs= list(new/datum/skill/uchiha/Super_Speed_I)
	enabled =0
	tier = 2
	after_learn()
		savant<<"Your martial technique increases."
		savant.techniqueBuff += 0.2
		savant.speedBuff += 0.3
	before_forget()
		savant<<"Your martial technique decreases."
		savant.techniqueBuff -= 0.2
		savant.speedBuff -= 0.2
		*/
/datum/skill/uchiha/Supreme_Skill
	skilltype = "Physical"
	name = "Supreme Skill"
	desc = "Your skill as a Uchiha knows no bounds... Perhaps if you meditate on your skill... KiSkill+++"
	can_forget = FALSE
	common_sense = FALSE
	skillcost = 1
	tier = 3
	maxlevel = 1
	expbarrier = 12000
	after_learn()
		savant<<"Your skill increases."
		savant.kiskillBuff += 0.15
	before_forget()
		savant<<"Your skill decreases."
		switch(level)
			if(0)
				savant.kiskillBuff -= 0.15
			if(1)
				savant.kiskillBuff -= 0.3

/datum/skill/uchiha/Supreme_Skill/effector()
	..()
	switch(level)
		if(0)
			if(levelup)
				levelup = 0
			if(savant.med)
				exp+=1
		if(1)
			if(levelup)
				levelup = 0
				savant << "Your skill increases further!"
				savant.kiskillBuff += 0.15
			if(savant.med)
				exp+=1
/*
/datum/skill/uchiha/Supreme_Skill_II
	skilltype = "Physical"
	name = "Martial Prowessor IV"
	desc = "Gain additional technique, which is natural to your race."
	can_forget = TRUE
	common_sense = FALSE
	skillcost = 1
	prereqs= list(new/datum/skill/uchiha/Supreme_Skill_I)
	enabled =0
	tier = 4
	after_learn()
		savant<<"Your skill increases."
		savant.kiskillBuff += 0.3
	before_forget()
		savant<<"Your skill decreases."
		savant.kiskillBuff -= 0.3
		*/