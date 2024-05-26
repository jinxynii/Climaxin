/datum/skill/tree/LimitBreak
	name = "Limit Break"
	desc = "Manipulation of limits, breaking past previous barriers."
	maxtier = 6
	tier=2
	enabled = 0
	allowedtier = 1
	constituentskills = list(new/datum/skill/LimitBreak/GateOne,new/datum/skill/LimitBreak/Startling_Will,\
		new/datum/skill/LimitBreak/GateTwo,new/datum/skill/LimitBreak/GateThree,new/datum/skill/LimitBreak/GateFour,\
		new/datum/skill/LimitBreak/GateFive,new/datum/skill/LimitBreak/GateSix,new/datum/skill/LimitBreak/GateSeven,\
		new/datum/skill/LimitBreak/GateEight,new/datum/skill/Frontal_Lotus,new/datum/skill/Reverse_Lotus,new/datum/skill/Morning_Eagle,\
		new/datum/skill/Daytime_Tiger,new/datum/skill/Evening_Elephant,new/datum/skill/Dragon_Night)
	growbranches()
		if(invested)
			allowedtier = min(invested+1,6)
		if(savant.GateMastery>=1) enableskill(/datum/skill/LimitBreak/GateTwo)
		if(savant.GateMastery>=2) enableskill(/datum/skill/LimitBreak/GateThree)
		if(savant.GateMastery>=3) enableskill(/datum/skill/LimitBreak/GateFour)
		if(savant.GateMastery>=4) enableskill(/datum/skill/LimitBreak/GateFive)
		if(savant.GateMastery>=5) enableskill(/datum/skill/LimitBreak/GateSix)
		if(savant.GateMastery>=6) enableskill(/datum/skill/LimitBreak/GateSeven)
		if(savant.GateMastery>=7) enableskill(/datum/skill/LimitBreak/GateEight)
		..()
		return
	prunebranches()
		if(invested)
			allowedtier = min(invested+1,6)
		..()
		return

/datum/skill/LimitBreak/Startling_Will
	skilltype = "Sprit Buff"
	name = "Startling Will"
	desc = "Your willpower is strong enough to shake the world around you. This will supercharge your anger, and increase your BP mod by a little."
	can_forget = TRUE
	common_sense = TRUE
	skillcost=2
	maxlevel = 1
	tier = 1
	after_learn()
		savant<<"You feel greatly empowered."
		savant.genome.add_to_stat("Battle Power",0.5)
		savant.willpowerMod+=0.3
		savant.angerMod*=1.15
	before_forget()
		savant<<"Your spirit leaves your senses, lessening your strength."
		savant.genome.sub_to_stat("Battle Power",0.5)
		savant.willpowerMod-=0.3
		savant.angerMod/=1.15


/datum/skill/Frontal_Lotus
	skilltype = "Sprit Buff"
	name = "Frontal Lotus"
	desc = "Slam into your opponent with great speed. A faster version of the Lariat. Can only be used while in the Gates."
	can_forget = TRUE
	common_sense = TRUE
	teacher=TRUE
	skillcost=1
	prereqs = list(new/datum/skill/LimitBreak/GateOne)
	maxlevel = 1
	tier = 2
	enabled = 1
	var/tmp/expbuffer = 0
	after_learn()
		savant<<"Your gates begin to obtain more uses."
		assignverb(/mob/keyable/verb/Frontal_Lotus)
	before_forget()
		savant<<"The gates have lost a use..."
		unassignverb(/mob/keyable/verb/Frontal_Lotus)
	login(var/mob/logger)
		..()
		assignverb(/mob/keyable/verb/Frontal_Lotus)

mob/keyable/verb/Frontal_Lotus()
	set category = "Skills"
	var/kireq=usr.Ephysoff*GateMastery*1.1*BaseDrain
	if(!usr.med&&!usr.train&&!usr.KO&&usr.Ki>=kireq&&!usr.basicCD&&usr.canfight&&usr.target&&usr.GateAt>=1)
		usr.basicCD+=15
		emit_Sound('ARC_BTL_CMN_DrgnRush_Start.ogg')
		sleep LotusRush(target)
		if(get_dist(src,target)>1&&canmove)
			step(src,get_dir(src,target))
		if(get_dist(src,target)>1)
			src<<"Your rush failed..."
		else
			for(var/mob/M in view(3))
				M<<"[src] slams into [target]!"
			emit_Sound('ARC_BTL_CMN_DrgnRush_Fnsh.ogg')
			if(MeleeAttack(GateMastery*4,TRUE))
				usr.Ki-=kireq
	else usr << "Make sure you have [kireq] Ki, a target, in a Gate, and you aren't training or meditating!"

mob/proc/LotusRush(var/mob/M)
	RushComplete=0
	var/rushSpeed=round(0.2*move_delay,0.05)
	var/justincase=0
	while(get_dist(src,M)>1)
		justincase+=1
		if(!canmove)
			src<<"Your rush fails since you can't move!"
			RushComplete=1
			break
		step(src,get_dir(src,M))
		if(justincase==50)
			src<<"All this running is exhausting..."
			RushComplete=1
			break
		sleep(rushSpeed)
	RushComplete=1
	return

/datum/skill/Reverse_Lotus
	skilltype = "Sprit Buff"
	name = "Reverse Lotus"
	desc = "Slam into your opponent with great speed, and then just suplex them into the ground! A faster version of the Lariat. Can only be used while in the third Gate."
	can_forget = TRUE
	common_sense = TRUE
	teacher=TRUE
	skillcost=1
	prereqs = list(new/datum/skill/LimitBreak/GateThree)
	maxlevel = 1
	tier = 3
	enabled = 1
	var/tmp/expbuffer = 0
	after_learn()
		savant<<"Your gates begin to obtain more uses."
		assignverb(/mob/keyable/verb/Reverse_Lotus)
	before_forget()
		savant<<"The gates have lost a use..."
		unassignverb(/mob/keyable/verb/Reverse_Lotus)
	login(var/mob/logger)
		..()
		assignverb(/mob/keyable/verb/Reverse_Lotus)

mob/keyable/verb/Reverse_Lotus()
	set category = "Skills"
	var/kireq=usr.Ephysoff*GateMastery*1.9*BaseDrain
	if(!usr.med&&!usr.train&&!usr.KO&&usr.Ki>=kireq&&!usr.basicCD&&usr.canfight&&usr.target&&usr.GateAt>=3)
		usr.basicCD+=30
		emit_Sound('ARC_BTL_CMN_DrgnRush_Start.ogg')
		sleep LotusRush(target)
		if(get_dist(src,target)>1&&canmove)
			step(src,get_dir(src,target))
		if(get_dist(src,target)>1)
			src<<"Your rush failed..."
		else
			for(var/mob/M in view(3))
				M<<"[src] slams into [target]!"
				if(M.client)
					M << sound('ARC_BTL_CMN_DrgnRush_Fnsh.ogg')
			if(MeleeAttack(GateMastery*2,0,0,"slams into"))
				usr.Ki-=kireq
				sleep(10)
				for(var/mob/M in view(4))
					M<<"Then [src] leans back, and crashes [M] onto [M]'s head!!"
				emit_Sound('ARC_BTL_CMN_DrgnRush_Fnsh.ogg')
				MeleeAttack(GateMastery*7,TRUE,0,"SUPLEXS")
				target.stagger+=1
				spawn(10) target.stagger-=1
	else usr << "Make sure you have [kireq] Ki, a target, in the third Gate, and you aren't training or meditating!"

/datum/skill/Morning_Eagle
	skilltype = "Sprit Buff"
	name = "Morning Eagle"
	desc = "A rapidfire attack that fires blasts that scale based off of your physical attributes. If you use it up close on someone, it's pretty nasty. Only usable in gate five."
	can_forget = TRUE
	common_sense = TRUE
	teacher=TRUE
	skillcost=0
	prereqs = list(new/datum/skill/LimitBreak/GateFive)
	maxlevel = 1
	tier = 4
	enabled = 1
	var/tmp/expbuffer = 0
	after_learn()
		savant<<"Your gates begin to obtain more uses."
		assignverb(/mob/keyable/verb/Morning_Eagle)
	before_forget()
		savant<<"The gates have lost a use..."
		unassignverb(/mob/keyable/verb/Morning_Eagle)
	login(var/mob/logger)
		..()
		assignverb(/mob/keyable/verb/Morning_Eagle)

mob/keyable/verb/Morning_Eagle()
	set category = "Skills"
	var/amount=15+GateMastery
	var/kireq=amount*15*BaseDrain
	var/curdir=usr.dir
	var/reload
	if(!usr.med&&!usr.train&&!usr.KO&&usr.Ki>=kireq&&!barrageCD&&canfight&&usr.GateAt>=5)
		dirlock=1
		reload=Eactspeed*2
		if(reload<2)reload=2
		usr.barrageCD=reload
		usr.Ki-=kireq
		usr.Blast_Gain()
		usr.Blast_Gain()
		usr.Blast_Gain()
		blasting=1
		usr.icon_state="Blast"
		var/bicon='40.dmi'
		while(amount)
			if(MeleeAttack(GateMastery))
			else
				Fight()
				emit_Sound('mediumpunch.wav')
				var/obj/attack/blast/A=new/obj/attack/blast
				emit_Sound('KIBLAST.WAV')
				A.icon=bicon
				spawn A.Burnout()
				A.avoidusr=1
				A.basedamage=2*Ephysoff*globalmeleeattackdamage
				A.BP=expressedBP
				A.mods=usr.Ephysoff*usr.Etechnique*2
				//A.icon_state=usr.BLASTSTATE
				A.proprietor=usr
				A.ownkey=usr.displaykey
				A.loc=locate(usr.x,usr.y,usr.z)
				step(A,curdir)
				A.density=1
				A.dir=curdir
				A.ogdir=usr.dir
				A.murderToggle=usr.murderToggle
				step(A,curdir)
				walk(A,curdir)
			amount-=1
			sleep(2)
		dirlock=0
		spawn(3) usr.icon_state=""
		blasting=0
		sleep(reload)
		usr.barrageCD=0
	else if(usr.Ki<=kireq) usr<<"This requires atleast [kireq] energy to use."
	else if(barrageCD) usr<<"This skill was set on cooldown for [barrageCD/10] seconds."

/datum/skill/Daytime_Tiger
	skilltype = "Sprit Buff"
	name = "Daytime Tiger"
	desc = "You just punch, really really fast, once... but somehow it's a special attack! By punching extremely fast, create something akin to a visible Kiai that scales completely off of physical stats. Only usable in Gate Six and up."
	can_forget = TRUE
	common_sense = TRUE
	teacher=TRUE
	skillcost=0
	prereqs = list(new/datum/skill/LimitBreak/GateFive)
	maxlevel = 1
	tier = 4
	enabled = 1
	var/tmp/expbuffer = 0
	after_learn()
		savant<<"Your gates begin to obtain more uses."
		assignverb(/mob/keyable/verb/Daytime_Tiger)
	before_forget()
		savant<<"The gates have lost a use..."
		unassignverb(/mob/keyable/verb/Daytime_Tiger)
	login(var/mob/logger)
		..()
		assignverb(/mob/keyable/verb/Daytime_Tiger)

mob/keyable/verb/Daytime_Tiger()
	set category = "Skills"
	var/kireq=100*BaseDrain
	var/curdir=usr.dir
	if(!usr.med&&!usr.train&&!usr.KO&&usr.Ki>=kireq&&!kiaionCD&&canfight&&usr.GateAt>=6)
		if(MeleeAttack(GateMastery*9,TRUE))
			usr.Ki-=kireq
		else
			kiaionCD = 15
			var/icon/bicon='Aura Blast Size 1W.dmi'
			Fight()
			emit_Sound('mediumpunch.wav')
			var/obj/attack/blast/A=new/obj/attack/blast
			A.pixel_x = round(((32 - bicon.Width()) / 2),1)
			A.pixel_y = round(((32 - bicon.Height()) / 2),1)
			emit_Sound('KIBLAST.WAV')
			A.icon=bicon
			spawn A.Burnout()
			A.avoidusr=1
			A.basedamage=50*Ephysoff*globalmeleeattackdamage
			usr.Ki-=kireq
			A.BP=expressedBP
			A.mods=usr.Ephysoff*usr.Etechnique*2
			//A.icon_state=usr.BLASTSTATE
			A.proprietor=usr
			A.ownkey=usr.displaykey
			A.loc=locate(usr.x,usr.y,usr.z)
			step(A,curdir)
			A.density=1
			A.dir=curdir
			A.ogdir=usr.dir
			A.murderToggle=usr.murderToggle
			step(A,curdir)
			walk(A,curdir)
			emit_Sound('scouterexplode.ogg')
		kiaiing=1
		sleep(kiaionCD)
		kiaiing=0
		kiaionCD=0
	else
		usr<<"You can't use this now!"

/datum/skill/Evening_Elephant
	skilltype = "Sprit Buff"
	name = "Evening Elephant"
	desc = "This can only be used in Gate Eight. It's free for a reason. You can use this to temporarily stun a foe. Useful for setting up attacks."
	can_forget = TRUE
	common_sense = TRUE
	teacher=TRUE
	skillcost=0
	prereqs = list(new/datum/skill/LimitBreak/GateEight)
	maxlevel = 1
	tier = 5
	enabled = 1
	var/tmp/expbuffer = 0
	after_learn()
		savant<<"Your gates begin to obtain more uses."
		assignverb(/mob/keyable/verb/Evening_Elephant)
	before_forget()
		savant<<"The gates have lost a use..."
		unassignverb(/mob/keyable/verb/Evening_Elephant)
	login(var/mob/logger)
		..()
		assignverb(/mob/keyable/verb/Evening_Elephant)

mob/keyable/verb/Evening_Elephant()
	set category = "Skills"
	var/kireq=90*BaseDrain
	var/curdir=usr.dir
	if(!usr.med&&!usr.train&&!usr.KO&&usr.Ki>=kireq&&!kiaionCD&&canfight&&usr.GateAt==8)
		kiaionCD = 15
		var/icon/bicon='Beam1.dmi'
		Fight()
		emit_Sound('mediumpunch.wav')
		var/obj/attack/blast/A=new/obj/attack/blast
		A.pixel_x = round(((32 - bicon.Width()) / 2),1)
		A.pixel_y = round(((32 - bicon.Height()) / 2),1)
		emit_Sound('KIBLAST.WAV')
		A.icon=bicon
		A.icon_state = "head"
		spawn A.Burnout()
		A.avoidusr=1
		A.basedamage=35*Ephysoff*globalmeleeattackdamage
		usr.Ki-=kireq
		A.BP=expressedBP
		A.mods=usr.Ephysoff*usr.Etechnique*2
		//A.icon_state=usr.BLASTSTATE
		A.proprietor=usr
		A.ownkey=usr.displaykey
		A.loc=locate(usr.x,usr.y,usr.z)
		A.paralysis = 1
		step(A,curdir)
		A.density=1
		A.dir=curdir
		A.ogdir=usr.dir
		A.murderToggle=usr.murderToggle
		step(A,curdir)
		walk(A,curdir)
		emit_Sound('scouterexplode.ogg')
		kiaiing=1
		sleep(kiaionCD)
		kiaiing=0
		kiaionCD=0
	else
		usr<<"You can't use this now!"

/datum/skill/Dragon_Night
	skilltype = "Sprit Buff"
	name = "Dragon Night"
	desc = "This can only be used in Gate Eight. It's free for a reason. This does a fuckhuge amount of damage at the price of prematurely ending the eighth gate.."
	can_forget = TRUE
	common_sense = TRUE
	teacher=TRUE
	skillcost=0
	prereqs = list(new/datum/skill/LimitBreak/GateEight)
	maxlevel = 1
	tier = 5
	enabled = 1
	var/tmp/expbuffer = 0
	after_learn()
		savant<<"Your gates begin to obtain more uses."
		assignverb(/mob/keyable/verb/Dragon_Night)
	before_forget()
		savant<<"The gates have lost a use..."
		unassignverb(/mob/keyable/verb/Dragon_Night)
	login(var/mob/logger)
		..()
		assignverb(/mob/keyable/verb/Dragon_Night)

mob/keyable/verb/Dragon_Night()
	set category = "Skills"
	var/kireq=150*BaseDrain*usr.Ephysoff/GateMastery
	if(!usr.med&&!usr.train&&!usr.KO&&usr.Ki>=kireq&&!usr.basicCD&&usr.canfight&&usr.target&&usr.GateAt>=8)
		view(usr)<<"<font size=[TextSize+1]><SayColor]>[usr]: AMASS!!"
		var/dh = icon('dragonnight.dmi',"head")
		usr.overlayList += dh
		usr.overlaychanged= 1
		for(var/mob/K in view(3))
			K.Quake()
		emit_Sound('telekinesis_charge.wav')
		sleep(15)
		view(usr)<<"<font size=[TextSize+1]><SayColor]>[usr]: FLOW!!!"
		usr.basicCD+=15
		emit_Sound('ARC_BTL_CMN_DrgnRush_Start.ogg')
		usr.Ki-=kireq
		sleep DragonRush(target)
		if(get_dist(src,target)>1&&canmove)
			step(src,get_dir(src,target))
		if(get_dist(src,target)>1)
			src<<"Your rush failed..."
		else
			for(var/mob/M in view(3))
				M<<"[src] slams into [target]!"
			emit_Sound('explosion.wav')
			view(usr)<<"<font size=[TextSize+1]><SayColor]>[usr]: NIGHT DRAGON!!!!!"
			MeleeAttack(GateMastery*30,TRUE)
			usr.overlayList -= dh
			usr.overlaychanged= 1
			usr.stopbuff(/obj/buff/Eight_Gates)
	else usr << "Make sure you have [kireq] Ki, a target, in a Gate, and you aren't training or meditating!"

mob/proc/DragonRush(var/mob/M)
	RushComplete=0
	var/rushSpeed=round(0.2*move_delay,0.05)
	var/justincase=0
	while(get_dist(src,M)>1)
		justincase+=1
		if(!canmove)
			src<<"Your rush fails since you can't move!"
			RushComplete=1
			break
		var/icon/bicon = 'dragonnight.dmi'
		var/obj/attack/blast/A=new/obj/attack/blast
		A.icon=bicon
		A.icon_state = "tail"
		A.density=0
		A.loc=locate(usr.x,usr.y,usr.z)
		step(src,get_dir(src,M))
		spawn A.Burnout()
		A.avoidusr=1
		A.basedamage=40*Ephysoff*globalmeleeattackdamage
		A.BP=expressedBP
		A.mods=usr.Ephysoff*usr.Etechnique*2
		//A.icon_state=usr.BLASTSTATE
		A.proprietor=usr
		A.ownkey=usr.displaykey
		A.paralysis = 1
		A.density=1
		A.dir=curdir
		A.ogdir=usr.dir
		A.murderToggle=usr.murderToggle
		if(justincase==50)
			src<<"All this running is exhausting..."
			RushComplete=1
			break
		sleep(rushSpeed)
	RushComplete=1
	return
