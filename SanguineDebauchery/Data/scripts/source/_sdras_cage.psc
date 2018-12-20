Scriptname _SDRAS_cage extends ReferenceAlias  

ReferenceAlias Property _SDRAP_masters_key  Auto
GlobalVariable Property _SDGVP_demerits  Auto  
GlobalVariable Property _SDGVP_demerits_join  Auto  
GlobalVariable Property _SDGVP_config_verboseMerits  Auto
GlobalVariable Property _SDGVP_state_caged  Auto  
GlobalVariable Property _SDGVP_enableCages  Auto  

Event OnLoad()
	ObjectReference cage = Self.GetReference() as ObjectReference
	Actor kPlayer = Game.GetPlayer()

	cage.SetLockLevel( kPlayer.GetBaseAV("Lockpicking") as Int )
	cage.Lock( False, True )
	cage.SetOpen( True )
EndEvent

Event OnActivate(ObjectReference akActionRef)
	ObjectReference cage = Self.GetReference() as ObjectReference
	ObjectReference masterKey 
	Form cageForm = cage as Form
	Form actorForm = akActionRef as Form
	Actor kPlayer = Game.GetPlayer()
	Actor kCurrentMaster
	Int kOpen = cage.GetOpenState()

	; Debug.Notification( "[SD] Cage door ID: " + cageForm.GetFormID() )
	; Debug.Notification( "[SD] Cage door - activate attempt :" + actorForm.GetFormID() )
	; Debug.Notification( "[SD] Cage Locked State : " + cage.IsLocked() )
	; Debug.Notification( "[SD] Cage Open State: " + cage.GetOpenState() )

	debugTrace(" Cage enabled: " + StorageUtil.GetIntValue(none, "_SD_bEnableCageScene") )
	debugTrace(" Cage scene active: " + StorageUtil.GetIntValue( none, "_SD_iCageSceneActive") )
	debugTrace(" Caged slave: " + StorageUtil.GetIntValue( none, "_SD_iCagedSlave") )
	debugTrace(" Cage marked as broken: " + StorageUtil.GetIntValue( cage, "_SD_iCageBroken"  ))

	debugTrace(" Cage door ID: " + cage )
	debugTrace(" Cage door - activate attempt :" + akActionRef )
	debugTrace(" Cage Locked State : " + cage.IsLocked() )
	debugTrace(" Cage Open State: " + cage.GetOpenState() )

	If (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved") == 1)
		kCurrentMaster = StorageUtil.GetFormValue(kPlayer, "_SD_CurrentOwner") as Actor

		if (akActionRef == (kCurrentMaster as ObjectReference)) && 	(StorageUtil.GetIntValue( none, "_SD_iCageSceneActive") == 0)

			; Debug.Notification( "[SD] Master activating cage" )
			debugTrace( "Master activating cage" )
			If (StorageUtil.GetIntValue( none, "_SD_iCagedSlave") == 1) ; If ( cage.IsLocked() )
				debugTrace("  - Slave in cage. Unlocking." )
				cage.Lock( False, True )
				cage.SetOpen( True )

				if (_SDGVP_state_caged!=None)
					_SDGVP_state_caged.SetValue(0)
				Endif
				StorageUtil.SetIntValue( none, "_SD_iCageSceneActive"  , 0)
				StorageUtil.SetIntValue( none, "_SD_iCagedSlave"  , 0)

			else
				debugTrace("  - locking cage" )
				cage.Lock( True, True )
				cage.SetOpen( False )
			EndIf

		EndIf

	elseif (_SDRAP_masters_key != None )
		masterKey = _SDRAP_masters_key.GetReference()

		If ( akActionRef.GetItemCount( masterKey ) )
			If ( cage.IsLocked() )
				cage.Lock( False )
			EndIf
			If(akActionRef == kPlayer) ;This should really be changed to !Master in order to prevent player from ordering a follower to open the cage, will revisit after playtesting.
	;			Self.GetOwningQuest().ModObjectiveGlobal( 1.0, _SDGVP_demerits, 3, _SDGVP_demerits_join.GetValue() as Float, False, True, _SDGVP_config_verboseMerits.GetValueInt() as Bool )
			EndIf
		EndIf
	Endif
EndEvent

Event OnOpen(ObjectReference akActionRef)
	; Debug.Notification( "[SD] Cage door - opening" )
	debugTrace(" Cage door - opening" )
	; _SDGVP_state_caged.SetValue( 0 )
EndEvent

Event OnClose(ObjectReference akActionRef)
	; Debug.Notification( "[SD] Cage door - closing" )
	debugTrace(" Cage door - closing" )
	; _SDGVP_state_caged.SetValue( 1 )
EndEvent



Function debugTrace(string traceMsg)
	if (StorageUtil.GetIntValue(none, "_SD_debugTraceON")==1)
		Debug.Trace("[_sdras_cage]"  + traceMsg)
	endif
endFunction