Scriptname _SDRAS_master extends ReferenceAlias Conditional
{ USED }
Import Utility

SexLabFramework Property SexLab  Auto  
daymoyl_MonitorVariables 	Property Variables Auto
_SDQS_functions Property funct  Auto
_SDQS_fcts_constraints Property fctConstraints  Auto
_SDQS_fcts_inventory Property fctInventory  Auto
_SDQS_fcts_factions Property fctFactions  Auto
_SDQS_fcts_slavery Property fctSlavery  Auto

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
GlobalVariable Property _SDGVP_state_MasterFollowSlave  Auto  
GlobalVariable Property _SDGVP_health_threshold Auto

LocationAlias Property _SDLAP_masters_location  Auto  

ReferenceAlias Property _SDRAP_slave  Auto
ReferenceAlias Property _SDRAP_master  Auto
ReferenceAlias Property _SDRAP_bindings  Auto
ReferenceAlias Property _SDRAP_crop  Auto  
ReferenceAlias Property _SDRAP_playerStorage  Auto  

FormList Property _SDFLP_slavers  Auto  
FormList Property _SDFLP_trade_items  Auto
FormList Property _SDFLP_banned_factions  Auto  
FormList Property _SDFLP_forced_allied  Auto  

Keyword Property _SDKP_spriggan  Auto  
Keyword Property _SDKP_sex  Auto  
Keyword Property _SDKP_enslave  Auto
Keyword Property _SDKP_master  Auto
Keyword Property _SDKP_food  Auto  
Keyword Property _SDKP_food_raw  Auto  

Package[] Property _SDPP_stall_package  Auto  

Spell Property _SDSP_SelfShockEffect  Auto  

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
Float fMasterDistance
Float fGoldEarned
Int count
Int index
Int iRelationship
Int iCheckdemerits
Int iuType

Actor kMaster
Actor kSlave
Actor kCombatTarget
Actor kLeashCenter
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
	; Master dead - Escape and transfer of ownership 
	Debug.Trace("[_sdras_master] Master dead - Stop enslavement")

	ObjectReference  kPlayerStorage = _SDRAP_playerStorage.GetReference()

	; Move all items back from Sanguine Storage into Master
	kPlayerStorage.RemoveAllItems(akTransferTo = kMaster as ObjectReference, abKeepOwnership = True)
	Wait(2.0)
	
	; SendModEvent("PCSubFree")
	; It may be better to directly stop the quest here instead of relying on Mod Events

	Self.GetOwningQuest().Stop()

	If (akKiller)
		If (GetState() != "search") && (akKiller != kSlave) &&  fctFactions.checkIfSlaver (  akKiller )
			; new master
			While ( Self.GetOwningQuest().IsStopping() )
			EndWhile

			; New enslavement - changing ownership
			_SDKP_enslave.SendStoryEvent(akRef1 = akKiller, akRef2 = kSlave, aiValue1 = 0)
			
				;kMaster = _SDRAP_master.GetReference() as Actor
				;kSlave = _SDRAP_slave.GetReference() as Actor
			Wait(7.0)

			; Welcome scene after changing ownership 
			Int iRandomNum = RandomInt(0,100)
			Debug.Notification( "You are mine!" )
			Wait(3.0) 
			If (iRandomNum > 75)
				; Punishment
				_SDKP_sex.SendStoryEvent(akRef1 = akKiller, akRef2 = kSlave, aiValue1 = 3, aiValue2 = RandomInt( 0, _SDGVP_punishments.GetValueInt() ) )
			ElseIf (iRandomNum > 50)
				; Whipping
				_SDKP_sex.SendStoryEvent(akRef1 = akKiller, akRef2 = kSlave, aiValue1 = 5 )
			ElseIf (iRandomNum > 25)
				enslavement.PunishSlave(akKiller,kSlave)
			Else
				; Sex
				_SDKP_sex.SendStoryEvent(akRef1 = akKiller, akRef2 = kSlave, aiValue1 = 0, aiValue2 = RandomInt( 0, _SDGVP_positions.GetValueInt() ) )
			EndIf
			
		EndIf
	EndIf
EndEvent

Event OnEnterBleedout()
	if (kMaster.IsEssential()) && (Variables.FollowerSetting==0)
		Debug.Trace("[_sdras_master] Essential master bleeding out - Stop enslavement")
		SendModEvent("PCSubFree")
		; Self.GetOwningQuest().Stop()
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

	; most likely to happen on a pickpocket failure.
	If ( (aeCombatState != 0) && (akTarget == kSlave) && (!kMaster.GetCurrentScene()) && (Self.GetOwningQuest().GetStage() < 90) )
		Int iGold = 100
		Float iDemerits = 10.0

		fctConstraints.actorCombatShutdown( kMaster )
		fctConstraints.actorCombatShutdown( kSlave )
		
		If ( kMaster.GetCrimeFaction() )
			iGold = kMaster.GetCrimeFaction().GetCrimeGold()
			iDemerits = Math.Ceiling( iGold / 100 ) as Float
		EndIf

		_SDDVP_buyoutEarned.Mod( 0 - iGold )
		Debug.Notification( iGold + " deducted from the gold earned for your freedom." )
		kMaster.GetCrimeFaction().PlayerPayCrimeGold( True, False )

		Debug.Notification( "You will regret attacking me!" )
		_SDSP_SelfShockEffect.Cast(kSlave as Actor)
		
		; Punishment
		If (RandomInt(0,10)> 5)
			_SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 3, aiValue2 = RandomInt( 0, _SDGVP_punishments.GetValueInt() ) )
		Else
			; Whipping
			_SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 5 )
		EndIf
		Wait(1.0)
		enslavement.PunishSlave(kMaster,kSlave)

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
			; Slave detected by Master holding a weapon
			; 	GoToState("combat")
			; 	kMaster.SetAlert()
			; 	Debug.Trace("[_sdras_master] Armed slave - Stop enslavement")
			; 
			; 	Self.GetOwningQuest().Stop()
		EndIf
	EndIf
EndEvent

	
Event OnInit()

	kMaster = _SDRAP_master.GetReference() as Actor
	kSlave = _SDRAP_slave.GetReference() as Actor

	Utility.Wait(5.0)
	; Welcome scene to replace rape after defeat
	Int iRandomNum = Utility.RandomInt(0,100)

	if (iRandomNum > 75)
		; Punishment
		enslavement.PunishSlave(kMaster,kSlave)
		_SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 3, aiValue2 = RandomInt( 0, _SDGVP_punishments.GetValueInt() ) )
	ElseIf (iRandomNum > 50)
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

		; Master variable updates
		_SDGVP_state_MasterFollowSlave.SetValue( StorageUtil.GetIntValue(kSlave, "_SD_iFollowSlave") )
		kLeashCenter =  StorageUtil.GetFormValue(kSlave, "_SD_LeashCenter") as Actor

		if (kLeashCenter == None)
			fctConstraints.setLeashCenterRef(kMaster as ObjectReference)
			kLeashCenter = kMaster
		EndIf

		fMasterDistance = kSlave.GetDistance( kMaster )
		distance = kSlave.GetDistance( kLeashCenter )

		If ( distanceAverage == 0 )
			distanceAverage = distance
		Else
			distanceAverage = ( distance + distanceAverage ) / 2
		EndIf

		kCombatTarget = kSlave.GetCombatTarget()
		bSlaveDetectedByMaster = kSlave.IsDetectedBy(kMaster)
		bSlaveDetectedByTarget = ( kCombatTarget && kSlave.IsDetectedBy(kCombatTarget) )
		bTargetMaster = ( kCombatTarget && kCombatTarget == kMaster )
		bTargetAllied = ( kCombatTarget && kCombatTarget != kMaster && fctFactions.actorFactionInList(kCombatTarget, _SDFLP_forced_allied) )
		iCheckdemerits = _SDGVP_demerits.GetValueInt()
		
		If ( !kMaster || !kSlave || kMaster.IsDisabled() || kMaster.IsDead() || ( kMaster.IsEssential() && (kMaster.IsBleedingOut()) || (kMaster.IsUnconscious()) ) )
			Debug.Trace("[_sdras_master] Master dead or disabled - Stop enslavement")

			; Self.GetOwningQuest().Stop()
			SendModEvent("PCSubFree")

		ElseIf ( Self.GetOwningQuest().IsStopping() || Self.GetOwningQuest().IsStopped() )
			; Park Master in Waiting mode while Enslavement quest is shutting down
			GoToState("waiting")

		ElseIf (kSlave.GetParentCell() == kMaster.GetParentCell())  &&  (kMaster.GetParentCell().IsInterior()) && ( ( kMaster.GetSleepState() == 0 )  || (StorageUtil.GetIntValue(kSlave, "_SD_iTrust") > 0) )  
			; If master and slave are in the same interior cell
			If (RandomInt( 0, 100 ) > 95 )
				Debug.Notification( "Your captors are watching...")
			EndIf
			GoToState("waiting")

		ElseIf ( !Game.IsMovementControlsEnabled() || kMaster.GetCurrentScene() || kSlave.GetCurrentScene() )
			; Slave is locked in place somewhere,
			; Add events here - master checking on slave, random punishment...

			fSlaveLastSeen = GetCurrentRealTime()
			enslavement.bEscapedSlave = False
			enslavement.bSearchForSlave = False

			if (fMasterDistance < StorageUtil.GetIntValue(kSlave, "_SD_iLeashLength"))
				Int iRandomNum = Utility.RandomInt(0,100)

				if (iRandomNum > 75)
					; Punishment
					enslavement.PunishSlave(kMaster,kSlave)
					_SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 3, aiValue2 = RandomInt( 0, _SDGVP_punishments.GetValueInt() ) )
				ElseIf (iRandomNum > 50)
					; Whipping
					_SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 5 )
				Else
					; Sex
					_SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 0, aiValue2 = RandomInt( 0, _SDGVP_positions.GetValueInt() ) )
				EndIf
			EndIf

		ElseIf ( Self.GetOwningQuest().GetStage() >= 90 ) ; || _SDCP_sanguines_realms.Find( kSlave.GetParentCell() ) > -1 )
			; Grace period after slave rejects master's offer to join
			fSlaveLastSeen = GetCurrentRealTime()
			enslavement.bEscapedSlave = False
			enslavement.bSearchForSlave = False

		ElseIf ( _SDGVP_state_caged.GetValueInt() )
			; Caged state
			GoToState("caged")

		ElseIf ( kMaster.IsInCombat() || kSlave.IsInCombat() )
			; Combat state
			GoToState("combat")

		ElseIf ( enslavement.bSearchForSlave || GetCurrentRealTime() - fSlaveLastSeen > fSlaveFreeTime )
			; Master is looking for slave
			GoToState("search")

		ElseIf (   kSlave.IsWeaponDrawn() && ( bSlaveDetectedByMaster || bSlaveDetectedByTarget ))
			; Slave is drawing a weapon in front of master

			If (!fctSlavery.CheckSlavePrivilege(kSlave, "_SD_iEnableFight")) 
				Debug.Notification( "Who said you could fight, Slave!")

				; Drop current weapon 

				Weapon krHand = kSlave.GetEquippedWeapon()
				Weapon klHand = kSlave.GetEquippedWeapon( True )
				If ( krHand )
				;	kSlave.DropObject( krHand )
					kSlave.UnequipItem( krHand )
				EndIf
				If ( klHand )
				;	kSlave.DropObject( klHand )
					kSlave.UnequipItem( klHand )
				EndIf 
			EndIf

		ElseIf (((kSlave.GetEquippedItemType(0) != 0)||(kSlave.GetEquippedItemType(1) != 0)) && ( bSlaveDetectedByMaster || bSlaveDetectedByTarget ))
			; If slave equips a weapon or spell in front of master
			Wait(1.0)

			; Skipped - Not working as intended - especially under magic attack
			; Should be detection of an attack by slave against master
			If (!fctSlavery.CheckSlavePrivilege(kSlave, "_SD_iEnableFight")) 
				Debug.Notification( "Who said you could fight, Slave!")
 
			ElseIf ((kSlave.GetEquippedItemType(0) == 9)||(kSlave.GetEquippedItemType(1) == 9 ))  && ( (!fctSlavery.CheckSlavePrivilege(kSlave, "_SD_iEnableSpellEquip")) && (!fctSlavery.CheckSlavePrivilege(kSlave, "_SD_iEnableShoutEquip")) )
				Debug.Notification( "You better unequip that spell before I make you swallow it, Slave!")

			;ElseIf ((kSlave.GetEquippedItemType(0) == 11)||(kSlave.GetEquippedItemType(1) == 11))
			;	Debug.Notification( "Hold that torch higher, Slave!" )

			Else
				Debug.Notification( "Better unequip that before I shove it up your ass, Slave!" )

			EndIf
			Wait(5.0)

			If ( bTargetMaster || bTargetAllied )
				; Slave attacks master

				If ( bSlaveDetectedByMaster )
				;	kMaster.StartCombat( kSlave )
				EndIf
				If ( bSlaveDetectedByTarget )
				;	kCombatTarget.StartCombat( kSlave )
				EndIf
				; Debug.Trace("[_sdras_master] Slave attacking - Stop enslavement")

				; Self.GetOwningQuest().Stop()
				; SendModEvent("PCSubFree")

				Wait(0.5)
				; kSlave.PlayAnimation("ZazAPC055");Inte
				; Wait(1.0)
				Debug.Notification( "You will regret this!" )
				; Whipping
					_SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 3 )

			ElseIf (Utility.RandomInt(0,100)>90) ; chance of attack failing and slave punished
				fctConstraints.actorCombatShutdown( kSlave )
				fctConstraints.actorCombatShutdown( kCombatTarget )

				If ( bSlaveDetectedByMaster )
					; Self.GetOwningQuest().ModObjectiveGlobal( 10.0, _SDGVP_demerits, 3, _SDGVP_demerits_join.GetValue() as Float, False, True, _SDGVP_config_verboseMerits.GetValueInt() as Bool )
					Wait(0.5)
					kSlave.PlayAnimation("ZazAPC055");Inte
					Wait(1.0)
					Debug.Notification( "Your owner pushes you down to your knees!" )
					; Whipping
						_SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 5 )
				EndIf

				If ( bSlaveDetectedByTarget )
					Debug.Notification( "Your owner wouldn't like that!" )
					; Whipping
					kSlave.PlayAnimation("ZazAPC055");Inte
					Wait(0.5)
					_SDKP_sex.SendStoryEvent(akRef1 = kCombatTarget, akRef2 = kSlave, aiValue1 = 5 )
				EndIf
			EndIf

		ElseIf ((kSlave.GetParentCell() != kMaster.GetParentCell()) && (kMaster.GetParentCell().IsInterior()) && (!_SDGVP_state_caged.GetValueInt())) && (StorageUtil.GetIntValue(kSlave, "_SD_iTrust") < 0)
			; Master is looking for slave (if not trusted)
			; TO DO - Check if this really works with new collar / leash system

			Debug.Notification( "Your owner is looking for you!" )
			Wait(5.0)	

			If (bSlaveDetectedByMaster)
				Debug.Notification( "There you are Slave... get your punishment, over here!" )
				; add punishment
				If ( _SDGVP_demerits.GetValueInt() > 20 )
					; Whipping
				 	_SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 5 )
				Else
					; Punishment
				 	_SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 3, aiValue2 = RandomInt( 0, _SDGVP_punishments.GetValueInt() ) )
				EndIf
			EndIf

		Else

			fSlaveLastSeen = GetCurrentRealTime()

			If ( fMasterDistance <= StorageUtil.GetIntValue(kSlave, "_SD_iLeashLength") )
				fSlaveFreeTime += 0.05
				enslavement.bSearchForSlave = False

				If ( kMaster.WornHasKeyword( _SDKP_spriggan ) && (StorageUtil.GetIntValue(Game.GetPlayer(), "_SD_iSprigganInfected") != 1) ) && (Utility.RandomInt(0,100)<=_SDGVP_health_threshold.GetValue())
					; Chance of spriggan infection if slave in close proximity of infected master
					SendModEvent("SDSprigganEnslaved")
					
				ElseIf ( RandomFloat( 0.0, 100.0 ) < fLibido )
					; TO DO - Update this code with checks on SL Aroused level for Master

					fLibido = 0.0
	 
					_SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 0, aiValue2 = RandomInt( 0, _SDGVP_positions.GetValueInt() ) )

				ElseIf (StorageUtil.GetIntValue(kMaster, "_SD_iDisposition") > 0) && (Utility.RandomInt(0,100) < StorageUtil.GetIntValue(kMaster, "_SD_iDisposition") ) 
					; Master is in a good mood - chance to remove punishment

					enslavement.RewardSlave(kMaster,kSlave)

				EndIf
			EndIf

		
		EndIf
			
		If ( Self.GetOwningQuest() && !(Self.GetOwningQuest().IsStopping() || Self.GetOwningQuest().IsStopped()))
            RegisterForSingleUpdate( fRFSU )
        EndIf
	EndEvent

	Event OnUpdateGameTime()
		kMaster.EvaluatePackage()
		
		If ( distanceAverage < 256 )
			; Slave remainse close to master on average
			; TO DO - Add bonus to master disposition?
		EndIf
		
		If ( Self.GetOwningQuest() )
			RegisterForSingleUpdateGameTime( fRFSUGT )
		EndIf
	EndEvent	
	
	Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
		iuType = akBaseItem.GetType()
		fGoldEarned = 0.0

		If ( akBaseItem.HasKeyword( _SDKP_food ) || akBaseItem.HasKeyword( _SDKP_food_raw ) )
			; Master receives Food

			If ( StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryLevel") >= 3 )
				Debug.Notification("Mmm.. that should hit the spot.")
				fctSlavery.UpdateSlaveStatus( Game.GetPlayer(), "_SD_iGoalFood", modValue = 1)
			Else
				Debug.Notification("Well? What are you waiting for?.")
				Debug.Notification("Get back to work slave!")
			EndIf

		ElseIf ( iuType == 26 || iuType == 41 || iuType == 42 )
			; Weapon
		
		Else 
			; Add code to match received items against Master's needs
			; Update Master's mood and trust

		 	If ( StorageUtil.GetIntValue(kMaster, "_SD_iDisposition") > 0 )
		 		fGoldEarned = akBaseItem.GetGoldValue()
			Else
				fGoldEarned = Math.Floor( akBaseItem.GetGoldValue() / 4 )
			EndIf

			If (fGoldEarned > 0) && ( StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryLevel") >= 2 )
				Debug.Notification("Good slave... keep it coming.")
				fctSlavery.UpdateSlaveStatus( Game.GetPlayer(), "_SD_iGoalGold", modValue = fGoldEarned as Int)
			Else
				Debug.Notification("That's right.")
				Debug.Notification("You don't have a use for gold anymore.")
			EndIf

			; TO DO - Master reaction if slave reaches buyout amount

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
			Debug.Notification("Watch what you are doing!!")
			_SDSP_SelfShockEffect.Cast(kSlave as Actor)

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

		SendModEvent("PCSubFree")
		; Self.GetOwningQuest().Stop()
	EndEvent

	Event OnUpdate()
		While ( !Game.GetPlayer().Is3DLoaded() )
		EndWhile
		
		If ( !kMaster || kMaster.IsDisabled() )
			Debug.Trace("[_sdras_master] Master dead in search - Stop enslavement")

			SendModEvent("PCSubFree")
			; Self.GetOwningQuest().Stop()

		ElseIf ( kMaster.GetDistance( kSlave ) <= StorageUtil.GetIntValue(kSlave, "_SD_iLeashLength") ) 
			; Slave is back, next to master
			enslavement.bEscapedSlave = False
			enslavement.bSearchForSlave = False
			kMaster.EvaluatePackage()

			GoToState("monitor")

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

			SendModEvent("PCSubFree")
			; Self.GetOwningQuest().Stop()

		ElseIf ( Self.GetOwningQuest().IsStopping() || Self.GetOwningQuest().IsStopped() )
			GoToState("waiting")

		ElseIf ( !kMaster.IsInCombat() && !kSlave.IsInCombat() )
			GoToState("monitor")
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

			SendModEvent("PCSubFree")
			; Self.GetOwningQuest().Stop()
		ElseIf ( !_SDGVP_state_caged.GetValueInt() )
			GoToState("monitor")
		EndIf

		If ( Self.GetOwningQuest() )
			RegisterForSingleUpdate( fRFSU )
		EndIf
	EndEvent
EndState

