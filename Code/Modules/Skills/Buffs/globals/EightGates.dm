//Eight gates will be a mixture of the idea of 'chalkra gates = enlightenment' from real mythos and the shit from Naruto.
//Specifically, it'll be on the surface level entirely Naruto based, but as you progress, you can 'truly' unlock the eight gates,
//which might augment your strength permenantly, instead of it eating up loads of stamina.
//Meant to be a 'libre' Kaioken of sorts, the eighth gate is a x100 multiplier, with each gate being kinda exponential in power.
//Gate 1: x1.2 ; Gate of Anger ; Representation of free 'anger' boosts
//Gate 2: x3 ; Gate of Love ; Representation of death anger boosts
//Gate 3: x10 ; Gate of Desperation ; Representation of minmaxing death anger boosts
//Gate 4: x25 ; Gate of Prowess ; Representation of getting this far needing actual mastery of the Eight Gates
//Gate 5: x50 ; Gate of Wonder ; Representation of what is possible with the Eight Gates
//Gate 6: x60 ; Gate of Mastery ; Representation of you needing to 'master' the gates for this one.
//Gate 7: x65 ; Gate of Sacrifice ; Representation of the fuckhuge stamina loss.
//Gate 8: x100 ; Gate of Death ; You die when you use this gate.
//If you notice, the gates after 5 drop off in mult, this is so that the penalty for using Gate 8 is balanced with the gain of using Gate 8.
//Gates can be used with any other transformation as long as it doesn't override the buff slot. (Sharingan/Body Expansion override the buff slot.)

/datum/skill/LimitBreak/GateOne
	skilltype = "Ki"
	name = "Eight Gates"
	desc = "Unlock the first gate within you, known as the Gate of Anger. Gates will take BP into hidden potential when unmastered, weaker BP mods will have higher boosts, and regardless of mastery your maximum Ki will drop after every use (which is regainable.) Additionally, you will accumlate injuries and the like that will only be apparent after you shut off the gates. This is trainable by wearing weights, or using the Gates. You can increase the number of Gates and what you can handle by training with weights."
	can_forget = TRUE
	common_sense = TRUE
	teacher=FALSE
	tier = 2
	skillcost=1
	prereqs = list(new/datum/skill/LimitBreak/Startling_Will)
	expbarrier = 1000
	var/trackGatenum = 0
	login(var/mob/logger)
		..()
		assignverb(/mob/keyable/verb/Eight_Gates)
	after_learn()
		assignverb(/mob/keyable/verb/Eight_Gates)
		savant.GatesUnlocked[1] = 1
		savant << "The Eight Gates become available to use freely!"
	before_forget()
		unassignverb(/mob/keyable/verb/Eight_Gates)
		savant.stopbuff(/obj/buff/Eight_Gates)
		savant.GatesUnlocked[1] = 0
		savant << "You've forgotten how to use the eight gates!"
	effector()
		..()
		if(prob(5))
			var/gatemax = 1
			while(savant.GatesUnlocked[gatemax])
				gatemax += 1
				trackGatenum = gatemax
			if(savant.GateMax)
				for(var/i = 1, i <= savant.GateMax,i++)
					savant.GatesUnlocked[i] = 1
				savant.GateMax = null
		switch(level)
			if(0)
				if(levelup == 1)
					levelup = 0
				if(7>=savant.GateMastery)
					if(savant.GateAt>=1) exp += 1 * savant.GateAt
					if(savant.GateXP)
						exp += savant.GateXP
						savant.GateXP = 0
					if(savant.weight>1) if(prob(4 ** savant.weight)) exp += 1 * savant.weight * max(1,savant.GateMastery)
			if(1)
				if(levelup == 1)
					levelup = 0
					savant.GateSkill = min(8, savant.GateSkill + 1)
					savant.GateMastery = min(savant.GateSkill,savant.GateMastery + 1)
					expbarrier = 1000 * (savant.GateSkill + 1)
					level = 0

mob
	var
		GateSkill = 0
		GateMax = 0
		GatesUnlocked=list(0,0,0,0,0,0,0,0)
		GateMastery = 0
		GateAt = 0
		GateXP = 0

mob/keyable/verb/Eight_Gates()
	set category="Skills"
	if(isBuffed(/obj/buff/Eight_Gates)) usr.stopbuff(/obj/buff/Eight_Gates)
	else if(!usr.GateAt&&usr.buffsBuff==1&&!usr.KO)
		var/gatemax = 1
		var/tgatemax =0
		while(usr.GatesUnlocked[gatemax])
			gatemax += 1
			tgatemax += 1
		usr.GateAt=min(round(input("Gate number. Your maximum number is [tgatemax]. If dead, the maximum gate is 3.") as num),tgatemax)
		if(usr.GateAt == 0||usr.GateAt<1)
			return
		if(usr.dead)
			usr.GateAt = min(3,usr.GateAt)
		usr.startbuff(/obj/buff/Eight_Gates)
	else
		usr.stopbuff(/obj/buff/Eight_Gates)
		usr.GateAt = 0

/obj/buff/Eight_Gates
	name = "Eight Gates"
	icon='EightGatesIcon.dmi'
	slot=sAURA
	var/tmp/hurtlimbthreshold = 0
	var/tmp/accumdamage = 0
	var/EightGateTimeLimit = 3000
	var/lastpower = 0
	var/truebuff
	var/ending = 0
	proc/randhurtlimb()
		if(container)
			hurtlimbthreshold = 0
			accumdamage += 1
			for(var/datum/Body/B in container.body)
				if(!B.lopped)
					B.health -= 2

	Buff()
		..()
		container.emit_Sound('powerup.wav')
		truebuff = container.BPMod
		if(container.Ki>container.MaxKi)
			container.Ki = container.MaxKi
		container.buffsBuff=1
		container.poweruprunning=1
		switch(container.GateAt)
			if(0)
				DeBuff()
			if(1)
				container.gateBuff=1 + (0.2 * (1 / container.BPMod))
				lastpower=1.05
				container.Tphysoff = lastpower
				container.Tspeed = (1+(lastpower-1)/2)
				container.Tphysdef = 1/(1+(lastpower-1)/2)
				view(container)<<"[container]'s skin ripples a bit as the first gate is released."
				view(container)<<"<font size=[container.TextSize+1]><[container.SayColor]>[container]: FIRST GATE! GATE OF ANGER!!!!"
			if(2)
				container.gateBuff=1 + (1 * (1 / container.BPMod))
				lastpower=1.15
				container.Tphysoff = lastpower
				container.Tspeed = (1+(lastpower-1)/2)
				container.Tphysdef = 1/(1+(lastpower-1)/2)
				view(container)<<"[container]'s skin turns a bit as the second gate is released."
				view(container)<<"<font size=[container.TextSize+1]><[container.SayColor]>[container]: SECOND GATE! GATE OF LOVE!!!!"
			if(3)
				container.gateBuff=1 + (3 * (1 / container.BPMod))
				container.trueKiMod = 2
				container.Ki *= container.trueKiMod
				lastpower=1.25
				container.Tphysoff = lastpower
				container.Tspeed = (1+(lastpower-1)/2)
				container.Tphysdef = 1/(1+(lastpower-1)/2)
				animate(container,time=5,color=rgb(90, 156, 70))
				view(container)<<"[container]'s skin turns red and a green aura spits out as the third gate is released."
				view(container)<<"<font size=[container.TextSize+1]><[container.SayColor]>[container]: THIRD GATE! GATE OF DESPERATION!!!!"
				container.updateOverlay(/obj/overlay/auras/eightgatesaura,'Aura Green.dmi')
			if(4)
				container.gateBuff=1 + (6 * (1 / container.BPMod))
				container.trueKiMod = 2
				container.Ki *= container.trueKiMod
				lastpower=1.35
				container.Tphysoff = lastpower
				container.Tspeed = (1+(lastpower-1)/2)
				container.Tphysdef = 1/(1+(lastpower-1)/2)
				animate(container,time=5,color=rgb(90, 156, 70))
				view(container)<<"[container]'s aura flares up a bit as the fourth gate is released."
				view(container)<<"<font size=[container.TextSize+1]><[container.SayColor]>[container]: FOURTH GATE! GATE OF PROWESS!!!!"
				container.updateOverlay(/obj/overlay/auras/eightgatesaura,'Aura Green.dmi')
			if(5)
				container.gateBuff=10 * (1 / container.BPMod)
				container.trueKiMod = 3
				container.Ki *= container.trueKiMod
				lastpower=1.5
				container.Tphysoff = lastpower
				container.Tspeed = (1+(lastpower-1)/2)
				container.Tphysdef = 1/(1+(lastpower-1)/2)
				animate(container,time=5,color=rgb(185, 185, 185))
				view(container)<<"[container]'s aura turns white as the fifth gate is released."
				view(container)<<"<font size=[container.TextSize+1]><[container.SayColor]>[container]: FIFTH GATE! GATE OF WONDER!!!!"
				container.updateOverlay(/obj/overlay/auras/eightgatesaura,'aura blanco.dmi')
			if(6)
				container.gateBuff=35 * (1 / container.BPMod)
				container.trueKiMod = 3
				container.Ki *= container.trueKiMod
				lastpower=1.75
				container.Tphysoff = lastpower
				container.Tspeed = (1+(lastpower-1)/2)
				container.Tphysdef = 1/(1+(lastpower-1)/2)
				animate(container,time=5,color=rgb(185, 185, 185))
				view(container)<<"[container]'s skin has veins popping out, aura flaring wildly as the sixth gate is released."
				view(container)<<"<font size=[container.TextSize+1]><[container.SayColor]>[container]: SIXTH GATE! GATE OF MASTERY!!!!"
				container.updateOverlay(/obj/overlay/auras/eightgatesaura,'aura blanco.dmi')
			if(7)
				container.gateBuff=50 * (1 / container.BPMod)
				container.trueKiMod = 4
				container.Ki *= container.trueKiMod
				lastpower=2
				container.Tphysoff = lastpower
				container.Tspeed = (1+(lastpower-1)/2)
				container.Tphysdef = 1/(1+(lastpower-1)/2)
				animate(container,time=5,color=rgb(89, 133, 226))
				view(container)<<"[container]'s aura turns blue as the seventh gate is released."
				view(container)<<"<font size=[container.TextSize+1]><[container.SayColor]>[container]: SEVENTH GATE! GATE OF SACRIFICE!!!!"
				container.updateOverlay(/obj/overlay/auras/eightgatesaura,'(Teal White)big aura - Copy.dmi')
			if(8)
				view(container)<<"[container]'s skin turns red, veins glowing red hot, the heart shining like a beacon... The culmination of life, a red hot aura blasts from [container]!"
				sleep(10)
				view(container)<<"<font size=[container.TextSize+1]><font color=red>[container]: THE FINAL GATE! GATE OF DEATH!!!!"
				container.gateBuff=100 * (1 / container.BPMod)
				container.trueKiMod = 6
				container.Ki *= container.trueKiMod
				lastpower=3
				container.Tphysoff = lastpower
				container.Tspeed = (1+(lastpower-1)/2)
				container.Tphysdef = 1/(1+(lastpower-1)/2)
				animate(container,time=5,color=rgb(255, 0, 0))
				container.updateOverlay(/obj/overlay/auras/eightgatesaura,'AuraSuperKaioken.dmi')
		sleep(12)
		container.emit_Sound('chargeaura.wav')
	Loop()
		if(!container.transing&&!ending)//If you're using another transformation with this, mind as well make drain less gay eh?
			container.SpreadDamage((2*container.GateAt)/(1+container.GateSkill))
			if(container.GateAt<=3)
				if(container.stamina>=container.maxstamina*(0.001/(1+container.GateSkill)))
					if(container.MysticPcnt==1) container.Ki-=(container.MaxKi*(0.001/(1+container.GateSkill))) //ki takes a small hit regardless.
					if(container.Ki<=(container.MaxKi*(0.001/(1+container.GateSkill))))
						DeBuff()
						container<<"You are too tired to sustain your form."
					container.stamina -= trans_drain*max(0.001,(0.003/(1+container.GateSkill)))/2
				else DeBuff()
				if(container.GateMastery<=2&&container.GateAt<4&&container.GateAt>=3)
					if(prob(1)&&prob(5))
						hurtlimbthreshold+=1
						accumdamage += 1
						if(hurtlimbthreshold>=4)
							randhurtlimb()
			if(container.GateAt<=5&&container.GateAt>=4)
				if(container.stamina>=container.maxstamina*(0.006/(1+container.GateSkill)))
					if(container.MysticPcnt==1) container.Ki-=(container.MaxKi*(0.006/(1+container.GateSkill))) //ki takes a small hit regardless.
					if(container.Ki<=(container.MaxKi*(0.004/(1+container.GateSkill))))
						DeBuff()
						container<<"You are too tired to sustain your form."
					container.stamina -= trans_drain*max(0.001,(0.0045/(1+container.GateSkill)))/2
				else DeBuff()
				if(container.GateMastery<8&&container.GateAt<6&&container.GateAt>=4)
					if(prob(1)&&prob(10))
						hurtlimbthreshold+=1
						accumdamage += 1
						if(hurtlimbthreshold>=4)
							randhurtlimb()
			if(container.GateAt<=7&&container.GateAt>=6)
				if(container.stamina>=container.maxstamina*(0.01/(1+container.GateSkill)))
					if(container.MysticPcnt==1) container.Ki-=(container.MaxKi*(0.01/(1+container.GateSkill))) //ki takes a small hit regardless.
					if(container.Ki<=(container.MaxKi*(0.006/(1+container.GateSkill))))
						DeBuff()
						container<<"You are too tired to sustain your form."
					container.stamina -= trans_drain*max(0.001,(0.008/(1+container.GateSkill)))/2
					if(container.GateMastery<11) container.genome.sub_to_stat("Lifespan",0.01)
				else DeBuff()
				if(container.GateMastery<12&&container.GateAt>=6)
					if(prob(1)&&prob(15))
						hurtlimbthreshold+=1
						accumdamage += 2
						if(hurtlimbthreshold>=4)
							randhurtlimb()
			if(container.GateAt==8)
				sleep(1)
				EightGateTimeLimit-= 1 / max(container.GateSkill,3)
				container.stamina = container.maxstamina
				container.Ki = container.MaxKi
				if(EightGateTimeLimit<=1)
					DeBuff()
	DeBuff()
		container<<"You close your gates."
		ending = 1
		var/KOflag
		container.gateBuff=1
		container.poweruprunning=0
		container.Ki /= container.trueKiMod
		container.trueKiMod = 1
		EightGateTimeLimit = 3000
		container.Tphysoff = 1
		container.Tspeed = 1
		container.Tphysdef = 1
		animate(container,time=3,color=null)
		lastpower = 0
		if(container.GateMastery<container.GateAt&&container.GateAt>0)
			KOflag = 1
			container << "You collapse from the usage of the lower gates at lower levels of mastery... and some BP is taken into potential!"
			accumdamage += 3 * container.GateAt
			container.baseKi -= container.baseKi*0.13*container.GateAt / max(container.GateSkill+1,1)
				//var/removedbp = (container.BP*0.01) / max(container.GateSkill+1,1)
				//container.BP -= removedbp
				//container.safetyBP -= removedbp
				//container.hiddenpotential += removedbp * 1.25
		else
			container.baseKi -= container.baseKi*0.01*container.GateAt / max(container.GateSkill+1,1)
		container.removeOverlay(/obj/overlay/auras/eightgatesaura)
		if(accumdamage)
			while(accumdamage>=1)
				switch(rand(1,3))
					if(1) container.kicapacity_remove -= (0.01)
					if(2) container.phys_remove -= (0.01)
					if(3) container.bp_remove -= (0.01)
				container.baseKi -= container.baseKi*0.01*container.GateAt / max(container.GateSkill+1,1)
				accumdamage = min(accumdamage - 1,20)
				var/datum/Body/B = pick(container.body)
				if(!B.lopped)
					B.health -= 7
		if(container.GateAt==8)
			container << "You collapse. You will die in a few seconds if your HP and stamina aren't increased dramatically, and some BP is taken into potential!"
			KOflag = 1
			container.stamina = 2
			container.baseKi -= container.baseKi*0.25*container.GateAt / max(container.GateSkill+1,1)
			var/removedbp = container.BP*0.02
			container.BP -= removedbp
			container.safetyBP -= removedbp
			container.hiddenpotential += removedbp * 2
			for(var/datum/Body/L in body)
				if(!L.lopped)
					L.health = 1
			spawn
				sleep(300)
				if(container.HP<=6||container.stamina<=3)
					container.buudead = "force"
					container.Death()
		container.GateAt = 0
		if(KOflag)
			spawn container.KO()
			sleep(2)
		..()

/datum/skill/LimitBreak/GateTwo
	skilltype = "Ki"
	name = "Gate Two"
	desc = "Unlock the second gate within you, known as the Gate of Love."
	can_forget = TRUE
	common_sense = TRUE
	tier = 3
	skillcost=1
	//prereqs = list(new/datum/skill/LimitBreak/GateOne)
	enabled = 0
	expbarrier = 10000
	after_learn()
		savant.GatesUnlocked[2] = 1
		savant << "The second Gate becomes available to use freely!"
	before_forget()
		savant.GatesUnlocked[2] = 0
		savant << "You've forgotten how to use the second gate!"
/datum/skill/LimitBreak/GateThree
	skilltype = "Ki"
	name = "Gate Three"
	desc = "Unlock the third gate within you, known as the Gate of Desperation."
	can_forget = TRUE
	common_sense = TRUE
	tier = 3
	skillcost=1
	//prereqs = list(new/datum/skill/LimitBreak/GateTwo)
	enabled = 0
	expbarrier = 10000
	after_learn()
		savant.GatesUnlocked[3] = 3
		savant << "The third Gate becomes available to use freely!"
	before_forget()
		savant.GatesUnlocked[3] =0
		savant << "You've forgotten how to use the third gate!"

/datum/skill/LimitBreak/GateFour
	skilltype = "Ki"
	name = "Gate Four"
	desc = "Unlock the fourth gate within you, known as the Gate of Prowess."
	can_forget = TRUE
	common_sense = TRUE
	tier = 4
	skillcost=2
	enabled = 0
	//prereqs = list(new/datum/skill/LimitBreak/GateThree)
	expbarrier = 10000
	after_learn()
		savant.GatesUnlocked[4] = 1
		savant << "The fourth Gate becomes available to use freely!"
	before_forget()
		savant.GatesUnlocked[4] = 0
		savant << "You've forgotten how to use the fourth gate!"

/datum/skill/LimitBreak/GateFive
	skilltype = "Ki"
	name = "Gate Five"
	desc = "Unlock the fifth gate within you, known as the Gate of Wonder."
	can_forget = TRUE
	common_sense = TRUE
	tier = 4
	skillcost=2
	enabled = 0
	//prereqs = list(new/datum/skill/LimitBreak/GateFour)
	expbarrier = 10000
	after_learn()
		savant.GatesUnlocked[5] = 1
		savant << "The fifth Gate becomes available to use freely!"
	before_forget()
		savant.GatesUnlocked[5] = 0
		savant << "You've forgotten how to use the fifth gate!"


//Gate 7: x65 ; Gate of Sacrifice ; Representation of the fuckhuge stamina loss.
//Gate 8: x100 ; Gate of Death ; You die when you use this gate.

/datum/skill/LimitBreak/GateSix
	skilltype = "Ki"
	name = "Gate Six"
	desc = "Unlock the sixth gate within you, known as the Gate of Mastery. Be careful, though. If you don't master the previous gates, your decline age will suffer!"
	can_forget = TRUE
	common_sense = TRUE
	tier = 5
	skillcost=2
	enabled = 0
	//prereqs = list(new/datum/skill/LimitBreak/GateFive)
	expbarrier = 10000
	after_learn()
		savant.GatesUnlocked[6] = 1
		savant << "The sixth Gate becomes available to use freely!"
	before_forget()
		savant.GatesUnlocked[6] = 0
		savant << "You've forgotten how to use the sixth gate!"


/datum/skill/LimitBreak/GateSeven
	skilltype = "Ki"
	name = "Gate Seven"
	desc = "Unlock the fifth gate within you, known as the Gate of Sacrifice."
	can_forget = TRUE
	common_sense = TRUE
	tier = 5
	skillcost=2
	enabled = 0
	//prereqs = list(new/datum/skill/LimitBreak/GateSix)
	expbarrier = 10000
	after_learn()
		savant.GatesUnlocked[7] = 1
		savant << "The seventh Gate becomes available to use freely!"
	before_forget()
		savant.GatesUnlocked[7] = 0
		savant << "You've forgotten how to use the seventh gate!"


/datum/skill/LimitBreak/GateEight
	skilltype = "Ki"
	name = "Gate Eight"
	desc = "Unlock the eighth gate within you, known as the Gate of Death. CAUTION: YOU WILL DIE IF YOU OPEN THIS GATE!"
	can_forget = TRUE
	common_sense = TRUE
	tier = 6
	skillcost=2
	enabled = 0
	//prereqs = list(new/datum/skill/LimitBreak/GateSeven)
	expbarrier = 10000
	after_learn()
		savant.GatesUnlocked[8] = 1
		savant << "The eighth Gate becomes available to use freely!"
	before_forget()
		savant.GatesUnlocked[8] = 0
		savant << "You've forgotten how to use the eighth gate!"


obj/overlay/auras/eightgatesaura
	name = "Eight Gates Aura"
	presetAura = 1
	ID=1843