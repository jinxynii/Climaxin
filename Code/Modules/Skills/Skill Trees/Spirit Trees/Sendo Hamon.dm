/datum/skill/tree/Sendo_Hamon
	name = "Sendo Hamon"
	desc = "Through self-controlled respiration, use an energy identical to the power of the Sun."
	maxtier = 3
	tier=3
	allowedtier = 1
	constituentskills = list(new/datum/skill/Sendo_Hamon,new/datum/skill/Sendo_Punch,new/datum/skill/Zoom_Punch,new/datum/skill/Hamon_Detection,\
		new/datum/skill/Ripple_Cutter,new/datum/skill/Sendo_Wave_Kick,new/datum/skill/Sendo_Overdrive,new/datum/skill/Sunlight_Yellow_Overdrive,new/datum/skill/Final_Ripple)
	growbranches()
		if(invested)
			allowedtier = min(invested+1,6)
		if(savant.hamon_skill >= 1)
			enableskill(/datum/skill/Sendo_Punch)
		if(savant.hamon_skill >= 3)
			enableskill(/datum/skill/Zoom_Punch)
			enableskill(/datum/skill/Hamon_Detection)
		if(savant.hamon_skill >= 5)
			enableskill(/datum/skill/Ripple_Cutter)
			enableskill(/datum/skill/Sendo_Wave_Kick)
		if(savant.hamon_skill >= 7)
			enableskill(/datum/skill/Sendo_Overdrive)
		if(savant.hamon_skill >= 8)
			enableskill(/datum/skill/Sunlight_Yellow_Overdrive)
		if(savant.hamon_skill >= 10)
			enableskill(/datum/skill/Final_Ripple)
			enableskill(/datum/skill/Teach_Ripple)
		..()
		return
	prunebranches()
		if(invested)
			allowedtier = min(invested+1,6)
		..()
		return
	effector()
		..()
		if(savant.hamon_skill_buffer >= 45 * savant.hamon_skill / (1 + savant.hamon_gain_boost))
			savant.hamon_skill = min(10,savant.hamon_skill+1)
			savant.hamon_skill_buffer = 0
			savant.hamon_gain_boost += 0.15
			savant.hamon_gain_boost = min(savant.hamon_gain_boost,5)
			savant << "You've reached another level in Hamon skill!"

mob/var
	hamon_skill_buffer = 0
	hamon_gain_boost = 0
	tmp/isfinaling = 0
/datum/skill/Sendo_Punch
	skilltype = "Sprit Buff"
	name = "Sendo Punch"
	desc = "Using Hamon, release it into a punch that damages the other foe depending on your skill. Does a lot of damage to Werewolves and Vampires."
	can_forget = TRUE
	common_sense = TRUE
	teacher=TRUE
	skillcost=2
	maxlevel = 1
	tier = 2
	enabled = 1
	var/tmp/expbuffer = 0
	after_learn()
		savant<<"You feel your Hamon well up inside you! You've gained a new ability!"
		assignverb(/mob/keyable/verb/Sendo_Punch)
	before_forget()
		savant<<"Your Hamon vanishes, alongside a ability to release it."
		unassignverb(/mob/keyable/verb/Sendo_Punch)
	login(var/mob/logger)
		..()
		assignverb(/mob/keyable/verb/Sendo_Punch)

mob/keyable/verb/Sendo_Punch()
	set category = "Skills"
	var/kireq=usr.Ephysoff*Hamon_release_efficiency*1.1
	if(!usr.med&&!usr.train&&!usr.KO&&usr.stamina>=kireq&&!usr.basicCD&&usr.canfight)
		usr.basicCD+=15
		if(MeleeAttack(hamon_skill*4,FALSE,hamon_skill))
			usr.hamon_skill_buffer += 1
			usr.stamina-=kireq

/datum/skill/Zoom_Punch
	skilltype = "Sprit Buff"
	name = "Zoom Punch"
	desc = "Unlock your joints using Hamon, and release a ranged melee attack. Will work up to three tiles away. Make sure to target the enemy before using this. As always, it does a lot of damage to Werewolves and Vampires."
	can_forget = TRUE
	common_sense = TRUE
	teacher=TRUE
	skillcost=1
	maxlevel = 1
	tier = 3
	enabled = 1
	var/tmp/expbuffer = 0
	after_learn()
		savant<<"You feel your Hamon well up inside you! You've gained a new ability!"
		assignverb(/mob/keyable/verb/Zoom_Punch)
	before_forget()
		savant<<"Your Hamon vanishes, alongside a ability to release it."
		unassignverb(/mob/keyable/verb/Zoom_Punch)
	login(var/mob/logger)
		..()
		assignverb(/mob/keyable/verb/Zoom_Punch)

mob/keyable/verb/Zoom_Punch()
	set category = "Skills"
	var/kireq=usr.Ephysoff*Hamon_release_efficiency*1.2
	if(!usr.med&&!usr.train&&!usr.KO&&usr.stamina>=kireq&&!usr.basicCD&&usr.canfight)
		usr.basicCD+=15
		var/mob/M = usr.target
		if(M)
			if(get_dist(M.loc,usr.loc)<= 3 && M in view(3))
				if(doAttack(M,usr.hamon_skill*3,FALSE,usr.hamon_skill,"elongates a fist towards"))
					usr.hamon_skill_buffer += 1
					usr.stamina-=kireq

/datum/skill/Hamon_Detection
	skilltype = "Sprit Buff"
	name = "Hamon Detection"
	desc = "Using hamon, detect creatures around you. Unlike Sense, creatures cannot hide from this."
	can_forget = TRUE
	common_sense = TRUE
	teacher=TRUE
	skillcost=1
	maxlevel = 1
	tier = 3
	enabled = 1
	var/tmp/expbuffer = 0
	after_learn()
		savant<<"You feel your Hamon well up inside you! You've gained a new ability!"
		assignverb(/mob/keyable/verb/Hamon_Detection)
	before_forget()
		savant<<"Your Hamon vanishes, alongside a ability to release it."
		unassignverb(/mob/keyable/verb/Hamon_Detection)
	login(var/mob/logger)
		..()
		assignverb(/mob/keyable/verb/Hamon_Detection)

mob/keyable/verb/Hamon_Detection()
	set category = "Skills"
	var/kireq=5*Hamon_release_efficiency
	if(!usr.med&&!usr.train&&!usr.KO&&usr.stamina>=kireq&&!usr.basicCD&&usr.canfight)
		usr.basicCD+=15
		usr.stamina -= kireq
		usr.hamon_skill_buffer += 0.5
		for(var/mob/M in mob_list)
			if(M.z == usr.z)
				switch(get_dir(usr,M))
					if(NORTH) usr<<"You sense a creature, distance: [get_dist(src,M)] (North)"
					if(SOUTH) usr<<"You sense a creature, distance: [get_dist(src,M)] (South)"
					if(EAST) usr<<"You sense a creature, distance: [get_dist(src,M)] (East)"
					if(NORTHEAST) usr<<"You sense a creature, distance: [get_dist(src,M)] (Northeast)"
					if(SOUTHEAST) usr<<"You sense a creature, distance: [get_dist(src,M)] (Southeast)"
					if(WEST) usr<<"You sense a creature, distance: [get_dist(src,M)] (West)"
					if(NORTHWEST) usr<<"You sense a creature, distance: [get_dist(src,M)] (Northwest)"
					if(SOUTHWEST) usr<<"You sense a creature, distance: [get_dist(src,M)] (Southwest)"
/datum/skill/Ripple_Cutter
	skilltype = "Sprit Buff"
	name = "Ripple Cutter"
	desc = "Send a wave of ripple energy toward a foe, dealing some major damage."
	can_forget = TRUE
	common_sense = TRUE
	teacher=TRUE
	skillcost=1
	maxlevel = 1
	tier = 4
	enabled = 1
	var/tmp/expbuffer = 0
	after_learn()
		savant<<"You feel your Hamon well up inside you! You've gained a new ability!"
		assignverb(/mob/keyable/verb/Ripple_Cutter)
	before_forget()
		savant<<"Your Hamon vanishes, alongside a ability to release it."
		unassignverb(/mob/keyable/verb/Ripple_Cutter)
	login(var/mob/logger)
		..()
		assignverb(/mob/keyable/verb/Ripple_Cutter)

mob/keyable/verb/Ripple_Cutter()
	set category = "Skills"
	var/kireq=usr.Ephysoff*Hamon_release_efficiency*3
	if(!usr.med&&!usr.train&&!usr.KO&&usr.stamina>=kireq&&!usr.basicCD&&usr.canfight)
		var/reload=Eactspeed/5
		if(reload<3)reload=3
		usr.basicCD+=reload
		usr.hamon_skill_buffer += 1
		var/passbp = 0
		passbp=expressedBP
		usr.Blast_Gain()
		var/bcolor=usr.BLASTICON
		bcolor+=rgb(215,222,29)
		var/obj/attack/blast/A=new/obj/attack/blast
		emit_Sound('fire_kiblast.wav')
		A.loc=locate(usr.x,usr.y,usr.z)
		A.icon=bcolor
		A.icon_state=usr.BLASTSTATE
		A.avoidusr=1
		A.density=1
		A.basedamage=usr.hamon_skill
		A.homingchance=(min(usr.Ekiskill*usr.kicontrolskill*usr.homingskill/100,100))//until you learn homing, your shots won't home at all
		A.BP=passbp
		A.mods=usr.Ekioff*usr.Ekiskill*log(10,max(usr.kieffusionskill,2))*log(10,max(usr.blastskill,2)) + usr.hamon_skill
		A.murderToggle=usr.murderToggle
		A.proprietor=usr
		A.ownkey=usr.displaykey
		A.dir=usr.dir
		A.ogdir=usr.dir
		A.inaccuracy = 2
		spawn A.Burnout()
		walk(A,usr.dir)
		spawn A.BlastControl()
		if(usr.target&&usr.target!=usr)
			spawn A.blasthoming(usr.target)
		usr.icon_state="Blast"
		spawn(3) usr.icon_state=""
	else usr<<"You must be combat ready (not be stunned, be able to attack, and not have a cooldown happening (Basic CD = -[basicCD/10]- seconds)) and have at least [kireq] ki."

/datum/skill/Sendo_Wave_Kick
	skilltype = "Sprit Buff"
	name = "Sendo Wave Kick"
	desc = "This attack will target multiple enemies in a small radius. As always, it does a lot of damage to Werewolves and Vampires."
	can_forget = TRUE
	common_sense = TRUE
	teacher=TRUE
	skillcost=1
	maxlevel = 1
	tier = 4
	enabled = 1
	var/tmp/expbuffer = 0
	after_learn()
		savant<<"You feel your Hamon well up inside you! You've gained a new ability!"
		assignverb(/mob/keyable/verb/Sendo_Wave_Kick)
	before_forget()
		savant<<"Your Hamon vanishes, alongside a ability to release it."
		unassignverb(/mob/keyable/verb/Sendo_Wave_Kick)
	login(var/mob/logger)
		..()
		assignverb(/mob/keyable/verb/Sendo_Wave_Kick)

mob/keyable/verb/Sendo_Wave_Kick()
	set category = "Skills"
	var/kireq=usr.Ephysoff*Hamon_release_efficiency*4
	if(!usr.med&&!usr.train&&!usr.KO&&usr.stamina>=kireq&&!usr.basicCD&&usr.canfight)
		usr.basicCD+=15
		usr.hamon_skill_buffer += 1
		for(var/mob/M in view(1))
			if(get_dist(M.loc,usr.loc)<= 3)
				if(doAttack(M,usr.hamon_skill*3,FALSE,usr.hamon_skill,"SLAMS a Sendo infused kick into"))
					usr.stamina-=kireq

/datum/skill/Sendo_Overdrive
	skilltype = "Sprit Buff"
	name = "Sendo Overdrive"
	desc = "Release a shitton of Hamon energy into a enemy. This reduces you 'Hamon' buffer, which will reset any level progress."
	can_forget = TRUE
	common_sense = TRUE
	teacher=TRUE
	skillcost=1
	maxlevel = 1
	tier = 5
	enabled = 1
	var/tmp/expbuffer = 0
	after_learn()
		savant<<"You feel your Hamon well up inside you! You've gained a new ability!"
		assignverb(/mob/keyable/verb/Sendo_Overdrive)
	before_forget()
		savant<<"Your Hamon vanishes, alongside a ability to release it."
		unassignverb(/mob/keyable/verb/Sendo_Overdrive)
	login(var/mob/logger)
		..()
		assignverb(/mob/keyable/verb/Sendo_Overdrive)

mob/keyable/verb/Sendo_Overdrive()
	set category = "Skills"
	var/kireq=usr.Ephysoff*Hamon_release_efficiency*5
	if(!usr.med&&!usr.train&&!usr.KO&&usr.stamina>=kireq&&!usr.basicCD&&usr.canfight)
		usr.basicCD+=15
		if(MeleeAttack(hamon_skill*8 + (hamon_skill_buffer/50),FALSE,hamon_skill))
			usr.hamon_skill_buffer = 0
			usr.stamina-=kireq

/datum/skill/Sunlight_Yellow_Overdrive
	skilltype = "Sprit Buff"
	name = "Sunlight Yellow Overdrive"
	desc = "Like Sendo Overdrive, this will reset your level progress. But it will also decrease your Hamon skill by one level. Cannot be used if your Hamon skill is under 3. The advantage, is that this also hits about forty times."
	can_forget = TRUE
	common_sense = TRUE
	teacher=TRUE
	skillcost=1
	maxlevel = 1
	tier = 5
	enabled = 1
	var/tmp/expbuffer = 0
	after_learn()
		savant<<"You feel your Hamon well up inside you! You've gained a new ability!"
		assignverb(/mob/keyable/verb/Sunlight_Yellow_Overdrive)
	before_forget()
		savant<<"Your Hamon vanishes, alongside a ability to release it."
		unassignverb(/mob/keyable/verb/Sunlight_Yellow_Overdrive)
	login(var/mob/logger)
		..()
		assignverb(/mob/keyable/verb/Sunlight_Yellow_Overdrive)

mob/keyable/verb/Sunlight_Yellow_Overdrive()
	set category = "Skills"
	var/kireq=usr.Ephysoff*Hamon_release_efficiency*6
	if(!usr.med&&!usr.train&&!usr.KO&&usr.stamina>=kireq&&!usr.basicCD&&usr.canfight&&usr.hamon_skill >= 3)
		usr.basicCD+=15
		var/amount = min(40,usr.hamon_skill * 5)
		if(BarrageAttack(hamon_skill + (hamon_skill_buffer/70),FALSE,hamon_skill,"fires a hamon punch at",amount,2))
			usr.hamon_skill_buffer = 0
			usr.stamina-=kireq
		usr.hamon_skill -= 1

/datum/skill/Final_Ripple
	skilltype = "Sprit Buff"
	name = "Final Ripple"
	desc = "This will reduce your Hamon Level to 1, and also your skill buffer to 0. In addition, it will reduce your base Ki (can be retrained) and take a lot of stamina. In exchange, it can either give an ally a huge power boost, or can deliver a very lethal blow to an enemy. Can't be used below 5 Hamon Skill. Will cause a tiny loss in decline every use."
	can_forget = TRUE
	common_sense = TRUE
	teacher=TRUE
	skillcost=1
	maxlevel = 1
	tier = 6
	enabled = 1
	var/tmp/expbuffer = 0
	after_learn()
		savant<<"You feel your Hamon well up inside you! You've gained a new ability!"
		assignverb(/mob/keyable/verb/Final_Ripple)
	before_forget()
		savant<<"Your Hamon vanishes, alongside a ability to release it."
		unassignverb(/mob/keyable/verb/Final_Ripple)
	login(var/mob/logger)
		..()
		assignverb(/mob/keyable/verb/Final_Ripple)

mob/keyable/verb/Final_Ripple()
	set category = "Skills"
	if(usr.isfinaling)
		if(usr.hamon_skill>=5&&!usr.med&&!usr.train&&!usr.KO&&usr.stamina>=usr.maxstamina*0.7&&!usr.basicCD&&usr.canfight)
			usr.basicCD+=15
			if(usr.target)
				var/mob/M = usr.target
				if(M&&get_dist(usr.loc,M.loc)<=3)
					doAttack(M,usr.hamon_skill*10 + (hamon_skill_buffer/50),FALSE,usr.hamon_skill,"breathes the final ripple attack... <font color=purple>SUPER SENDO OVERDRIVE!!!!</font> This attack, as it's released, flies menacingly towards")
					usr.hamon_skill_buffer = 0
					usr.hamon_skill = 1
		else usr <<"Not enough stamina! [usr.maxstamina*0.7] stamina required!"
		usr.isfinaling = 0
	else
		if(usr.hamon_skill>=5&&!usr.med&&!usr.train&&!usr.KO&&usr.stamina>=usr.maxstamina*0.7&&!usr.basicCD&&usr.canfight)
			usr.basicCD+=15
			switch(input(usr,"Give or attack? You have to press this verb one more time to use attack. Make sure you target the enemy! Don't worry about range, it is 3 tiles. If you're giving, make sure you target an ally. Either way, no target will do nothing. As a reminder: This will reduce your Hamon Level to 1, and also your skill buffer to 0. In addition, it will reduce your base Ki (can be retrained) and take a lot of stamina. In exchange, it can either give an ally a huge power boost, or can deliver a very lethal blow to an enemy. Can't be used below 5 Hamon Skill. Will cause a tiny loss in decline every use.","Cancel") in list("Cancel","Give","Attack"))
				if("Cancel")
					return
				if("Give")
					if(usr.target)
						var/mob/M = usr.target
						if(M&&get_dist(usr.loc,M.loc)<=3)
							view(M)<<"[M] becomes empowered by [usr]'s hamon!!'"
							M.overcharge = 1
							M.Ki += usr.Ki * usr.hamon_skill
							M.SpreadHeal(40,1)
							usr.hamon_skill_buffer = 0
							usr.hamon_skill = 1
				if("Attack")
					usr.isfinaling = 1
		else usr <<"Not enough stamina! [usr.maxstamina*0.7] stamina required!"

mob/keyable/verb/Check_Hamon_Level()
	set category = "Learning"
	var/exptonexthamonlevel = 45 * usr.hamon_skill
	usr << "Total Hamon Level: [usr.hamon_skill]"
	usr << "<font color=yellow>EXP</font> to next Hamon Level: [usr.hamon_skill_buffer]/[exptonexthamonlevel / (1 + hamon_gain_boost)]"
	usr << "Your Hamon Gains boost (increases on level up permanently.) [hamon_gain_boost]."

/datum/skill/Teach_Ripple
	skilltype = "Sprit Buff"
	name = "Teach Ripple"
	desc = "Requires a Hamon Skill of 2 or more. This will reduce your Hamon Level by 1 and reduce your skill buffer to 0. In exchange, allow someone access to the Hamon Tree and give them one skill level in Hamon."
	can_forget = TRUE
	common_sense = TRUE
	teacher=TRUE
	skillcost=2
	maxlevel = 1
	tier = 6
	enabled = 1
	var/tmp/expbuffer = 0
	after_learn()
		savant<<"You feel your Hamon well up inside you! You've gained a new ability!"
		assignverb(/mob/keyable/verb/Teach_Ripple)
	before_forget()
		savant<<"Your Hamon vanishes, alongside a ability to release it."
		unassignverb(/mob/keyable/verb/Teach_Ripple)
	login(var/mob/logger)
		..()
		assignverb(/mob/keyable/verb/Teach_Ripple)

mob/keyable/verb/Teach_Ripple()
	set category = "Skills"
	var/kireq=usr.Ephysoff*Hamon_release_efficiency*20
	if(!usr.med&&!usr.train&&!usr.KO&&usr.stamina>=kireq&&!usr.basicCD&&usr.canfight&&usr.hamon_skill>2)
		usr.basicCD+=15
		usr.stamina -=kireq
		usr.hamon_skill_buffer = 0
		usr.hamon_skill--
		if(target in view(1))
			view(src)<<"[usr] strikes [target] in the middle of their chest!!"
			target.SpreadDamage(10,0)
			sleep(10)
			if(prob(50 * target.Ewillpower))
				view(src)<<"[target] manages to gain some Hamon!!!"
				target.getTree(/datum/skill/tree/Sendo_Hamon)
				target.hamon_skill++
				target.hamon_skill_buffer++
			else
				view(src)<<"[target] failes to manifest."