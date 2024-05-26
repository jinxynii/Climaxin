/datum/skill/style/DemonStyle
	skilltype = "Body Buff"
	name = "Demon Style"
	desc = "A savage but strangely elegant style that reeks of superiority."
	can_forget = TRUE
	common_sense = TRUE
	teacher=TRUE
	tier = 1
	skillcost=1
	enabled=0
//	var/datum/style/attachedstyle //as a reminder: include this if you're getting errors.

	after_learn()
		savant<<"You feel more complex in both body and movement."
		attachedstyle = new /datum/style/DemonStyle
		savant.styleList.Add(attachedstyle)
		savant.availableStyles += attachedstyle
		attachedstyle.savant = savant

	before_forget()
		savant<<"You feel like something neccessary was removed from your form."
		savant.styleList.Cut(attachedstyle)
		del(attachedstyle)


/datum/style/DemonStyle
	name="Demon Style"
	desc="A savage but strangely elegant style that reeks of superiority."
	//Default stats
	defaultphysoff = 4
	defaultphysdef = 3
	defaultechnique = 2
	defaultkioff = 1
	defaultkidef = 1
	defaultkiskill = 1
	defaultspeed = 1
	defaultkiregen=1
	defaultsstaminamod = 3
	//
	learncost = 4 //what you need to pay to actually USE the style, in the form of allocated points.
	allocatedpoints = 8 //total value of all points added up minus 9

	//now for the fun part: define some preset "actions" to help sell the style. Takes the form of "[Your Name][AttackFlavor][Enemy]" for all of them.
	//These texts are the same as the Kamestyle texts.
	attackTextlist = list("flat strikes","cyclone kicks","upward punches","drives the tunnel fist into","god-strikes","god-kicks","punches gracefully","curts into")
	dodgeTextlist = list("flips out of the way from","dodges to the left from","dodges to the right from","ducks down","dances around from")
	counterTextlist = list("narrowly misses the oncoming strike, before slamming an attack into","skirts the attack, cracking a fist into","takes the attack head on")