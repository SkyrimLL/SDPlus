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

;CagedFollowers
Keyword CagedFollowerQst = none

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

	;CagedFollowers
	CagedFollowerQst = StorageUtil.GetFormValue(none, "_SLS_getCagedFollowerQuestKeyword") as Keyword
	
	Debug.Trace("[_sdras_companion]  Enslaving follower: ") 
	If ( kCompanion ) && (kCompanion!=kMaster)
		Debug.Trace("[_sdras_companion]     Follower name is being enslaved : " + kCompanion.GetName()) 
		Debug.Trace("[_sdras_companion]     		Follower ID : " + kCompanion ) 

		If (kCompanion.IsChild())
			Debug.Trace("[_sdras_companion]     Follower is a child - Aborting") 
			GoToState("null")
		ElseIf (kCompanion == kMaster)
			Debug.Trace("[_sdras_companion]     Follower is the Master! - Aborting") 
			GoToState("null")
		Else
			GoToState("monitor")
			bEnslaved = False
			kCompanion.SetNoBleedoutRecovery( True )
			; kCompanion.StartCombat( kMaster )
			kCompanion.AddToFaction( _SDFP_slaverResistance )

			; Force proper enslavement of companions for now - add better behaviors later
			enslaveCompanion(  kCompanion )

			RegisterForSingleUpdate( fRFSU )
		EndIf
	Else
		Debug.Trace("[_sdras_companion]     Follower isn't initialized - Aborting") 
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
		Debug.Trace("[_sdras_companion]     		Follower ID : " + kCompanion ) 

		fctFactions.syncActorFactionsByRace( kMaster, kCompanion ) 
		fctFactions.syncActorFactions( kMaster, kCompanion )

		kActor.RemoveFromFaction( _SDFP_slaverResistance )
		kActor.StopCombat()
		kActor.StopCombatAlarm()

		if (kActor.HasKeyword( _SDKP_actorTypeNPC ))
			; Humanoid followers

			;;;Start CagedFollowers
			bool processFollower = true
			if CagedFollowerQst && (StorageUtil.GetIntValue(none, "_SLS_isCagedFollowerON")==1)
				if !kActor.HasKeyword(CagedFollowerQst) && (Utility.RandomInt(0,100)>50)
					CagedFollowerQst.SendStoryEvent(akRef1 = kActor, aiValue1 = Utility.RandomInt(0,99))
					; check if quest could be started
					Utility.Wait(5.0)
					if kActor.HasKeyword(CagedFollowerQst)
						processFollower = false
						Self.Clear()
					endif
				endif
			else
			;;;End CagedFollowers
				If (Utility.RandomInt(0,100)>80)

					Debug.MessageBox("Your follower is dragged away in bondage...") 
					fctFollowers.sendCaptiveFollowerAway(kActor) 
					; fctOutfit.equipDeviceNPCByString ( kActor, "Yoke", "", false, false, "")

					;;;Start CagedFollowers
					processFollower = false
				endif
			endif
			if processFollower
			;;;End CagedFollowers
			;else
				; kActor.SendModEvent("SDEquipDevice","Armbinder:zap")
				Debug.Notification("Your follower has been enslaved!")
				; fctOutfit.equipDeviceNPCByString ( kActor, "WristRestraints", "", false, false, "zap")
				int index = StorageUtil.FormListFind(kPlayer, "_SD_lEnslavedFollower", kActor)
				if (index < 0)
					; Debug.Notification("Not found!")
					StorageUtil.FormListAdd( kPlayer, "_SD_lEnslavedFollower", kActor)
				else
					; Debug.Notification("Element 183 is at index " + index)
				endif
			EndIf

			Utility.Wait(1.0)
			;;;CagedFollowers
			if processFollower || CagedFollowerQst == none

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
				
				; Slave gear for Follower disabled for now ... potential issue with disabling all dialogues

				idx = 0
				While idx < _SDFLP_companion_items.GetSize()
				  	nthArmor = _SDFLP_companion_items.GetAt(idx) as Armor
				  	kActor.AddItem( nthArmor, 1 )
				  	kActor.EquipItem( nthArmor, True, True )
				  	idx += 1
				EndWhile

				DontUseWeaponsWhenIRemoveAllItemsIReallyMeanIt( kActor )
				; kActor.playIdle(OffsetBoundStandingStart) 

				; fctOutfit.equipDeviceNPCByString ( kActor, "WristRestraints", "", false, false, "zap")
				; fctOutfit.equipDeviceNPCByString ( kActor, "Collar", "", false, false, "zap")
				; fctOutfit.equipDeviceNPCByString ( kActor, "Gag", "", false, false, "zap")

				kActor.EvaluatePackage()

			;;;CagedFollowers
			endif
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
