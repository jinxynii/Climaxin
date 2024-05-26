//Mostly joke code. Can be disabled.
//However, this code IS, however, usable for other shit.

//Reality Stone: Infinite resources. Can change the icon of anything in the game.
//Mind Stone: Free Telepathy, flight, the ability to phase through walls.
//Space Stone: Free teleportation to ANY coordinate.
//Time Stone: Can age/deage anyone in view. Can change the time of the universe.
//Soul Stone: Can seal anyone, can resurrect dead people in view.
//Power Stone: Can multiply power to x10. When Planet Destroy is a thing, you can do that for free.

var/InfinityStonesToggle = 1

mob/Admin3/verb/Toggle_Infinity_Stones()
	set category = "Admin"
	if(InfinityStonesToggle)
		InfinityStonesToggle=0
		for(var/obj/Artifacts/Infinity_Stone/S in world)
			S.OnRelease()
			del(S)
		world << "Infinity Stones off."
	else
		InfinityStonesToggle=1
		world << "Infinity Stones on. (Admins need to manually add them.)"

mob/Admin3/verb/Create_Infinity_Stones()
	set category = "Admin"
	switch(alert(usr,"Spread them out?","","Yes","No","Cancel"))
		if("Yes")
			var/obj/Artifacts/Infinity_Stone/Reality_Stone/A = new
			var/obj/Artifacts/Infinity_Stone/Time_Stone/B = new
			var/obj/Artifacts/Infinity_Stone/Power_Stone/C = new
			var/obj/Artifacts/Infinity_Stone/Soul_Stone/D = new
			var/obj/Artifacts/Infinity_Stone/Mind_Stone/E = new
			var/obj/Artifacts/Infinity_Stone/Space_Stone/F = new
			A.Scatter()
			B.Scatter()
			C.Scatter()
			D.Scatter()
			E.Scatter()
			F.Scatter()
		if("No")
			new/obj/Artifacts/Infinity_Stone/Reality_Stone(loc)
			new/obj/Artifacts/Infinity_Stone/Time_Stone(loc)
			new/obj/Artifacts/Infinity_Stone/Power_Stone(loc)
			new/obj/Artifacts/Infinity_Stone/Soul_Stone(loc)
			new/obj/Artifacts/Infinity_Stone/Mind_Stone(loc)
			new/obj/Artifacts/Infinity_Stone/Space_Stone(loc)
mob/var
	CanHandleInfinityStones = 0
	//If you can't handle a infinity stone, you can only use it for ten seconds before dying. Playing hotpocket with infinity stones is not recommended.

obj/Artifacts/Infinity_Stone
	name = "Infinity Stone"
	desc = {"\n
	The Infinity Stones are legendary artifacts capable of granting immeasurable power to its wielder.\n
	Only six are known to exist, and it's dangerous to gather even just one, so they remain rare."}
	icon = 'InfinityStones.dmi'
	//icon_state = "Mind" "Space" "Time" "Power" "Soul" "Reality" for reference sake
	SaveItem = 1
	var/SafeToHold = 0 //Admins can edit a Infinity stone to change this value for RP purposes.
	CantKeep=1
	ContentsDontSave=1
	var/tmp/obj/items/Infinity_Stone_Holder/Holder = null
	var/lastx
	var/lasty
	var/lastz

	New()
		..()
		if(!InfinityStonesToggle)
			if(container)
				OnRelease()
			sleep(2)
			del(src)
		for(var/obj/Artifacts/Infinity_Stone/A in world)
			if(A.type == type&&A!=src)
				del(src)

	ArtifactLoop()
		if(!InfinityStonesToggle)
			if(container)
				OnRelease()
			sleep(2)
			del(src)
		else
			if(container)
				loc = container
				if(!SafeToHold&&!container.CanHandleInfinityStones&&!Holder)
					container.SpreadDamage(0.8)
					if(container.HP<=0)
						if(!container.KO) container.KO()
						OnRelease()
			if(isnull(loc)||isnull(x)||isnull(y)||isnull(z))
				if(!container)
					if(isnull(lastx)||isnull(lasty)||isnull(lastz)) Scatter()
					else Move(locate(lastx,lasty,lastz))
	logout()
		..()
		if(isnull(lastx)||isnull(lasty)||isnull(lastz)) Scatter()
		else
			Move(locate(lastx,lasty,lastz))
	OnRelease()
		if(Holder)
			Holder = null
			Holder.StoneList -= src
		Holder=null
		..()
		lastx = x
		lasty = y
		lastz = z
	OnGrab()
		lastx = x
		lasty = y
		lastz = z
		..()
	proc/Scatter()
		set background = 1
		if(container)
			OnRelease()
		var/area/targetArea
		var/planetpick = pick("Earth","Vegeta","Arconia","Namek","Icer Planet")
		for(var/area/A in area_outside_list)
			CHECK_TICK
			if(A.Planet == planetpick&&A.PlayersCanSpawn==1)
				targetArea = A
		if(targetArea)
			var/turf/temploc = pickTurf(targetArea,2)
			src.Move(locate(temploc.x,temploc.y,temploc.z))
			lastx = x
			lasty = y
			lastz = z
		return


obj/Artifacts/Infinity_Stone/Reality_Stone
	name = "Reality Stone"
	desc = {"\n
	An infinity stone. Capable of creating infinite amounts of Zenni, and can change anything's icon remotely."}
	icon_state = "Reality"
	SaveItem = 1
	var/storedzenni

obj/Artifacts/Infinity_Stone/Time_Stone
	name = "Time Stone"
	desc = {"\n
	An infinity stone. Capable of age/deage -ing anyone in view. Can change the time of the universe."}
	icon_state = "Time"
	SaveItem = 1

obj/Artifacts/Infinity_Stone/Power_Stone
	name = "Power Stone"
	desc = {"\n
	An infinity stone. Capable of multiplying your power by 10, and destroying planets."}
	icon_state = "Power"
	SaveItem = 1
	var/tmp/powermult = 1

obj/Artifacts/Infinity_Stone/Soul_Stone
	name = "Soul Stone"
	desc = {"\n
	An infinity stone. Capable of sealing anyone, and can resurrect the dead if present."}
	icon_state = "Soul"
	SaveItem = 1

obj/Artifacts/Infinity_Stone/Mind_Stone
	name = "Mind Stone"
	desc = {"\n
	An infinity stone. Makes you able to fly (for free), use telepathy, and undense yourself (Others can walk through you. Can't go through walls.)"}
	icon_state = "Mind"
	SaveItem = 1
	var/UnDensing

obj/Artifacts/Infinity_Stone/Space_Stone
	name = "Space Stone"
	desc = {"\n
	An infinity stone. Create temporary portals from any location to another. Recharges items as well."}
	icon_state = "Space"
	SaveItem = 1


obj/Artifacts/Infinity_Stone/Reality_Stone
	verb
		Reality_Create_Zenni()
			set category = "Skills"
			storedzenni = input(usr,"Create how much zenni?","",100) as num
		Reality_Change_A_Icon(var/atom/A in view())
			set category = "Other"
			A.icon = input(usr,"Select an icon.") as icon
		Reality_Withdraw_Zenni()
			set category = "Skills"
			usr.zenni += min((input(usr,"Withdraw how much zenni?","",storedzenni) as num),storedzenni)
		Reality_Invisible()
			set category = "Skills"
			if(usr.invisibility) usr.invisibility = 2
			else usr.invisibility = 0

obj/Artifacts/Infinity_Stone/Time_Stone
	OnGrab()
		usr.CanViewFrozenTime = 1
		..()

	OnRelease()
		usr.CanViewFrozenTime = 0
		..()

	verb
		Time_Change_Age()
			set category = "Skills"
			switch(alert(usr,"Global time or somebody's own time?","","Global","Local","Cancel"))
				if("Global")
					edittimeagain
					world << "[usr], using the Time Stone, is changing the time!"
					switch(input(usr,"Which parameter?","","Hours") in list("Hours","Days","Month","Year","End/Cancel"))
						if("Hours")
							Hours=round(max(min((input(usr,"Select the hour. (1-24)","",Hours) as num),1),24),1)
						if("Days")
							Days=round(max(min((input(usr,"Select the day. (1-28)","",Days) as num),1),28),1)
						if("Month")
							Month=round(max(min((input(usr,"Select the Month. (1-10)","",Month) as num),1),10),1)
						if("Year")
							Year=round(max((input(usr,"Select the Year. (1-???)","",Year) as num),1),1)
						if("End/Cancel")
							goto edittimeend
					goto edittimeagain
					edittimeend
					Calculate_Day()
					Years()
					world<<"It is now [listedDay], [listedMonth] the [Days][listedDaysuffix]"
				if("Local")
					var/list/victimlist = list()
					for(var/mob/M in view())
						victimlist+=M
					var/mob/choice = input(usr,"Select mob to age/deage.","",null) as null|anything in victimlist
					if(!isnull(choice))
						choice.Age = max(input(usr,"Select age.","",choice.Age) as num,1)
						view(choice) << "[choice]'s age rapidly changes to [choice.Age]!"
						choice.AgeCheck()
		Time_Stop()
			set category = "Skills"
			var/durationTime = round(max(min(input(usr,"How long, in seconds? (Maximum is 30 seconds.)") as num,30),1))
			if(TimeStopDuration&&TimeStopped)
				view(usr)<<"<font size=(usr.TextSize+3)><font color=red> says, '[name]: ZA WARUDO!!'"
				TimeStopDuration += durationTime
				if(TimeStopperBP<=usr.expressedBP)
					TimeStopperBP = usr.expressedBP
				usr.CanMoveInFrozenTime = 1
				usr.TrackTimeStop(durationTime)
			else
				var/previousHP = usr.HP
				view(usr)<<"<font size=(usr.TextSize+3)><font color=red> says, '[usr.name]: ZA...'"
				view(usr)<<"<font size=3><font color=red><font face=Old English Text MT>-[usr.name] is stopping time!"
				sleep(30)
				if(!usr.KO&&previousHP<=usr.HP)
					view(usr)<<"<font size=(usr.TextSize+4)><font color=red> says, '[usr.name]: WARUDO!!'"
					usr.emit_Sound('timestop.wav')
					TimeStopped = 1
					usr.TimeStopSkill = min(usr.TimeStopSkill*1.1,30*usr.magiBuff*usr.kiskillBuff)
					TimeStopDuration += durationTime
					TimeStopperBP = usr.expressedBP
					usr.CanMoveInFrozenTime = 1
					usr.sight &= ~BLIND    // turn off the blind bit
					usr.TrackTimeStop(durationTime)

obj/Artifacts/Infinity_Stone/Power_Stone
	verb
		Power_Change_Multiplier()
			set category = "Skills"
			var/tempmult = min(max(input(usr,"Select the power multiplier.","",10) as num,1),10)
			if(tempmult == 1&&usr.ArtifactsBuff!=1&&powermult!=1)
				usr.ArtifactsBuff = 1
				powermult = 1
			if(powermult>1&&usr.ArtifactsBuff>1)
				usr.ArtifactsBuff /= powermult
				usr.ArtifactsBuff = max(usr.ArtifactsBuff,1)
				powermult = 1
			if(container)
				if(usr.ArtifactsBuff!=1&&powermult==1)
					usr<<"Power Stone: ERROR CANNOT STACK ANY FURTHER! (You already have a artifact buffing you.)"
					return
				usr.ArtifactsBuff *= tempmult
				powermult = tempmult
		//todo:planetbusting
		Power_Planet_Destroy()
			set name = "Power Planet Destroy"
			set category="Skills"
			set waitfor =0
			set background = 1
			var/obj/Planets/currentP
			for(var/obj/Planets/P in planet_list)
				if(P.planetType==usr.Planet)
					currentP = P.planetType
					if(!P.destroyAble||usr.Planet=="Space"||!canplanetdestroy)
						usr << "You can't use Planet Destroy here."
						return
					break
			if(!currentP)
				usr << "You can't use Planet Destroy here."
				return
			switch(input("Destroy this Planet?","",text) in list("No","Yes"))
				if("Yes")
					//var/zz=usr.z
					var/mexpressedBP = usr.expressedBP * 10
					for(var/obj/Planets/P in planet_list)
						if(P.planetType==currentP)
							P.isBeingDestroyed = 1
							break
					view(usr)<<"<font color=yellow>*[usr] begins focusing their energy on destroying the planet!*"
					WriteToLog("rplog","[usr] blew up [currentP] with planet destroy!!!   ([time2text(world.realtime,"Day DD hh:mm")])")
					usr.emit_Sound('deathball_charge.wav')
					var/obj/attack/blast/A=new/obj/attack/blast
					A.icon='15.dmi'
					A.icon_state="15"
					A.density=1
					A.loc=locate(usr.x,usr.y+1,usr.z)
					sleep(100)
					flick('Zanzoken.dmi',usr)
					if(A)
						A.icon='16.dmi'
						A.icon_state="16"
						sleep(10)
						walk(A,SOUTH,3)
						spawn(30) if(A)
							var/obj/B=new/obj
							B.icon='Giant Hole.dmi'
							B.loc=A.loc
							del(A)
					var/area/currentarea=GetArea()
					currentarea.DestroyPlanet(mexpressedBP)
	OnRelease()
		if(powermult>1)
			usr.ArtifactsBuff = 1
			powermult = 1
		..()

obj/Artifacts/Infinity_Stone/Soul_Stone
	verb
		Soul_Revive(var/mob/M)
			set category = "Skills"
			WriteToLog("admin","[usr]([usr.key]) revived [M.name]([M.key]) at [time2text(world.realtime,"Day DD hh:mm")]")
			M.ReviveMe()
			M.KO=0
			M.SpreadHeal(100,1,1)
			M.Ki=M.MaxKi
			M.stamina=M.maxstamina
			M.move=1
			M.icon_state=""
			M.overlayList-='Halo.dmi'
			M.overlaychanged=1
		Soul_Seal(var/mob/M in view())
			set category = "Skills"
			var/maxiseal = max(M.BP,M.expressedBP,1)
			M.SealMob(maxiseal*10,0.9)
		Soul_Unseal(var/mob/M in view())
			set category = "Skills"
			if(M.isSealed) M.UnSealMob()
mob/var/tmp
	freeflight =0

obj/Artifacts/Infinity_Stone/Mind_Stone
	var/isUndensed
	verb
		Mind_Phase()
			set category = "Skills"
			for(var/turf/T in get_step(usr,usr.dir))
				usr << "You attempt to phase through whatevers in front of you."
				if(T.x && T.y && T.z)
					loc = locate(T.x,T.y,T.z)
		Mind_Undense()
			set category = "Skills"
			if(usr.density)
				usr.density=0
				usr.grabMode=99
				usr.attackable = 0
				isUndensed = 1
				usr << "You can pass through objects, and cannot touch objects or attack objects. (Nor can you be attacked.)"
			else
				usr.density=1
				usr.grabMode = 0
				usr.attackable = 1
				isUndensed = 0
				usr << "You're no longer able to pass through objects."
		Mind_Fly(var/atom/A in view())
			set category = "Skills"
			if(usr.flight)
				usr.flight=0
				usr.freeflight=0
				if(usr.Savable) usr.icon_state=""
				usr<<"You land back on the ground."
				usr.isflying=0
				usr.emit_Sound('buku_land.wav')
				usr.overlayList-=usr.FLIGHTAURA
				usr.overlaychanged=1
			else
				usr.Deoccupy()
				if(usr.flightspeed) usr.overlayList+=usr.FLIGHTAURA
				usr.overlaychanged=1
				usr.flight=1
				usr.freeflight=1
				usr.swim=0
				usr.isflying=1
				usr<<"You start to hover."
				usr.emit_Sound('buku.wav')
				if(usr.Savable) usr.icon_state="Flight"
		Mind_Telepathy(var/mob/M,var/msg as text)
			set category = "Skills"
			usr<<output("<font size=[usr.TextSize]><[usr.SayColor]>*[usr.name] telepathically says: [html_encode(msg)]","Chatpane.Chat")
			M<<output("<font size=[M.TextSize]><[usr.SayColor]>*[usr.name] telepathically says: [html_encode(msg)]","Chatpane.Chat")
	OnRelease()
		if(!container.density || isUndensed)
			isUndensed = 0
			container.density=1
			container.attacking = 0
			container.attackable = 1
		..()

obj/Artifacts/Infinity_Stone/Space_Stone
	verb
		Space_Create_Portal()
			set category = "Skills"
			var/list/oldloc = list(rand(usr.x+1,usr.x-1),rand(usr.y+1,usr.y-1),usr.z)
			var/list/newloc = list(0,0,0)
			newloc[1] = round(input(usr,"Input the X coordinate.") as num,1)
			newloc[2] = round(input(usr,"Input the Y coordinate.") as num,1)
			newloc[3] = round(input(usr,"Input the Z coordinate.") as num,1)
			var/obj/Space_Stone_Portal/A = new
			A.othercoords = newloc
			A.loc = locate(oldloc[1],oldloc[2],oldloc[3])
			var/obj/Space_Stone_Portal/B = new
			B.othercoords = oldloc
			B.loc = locate(newloc[1],newloc[2],newloc[3])
	ArtifactLoop()
		..()
		spawn
			for(var/obj/Modules/A in container)
				if(A.elec_energy<A.elec_energy_max)
					A.elec_energy+=(A.elec_energy_max - A.elec_energy)*0.1

obj/Space_Stone_Portal
	icon = 'LightPortal.dmi'
	var/list/othercoords = list(0,0,0)
	pixel_x = -34
	pixel_y = -34
	canGrab=0
	density = 0
	var/lifespan = 30
	New()
		..()
		spawn Ticker()
	proc/Ticker()
		set background = 1
		lifespan -= 1
		if(lifespan<=0)
			del(src)
		for(var/mob/M in view(0,locate(src.x,src.y,src.z)))
			if(othercoords.len==3)
			else
				sleep(10)
				spawn Ticker()
				return
			var/theloc = locate(othercoords[1],othercoords[2],othercoords[3])
			var/list/possibleplaces = list()
			for(var/turf/A in oview(1,theloc))
				possibleplaces+=A
			rechoose
			var/turf/choice = pick(possibleplaces)
			if(isturf(choice))
				M.loc = locate(choice.x,choice.y,choice.z)
			else goto rechoose
		sleep(10)
		spawn Ticker()
		return

obj/Creatables
	Infinity_Stone_Holder
		icon = 'InfinityStoneHolder.dmi'
		cost=100000
		neededtech=50
		desc = "Lets anyone hold a infinity stone... Useless if they're not enabled."
		create_type = /obj/items/Infinity_Stone_Holder
		New()
			..()
			if(!InfinityStonesToggle)
				del(src)

obj/items/Infinity_Stone_Holder
	icon = 'InfinityStoneHolder.dmi'
	desc = "This item holds Infinity Stones... Useless if they're not enabled."
	SaveItem = 1
	var/tmp/list/StoneList = list()

	New()
		..()
		spawn Ticker()

	proc/Ticker()
		set background = 1
		if(ismob(loc))
			for(var/obj/Artifacts/Infinity_Stone/A in StoneList)
				A.Move(loc)
		if(isturf(loc))
			for(var/obj/Artifacts/Infinity_Stone/A in StoneList)
				A.Move(src)
		sleep(10)
		spawn Ticker()
	verb/Snap()
		set category = "Skills"
		view(usr)<<"<font size=3><font color=red>[usr] begins to snap [usr]'s fingers!"
		if(StoneList.len != 6)
			sleep(25)
			view(usr)<<"<font size=3><font color=red>[usr]'s snap echoes hollow."
			return
		switch(input(usr,"Revive or Kill?") in list("Revive","Kill","Destroy The Stones",/*"Change A Universal Constant",<- eventually allow stone wielders to change admin variables. Togglable by admins.*/"Cancel"))
			if("Revive")
				sleep(25)
				view(usr)<<"<font size=3><font color=green>[usr] snaps [usr]'s fingers!"
				world << "<font size=3 color=green>COSMIC ENERGY BLASTS THROUGH THE UNIVERSE, ALL AT ONCE.</font>"
				var/totalmobs
				var/list/moblist = list()
				for(var/mob/A)
					if(A.dead == 1)
						totalmobs+=1
						moblist+=A
						continue
					else continue
				switch(alert(usr,"There are [totalmobs] mobs in the universe.","","Revive All","Cancel"))
					if("Cancel")
						return
				WriteToLog("admin","[usr]([usr.key]) revived everyone VIA Gauntlet Revive at [time2text(world.realtime,"Day DD hh:mm")]")
				world << "<font size=3><[usr.OOCColor]> [usr] snaps [usr]'s fingers..."
				spawn while(totalmobs)
					var/mob/chosensacrifice = pick(moblist)
					totalmobs-=1
					moblist -= chosensacrifice
					chosensacrifice.ReviveMe()
					chosensacrifice.KO=0
					chosensacrifice.Locate()
					chosensacrifice.SpreadHeal(100,1,1)
					chosensacrifice.Ki=chosensacrifice.MaxKi
					chosensacrifice.stamina=chosensacrifice.maxstamina
					chosensacrifice.move=1
					chosensacrifice.icon_state=""
					chosensacrifice.overlayList-='Halo.dmi'
					chosensacrifice.overlaychanged=1
			if("Kill")
				sleep(25)
				view(usr)<<"<font size=3><font color=red>[usr] snaps [usr]'s fingers!"
				world << "<font size=3 color=red>COSMIC ENERGY BLASTS THROUGH THE UNIVERSE, ALL AT ONCE.</font>"
				var/totalmobs
				var/list/moblist = list()
				for(var/mob/A)
					if(A.dead == 0&&A!=usr)
						totalmobs+=1
						moblist+=A
						continue
					else continue
				switch(alert(usr,"There are [totalmobs] mobs in the universe.","","Destroy Half","Destroy All","Cancel"))
					if("Destroy Half")
						totalmobs=round(totalmobs/2,1)
					if("Cancel")
						return
				WriteToLog("admin","[usr]([usr.key]) snapped, killing [totalmobs] at [time2text(world.realtime,"Day DD hh:mm")]")
				world << "<font size=3><[usr.OOCColor]> [usr] snaps [usr]'s fingers..."
				spawn while(totalmobs)
					var/mob/chosensacrifice = pick(moblist)
					totalmobs-=1
					moblist -= chosensacrifice
					chosensacrifice.buudead = "force"
					spawn chosensacrifice.Death()
			if("Destroy The Stones")
				sleep(25)
				view(usr)<<"<font size=3><font color=yellow>[usr] snaps [usr]'s fingers!"
				world << "<font size=3 color=yellow>COSMIC ENERGY BLASTS THROUGH THE UNIVERSE, ALL AT ONCE.</font>"
				for(var/obj/A in StoneList)
					StoneList -= A
					del(A)
				sleep(10)
				view(usr)<<"<font size=3><font color=red>[usr]'s body becomes wracked with cosmic energy blowback!"
				usr.SpreadDamage(70,1)
	verb/Stones()
		set category=null
		set src in usr
		switch(alert(usr,"Add or remove stones?","","Add stone.","Remove stone.","Cancel"))
			if("Add stone.")
				var/list/stoneaddlist = list()
				for(var/obj/Artifacts/Infinity_Stone/A in view(1))
					stoneaddlist+=A
				for(var/obj/Artifacts/Infinity_Stone/A in usr.contents)
					stoneaddlist+=A
				var/obj/Artifacts/Infinity_Stone/choice = input(usr,"Which stone?","",null) as null|anything in stoneaddlist
				if(!isnull(choice))
					choice.Holder = src
					StoneList += choice
			if("Remove stone.")
				var/list/stoneaddlist = list()
				for(var/obj/Artifacts/Infinity_Stone/A in StoneList)
					stoneaddlist+=A
				var/obj/Artifacts/Infinity_Stone/choice = input(usr,"Which stone?","",null) as null|anything in stoneaddlist
				if(!isnull(choice))
					choice.Holder = null
					StoneList -= choice
					choice.loc = locate(usr.x,usr.y,usr.z)
	verb/Customize()
		set category=null
		set src in usr
		switch(alert(usr,"Name or icon?","","Icon","Name","Cancel"))
			if("Name")
				name = input(usr,"Type a name,","",name) as text
			if("Icon")
				icon = input(usr,"Select a icon","Select a icon",icon) as icon
				if(alert(usr,"Make default instead?","","Yes","No")=="Yes")
					icon = 'InfinityStoneHolder.dmi'
	verb/Equip()
		set category=null
		set src in usr
		if(!equipped)
			equipped=1
			suffix="*Equipped*"
			usr.updateOverlay(/obj/overlay/clothes/InfinityHolder,icon)
			usr<<"You put on the [src]."
			for(var/obj/Artifacts/Infinity_Stone/A in StoneList)
				A.container = usr
				A.Move(usr)
		else
			equipped=0
			suffix=""
			usr.removeOverlay(/obj/overlay/clothes/InfinityHolder,icon)
			usr<<"You take off the [src]."
	Get()
		..()
		for(var/obj/Artifacts/Infinity_Stone/A in StoneList)
			A.container = usr
			A.Move(usr)
	Drop()
		..()
		for(var/obj/Artifacts/Infinity_Stone/A in StoneList)
			A.OnRelease()
			A.Move(src)
			A.Holder = src
			StoneList += A
obj/overlay/clothes/InfinityHolder
	ID = 331