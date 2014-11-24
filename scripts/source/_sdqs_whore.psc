Scriptname _SDQS_whore extends Quest  

_SDQS_functions Property funct  Auto
_SDQS_fcts_factions Property fctFactions  Auto

SexLabFramework property SexLab auto

FormList Property _SDFLP_forced_allied  Auto  
GlobalVariable Property _SDGVP_demerits  Auto  
GlobalVariable Property _SDGVP_demerits_join  Auto  
GlobalVariable Property _SDGVP_positions  Auto  
ReferenceAlias Property _SDRAP_whore  Auto  
Keyword Property _SDKP_sex  Auto  
Quest Property _SDQP_enslavement  Auto  
ObjectReference[] Property _SDORP_queue  Auto  

SPELL Property _SDSP_Weak Auto

; ragdolling
GlobalVariable Property _SDGVP_state_playerRagdoll  Auto  
GlobalVariable Property _SDGVP_config_verboseMerits  Auto

ObjectReference whore
Float fRegForUpdate = 5.0

Bool Function addToQueue( ObjectReference akObject )
	Bool bAdded = False
	
	If ( akObject != None )
		Int iIdx = 0
		While ( !bAdded && iIdx < _SDORP_queue.Length )
			If ( _SDORP_queue[iIdx] == None )
				bAdded = True
				_SDORP_queue[iIdx] = akObject
				Debug.Trace("[Whore queue] Adding actor to queue: " + akObject)
			EndIf
			iIdx += 1
		EndWhile
	EndIf
	
	Return bAdded
EndFunction

Bool Function removeFromQueue( ObjectReference akWhore )
	Bool bRemoved = False
	Int iIdx = 0
	; Debug.SendAnimationEvent(akWhore, "ZazAPC205")

	While ( !bRemoved && iIdx < _SDORP_queue.Length )
		If ( _SDORP_queue[iIdx] != None )
			Debug.Trace("[Whore queue] Removing actor from queue: " + _SDORP_queue[iIdx])

			bRemoved = True
			If ( !_SDORP_queue[iIdx].GetCurrentScene() && _SDORP_queue[iIdx].GetParentCell() == akWhore.GetParentCell() )
				If ( _SDQP_enslavement.IsRunning() && fctFactions.actorFactionInList( _SDORP_queue[iIdx] as Actor, _SDFLP_forced_allied ) )
					; _SDQP_enslavement.ModObjectiveGlobal( -5.0, _SDGVP_demerits, 3, _SDGVP_demerits_join.GetValue() as Float, False, True, _SDGVP_config_verboseMerits.GetValueInt() as Bool )
				EndIf
			
				; _SDKP_sex.SendStoryEvent( akLoc = akWhore.GetCurrentLocation(), akRef1 = _SDORP_queue[iIdx], akRef2 = akWhore, aiValue1 = 0, aiValue2 = Utility.RandomInt( 0, _SDGVP_positions.GetValueInt() ) )
				; Sex
				If  (SexLab.ValidateActor( _SDORP_queue[iIdx] as actor ) > 0) &&  (SexLab.ValidateActor(akWhore as actor) > 0) 

					If ( ( _SDORP_queue[iIdx] as actor ) == (akWhore as actor))
						Debug.Notification("Next!")

						funct.SanguineRape( akWhore as Actor , akWhore as Actor , "Masturbation", "Masturbation")


					Else
						Debug.Notification("Next!")
						
						actor[] sexActors = new actor[2]
						sexActors[0] = akWhore as actor
						sexActors[1] = _SDORP_queue[iIdx]  as actor
						
						funct.SanguineRape( _SDORP_queue[iIdx]  as actor,  akWhore as actor  , "Dirty")

					EndIf

				Else
					Debug.Trace("[Whore queue] Actors busy: " + SexLab.ValidateActor( _SDORP_queue[iIdx] as actor ) + " - " + akWhore as actor)
				EndIf


				Utility.Wait( 5.0 )
			Else
				Debug.Trace( "_SD::Queue abort - Actor in scene or out of player cell." )
			EndIf
			_SDORP_queue[iIdx] = None
		Else
			iIdx += 1
		EndIf
	EndWhile

	; Debug.SendAnimationEvent(akWhore, "IdleForceDefaultState")

	Return bRemoved
EndFunction

Event OnInit()
	whore = _SDRAP_whore.GetReference() as ObjectReference

	_SDSP_Weak.Cast(whore as Actor)

	RegisterForSingleUpdate( fRegForUpdate )
	GoToState("waiting")
EndEvent

State waiting
	Event OnUpdate()
		If ( Self.IsRunning() )
			GoToState("monitor")
		EndIf
		If ( Self )
			RegisterForSingleUpdate( fRegForUpdate )
		EndIf
	EndEvent
EndState

State monitor
	Event OnUpdate()
		While( whore.GetCurrentScene() )
			Utility.Wait( 5.0 )
		EndWhile
	
		If ( Self.IsStopping() || Self.IsStopped() )
			GoToState("waiting")
		;ElseIf ( whore && !whore.GetCurrentScene() && Game.IsMovementControlsEnabled() && _SDGVP_state_playerRagdoll.GetValueInt() == 0 )
		ElseIf ( whore ) ; && ( whore as Actor ).GetPlayerControls() ) ; && _SDGVP_state_playerRagdoll.GetValueInt() == 0 )
			removeFromQueue( whore )
		EndIf

		If ( Self )
			RegisterForSingleUpdate( fRegForUpdate )
		EndIf
	EndEvent
EndState
