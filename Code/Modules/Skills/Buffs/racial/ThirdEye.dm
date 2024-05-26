mob/var
	geteye //when you actually get the ability
	tmp/thirdeyeing
	thirdeye
	eyeBuff = 1

mob/keyable/verb/Third_Eye()
	set category="Skills"
	if(!usr.thirdeyeing)
		usr.thirdeyeing=1
		if(isBuffed(/obj/buff/Third_Eye))
			stopbuff(/obj/buff/Third_Eye)
		else
			startbuff(/obj/buff/Third_Eye)
		sleep(10)
		usr.thirdeyeing=0
mob/var/third_eye_icon = 'Third Eye.dmi'
/obj/buff/Third_Eye
	name = "Third Eye"
	icon='Electric_Blue.dmi'
	slot=sBUFF
	var/storedpower
	Buff()
		..()
		container.see_invisible=1 //A permanent change.
		container.angerMod/=1.3
		container.eyeBuff=1.3
		container.overlayList+=container.third_eye_icon
		container.overlaychanged=1
		container<<"You concentrate on the power of your mind and unlock your third eye chakra, increasing your power ability significantly."
		container.thirdeye=1
	DeBuff()
		container.angerMod*=1.3
		container.eyeBuff=1
		container.overlayList-=container.third_eye_icon
		container.overlaychanged=1
		container<<"You repress the power of your third eye chakra."
		container.thirdeye=0
		..()