datum/genetics/proc/build_stats() //time to take the original stats of the racial protos into us
	//general idea: take the number of the stat, divide the number by the race's inclusions, then add it to the master stat.
	//i.e. physoff = 0
	//saiyan physoff = 3 (50% saiyan 50% human)
	//resulting physoff from saiyan = 1.5
	//human physoff = 2 (50% human)
	//resulting physoff from human = 1
	//total physoff = 2.5
	
	//SHAPESHIFTER
	if(FLAG_SHAPESHIFTER == TRUE && FLAG_SHAPESHIFTER_TYPE != FALSE)
		for(var/a in m_stats)
			shapeshift_m[a] = m_stats[a]
		for(var/a in misc_stats)
			shapeshift_misc[a] = misc_stats[a]
		var/datum/genetics/ancestor = fetch_race_by_Name("[FLAG_SHAPESHIFTER_TYPE]")
		var/list/nM = ancestor.m_stats.Copy()
		var/list/nMc = ancestor.misc_stats.Copy()
		for(var/a in nM)
			if(!a in list("Energy Level","Battle Power","Skillpoint Mod","Lifespan","Regeneration","Potential","Zenkai","Tech Modifier"))
				m_stats[a] += nM[a]
		for(var/a in nMc)
			if(!a in list("Energy Level","Battle Power","Skillpoint Mod","Lifespan","Regeneration","Potential","Zenkai","Tech Modifier"))
				misc_stats[a] += nMc[a]
		reapply_stats(TRUE) 
		return
	//
	//EVERYONE ELSE 
	for(var/a in m_stats)
		m_stats[a] = 0
	for(var/a in misc_stats)
		misc_stats[a] = 0
	for(var/name in racial_protos)
		var/datum/genetics/ancestor = fetch_race_by_Name("[name]")
		var/list/nM = ancestor.m_stats.Copy()
		var/list/nMc = ancestor.misc_stats.Copy()
		if(this_class in ancestor.class_stats)
			var/list/L = class_stats[this_class].Copy()
			for(var/I=1,I <= L.len, I++)
				if(L[I] in nMc) //wish we could switch it but we can't. Conditionals can't be switch()'d. 
					nMc[nMc[I]] = L[L[I]] / (racial_protos[name]/100)
				if(L[I] in nM)
					nM[nM[I]] = L[L[I]] / (racial_protos[name]/100)
				if(L[I] == "Icon_Type")
					if(!L[L[I]] in alternate_icon_flags) alternate_icon_flags += L[L[I]]//this can get slow, luckily it should usually be a string or short list.

		for(var/a in nM)
			m_stats[a] += nM[a] / (racial_protos[name]/100)
		for(var/a in nMc)
			misc_stats[a] += nMc[a] / (racial_protos[name]/100)
		
		ancestor.special_info(src,racial_protos["[ancestor.name]"])
		if(ancestor.name = majority_genome)
			limb_list = ancestor.limb_list
			vital_list = ancestor.vital_list
			extra_limb_list = ancestor.extra_limb_list
	//done