Scriptname _SDQS_snp extends Quest Conditional
{ USED }
Import Utility

_SDQS_functions Property funct  Auto
_SDQS_config Property config Auto
SexLabFramework property SexLab auto

GlobalVariable Property _SDGV_snp_delay  Auto
GlobalVariable Property _SDGVP_state_playerRagdoll  Auto

Bool[] Property _SDBP_allowDisabledActors  Auto
Bool[] Property _SDBP_scenePositionAdj  Auto
Bool[] Property _SDBP_scenePositionSync  Auto
Bool[] Property _SDBP_sceneLockPosition  Auto  

ReferenceAlias Property _SDRAP_male  Auto
ReferenceAlias Property _SDRAP_female  Auto
ReferenceAlias Property _SDRAP_lockPosition  Auto

Keyword Property _SDKP_lustAura  Auto

Message[] Property _SDMP_messages  Auto
Scene[] Property _SDSP_sexScenes  Auto
Spell[] Property _SDSP_sexSpells Auto
Armor[] Property _SDAP_punish_items  Auto

Idle[] Property _SDIAP_4phase_male  Auto
Idle[] Property _SDIAP_4phase_female  Auto
Idle[] Property _SDIAP_1phase_male  Auto
Idle[] Property _SDIAP_1phase_female  Auto
Idle[] Property _SDIAP_poses_female  Auto
Idle[] Property _SDIAP_poses_male  Auto
Idle[] Property _SDIAP_dance_female  Auto

Int Property _SDUIP_scene = 0 Auto
Int Property _SDUIP_position = 0 Auto
Int Property _SDUIP_phase = 0 Auto
Float Property _SDFP_distance = 0.0 Auto

Int Property iQuestActive = 0 Auto Conditional

Int iMsgResponse 

Bool shiftPress
Bool keyPress1
Bool keyPress2

Float sceneRunTime
Float sceneStartTime

Actor kMale
Actor kFemale
ObjectReference kLockPos

Function updateSexPk( Actor akActorM, Actor akActorF, Bool abWithTarget = True )
	_SDSP_sexSpells[0].RemoteCast(akActorF, akActorF, akActorF)
EndFunction

; position update
Function updatePos( Actor akActorM, Actor akActorF, Bool abFlip = False )
;HACK: position handled by sexlab	
;_SDFP_distance = funct.syncActorPosition ( akActorM, akActorF, config._SDFP_offset_x[ _SDUIP_position  ], config._SDFP_offset_y[ _SDUIP_position  ], config._SDFP_offset_z[ _SDUIP_position ], config._SDBP_flip[ _SDUIP_position ], abFlip )
EndFunction

; aiValue1 = scene
; aiValue2 = package selection within scene or animation
Event OnStoryScript(Keyword akKeyword, Location akLocation, ObjectReference akRef1, ObjectReference akRef2, int aiValue1, int aiValue2)

	Debug.Notification("[_sdqs_snp] Receiving scene:" + aiValue1 + " [ " + aiValue2 + " ]")
	Debug.Trace("[_sdqs_snp] Receiving scene:" + aiValue1 + " [ " + aiValue2 + " ]")

	If( iQuestActive == 0 )
		GoToState("waiting")
		RegisterForSingleUpdate( 0.1 )

		iQuestActive = 1
		sceneRunTime = 0.0
		sceneStartTime = GetCurrentRealTime()

		kMale = akRef1 as Actor
		kFemale = akRef2 as Actor
		kLockPos = _SDRAP_lockPosition.GetReference() as ObjectReference

		_SDUIP_scene = aiValue1
		_SDUIP_position = aiValue2

		_SDSP_sexSpells[1].RemoteCast(akRef2, akRef2 as Actor, akRef2)

		; Debug.Notification("[_sdqs_snp] Waiting for Ragdoll")
		; While ( _SDGVP_state_playerRagdoll.GetValueInt() == 1 )
		;	Wait(5.0)
		;	If ( GetCurrentRealTime() - sceneStartTime > 10.0 )
		;		Self.Stop()
		;	EndIf
		; EndWhile
		
		; Debug.Notification("[_sdqs_snp] Waiting for SexLab ")
		; while SexLab.GetActorController(kMale) != none && SexLab.GetActorController(kFemale) != none
		;	Wait(5.0)
		;	If ( GetCurrentRealTime() - sceneStartTime > 10.0 )
		;		Self.Stop()
		;	EndIf			
		; endWhile

		; Debug.Notification("[_sdqs_snp] Waiting for actors")
		; while akRef1.GetCurrentScene() != none && akRef2.GetCurrentScene() != none
		;	; pause for startup and ragdolling to end for 30 sec.
		;	Wait(5.0)
		;	If ( GetCurrentRealTime() - sceneStartTime > 10.0 )
		;		Self.Stop()
		;	EndIf			
		; endWhile

		if ( akLocation )
			Float fNewLust = akLocation.GetKeywordData( _SDKP_lustAura ) as Float + 1.0
			akLocation.SetKeywordData( _SDKP_lustAura, fNewLust )
			Debug.Trace("_SD:: Location " + akLocation.GetName() + " lust level: " + akLocation.GetKeywordData( _SDKP_lustAura ) )
		EndIf

		Debug.Trace("_SD:: _SDBP_sceneLockPosition = " + _SDBP_sceneLockPosition[ _SDUIP_scene ])
		If ( kLockPos && kLockPos.Is3DLoaded() && _SDBP_sceneLockPosition[ _SDUIP_scene ] )
			; marker.MoveTo( female, 128 * Math.Sin( female.GetAngleZ() ), 128 * Math.Cos( female.GetAngleZ() ), female.GetHeight() )
			kLockPos.TranslateTo(kLockPos.X, kLockPos.Y, kFemale.Z,  kMale.GetAngleX(), kMale.GetAngleY(), kMale.GetAngleZ() + kMale.GetHeadingAngle( kLockPos ), 200.0 )
			; kFemale.TranslateToRef(kLockPos, 500.0)
		EndIf
	Else
		Debug.Notification("_SD:: _SDUIP_scene = " + _SDUIP_scene + " start fail")
	EndIf
EndEvent

Auto State waiting
	Event OnUpdate()
		Actor kSlave= _SDRAP_female.GetReference() as Actor
		Actor kMaster= _SDRAP_male.GetReference() as Actor

		If ( Self.IsRunning() && _SDUIP_scene != -1 )
			GoToState("monitor")

			; If  (SexLab.ValidateActor( kSlave ) > 0) &&  (SexLab.ValidateActor(kMaster) > 0) 

				; Debug.Notification("[_sdqs_snp] Waiting - Starting scene:" + _SDUIP_scene + " [ "  + _SDUIP_phase+ " ]")

				If (_SDUIP_scene >=0 ) && (_SDUIP_scene <=8 )
					If (_SDUIP_scene != -1 ) ; AI Leash disabled for now
						If  (_SDUIP_scene == 3 ) || (_SDUIP_scene == 5 ) 
							; _SDUIP_scene = 0  ; Routing punishments and whippings for now.
							
						EndIf
						_SDSP_sexScenes[ _SDUIP_scene ].Start()
					Else
						Debug.Notification("[_sdqs_snp] Scene skipped:" + _SDUIP_scene)	
					EndIf
				ElseIf   (_SDUIP_scene >=9 ) && (_SDUIP_scene <=18 )
					; Scenes 9 and 10 not used right now
					; _SDSP_sexScenes2[ _SDUIP_scene - 9 ].Start()
				EndIf

			; Else
			; 	Debug.Notification("[_sdqs_snp] Actors not ready - skipping scene:" + _SDUIP_scene + " [ "  + _SDUIP_phase+ " ]")


			; EndIf
		Else
			; Debug.Notification("[_sdqs_snp] Scene stopped:" + _SDUIP_scene + " [ "  + _SDUIP_phase+ " ]")

			If ( Self.IsRunning() )
			 	; Debug.Notification("[_sdqs_snp] SnP quest is still running")
			 	; Debug.Notification("[_sdqs_snp] Waiting for timeout")
			 	; Self.Stop()
			Else
			 	; Debug.Notification("[_sdqs_snp] SnP quest is not running yet")
			 	; Debug.Notification("[_sdqs_snp] Waiting for timeout")
			 	; Self.Reset()
		       EndIf
		EndIf

		If ( Self )
			RegisterForSingleUpdate( 0.1 )
		EndIf
	EndEvent
EndState

State monitor
	Event OnBeginState()
		kLockPos = _SDRAP_lockPosition.GetReference() as ObjectReference
	EndEvent

	Event OnEndState()
	EndEvent
	
	Event OnUpdate()
		If ( Self.IsStopped() || Self.IsStopping() )
			_SDUIP_scene = -1
			GoToState("waiting")
		Else
			
			If( !_SDBP_allowDisabledActors[ _SDUIP_scene ] )
				If( !kMale || kMale.IsDead() || kMale.IsDisabled() )
					UnregisterForAllKeys()
					Self.Stop()
					Return
				EndIf
				If( !kFemale || kFemale.IsDead() || kFemale.IsDisabled() )
					UnregisterForAllKeys()
					Self.Stop()
					Return
				Endif
			EndIf



			sceneRunTime = GetCurrentRealTime() - sceneStartTime
			; Debug.Notification("[_sdqs_snp] scene " + _SDUIP_scene + " [ "  + _SDUIP_phase+ " ]  runtime: " + sceneRunTime )

			If (sceneRunTime > 300.0)
				Debug.Notification("[_sdqs_snp] Scene timeout" )
					UnregisterForAllKeys()
					Self.Stop()
					Return
			EndIf

			;marker.MoveTo( female, 128 * Math.Sin( female.GetAngleZ() ), 128 * Math.Cos( female.GetAngleZ() ), female.GetHeight() )
			;male.TranslateTo(marker.X, marker.Y, female.Z,  male.GetAngleX(), male.GetAngleY(), male.GetAngleZ() + male.GetHeadingAngle( female ), 100.0 )
			If ( _SDBP_sceneLockPosition[ _SDUIP_scene ] && kLockPos.GetDistance( kFemale ) > 10.0 )
				kLockPos.TranslateTo(kLockPos.X, kLockPos.Y, kFemale.Z,  kMale.GetAngleX(), kMale.GetAngleY(), kMale.GetAngleZ() + kMale.GetHeadingAngle( kLockPos ), 1000.0 )
				; kFemale.TranslateToRef(kLockPos, 500.0)
			EndIf
		EndIf

		If ( Self )
			RegisterForSingleUpdate( 0.1 )
		EndIf
	EndEvent
EndState

Scene[] Property _SDSP_sexScenes2  Auto  
