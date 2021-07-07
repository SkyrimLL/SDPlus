Scriptname _SDQS_enslavement extends Quest Conditional
{ USED }
Import Utility

_SDQS_functions Property funct  Auto
_SDQS_fcts_constraints Property fctConstraints  Auto
_SDQS_fcts_inventory Property fctInventory  Auto
_SDQS_fcts_outfit Property fctOutfit  Auto
_SDQS_fcts_factions Property fctFactions  Auto
_SDQS_fcts_slavery Property fctSlavery  Auto

DialogueFollowerScript Property companionDialogue  Auto

Quest Property _SDQP_enslavement  Auto
Quest Property _SD_dream_destinations  Auto  
_sdqs_dream_destinations property dreamDest Auto


GlobalVariable Property _SDGVP_enslaved  Auto  
GlobalVariable Property _SDGVP_positions  Auto  
GlobalVariable Property _SDGVP_demerits  Auto  
GlobalVariable Property _SDGVP_demerits_join  Auto  
GlobalVariable Property _SDGVP_gametime  Auto  
GlobalVariable Property _SDGVP_buyout  Auto Conditional
GlobalVariable Property _SDGVP_buyoutEarned  Auto Conditional
GlobalVariable[] Property _SDGVP_config  Auto  
GlobalVariable Property _SDGVP_stats_enslaved  Auto  
GlobalVariable Property _SDGVP_state_joined  Auto  
GlobalVariable Property _SDKP_trust_hands Auto
GlobalVariable Property _SDKP_trust_feet Auto
GlobalVariable Property _SDGV_leash_length Auto
GlobalVariable Property _SDGVP_punishments  Auto  
GlobalVariable Property _SDGVP_snp_busy Auto
GlobalVariable Property GameHour Auto

SexLabFramework Property SexLab  Auto  


ReferenceAlias Property _SDRAP_master  Auto
ReferenceAlias Property _SDRAP_slave  Auto
ReferenceAlias Property _SDRAP_bindings Auto
ReferenceAlias Property _SDRAP_shackles Auto
ReferenceAlias Property _SDRAP_collar Auto
ReferenceAlias Property _SDRAP_key Auto
ReferenceAlias Property _SDRAP_crop Auto
ReferenceAlias Property _SDRAP_cage Auto
ReferenceAlias Property _SDRAP_cage_door Auto

FormList Property _SDFLP_allied  Auto
FormList Property _SDFLP_slaver  Auto
FormList Property _SDFLP_punish_items  Auto
FormList Property _SDFLP_ignore_items  Auto
FormList Property _SDFLP_sex_items  Auto
FormList Property _SDFLP_master_items  Auto

Keyword Property _SDKP_sex  Auto  
Keyword Property _SDKP_wrists  Auto  
Keyword Property _SDKP_ankles  Auto  
Keyword Property ActorTypeNPC  Auto  
Keyword Property _SDKP_enslave  Auto

Quest Property WEBountyCollectorQST  Auto
Faction Property _SDFP_bountyhunter  Auto

Faction Property _SDFP_spriggan  Auto  
Spell Property _SDSP_spriggan_heal  Auto
ActorBase Property _SDABP_sprigganhost  Auto
Actor Property _SDAP_sanguine  Auto  

GlobalVariable Property _SDGVP_state_housekeeping  Auto  



Faction Property _SDFP_slaverCrimeFaction  Auto 
GlobalVariable Property _SDGVP_config_verboseMerits  Auto
GlobalVariable Property _SDGVP_trust_hands  Auto  
GlobalVariable Property _SDGVP_trust_feet  Auto  
ReferenceAlias[] Property _SDRAP_companions Auto
Armor Property _SDA_bindings  Auto  

ReferenceAlias Property _SDRAP_playerStorage  Auto  
ObjectReference Property _SDRAP_playerStorageKeys  Auto  
ReferenceAlias Property _SDAP_clothing  Auto  


Bool Property bEscapedSlave = False Auto Conditional
Bool Property bSearchForSlave = False Auto Conditional
Bool Property bJoinedFaction = False Auto Conditional
Bool Property bQuestActive = False Auto Conditional
Bool Property bOriginallyEnemies = False Auto Conditional
Float Property fTimeEnslaved = 0.0 Auto Conditional
Int Property uiPunishmentsEarned = 0 Auto Conditional
Float fPunishmentsLength = 0.0  
Int Property uiLastDemerits = 0 Auto Conditional
Int Property uiHighestDemerits = 0 Auto Conditional
Int Property uiLowestDemerits = 0 Auto Conditional
Float Property ufMedianDemerits = 0.0 Auto Conditional
Float Property ufBindingsHealth = 10.0 Auto Conditional

Float fRFSU = 0.5
Float fRFSUGT = 3.0
Float fEnslavementStart = 0.0
Float kneelingDistance
Int trust

Float fFadeOutTime = 30.0

Actor kMaster
Actor kSlave

Int iGold = 0
Int iDemerits

Faction kCrimeFaction

; ObjectReference akRef1 = master
; ObjectReference akRef2 = slave
Event OnStoryScript(Keyword akKeyword, Location akLocation, ObjectReference akRef1, ObjectReference akRef2, int aiValue1, int aiValue2 )
	; ObjectReference shackles = _SDRAP_shackles.GetReference() as ObjectReference
	; ObjectReference bindings = _SDRAP_bindings.GetReference() as ObjectReference
	; ObjectReference collar = _SDRAP_collar.GetReference() as ObjectReference
	Actor MasterQuestAlias = _SDRAP_master.GetReference() as Actor

	kMaster = akRef1 as Actor
	kSlave = akRef2 as Actor

	debugTrace(" Receiving enslavement story.")
 	debugTrace(" bQuestActive == " + bQuestActive)

	If ( kMaster != MasterQuestAlias )
		debug.Notification("[_sdqs_enslavement] OnStoryScript - Master quest alias empty")
		debugTrace("[_sdqs_enslavement] OnStoryScript - Master quest alias empty - aborting enslavement")
		debugTrace("[_sdqs_enslavement]     kMaster: " + kMaster)
		debugTrace("[_sdqs_enslavement]     MasterQuestAlias: " + MasterQuestAlias)
		_SDQP_enslavement.Stop()
		Return
	EndIf

	If ( !kMaster )
		debugTrace("[_sdqs_enslavement] OnStoryScript - Master is empty - aborting enslavement")
		_SDQP_enslavement.Stop()
		Return
	EndIf

	If ( !kSlave )
		debugTrace("[_sdqs_enslavement] OnStoryScript - Slave is empty - aborting enslavement")
		_SDQP_enslavement.Stop()
		Return
	EndIf

	; kMaster = _SDRAP_master.GetReference() as Actor
	; kSlave = _SDRAP_slave.GetReference() as Actor


	If ( !bQuestActive )
		debugTrace("[_sdqs_enslavement]  Starting enslavement story.")
		bQuestActive = True		

		; _SDGVP_demerits.SetValueInt( aiValue1 )

		; ---------------------------------------------------------------------------
		debugTrace("[_sdqs_enslavement]  kMaster:" + kMaster)
		debugTrace("[_sdqs_enslavement]  kSlave:" + kSlave)
		StorageUtil.SetFormValue(none, "_SD_CurrentOwner", kMaster)
		StorageUtil.SetFormValue(none, "_SD_CurrentSlave", kSlave)
		EnslavePlayer(kMaster, kSlave, _SDGVP_config[3].GetValue() as Bool)
		; ---------------------------------------------------------------------------


		SetObjectiveDisplayed( 0 )
		if (StorageUtil.GetIntValue(kMaster, "_SD_iMasterIsCreature")==0)
			SetObjectiveDisplayed( 1 )
			; SetObjectiveDisplayed( 2 )
			; SetObjectiveDisplayed( 6 )
		EndIf

		; If ( Self )
		;	RegisterForSingleUpdate( fRFSU )
		;	RegisterForSingleUpdateGameTime( fRFSUGT )
		; EndIf
	ElseIf ( _SDGVP_config[0].GetValue() )
;		kSlave.GetActorBase().SetEssential( False )
		debugTrace("[_sdqs_enslavement] Aborting enslavement story - already active.")
	EndIf

EndEvent
 

ObjectReference Function GetSlave()
	Return kSlave as ObjectReference
EndFunction

ObjectReference Function GetMaster()
	Return kMaster as ObjectReference
EndFunction

Function EnslavePlayer(Actor akMaster, Actor akSlave, Bool bLimitedRemoval = False)
	ObjectReference kRags = _SDAP_clothing.GetReference() as  ObjectReference 
	ActorBase akActorBase  
	Bool bIsCollarded = false
	Bool bIsArmBound = false
	Bool bIsLegsBound = false

	_SDGVP_buyout.SetValue( (_SDGVP_buyout.GetValue() as Int)  - 100 + Utility.RandomInt(0,500) )
	_SDGVP_demerits_join.SetValue(  - 20 - 10 * (4 - (kMaster.GetAV("morality") as Int) ) )
	_SDGV_leash_length.SetValue(400)
	_SDGVP_stats_enslaved.Mod( 1.0 )
	_SDGVP_enslaved.SetValue(1)	   

	fEnslavementStart = GetCurrentGameTime()

	kMaster = akMaster
	kSlave = akSlave

	kCrimeFaction = kMaster.GetCrimeFaction()
	akActorBase = kMaster.GetLeveledActorBase() as ActorBase

	SendModEvent("dhlp-Suspend")
	SendModEvent("da_PacifyNearbyEnemies" )

	StorageUtil.SetIntValue(kSlave, "_SD_iEnslavementInitSequenceOn",1)

	debugTrace(" You submit to a new owner.")
	; if (StorageUtil.GetIntValue(kMaster, "_SD_iForcedSlavery")==0)
	;	Debug.Notification("$You submit to a new owner.")
	; Else
	;	Debug.Notification("$Your new owner defeated you.")
	; Endif

	; Drop current weapon - Do this first to prevent camera stuck in combat mode
	if(kSlave.IsWeaponDrawn())
		kSlave.SheatheWeapon()
		Utility.Wait(1.0)
	endif

	fctConstraints.actorCombatShutdown( kSlave )
	; fctConstraints.togglePlayerControlsOff( )

	; a new slave into a slaver faction
	; If ( aiValue2 == 1 )
		; transfer of ownership
	fctFactions.syncActorFactionsByRace( kMaster, kSlave, _SDFLP_allied ) 
	fctFactions.syncActorFactions( kMaster, kSlave, _SDFLP_allied )

	; Force enslavement of followers - Sync factions

	; Else
	;	bOriginallyEnemies = fctFactions.allyToActor( kMaster, kSlave, _SDFLP_slaver, _SDFLP_allied )
	; EndIf

	fctSlavery.StartSlavery( kMaster, kSlave)

	debugTrace(" Your new owner strips you naked.")
	; Debug.Notification("$Your new owner strips you naked.")

	SexLab.StripActor( kSlave, DoAnimate= false)

	If ( bLimitedRemoval )
		StorageUtil.GetIntValue(kSlave, "_SD_iEnableClothingEquip", 1)
	EndIf
	; Utility.Wait(2.0)

	; Debug.SendAnimationEvent( kSlave, "IdleForceDefaultState" )

	; Debug.Trace("_SDQS_enslavement:: start sex 0 == " + aiValue1)
	; If ( aiValue1 == 0 && !kMaster.GetCurrentScene() && !kSlave.GetCurrentScene() )
		; Send story scene - Sex
		; _SDKP_sex.SendStoryEvent( akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 0, aiValue2 = RandomInt( 0, _SDGVP_positions.GetValueInt() ) )

	; EndIf

	; Waking up
	; Game.FadeOutGame(false, true, 2.0, 10)
	; Game.ForceThirdPerson()

	; Debug.SendAnimationEvent(kSlave, "IdleForceDefaultState")
	; fctOutfit.toggleActorClothing (  kSlave,  bStrip = True,  bDrop = False )
	if (fctOutfit.isCollarEquipped(kSlave))
		bIsCollarded = true
	endif

	if (fctOutfit.isArmbinderEquipped(kSlave))
		bIsArmBound = true
	endif

	if (fctOutfit.isShacklesEquipped(kSlave))
		bIsLegsBound = true
	EndIf

	; Remove current collar if already equipped
	if ((bIsCollarded) || (bIsArmBound)) && (StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryBindingsOn")==1)
		fctOutfit.clearDevicesForEnslavement()
	EndIf

	; Transfer of inventory
	fctInventory.TransferInventory( akSlave )

	If ( bLimitedRemoval )
		If ( kSlave.GetItemCount( kRags ) == 0 )
			; kSlave.AddItem( kRags, 1, True)
			kMaster.AddItem( kRags, 1, True)
		Else
			kSlave.RemoveItem( kRags, 1, False, kMaster)
		EndIf
		kSlave.EquipItem( kRags.GetBaseObject() ) ;Inte
	endif

	Utility.Wait(1.0)

	; debugTrace(" You are chained and collared.")
	Debug.Notification("$You are chained and collared.")

	StorageUtil.FormListClear( kSlave, "_SD_lActivePunishmentDevices" )

	if (!fctOutfit.isCollarEquipped(kSlave)) && (StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryCollarOn") == 1) && (!bIsCollarded)
		fctOutfit.equipDeviceByString ( "Collar" )
		fctOutfit.lockDeviceByString( kSlave,  "Collar")
	EndIf

	if (StorageUtil.GetIntValue(kMaster, "_SD_iForcedSlavery") == 1)
		if (!fctOutfit.isArmbinderEquipped(kSlave)) && (StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryBindingsOn")==1) && (!bIsArmBound)
			; fctOutfit.equipDeviceByString ( "Armbinder" )
			PunishSlave(kMaster, kSlave, "WristRestraint")
		EndIf
		if (!fctOutfit.isShacklesEquipped(kSlave)) && (StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryBindingsOn")==1) && (!bIsLegsBound)
			; fctOutfit.equipDeviceByString ( "LegCuffs" )
			PunishSlave(kMaster, kSlave, "LegCuffs")
		EndIf
	Endif

	; if  (Utility.RandomInt(0,100)>( 100 - 10 * (4 - (kMaster.GetAV("morality") as Int) ) ))
	;	PunishSlave( kMaster,  kSlave, "Gag")
	; EndIf

	debugTrace(" Your owner inspects you carefully.")
	; Debug.Notification("$Your owner inspects you carefully.")

	kMaster.AllowPCDialogue( True )
	kMaster.RestoreAV("health", kMaster.GetBaseAV("health") )
	kSlave.RestoreAV("health", kSlave.GetBaseAV("health") )

	kMaster.SetAV("Aggression", 1)
	kMaster.SetAV("Confidence", 3)

	if (kMaster.GetRelationshipRank(kSlave)<0)
		kMaster.SetRelationshipRank(kSlave, -4 )
	Else
		kMaster.SetRelationshipRank(kSlave, 0 )
	EndIf

	If ( kCrimeFaction && !kMaster.IsInFaction( _SDFP_bountyhunter ) )
		iGold = kCrimeFaction.GetCrimeGold()
		iDemerits += Math.Ceiling( Math.abs(iGold) / 100 )
		kCrimeFaction.PlayerPayCrimeGold( True, False )
	EndIf

	; Test slaver tattoo
	debugTrace(" You are marked as your owner's property.")
	; Debug.Notification("$You are marked as your owner's property.")
	fctOutfit.sendSlaveTatModEvent(kMaster, "SD+","Slavers Hand (back)" )

	StorageUtil.SetIntValue(kSlave, "_SD_iEnslavementInitSequenceOn",0)

	fctConstraints.UpdateStanceOverrides(bForceRefresh=True) 

	; if (StorageUtil.GetIntValue(kMaster, "_SD_iForcedSlavery") == 1)
	;	GameHour.Mod(Utility.RandomInt(1,4))
	; endif

	; fctSlavery.DisplaySlaveryLevel(  kMaster, kSlave)
	kMaster.SendModEvent("PCSubStatus")
	kMaster.SendModEvent("SLDRefreshNPCDialogues")

	; ScanSlavePunishment(kSlave)
	UpdateSlaveState(kMaster,kSlave)
EndFunction

Function TransferSlave(Actor akOldMaster, Actor akNewMaster, Actor akSlave)
	ObjectReference keyRef = _SDRAP_key.GetReference() as  ObjectReference 
	ObjectReference cropRef = _SDRAP_crop.GetReference() as  ObjectReference 
	ObjectReference oldMasterRef = akOldMaster as ObjectReference

	fctSlavery.StopSlavery( akOldMaster, akSlave)
	fctFactions.clearSlaveFactions( akSlave )

	_SDRAP_master.ForceRefTo(akNewMaster as ObjectReference)

	EnslavePlayer(akNewMaster, akSlave, _SDGVP_config[3].GetValue() as Bool)

	; Find a way to add missing key / crop for transfer from creature to human master
	if (keyRef != None)
		oldMasterRef.RemoveItem(keyRef as Form, 1, true, akNewMaster as ObjectReference)
	EndIf
	if (cropRef != None)
		oldMasterRef.RemoveItem(cropRef as Form, 1, true, akNewMaster as ObjectReference)
	Endif
EndFunction

Function ResetCage( Actor akSlave)
	ObjectReference cageDoorRef = _SDRAP_cage_door.GetReference() as  ObjectReference 
	ObjectReference cageDoorNewRef
	Form fOldCageDoorID = cageDoorRef as Form
	Form fNewCageDoorID = None
	Bool bCageReset = false

	if (_SDRAP_cage != None)
		; debug.Notification("[SD] Old Cage Door ID: " + fOldCageDoorID.GetFormID() )
		debugTrace(" Old Cage Door ID: " + cageDoorRef )
	endif

	debugTrace(" Looking for a nearby cage")
	_SD_dream_destinations.Start()
	cageDoorNewRef = dreamDest.getNewCage()
	Utility.Wait( 1.0 )

	If (cageDoorNewRef!=None)
		_SDRAP_cage_door.ForceRefTo( cageDoorNewRef )
	 	debugTrace(" Cage alias successfully updated: " + cageDoorNewRef)
		fNewCageDoorID = cageDoorNewRef as Form
		; debug.Notification("[_sdqs_enslavement] New Cage ID: " + fNewCageDoorID.GetFormID() )
	 Else
	 	Debug.Notification("[_sdqs_enslavement] Cage alias failed to update")
	 	debugTrace(" Cage alias failed to update")
	EndIf

	_SD_dream_destinations.Stop()


EndFunction

Function UpdateSlaveState(Actor akMaster, Actor akSlave)
	Int valueCount = StorageUtil.FormListCount(akSlave, "_SD_lActivePunishmentDevices")
	int i = 0
	Form fThisDevice
	String sDeviceName 
	Float fPunishmentDuration  
	Float fPunishmentStartGameTime
	float fPunishmentRemainingtime

	If (akSlave == Game.GetPlayer()) && (!akSlave.IsInCombat()) && (StorageUtil.GetIntValue(akSlave, "_SD_iSlaveryPunishmentOn") == 1) && ( (_SDGVP_snp_busy.GetValue() as Int)<0 )

	 	; Debug.Notification("[_sdqs_enslavement] Update punishment list")
	 	debugTrace(" Update slave state")

		fTimeEnslaved = GetCurrentGameTime() - fEnslavementStart
	 	debugTrace(" Time enslaved: " + fTimeEnslaved)
		
		If ( _SDGVP_demerits.GetValueInt() < uiLowestDemerits )
			uiLowestDemerits = _SDGVP_demerits.GetValueInt()
		EndIf
		If ( _SDGVP_demerits.GetValueInt() > uiHighestDemerits )
			uiHighestDemerits = _SDGVP_demerits.GetValueInt()
		EndIf
		ufMedianDemerits = ( uiHighestDemerits + uiLowestDemerits ) / 2

		while(i < valueCount)
			
			fThisDevice = StorageUtil.FormListGet(akSlave, "_SD_lActivePunishmentDevices", i)
			sDeviceName = StorageUtil.GetStringValue(fThisDevice, "_SD_sPunishmentName")
			fPunishmentStartGameTime = StorageUtil.GetFloatValue(fThisDevice, "_SD_fPunishmentGameTime")
			fPunishmentDuration = StorageUtil.GetFloatValue(fThisDevice, "_SD_fPunishmentDuration")
			fPunishmentRemainingtime = fPunishmentDuration - (_SDGVP_gametime.GetValue() - fPunishmentStartGameTime)

			If (fPunishmentDuration > 0)
				; debugTrace("   Punishment time:" + fPunishmentRemainingtime  )

				; debugTrace(" _SD_fPunishmentGameTime:" + fPunishmentStartGameTime)
				; debugTrace("   fPunishmentDuration:" + fPunishmentDuration)
				; debugTrace("   _SDGVP_gametime:" + _SDGVP_gametime.GetValue())

				debugTrace("		Device [" + i + "] = " + sDeviceName + " - Remaining time: " + fPunishmentRemainingtime)

				If ( fPunishmentRemainingtime <= 0 ) 

					RewardSlave(  akMaster,   akSlave, sDeviceName)
					debugTrace("			Clear punishment duration")
				Else
					; Debug.Trace("Your punishment is not over yet.")
				EndIf				
			EndIf

			if (fPunishmentDuration <= 0.0) && (fctOutfit.isDeviceEquippedString(  akSlave, sDeviceName ))
				; Timer ran out and device still equiped
				fctOutfit.ClearSinglePunishmentDevice( akSlave, sDeviceName )

			Elseif (fPunishmentDuration > 0.0) && (!fctOutfit.isDeviceEquippedString(  akSlave, sDeviceName ))
				; Timer still running and device not equiped
				fctOutfit.EquipSinglePunishmentDevice( akSlave, sDeviceName )
			Endif

			i += 1
		endwhile

		; Variables for inter-mod compatibility now that DD doesn't support ZAP keywords any more
		If (fctOutfit.isCollarEquipped(kSlave)) && (StorageUtil.GetIntValue(akSlave, "_SD_iDeviousCollarOn") == 0)
			StorageUtil.SetIntValue(akSlave, "_SD_iDeviousCollarOn", 1)
		EndIf

		If (fctOutfit.isGagEquipped(kSlave)) && (StorageUtil.GetIntValue(akSlave, "_SD_iDeviousGagOn") == 0)
			StorageUtil.SetIntValue(akSlave, "_SD_iDeviousGagOn", 1)
		EndIf

		fctSlavery.PickSlaveryTask(kSlave) ; evaluate tasks on enslavements

	Else
		If (akSlave != Game.GetPlayer())
			debugTrace(" Update punishment list: Target is not the player")
		endif
	EndIf


EndFunction

Bool Function PunishSlave(Actor akMaster, Actor akSlave, String sDevice)
	Bool punishmentAdded = False
	Keyword kwDeviceKeyword = fctOutfit.getDeviousKeywordByString(sDevice)

	If (akSlave == Game.GetPlayer()) && (StorageUtil.GetIntValue(akSlave, "_SD_iSlaveryPunishmentOn") == 1)
		float fMasterDistance = (akSlave as ObjectReference).GetDistance(akMaster as ObjectReference)

		If (fMasterDistance <= StorageUtil.GetIntValue(kSlave, "_SD_iLeashLength")) && (kwDeviceKeyword!=None)
			; Debug.Notification("$[SD] Slave Punishment")

			if (!fctOutfit.isDeviceEquippedString(kSlave,sDevice))  
				; AddSlavePunishment( akSlave, sDevice)
				fctOutfit.QueueSlavePunishment(akSlave, sDevice, 1.0 + Utility.RandomFloat(1.0, 23.0))
				punishmentAdded = True

			Else
				debugTrace(" Punish slave: Nothing to add. Device already equipped - " + sDevice)
			EndIf

		ElseIf (fMasterDistance > StorageUtil.GetIntValue(kSlave, "_SD_iLeashLength"))
			Debug.Notification("$Your owner is too far to punish you.")
		EndIf
	Else
		debugTrace(" Punish slave: Target is not the player")
	EndIf

	Return 	punishmentAdded 
EndFunction

Bool Function RewardSlave(Actor akMaster, Actor akSlave, String sDevice)
	Bool punishmentRemoved = False
	Keyword kwDeviceKeyword = fctOutfit.getDeviousKeywordByString(sDevice)

	If (akSlave == Game.GetPlayer()) && (StorageUtil.GetIntValue(akSlave, "_SD_iSlaveryPunishmentOn") == 1)
		float fMasterDistance = (akSlave as ObjectReference).GetDistance(akMaster as ObjectReference)

		If (fMasterDistance <= StorageUtil.GetIntValue(kSlave, "_SD_iLeashLength"))
			; Debug.Notification("$[SD] Slave Reward")

			if (fctOutfit.isDeviceEquippedString(kSlave,sDevice))  
				debugTrace(" Reward slave: Trying to remove - " + sDevice)
				; RemoveSlavePunishment( akSlave, sDevice)
				fctOutfit.ClearSlavePunishment(akSlave, sDevice, false)

				punishmentRemoved = True

			Else
				debugTrace(" Reward slave: Nothing to remove. Device missing - " + sDevice)

			EndIf

		ElseIf (fMasterDistance > StorageUtil.GetIntValue(kSlave, "_SD_iLeashLength"))
			Debug.Notification("$Your owner is too far to remove your punishment.")
		EndIf
	Else
		debugTrace(" Reward slave: Target is not the player")
	EndIf

	Return punishmentRemoved 
EndFunction



Function UpdateSlaveFollowerState(Actor akSlave)
	Int idx = 0
	Actor nthActor

	; For now, follower slavery is simple: always bound, always kneeling at rest and close to master
	; We will have to make this part more elaborate in a future version

	; Housekeeping - equip cuffs
	While idx < _SDRAP_companions.Length
		nthActor = _SDRAP_companions[idx].GetReference() as Actor
		If ( nthActor )
			; int index = StorageUtil.FormListFind(Game.GetPlayer(), "_SD_lEnslavedFollower", nthActor)
			; if (index < 0)
				; Debug.Notification("$Not found!")
			; 	StorageUtil.FormListAdd( Game.GetPlayer(), "_SD_lEnslavedFollower", nthActor)
			; endif

			If (StorageUtil.GetIntValue(nthActor, "_SD_iHandsFreeSex") == 0) && ( nthActor.GetDistance( kMaster ) < kneelingDistance ) &&  !fctOutfit.isWristRestraintEquipped( nthActor)
				; nthActor.EquipItem(  _SDA_bindings , True, True )
				; nthActor.SendModEvent("SDEquipDevice","Armbinder:zap")
				fctOutfit.equipDeviceNPCByString (nthActor, sDeviceString = "WristRestraint", sDeviceTags = "armbinder,zap" )

			EndIf

			; Force follower to kneel down
			If (StorageUtil.GetIntValue(kSlave, "_SD_iDisableFollowerAutoKneeling") == 0) && (StorageUtil.GetIntValue(nthActor, "_SD_iHandsFreeSex") == 0)  && (SexLab.ValidateActor( nthActor ) > 0)
				trust = StorageUtil.GetIntValue(kMaster, "_SD_iTrust")  
				kneelingDistance = funct.floatWithinRange( 500.0 - ((trust as Float) * 5.0), 100.0, 2000.0 )

				If ( ( nthActor.GetDistance( kMaster ) < kneelingDistance ) || ( nthActor.GetDistance( kSlave ) < kneelingDistance ) ) && ( nthActor.GetAnimationVariableFloat("Speed") == 0 ) && (StorageUtil.GetStringValue(kSlave, "_SD_sDefaultStanceFollower") != "Standing") && !nthActor.GetCurrentScene() &&  !fctOutfit.isWristRestraintEquipped( nthActor)

					Debug.SendAnimationEvent(nthActor, "ZazAPC018")

				ElseIf !nthActor.GetCurrentScene() &&  !fctOutfit.isWristRestraintEquipped( nthActor)

					Debug.SendAnimationEvent(nthActor, "OffsetBoundStandingStart")

				EndIf
			EndIf

			Faction DefeatDialogueBlockFaction = StorageUtil.GetFormValue( none, "_SD_SexLabDefeatDialogueBlockFaction") As Faction
			If (DefeatDialogueBlockFaction != None)
				If (nthActor.IsInFaction(DefeatDialogueBlockFaction))
			 		debugTrace(" 		Debug - NPC is in Dialogue Blocking Faction from Defeat" )
			 		nthActor.RemoveFromFaction(DefeatDialogueBlockFaction)
				Else
			 		debugTrace(" 		Debug - NPC is NOT in Dialogue Blocking Faction from Defeat" )
				Endif
			Endif
			nthActor.EvaluatePackage()

		EndIf
		idx += 1
	EndWhile

EndFunction

Actor Function GetNearbyEnslavedFollower(Actor akSlave)
	Int idx = 0
	Actor nthActor = None
	Actor thisActor = None

	; For now, follower slavery is simple: always bound, always kneeling at rest and close to master
	; We will have to make this part more elaborate in a future version

	; Housekeeping - equip cuffs
	While idx < _SDRAP_companions.Length
		nthActor = _SDRAP_companions[idx].GetReference() as Actor
		If ( nthActor )

			trust = StorageUtil.GetIntValue(kMaster, "_SD_iTrust")  
			kneelingDistance = funct.floatWithinRange( 500.0 - ((trust as Float) * 5.0), 100.0, 2000.0 )

			If ( ( nthActor.GetDistance( kMaster ) < kneelingDistance ) || ( nthActor.GetDistance( kSlave ) < kneelingDistance ) ) && !nthActor.GetCurrentScene() && (Utility.RandomInt(0,100)>60)

				thisActor = nthActor

			EndIf

		EndIf
		idx += 1
	EndWhile

	If (thisActor == None) && (nthActor != None)
		thisActor = nthActor
	EndIf

	Return thisActor
EndFunction

Function EquipSlaveRags(Actor akSlave)
	ObjectReference kRags = _SDAP_clothing.GetReference() as  ObjectReference 

	akSlave.AddItem( kRags, 1, True )
	akSlave.EquipItem( kRags, True, True )
EndFunction


Function debugTrace(string traceMsg)
	if (StorageUtil.GetIntValue(none, "_SD_debugTraceON")==1)
		Debug.Trace("[_sdqs_enslavement]"  + traceMsg)
	endif
endFunction