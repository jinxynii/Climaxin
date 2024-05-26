var/MEBPMult=7
var/MEBroken=0
var/AltarState

mob/var/tmp/restoring
obj/var/tmp/restored=0

obj/Artifacts/Master_Emerald
	name="Master Emerald"
	desc={"/n
	A massive and legendary gemstone filled with unbelievable power.\n
	Myths state that it can prevent potential worldwide calamities, grant a being a signifcant amount of power, and much more.\n
	Few people know of its existence, and even less have seen it."}
	icon = 'Green Emerald.dmi'
	//icon_state = "","Shrine","Shrine_NoME"
	SaveItem = 1
	var/tmp/powermult = 1
	verb
		Shatter()
			set src in oview(1)
			set category=null
			switch(alert(usr,"Shatter the Master Emerald?","","Yes","No"))
				if("Yes")
					view()<<"<font size=[4]><font color=red>[usr] destroys the Master Emerald, shattering it into pieces!</font>"
					emit_Sound('MasterEmeraldBreak.wav')
					var/NeededShardCount=15
					while(NeededShardCount>=1)
						var/obj/Artifacts/Emerald_Shards/A = new()
						A.ShardNum = NeededShardCount
						NeededShardCount-=1
						A.loc = usr.loc
						A.Scatter()
					for(var/obj/Artifacts/Master_Emerald/M in oview(1))
						del(M)
					view()<<"The shards of the Emerald fly off into the distance..."
					return
		Power_Change_Multiplier()
			set category = "Skills"
			var/tempmult = min(max(input(usr,"Select the power multiplier.","",10) as num,1),3)
			if(tempmult == 1&&usr.ArtifactsBuff!=1&&powermult!=1)
				usr.ArtifactsBuff = 1
				powermult = 1
			if(powermult>1&&usr.ArtifactsBuff>1)
				usr.ArtifactsBuff /= powermult
				usr.ArtifactsBuff = max(usr.ArtifactsBuff,1)
				powermult = 1
			if(container)
				if(usr.ArtifactsBuff!=1&&powermult==1)
					usr<<"Master Emerald: ERROR CANNOT STACK ANY FURTHER! (You already have a artifact buffing you.)"
					return
				usr.ArtifactsBuff *= tempmult
				powermult = tempmult
	OnRelease()
		if(powermult>1)
			usr.ArtifactsBuff = 1
			powermult = 1
		..()

obj/Artifacts/Emerald_Shards
	SaveItem = 1
	name="Emerald Shard"
	desc="A small, emerald green shard. While meaningless to some, it is priceless to those who know it's origins..."
	icon='EmeraldShard.dmi'
	icon_state=""
	var/ShardNum = 1
	var/ShardID  = 1
	SaveItem=1
	verb
		RestoreEmerald()
			set category=null
			var/shardnum
			for(var/obj/Artifacts/Emerald_Shards/A in view(1))
				if(A.ShardID == ShardID)
					shardnum+=1
			if(shardnum==15&&!usr.restoring&&!restored)
				var/exists
				restored = 1
				for(var/obj/Artifacts/Master_Emerald/A in view(1))
					exists = 1
					break
				if(!exists)
					new/obj/Artifacts/Master_Emerald(locate(usr.x,usr.y,usr.z))
					view(7)<<output("<font size=[4]><font color=green><font face=Old English Text MT>[usr] assembles all the shards of the Master Emerald. [usr] uses their energy to merge the shards together! In a flash of light, they become one, and the Master Emerald is made whole once again!","Chatpane.Chat")
					emit_Sound('MasterEmeraldShine.wav')
					for(var/obj/Artifacts/Emerald_Shards/B in view(1))
						if(B!=src)
							del(B)
					del(src)
				usr.restoring = 1
				alert(usr, "Congratulations! You've restored the Master Emerald to its completed state! The question now is, what will you do with it..?","","Hmm...")
				usr.restoring = 0
	proc/Scatter()
		var/obj/B=new/obj/attack/blast
		B.loc=locate(x,y,z)
		B.icon='16.dmi'
		B.icon_state="16"
		B.icon+=rgb(0,255,0)
		B.density=0
		B.Pow=20
		B.BP=500000
		spawn()
			step(B,NORTH,1)
			step(B,NORTH,1)
			step(B,NORTH,1)
			step(B,NORTH,1)
			step(B,NORTH,1)
			step(B,NORTH,1)
			walk_rand(B)
			spawn(30) del(B)
		var/area/targetArea
		var/templanet = pick("Earth","Desert","Arconia","Vegeta","Hera","Arlia", "Icer Planet") //no ball 'planet' results in the balls being spread accross the entire gameworld
		for(var/area/A)
			if(A.Planet == templanet&&A.PlayersCanSpawn==1)
				targetArea = A
		if(targetArea)
			var/turf/temploc = pickTurf(targetArea,2)
			src.loc = (locate(temploc.x,temploc.y,temploc.z))
		return

obj/Altar
	name="Master Emerald Altar"
	icon='Green Emerald.dmi'
	icon_state="Shrine"
	density=1
	IsntAItem=1
	SaveItem=1
	canGrab=0
	Bolted=1
	New()
		..()
		for(var/obj/Altar/A in world)
			if(A.type == type&&A!=src)
				del(A)
		tickME()
	proc/tickME()
		if(!EmeraldInAltar)
			icon_state="Shrine NoME"
		if(EmeraldInAltar)
			icon_state="Shrine"
	verb
		Description()
			set src in oview(1)
			set category = null
			usr<<"The shrine created to hold the Master Emerald. A mysterious power echoes from it."
			if(EmeraldInAltar)
				usr<<"The Master Emerald is currently placed in the altar."
				tickME()
			if(!EmeraldInAltar)
				usr<<"The Master Emerald is missing from the altar."
				tickME()
		ReturnEmerald()
			set src in oview(1)
			set category = null
			if(EmeraldInAltar)
				usr<<"The Master Emerald is already in the altar. There's nothing that can be returned to it."
			if(!EmeraldInAltar)
				for(var/obj/Artifacts/Master_Emerald/D in usr.contents)
					if(D.type==/obj/Artifacts/Master_Emerald)
						switch(alert(usr, "Are you sure? You won't be able to reap the Emerald for your own gain anymore.","","Yes","No"))
							if("Yes")
								del(D)
								icon_state="Shrine"
								EmeraldInAltar=1
								usr<<"The Master Emerald is carefully placed back inside its altar. You feel a weight lifted off your shoulders."
								emit_Sound('MasterEmeraldShine.wav')
							else
								usr<<"You change your mind, you fickle thing."
					else
						usr<<"You lack the completed Master Emerald."
		TakeEmerald()
			set src in oview(1)
			set category = null
			if(EmeraldInAltar==1)
				switch(alert(usr, "Are you sure?","","Yes","No"))
					if("Yes")
						icon_state="Shrine NoME"
						EmeraldInAltar=0
						new/obj/Artifacts/Master_Emerald(locate(usr.x,usr.y,usr.z))
						view(usr) << "[usr] removes the Master Emerald from its holy altar."
			else
				usr<<"The altar is empty. There's nothing to take."

mob/Admin3/verb/Bring_Emerald_Shards()
	set category = "Admin"
	switch(alert(usr,"This will summon all currently existing Emerald Shards. Continue?","","Yes","No"))
		if("Yes")
			for(var/obj/Artifacts/Emerald_Shards/A)
				A.loc = locate(x,y,z)

mob/Admin3/verb/Delete_Emerald_Shards()
	set category = "Admin"
	switch(alert(usr,"This will DELETE all currently existing Emerald Shards. Continue?","","Yes","No"))
		if("Yes")
			for(var/obj/Artifacts/Emerald_Shards/A in world)
				A.OnRelease()
				del(A)
			world<< "Emerald Shards deleted."