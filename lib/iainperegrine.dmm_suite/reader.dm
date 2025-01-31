

//-- Reader for loading DMM files at runtime -----------------------------------

dmm_suite

	/*-- read_map ------------------------------------
	Generates map instances based on provided DMM formatted text. If coordinates
	are provided, the map will start loading at those coordinates. Otherwise, any
	coordinates saved with the map will be used. Otherwise, coordinates will
	default to (1, 1, world.maxz+1)
	*/
	read_map(dmm_text as text, coordX as num, coordY as num, coordZ as num)
		set background = 1
		set waitfor = 0
		// Split Key/Model list into lines
		var key_len = length(
			copytext(
				dmm_text, 2, findtext(dmm_text, quote, 2, 0)
			)
		)
		var /list/grid_models[0]
		var startGridPos = findtext(dmm_text, "\n\n(1,1,") // Safe because \n not allowed in strings in dmm
		var linesText = copytext(dmm_text, 1, startGridPos)
		var /list/modelLines = text2list(linesText, "\n")
		for(var/modelLine in modelLines) // "aa" = (/path{key = value; key = value},/path,/path)\n
			var modelKey = copytext(modelLine, 2, findtext(modelLine, quote, 2, 0))
			var modelsStart = findtextEx(modelLine, "=")+3 // Skip key and first three characters: "aa" = (
			var modelContents = copytext(modelLine, modelsStart, length(modelLine)) // Skip last character: )
			grid_models[modelKey] = modelContents
			sleep(-1)
		// Retrieve Comments, Determine map position (if not specified)
		var commentModel = modelLines[1] // The comment key will always be first.
		var bracketPos = findtextEx(commentModel, "}")
		commentModel = copytext(commentModel, findtextEx(commentModel, "=")+3, bracketPos) // Skip opening bracket
		var commentPathText = "[/dmm_suite/comment]"
		if(copytext(commentModel, 1, length(commentPathText)+1) == commentPathText)
			var attributesText = copytext(commentModel, length(commentPathText)+2, -1) // Skip closing bracket
			var /list/paddedAttributes = text2list(attributesText, "; ") // "Key = Value"
			for(var/paddedAttribute in paddedAttributes)
				var equalPos = findtextEx(paddedAttribute, "=")
				var attributeKey = copytext(paddedAttribute, 1, equalPos-1)
				var attributeValue = copytext(paddedAttribute, equalPos+3, -1) // Skip quotes
				switch(attributeKey)
					if("coordinates")
						var /list/coords = text2list(attributeValue, ",")
						if(!coordX) coordX = text2num(coords[1])
						if(!coordY)	coordY = text2num(coords[2])
						if(!coordZ) coordZ = text2num(coords[3])
		if(!coordX) coordX = 1
		if(!coordY) coordY = 1
		if(!coordZ) coordZ = world.maxz+1
		// Store quoted portions of text in text_strings, and replaces them with an index to that list.
		var gridText = copytext(dmm_text, startGridPos)
		var /list/gridLevels = list()
		var /regex/grid = regex(@(##)\{"\n((?:\l*\n)*)"\}##, "g")
		while(grid.Find(gridText))
			gridLevels.Add(copytext(grid.group[1], 1, -1)) // Strip last \n
		// Create all Atoms at map location, from model key
		world.maxz = max(world.maxz, coordZ+gridLevels.len-1)
		for(var/posZ = 1 to gridLevels.len)
			var zGrid = gridLevels[posZ]
			// Reverse Y coordinate
			var /list/yReversed = text2list(zGrid, "\n")
			var /list/yLines = list()
			for(var/posY = yReversed.len to 1 step -1)
				yLines.Add(yReversed[posY])
			//
			var yMax = yLines.len+(coordY-1)
			if(world.maxy < yMax) world.maxy = yMax
			var exampleLine = pick(yLines)
			var xMax = length(exampleLine)+(coordX-1)
			if(world.maxx < xMax) world.maxx = xMax
			for(var/posY = 1 to yLines.len)
				var yLine = yLines[posY]
				for(var/posX = 1 to length(yLine)/key_len)
					var keyPos = ((posX-1)*key_len)+1
					var modelKey = copytext(yLine, keyPos, keyPos+key_len)
					parse_grid(
						grid_models[modelKey], posX+(coordX-1), posY+(coordY-1), posZ+(coordZ-1)
					)
				sleep(-1)
			sleep(-1)
		//
		return TRUE

	/*-- load_map ------------------------------------
	Deprecated. Use read_map instead.
	*/
	load_map(dmm_file as file, z_offset as num)
		if(!z_offset) z_offset = world.maxz+1
		var dmmText = file2text(dmm_file)
		return read_map(dmmText, 1, 1, z_offset)


//-- Supplemental Methods ------------------------------------------------------

	var
		quote = "\""

	proc
		parse_grid(models as text, xcrd, ycrd, zcrd)
			/* Method parse_grid() - Accepts a text string containing a comma separated list
				of type paths of the same construction as those contained in a .dmm file, and
				instantiates them.*/
			// Store quoted portions of text in text_strings, and replace them with an index to that list.
			var /list/originalStrings = list()
			var /regex/noStrings = regex(@(##)(["])(?:(?=(\\?))\2(.|\n))*?\1##)
			var stringIndex = 1
			var found
			do
				found = noStrings.Find(models, noStrings.next)
				if(found)
					var indexText = {""[stringIndex]""}
					stringIndex++
					var match = copytext(noStrings.match, 2, -1) // Strip quotes
					models = noStrings.Replace(models, indexText, found)
					originalStrings[indexText] = (match)
			while(found)
			// Identify each object's data, instantiate it, & reconstitues its fields.
			var /list/turfStackTypes = list()
			var /list/turfStackAttributes = list()
			for(var/atomModel in text2list(models, ","))
				var bracketPos = findtext(atomModel, "{")
				var atomPath = text2path(copytext(atomModel, 1, bracketPos))
				var /list/attributes
				if(bracketPos)
					attributes = new()
					var attributesText = copytext(atomModel, bracketPos+1, -1)
					var /list/paddedAttributes = text2list(attributesText, "; ") // "Key = Value"
					for(var/paddedAttribute in paddedAttributes)
						var equalPos = findtextEx(paddedAttribute, "=")
						var attributeKey = copytext(paddedAttribute, 1, equalPos-1)
						var attributeValue = copytext(paddedAttribute, equalPos+2)
						attributes[attributeKey] = attributeValue
				if(!ispath(atomPath, /turf))
					loadModel(atomPath, attributes, originalStrings, xcrd, ycrd, zcrd)
				else
					turfStackTypes.Insert(1, atomPath)
					turfStackAttributes.Insert(1, null)
					turfStackAttributes[1] = attributes
			// Layer all turf appearances into final turf
			if(!turfStackTypes.len) return
			var /turf/topTurf = loadModel(turfStackTypes[1], turfStackAttributes[1], originalStrings, xcrd, ycrd, zcrd)
			for(var/turfIndex = 2 to turfStackTypes.len)
				var /mutable_appearance/underlay = new(turfStackTypes[turfIndex])
				loadModel(underlay, turfStackAttributes[turfIndex], originalStrings, xcrd, ycrd, zcrd)
				topTurf.underlays.Add(underlay)

		loadModel(atomPath, list/attributes, list/strings, xcrd, ycrd, zcrd)
			// Cancel if atomPath is a placeholder (DMM_IGNORE flags used to write file)
			if(ispath(atomPath, /dmm_suite/clear_turf) || ispath(atomPath, /dmm_suite/clear_area))
				return
			// Parse all attributes and create preloader
			var /list/attributesMirror = list()
			var /turf/location = locate(xcrd, ycrd, zcrd)
			for(var/attributeName in attributes)
				attributesMirror[attributeName] = loadAttribute(attributes[attributeName], strings)
			var /dmm_suite/preloader/preloader = new(location, attributesMirror)
			// Begin Instanciation
			// Handle Areas (not created every time)
			var /atom/instance
			if(ispath(atomPath, /area))
				instance = locate(atomPath)
				instance.contents.Add(locate(xcrd, ycrd, zcrd))
				location.dmm_preloader = null
			// Handle Underlay Turfs
			else if(istype(atomPath, /mutable_appearance))
				instance = atomPath // Skip to preloader manual loading.
				preloader.load(instance)
			// Handle Turfs & Movable Atoms
			else// if(ispath(atomPath, /turf))
				instance = new atomPath(location)
			// Handle cases where Atom/New was redifined without calling Super()
			if(preloader && instance) // Atom could delete itself in New()
				preloader.load(instance)
			//
			return instance

		loadAttribute(value, list/strings)
			//Check for string
			if(copytext(value, 1, 2) == "\"")
				return strings[value]
			//Check for number
			var num = text2num(value)
			if(isnum(num))
				return num
			//Check for file
			else if(copytext(value,1,2) == "'")
				return file(copytext(value,2,length(value)))
			// Check for lists
				// To Do


//-- Preloading ----------------------------------------------------------------

turf
	var
		dmm_suite/preloader/dmm_preloader

atom/New(turf/newLoc)
    if(isturf(newLoc))
        var /dmm_suite/preloader/preloader = newLoc.dmm_preloader
        if(preloader)
            newLoc.dmm_preloader = null
            preloader.load(src)
    . = ..()

dmm_suite
	preloader
		parent_type = /datum
		var
			list/attributes
		New(turf/loadLocation, list/_attributes)
			loadLocation.dmm_preloader = src
			attributes = _attributes
			. = ..()
		proc
			load(atom/newAtom)
				var /list/attributesMirror = attributes // apparently this is faster
				for(var/attributeName in attributesMirror)
					newAtom.vars[attributeName] = attributesMirror[attributeName]
