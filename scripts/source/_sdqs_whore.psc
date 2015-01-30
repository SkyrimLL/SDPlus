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
ReferenceAlias[] Property _SDORP_queueAliasRef  Auto  

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
				_SDORP_queueAliasRef[iIdx].ForceRefTo( akObject )

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
	Int iThreesome = 0
	Int iRandomNum 
	; Debug.SendAnimationEvent(akWhore, "ZazAPC205")

	While ( !bRemoved && iIdx < _SDORP_queue.Length )
		If ( _SDORP_queue[iIdx] != None )
			Debug.Trace("[Whore queue] Removing actor from queue: " + _SDORP_queue[iIdx])
			StorageUtil.SetIntValue( (akWhore as actor) , "_SD_iHandsFreeSex", 1)

			If ( _SDORP_queue[iIdx+1] != None ) && ( _SDORP_queue[iIdx+1] != _SDORP_queue[iIdx] )  && ( _SDORP_queue[iIdx] != akWhore )  && ( _SDORP_queue[iIdx+1] != akWhore )
				If ( _SDORP_queue[iIdx+1].GetParentCell() == akWhore.GetParentCell() )
					iThreesome = 1
				Else
					iThreesome = 0
				EndIf
			Else
				iThreesome = 0
			EndIf

			bRemoved = True
			If ( _SDORP_queue[iIdx].GetParentCell() == akWhore.GetParentCell() )
				; If ( _SDQP_enslavement.IsRunning() && fctFactions.actorFactionInList( _SDORP_queue[iIdx] as Actor, _SDFLP_forced_allied ) )
					; _SDQP_enslavement.ModObjectiveGlobal( -5.0, _SDGVP_demerits, 3, _SDGVP_demerits_join.GetValue() as Float, False, True, _SDGVP_config_verboseMerits.GetValueInt() as Bool )
				; EndIf
			
				; _SDKP_sex.SendStoryEvent( akLoc = akWhore.GetCurrentLocation(), akRef1 = _SDORP_queue[iIdx], akRef2 = akWhore, aiValue1 = 0, aiValue2 = Utility.RandomInt( 0, _SDGVP_positions.GetValueInt() ) )
				; Sex
				If  (SexLab.ValidateActor( _SDORP_queue[iIdx] as actor ) > 0) &&  (SexLab.ValidateActor(akWhore as actor) > 0) 

					If (iThreesome==0) && ( ( _SDORP_queue[iIdx] as actor ) == (akWhore as actor))
						Debug.Notification("Your turn!")

						funct.SanguineRape( akWhore as Actor , akWhore as Actor , "Masturbation", "Masturbation")


					Else
						iRandomNum = Utility.RandomInt(0,100)

						If (iThreesome==1) &&  (SexLab.ValidateActor( _SDORP_queue[iIdx] as actor ) > 0) &&  (SexLab.ValidateActor( _SDORP_queue[iIdx+1] as actor ) > 0) 
							If (iRandomNum>80)
								Debug.Notification("Mind if I join in?")
							ElseIf (iRandomNum>50)
								Debug.Notification("We are going to stuff you good.")
							ElseIf (iRandomNum>0)
								Debug.Notification("Look what we have here..")
							EndIf

							actor[] sexActors = new actor[3]
							sexActors[0] = akWhore as actor
							sexActors[1] = _SDORP_queue[iIdx]  as actor
							sexActors[2] = _SDORP_queue[iIdx+1]  as actor
 
						    sslBaseAnimation[] anims
						    anims = SexLab.GetAnimationsByTags(3,"Orgy" )
 
						    SexLab.StartSex(sexActors, anims, victim=akWhore as actor  )

						Else 
							If (iRandomNum>80)
								Debug.Notification("Next!")
							ElseIf (iRandomNum>50)
								Debug.Notification("Come here.. don't be shy.")
							ElseIf (iRandomNum>0)
								Debug.Notification("Look what we have here..")
							EndIf

							actor[] sexActors = new actor[2]
							sexActors[0] = akWhore as actor
							sexActors[1] = _SDORP_queue[iIdx]  as actor
							
							funct.SanguineRape( _SDORP_queue[iIdx]  as actor,  akWhore as actor  , "Sex")
						EndIf
					EndIf

				Else
					Debug.Trace("[Whore queue] Actors busy: " + SexLab.ValidateActor( _SDORP_queue[iIdx] as actor ) + " - " + SexLab.ValidateActor(  akWhore as actor) )
				EndIf


				Utility.Wait( 5.0 )
			Else
				Debug.Trace( "[Whore queue] abort - Actor in scene or out of player cell." )
			EndIf
			_SDORP_queue[iIdx] = None
			_SDORP_queueAliasRef[iIdx].ForceRefTo( akWhore )
		Else
			if  (_SDORP_queueAliasRef[iIdx].GetReference() != akWhore)			
				_SDORP_queueAliasRef[iIdx].ForceRefTo( akWhore )
				Debug.Trace( "[Whore queue] Cleaning up whore." )
			EndIf

			iIdx += 1

		EndIf
	EndWhile

	If (StorageUtil.GetIntValue( (akWhore as actor) , "_SD_iHandsFreeSex") == 1)
		StorageUtil.SetIntValue( (akWhore as actor) , "_SD_iHandsFreeSex", 0)
	EndIf

	; Debug.SendAnimationEvent(akWhore, "IdleForceDefaultState")

	Return bRemoved
EndFunction

Function checkQueue( ) 
	Int iIdx = 0
	Int iRefCount = 0
	Int iAliasCount = 0

	Debug.Trace("[Whore queue] Queue ---")

	While ( iIdx < _SDORP_queue.Length )
		Debug.Trace("[Whore queue] Queue ["+ iIdx +"] ActorRef: " + _SDORP_queue[iIdx] + " - Alias: " + _SDORP_queueAliasRef[iIdx])

		if (_SDORP_queue[iIdx] != None)
			iRefCount += 1
		endif

		if (_SDORP_queueAliasRef[iIdx] != None)
			iAliasCount += 1
		endif

		iIdx += 1
	EndWhile

	Debug.Notification("[Whore queue] RefCount: " + iRefCount + " - AliasCount: " + iAliasCount)
  
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

		; checkQueue( )
		; Debug.Notification("[Whore queue] Whore: " + whore)
	
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
