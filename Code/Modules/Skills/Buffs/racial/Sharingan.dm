mob/var
	uchihaskill=1
	tmp/uchihabuff=0

/datum/skill/sharingan
	skilltype = "Ki"
	name = "Sharingan"
	desc = "As a product of extreme emotional stimuli or intense training you have unlocked your innate power! Your eyes might shift into a 1 tomote Sharingan.."
	level = 0
	expbarrier = 1
	enabled = 0
	maxlevel = 2
	can_forget = FALSE
	common_sense = FALSE
	skillcost = 2
	compatible_races = list()//for classes (I.E. subraces), make sure this list is null, or else everyone of the race will be able to learn it.
	compatible_classes = list("Uchiha")
	var/tmp/kiblock=1000
	var/tmp/lastki=0
	var/tmp/diffki=0
	effector()
		..()
		switch(level)
			if(0)
				if(levelup == 1)
					levelup = 0
				diffki=(savant.Ki-lastki)
				if(savant.Ki!=lastki&&diffki<0) kiblock-=(-1*diffki)
				lastki=savant.Ki
				if(kiblock<=0)
					exp+=1
			if(1)
				if(levelup == 1)
					levelup = 0
					savant << "After much practice, you have strained your eye, giving it more power!"
					savant.verbs += /verb/Sharingan
				if(savant.uchihabuff==1)
					if(savant.uchihaskill<1)
						savant.uchihaskill+=0.001
						savant.Ki-=round((savant.MaxKi/10)/savant.uchihaskill,1)*savant.BaseDrain
					if(savant.Ki<=1) savant.SGRevert()
	login(var/mob/logger)
		..()
		if(level) assignverb(/verb/Sharingan)

verb/Sharingan()
	set category="Skills"
	if(usr.uchihabuff==1) usr.SGRevert()
	else if(usr.uchihabuff==2) usr.MSGRevert()
	else
		if(usr.Ki<=2)
			usr<<"You're too tired to maintain the Sharingan."
		else
			animate(usr,time=7,color=rgb(233, 93, 93))
			usr.color = null
			usr.startbuff(/obj/buff/Sharingan)
mob/proc/SGRevert()
	stopbuff(/obj/buff/Sharingan)

/obj/buff/Sharingan
	name = "Sharingan"
	icon='SHARINGAN.dmi'
	slot=sFORM
	var/storedpower
	Buff()
		..()
		container.overlayList+=icon
		container.overlaychanged=1
		container.emit_Sound('Sharingan.wav')
		storedpower = 1 + container.uchihaskill
		container.transBuff=storedpower
		container.uchihabuff=1
	DeBuff()
		container<<"You relax your eyes."
		container.overlayList-=icon
		container.overlaychanged=1
		container.transBuff=1
		container.uchihabuff=0
		..()

/datum/skill/msharingan
	skilltype = "Ki"
	name = "Mangekyo Sharingan"
	desc = "As a product of extreme emotional stimuli and Sharingan prowess, you have unlocked the Mangekyo Sharingan!"
	level = 0
	expbarrier = 1
	enabled = 0
	tier = 2
	skillcost = 2
	maxlevel = 2
	can_forget = FALSE
	common_sense = FALSE
	compatible_races = list()//for classes (I.E. subraces), make sure this list is null, or else everyone of the race will be able to learn it.
	compatible_classes = list("Uchiha")
	var/tmp/kiblock=1000
	var/tmp/lastki=0
	var/tmp/diffki=0
	effector()
		..()
		switch(level)
			if(0)
				if(levelup == 1)
					levelup = 0
				diffki=(savant.Ki-lastki)
				if(savant.Ki!=lastki&&diffki<0) kiblock-=(-1*diffki)
				lastki=savant.Ki
				if(kiblock<=0)
					exp+=1
			if(1)
				if(levelup == 1)
					levelup = 0
					savant << "After much practice, you have unlocked the Mangekyo Sharingan!"
				if(savant.uchihabuff==2)
					if(savant.uchihaskill<2)
						savant.uchihaskill+=0.001
						assignverb(/verb/Mangekyo_Sharingan)
						savant.Ki-=round((savant.MaxKi/10)/savant.uchihaskill,1)*savant.BaseDrain
					if(savant.Ki<=1) savant.SGRevert()
	login(var/mob/logger)
		..()
		if(level) assignverb(/verb/Mangekyo_Sharingan)

verb/Mangekyo_Sharingan()
	set category="Skills"
	if(usr.uchihabuff==1) usr.SGRevert()
	else if(usr.uchihabuff==2) usr.MSGRevert()
	else
		if(usr.Ki<=2)
			usr<<"You're too tired to maintain the Mangekyo Sharingan."
		else
			animate(usr,time=7,color=rgb(233, 93, 93))
			usr.color = null
			createDustshock(usr.loc,3)
			createCrater(usr.loc,5)
			usr.Quake()
			usr.startbuff(/obj/buff/MSharingan)
mob/proc/MSGRevert()
	stopbuff(/obj/buff/MSharingan)

/obj/buff/MSharingan
	name = "Mangekyo Sharingan"
	icon='SHARINGAN.dmi'
	slot=sFORM
	var/storedpower
	Buff()
		..()
		container<<"You activate your Mangekyo Sharingan."
		container.overlayList+=icon
		container.overlaychanged=1
		emit_Sound('Sharingan.wav')
		storedpower = 2 + container.uchihaskill
		container.transBuff=storedpower
		container.uchihabuff=2
	DeBuff()
		container<<"You relax your eyes."
		container.overlayList-=icon
		container.overlaychanged=1
		container.transBuff=1
		container.uchihabuff=0
		..()