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

Message Property _SD_whoreQueueMenu Auto

ObjectReference whore


GlobalVariable Property GameTime  Auto  
float fLast = 0.0
float fNextAllowed = 0.02

Float fRegForUpdate = 5.0

Bool Function addToQueue( ObjectReference akObject )
	Bool bAdded = False
	Actor akActor = akObject as Actor
	Actor akPlayer = Game.GetPlayer()

	If ( !Self.IsRunning() )
		Debug.Trace("[SD] Whore queue - Quest disabled - aborting")
		Return False
	Endif	

	If ( akObject != None ) && ( akActor != None )
		If (!akActor.IsGhost()) && (!akObject.IsDisabled()) &&  (SexLab.ValidateActor( akActor ) > 0) 
			Int iIdx = 0
			While ( !bAdded && iIdx < _SDORP_queue.Length )
				If ( _SDORP_queue[iIdx] == None )
					bAdded = True
					_SDORP_queue[iIdx] = akObject
					_SDORP_queueAliasRef[iIdx].ForceRefTo( akObject )

					SendModEvent("SLHModHormone", "SexDrive", 0.5)

					Debug.Trace("[SD] Whore queue - Adding actor to queue: " + akObject)
				EndIf
				iIdx += 1
			EndWhile
		Endif
	EndIf
	
	Return bAdded
EndFunction

Bool Function removeFromQueue( ObjectReference akWhore )
	Bool bRemoved = False
	Int iIdx = 0
	Int iThreesome = 0
	Int iRandomNum 
	Int IButton  
	int AttackerStamina
	int VictimStamina = (akWhore as actor).GetActorValue("stamina") as int
	; Debug.SendAnimationEvent(akWhore, "ZazAPC205")
	If ( !Self.IsRunning() )
		Debug.Trace("[SD] Whore queue - Quest disabled - aborting")
		Return False
	Endif

	While ( !bRemoved && iIdx < _SDORP_queue.Length )
		If ( _SDORP_queue[iIdx] != None )
			Debug.Trace("[SD] Whore queue - Removing actor from queue: " + _SDORP_queue[iIdx])
			StorageUtil.SetIntValue( (akWhore as actor) , "_SD_iHandsFreeSex", 1)

			If (iIdx <= (_SDORP_queue.Length - 2)) 
				If ( _SDORP_queue[iIdx+1] != None ) && ( _SDORP_queue[iIdx+1] != _SDORP_queue[iIdx] )  && ( _SDORP_queue[iIdx] != akWhore )  && ( _SDORP_queue[iIdx+1] != akWhore )
					If ( _SDORP_queue[iIdx+1].GetParentCell() == akWhore.GetParentCell() )
						iThreesome = 1
					Else
						iThreesome = 0
					EndIf
				Endif
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


				if ( (GameTime.GetValue() - StorageUtil.GetFloatValue(akWhore, "_SD_iLastSexTime"))  < StorageUtil.GetFloatValue(akWhore, "_SD_iNextSexTime") )
					; Debug.Notification("(nevermind...)")
					Debug.Trace("[SD]    Sex aborted - too soon since last sex scene")
					Debug.Trace("[SD]      		(GameTime.GetValue() - fLast) : " + (GameTime.GetValue() - fLast))
					Debug.Trace("[SD]      		fNextAllowed : " + fNextAllowed)

				Else	
					If ( ( _SDORP_queue[iIdx] as actor ) == (akWhore as actor)) && (SexLab.ValidateActor( akWhore as actor ) > 0)
						Debug.Notification("They force you to give them a good show.")

						funct.SanguineRape( akWhore as Actor , akWhore as Actor , "Masturbation", "Masturbation")


					Else

						If (iThreesome==1) &&  (SexLab.ValidateActor( _SDORP_queue[iIdx] as actor ) > 0) &&  (SexLab.ValidateActor( _SDORP_queue[iIdx+1] as actor ) > 0)  && (SexLab.ValidateActor( akWhore as actor ) > 0)
							iRandomNum = Utility.RandomInt(0,100)
							If (iRandomNum>80)
								Debug.Notification("They are not finished with you yet.")
							ElseIf (iRandomNum>50)
								Debug.Notification("They surround you with lust in their eyes.")
							ElseIf (iRandomNum>0)
								Debug.Notification("You feel helpless as they take turns on you.")
							EndIf

							AttackerStamina = ((_SDORP_queue[iIdx]  as actor).GetActorValue("stamina") + (_SDORP_queue[iIdx+1]  as actor).GetActorValue("stamina")) as int
							VictimStamina = (akWhore as actor).GetActorValue("stamina") as int
							IButton = _SD_whoreQueueMenu.Show()
							If IButton == 0 ; Undress
								StorageUtil.SetIntValue( akWhore as actor , "_SD_iSub", StorageUtil.GetIntValue( akWhore as actor, "_SD_iSub") + 1)
								actor[] sexActors = new actor[3]
								sexActors[0] = akWhore as actor
								sexActors[1] = _SDORP_queue[iIdx]  as actor
								sexActors[2] = _SDORP_queue[iIdx+1]  as actor
	 
							    sslBaseAnimation[] anims
							    anims = SexLab.GetAnimationsByTags(3,"Orgy" )
	 
							    SexLab.StartSex(sexActors, anims, victim=akWhore as actor  )

							else
								StorageUtil.SetIntValue( akWhore as actor , "_SD_iDom", StorageUtil.GetIntValue( akWhore as actor, "_SD_iDom") + 1)
								if AttackerStamina > VictimStamina
									AttackerStamina = VictimStamina
									Debug.MessageBox("You try to resist with all your strength, but at the end the aggressors overwhelm you...")
									actor[] sexActorsA = new actor[3]
									sexActorsA[0] = akWhore as actor
									sexActorsA[1] = _SDORP_queue[iIdx]  as actor
									sexActorsA[2] = _SDORP_queue[iIdx+1]  as actor
	 
									sslBaseAnimation[] animsA
									animsA = SexLab.GetAnimationsByTags(3,"Aggressive" )
	 
									SexLab.StartSex(sexActorsA, animsA, victim=akWhore as actor  )
								endIf
								(_SDORP_queue[iIdx]  as actor).DamageActorValue("stamina",AttackerStamina / 2) 
								(_SDORP_queue[iIdx+1]  as actor).DamageActorValue("stamina",AttackerStamina / 2) 
								(akWhore as actor).DamageActorValue("stamina",AttackerStamina)

							EndIf


						Elseif (SexLab.ValidateActor( _SDORP_queue[iIdx] as actor ) > 0) && (SexLab.ValidateActor( akWhore as actor ) > 0)
							iRandomNum = Utility.RandomInt(0,100)
							If (iRandomNum>80)
								Debug.Notification("Another one is waiting for you.")
							ElseIf (iRandomNum>50)
								Debug.Notification("You can't hide from the next aggressor.")
							ElseIf (iRandomNum>0)
								Debug.Notification("You feel weak as another one grabs you.")
							EndIf

							; actor[] sexActors = new actor[2]
							; sexActors[0] = akWhore as actor
							; sexActors[1] = _SDORP_queue[iIdx]  as actor

							AttackerStamina = (_SDORP_queue[iIdx]  as actor).GetActorValue("stamina") as int
							VictimStamina = (akWhore as actor).GetActorValue("stamina") as int
							IButton = _SD_whoreQueueMenu.Show()
							If IButton == 0 ; Undress
								StorageUtil.SetIntValue( akWhore as actor , "_SD_iSub", StorageUtil.GetIntValue( akWhore as actor, "_SD_iSub") + 1)

								funct.SanguineRape( _SDORP_queue[iIdx]  as actor,  akWhore as actor  , "Sex")

							else
								StorageUtil.SetIntValue( akWhore as actor , "_SD_iDom", StorageUtil.GetIntValue( akWhore as actor, "_SD_iDom") + 1)
								
								if AttackerStamina > VictimStamina
									AttackerStamina = VictimStamina
									Debug.MessageBox("You try to resist with all your strength, but at the end the aggressors overwhelm you...")
									funct.SanguineRape( _SDORP_queue[iIdx] as actor, akWhore as actor, "Agressive")
								endIf
								(_SDORP_queue[iIdx]  as actor).DamageActorValue("stamina",AttackerStamina) 
								(akWhore as actor).DamageActorValue("stamina",AttackerStamina)

							EndIf							
						Else
							Debug.Trace("[SD] Whore queue - Actors busy: " + SexLab.ValidateActor( _SDORP_queue[iIdx] as actor ) + " - " + SexLab.ValidateActor(  akWhore as actor) )
						EndIf
					EndIf

				EndIf


				Utility.Wait( 5.0 )
			Else
				Debug.Trace( "[SD] Whore queue - abort - Actor in scene or out of player cell." )
			EndIf
			_SDORP_queue[iIdx] = None
			_SDORP_queueAliasRef[iIdx].ForceRefTo( akWhore )
			If (iThreesome == 1) 
				_SDORP_queue[iIdx+1] = None
				_SDORP_queueAliasRef[iIdx+1].ForceRefTo( akWhore )
			endif
		Else
			if  (_SDORP_queueAliasRef[iIdx].GetReference() != akWhore)			
				_SDORP_queueAliasRef[iIdx].ForceRefTo( akWhore )
				Debug.Trace( "[SD] Whore queue - Cleaning up whore." )
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

	Debug.Trace("[SD] Whore queue --- Checking")
	If ( !Self.IsRunning() )
		Debug.Trace("[SD] Whore queue - Quest disabled - aborting")
		Return
	Endif

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
			Utility.Wait( 1.0 )
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
