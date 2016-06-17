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
Quest Property _SDQP_enslavement Auto
Cell[] Property _SDCP_sanguines_realms  Auto  

GlobalVariable Property _SDGV_leash_length  Auto
GlobalVariable Property _SDGV_free_time  Auto
GlobalVariable Property _SDGVP_positions  Auto  
GlobalVariable Property _SDGVP_punishments  Auto  
GlobalVariable Property _SDGVP_demerits  Auto 
GlobalVariable Property _SDGVP_demerits_join  Auto  
GlobalVariable Property _SDGVP_join_days  Auto  
GlobalVariable Property _SDGVP_can_join  Auto  
GlobalVariable Property _SDGVP_buyout  Auto  
GlobalVariable Property _SDGVP_buyoutEarned  Auto  
GlobalVariable Property _SDGVP_escape_radius  Auto  
GlobalVariable Property _SDGVP_config_verboseMerits  Auto
GlobalVariable Property _SDDVP_buyoutEarned  Auto
GlobalVariable Property _SDGVP_state_caged  Auto  
GlobalVariable Property _SDGVP_state_MasterFollowSlave  Auto  
GlobalVariable Property _SDGVP_health_threshold Auto
GlobalVariable Property _SDGVP_config_healthMult Auto

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
Keyword Property _SDKP_spriggan_infected  Auto  
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

	If (kSlave.GetDistance( kMaster ) <= (StorageUtil.GetIntValue(kSlave, "_SD_iLeashLength") * 3.0))
		; Move all items back from Sanguine Storage into Master if slave is nearby
		kPlayerStorage.RemoveAllItems(akTransferTo = kMaster as ObjectReference, abKeepOwnership = True)
		Wait(2.0)
	EndIf
	
	; SendModEvent("PCSubFree")
	; It may be better to directly stop the quest here instead of relying on Mod Events

	If (akKiller)
		Debug.Trace("[_sdras_master] Master killed by: " + akKiller)

		If (GetState() != "search") && (akKiller != kSlave) &&  (fctFactions.checkIfSlaver (  akKiller ) || fctFactions.checkIfSlaverCreature (  akKiller ) ) &&  !fctFactions.checkIfFollower (  akKiller ) 
			; Followers are not allowed to forcefully take the player as a slave to prevent friendly fire or rescue
			; Only voluntary submission to followers is allowed

			; Send all items back to Dreamworld storage
			kMaster.RemoveAllItems(akTransferTo = _SDRAP_playerStorage.GetReference(), abKeepOwnership = True)

			If (Utility.RandomInt(0,100)>60)
				SendModEvent("PCSubFree")
			ElseIf (akKiller != kMaster)
				Debug.Notification( "A new owner grabs you." )
				Debug.Trace("[_sdras_master] Start enslavement with:"  + akKiller)
				; StorageUtil.SetFormValue( Game.getPlayer() , "_SD_TempAggressor", akKiller)

				akKiller.SendModEvent("PCSubTransfer") ; Whipping
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
			; iDemerits = Math.Ceiling( iGold / 100 ) as Float

			; _SDDVP_buyoutEarned.Mod( 0 - iGold )
			If (iGold > _SDDVP_buyoutEarned.GetValue() )
				_SDDVP_buyoutEarned.SetValue(0)
			Else
				_SDDVP_buyoutEarned.Mod( 0 - iGold )
			EndIf

			; Debug.Notification( iGold + " deducted from the gold earned for your freedom." )
			kMaster.GetCrimeFaction().PlayerPayCrimeGold( True, False )

		EndIf

		If (StorageUtil.GetIntValue(kMaster, "_SD_iMasterIsCreature") == 0)
			Debug.Notification( "You will regret attacking me!" )
		EndIf
		_SDSP_SelfShockEffect.Cast(kSlave as Actor)
		
		If (fctSlavery.ModMasterTrust( kMaster, -5)<0)
			; Punishment
			If (RandomInt(0,10)> 5)
				; _SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 3, aiValue2 = RandomInt( 0, _SDGVP_punishments.GetValueInt() ) )
				kMaster.SendModEvent("PCSubPunish") 
			Else
				; Whipping
				; _SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 5 )
				kMaster.SendModEvent("PCSubWhip") 
			EndIf
			Wait(1.0)
		EndIf

		; enslavement.PunishSlave(kMaster,kSlave, "Yoke")
		kSlave.SendModEvent("SDPunishSlave", "Yoke")

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

	if (iRandomNum > 85)
		; Punishment
		; enslavement.PunishSlave(kMaster,kSlave,"Gag")
		;_SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 3, aiValue2 = RandomInt( 0, _SDGVP_punishments.GetValueInt() ) )
	;	kMaster.SendModEvent("PCSubPunish") 
		kMaster.SendModEvent("PCSubWhip")
		; kMaster.SendModEvent("PCSubSex") 

	ElseIf (iRandomNum > 70)
		; Whipping
		; _SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 5 )
	;	kMaster.SendModEvent("PCSubWhip") 

	ElseIf (iRandomNum > 20)
		; Sex
		; _SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 0, aiValue2 = RandomInt( 0, _SDGVP_positions.GetValueInt() ) )
		; kMaster.SendModEvent("PCSubSex") 

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
		; Debug.Notification("[_sdras_master] Master is monitoring slave")

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
		While ( !Game.GetPlayer().Is3DLoaded() ) || (StorageUtil.GetIntValue(kSlave, "_SD_iEnslavementInitSequenceOn")==1)
		EndWhile

		; Master variable updates
		_SDGVP_state_MasterFollowSlave.SetValue( StorageUtil.GetIntValue(kMaster, "_SD_iFollowSlave") )
		kLeashCenter =  StorageUtil.GetFormValue(kSlave, "_SD_LeashCenter") as Actor
		fctSlavery.SlaveryRefreshGlobalValues( kMaster, kSlave)

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
		
		If (kMaster.GetParentCell().IsInterior())
			StorageUtil.SetIntValue(kMaster, "_SD_iDaysPassedOutside", 0)
		Else
			StorageUtil.SetIntValue(kMaster, "_SD_iDaysPassedOutside",  Game.QueryStat("Days Passed"))
		EndIf

		If !kMaster || !kSlave || kMaster.IsDisabled() || kMaster.IsDead() ; || ( kMaster.IsEssential() && (kMaster.IsBleedingOut()) || (kMaster.IsUnconscious()) ) )
			Debug.Trace("[_sdras_master] Master dead or disabled - Stop enslavement")

			; Self.GetOwningQuest().Stop()
			SendModEvent("PCSubFree")

		ElseIf ( Self.GetOwningQuest().IsStopping() || Self.GetOwningQuest().IsStopped() )
			; Park Master in Waiting mode while Enslavement quest is shutting down
			GoToState("waiting")

		ElseIf ( enslavement.bSearchForSlave || (GetCurrentRealTime() - fSlaveLastSeen > fSlaveFreeTime) || ( !kMaster.HasLOS( kSlave ))  )
			; Master is looking for slave
			GoToState("search")

		ElseIf (kSlave.GetParentCell() == kMaster.GetParentCell())  &&  (kMaster.GetParentCell().IsInterior()) && ( ( kMaster.GetSleepState() == 0 )  || (StorageUtil.GetIntValue(kMaster, "_SD_iTrust") > 0) )  
			; If master and slave are in the same interior cell
			If (RandomInt( 0, 100 ) > 95 )
				Debug.Notification( "Your captors are watching...")
			EndIf
			GoToState("waiting")

		ElseIf ( !Game.IsMovementControlsEnabled() || kMaster.GetCurrentScene() || kSlave.GetCurrentScene() )
			; Slave is in the middle of a scene (snp)
			; Add events here - master checking on slave, random punishment...

			fSlaveLastSeen = GetCurrentRealTime()
			enslavement.bEscapedSlave = False
			enslavement.bSearchForSlave = False

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

		ElseIf (   kSlave.IsWeaponDrawn() && ( bSlaveDetectedByMaster || bSlaveDetectedByTarget ))
			; Slave is drawing a weapon in front of master

			If (!fctSlavery.CheckSlavePrivilege(kSlave, "_SD_iEnableFight"))  
				If (StorageUtil.GetIntValue(kMaster, "_SD_iMasterIsCreature") == 0)
					Debug.Notification( "Who said you could fight, Slave!")
				endif

				; Drop current weapon 
				if(kSlave.IsWeaponDrawn())
					kSlave.SheatheWeapon()
					Utility.Wait(2.0)
				endif

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
				; Debug.Notification( "Who said you could use magic, Slave!")
 
			ElseIf ((kSlave.GetEquippedItemType(0) == 9)||(kSlave.GetEquippedItemType(1) == 9 ))  && ( (!fctSlavery.CheckSlavePrivilege(kSlave, "_SD_iEnableSpellEquip")) && (!fctSlavery.CheckSlavePrivilege(kSlave, "_SD_iEnableShoutEquip")) )
				If (StorageUtil.GetIntValue(kMaster, "_SD_iMasterIsCreature") == 0)
					Debug.Notification( "You better unequip that spell before I make you swallow it, Slave!")
				endif

			;ElseIf ((kSlave.GetEquippedItemType(0) == 11)||(kSlave.GetEquippedItemType(1) == 11))
			;	Debug.Notification( "Hold that torch higher, Slave!" )

			Else
				If (StorageUtil.GetIntValue(kMaster, "_SD_iMasterIsCreature") == 0)
					Debug.Notification( "Better unequip that before I shove it up your ass, Slave!" )
				endif

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
				If (StorageUtil.GetIntValue(kMaster, "_SD_iMasterIsCreature") == 0)
					Debug.Notification( "You will regret this!" )
				else
					Debug.Notification( "Your owner barks at you." )
				endif
				; Punishment
				;	_SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 3 )
				fctConstraints.actorCombatShutdown( kSlave )
				fctConstraints.actorCombatShutdown( kMaster )
				; enslavement.PunishSlave(kMaster,kSlave, "Gag")
				kSlave.SendModEvent("SDPunishSlave", "Gag")

				If (fctSlavery.ModMasterTrust( kMaster, -1)<0)
					kMaster.SendModEvent("PCSubPunish") 
				Endif

			ElseIf (Utility.RandomInt(0,100)>90) ; chance of attack failing and slave punished
				fctConstraints.actorCombatShutdown( kSlave )
				fctConstraints.actorCombatShutdown( kCombatTarget )

				If ( bSlaveDetectedByMaster )
					; Self.GetOwningQuest().ModObjectiveGlobal( 10.0, _SDGVP_demerits, 3, _SDGVP_demerits_join.GetValue() as Float, False, True, _SDGVP_config_verboseMerits.GetValueInt() as Bool )
					; Wait(0.5)
					; kSlave.PlayAnimation("ZazAPC055");Inte
					; Wait(1.0)
					Debug.Notification( "Your owner pushes you down to your knees!" )
					; Punish
					;	_SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 5 )
					; enslavement.PunishSlave(kMaster,kSlave, "Gag")
					kSlave.SendModEvent("SDPunishSlave", "Gag")

					If (fctSlavery.ModMasterTrust( kMaster, -1)<0)
						kMaster.SendModEvent("PCSubPunish") 
					Endif
				EndIf

				If ( bSlaveDetectedByTarget )
					Debug.Notification( "Your owner wouldn't like that!" )
					; Whipping
					; kSlave.PlayAnimation("ZazAPC055");Inte
					; Wait(0.5)
					; _SDKP_sex.SendStoryEvent(akRef1 = kCombatTarget, akRef2 = kSlave, aiValue1 = 5 )

					If (fctSlavery.ModMasterTrust( kMaster, -1)<0)
						kMaster.SendModEvent("PCSubWhip") 
					Endif
				EndIf
			EndIf


		ElseIf ((kSlave.GetParentCell() != kMaster.GetParentCell()) && (kMaster.GetParentCell().IsInterior()) && (!_SDGVP_state_caged.GetValueInt())) && (StorageUtil.GetIntValue(kMaster, "_SD_iTrust") < 0)
			; Master is looking for slave (if not trusted)
			; TO DO - Check if this really works with new collar / leash system

			Debug.Notification( "Your owner is looking for you!" )
			Wait(5.0)	

			If (bSlaveDetectedByMaster)
				If (StorageUtil.GetIntValue(kMaster, "_SD_iMasterIsCreature") == 0)
					Debug.Notification( "There you are Slave... get your punishment, over here!" )
				endif
				; enslavement.PunishSlave(kMaster,kSlave,"Blindfold")
				kSlave.SendModEvent("SDPunishSlave", "Blindfold")

				If (fctSlavery.ModMasterTrust( kMaster, -1)<0)
					; add punishment
					If ( _SDGVP_demerits.GetValueInt() > 20 )
						; Whipping
					 	; _SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 5 )
					 	kMaster.SendModEvent("PCSubWhip") 
					Else
						; Punishment
					 	; _SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 3, aiValue2 = RandomInt( 0, _SDGVP_punishments.GetValueInt() ) )
					 	kMaster.SendModEvent("PCSubPunish") 
					EndIf
				Endif
			EndIf

		Else

			fSlaveLastSeen = GetCurrentRealTime()

			If ( fMasterDistance <= StorageUtil.GetIntValue(kSlave, "_SD_iLeashLength") )
				fSlaveFreeTime += 0.05
				enslavement.bSearchForSlave = False

				If ( kMaster.WornHasKeyword( _SDKP_spriggan_infected ) && (StorageUtil.GetIntValue(kSlave, "_SD_iSprigganInfected") != 1) ) && (Utility.RandomInt(1,100)<=_SDGVP_config_healthMult.GetValue()/10) && (Utility.RandomInt(0,100)>=(StorageUtil.GetIntValue(kSlave, "_SD_iSprigganEnslavedCount") * 30)) 
					; Chance of spriggan infection if slave in close proximity of infected master
					; Debug.Notification("[SD] Infected by spriggan swarm...")
					SendModEvent("SDSprigganEnslave")
					
				ElseIf ( RandomFloat( 0.0, 100.0 ) < fLibido )
					; TO DO - Update this code with checks on SL Aroused level for Master

					fLibido = 0.0
	 
					; _SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 0, aiValue2 = RandomInt( 0, _SDGVP_positions.GetValueInt() ) )

				ElseIf (StorageUtil.GetIntValue(kMaster, "_SD_iDisposition") > 0) && (Utility.RandomInt(0,10) < StorageUtil.GetIntValue(kMaster, "_SD_iDisposition") ) 
					; Master is in a good mood - chance to remove punishment

					; enslavement.RewardSlave(kMaster,kSlave,"Gag")
					; enslavement.RewardSlave(kMaster,kSlave,"Blindfold")
					kSlave.SendModEvent("SDRewardSlave", "Gag")
					kSlave.SendModEvent("SDRewardSlave", "Blindfold")

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
		Actor kSourceContainer = akSourceContainer as Actor
		iuType = akBaseItem.GetType()
		fGoldEarned = 0.0

		If (kMaster.IsDead())
			Debug.Trace( "[SD] Item added to a dead master." )
			Return
		EndIf

		If (kSourceContainer == kSlave )
			Debug.Trace( "[SD] Master receives an item from player" )
			If (StorageUtil.GetIntValue(kMaster, "_SD_iMasterIsCreature") == 0)
				Debug.Notification( "Good slave." )
			else
				Debug.Notification( "Your owner seems pleased." )
			endif

			If ( akBaseItem.HasKeyword( _SDKP_food ) || akBaseItem.HasKeyword( _SDKP_food_raw ) || (iuType == 46) ) ; food or potion
				; Master receives Food
				fctSlavery.UpdateSlaveStatus( kSlave, "_SD_iGoalFood", modValue = 1)
				fctSlavery.ModMasterTrust( kMaster, 1)

				If ( StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryLevel") >= 2 )
					If (StorageUtil.GetIntValue(kMaster, "_SD_iMasterIsCreature") == 0)
						Debug.Notification("Mmm.. that should hit the spot.")
					endif
				Else
					If (StorageUtil.GetIntValue(kMaster, "_SD_iMasterIsCreature") == 0)
						Debug.Notification("Well? What are you waiting for?.")
						Debug.Notification("Get back to work slave!")
					endif
				EndIf

			; ElseIf ( iuType == 26 || iuType == 41 || iuType == 42 )
				; Weapon
			
			Else 
				; Add code to match received items against Master's needs
				; Update Master's mood and trust

			 	If ( StorageUtil.GetIntValue(kMaster, "_SD_iDisposition") > 0 )
			 		fGoldEarned = akBaseItem.GetGoldValue()
				Else
					fGoldEarned = Math.Floor( akBaseItem.GetGoldValue() / 4 )
				EndIf

				Float fGoldCoins = kSlave.GetItemCount(Gold) as Float
				kSlave.RemoveItem(Gold, fGoldCoins as Int)

				fGoldEarned = fGoldEarned + fGoldCoins

				If (fGoldEarned > 0) 
					fctSlavery.UpdateSlaveStatus( kSlave, "_SD_iGoalGold", modValue = fGoldEarned as Int)
					StorageUtil.SetIntValue(kMaster, "_SD_iGoldCountTotal", StorageUtil.GetIntValue(kMaster, "_SD_iGoldCountTotal") + (fGoldEarned as Int))

					_SDQP_enslavement.ModObjectiveGlobal( fGoldEarned as Int, _SDGVP_buyoutEarned, 6, _SDGVP_buyout.GetValue() as Float, False, True, True )
					
					fctSlavery.ModMasterTrust( kMaster, 1)

					If ( StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryLevel") >= 2 )
						If (StorageUtil.GetIntValue(kMaster, "_SD_iMasterIsCreature") == 0)
							Debug.Notification("Good slave... keep it coming.")
						endif

					Else
						If (StorageUtil.GetIntValue(kMaster, "_SD_iMasterIsCreature") == 0)
							Debug.Notification("That's right.")
							Debug.Notification("You don't have a use for gold anymore.")
						endif
					Endif

				ElseIf (fGoldEarned == 0)
					If (StorageUtil.GetIntValue(kMaster, "_SD_iMasterIsCreature") == 0)
						Debug.Notification("What is this junk!?.")
					endif
				EndIf

				; TO DO - Master reaction if slave reaches buyout amount

			EndIf
		Else
			; Debug.Notification( "New item for owner" )
			Debug.Trace( "[SD] Master receives an item from " + kSourceContainer + " / " + kSlave )

		EndIf
	EndEvent

	Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)

		ObjectReference PlayerRef = Game.GetPlayer()
		Bool boHitByMagic = FALSE  ; True if likely hit by Magic attack.
		Bool boHitByMelee = FALSE  ; True if likely hit by Melee attack.
		Bool boHitByRanged = FALSE ; True if likely his by Ranged attack.
		 
		Weapon krHand = kSlave.GetEquippedWeapon()
		Weapon klHand = kSlave.GetEquippedWeapon( True )


		IF (akAggressor == PlayerRef) ; && PlayerRef.IsInCombat() && akAggressor.IsHostileToActor(PlayerRef)

			IF ((kSlave.GetEquippedItemType(0) == 8) || (kSlave.GetEquippedItemType(1) == 8) \
				|| (kSlave.GetEquippedItemType(0) == 9) || (kSlave.GetEquippedItemType(1) == 9))  && akProjectile != None
				boHitByMagic = TRUE

			ELSEIF (kSlave.GetEquippedItemType(0) != 7) && (akProjectile == None) && ((kSlave.IsWeaponDrawn())) && (krHand || klHand)
				boHitByMelee = TRUE

			ELSEIF (kSlave.GetEquippedItemType(0) == 7) && (kSlave.IsWeaponDrawn()) && (krHand || klHand)
				boHitByRanged = TRUE

			ENDIF
		ENDIF

		If  ((boHitByMelee) || (boHitByRanged)) && (!boHitByMagic) ; (!fctSlavery.CheckSlavePrivilege(kSlave, "_SD_iEnableFight"))
			Debug.Messagebox( "Your collar compels you to drop your weapon when attacking your owner." )

			; Drop current weapon 
			if(kSlave.IsWeaponDrawn())
				kSlave.SheatheWeapon()
				Utility.Wait(2.0)
			endif

			If ( krHand )
			;	kSlave.DropObject( krHand )
				kSlave.UnequipItem( krHand )
			EndIf
			If ( klHand )
			;	kSlave.DropObject( klHand )
				kSlave.UnequipItem( klHand )
			EndIf

			; enslavement.PunishSlave(kMaster,kSlave,"Yoke")
			kSlave.SendModEvent("SDPunishSlave", "Yoke")

			If (fctSlavery.ModMasterTrust( kMaster, -1)<0)
				; add punishment
				Int iRandomNum = Utility.RandomInt(0,100)

				if (iRandomNum > 70)
					; Whipping
				 	; _SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 5 )
				 	kMaster.SendModEvent("PCSubWhip") 
				Else
					; Punishment
				 	; _SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 3, aiValue2 = RandomInt( 0, _SDGVP_punishments.GetValueInt() ) )
				 	kMaster.SendModEvent("PCSubPunish") 
				EndIf
			Endif
		EndIf

	EndEvent
EndState

State search
	Event OnBeginState()
		; Debug.Notification("[_sdras_master] Master starts searching for slave")
		enslavement.bSearchForSlave = True
		kMaster.EvaluatePackage()
		RegisterForLOS( kMaster, kSlave )
	EndEvent
	
	Event OnEndState()
		; Debug.Notification("[_sdras_master] Master stops searching slave")
		kMaster.EvaluatePackage()
		UnregisterForLOS( kMaster, kSlave )
	EndEvent

	Event OnGainLOS(Actor akViewer, ObjectReference akTarget)
		; Debug.Notification("[_sdras_master] Master found slave")
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

		ElseIf ( (kMaster.GetDistance( kSlave ) <= StorageUtil.GetIntValue(kSlave, "_SD_iLeashLength") ) && (( kMaster.HasLOS( kSlave )) ) )
			; Slave is back, next to master
			; Debug.Notification("[_sdras_master] Master close to slave with LOS")
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


MiscObject Property Gold  Auto  
