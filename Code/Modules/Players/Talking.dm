mob/proc/sayType(var/msg,var/typeversion)
	if(Apeshit&&Apeshitskill<10&&typeversion!=1&&typeversion<=3)
		for(var/mob/M in oview())
			M.TestListeners("\icon[usr]<font size=[M.TextSize] color=green face=\"Old English Text MT\">-Apeshit yells, 'RAWR!'</font>","Chatpane.Chat")
		switch(typeversion)
			if(2)
				WriteToLog("rplog","(Whisper)[src]: [msg]   ([time2text(world.realtime,"Day DD hh:mm")])")
			if(3)
				WriteToLog("rplog","[src] says, '[msg]'   ([time2text(world.realtime,"Day DD hh:mm")])")
		return
	switch(typeversion)
		if(1)
			if(OOC)
				if(!Mutes.Find(key))
					for(var/mob/M in lobby_list)
						if(OOC_anon) M<<output("<font size=[M.TextSize]><[OOCColor]>([displaykey]): <font color=white>[html_encode(msg)]</font></font>","Chatpane.Chat")
						else M<<output("<font size=[M.TextSize]><[OOCColor]>[name]([displaykey]): <font color=white>[html_encode(msg)]</font></font>","Chatpane.Chat")
					for(var/mob/M in player_list)
						if(M.Ignore.Find(key)==0)
							if(M.OOCon||M.name==src.name)
								if(M.OOCchannel==OOCchannel)
									typing = 0
									if(OOC_anon) M<<output("<font size=[M.TextSize]><[OOCColor]>([displaykey]): <font color=white>[html_encode(msg)]</font></font>","Chatpane.Chat")
									else M<<output("<font size=[M.TextSize]><[OOCColor]>[name]([displaykey]): <font color=white>[html_encode(msg)]</font></font>","Chatpane.Chat")
			else src<<"OOC is disabled currently."
		if(2)
			var/introduceflag=rand(1,30)
			if(introduceflag==30)
				for(var/mob/M in view(7))if(!locate(M.name) in knowmob)knowmob+=M.name
			WriteToLog("rplog","(Whisper)[src]: [msg]   ([time2text(world.realtime,"Day DD hh:mm")])")
			if(is_silenced) msg = "mmph!"
			if(Fusee && !isnamekd)
				for(var/mob/M in range(Fusee)) M<<output("\icon[usr]<font size=[M.TextSize]>-[name] whispers something...</font>","Chatpane.Chat")
				for(var/mob/M in range(2,Fusee))
					M.TestListeners("\icon[usr]<font size=[M.TextSize]><[Fusee.SayColor]>*[Fusee.name] whispers: [html_encode(msg)]</font></font>")
			for(var/mob/M in range(src))
				M<<output("\icon[usr]<font size=[M.TextSize]>-[name] whispers something...","Chatpane.Chat")
			for(var/mob/M in range(2))
				M.TestListeners("\icon[usr]<font size=[M.TextSize]><[SayColor]>*[name] whispers: [html_encode(msg)]</font></font>","Chatpane.Chat")
			if(!is_silenced) power_Test(msg)
		if(3)
			var/introduceflag=rand(1,30)
			if(introduceflag==30)
				for(var/mob/M in view(7))if(!locate(M.name) in knowmob)knowmob+=M.name
			var/typsay = "says"
			var/rng = 0
			if(findtext(msg,"!"))
				typsay = "yells"
				rng = 15
			WriteToLog("rplog","[src] [typsay], '[msg]'   ([time2text(world.realtime,"Day DD hh:mm")])")
			if(is_silenced) msg = "mmph!"
			if(Fusee && !isnamekd)
				for(var/mob/M in view(screenx+rng,Fusee))
					M.TestListeners("\icon[usr]<font size=[M.TextSize]><[Fusee.SayColor]>[Fusee.name] [typsay], '[html_encode(msg)]'</font></font>")
			for(var/mob/M in view(screenx+rng,src))
				M.TestListeners("\icon[usr]<font size=[M.TextSize]><[SayColor]>[name] [typsay], '[html_encode(msg)]'</font></font>")
			if(!is_silenced) power_Test(msg)
		if(4)
			var/introduceflag=rand(1,30)
			if(introduceflag==30)
				for(var/mob/M in view(7))if(!locate(M.name) in knowmob)knowmob+=M.name
			WriteToLog("rplog","[src] thinks to themselves, '[msg]'    ([time2text(world.realtime,"Day DD hh:mm")])")
			if(Fusee && !isnamekd)
				for(var/mob/M in view(screenx,Fusee))
					M.TestListeners("\icon[usr]<font size=[M.TextSize]><[Fusee.SayColor]>[Fusee.name] thinks to themselves, '[html_encode(msg)]'</font></font>",1)
			for(var/mob/M in view(screenx,src))
				M.TestListeners("\icon[usr]<font size=[M.TextSize]><[SayColor]>[name] thinks to themselves, '[html_encode(msg)]'</font></font>",1)
		if(5)
			var/introduceflag=rand(1,30)
			if(introduceflag==30)
				for(var/mob/M in view(7))if(!locate(M.name) in knowmob)knowmob+=M.name
			WriteToLog("rplog","**[src] [msg]**   ([time2text(world.realtime,"Day DD hh:mm")])")
			if(Fusee && !isnamekd)
				for(var/mob/M in view(screenx,Fusee))
					M.TestListeners("<font size=[M.TextSize]><font color=yellow>*[Fusee.name] [html_encode(msg)]*</font></font>",1)
			for(var/mob/M in view(screenx,src))
				M.TestListeners("<font size=[M.TextSize]><font color=yellow>*[name] [html_encode(msg)]*</font></font>",1)
			for(var/mob/C in mob_list)
				if(C.Admin&&C.key!=src.key&&C.Spying)
					C<<output("<font size=[C.TextSize]><font color=yellow>(RP Spy)*[name] [html_encode(msg)]*(RP Spy)</font></font>","Chatpane.Chat")
		if(6)
			WriteToLog("rplog","[src]([src.key])(LOOC): [msg]   ([time2text(world.realtime,"Day DD hh:mm")])")
			if(Fusee && !isnamekd)
				for(var/mob/M in view(screenx,Fusee))
					M.TestListeners("<font size=3><[OOCColor]>[src]([src.key])(LOOC): [msg]</font></font>",1)
			for(var/mob/M in view(screenx,src))
				M.TestListeners("<font size=3><[OOCColor]>[src]([src.key])(LOOC): [msg]</font></font>",1)

mob/verb
	OOC(var/msg as text)
		set src = usr
		set category="Other"
		typewindow = 1
		typing = 0
		typewindow = 0
		msg=copytext(msg,1,1000)
		if(findtext(msg,"<font")==0|findtext(msg,"   ")==0)
			sayType(msg,1)
	OOC2()
		set hidden = 1
		set src = usr
		set category="Other"
		typewindow = 1
		var/msg = input("Say something.") as null|text
		typing = 0
		typewindow = 0
		if(isnull(msg)) return
		msg=copytext(msg,1,1000)
		if(findtext(msg,"<font")==0|findtext(msg,"   ")==0)
			sayType(msg,1)
	LOOC(var/msg as text)
		set src = usr
		set category="Other"
		typewindow = 1
		typing = 0
		typewindow = 0
		msg=copytext(msg,1,1000)
		if(findtext(msg,"<font")==0|findtext(msg,"   ")==0)
			sayType(msg,6)
	LOOC2()
		set hidden = 1
		set src = usr
		set category="Other"
		typewindow = 1
		var/msg = input("Say something.") as null|text
		typing = 0
		typewindow = 0
		if(isnull(msg)) return
		msg=copytext(msg,1,1000)
		if(findtext(msg,"<font")==0|findtext(msg,"   ")==0)
			sayType(msg,6)
	Whisper(var/msg as text)
		set src = usr
		set category="Other"
		sayType(msg,2)
	Whisper2()
		set hidden = 1
		set src = usr
		set category="Other"
		typewindow = 1
		var/msg = input("Say something.") as null|text
		typing = 0
		typewindow = 0
		if(isnull(msg)) return
		sayType(msg,2)
	Say(var/msg as text)
		set src = usr
		set category="Other"
		sayType(msg,3)
	Say2()
		set hidden = 1
		set src = usr
		set category="Other"
		typewindow = 1
		var/msg = input("Say something.") as null|text
		typing = 0
		typewindow = 0
		if(isnull(msg)) return
		sayType(msg,3)

	Think()
		set src = usr
		set category="Other"
		typewindow = 1
		var/msg = input("Say something.") as null|text
		typing = 0
		typewindow = 0
		if(isnull(msg)) return
		sayType(msg,4)

	Think2(var/msg as text)
		set src = usr
		set hidden = 1
		set category="Other"
		sayType(msg,4)

	Roleplay(var/msg as text)
		set src = usr
		set category="Other"
		sayType(msg,5)

	Roleplay2()
		set hidden = 1
		set src = usr
		set category="Other"
		typewindow = 1
		var/msg = input("Say something.") as null|message
		typing = 0
		typewindow = 0
		if(isnull(msg)) return
		sayType(msg,5)

mob/proc/TestListeners(var/MsgToOutput,type)
	//observers, etc.
	//for right now, it holds fusions.
	src<<output(MsgToOutput,"Chatpane.Chat")
	//usr = caller
	//src = listener
	if(prob(1) && usr != src)
		if(!src.isNPC && !usr.isNPC)
			add_familiarity(usr)
			usr.add_familiarity(src)
		else
			if(istype(src,/mob/npc/pet))
				var/mob/npc/pet/tP = src
				if(tP.target != usr)
					tP.relation["[usr.signature]"]++
	for(var/datum/Fusion/F)
		if(F.KeeperSig==signature)
			if(F.IsActiveForKeeper&&F.IsActiveForLoser)
				F.Loser << output(MsgToOutput)
	if(Fusee && isnamekd)
		for(var/datum/Fusion/F)
			if(F.LoserSig==signature)
				if(F.IsActiveForKeeper&&F.IsActiveForLoser)
					if(F.Keeper) F.Keeper << output(MsgToOutput)
	/*for(var/obj/Ritual/r in view(3))
		if(findtext(MsgToOutput,r.activator_word))
			r.activate_ritual(src)*/
	if(deepmeditation && type != 1)
		medruincount+=1
		if(medruincount>=10)
			medruincount=0
			src << "The sounds around you are disrupting your meditation."
			src << "You're pulled out of deep meditation."
			deepmeditation = 0


mob/proc/RandomizeText()
	OOCColor = name_string_to_color(pick(HTMLCOLORLIST))
	OOCColor="font color=[OOCColor]"
	SayColor = name_string_to_color(pick(HTMLCOLORLIST))
	SayColor="font color=[SayColor]"

mob
	verb
		OOC_Color()
			set category="Other"
			set hidden=1
			switch(alert(usr,"Custom color?","","Yes","No","Cancel"))
				if("Yes")
					OOCColor=input("Input an html color code") as text
					OOCColor=copytext(OOCColor,1,8)
				if("No") OOCColor = name_string_to_color(input("Choose Color", "", text) in HTMLCOLORLIST)
			OOCColor="font color=[OOCColor]"
		Say_Color()
			set category="Other"
			set hidden=1
			switch(alert(usr,"Custom color?","","Yes","No","Cancel"))
				if("Yes")
					SayColor=input("Input an html color code") as text
					SayColor=copytext(SayColor,1,8)
				if("No") SayColor = name_string_to_color(input("Choose Color", "", text) in HTMLCOLORLIST)
			SayColor="font color=[SayColor]"

var/list/HTMLCOLORLIST = list("Blue","Light Blue","Red","Crimson","Purple","Teal","Yellow","Green","Pink","Tan","Cyan","Moss","Namek Green","Piss Yellow","Skin Pale","Sweet Blue","Gray","Goblin-Slayer Iron")

proc/name_string_to_color(var/name)
	switch(name)
		if("Blue") return "blue"
		if("Light Blue") return "#00CCFF"
		if("Red") return "#FF3333"
		if("Crimson") return "#CC0000"
		if("Purple") return "Purple"
		if("Teal") return "teal"
		if("Yellow") return "yellow"
		if("Green") return "green"
		if("Pink") return "#FF69B4"
		if("Tan") return "#d47e53"
		if("Cyan") return "#00ffff"
		if("Moss") return "#5f8d5e"
		if("Namek Green") return "#0fac82"
		if("Piss Yellow") return "#d5de17"
		if("Skin Pale") return "#ffd39b"
		if("Sweet Blue") return "#304878"
		if("Goblin-Slayer Iron") return "#626262"
		if("Gray") return "gray"
mob/var
	OOCColor="font color=gray"
	SayColor="font color=green"

	is_silenced = 0