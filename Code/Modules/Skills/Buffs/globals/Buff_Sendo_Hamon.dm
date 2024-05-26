/datum/skill/Sendo_Hamon
	skilltype = "Sprit Buff"
	name = "Sendo Hamon"
	desc = "Conserve your energy, increasing Ki regeneration and defensive and offensive stats, along with slowly regenerating HP. Does not increase raw BP at first. Hamon skill will increase these bonuses."
	can_forget = TRUE
	common_sense = TRUE
	teacher=TRUE
	skillcost=2
	maxlevel = 2
	tier = 1
	enabled = 1
	var/tmp/expbuffer = 0
	after_learn()
		savant<<"You feel your Hamon well up inside you! You've gained a new ability!"
		savant.maxstamina+=10
		assignverb(/mob/keyable/verb/Hamon_Release)
		assignverb(/mob/keyable/verb/Check_Hamon_Level)
	before_forget()
		savant<<"Your Hamon vanishes, alongside the ability to release it."
		savant.maxstamina-=10
		unassignverb(/mob/keyable/verb/Hamon_Release)
		unassignverb(/mob/keyable/verb/Check_Hamon_Level)
	login(var/mob/logger)
		..()
		assignverb(/mob/keyable/verb/Hamon_Release)
		assignverb(/mob/keyable/verb/Check_Hamon_Level)
	effector()
		..()
		if(level < 2 && savant.Hamon_release_on)
			expbuffer+= 1 * rand(1,7)
			savant.hamon_skill_buffer++
			if(expbuffer>= 20)
				exp += 1 * savant.Hamon_release_efficiency
				expbuffer = 0
		switch(level)
			if(0)
				if(levelup)
					levelup=0
			if(1)
				if(levelup)
					levelup=0
					savant<<"Your Hamon release has improved a bit!"
					savant.Hamon_release_efficiency = 0.5
					expbarrier=60
					savant.hamon_skill+=1

			if(2)
				if(levelup)
					levelup=0
					savant<<"Your Hamon release has improved even more!"
					savant.Hamon_release_efficiency = 0.15
					expbarrier=60
					savant.hamon_skill+=1
				exp = 0


mob/var
	tmp/Hamon_releaser_spam
	tmp/Hamon_release_on
	hamon_skill = 0
	Hamon_release_efficiency = 1

mob/keyable/verb/Hamon_Release()
	set category="Skills"
	if(Hamon_releaser_spam)
		return
	else
		Hamon_releaser_spam = 1
		spawn(10) Hamon_releaser_spam = 0
	if(isBuffed(/obj/buff/Hamon_Release))
		stopbuff(/obj/buff/Hamon_Release)
	else
		startbuff(/obj/buff/Hamon_Release)

/obj/buff/Hamon_Release
	name = "Hamon Release"
	icon='Electric_Blue.dmi'
	slot=sAURA
	var/healbuffer=0
	var/hamon_init_skill
	Buff()
		..()
		hamon_init_skill = container.hamon_skill
		container.buffsBuff=1 + hamon_init_skill * 0.1
		container.Hamon_release_on = 1
		container.Tphysoff+=0.2 + hamon_init_skill * 0.1
		container.Tphysdef+=0.2 + hamon_init_skill * 0.1
		container.Tspeed+=0.2 + hamon_init_skill * 0.1
		container<<"You concentrate on the power of your Hamon, releasing your energy!."
	Loop()
		if(!container.transing)
			if(container.hamon_skill <= 4)
				if(container.stamina>=container.maxstamina*0.002*container.Hamon_release_efficiency || container.dead)
					container.stamina -= trans_drain*max(0.001,container.maxstamina*0.002*container.Hamon_release_efficiency)/2
			healbuffer += rand(1,5)
			if(healbuffer >= 25)
				container.SpreadHeal(1 + container.hamon_skill * 0.25,1)

	DeBuff()
		container.buffsBuff=1
		container.Tphysoff-=0.2 + hamon_init_skill * 0.1
		container.Tphysdef-=0.2 + hamon_init_skill * 0.1
		container.Tspeed-=0.2 + hamon_init_skill * 0.1
		container.Hamon_release_on = 0
		container<<"You seal your Hamon once more."
		..()