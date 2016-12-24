Scriptname _SDRAS_companion extends ReferenceAlias Conditional
_SDQS_functions Property funct  Auto
_SDQS_fcts_followers Property fctFollowers  Auto
_SDQS_fcts_factions Property fctFactions Auto
_SDQS_fcts_outfit Property fctOutfit Auto
_SDQS_fcts_inventory Property fctInventory  Auto

ReferenceAlias Property _SDRAP_playerStorage  Auto  
ReferenceAlias Property _SDRAP_master  Auto

Faction Property _SDFP_slaverResistance  Auto

FormList Property _SDFLP_sex_items  Auto
FormList Property _SDFLP_punish_items  Auto
FormList Property _SDFLP_companion_items  Auto

Outfit Property _SDOP_naked  Auto  
Outfit Property _SDOP_gagged  Auto  
Idle Property OffsetBoundStandingStart  Auto  

Bool bEnslaved = False
Actor kCompanion
Actor kMaster
Actor kPlayer
Float fRFSU = 0.1

Int idx = 0
Armor nthArmor = None

; everytime we add an item to a companion's inventory the weapon
; stack is also re evaluated. 
Function DontUseWeaponsWhenIRemoveAllItemsIReallyMeanIt( Actor akActor )
	If ( akActor.GetEquippedWeapon() )
		akActor.UnequipItem( akActor.GetEquippedWeapon(), false, True )
		akActor.RemoveItem( akActor.GetEquippedWeapon(), 1, True )
	EndIf
	If ( akActor.GetEquippedWeapon(True) )
		akActor.UnequipItem( akActor.GetEquippedWeapon(True), false, True )
		akActor.RemoveItem( akActor.GetEquippedWeapon(True), 1, True )
	EndIf
	If ( akActor.GetEquippedShield() )
		akActor.UnequipItem( akActor.GetEquippedShield(), false, True )
		akActor.RemoveItem( akActor.GetEquippedShield(), 1, True )
	EndIf
	If ( akActor.GetEquippedSpell(0) )
		akActor.UnequipSpell( akActor.GetEquippedSpell(0), 0 )
	EndIf
	If ( akActor.GetEquippedSpell(1) )
		akActor.UnequipSpell( akActor.GetEquippedSpell(1), 1 )
	EndIf
EndFunction


Event OnInit()
	kCompanion = Self.GetReference() as Actor
	kMaster = _SDRAP_master.GetReference() as Actor
	
	Debug.Trace("[_sdras_companion]  Enslaving follower: ") 
	If ( kCompanion ) && (kCompanion!=kMaster)
		Debug.Trace("[_sdras_companion]     Follower name is being enslaved : " + kCompanion.GetName()) 
		GoToState("monitor")
		bEnslaved = False
		kCompanion.SetNoBleedoutRecovery( True )
		; kCompanion.StartCombat( kMaster )
		kCompanion.AddToFaction( _SDFP_slaverResistance )

		; Force proper enslavement of companions for now - add better behaviors later
		enslaveCompanion(  kCompanion )

		RegisterForSingleUpdate( fRFSU )
	Else
		Debug.Trace("[_sdras_companion]     Follower isn't initialized") 
		GoToState("null")
	EndIf
EndEvent

State null

EndState

State monitor
	Event OnCellAttach()
		If ( bEnslaved )
			;kCompanion.playIdle(OffsetBoundStandingStart)
		EndIf
	EndEvent

	Event OnEnterBleedout()
		If (!bEnslaved)
			enslaveCompanion(  kCompanion )
		EndIf
	EndEvent
	
	Event OnUpdate()
		If ( !bEnslaved )
			enslaveCompanion(  kCompanion )
			; If ( !kMaster.IsDead() && kCompanion.GetCombatTarget() != kMaster )
			;	kCompanion.StartCombat( kMaster )
			; EndIf
			RegisterForSingleUpdate( fRFSU )
		EndIf
	EndEvent

EndState

Function enslaveCompanion( Actor kActor)
		bEnslaved = True
		kPlayer = Game.GetPlayer()

		Debug.Trace("[_sdras_companion]       Enslavement starting for " + kActor.GetName()) 

		fctFactions.syncActorFactionsByRace( kMaster, kCompanion ) 
		fctFactions.syncActorFactions( kMaster, kCompanion )

		kActor.RemoveFromFaction( _SDFP_slaverResistance )
		kActor.StopCombat()
		kActor.StopCombatAlarm()

		if (kActor.HasKeyword( _SDKP_actorTypeNPC ))
			; Humanoid followers
			If (Utility.RandomInt(0,100)>80)
				Debug.MessageBox("Your follower is dragged away in bondage...") 
				fctFollowers.sendCaptiveFollowerAway(kActor) 
				; fctOutfit.equipDeviceNPCByString ( kActor, "Yoke", "", false, false, "")

			Else
				; kActor.SendModEvent("SDEquipDevice","Armbinder:zap")
				Debug.Notification("Your follower has been enslaved!")
				; fctOutfit.equipDeviceNPCByString ( kActor, "Armbinder", "", false, false, "zap")
				int index = StorageUtil.FormListFind(kPlayer, "_SD_lEnslavedFollower", kActor)
				if (index < 0)
					; Debug.Notification("Not found!")
					StorageUtil.FormListAdd( kPlayer, "_SD_lEnslavedFollower", kActor)
				else
					; Debug.Notification("Element 183 is at index " + index)
				endif
			EndIf

			Utility.Wait(1.0)

			; if (fctFactions.checkIfSlaverCreatureRace ( kMaster ))
			If (StorageUtil.GetIntValue(kActor, "_SD_iCanBeStripped")!=-1 )
				StorageUtil.SetIntValue(kActor, "_SD_iCanBeStripped", 1)
			EndIf

			If (StorageUtil.GetIntValue(kActor, "_SD_iCanBeStripped") == 1 )
				; fctOutfit.clearDeviceNPCByString ( kActor, "Gag") 
				funct.sexlabStripActor( kActor )
				; kActor.RemoveAllItems(akTransferTo = kMaster, abKeepOwnership = True)
				fctInventory.safeRemoveAllItems ( kActor, _SDRAP_playerStorage.GetReference() )

				; kActor.SetOutfit( _SDOP_gagged )
				; kActor.SetOutfit( _SDOP_gagged, True )
				kActor.SetOutfit( _SDOP_naked )
				kActor.SetOutfit( _SDOP_naked, True )
			EndIf
			
			idx = 0
			While idx < _SDFLP_companion_items.GetSize()
			 	nthArmor = _SDFLP_companion_items.GetAt(idx) as Armor
			 	kActor.AddItem( nthArmor, 1 )
			 	kActor.EquipItem( nthArmor, True, True )
			 	idx += 1
			EndWhile

			DontUseWeaponsWhenIRemoveAllItemsIReallyMeanIt( kActor )
			kActor.playIdle(OffsetBoundStandingStart) 

			fctOutfit.equipDeviceNPCByString ( kActor, "Collar", "", false, false, "zap")
			; fctOutfit.equipDeviceNPCByString ( kActor, "Gag", "", false, false, "zap")

			kActor.EvaluatePackage()
		Else
			; Animal / Creature followers
			If (Utility.RandomInt(0,100)>0)
				fctFollowers.sendCaptiveFollowerAway(kActor)

				Debug.MessageBox("Your follower is dragged away in bondage...")
			EndIf

			kActor.EvaluatePackage()

		EndIf

		Debug.Trace("[_sdras_companion]       Enslavement complete for " + kActor.GetName()) 

EndFunction


Keyword 			Property _SDKP_actorTypeNPC  Auto
