Scriptname _SDRAS_master extends ReferenceAlias Conditional
{ USED }
Import Utility

SexLabFramework Property SexLab  Auto  

_SDQS_functions Property funct  Auto
_SDQS_snp Property snp Auto
_SDQS_enslavement Property enslavement  Auto
_SDQS_ennslavement_tasks Property tasks  Auto

Quest Property _SDQP_enslavement_tasks  Auto
Cell[] Property _SDCP_sanguines_realms  Auto  

GlobalVariable Property _SDGV_leash_length  Auto
GlobalVariable Property _SDGV_free_time  Auto
GlobalVariable Property _SDGVP_positions  Auto  
GlobalVariable Property _SDGVP_punishments  Auto  
GlobalVariable Property _SDGVP_demerits  Auto 
GlobalVariable Property _SDGVP_demerits_join  Auto  
GlobalVariable Property _SDGVP_buyout  Auto  
GlobalVariable Property _SDGVP_buyoutEarned  Auto  
GlobalVariable Property _SDGVP_escape_radius  Auto  
GlobalVariable Property _SDGVP_config_verboseMerits  Auto
GlobalVariable Property _SDDVP_buyoutEarned  Auto
GlobalVariable Property _SDGVP_state_caged  Auto  

LocationAlias Property _SDLAP_masters_location  Auto  

ReferenceAlias Property _SDRAP_slave  Auto
ReferenceAlias Property _SDRAP_master  Auto
ReferenceAlias Property _SDRAP_bindings  Auto
ReferenceAlias Property _SDRAP_crop  Auto  

FormList Property _SDFLP_slavers  Auto  
FormList Property _SDFLP_trade_items  Auto
FormList Property _SDFLP_banned_factions  Auto  
FormList Property _SDFLP_forced_allied  Auto  

Keyword Property _SDKP_sex  Auto  
Keyword Property _SDKP_enslave  Auto
Keyword Property _SDKP_master  Auto
Keyword Property _SDKP_food  Auto  
Keyword Property _SDKP_food_raw  Auto  

Package[] Property _SDPP_stall_package  Auto  

Bool bSlaveDetectedByMaster
Bool bSlaveDetectedByTarget
Bool bTargetAllied
Bool bTargetMaster

Float fPackageTime = 0.0
Float fSlaveLastSeen
Float fLibido
Float fSlaveFreeTime
Float fLeashLength
Float distance
Float distanceAverage = 0.0
Float fGoldEarned
Int count
Int index
Int iRelationship
Int iCheckdemerits
Int iuType

Actor kMaster
Actor kSlave
Actor kCombatTarget
Actor kNPC
ObjectReference kBindings
Weapon kCrop

Race Property FalmerRace  Auto  
Keyword Property _SDKP_actorTypeNPC  Auto
_SDRAS_player Property player Auto

Bool bAttackedBySlave = False
Float fRFSU = 2.0
Float fRFSUGT = 1.0

Event OnDeath(Actor akKiller)
	; escape
	Debug.Trace("[_sdras_master] Master dead - Stop enslavement")

	Self.GetOwningQuest().Stop()
	If (GetState() != "search") && (akKiller != kSlave) && ( (akKiller.HasKeyword( _SDKP_actorTypeNPC ) || (akKiller.GetRace() == falmerRace)) && player.checkGenderRestrictions( akKiller, kSlave ) ) && !funct.actorFactionInList( akKiller, _SDFLP_banned_factions ) ; && funct.actorFactionInList( akKiller, _SDFLP_slavers, _SDFLP_banned_factions ) )
		; new master
		While ( Self.GetOwningQuest().IsStopping() )
		EndWhile

		; New enslavement - changing ownership
		_SDKP_enslave.SendStoryEvent(akRef1 = akKiller, akRef2 = kSlave, aiValue1 = 0)

	EndIf
EndEvent

Event OnCellLoad()

EndEvent

Event OnPackageChange(Package akOldPackage)
	fPackageTime = GetCurrentRealTime()
EndEvent

Event OnCombatStateChanged(Actor akTarget, int aeCombatState)
	If ( !kMaster )
		kMaster = _SDRAP_master.GetReference() as Actor
	EndIf

	; most likelt happen on a pickpocket failure.
	If ( (aeCombatState != 0) && (akTarget == kSlave) && (!kMaster.GetCurrentScene()) && (Self.GetOwningQuest().GetStage() < 90) )
		Int iGold = 100
		Float iDemerits = 10.0

		funct.actorCombatShutdown( kMaster )
		funct.actorCombatShutdown( kSlave )
		
		If ( kMaster.GetCrimeFaction() )
			iGold = kMaster.GetCrimeFaction().GetCrimeGold()
			iDemerits = Math.Ceiling( iGold / 100 ) as Float
		EndIf

		Self.GetOwningQuest().ModObjectiveGlobal( iDemerits, _SDGVP_demerits, -1, _SDGVP_demerits_join.GetValue() as Float, False, True, _SDGVP_config_verboseMerits.GetValueInt() as Bool )
		
		_SDDVP_buyoutEarned.Mod( 0 - iGold )
		Debug.Notification( iGold + " deducted from the gold earned for your freedom." )
		kMaster.GetCrimeFaction().PlayerPayCrimeGold( True, False )

		Debug.Notification( "[_sdras_master] You will regret attacking me!" )
		; Punishment
		; _SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 3, aiValue2 = RandomInt( 0, _SDGVP_punishments.GetValueInt() ) )

		; Whipping
		_SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 5 )

	ElseIf ( aeCombatState == 0 )
		GoToState("monitor")
	Else
		GoToState("combat")
	EndIf
EndEvent

Event OnLostLOS(Actor akViewer, ObjectReference akTarget)
	If (kMaster) && (kSlave)

		If ( kMaster.GetDistance( kSlave ) > _SDGVP_escape_radius.GetValue() / 4.0 )
			GoToState("search")
		EndIf
		
		enslavement.bSearchForSlave = True
		fSlaveLastSeen = GetCurrentRealTime()
	EndIf
EndEvent

Event OnGainLOS(Actor akViewer, ObjectReference akTarget)
	If (kMaster) && (kSlave)
		kMaster.ClearLookAt()
		enslavement.bSearchForSlave = False

		fSlaveLastSeen = GetCurrentRealTime()
		fLibido += 2.5

		If ( kSlave.GetEquippedWeapon() || kSlave.GetEquippedWeapon( True ) )
			If ( _SDGVP_demerits.GetValue() > -5.0 )
				GoToState("combat")
				kMaster.SetAlert()
				Debug.Trace("[_sdras_master] Armed slave - Stop enslavement")

				Self.GetOwningQuest().Stop()
			Else
			
			EndIf
		EndIf
	EndIf
EndEvent

	
Event OnInit()

		kMaster = _SDRAP_master.GetReference() as Actor
		kSlave = _SDRAP_slave.GetReference() as Actor

		Utility.Wait(5)
		; Welcome scene to replace rape after defeat
		Int iRandomNum = Utility.RandomInt(0,100)

		if (iRandomNum>80)
			; Punishment
			_SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 3, aiValue2 = RandomInt( 0, _SDGVP_punishments.GetValueInt() ) )
		ElseIf (iRandomNum>50)
			; Whipping
			_SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 5 )
		Else
			; Sex
			_SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 0, aiValue2 = RandomInt( 0, _SDGVP_positions.GetValueInt() ) )
		EndIf
		
	If ( Self.GetOwningQuest() )
		RegisterForSingleUpdate( fRFSU )
	EndIf
	GoToState("waiting")
EndEvent

State waiting
	Event OnUpdate()
		If ( Self.GetOwningQuest().IsRunning() )
			distanceAverage = 0
			GoToState("monitor")
		EndIf
		If ( Self.GetOwningQuest() )
			RegisterForSingleUpdate( fRFSU )
		EndIf
	EndEvent
EndState

State monitor
	Event OnBeginState()
		fSlaveFreeTime = _SDGV_free_time.GetValue()
		fLeashLength = _SDGV_leash_length.GetValue()
		enslavement.bSearchForSlave = True
		fSlaveLastSeen = GetCurrentRealTime()
		fLibido = 0.0
		
		kMaster = _SDRAP_master.GetReference() as Actor
		kSlave = _SDRAP_slave.GetReference() as Actor
		kBindings = _SDRAP_bindings.GetReference() as ObjectReference
		kCrop = _SDRAP_crop.GetReference().GetBaseObject() as Weapon

		RegisterForLOS( kMaster, kSlave )
		RegisterForSingleUpdate( fRFSU )
	EndEvent
	
	Event OnEndState()
		UnregisterForLOS( kMaster, kSlave )
	EndEvent

	Event OnUpdate()
		While ( !Game.GetPlayer().Is3DLoaded() )
		EndWhile

		distance = kMaster.GetDistance( kSlave )
		
		If ( distanceAverage == 0 )
			distanceAverage = distance
		Else
			distanceAverage = ( distance + distanceAverage ) / 2
		EndIf

		kCombatTarget = kSlave.GetCombatTarget()
		bSlaveDetectedByMaster = kSlave.IsDetectedBy(kMaster)
		bSlaveDetectedByTarget = ( kCombatTarget && kSlave.IsDetectedBy(kCombatTarget) )
		bTargetMaster = ( kCombatTarget && kCombatTarget == kMaster )
		bTargetAllied = ( kCombatTarget && kCombatTarget != kMaster && funct.actorFactionInList(kCombatTarget, _SDFLP_forced_allied) )
		iCheckdemerits = _SDGVP_demerits.GetValueInt()
		
		If ( !kMaster || !kSlave || kMaster.IsDisabled() || kMaster.IsDead())
			Debug.Trace("[_sdras_master] Master dead or disabled - Stop enslavement")

			Self.GetOwningQuest().Stop()
		ElseIf ( _SDGV_leash_length.GetValue() == -10) ; escape trigger in some situations
		;	If (RandomInt( 0, 100 ) > 80 )
		;		Debug.Notification( "Get out of here!...")
		;	EndIf
		;	enslavement.bEscapedSlave = False
		;	enslavement.bSearchForSlave = False
		;	Self.GetOwningQuest().Stop()
			_SDGV_leash_length.SetValue(400)
		ElseIf ( Self.GetOwningQuest().IsStopping() || Self.GetOwningQuest().IsStopped() )
			GoToState("waiting")
		ElseIf ((kSlave.GetParentCell() == kMaster.GetParentCell()) && (kMaster.GetParentCell().IsInterior()))
			If (RandomInt( 0, 100 ) > 95 )
				Debug.Notification( "Your captors are watching...")
			EndIf
			GoToState("waiting")
		ElseIf ( !Game.IsMovementControlsEnabled() || kMaster.GetCurrentScene() || kSlave.GetCurrentScene() )
			fSlaveLastSeen = GetCurrentRealTime()
			enslavement.bEscapedSlave = False
			enslavement.bSearchForSlave = False
		ElseIf ( Self.GetOwningQuest().GetStage() >= 90 || _SDCP_sanguines_realms.Find( kSlave.GetParentCell() ) > -1 )
			fSlaveLastSeen = GetCurrentRealTime()
			enslavement.bEscapedSlave = False
			enslavement.bSearchForSlave = False
		ElseIf ( _SDGVP_state_caged.GetValueInt() )
			GoToState("caged")
		ElseIf ( kMaster.IsInCombat() || kSlave.IsInCombat() )
			GoToState("combat")
		ElseIf ( enslavement.bSearchForSlave || GetCurrentRealTime() - fSlaveLastSeen > fSlaveFreeTime )
			GoToState("search")
		ElseIf ( false && kSlave.IsWeaponDrawn() && ( bSlaveDetectedByMaster || bSlaveDetectedByTarget ))
			; Skipped - Not working as intended - especially under magic attack
			; Should be detection of an attack by slave against master

			If ( bTargetMaster || bTargetAllied )
				If ( bSlaveDetectedByMaster )
					kMaster.StartCombat( kSlave )
				EndIf
				If ( bSlaveDetectedByTarget )
					kCombatTarget.StartCombat( kSlave )
				EndIf
				Debug.Trace("[_sdras_master] Slave attacking - Stop enslavement")

				Self.GetOwningQuest().Stop()
			Else
				funct.actorCombatShutdown( kSlave )
				funct.actorCombatShutdown( kCombatTarget )
				If ( bSlaveDetectedByMaster )
					; Self.GetOwningQuest().ModObjectiveGlobal( 10.0, _SDGVP_demerits, 3, _SDGVP_demerits_join.GetValue() as Float, False, True, _SDGVP_config_verboseMerits.GetValueInt() as Bool )


					Debug.Notification( "Your owner pushes you down on your knees." )
					; Whipping
						_SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 5 )
				EndIf
				If ( bSlaveDetectedByTarget )
					; Debug.Notification( "Your owner is getting angry" )
					; Whipping
					;	_SDKP_sex.SendStoryEvent(akRef1 = kCombatTarget, akRef2 = kSlave, aiValue1 = 5 )
				EndIf
			EndIf
		ElseIf ( (enslavement.uiLastDemerits < iCheckdemerits)  && ((kSlave.GetParentCell() != kMaster.GetParentCell()) || (!kMaster.GetParentCell().IsInterior()))  )
			Debug.Notification( "Your owner is losing patience" )
				
			Self.GetOwningQuest().ModObjectiveGlobal( 1.0, _SDGVP_demerits, -1, _SDGVP_demerits_join.GetValue() as Float, False, True, _SDGVP_config_verboseMerits.GetValueInt() as Bool )

			; add punishment
			If ( _SDGVP_demerits.GetValueInt() < 10 )
				; Whipping
				; _SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 5 )

			Else
				; Punishment
				; _SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 3, aiValue2 = RandomInt( 0, _SDGVP_punishments.GetValueInt() ) )
				
			EndIf
			enslavement.uiLastDemerits = iCheckdemerits
		ElseIf ( enslavement.uiLastDemerits > iCheckdemerits && (kSlave.GetParentCell() == kMaster.GetParentCell()) && (kMaster.GetParentCell().IsInterior())  )
			; Remove punishment
			; _SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 6 )
			enslavement.uiLastDemerits = iCheckdemerits
		Else
			fSlaveLastSeen = GetCurrentRealTime()

			If ( _SDQP_enslavement_tasks.IsRunning() )
				kNPC = funct.findClosestHostileActorToActor( kMaster, 1000.0 )
				If ( kNPC != kSlave && kNPC != None )
					Debug.MessageBox( "$SD_MESSAGE_MASTER_SUSPICIOUS" )
					Debug.Trace( "_SD:: ending tasks due to near hostile" )
					_SDQP_enslavement_tasks.FailAllObjectives()
					_SDQP_enslavement_tasks.Stop()
				EndIf
				
				If ( distance > fLeashLength )
					kMaster.EvaluatePackage()
				EndIf
			ElseIf ( distance <= fLeashLength )
				fSlaveFreeTime += 0.05
				enslavement.bSearchForSlave = False

			ElseIf ( RandomFloat( 0.0, 100.0 ) < fLibido )
				fLibido = 0.0
				Self.GetOwningQuest().ModObjectiveGlobal( -1.0, _SDGVP_demerits, -1, _SDGVP_demerits_join.GetValue() as Float, False, True, _SDGVP_config_verboseMerits.GetValueInt() as Bool )

				_SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 0, aiValue2 = RandomInt( 0, _SDGVP_positions.GetValueInt() ) )

			EndIf		
		EndIf
			
		If ( Self.GetOwningQuest() && !(Self.GetOwningQuest().IsStopping() || Self.GetOwningQuest().IsStopped()))
            RegisterForSingleUpdate( fRFSU )
        EndIf
	EndEvent

	Event OnUpdateGameTime()
		kMaster.EvaluatePackage()
		
		If ( distanceAverage < 256 )
			Self.GetOwningQuest().ModObjectiveGlobal( -1.0, _SDGVP_demerits, -1, _SDGVP_demerits_join.GetValue() as Float, False, True, _SDGVP_config_verboseMerits.GetValueInt() as Bool )
		EndIf
		
		If ( Self.GetOwningQuest() )
			RegisterForSingleUpdateGameTime( fRFSUGT )
		EndIf
	EndEvent	
	
	Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
		iuType = akBaseItem.GetType()

		If ( akBaseItem.HasKeyword( _SDKP_food ) || akBaseItem.HasKeyword( _SDKP_food_raw ) )

		ElseIf ( iuType == 26 || iuType == 41 || iuType == 42 )
		
		ElseIf ( _SDQP_enslavement_tasks.IsRunning() && _SDFLP_trade_items.HasForm( akBaseItem ) && akSourceContainer == kSlave as ObjectReference )
			If ( tasks._SDBP_task_complete )
				fGoldEarned = akBaseItem.GetGoldValue()
			Else
				fGoldEarned = Math.Floor( akBaseItem.GetGoldValue() / 4 )
			EndIf

			If ( Self.GetOwningQuest().ModObjectiveGlobal( fGoldEarned, _SDGVP_buyoutEarned, 2, _SDGVP_buyout.value ) )
				Self.GetOwningQuest().SetObjectiveDisplayed( 90 )
			EndIf
		EndIf
	EndEvent

	Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
		If ( akAggressor == kSlave )
			; Disabled for now - seems to conflict with other mods 
			; Handle attacks by slave differently

			; bAttackedBySlave = True
			; kMaster.SetLookAt( kSlave )
			; kMaster.StartCombat( kSlave )
			; Debug.Trace("[_sdras_master] Master hit by slave - Stop enslavement")

			; Self.GetOwningQuest().Stop()
		EndIf
	EndEvent
EndState

State search
	Event OnBeginState()
		kMaster.EvaluatePackage()
		RegisterForLOS( kMaster, kSlave )
	EndEvent
	
	Event OnEndState()
		kMaster.EvaluatePackage()
		UnregisterForLOS( kMaster, kSlave )
	EndEvent

	Event OnGainLOS(Actor akViewer, ObjectReference akTarget)
		enslavement.bSearchForSlave = False
		kMaster.EvaluatePackage()
	EndEvent

	Event OnDeath(Actor akKiller)
		Debug.Trace("[_sdras_master] Master death event - Stop enslavement")

		Self.GetOwningQuest().Stop()
	EndEvent

	Event OnUpdate()
		While ( !Game.GetPlayer().Is3DLoaded() )
		EndWhile
		
		If ( !kMaster || kMaster.IsDisabled() )
			Debug.Trace("[_sdras_master] Master dead in search - Stop enslavement")

			Self.GetOwningQuest().Stop()
		ElseIf (( kMaster.GetDistance( kSlave ) <= _SDGV_leash_length.GetValue() )  && ( _SDGV_leash_length.GetValue() > 0))
			GoToState("monitor")
			enslavement.bEscapedSlave = False
			enslavement.bSearchForSlave = False
			kMaster.EvaluatePackage()
		EndIf
		
		If ( Self.GetOwningQuest() )
			RegisterForSingleUpdate( fRFSU )
		EndIf
	EndEvent	
EndState

State combat
	Event OnBeginState()
		If ( kMaster.GetCurrentScene() )
			kMaster.GetCurrentScene().Stop()
		EndIf
	EndEvent
	
	Event OnEndState()
	EndEvent

	Event OnUpdate()
		While ( !Game.GetPlayer().Is3DLoaded() )
		EndWhile

		If ( !kMaster || kMaster.IsDisabled() )
			Debug.Trace("[_sdras_master] Master dead in combat- Stop enslavement")

			Self.GetOwningQuest().Stop()
		ElseIf ( Self.GetOwningQuest().IsStopping() || Self.GetOwningQuest().IsStopped() )
			GoToState("waiting")
		ElseIf ( !kMaster.IsInCombat() && !kSlave.IsInCombat() )
			GoToState("monitor")
		ElseIf ( !enslavement.bSearchForSlave && kMaster.GetDistance( kSlave ) > _SDGVP_escape_radius.GetValue() / 2.0 )
			enslavement.bSearchForSlave = True
			GoToState("search")
		EndIf
		
		If ( Self.GetOwningQuest() )
			RegisterForSingleUpdate( fRFSU )
		EndIf
	EndEvent
EndState

State caged
	Event OnBeginState()
	EndEvent
	
	Event OnEndState()
	EndEvent

	Event OnUpdate()
		While ( !Game.GetPlayer().Is3DLoaded() )
		EndWhile
		
		If ( !kMaster || kMaster.IsDisabled() )
			Debug.Trace("[_sdras_master] Master dead in caged - Stop enslavement")

			Self.GetOwningQuest().Stop()
		ElseIf ( !_SDGVP_state_caged.GetValueInt() )
			GoToState("monitor")
		EndIf

		If ( Self.GetOwningQuest() )
			RegisterForSingleUpdate( fRFSU )
		EndIf
	EndEvent
EndState
