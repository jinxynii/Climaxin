/datum/skill/SpiritReleaser
	skilltype = "Sprit Buff"
	name = "Spirit Releaser"
	desc = "Burn stamina rapidly to recover health and increase your power temporarily! Caution: This is very inefficient!"
	can_forget = TRUE
	common_sense = TRUE
	teacher=TRUE
	prereqs = list(new/datum/skill/SpiritUnleashed)
	skillcost=2
	maxlevel = 1
	tier = 4
	var/tmp/expbuffer = 0
	after_learn()
		savant<<"You feel your spirit well up inside you! You've gained a new ability!"
		savant.maxstamina+=10
		assignverb(/mob/keyable/verb/Spirit_Release)
	before_forget()
		savant<<"Your spirit vanishes, alongside the ability to release it."
		savant.maxstamina-=10
		unassignverb(/mob/keyable/verb/Spirit_Release)
	login(var/mob/logger)
		..()
		assignverb(/mob/keyable/verb/Spirit_Release)
	effector()
		..()
		if(level < 2 && savant.spirit_release_on)
			expbuffer+= 1 * rand(1,7)
			if(expbuffer>= 20)
				exp += 1 * savant.spirit_release_efficiency
				expbuffer = 0
		switch(level)
			if(0)
				if(levelup)
					levelup=0
			if(1)
				if(levelup)
					levelup=0
					savant<<"Your Spirit Release has improved a bit!"
					savant.spirit_release_efficiency = 0.5
					expbarrier=60
				
			if(2)
				if(levelup)
					levelup=0
					savant<<"Your spirit release has improved even more!"
					savant.spirit_release_efficiency = 0.15
					expbarrier=60
				

mob/var
	tmp/spirit_releaser_spam
	tmp/spirit_release_on
	spirit_release_efficiency = 1

mob/keyable/verb/Spirit_Release()
	set category="Skills"
	if(spirit_releaser_spam)
		return
	else
		spirit_releaser_spam = 1
		spawn(10) spirit_releaser_spam = 0
	if(isBuffed(/obj/buff/Spirit_Release))
		stopbuff(/obj/buff/Spirit_Release)
	else
		startbuff(/obj/buff/Spirit_Release)
		createShockwavemisc(loc,1)
		emit_Sound('chargeaura.wav')
		createCrater(loc,5)

/obj/buff/Spirit_Release
	name = "Spirit Release"
	icon='Electric_Blue.dmi'
	slot=sAURA
	var/healbuffer=0
	Buff()
		..()
		container.angerMod*=1.3
		container.buffsBuff=1.15 + (1 - container.spirit_release_efficiency)
		container.spirit_release_on = 1
		container<<"You concentrate on the power of your spirit, releasing your energy!."
	Loop()
		if(!container.transing)
			if(container.stamina>=container.maxstamina*0.005*trans_drain*container.spirit_release_efficiency || container.dead)
				container.stamina -= trans_drain*max(0.001,container.maxstamina*0.005*container.spirit_release_efficiency)/2
			healbuffer += rand(1,5)
			if(healbuffer >= 30)
				container.SpreadHeal(5,1)
			
	DeBuff()
		container.angerMod/=1.3
		container.buffsBuff=1
		container.spirit_release_on = 0
		container<<"You seal your spirit once more."
		..()