Scriptname SLD_ME_SleepAnywhere extends activemagiceffect Hidden 


ImageSpaceModifier 	Property FadeOut 			Auto
ImageSpaceModifier 	Property BlackScreen 		Auto
ImageSpaceModifier 	Property FadeIn 			Auto

Message Property RestPrompt	Auto
Message Property SelfRestPrompt	Auto
Message	Property SleepPrompt	Auto

Furniture Property Bed Auto
ObjectReference Property BedRef Auto Hidden


Actor Target
bool returnToFirstPerson = false

Event OnEffectStart(Actor akTarget, Actor akCaster)
	; Debug.Notification("[SLD] Rest anywhere cast")
	int r

	Target = akTarget
	if(Target != Game.GetPlayer() || Target.GetCombatState() != 0)
		self.Dispel()
		return
	endif

	; 
	If (!StorageUtil.HasIntValue(akTarget, "_SD_iSleepType"))
		StorageUtil.SetIntValue(akTarget, "_SD_iSleepType",1)
	endif

	StorageUtil.SetIntValue(akTarget, "_SD_iSleepAnywhereON",1)

	int sleepType = StorageUtil.GetIntValue(akTarget, "_SD_iSleepType")

	if (StorageUtil.GetIntValue(Game.GetPlayer(), "_SD_iEnslaved") == 1)
		r = RestPrompt.Show()
		if(r == 1)
			self.Dispel()
			return
		elseif(akTarget.IsWeaponDrawn())
			akTarget.SheatheWeapon()
			Utility.Wait(2.0)
		endif
	else
		r = SelfRestPrompt.Show()
		if(r == 3)
			self.Dispel()
			return
		elseif(akTarget.IsWeaponDrawn())
			akTarget.SheatheWeapon()
			Utility.Wait(2.0)
		endif

		sleepType = r + 1
	EndIf

	; Debug.Notification("[SD] Sleep pose: " + StorageUtil.GetStringValue(Target, "_SD_sSleepPose"))

	returnToFirstPerson = (Game.GetCameraState() == 0)
	Game.ForceThirdPerson()
	Game.DisablePlayerControls(1, 1, 1, 0, 0, 0, 0, 0, 0)
	self.RegisterForKey(Input.GetMappedKey("Jump"))
	
	if(sleepType == 1) ; Kneeling
		Debug.MessageBox("You sit back on your knees and take a rest. \n [Press Jump to cancel]")
		self.GoToState("Kneeling")
	elseif(sleepType == 2) ; Sitting	
		Debug.MessageBox("You sit back for a while. \n [Press Jump to cancel]")
		self.GoToState("Sitting")
	elseif(sleepType == 3) ; Sleeping sideway
		Debug.MessageBox("You lie down on the ground and sleep for a while. \n [Press Jump to cancel]")
		self.GoToState("EnterSleepingSideway")
	elseif(sleepType == 4) ; Sleeping 
		Debug.MessageBox("Your owner lets you sleep on the ground. \n [Press Jump to cancel]")
		self.GoToState("EnterSleeping")
	endif
endEvent

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
	self.Dispel()
endEvent

Event OnKeyDown(Int KeyCode)
	; Debug.Notification("Pressed key in normal mode")
	self.Dispel()
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	Game.EnablePlayerControls(1, 1, 1, 0, 0, 0, 0, 0, 0)
	; Debug.Notification("[SLD] Rest anywhere stop")
	StorageUtil.SetIntValue(akTarget, "_SD_iSleepAnywhereON",0)

	self.GoToState("")	
endEvent
	
	
	
State EnterSleeping
	Event OnBeginState()
		If (StorageUtil.GetStringValue(Target, "_SD_sSleepPose") != "")
			Debug.SendAnimationEvent(Target, StorageUtil.GetStringValue(Target, "_SD_sSleepPose"))
		Else
			Debug.SendAnimationEvent(Target, "idleLayDownEnter")
		EndIf
		self.RegisterForSingleUpdate(4.0)
	endEvent
	
	Event OnUpdate()  ; what happens if dispelled in the middle of this sequence?
		int s = SleepPrompt.Show()
		if(s == 0) ; yes
			self.GoToState("Sleeping")
		else
			self.GoToState("ExitSleeping")
		endif
	endEvent
endState	
	
State Sleeping
	Event OnBeginState()
		StorageUtil.SetIntValue(none, "DN_ONOFF", 1)
		
		BedRef = Target.PlaceAtMe(Bed, 1)	
		BedRef.SetActorOwner(Game.GetPlayer().GetActorBase())
		FadeOut.Apply()
		Utility.Wait(2.5) ; since Fadeout lasts exactly 3.0s, we need to allow some script delay
		FadeOut.PopTo(BlackScreen)
		Debug.SendAnimationEvent(Target, "IdleForceDefaultState")		
		Utility.Wait(0.3)
		BedRef.Activate(Target, true) ; this spawns the sleep menu of the befref but it wouldn't work if called while the laying anim is playing.
		self.RegisterForSingleUpdate(0.1)
	endEvent

	Event OnUpdate()
		self.GoToState("ExitSleeping")
	endEvent
	
	Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
	endEvent	

	Event OnKeyDown(Int KeyCode)
		; Debug.Notification("Pressed key in sleep mode")
	EndEvent
	
	Event OnEndState()
		StorageUtil.SetIntValue(none, "DN_ONOFF", 0)

		Debug.SendAnimationEvent(Target, "idleLayDownEnterInstant")		
		Utility.Wait(0.5)			
		BlackScreen.PopTo(FadeIn)
		BedRef.Delete()		
	endEvent
endState

State ExitSleeping
	Event OnBeginState()
		self.RegisterForUpdate(0.5)
	endEvent

	Event OnUpdate()
		if(Target.GetCombatState() != 0)
			self.Dispel()
		endif
	endEvent

	Event OnEndState()
		Debug.SendAnimationEvent(Target, "idleChairExitStart")	
	endEvent
endState




State EnterSleepingSideway
	Event OnBeginState()
		If (StorageUtil.GetStringValue(Target, "_SD_sSleepPose") != "")
			Debug.SendAnimationEvent(Target, StorageUtil.GetStringValue(Target, "_SD_sSleepPose"))
		Else
			Debug.SendAnimationEvent(Target, "idleBedRollRightEnterStart")
		EndIf
		self.RegisterForSingleUpdate(6.0)
	endEvent
	
	Event OnUpdate()  ; what happens if dispelled in the middle of this sequence?
		int s = SleepPrompt.Show()
		if(s == 0) ; yes
			self.GoToState("SleepingSideway")
		else
			self.GoToState("ExitSleepingSideway")
		endif
	endEvent
endState	
	
State SleepingSideway
	Event OnBeginState()
		StorageUtil.SetIntValue(none, "DN_ONOFF", 1)

		BedRef = Target.PlaceAtMe(Bed, 1)	
		BedRef.SetActorOwner(Game.GetPlayer().GetActorBase())
		FadeOut.Apply()
		Utility.Wait(2.5) ; since Fadeout lasts exactly 3.0s, we need to allow some script delay
		FadeOut.PopTo(BlackScreen)
		Debug.SendAnimationEvent(Target, "IdleForceDefaultState")		
		Utility.Wait(0.3)
		BedRef.Activate(Target, true) ; this spawns the sleep menu of the befref but it wouldn't work if called while the laying anim is playing.
		self.RegisterForSingleUpdate(0.1)
	endEvent

	Event OnUpdate()
		self.GoToState("ExitSleepingSideway")
	endEvent
	
	Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
	endEvent	

	Event OnKeyDown(Int KeyCode)
		; Debug.Notification("Pressed key in sleep mode")
		self.Dispel()
	EndEvent
	
	Event OnEndState()
		StorageUtil.SetIntValue(none, "DN_ONOFF", 0)

		Debug.SendAnimationEvent(Target, "idleBedRollRightEnterInstant")		
		Utility.Wait(0.5)			
		BlackScreen.PopTo(FadeIn)
		BedRef.Delete()		
	endEvent
endState

State ExitSleepingSideway
	Event OnBeginState()
		self.RegisterForUpdate(0.5)
	endEvent

	Event OnUpdate()
		if(Target.GetCombatState() != 0)
			self.Dispel()
		endif
	endEvent

	Event OnEndState()
		Debug.SendAnimationEvent(Target, "idleBedExitStart")	
	endEvent
endState




State Sitting
	Event OnBeginState()
		If (StorageUtil.GetStringValue(Target, "_SD_sSleepPose") != "")
			Debug.SendAnimationEvent(Target, StorageUtil.GetStringValue(Target, "_SD_sSleepPose"))
		Else
			Debug.SendAnimationEvent(Target, "idleSitCrossLeggedEnter")
		EndIf
		self.RegisterForUpdate(0.5)
	endEvent

	Event OnUpdate()
		Target.RestoreActorValue("Stamina", 10)
		if(Target.GetCombatState() != 0)
			self.Dispel()
		endif
	endEvent
	
	Event OnEndState()
		Debug.SendAnimationEvent(Target, "idleChairExitStart")
	endEvent
endState	



State Kneeling
	Event OnBeginState()
		If (StorageUtil.GetStringValue(Target, "_SD_sSleepPose") != "")
			Debug.SendAnimationEvent(Target, StorageUtil.GetStringValue(Target, "_SD_sSleepPose"))
		Else
			Debug.SendAnimationEvent(Target, "idleGreyBeardMeditateEnter")
		EndIf
		self.RegisterForUpdate(0.5)
	endEvent
	
	Event OnUpdate()
		Target.RestoreActorValue("Magicka", 10)
		if(Target.GetCombatState() != 0)
			self.Dispel()
		endif
	endEvent
	
	Event OnEndState()
		Debug.SendAnimationEvent(Target, "idleChairExitStart")
	endEvent
endState