Scriptname _SDQS_enslavement extends Quest Conditional
{ USED }
Import Utility

_SDQS_functions Property funct  Auto
_SDQS_fcts_constraints Property fctConstraints  Auto
_SDQS_fcts_inventory Property fctInventory  Auto
_SDQS_fcts_outfit Property fctOutfit  Auto
_SDQS_fcts_factions Property fctFactions  Auto

DialogueFollowerScript Property companionDialogue  Auto
 
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

SexLabFramework Property SexLab  Auto  

ReferenceAlias Property _SDRAP_master  Auto
ReferenceAlias Property _SDRAP_slave  Auto
ReferenceAlias Property _SDRAP_bindings Auto
ReferenceAlias Property _SDRAP_shackles Auto
ReferenceAlias Property _SDRAP_collar Auto

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

Quest Property WEBountyCollectorQST  Auto
Faction Property _SDFP_bountyhunter  Auto

Faction Property _SDFP_spriggan  Auto  
Spell Property _SDSP_spriggan_heal  Auto
ActorBase Property _SDABP_sprigganhost  Auto
Actor Property _SDAP_sanguine  Auto  

GlobalVariable Property _SDGVP_state_housekeeping  Auto  


Bool Property bEscapedSlave = False Auto Conditional
Bool Property bSearchForSlave = False Auto Conditional
Bool Property bJoinedFaction = False Auto Conditional
Bool Property bQuestActive = False Auto Conditional
Bool Property bOriginallyEnemies = False Auto Conditional
Float Property fTimeEnslaved = 0.0 Auto Conditional
Int Property uiPunishmentsEarned = 0 Auto Conditional
Int Property uiLastDemerits = 0 Auto Conditional
Int Property uiHighestDemerits = 0 Auto Conditional
Int Property uiLowestDemerits = 0 Auto Conditional
Float Property ufMedianDemerits = 0.0 Auto Conditional
Float Property ufBindingsHealth = 10.0 Auto Conditional

Float fRFSU = 0.5
Float fRFSUGT = 3.0
Float fEnslavementStart = 0.0

Float fFadeOutTime = 30.0

Actor kMaster
Actor kSlave

Int iGold
Int iDemerits

Faction kCrimeFaction

; ObjectReference akRef1 = master
; ObjectReference akRef2 = slave
Event OnStoryScript(Keyword akKeyword, Location akLocation, ObjectReference akRef1, ObjectReference akRef2, int aiValue1, int aiValue2)
	ObjectReference shackles = _SDRAP_shackles.GetReference() as ObjectReference
	ObjectReference bindings = _SDRAP_bindings.GetReference() as ObjectReference
	ObjectReference collar = _SDRAP_collar.GetReference() as ObjectReference
	iGold = 0

	kMaster = akRef1 as Actor
	kSlave = akRef2 as Actor
	kCrimeFaction = kMaster.GetCrimeFaction()
	
; 	Debug.Notification("_SDQS_enslavement:: bQuestActive == " + bQuestActive)
	If ( !bQuestActive )
		bQuestActive = True

		; Add while loop to check for Ragdoll effect
		; Wait until ragdoll expires / find a way to turn it off or trigger enslavement AFTER ragdoll is over

		fEnslavementStart = GetCurrentGameTime()

		; Debug.SendAnimationEvent(kSlave, "Unequip")
		; Debug.SendAnimationEvent(kSlave, "UnequipNoAnim")


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


		If ( kSlave.IsSneaking() )
			kSlave.StartSneaking()
		EndIf

		Utility.Wait(1.0)

		Debug.Trace("[SD] enslavement Zaz animation goes here.")
		; Debug.SendAnimationEvent(Game.GetPlayer(), "Unequip")
		; Debug.SendAnimationEvent(Game.GetPlayer(), "ZazAPC057")
	
		kSlave.StopCombatAlarm()
		kSlave.StopCombat()
		Game.ForceThirdPerson()

		; ---

		_SDGVP_stats_enslaved.Mod( 1.0 )
		_SDGVP_enslaved.SetValue(1)

		; a new slave into a slaver faction
		If ( aiValue2 == 0 )
			bOriginallyEnemies = fctFactions.allyToActor( kMaster, kSlave, _SDFLP_slaver, _SDFLP_allied )
		; transfer of ownership
		ElseIf ( aiValue2 == 1 )
			fctFactions.syncActorFactions( kMaster, kSlave, _SDFLP_allied )
		EndIf

		kMaster.AllowPCDialogue( True )
		; funct.actorCombatShutdown( kMaster )
		; funct.actorCombatShutdown( kSlave )
		fctConstraints.togglePlayerControlsOff( )

		; item cleanup
		_SDGVP_state_housekeeping.SetValue(0)
		; funct.removeItemsInList( kSlave, _SDFLP_sex_items )
		; funct.removeItemsInList( kSlave, _SDFLP_punish_items )
		; fctInventory.removeItemsInList( akPlayer, _SDFLP_master_items )
		_SDGV_leash_length.SetValue(400)

		; Transfer of inventory
		If ( aiValue2 == 0 )
			If ( _SDGVP_config[3].GetValue() as Bool )
				fctInventory.limitedRemoveAllItems ( kSlave, _SDRAP_playerStorage.GetReference(), True, _SDFLP_ignore_items )
			Else
				; kSlave.RemoveAllItems(akTransferTo = kMaster, abKeepOwnership = True)
				kSlave.RemoveAllItems(akTransferTo = _SDRAP_playerStorage.GetReference(), abKeepOwnership = True)

				; Testing use of limitedRemove for all cases to allow for detection of Devious Devices, SoS underwear and other exceptions
				; fctInventory.limitedRemoveAllItems ( kSlave, kMaster, True )

			EndIf
		EndIf		

		Utility.Wait(2.0)
		kMaster.RestoreAV("health", kMaster.GetBaseAV("health") )
		kSlave.RestoreAV("health", kSlave.GetBaseAV("health") )

		kMaster.SetAV("Aggression", 1)
		kMaster.SetAV("Confidence", 3)

		if (kMaster.GetRelationshipRank(kSlave)<0)
			kMaster.SetRelationshipRank(kSlave, -4 )
		Else
			kMaster.SetRelationshipRank(kSlave, 0 )
		EndIf

		_SDGVP_demerits.SetValueInt( aiValue1 )
		_SDGVP_state_housekeeping.SetValue(1)
		_SDKP_trust_hands.SetValue(0)
		_SDKP_trust_feet.SetValue(0)
		
		If ( kCrimeFaction && !kMaster.IsInFaction( _SDFP_bountyhunter ) )
			iGold -= kCrimeFaction.GetCrimeGold()
			iDemerits += Math.Ceiling( Math.abs(iGold) / 100 )
			kCrimeFaction.PlayerPayCrimeGold( True, False )
		EndIf

		; Getting an error in log when I try to set a value to these two globals here 
		; Commenting out for now

		_SDGVP_buyout.SetValue( (_SDGVP_buyout.GetValue() as Int)  - 100 + 50 * (kMaster.GetAV("confidence") as Int) )
		_SDGVP_demerits_join.SetValue(  - 20 - 10 * (4 - (kMaster.GetAV("morality") as Int) ) )

		Self.ModObjectiveGlobal( iGold, _SDGVP_buyoutEarned, 2, _SDGVP_buyout.GetValue() as Float, False, True, True )
		Self.ModObjectiveGlobal( iDemerits, _SDGVP_demerits, 3, _SDGVP_demerits_join.GetValue() as Float, False, True, True )
		Utility.Wait(1.0)
		
		; Debug.SendAnimationEvent(kSlave, "IdleForceDefaultState")

		; Outfit selection - Commoner by default

		int outfitID = 0

		if (kMaster.HasKeyword( ActorTypeNPC ))
			if ( (kMaster.GetAV("Magicka") as Int) > (kMaster.GetAV("Health") as Int) ) && ( (kMaster.GetAV("Magicka") as Int) > (kMaster.GetAV("Stamina") as Int) )
				; Greater magicka - use magicka outfit
				outfitID = 2
			Elseif ( (kMaster.GetAV("Health") as Int) > (kMaster.GetAV("Magicka") as Int) ) && ( (kMaster.GetAV("Health") as Int) > (kMaster.GetAV("Stamina") as Int) )
				; Greater health - use wealthy outfit
				outfitID = 1
			EndIf
		Else
			outfitID = 3
		EndIf

		Utility.Wait(1.0)

		fctOutfit.setDeviousOutfitID ( iOutfit = outfitID, sMessage = "Your new owner quickly locks you into slavery.")

		if (1==0) && (Utility.RandomInt(0,100)> ( 100 - 10 * (4 - (kMaster.GetAV("morality") as Int) ) ) )

			; Replace by function with detection of currently worn collar / outfit
			fctOutfit.setDeviousOutfitCollar ( bDevEquip = False, sDevMessage = "")
			Utility.Wait(1.0)
			fctOutfit.setDeviousOutfitHarness ( bDevEquip = True, sDevMessage = "")
		Else
			fctOutfit.setDeviousOutfitCollar ( bDevEquip = True, sDevMessage = "")
		EndIf

		fctOutfit.setDeviousOutfitArms ( bDevEquip = True, sDevMessage = "")
		fctOutfit.setDeviousOutfitLegs ( bDevEquip = True, sDevMessage = "")

		if (Utility.RandomInt(0,100)>( 100 - 10 * (4 - (kMaster.GetAV("morality") as Int) ) ))
			fctOutfit.setDeviousOutfitGag ( bDevEquip = True, sDevMessage = "")
		EndIf

		if (Utility.RandomInt(0,100)>( 100 - 10 * (4 - (kMaster.GetAV("morality") as Int) ) ))
			fctOutfit.setDeviousOutfitBlindfold ( bDevEquip = True, sDevMessage = "")
		EndIf

		StorageUtil.StringListAdd(kMaster, "_DDR_DialogExclude", "SD+:Master")

		; Devious outfit - wealthy masters
		; fctOutfit.setDeviousOutfit ( iOutfit = 1, iOutfitPart = -1, bEquip = True, sMessage = "Your new owner quickly locks you into slavery.")

		

		SetObjectiveDisplayed( 0 )
		SetObjectiveDisplayed( 1 )
		SetObjectiveDisplayed( 2 )
		SetObjectiveDisplayed( 3 )
		Utility.Wait(2.0)


		; Debug.SendAnimationEvent( kSlave, "IdleForceDefaultState" )

		;Debug.Trace("_SDQS_enslavement:: start sex 0 == " + aiValue1)
		If ( aiValue1 == 0 && !kMaster.GetCurrentScene() && !kSlave.GetCurrentScene() )
			; Send story scene - Sex
			; _SDKP_sex.SendStoryEvent( akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 0, aiValue2 = RandomInt( 0, _SDGVP_positions.GetValueInt() ) )

		EndIf
		If ( Self )
			RegisterForSingleUpdate( fRFSU )
			RegisterForSingleUpdateGameTime( fRFSUGT )
		EndIf
	ElseIf ( _SDGVP_config[0].GetValue() )
;		kSlave.GetActorBase().SetEssential( False )
	EndIf

EndEvent

Auto State enslaved
	Event OnUpdate()
		While ( !Game.GetPlayer().Is3DLoaded() )
		EndWhile
		fTimeEnslaved = GetCurrentGameTime() - fEnslavementStart
		
		If ( _SDGVP_demerits.GetValueInt() < uiLowestDemerits )
			uiLowestDemerits = _SDGVP_demerits.GetValueInt()
		EndIf
		If ( _SDGVP_demerits.GetValueInt() > uiHighestDemerits )
			uiHighestDemerits = _SDGVP_demerits.GetValueInt()
		EndIf
		ufMedianDemerits = ( uiHighestDemerits + uiLowestDemerits ) / 2
		
		If ( Self.IsRunning() )
			RegisterForSingleUpdate( fRFSU )
		EndIf
	EndEvent

	Event OnUpdateGameTime()
		While ( !Game.GetPlayer().Is3DLoaded() )
		EndWhile
		
		If ( ufMedianDemerits < 256.0 )
			Self.ModObjectiveGlobal( -2.0, _SDGVP_demerits, 3, _SDGVP_demerits_join.GetValue() as Float, False, True, _SDGVP_config[4].GetValueInt() as Bool )
		EndIf

		If ( Self.IsRunning() )
			RegisterForSingleUpdateGameTime( fRFSUGT )			
		EndIf
	EndEvent
EndState


Function UpdateSlaveState(Actor akSlave)

	; Devious devices and punishment items restrictions

	If (akSlave == Game.GetPlayer())
		uiPunishmentsEarned = Utility.RandomInt(0,2)
		Debug.Notification("[_sdqs_enslavement] Updating slave state: " + uiPunishmentsEarned )

		Self.ModObjectiveGlobal( _SDFP_slaverCrimeFaction.GetCrimeGold() / 100.0, _SDGVP_demerits, 3, _SDGVP_demerits_join.GetValue() as Float, False, True, _SDGVP_config_verboseMerits.GetValueInt() as Bool )
		_SDFP_slaverCrimeFaction.PlayerPayCrimeGold( True, False )
		uiLastDemerits = _SDGVP_demerits.GetValueInt()

		Int idx = 0
		ObjectReference bindings = _SDRAP_bindings.GetReference() as ObjectReference

		; If ( !akSlave.IsEquipped( bindings ) )
		;	akSlave.AddItem( bindings )
		; EndIf

		Armor item = None
		Form kForm = None

		; Anal plug
		; If (uiPunishmentsEarned == 0)
		If (Utility.RandomInt(0,100) >= 60)
			Debug.Notification("[_sdqs_enslavement] Adding punishment item: Anal plug" )
				
			fctOutfit.setDeviousOutfitPlugAnal ( bDevEquip = True, sDevMessage = "")
		Else
			Debug.Notification("[_sdqs_enslavement] Removing punishment item: Anal plug" )
				
			fctOutfit.setDeviousOutfitPlugAnal ( bDevEquip = False, sDevMessage = "")
		EndIf

		; Blinds
		If (Utility.RandomInt(0,100) >= 60)
			Debug.Notification("[_sdqs_enslavement] Adding punishment item: Blinds" )
				
			fctOutfit.setDeviousOutfitBlindfold ( bDevEquip = True, sDevMessage = "")
		Else
			Debug.Notification("[_sdqs_enslavement] Removing punishment item: Blinds" )
				
			fctOutfit.setDeviousOutfitBlindfold ( bDevEquip = False, sDevMessage = "")
		EndIf

		; Gag

		If (Utility.RandomInt(0,100) >= 60)
			Debug.Notification("[_sdqs_enslavement] Adding punishment item: Gag: " + idx )

			fctOutfit.setDeviousOutfitGag ( bDevEquip = True, sDevMessage = "")

		ElseIf (uiPunishmentsEarned - 6 < 1)
			Debug.Notification("[_sdqs_enslavement] Removing punishment item: Gag "  )

			fctOutfit.setDeviousOutfitGag ( bDevEquip = False, sDevMessage = "")

		
		EndIf

	Else
		Debug.Notification("[_sdqs_enslavement] Target is not the player")
	EndIf
EndFunction



Function UpdateSlaveFollowerState(Actor akSlave)
		Int idx = 0
		Actor nthActor
		While idx < _SDRAP_companions.Length
			nthActor = _SDRAP_companions[idx].GetReference() as Actor
			If ( nthActor )
				nthActor.EquipItem(  _SDA_bindings , True, True )
			EndIf
			idx += 1
		EndWhile
EndFunction

Faction Property _SDFP_slaverCrimeFaction  Auto 
GlobalVariable Property _SDGVP_config_verboseMerits  Auto
GlobalVariable Property _SDGVP_trust_hands  Auto  
GlobalVariable Property _SDGVP_trust_feet  Auto  
ReferenceAlias[] Property _SDRAP_companions Auto
Armor Property _SDA_bindings  Auto  

ReferenceAlias Property _SDRAP_playerStorage  Auto  
