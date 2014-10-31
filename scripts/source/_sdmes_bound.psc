Scriptname _SDMES_bound extends activemagiceffect  
{ USED }
_SDQS_functions Property funct  Auto
_SDQS_fcts_constraints Property fctConstraints  Auto
_SDQS_fcts_slavery Property fctSlavery  Auto

ReferenceAlias Property _SDRAP_master  Auto  
GlobalVariable Property _SDGVP_demerits  Auto  
GlobalVariable Property _SDGVP_demerits_join  Auto  

Keyword[] Property notKeywords  Auto  
Idle[] Property _SDIAP_bound  Auto  
Idle Property _SDIAP_reset  Auto  

Faction Property SexLabActiveFaction  Auto  


Actor kTarget
Actor kPlayer
ObjectReference kMaster

Float fRFSU = 0.1

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

; Add Master privileges flags
	If ( kTarget.GetEquippedWeapon() ) && (fctSlavery.CheckSlavePrivilege( kTarget , "_SD_iEnableWeaponEquip") )
		kTarget.UnequipItem( kTarget.GetEquippedWeapon(), false, True )
		kTarget.RemoveItem( kTarget.GetEquippedWeapon(), 1, True )
	EndIf
	If ( kTarget.GetEquippedWeapon(True) ) && (fctSlavery.CheckSlavePrivilege( kTarget , "_SD_iEnableWeaponEquip")  )
		kTarget.UnequipItem( kTarget.GetEquippedWeapon(True), false, True )
		kTarget.RemoveItem( kTarget.GetEquippedWeapon(True), 1, True )
	EndIf
	If ( kTarget.GetEquippedShield() ) && (fctSlavery.CheckSlavePrivilege( kTarget , "_SD_iEnableWeaponEquip")   )
		kTarget.UnequipItem( kTarget.GetEquippedShield(), false, True )
		kTarget.RemoveItem( kTarget.GetEquippedShield(), 1, True )
	EndIf
	If ( kTarget.GetEquippedSpell(0) ) && (fctSlavery.CheckSlavePrivilege( kTarget , "_SD_iEnableSpellEquip")  )
		kTarget.UnequipSpell( kTarget.GetEquippedSpell(0), 0 )
	EndIf
	If ( kTarget.GetEquippedSpell(1) ) && (fctSlavery.CheckSlavePrivilege( kTarget , "_SD_iEnableSpellEquip") )
		kTarget.UnequipSpell( kTarget.GetEquippedSpell(1), 1 )
	EndIf

	
	

	If ( !kTarget.GetCurrentScene() && !kTarget.IsOnMount() && !kTarget.IsInFaction(SexLabActiveFaction)  && !StorageUtil.GetIntValue(kTarget, "_SD_iDisablePlayerAutoKneeling") )

		; If ( Game.IsMovementControlsEnabled() && kTarget == kPlayer)
		;	fctConstraints.togglePlayerControlsOff()
		; EndIf

		; Debug.Notification("[SD] Stand: " + fctSlavery.CheckSlavePrivilege( kPlayer , "_SD_iEnableStand") + " - Stance:" + StorageUtil.GetStringValue(kTarget, "_SD_sDefaultStance"))

		if (kMaster)



			Int trust = StorageUtil.GetIntValue(kMaster, "_SD_iTrustThreshold") - StorageUtil.GetIntValue(kTarget, "_SD_iTrustPoints")
			Int disposition = StorageUtil.GetIntValue(kMaster, "_SD_iDisposition")

			If ( kTarget.GetDistance( kMaster ) < 512 && kTarget.GetAnimationVariableFloat("Speed") == 0 ) 

				If ( (Utility.RandomInt( 0, 100 ) == 99 ) && !fctSlavery.CheckSlavePrivilege( kPlayer , "_SD_iEnableStand") )
					Debug.Notification( "The collar forces you down on your knees." )
				EndIf

				If (kTarget == kPlayer)
					If ( fctSlavery.CheckSlavePrivilege( kPlayer , "_SD_iEnableStand") ) && (StorageUtil.GetStringValue(kTarget, "_SD_sDefaultStance") == "Standing")
						; fctConstraints.SetAnimating(false)
					ElseIf ( trust < 0 ) && (disposition < 0)
						; fctConstraints.SetAnimating(true)
						If  (StorageUtil.GetStringValue(kTarget, "_SD_sDefaultStance") == "Kneeling")
							PlayIdleWrapper(kTarget, _SDIAP_bound[4] )
						ElseIf  (StorageUtil.GetStringValue(kTarget, "_SD_sDefaultStance") == "Crawling")
							PlayIdleWrapper(kTarget, _SDIAP_bound[5] ) ; Crawling
						EndIf

					ElseIf ( trust >= 0 ) && (disposition < 0)
						; fctConstraints.SetAnimating(true)
						If  (StorageUtil.GetStringValue(kTarget, "_SD_sDefaultStance") == "Kneeling")
							PlayIdleWrapper(kTarget, _SDIAP_bound[2] )
						ElseIf  (StorageUtil.GetStringValue(kTarget, "_SD_sDefaultStance") == "Crawling")
							PlayIdleWrapper(kTarget, _SDIAP_bound[5] ) ; Crawling
						EndIf

					Else
						; fctConstraints.SetAnimating(true)
						If  (StorageUtil.GetStringValue(kTarget, "_SD_sDefaultStance") == "Kneeling") 
							PlayIdleWrapper(kTarget, _SDIAP_bound[1] )
						ElseIf  (StorageUtil.GetStringValue(kTarget, "_SD_sDefaultStance") == "Crawling")
							PlayIdleWrapper(kTarget, _SDIAP_bound[5] ) ; Crawling
						EndIf
					EndIf
				Else
					If ( fctSlavery.CheckSlavePrivilege( kPlayer , "_SD_iEnableStand") )
						; fctConstraints.SetAnimating(false)

					Else
						; fctConstraints.SetAnimating(true)
						PlayIdleWrapper(kTarget, _SDIAP_bound[1] )
					EndIf
				EndIf
			Else
				; Debug.Notification("[SD] Turning DD animations on - 4");
				;If ( fctSlavery.CheckSlavePrivilege( kPlayer , "_SD_iEnableStand") ) && (StorageUtil.GetStringValue(kTarget, "_SD_sDefaultStance") == "Standing")
					; fctConstraints.SetAnimating(false)
				;ElseIf  (StorageUtil.GetStringValue(kTarget, "_SD_sDefaultStance") == "Kneeling") 
				;	PlayIdleWrapper(kTarget, _SDIAP_bound[1] )
				;ElseIf  (StorageUtil.GetStringValue(kTarget, "_SD_sDefaultStance") == "Crawling")
				;	PlayIdleWrapper(kTarget, _SDIAP_bound[5] ) ; Crawling
				;EndIf
				PlayIdleWrapper(kTarget, _SDIAP_bound[0] )
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
	EndIf
	PlayIdleWrapper(kTarget, _SDIAP_bound[0] )

	Debug.Notification("The collar snaps around your neck.")
	Debug.Notification("You feel sluggish and unable to resist your owner's commands.")

	RegisterForSingleUpdate( fRFSU )
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	if !kTarget.IsInFaction(SexLabActiveFaction)
		Utility.Wait( 2.0 )
		Debug.SendAnimationEvent(kTarget, "IdleForceDefaultState")
	endIf
	If ( kTarget == kPlayer )
		fctConstraints.togglePlayerControlsOff( False )
	EndIf
	kTarget.PlayIdle( _SDIAP_reset )	

	Debug.Notification("The collar releases its grasp around your will, ...")
	Debug.Notification("leaving behind a screaming headache and bruises around your neck.")

EndEvent

