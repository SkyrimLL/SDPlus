Scriptname _SDRAS_master extends ReferenceAlias Conditional
{ USED }
Import Utility

SexLabFramework Property SexLab  Auto   
_SDQS_functions Property funct  Auto
_SDQS_fcts_constraints Property fctConstraints  Auto
_SDQS_fcts_inventory Property fctInventory  Auto
_SDQS_fcts_factions Property fctFactions  Auto
_SDQS_fcts_slavery Property fctSlavery  Auto
_SDQS_fcts_outfit Property fctOutfit  Auto

_SDQS_snp Property snp Auto
_SDQS_enslavement Property enslavement  Auto
_SDQS_ennslavement_tasks Property tasks  Auto

Quest Property _SDQP_enslavement_tasks  Auto
Quest Property _SDQP_enslavement Auto
Cell[] Property _SDCP_sanguines_realms  Auto  

MiscObject Property Gold  Auto  

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
; Float fLibido
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
Cell kMasterCell
Cell kSlaveCell

Actor kMaster
Actor kSlave
Actor kCombatTarget
Actor kLeashCenter
Actor kNPC
; ObjectReference kBindings
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

		If (GetState() != "search") && (akKiller != kSlave) &&  !fctFactions.checkIfFollower (  akKiller ) 
			; Followers are not allowed to forcefully take the player as a slave to prevent friendly fire or rescue
			; Only voluntary submission to followers is allowed

			If (Utility.RandomInt(0,100)>40)
				SendModEvent("PCSubFree")
				GoToState("doNothing")

			ElseIf (akKiller != kMaster)
				; Send all items back to Dreamworld storage
				kMaster.RemoveAllItems(akTransferTo = _SDRAP_playerStorage.GetReference(), abKeepOwnership = True)

				Debug.Notification( "A new owner grabs you." )
				Debug.Trace("[_sdras_master] Start enslavement with:"  + akKiller)
				; StorageUtil.SetFormValue( Game.getPlayer() , "_SD_TempAggressor", akKiller)

				akKiller.SendModEvent("PCSubTransfer") 

			EndIf

		EndIf
	EndIf
EndEvent

Event OnEnterBleedout()
	if (kMaster.IsEssential()) ; && (Variables.FollowerSetting==0)
		Debug.Trace("[_sdras_master] Essential master bleeding out - Stop enslavement")
		SendModEvent("PCSubFree")
		GoToState("doNothing")
		; Self.GetOwningQuest().Stop()
	EndIf
EndEvent

Event OnPackageChange(Package akOldPackage)
	fPackageTime = GetCurrentRealTime()
EndEvent

Event OnCombatStateChanged(Actor akTarget, int aeCombatState)
	If ( !kMaster )
		kMaster = _SDRAP_master.GetReference() as Actor
	EndIf

	; most likely to happen on a pickpocket failure.
	If ( (aeCombatState != 0) && (akTarget == kSlave) && (!kMaster.GetCurrentScene()) && (Self.GetOwningQuest().GetStage() <  90) ) && (StorageUtil.GetIntValue(kSlave, "_SD_iEnslavementInitSequenceOn")==0) && !fctOutfit.isArmbinderEquipped( kSlave ) && !fctOutfit.isYokeEquipped( kSlave )
		Int iGold = 100
		Float iDemerits = 10.0
				
		Debug.Trace( "[_sdras_master] Master attacked by slave - aeCombatState " + aeCombatState )

		StorageUtil.SetIntValue(kSlave, "_SD_iEnableArmorEquip", 0)
		StorageUtil.SetIntValue(kSlave, "_SD_iHandsFree", 0)
		StorageUtil.SetIntValue(kSlave, "_SD_iEnableAction", 0)

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

		If (StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryPunishmentSceneOn")==1)
			If (StorageUtil.GetIntValue(kMaster, "_SD_iMasterIsCreature") == 0)
				Debug.Notification( "You will regret attacking me!" )
			EndIf
			_SDSP_SelfShockEffect.Cast(kSlave as Actor)
			
			If (fctSlavery.ModMasterTrust( kMaster, -5)<0)
				; Punishment
				If (RandomInt(0,10)> 5) && (StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryPunishmentSceneOn")==1)
					; _SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 3, aiValue2 = RandomInt( 0, _SDGVP_punishments.GetValueInt() ) )
					; kMaster.SendModEvent("PCSubPunish") 
					funct.SanguinePunishment( kMaster )

				Elseif (StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryWhipSceneOn")==1)
					; Whipping
					; _SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 5 )
					; kMaster.SendModEvent("PCSubWhip") 
					funct.SanguineWhip( kMaster )

				Else
					kMaster.SendModEvent("PCSubSex","Rough") 
				EndIf
				Wait(1.0)
			EndIf

			; 
			If (StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryPunishmentOn")==1)
				Debug.Trace( "[_sdras_master] Punishment for engaging in combat or pickpocket attempt - Armbinder" )
				enslavement.PunishSlave(kMaster,kSlave, "Armbinder")
			endif
		else
			kMaster.SendModEvent("PCSubSex","Rough") 
		endif
	ElseIf ( aeCombatState == 0 )
		GoToState("monitor")
	Else
		; GoToState("combat")
	EndIf
EndEvent

Event OnLostLOS(Actor akViewer, ObjectReference akTarget)
	If (kMaster) && (kSlave) 

		If ( kMaster.GetDistance( kSlave ) > (_SDGVP_escape_radius.GetValue() / 4.0) )
			; Debug.Notification( "[_sdras_master] Slave is too far or out of sight" )
			; If ( kMaster.GetCurrentScene() )
			;	kMaster.GetCurrentScene().Stop()
			; EndIf
			enslavement.bSearchForSlave = True
			GoToState("search")
		EndIf


		; enslavement.bSearchForSlave = True
		fSlaveLastSeen = GetCurrentRealTime()
	EndIf
EndEvent

Event OnGainLOS(Actor akViewer, ObjectReference akTarget)
	If (kMaster) && (kSlave)  
		kMaster.ClearLookAt()
		enslavement.bSearchForSlave = False

		fSlaveLastSeen = GetCurrentRealTime()
		; fLibido += 2.5

		; If ( kSlave.GetEquippedWeapon() || kSlave.GetEquippedWeapon( True ) )
			; Slave detected by Master holding a weapon
			; 	GoToState("combat")
			; 	kMaster.SetAlert()
			; 	Debug.Trace("[_sdras_master] Armed slave - Stop enslavement")
			; 
			; 	Self.GetOwningQuest().Stop()
		; EndIf
	EndIf
EndEvent

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	Actor kSourceContainer = akSourceContainer as Actor
	iuType = akBaseItem.GetType()
	fGoldEarned = 0.0

	If (kMaster.IsDead())
		Debug.Trace( "[_sdras_master] Item added to a dead master." )
		Return
	EndIf

	if !akSourceContainer
		Debug.Trace("[_sdras_master] Master receives  " + aiItemCount + "x " + akBaseItem + " from the world")
	elseif akSourceContainer == Game.GetPlayer()
		Debug.Trace("[_sdras_master] Master receives  " + aiItemCount + "x " + akBaseItem)
	else
		Debug.Trace("[_sdras_master] Master receives  " + aiItemCount + "x " + akBaseItem + " from another container")
	endIf

	If (kSourceContainer == kSlave ) 
		fctInventory.ProcessItemAdded(kMaster, kSlave, akBaseItem)

	Else
		; Debug.Notification( "New item for owner" )
		Debug.Trace( "[_sdras_master] Master receives an item from " + kSourceContainer + " / " + kSlave )

	EndIf
EndEvent


Event OnInit()

	kMaster = _SDRAP_master.GetReference() as Actor
	kSlave = _SDRAP_slave.GetReference() as Actor

	Utility.Wait(5.0)
		
	If ( Self.GetOwningQuest() )
	 	RegisterForSingleUpdate( fRFSU )
	EndIf
	GoToState("waiting")
EndEvent

State waiting
	Event OnUpdate()
		If ( Self.GetOwningQuest().IsRunning() ) && (kMaster)  && ( kMaster.Is3DLoaded() ); && (StorageUtil.GetIntValue(kSlave, "_SD_iEnslavementInitSequenceOn")==0) ; wait for end of enslavement sequence
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
		; If ( kMaster.GetCurrentScene() )
		;	kMaster.GetCurrentScene().Stop()
		; EndIf

		fSlaveFreeTime = _SDGV_free_time.GetValue()
		fLeashLength = _SDGV_leash_length.GetValue()
		enslavement.bSearchForSlave = False
		fSlaveLastSeen = GetCurrentRealTime()
		; fLibido = 0.0
		
		kMaster = _SDRAP_master.GetReference() as Actor
		kSlave = _SDRAP_slave.GetReference() as Actor
		; kBindings = _SDRAP_bindings.GetReference() as ObjectReference
		kCrop = _SDRAP_crop.GetReference().GetBaseObject() as Weapon

		RegisterForLOS( kMaster, kSlave )
		RegisterForSingleUpdate( fRFSU )
	EndEvent
	
	Event OnEndState()
		UnregisterForLOS( kMaster, kSlave )
	EndEvent

	Event OnUpdate()
		; While ( !Game.GetPlayer().Is3DLoaded() )
		; EndWhile
		kMaster = _SDRAP_master.GetReference() as Actor
		if (!kMaster)  || ( !kMaster.Is3DLoaded() )
			GoToState("monitor")
		endif

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
 		kMasterCell = kMaster.GetParentCell()
		kSlaveCell = kSlave.GetParentCell()
		
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
		
		If (kMasterCell.IsInterior())
			StorageUtil.SetIntValue(kMaster, "_SD_iDaysPassedOutside", 0)
		Else
			StorageUtil.SetIntValue(kMaster, "_SD_iDaysPassedOutside",  Game.QueryStat("Days Passed"))
		EndIf

		If !kMaster || !kSlave || kMaster.IsDisabled() || kMaster.IsDead() ; || ( kMaster.IsEssential() && (kMaster.IsBleedingOut()) || (kMaster.IsUnconscious()) ) )
			Debug.Trace("[_sdras_master] Master dead or disabled - Stop enslavement")
			Debug.Notification( "Your owner is either dead or left you...")

			SendModEvent("PCSubFree")
			GoToState("doNothing")

		ElseIf ( Self.GetOwningQuest().IsStopping() || Self.GetOwningQuest().IsStopped() )
			; Park Master in Waiting mode while Enslavement quest is shutting down
			GoToState("waiting")

		ElseIf ( enslavement.bSearchForSlave && ( !kMaster.HasLOS( kSlave ))  && ( kMaster.GetDistance( kSlave ) > (_SDGVP_escape_radius.GetValue() / 4.0) ) ) ; || (GetCurrentRealTime() - fSlaveLastSeen > fSlaveFreeTime) 
			; Master is looking for slave - should be triggered only when enslavement.bSearchForSlave is set from elsewhere
			; Debug.Notification( "[_sdras_master] Checking in one slave or out of sight" )
			GoToState("search")

		ElseIf (kSlaveCell == kMasterCell)  &&  (kMasterCell.IsInterior()) && ( ( kMaster.GetSleepState() == 0 )  || (StorageUtil.GetIntValue(kMaster, "_SD_iTrust") > 0) )  
			; If master and slave are in the same interior cell
			If (RandomInt( 0, 100 ) > 95 )
				Debug.Notification( "Your captors are watching...")
			EndIf
			; GoToState("waiting")

		ElseIf ( !Game.IsMovementControlsEnabled() || kMaster.GetCurrentScene() || kSlave.GetCurrentScene() )
			; Slave is in the middle of a scene (snp)
			; Add events here - master checking on slave, random punishment...

			fSlaveLastSeen = GetCurrentRealTime()
			enslavement.bEscapedSlave = False
			enslavement.bSearchForSlave = False

		ElseIf ( Self.GetOwningQuest().GetStage() >= 90 ) ; || _SDCP_sanguines_realms.Find( kSlaveCell ) > -1 )
			; Grace period after slave rejects master's offer to join
			fSlaveLastSeen = GetCurrentRealTime()
			enslavement.bEscapedSlave = False
			enslavement.bSearchForSlave = False

		ElseIf ( _SDGVP_state_caged.GetValueInt() )
			; Caged state
			GoToState("caged")

		ElseIf ( kMaster.IsInCombat() || kSlave.IsInCombat() )
			; Combat state
			; GoToState("combat")

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

				; If ( bSlaveDetectedByMaster )
				;	kMaster.StartCombat( kSlave )
				; EndIf
				; If ( bSlaveDetectedByTarget )
				;	kCombatTarget.StartCombat( kSlave )
				; EndIf
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
				; 
				If (StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryPunishmentOn")==1)
					Debug.Trace( "[_sdras_master] Punishment for attacking master - Yoke" )
					enslavement.PunishSlave(kMaster,kSlave, "Yoke")
				endif

				If (fctSlavery.ModMasterTrust( kMaster, -1)<0) 
					If (StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryPunishmentSceneOn")==1)
					;	kMaster.SendModEvent("PCSubPunish") 
					funct.SanguinePunishment( kMaster )

					else
						kMaster.SendModEvent("PCSubSex","Rough") 
					endif
				Endif

			ElseIf (Utility.RandomInt(0,100)>90) ; chance of attack failing and slave punished
				fctConstraints.actorCombatShutdown( kSlave )
				fctConstraints.actorCombatShutdown( kCombatTarget )

				If ( bSlaveDetectedByMaster )
					; Self.GetOwningQuest().ModObjectiveGlobal( 10.0, _SDGVP_demerits, 3, _SDGVP_demerits_join.GetValue() as Float, False, True, _SDGVP_config_verboseMerits.GetValueInt() as Bool )
					; Wait(0.5)
					; kSlave.PlayAnimation("ZazAPC055");Inte
					; Wait(1.0)
					; Debug.Notification( "Your owner pushes you down to your knees!" )
					; Punish
					;	_SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 5 )
					; 
					; If (StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryPunishmentOn")==1)
					;	Debug.Trace( "[SD] Punishment for attacking master - Yoke" )
					;	enslavement.PunishSlave(kMaster,kSlave, "Yoke")
					; EndIf

					If (fctSlavery.ModMasterTrust( kMaster, -1)<0)
						If (StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryPunishmentSceneOn")==1)
						;	kMaster.SendModEvent("PCSubPunish") 
						funct.SanguinePunishment( kMaster )

						else
							kMaster.SendModEvent("PCSubSex","Rough") 
						endif
					Endif
				EndIf

				If ( bSlaveDetectedByTarget )
					Debug.Notification( "Your owner wouldn't like that!" )
					; Whipping
					; kSlave.PlayAnimation("ZazAPC055");Inte
					; Wait(0.5)
					; _SDKP_sex.SendStoryEvent(akRef1 = kCombatTarget, akRef2 = kSlave, aiValue1 = 5 )

					If (fctSlavery.ModMasterTrust( kMaster, -1)<0)
						; kMaster.SendModEvent("PCSubWhip") 
						funct.SanguineWhip( kMaster )
					Endif
				EndIf
			EndIf


		ElseIf ((kSlaveCell != kMasterCell) && (kMasterCell.IsInterior()) && (!_SDGVP_state_caged.GetValueInt())) && (StorageUtil.GetIntValue(kMaster, "_SD_iTrust") < 0)
			; Master is looking for slave (if not trusted)
			; TO DO - Check if this really works with new collar / leash system

			Debug.Notification( "Your owner is looking for you!" )
			Wait(5.0)	

			If (bSlaveDetectedByMaster)
				If (StorageUtil.GetIntValue(kMaster, "_SD_iMasterIsCreature") == 0)
					Debug.Notification( "There you are Slave... get your punishment, over here!" )
				endif
				; 
				If (StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryPunishmentOn")==1)
					enslavement.PunishSlave(kMaster,kSlave,"Blindfold")
				Endif

				If (fctSlavery.ModMasterTrust( kMaster, -1)<0)
					; add punishment
					If ( _SDGVP_demerits.GetValueInt() > 20 ) && (StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryWhipSceneOn")==1)
						; Whipping
					 	; _SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 5 )
					 	; kMaster.SendModEvent("PCSubWhip") 
						funct.SanguineWhip( kMaster )

					Elseif (StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryPunishmentSceneOn")==1)
						; Punishment
					 	; _SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 3, aiValue2 = RandomInt( 0, _SDGVP_punishments.GetValueInt() ) )
					 	; kMaster.SendModEvent("PCSubPunish") 
						funct.SanguinePunishment( kMaster )

					Else
						kMaster.SendModEvent("PCSubSex","Rough") 
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
					
				; ElseIf ( RandomFloat( 0.0, 100.0 ) < fLibido )
					; TO DO - Update this code with checks on SL Aroused level for Master
	 
					; _SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 0, aiValue2 = RandomInt( 0, _SDGVP_positions.GetValueInt() ) )

				ElseIf (StorageUtil.GetIntValue(kMaster, "_SD_iDisposition") > 0) && (Utility.RandomInt(0,10) < StorageUtil.GetIntValue(kMaster, "_SD_iDisposition") ) && (StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryPunishmentOn")==1)
					; Master is in a good mood - chance to remove punishment

					enslavement.RewardSlave(kMaster,kSlave,"Gag")
					enslavement.RewardSlave(kMaster,kSlave,"Blindfold")
					; kSlave.SendModEvent("SDRewardSlave", "Gag")
					; kSlave.SendModEvent("SDRewardSlave", "Blindfold")

				EndIf
			EndIf

		
		EndIf
			
		If ( Self.GetOwningQuest() && !(Self.GetOwningQuest().IsStopping() || Self.GetOwningQuest().IsStopped()))
            RegisterForSingleUpdate( fRFSU )
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

			ELSE
				boHitByMelee = TRUE ; Hit by hand to hand / unarmed

			ENDIF

			If  ((boHitByMelee) || (boHitByRanged)) && (!boHitByMagic) ; (!fctSlavery.CheckSlavePrivilege(kSlave, "_SD_iEnableFight"))
				; Debug.Messagebox( "Your collar compels you to drop your weapon when attacking your owner." )

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

				;
				If (StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryPunishmentOn")==1)
					Debug.Trace( "[_sdras_master] Punishment for hitting master - Yoke" )
					enslavement.PunishSlave(kMaster,kSlave,"Yoke")
					; enslavement.PunishSlave(kMaster,kSlave,"Corset")
					; enslavement.PunishSlave(kMaster,kSlave,"Boots")
					; enslavement.PunishSlave(kMaster,kSlave,"Gag")
				endif

				If (fctSlavery.ModMasterTrust( kMaster, -1)<0)
					; add punishment
					Int iRandomNum = Utility.RandomInt(0,100)

					if (iRandomNum > 70) && (StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryWhipSceneOn")==1)
						; Whipping
					 	; _SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 5 )
					 	; kMaster.SendModEvent("PCSubWhip") 
						funct.SanguineWhip( kMaster )

					Elseif (StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryPunishmentSceneOn")==1)
						; Punishment
					 	; _SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 3, aiValue2 = RandomInt( 0, _SDGVP_punishments.GetValueInt() ) )
					 	; kMaster.SendModEvent("PCSubPunish") 
						funct.SanguinePunishment( kMaster )

					Else
					 	kMaster.SendModEvent("PCSubSex","Rough") 

					EndIf
				Endif
			EndIf
		ENDIF

	EndEvent
EndState

State search
	Event OnBeginState()
		; Debug.Notification("[_sdras_master] Master starts searching for slave")
		; If ( kMaster.GetCurrentScene() )
		;	kMaster.GetCurrentScene().Stop()
		; EndIf
		enslavement.bSearchForSlave = True
		RegisterForLOS( kMaster, kSlave )
		kMaster.EvaluatePackage()
	EndEvent
	
	Event OnEndState()
		; Debug.Notification("[_sdras_master] Master stops searching slave")
		kMaster.EvaluatePackage()
		UnregisterForLOS( kMaster, kSlave )
	EndEvent

	Event OnGainLOS(Actor akViewer, ObjectReference akTarget)
		If (kMaster.GetDistance( kSlave ) <= (StorageUtil.GetIntValue(kSlave, "_SD_iLeashLength") / 2 ) )
			; Debug.Notification("[_sdras_master] Master found slave")
			; If ( kMaster.GetCurrentScene() )
			;	kMaster.GetCurrentScene().Stop()
			; EndIf
			; enslavement.bSearchForSlave = False
			; kMaster.EvaluatePackage()
		else
			; Debug.Notification("[_sdras_master] Master can see slave")
		Endif
	EndEvent

	Event OnDeath(Actor akKiller)
		Debug.Trace("[_sdras_master] Master death event - Stop enslavement")

		SendModEvent("PCSubFree")
		GoToState("doNothing")
		; Self.GetOwningQuest().Stop()
	EndEvent

	Event OnUpdate()
		; While ( !Game.GetPlayer().Is3DLoaded() )
		; EndWhile
		kMaster = _SDRAP_master.GetReference() as Actor
		
		If ( !kMaster || kMaster.IsDisabled() )
			Debug.Trace("[_sdras_master] Master dead in search - Stop enslavement")
			Debug.Notification("It looks like your owner abandonned you...")

			SendModEvent("PCSubFree")
			GoToState("doNothing")

		ElseIf ( (kMaster.GetDistance( kSlave ) <= (StorageUtil.GetIntValue(kSlave, "_SD_iLeashLength") / 2 ) ) && (( kMaster.HasLOS( kSlave )) ) )
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
	; Disabled in 3.5.9 because of abusive stack dumps - revisit later
	Event OnBeginState()
		; Debug.Notification("[_sdras_master] Master in combat")
		If ( kMaster.GetCurrentScene() )
			kMaster.GetCurrentScene().Stop()
		EndIf
		enslavement.bSearchForSlave = False
	EndEvent
	
	Event OnEndState()
		kMaster.EvaluatePackage()
		; Debug.Notification( "[_sdras_master] Combat ended - looking for slave" )
		enslavement.bSearchForSlave = True
		GoToState("search")
	EndEvent

	Event OnUpdate()
		; While ( !Game.GetPlayer().Is3DLoaded() ) || (StorageUtil.GetIntValue(kSlave, "_SD_iEnslavementInitSequenceOn")==1)
		; EndWhile
		kMaster = _SDRAP_master.GetReference() as Actor

		If ( !kMaster || kMaster.IsDisabled() )
			Debug.Trace("[_sdras_master] Master dead in combat- Stop enslavement")
			Debug.Notification("It looks like your owner left you to your fate...")

			SendModEvent("PCSubFree") 
			GoToState("doNothing")

		ElseIf ( Self.GetOwningQuest().IsStopping() || Self.GetOwningQuest().IsStopped() )
			kMaster.EvaluatePackage()
			GoToState("waiting")

		ElseIf ( !kMaster.IsInCombat() && !kSlave.IsInCombat() )
			; GoToState("monitor")
			; Debug.Notification( "[_sdras_master] Master not in combat - looking for slave" )
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
		kMaster.EvaluatePackage()
	EndEvent

	Event OnUpdate()
	;	While ( !Game.GetPlayer().Is3DLoaded() ) || (StorageUtil.GetIntValue(kSlave, "_SD_iEnslavementInitSequenceOn")==1)
	;	EndWhile
		kMaster = _SDRAP_master.GetReference() as Actor
		
		If ( !kMaster || kMaster.IsDisabled() )
			Debug.Trace("[_sdras_master] Master dead in caged - Stop enslavement")
			Debug.Notification("Your owner left you to your fate...")

			SendModEvent("PCSubFree")
			GoToState("doNothing")
			; Self.GetOwningQuest().Stop()
		ElseIf ( !_SDGVP_state_caged.GetValueInt() )
			kMaster.EvaluatePackage()
			GoToState("monitor")
		EndIf

		If ( Self.GetOwningQuest() )
			RegisterForSingleUpdate( fRFSU )
		EndIf
	EndEvent
EndState

State doNothing
EndState