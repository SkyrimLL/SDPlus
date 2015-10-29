Scriptname _SDMES_bound extends activemagiceffect  
{ USED }
_SDQS_functions Property funct  Auto
_SDQS_fcts_constraints Property fctConstraints  Auto
_SDQS_fcts_slavery Property fctSlavery  Auto
_SDQS_fcts_outfit Property fctOutfit  Auto

ReferenceAlias Property _SDRAP_master  Auto  
GlobalVariable Property _SDGVP_demerits  Auto  
GlobalVariable Property _SDGVP_demerits_join  Auto  
GlobalVariable Property _SDGVP_ArmbinderKnee  Auto  

Keyword[] Property notKeywords  Auto  
Idle[] Property _SDIAP_bound  Auto  
Idle Property _SDIAP_reset  Auto  

Faction Property SexLabActiveFaction  Auto  
SexLabFramework property SexLab auto

Int sleepType
Actor kTarget
Actor kPlayer
ObjectReference kMaster

Int iTrust  
Int iDisposition 
Float fKneelingDistance 

Float fRFSU = 0.1
int throttle = 0 

Function PlayIdleWrapper(actor akActor, idle theIdle)
	If (!fctConstraints.libs.IsAnimating(akActor))
		akActor.PlayIdle(theIdle)
	EndIf
EndFunction


Event OnUpdate()
	If (!kMaster) || (!kTarget)
		Return
	EndIf

	; If (Utility.RandomInt( 0, 100 ) >= 99 )
	;	Debug.Notification( "Your collar weighs around your neck..." )
	; EndIf

	If (StorageUtil.GetIntValue(kPlayer, "_SD_iSleepAnywhereON") == 1)
		If (StorageUtil.HasIntValue(kPlayer, "_SD_iSleepType"))
			sleepType = StorageUtil.GetIntValue(kPlayer, "_SD_iSleepType")
		Else
			sleepType = 1
		EndIf

		; Debug.Notification("[_sdmes_bound.psc] Stance: " +  StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance"))
		; Debug.Notification("[_sdmes_bound.psc] Sleep type: " +  StorageUtil.GetIntValue(kPlayer, "_SD_iSleepType"))
		; Debug.Notification("[_sdmes_bound.psc] Sleep pose: " +  StorageUtil.GetStringValue(kPlayer, "_SD_sSleepPose"))

		If (StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance") == "Crawling")
			if(sleepType == 1) ; Kneeling
				; Debug.MessageBox("Your owner reluctantly allows you to kneel and take a rest.")
				StorageUtil.SetStringValue(kPlayer, "_SD_sSleepPose", "ZazAPC011") ; HandsBehindLieFaceDown

			elseif(sleepType == 2) ; Sitting	
				; Debug.MessageBox("Your owner accepts to let you sit for a while. ")
				StorageUtil.SetStringValue(kPlayer, "_SD_sSleepPose", "ZazAPC057") ;  		FrogTieFaceDownStruggle

			elseif(sleepType == 3) ; Sleeping sideway
				; Debug.MessageBox("You are allowed to lie down and sleep for a while. ")
				StorageUtil.SetStringValue(kPlayer, "_SD_sSleepPose", "ZazAPC012") ;  		HandsBehindLieSide

			elseif(sleepType == 4) ; Sleeping 
				; Debug.MessageBox("Your owner lets you sleep on the ground. ")
				StorageUtil.SetStringValue(kPlayer, "_SD_sSleepPose", "ZazAPC014") ;  		HandsBehindLieSideCurlUp

			endif
			
		ElseIf (StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance") == "Kneeling")
			if(sleepType == 1) ; Kneeling
				; Debug.MessageBox("Your owner reluctantly allows you to kneel and take a rest.")
				StorageUtil.SetStringValue(kPlayer, "_SD_sSleepPose", "ZazAPC020") ; 		HandsBehindKneelBowDown

			elseif(sleepType == 2) ; Sitting	
				; Debug.MessageBox("Your owner accepts to let you sit for a while. ")
				StorageUtil.SetStringValue(kPlayer, "_SD_sSleepPose", "ZazAPC008") ;  HandsBehindSitFloorKneestoChest

			elseif(sleepType == 3) ; Sleeping sideway
				; Debug.MessageBox("You are allowed to lie down and sleep for a while. ")
				StorageUtil.SetStringValue(kPlayer, "_SD_sSleepPose", "ZazAPC056") ;  		HogTieFaceDownLegsSpread

			elseif(sleepType == 4) ; Sleeping 
				; Debug.MessageBox("Your owner lets you sleep on the ground. ")
				StorageUtil.SetStringValue(kPlayer, "_SD_sSleepPose", "ZazAPC015") ;  		HandsBehindLieHogtieFaceDown

			endif

		ElseIf (StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance") == "Standing")
			if(sleepType == 1) ; Kneeling
				; Debug.MessageBox("Your owner reluctantly allows you to kneel and take a rest.")
				StorageUtil.SetStringValue(kPlayer, "_SD_sSleepPose", "ZazAPCAO023") ;   AnimObjectZazAPCAO023		Vertical Pillory

			elseif(sleepType == 2) ; Sitting	
				; Debug.MessageBox("Your owner accepts to let you sit for a while. ")
				StorageUtil.SetStringValue(kPlayer, "_SD_sSleepPose", "ZazAPCAO024") ;   AnimObjectZazAPCAO024		Wooden Horse

			elseif(sleepType == 3) ; Sleeping sideway
				; Debug.MessageBox("You are allowed to lie down and sleep for a while. ")
				StorageUtil.SetStringValue(kPlayer, "_SD_sSleepPose", "ZazAPCAO009") ;    AnimObjectZazAPCAO009		PilloryIdle

			elseif(sleepType == 4) ; Sleeping 
				; Debug.MessageBox("Your owner lets you sleep on the ground. ")
				StorageUtil.SetStringValue(kPlayer, "_SD_sSleepPose", "ZazAPCAO025") ;   AnimObjectZazAPCAO025		X Cross

			endif

		Else
			StorageUtil.SetStringValue(kPlayer, "_SD_sSleepPose", "ZazAPCAO009") ; default sleep pose - pillory idle
		EndIf
	EndIf
	
	; Debug.Notification("[SD] AutoKneelingOff: " + StorageUtil.GetIntValue(kPlayer, "_SD_iDisablePlayerAutoKneeling"))
	; Debug.Notification("[SD] Stand: " + fctSlavery.CheckSlavePrivilege( kPlayer , "_SD_iEnableStand") + " - Stance:" + StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance"))

	If !(_SDGVP_ArmbinderKnee.GetValue()==0)
	;	StorageUtil.SetIntValue(kPlayer, "_SD_iHandsFree", 1)
	;	StorageUtil.SetIntValue(kPlayer, "_SD_iEnableStand", 1)
	;	StorageUtil.SetIntValue(kPlayer, "_SD_iDisablePlayerAutoKneeling", 1)
	;	StorageUtil.SetStringValue(kPlayer, "_SD_sDefaultStanceFollower", "Standing" ) 
	EndIf

	If fctOutfit.isYokeEquipped( kPlayer ) && fctOutfit.isArmsEquipped( kPlayer ) 
		; fctOutfit.setDeviousOutfitArms ( iDevOutfit = -1, bDevEquip = False, sDevMessage = "Removing cuffs since yoke is equipped.")
		fctOutfit.clearDeviceByString ( sDeviceString = "Armbinder" )
	Endif

	If (StorageUtil.GetIntValue(kPlayer, "_SD_iDisablePlayerAutoKneeling") == 0) && fctOutfit.isYokeEquipped( kPlayer ) 
	;	Debug.Notification("[SD] Yoke detected" )
		StorageUtil.SetIntValue(kPlayer, "_SD_iHandsFree", 1)
		StorageUtil.SetIntValue(kPlayer, "_SD_iEnableStand", 1)
		StorageUtil.SetIntValue(kPlayer, "_SD_iDisablePlayerAutoKneeling", 1)
		StorageUtil.SetStringValue(kPlayer, "_SD_sDefaultStanceFollower", "Standing" ) 
		
	ElseIf (StorageUtil.GetIntValue(kPlayer, "_SD_iDisablePlayerAutoKneeling") == 1) && (fctOutfit.isDeviceEquippedKeyword( kPlayer,  "_SD_DeviousEnslaved", "Armbinder"  ) || fctOutfit.isDeviceEquippedKeyword( kPlayer,  "_SD_DeviousSanguine", "Armbinder"  ) ) && !fctOutfit.isYokeEquipped( kPlayer ) 
	;	Debug.Notification("[SD] SD cuffs detected" )
		StorageUtil.SetIntValue(kPlayer, "_SD_iHandsFree", 0)
		StorageUtil.SetIntValue(kPlayer, "_SD_iEnableStand", 0)
		StorageUtil.SetIntValue(kPlayer, "_SD_iDisablePlayerAutoKneeling", 0)
		StorageUtil.SetStringValue(kPlayer, "_SD_sDefaultStanceFollower", "Kneeling" ) 

	EndIf

	if (! kPlayer.WornHasKeyword(fctConstraints.libs.zbf.zbfWornWrist)) ; Stop kneeling restriction if the cuffs are escaped from.
		throttle += 1
		if throttle >= 15 ; Avoid updating controls 10 times per second...
			fctConstraints.libs.UpdateControls()
			throttle = 0
		EndIf		

	ElseIf !kPlayer.GetCurrentScene() && !kPlayer.IsOnMount() && (StorageUtil.GetIntValue(kPlayer, "_SD_iDisablePlayerAutoKneeling")!=1) && (SexLab.ValidateActor( kPlayer ) > 0) && !(_SDGVP_ArmbinderKnee.GetValue()==0)

		; If ( Game.IsMovementControlsEnabled() && kTarget == kPlayer)
		;	fctConstraints.togglePlayerControlsOff()
		; EndIf

		; Debug.Notification("[SD] Stand: " + fctSlavery.CheckSlavePrivilege( kPlayer , "_SD_iEnableStand") + " - Stance:" + StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance"))

		if (kMaster) && (StorageUtil.GetIntValue(kPlayer, "_SD_iHandsFree") == 0) && (StorageUtil.GetIntValue(kPlayer, "_SD_iSleepAnywhereON") == 0)

			iTrust = StorageUtil.GetIntValue(kMaster, "_SD_iTrust")  
			iDisposition = StorageUtil.GetIntValue(kMaster, "_SD_iDisposition")
			fKneelingDistance = funct.floatWithinRange( 500.0 - ((iTrust as Float) * 5.0), 100.0, 2000.0 )

			If (StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance") == "Standing") && (StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStanceFollower") != "Standing")
				StorageUtil.SetStringValue(kPlayer, "_SD_sDefaultStanceFollower", "Standing" ) 

			ElseIf (StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance") != "Standing") && (StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStanceFollower") == "Standing")
				StorageUtil.SetStringValue(kPlayer, "_SD_sDefaultStanceFollower", "Kneeling" ) 
				
			EndIf

			If ( kPlayer.GetDistance( kMaster ) < fKneelingDistance ) && ( kPlayer.GetAnimationVariableFloat("Speed") == 0 ) && (fctOutfit.isDeviceEquippedKeyword( kPlayer,  "_SD_DeviousEnslaved" , "Armbinder" ) || fctOutfit.isDeviceEquippedKeyword( kPlayer,  "_SD_DeviousSanguine", "Armbinder"  ) ) 

				If ( (Utility.RandomInt( 0, 200 ) == 198 ) && !fctSlavery.CheckSlavePrivilege( kPlayer , "_SD_iEnableStand") )
					Debug.Notification( "The collar forces you down on your knees." )
				EndIf

				If (kTarget == kPlayer) 
					If ( fctSlavery.CheckSlavePrivilege( kPlayer , "_SD_iEnableStand") ) && (StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance") == "Standing")
						; fctConstraints.SetAnimating(false)

					ElseIf ( iTrust < 0 ) && (iDisposition < 0)
						; fctConstraints.SetAnimating(true)

						If  (StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance") == "Kneeling")
							PlayIdleWrapper(kPlayer, _SDIAP_bound[4] )
						ElseIf  (StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance") == "Crawling")
							PlayIdleWrapper(kPlayer, _SDIAP_bound[5] ) ; Crawling
						EndIf

					ElseIf ( iTrust >= 0 ) && (iDisposition < 0)
						; fctConstraints.SetAnimating(true)

						If  (StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance") == "Kneeling")
							PlayIdleWrapper(kPlayer, _SDIAP_bound[2] )
						ElseIf  (StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance") == "Crawling")
							PlayIdleWrapper(kPlayer, _SDIAP_bound[5] ) ; Crawling
						EndIf

					Else
						; fctConstraints.SetAnimating(true)
						
						If  (StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance") == "Kneeling") 
							PlayIdleWrapper(kPlayer, _SDIAP_bound[1] )
						ElseIf  (StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance") == "Crawling")
							PlayIdleWrapper(kPlayer, _SDIAP_bound[5] ) ; Crawling
						EndIf
					EndIf

				ElseIf !fctOutfit.isYokeEquipped( kPlayer) 
					If ( fctSlavery.CheckSlavePrivilege( kPlayer , "_SD_iEnableStand") )
						; fctConstraints.SetAnimating(false)

					Else
						; fctConstraints.SetAnimating(true)
						PlayIdleWrapper(kPlayer, _SDIAP_bound[1] )
					EndIf
				EndIf

			ElseIf !fctOutfit.isYokeEquipped( kPlayer) 
				; Debug.Notification("[SD] Turning DD animations on - 4");
				;If ( fctSlavery.CheckSlavePrivilege( kPlayer , "_SD_iEnableStand") ) && (StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance") == "Standing")
	
				fctConstraints.SetAnimating(false)

				;ElseIf  (StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance") == "Kneeling") 
				;	PlayIdleWrapper(kPlayer, _SDIAP_bound[1] )
				;ElseIf  (StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance") == "Crawling")
				;	PlayIdleWrapper(kPlayer, _SDIAP_bound[5] ) ; Crawling
				;EndIf

				; If  (fctOutfit.isDeviceEquippedKeyword( kPlayer,  "_SD_DeviousEnslaved", "Armbinder"  ) || fctOutfit.isDeviceEquippedKeyword( kPlayer,  "_SD_DeviousSanguine", "Armbinder"  ) )
				;	PlayIdleWrapper(kPlayer, _SDIAP_bound[0] )
				; Endif
			EndIf


		EndIf
	EndIf

	

	;Debug.SendAnimationEvent(kTarget, "Unequip")
	;Debug.SendAnimationEvent(kTarget, "UnequipNoAnim")
	RegisterForSingleUpdate( fRFSU )
EndEvent

Event OnEffectStart(Actor akTarget, Actor akCaster)
	kPlayer = Game.GetPlayer()
	kTarget = akTarget
	kMaster = _SDRAP_master.GetReference() as ObjectReference

	If ( kTarget == kPlayer )
		fctConstraints.togglePlayerControlsOff()
		PlayIdleWrapper(kPlayer, _SDIAP_bound[0] )

		; Debug.Messagebox("The collar snaps around your neck.\nYou feel sluggish and unable to resist your owner's commands.")
	EndIf

	RegisterForSingleUpdate( fRFSU )
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)

	If ( kTarget == kPlayer )
		if (SexLab.ValidateActor( kPlayer ) > 0)
			Utility.Wait( 2.0 )
			Debug.SendAnimationEvent(kPlayer, "IdleForceDefaultState")
		endIf

		fctConstraints.togglePlayerControlsOff( False )
		kPlayer.PlayIdle( _SDIAP_reset )	

		; Debug.Messagebox("The collar releases its grasp around your will, leaving behind a screaming headache and bruises around your neck.")
		Debug.Notification("The collar releases its grasp around your will...")
	EndIf

EndEvent

