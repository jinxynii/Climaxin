mob/var
	hasdeviltrigger = 0
	hassindeviltrigger = 0
	deviltriggerskill = 1
	deviltriggerdrain = 0.015
	deviltriggered = 0

/datum/skill/tree/Demonic_Corruption
	name="Demonic Corruption"
	desc="Demonic energies have suffused your soul."
	maxtier=1
	tier=3
	enabled=0
	allowedtier=1
	can_refund = FALSE
	constituentskills = list(new/datum/skill/DevilTrigger)

/datum/skill/DevilTrigger
	skilltype = "Form"
	name = "Devil Trigger"
	desc = "The demonic energy latent in your being awakens! You take on a devilish form, with strength to match!"
	level = 0
	expbarrier = 100
	maxlevel = 7
	skillcost= 0
	enabled = 1
	exp = 1
	can_forget = FALSE
	common_sense = FALSE
	var/kiblock=1000
	var/tmp/lastki=0
	var/tmp/diffki=0

/datum/skill/DevilTrigger/effector()
	..()
	switch(level)
		if(0)
			if(levelup == 1)
				levelup = 0
			diffki=(savant.Ki-lastki)
			if(savant.Ki!=lastki&&diffki<0) kiblock-=(-1*diffki)
			lastki=savant.Ki
			if(kiblock<=0)
				kiblock = round(1000/exp)
				exp+=1
		if(1)
			if(levelup == 1)
				levelup = 0
				savant << "You feel a demonic power awaken within you!"
				assignverb(/mob/keyable/verb/Devil_Trigger)
				expbarrier = 10000
				savant.speedBuff += 0.1
			if(savant.isBuffed(/obj/buff/Devil_Trigger))
				if(savant.deviltriggerskill<100)
					savant.deviltriggerskill+=0.001
				exp+=1
		if(2)
			if(levelup == 1)
				levelup = 0
				savant.deviltriggerdrain = 0.05
				savant << "Your demonic power grows in strength!"
				expbarrier = 12000
				savant.speed += 0.1
				savant.HPregenbuff += 0.2
			if(savant.isBuffed(/obj/buff/Devil_Trigger))
				if(savant.deviltriggerskill<150)
					savant.deviltriggerskill+=0.001
				exp+=1
		if(3)
			if(levelup == 1)
				levelup = 0
				savant.deviltriggerdrain = 0.001
				savant << "Your demonic power becomes overwhelming!"
				expbarrier = 15000
				savant.speed += 0.2
				savant.HPregenbuff += 0.2
				savant.physdef += 0.2
			if(savant.isBuffed(/obj/buff/Devil_Trigger))
				if(savant.deviltriggerskill<200)
					savant.deviltriggerskill+=0.001
				exp+=1
		if(4)
			if(levelup == 1)
				levelup = 0
				savant.deviltriggerdrain = 0
				savant << "Your demonic power has reached its peak!"
				savant.speed += 0.3
				savant.HPregenbuff += 0.1
				savant.physdef += 0.4
			if(savant.isBuffed(/obj/buff/Devil_Trigger))
				if(savant.deviltriggerskill<250)
					savant.deviltriggerskill+=0.001
				if(savant.deviltriggerskill>250)
					savant.deviltriggerskill=250
			if(savant.isBuffed(/obj/buff/Devil_Trigger)&&savant.hassindeviltrigger==1)
				level=5
				levelup=1
				savant.stopbuff(/obj/buff/Devil_Trigger)
		if(5)
			if(levelup == 1)
				levelup = 0
				expbarrier = 10000
				savant.deviltriggered=1
				savant.startbuff(/obj/buff/Devil_Trigger)
			if(savant.isBuffed(/obj/buff/Devil_Trigger))
				if(savant.deviltriggerskill<400)
					savant.deviltriggerskill+=0.001
				exp+=1
		if(6)
			if(levelup == 1)
				levelup = 0
				expbarrier = 10000
				savant <<"You have become used to your true demonic form."
				savant.willpowerMod +=0.1
			if(savant.isBuffed(/obj/buff/Devil_Trigger))
				if(savant.deviltriggerskill<500)
					savant.deviltriggerskill+=0.001
				exp+=1
		if(6)
			if(levelup == 1)
				levelup = 0
				expbarrier = 10000
				savant <<"You have reached the highest level of true demonic power."
				savant.willpowerMod +=0.1
			if(savant.isBuffed(/obj/buff/Devil_Trigger))
				if(savant.deviltriggerskill<600)
					savant.deviltriggerskill+=0.001
				if(savant.deviltriggerskill>600)
					savant.deviltriggerskill=600

/datum/skill/DevilTrigger/login(var/mob/logger)
	..()
	if(level >= 1)
		assignverb(/mob/keyable/verb/Devil_Trigger)
		assignverb(/mob/keyable/verb/Devil_Trigger_Mastery)

/datum/skill/DevilTrigger/after_learn()
	savant <<"You feel a dark power stir within you"

mob/keyable/verb/Devil_Trigger_Mastery()
	set category = "Skills"
	usr <<"You concentrate deeply on your demonic powers..."
	sleep (1)
	if(usr.deviltriggerskill <=100)
		usr <<"You are still inexperienced with your form. Skill: [round(deviltriggerskill,1)]"
	if(usr.deviltriggerskill <=150&&usr.deviltriggerskill >100)
		usr <<"You are gaining control over your form. Skill: [round(deviltriggerskill,1)]"
	if(usr.deviltriggerskill <=200&&usr.deviltriggerskill >150)
		usr <<"You are approaching mastery of your form. Skill: [round(deviltriggerskill,1)]"
	if(usr.deviltriggerskill <250&&usr.deviltriggerskill >200)
		usr <<"You are an expert with your form. Skill: [round(deviltriggerskill,1)]"
	if(usr.deviltriggerskill ==250)
		usr <<"You have mastered your Devil Trigger form! Skill: [round(deviltriggerskill,1)]"
	if(usr.deviltriggerskill <=400&&usr.deviltriggerskill >250)
		usr <<"You have ascended beyond the normal Devil Trigger. Skill: [round(deviltriggerskill,1)]"
	if(usr.deviltriggerskill <=500&&usr.deviltriggerskill >400)
		usr <<"You are familiar with your ascended form. Skill: [round(deviltriggerskill,1)]"
	if(usr.deviltriggerskill <=600&&usr.deviltriggerskill >500)
		usr <<"You are nearing the pinnacle of your form. Skill: [round(deviltriggerskill,1)]"
	if(usr.deviltriggerskill ==600)
		usr <<"You have mastered the Sin Devil Trigger form. Skill: [round(deviltriggerskill,1)]"

mob/keyable/verb/Devil_Trigger()
	set category = "Skills"
	var/obj/items/Equipment/Weapon/Sword/Rebellion/A = locate() in usr.contents
	var/obj/items/Equipment/Weapon/Sword/Sparda/B = locate() in usr.contents
	var/obj/items/Equipment/Weapon/Sword/Yamato/C = locate() in usr.contents
	if(usr.deviltriggered==0&&usr.hassindeviltrigger==0)
		usr.deviltriggered=1
		usr <<"You unleash your demonic power!"
		usr.startbuff(/obj/buff/Devil_Trigger)
		return
	if(usr.deviltriggered==1&&usr.deviltriggerskill>=250&&usr.daequip==1&&usr.hassindeviltrigger==0)
		if(A)
			usr <<"You absorb the Devil Arm, unleashing your true demonic power!"
			usr.hassindeviltrigger=1
			usr.deviltriggered=2
			A.Equip()
			del(A)
			return
		if(B)
			usr <<"You absorb the Devil Arm, unleashing your true demonic power!"
			usr.hassindeviltrigger=1
			usr.deviltriggered=2
			B.Equip()
			del(B)
			return
		if(C)
			usr <<"You absorb the Devil Arm, unleashing your true demonic power!"
			usr.hassindeviltrigger=1
			usr.deviltriggered=2
			C.Equip()
			del(C)
			return
	if(usr.deviltriggered==0&&usr.hassindeviltrigger==1)
		usr.deviltriggered=2
		usr <<"You unleash your true demonic power!"
		usr.startbuff(/obj/buff/Devil_Trigger)
		return
	if(usr.deviltriggered!=0)
		usr <<"You seal your demonic power."
		usr.stopbuff(/obj/buff/Devil_Trigger)
		usr.deviltriggered=0

obj/buff/Devil_Trigger
	name = "Devil Trigger"
	icon='Dante DT(DMC3).dmi'
	slot=sFORM //which slot does this buff occupy
	var/lastForm=0
	var/dtpower=1

obj/buff/Devil_Trigger/Buff()
	lastForm=0
	..()
obj/buff/Devil_Trigger/Loop()
	if(!container.transing)
		if(container.deviltriggered>=1) if(container.deviltriggerdrain)
			if(container.stamina>=container.maxstamina*container.deviltriggerdrain)
				if(prob(20)) container.Ki-=container.deviltriggerdrain*container.BaseDrain //ki takes a small hit regardless.
				if(container.Ki<=container.MaxKi*container.deviltriggerdrain)
					container.stopbuff(/obj/buff/Devil_Trigger)
					container.deviltriggered=0
					container<<"You are too tired to sustain your form."
				container.stamina -= trans_drain*max(0.001,container.deviltriggerdrain) //max statement ensures you won't be hitting exactly zero if drain changes mid drain.
			else
				container.stopbuff(/obj/buff/Devil_Trigger)
				container.deviltriggered=0
	if(lastForm!=container.deviltriggered)
		lastForm=container.deviltriggered
		sleep container.RemoveHair()
		container.originalicon = container.icon
		switch(container.deviltriggered)
			if(1)
				dtpower = 1 + (container.deviltriggerskill/100)
				container.transBuff*=dtpower
				container.trueKiMod = 2
				container.Ki *= container.trueKiMod
				container.speedMod *= 1.2
				container.HPregenbuff += 3
				container.physdefMod *= 1.2
				container.icon='Dante DT(DMC3).dmi'
				container.updateOverlay(/obj/overlay/effects/MajinEffect)
			if(2)
				dtpower = 2 + (container.deviltriggerskill/100)
				container.transBuff*=dtpower
				container.trueKiMod = 2
				container.Ki *= container.trueKiMod
				container.speedMod *= 1.2
				container.HPregenbuff += 3
				container.physdefMod *= 1.2
				container.kidefMod *= 1.2
				container.icon='Vergil DT.dmi'
				container.updateOverlay(/obj/overlay/effects/MajinEffect)
		..()
obj/buff/Devil_Trigger/DeBuff()
	switch(container.deviltriggered)
		if(1)
			container.transBuff /= dtpower
			container.Ki = container.Ki / container.trueKiMod
			container.trueKiMod = 1
			container.speedMod /= 1.2
			container.HPregenbuff -= 3
			container.physdefMod /= 1.2
			container.icon = container.originalicon
			container.removeOverlay(/obj/overlay/effects/MajinEffect)
			container.updateOverlay(/obj/overlay/hairs/hair)
			container.deviltriggered = 0
			..()
		if(2)
			container.transBuff /= dtpower
			container.Ki = container.Ki / container.trueKiMod
			container.trueKiMod = 1
			container.speedMod /= 1.2
			container.HPregenbuff -= 3
			container.physdefMod /= 1.2
			container.kidefMod /= 1.2
			container.icon = container.originalicon
			container.removeOverlay(/obj/overlay/effects/MajinEffect)
			container.updateOverlay(/obj/overlay/hairs/hair)
			container.deviltriggered = 0
			..()

