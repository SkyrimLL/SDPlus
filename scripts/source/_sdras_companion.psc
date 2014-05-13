Scriptname _SDRAS_companion extends ReferenceAlias Conditional

ReferenceAlias Property _SDRAP_master  Auto

Faction Property _SDFP_slaverResistance  Auto

FormList Property _SDFLP_sex_items  Auto
FormList Property _SDFLP_punish_items  Auto
FormList Property _SDFLP_companion_items  Auto

Outfit Property _SDOP_naked  Auto  
Idle Property OffsetBoundStandingStart  Auto  

Bool bEnslaved = False
Actor kCompanion
Actor kMaster
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
	
	If ( kCompanion )
		GoToState("monitor")
		bEnslaved = False
		kCompanion.SetNoBleedoutRecovery( True )
		; kCompanion.StartCombat( kMaster )
		kCompanion.AddToFaction( _SDFP_slaverResistance )

		; Force proper enslavement of companions for now - add better behaviors later
		enslaveCompanion(  kCompanion )

		RegisterForSingleUpdate( fRFSU )
	Else
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
			If ( !kMaster.IsDead() && kCompanion.GetCombatTarget() != kMaster )
				kCompanion.StartCombat( kMaster )
			EndIf
			RegisterForSingleUpdate( fRFSU )
		EndIf
	EndEvent

EndState

Function enslaveCompanion( Actor kActor)
	Debug.Notification("[_sdras_companion] Your follower has been ensvlaved.")
		bEnslaved = True

		kActor.RemoveFromFaction( _SDFP_slaverResistance )
		kActor.StopCombat()
		kActor.StopCombatAlarm()

		kActor.RemoveAllItems(akTransferTo = kMaster, abKeepOwnership = True)

		kActor.SetOutfit( _SDOP_naked )
		kActor.SetOutfit( _SDOP_naked, True )
		
		idx = 0
		While idx < _SDFLP_companion_items.GetSize()
			nthArmor = _SDFLP_companion_items.GetAt(idx) as Armor
			kActor.AddItem( nthArmor, 1 )
			kActor.EquipItem( nthArmor, True, True )
			idx += 1
		EndWhile

		DontUseWeaponsWhenIRemoveAllItemsIReallyMeanIt( kActor )
		;kActor.playIdle(OffsetBoundStandingStart)
		kActor.EvaluatePackage()
EndFunction

