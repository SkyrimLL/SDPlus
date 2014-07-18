Scriptname _SDRAS_slave extends ReferenceAlias
{ USED }
Import Utility

_SDQS_snp Property snp Auto
_SDQS_enslavement Property enslavement  Auto
_SDQS_functions Property funct  Auto
_SDQS_fcts_outfit Property fctOutfit  Auto

MiscObject Property _SDMOP_lockpick  Auto  

Quest Property _SDQP_enslavement_tasks  Auto
Quest Property _SDQP_thug_slave  Auto

Quest Property _SD_dreamQuest  Auto

ReferenceAlias Property Alias__SDRA_lust_m  Auto
ReferenceAlias Property Alias__SDRA_lust_f  Auto

Cell[] Property _SDCP_sanguines_realms  Auto  

GlobalVariable Property _SDGVP_config_lust auto
GlobalVariable Property _SDGV_leash_length  Auto
GlobalVariable Property _SDGV_free_time  Auto
GlobalVariable Property _SDGVP_positions  Auto  
GlobalVariable Property _SDGVP_demerits  Auto  
GlobalVariable Property _SDGVP_demerits_join  Auto  
GlobalVariable Property _SDGVP_config_verboseMerits  Auto
GlobalVariable Property _SDGVP_escape_radius  Auto  
GlobalVariable Property _SDGVP_escape_timer  Auto  
GlobalVariable Property _SDGVP_state_caged  Auto  
GlobalVariable Property _SDGVP_config_safeword  Auto  
GlobalVariable Property _SDKP_trust_hands  Auto  
GlobalVariable Property _SDKP_trust_feet   Auto  
GlobalVariable Property _SDKP_snp_busy   Auto  
GlobalVariable Property _SDGVP_punishments  Auto  

ReferenceAlias Property _SDRAP_cage  Auto
ReferenceAlias Property _SDRAP_masters_key  Auto
ReferenceAlias Property _SDRAP_slave  Auto
ReferenceAlias Property _SDRAP_master  Auto
ReferenceAlias Property _SDRAP_bindings  Auto
ReferenceAlias Property _SDRAP_shackles  Auto
Float Property _SDFP_bindings_health = 10.0 Auto

FormList Property _SDFLP_master_items  Auto
FormList Property _SDFLP_sex_items  Auto
FormList Property _SDFLP_punish_items  Auto  
FormList Property _SDFLP_trade_items  Auto
FormList Property _SDFLP_slave_clothing  Auto
FormList Property _SDFLP_banned_locations  Auto  
FormList Property _SDFLP_banned_worldspaces  Auto  

Keyword Property _SDKP_enslave  Auto
Keyword Property _SDKP_sex  Auto
Keyword Property _SDKP_arrest  Auto
Keyword Property _SDKP_gagged  Auto
Keyword Property _SDKP_bound  Auto
Keyword Property _SDKP_wrists  Auto
Keyword Property _SDKP_ankles  Auto
; these keywords are usually associated with quest items.
; i.e. prevent selling or disenchanting them.
Keyword Property _SDKP_noenchant  Auto  
Keyword Property _SDKP_nosale  Auto  
Keyword Property _SDKP_food  Auto  
Keyword Property _SDKP_food_raw  Auto  
Keyword Property _SDKP_food_vendor  Auto  

Faction Property _SDFP_slaversFaction  Auto  
Spell Property _SDSP_SelfShock  Auto  
Spell Property _SDSP_Weak  Auto  


; LOCAL
Int iuType
Float fCalcLeashLength
Float fCalcOOCLimit = 10.0
Float fDamage
Float fDistance
Float fEscapeTime
Float fEscapeUpdateTime
Float fOutOfCellTime

Float fLastIngest
Float fLastEscape

Actor kMaster
Actor kSlave
Actor kCombatTarget
ObjectReference kBindings
ObjectReference kShackles
ObjectReference kCollar
ObjectReference kGag

Float fRFSU = 0.5

Int iuIdx
Int iuCount
Form kAtIdx
Float fTime

Bool[] uiSlotDevice
Int iWristsDevice = 0 ;59  Bindings
Int iCollarDevice = 1 ;45  Collar
Int iAnklesDevice = 2 ;53  Ankles
Int iGagDevice = 4 ;44  DD Gag
Form fGagDevice = None

Function freedomTimer( Float afTime )
	If ( afTime >= 60.0 )
		Debug.Notification( Math.Floor( afTime / 60.0 ) + " min.," + ( Math.Floor( afTime ) % 60 ) + " sec. and you're free!" )
	Else
		Debug.Notification( Math.Floor( afTime ) + " sec. and you're free!" )
	EndIf
EndFunction


Event OnInit()
	If ( Self.GetOwningQuest() )
		RegisterForSingleUpdate( fRFSU )
	EndIf
	GoToState("waiting")
EndEvent

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
	If ( _SDFLP_banned_locations.HasForm( akNewLoc ) )
		Debug.Trace("[_sdras_slave] Banned location - Stop enslavement")
		Self.GetOwningQuest().Stop()
		Wait( fRFSU * 5.0 )
	EndIf
	If ( _SDFLP_banned_worldspaces.HasForm( kSlave.GetWorldSpace() ) )

		Debug.Trace("[_sdras_slave] Banned worldspace - Stop enslavement")
		Self.GetOwningQuest().Stop()
		Wait( fRFSU * 5.0 )
	EndIf
EndEvent

Event OnAnimationEvent(ObjectReference akSource, string asEventName)
	If ( akSource == Self.GetReference() && asEventName == "weaponDraw" && Self.GetOwningQuest().GetStage() >= 90 )
		Debug.Trace("[_sdras_slave] Weapon draw - Stop enslavement")
		Self.GetOwningQuest().Stop()			
	EndIf
EndEvent

Event OnCombatStateChanged(Actor akTarget, int aeCombatState)
	If ( aeCombatState == 0 )
		GoToState("monitor")
	Else
		GoToState("escape")
	EndIf
EndEvent

Event OnItemAdded(Form akBaseItem, Int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	If ( Self.GetOwningQuest().GetStage() >= 90 || _SDFLP_sex_items.Find( akBaseItem ) >= 0 || _SDFLP_punish_items.Find( akBaseItem ) >= 0 || _SDFLP_slave_clothing.Find( akBaseItem ) >= 0 )
		Return
	EndIf
	If ( akBaseItem.HasKeyword(_SDKP_noenchant) || akBaseItem.HasKeyword(_SDKP_nosale) )
		Return
	EndIf
	
	iuType = akBaseItem.GetType()
	
	If ( akItemReference == _SDRAP_masters_key.GetReference() )
		; escape
		Debug.Trace("[_sdras_slave] Master key - Stop enslavement")
		kSlave.RemoveItem(akItemReference, aiItemCount)

		fctOutfit.setDeviousOutfitArms ( bDevEquip = False, sDevMessage = "")
		fctOutfit.setDeviousOutfitLegs ( bDevEquip = False, sDevMessage = "")
		fctOutfit.setDeviousOutfitBlindfold ( bDevEquip = False, sDevMessage = "")
	
		if (Utility.RandomInt(0,100) < 90)
			fctOutfit.setDeviousOutfitCollar ( bDevEquip = False, sDevMessage = "")
			Debug.Messagebox("Your Master's Key helps you break free of your chains.")
		Else
			Debug.MessageBox("Your Master's Key helps you break free of your chains but the key snapped as you tried to force your collar open.")
		EndIf

		Self.GetOwningQuest().Stop()
		Utility.Wait(2.0)
		Return
	ElseIf ( iuType == 41 || iuType == 42 )

		If ( GetCurrentRealTime() - fLastEscape < 5.0 )
			Debug.Notification( "$SD_MESSAGE_WAIT_5_SEC" )
			kSlave.DropObject(akBaseItem, aiItemCount)
		Else
			fDamage = ( akBaseItem as Weapon ).GetBaseDamage() as Float

			If ( fDamage <= 0.0 )
				fDamage = Utility.RandomFloat( 1.0, 4.0 )
			EndIf

			_SDFP_bindings_health -= fDamage
			enslavement.ufBindingsHealth = _SDFP_bindings_health
			If ( _SDFP_bindings_health < 0.0 && !_SDGVP_state_caged.GetValueInt() )
				Debug.Trace("[_sdras_slave] Broken chains - Stop enslavement")
				Debug.Messagebox("You manage to break your chains with a weapon.")

				fctOutfit.setDeviousOutfitArms ( bDevEquip = False, sDevMessage = "")
				fctOutfit.setDeviousOutfitLegs ( bDevEquip = False, sDevMessage = "")
				fctOutfit.setDeviousOutfitBlindfold ( bDevEquip = False, sDevMessage = "")

				Self.GetOwningQuest().Stop()
				Return
			Else
				kSlave.DropObject(akBaseItem, aiItemCount)
			EndIf
		EndIf
		fLastEscape = GetCurrentRealTime()

	EndIf
EndEvent

State waiting
	Event OnUpdate()
		If ( Self.GetOwningQuest().IsRunning() )
			GoToState("monitor")
		EndIf
		If ( Self.GetOwningQuest() )
			RegisterForSingleUpdate( fRFSU )
		EndIf
	EndEvent
EndState

State monitor
	Event OnBeginState()

		kMaster = _SDRAP_master.GetReference() as Actor
		kSlave = _SDRAP_slave.GetReference() as Actor
;		kBindings = _SDRAP_bindings.GetReference() as ObjectReference
;		kShackles = _SDRAP_shackles.GetReference() as ObjectReference
;		kCollar = _SDRAP_collar.GetReference() as ObjectReference

		fOutOfCellTime = GetCurrentRealTime()
		fLastEscape = GetCurrentRealTime() - 5.0
		fLastIngest = GetCurrentRealTime() - 5.0

		If ( RegisterForAnimationEvent(kSlave, "weaponDraw") )
		EndIf
	EndEvent
	
	Event OnEndState()
		If ( UnregisterForAnimationEvent(kSlave, "weaponDraw") )
		EndIf
	EndEvent

	Event OnUpdate()
		While ( !Game.GetPlayer().Is3DLoaded() )
		EndWhile

		enslavement.UpdateSlaveState(kMaster ,kSlave)
		enslavement.UpdateSlaveFollowerState(kSlave)
		
		fDistance = kSlave.GetDistance( kMaster )
		kCombatTarget = kSlave.GetCombatTarget()

		If (_SDGVP_config_safeword.GetValue() as bool)
			Debug.MessageBox( "Safeword: You are released from enslavement.")
			_SDGVP_state_joined.SetValue( 0 )
			_SDGVP_config_safeword.SetValue(0)
			Self.GetOwningQuest().Stop()
		ElseIf (_SDGVP_demerits.GetValue()>200) && (_SD_dreamQuest.GetStage() != 0) && (SexLab.ValidateActor( SexLab.PlayerRef ) > 0)
			_SD_dreamQuest.SetStage(20)
		ElseIf ( Self.GetOwningQuest().IsStopping() || Self.GetOwningQuest().IsStopped() )
			GoToState("waiting")
		ElseIf ( _SDGV_leash_length.GetValue() == -10) ; escape trigger in some situations
		;	If (RandomInt( 0, 100 ) > 80 )
		;		Debug.Notification( "Keep running!...")
		;	EndIf
		;	enslavement.bEscapedSlave = False
		;	enslavement.bSearchForSlave = False
		;	Self.GetOwningQuest().Stop()
			_SDGV_leash_length.SetValue(400)
		ElseIf ( Self.GetOwningQuest().GetStage() >= 90 )
			fOutOfCellTime = GetCurrentRealTime()
			enslavement.bEscapedSlave = False
			enslavement.bSearchForSlave = False
		ElseIf ( _SDCP_sanguines_realms.Find( kSlave.GetParentCell() ) > -1 )
			fOutOfCellTime = GetCurrentRealTime()
			enslavement.bEscapedSlave = False
			enslavement.bSearchForSlave = False
		ElseIf ( !Game.IsMovementControlsEnabled() || kSlave.GetCurrentScene() )
			fOutOfCellTime = GetCurrentRealTime()
			enslavement.bEscapedSlave = False
			enslavement.bSearchForSlave = False
		ElseIf ( _SDGVP_state_caged.GetValueInt() )
			GoToState("caged")
		ElseIf ((kSlave.GetParentCell() == kMaster.GetParentCell()) && (kMaster.GetParentCell().IsInterior()))
			If (RandomInt( 0, 100 ) > 95 )
				Debug.Notification( "Your collar weighs around your neck..." )
			EndIf
			GoToState("waiting")		
		ElseIf ( fDistance > _SDGVP_escape_radius.GetValue() || kMaster.IsInCombat() )
			GoToState("escape")
		Else
			If ( kBindings && !kSlave.IsEquipped( kBindings.GetBaseObject() ) )
				fOutOfCellTime = GetCurrentRealTime()
				iuIdx = 0
				While iuIdx < _SDFLP_trade_items.GetSize()
					kAtIdx  = _SDFLP_trade_items.GetAt( iuIdx )
					iuCount = kSlave.GetItemCount( kAtIdx )
					iuType  = kAtIdx.GetType()
					If ( iuCount && !kSlave.IsEquipped( kAtIdx ) && ( iuType == 26 || ( iuType == 41 && !( kAtIdx as Weapon ).IsDagger() ) ) )
						kSlave.DropObject( kAtIdx, iuCount )
					EndIf
					iuIdx += 1
				EndWhile
			EndIf

			If ( !_SDQP_enslavement_tasks.IsRunning() )
				fCalcLeashLength = _SDGV_leash_length.GetValue() * 1.5		

				If (kMaster.GetParentCell().IsInterior()) 
					; Debug.Notification( "Master inside") 
				Else
					; Debug.Notification( "Master outside")
				EndIf
				If (kMaster.GetParentCell() == kSlave.GetParentCell()) 
					; Debug.Notification( "Slave and master in same cell ") 
				Else
					; Debug.Notification( "Slave and master in diff cells ") 
				EndIf

				If (( fDistance > fCalcLeashLength ) && ( kMaster.GetSleepState() == 0 )  && (kMaster.GetParentCell() == kSlave.GetParentCell()) && (!kMaster.GetParentCell().IsInterior()) && ( _SDGV_leash_length.GetValue() > 0))
					If ( fDistance < fCalcLeashLength * 2 )
						; Up to twice the leash, Master will walk towards slave
						; Debug.Notification( "$SD_MESSAGE_STAY_CLOSE_TO_MASTER" )
						; Debug.Notification( "[Master follows you]" )

						fOutOfCellTime = GetCurrentRealTime()
						; _SDSP_SelfShock.Cast(kSlave as Actor, kSlave as Actor)
						; _SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 10)
					ElseIf ( kMaster.HasLOS( kSlave ))
						; Debug.notification( "Escape auto detected -  _SDRAS_slave 1" )
						; Debug.Notification( "[Master can see you leave]" )
						Self.GetOwningQuest().ModObjectiveGlobal( 1.0, _SDGVP_demerits, -1, _SDGVP_demerits_join.GetValue() as Float, False, True, _SDGVP_config_verboseMerits.GetValueInt() as Bool )

						fOutOfCellTime = GetCurrentRealTime()
						; _SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 10)
					ElseIf ( GetCurrentRealTime() - fOutOfCellTime > fCalcOOCLimit )
						; Debug.Notification( "[Master did not see you]" )
						Self.GetOwningQuest().ModObjectiveGlobal( 3.0, _SDGVP_demerits, -1, _SDGVP_demerits_join.GetValue() as Float, False, True, _SDGVP_config_verboseMerits.GetValueInt() as Bool )
						fOutOfCellTime = GetCurrentRealTime() + 30
						; _SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 =  kSlave, aiValue1 = 10)
					Else
						; Debug.Notification( "[Master ignores you]" )
					EndIf

				Else
					; Debug.Notification( "[Master is busy]" )
				EndIf
			Else
				If (RandomInt( 0, 100 ) > 80 )
					; Debug.Notification( "Don't forget your assignment..." )
				EndIf	

				If (kMaster.GetParentCell().IsInterior()) 
					; Debug.Notification( "Master inside") 
				Else
					; Debug.Notification( "Master outside")
				EndIf
				If (kMaster.GetParentCell() == kSlave.GetParentCell()) 
					; Debug.Notification( "Slave and master in same cell ") 
				Else
					; Debug.Notification( "Slave and master in diff cells ") 
				EndIf
			EndIf
		EndIf

		If ( Self.GetOwningQuest() )
			RegisterForSingleUpdate( fRFSU )
		EndIf
	EndEvent

	Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, Bool abPowerAttack, Bool abSneakAttack, Bool abBashAttack, Bool abHitBlocked)
		If ( akAggressor != kMaster && Self.GetOwningQuest().GetStage() < 90)
			kSlave.StopCombatAlarm()
			kSlave.StopCombat()
			If ( ( akAggressor as Actor ).IsHostileToActor( kMaster ) )
				kMaster.StartCombat( akAggressor as Actor )
			EndIf
		EndIf
	EndEvent
	
	Event OnItemAdded(Form akBaseItem, Int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
		If ( Self.GetOwningQuest().GetStage() >= 90 ) || ( akBaseItem.HasKeyword(_SDKP_noenchant) || akBaseItem.HasKeyword(_SDKP_nosale) )
			Return
		EndIf

;		Debug.Notification("[_sdras_slave] Adding item: " + akBaseItem)
;		Debug.Notification("[_sdras_slave] Slave bound status: " + kSlave.WornHasKeyword( _SDKP_bound ) )

		iuType = akBaseItem.GetType()
		_SDFLP_trade_items.AddForm( akBaseItem )

;		Debug.Notification("[_sdras_slave] Item type: " + iuType)

		If ( akItemReference == _SDRAP_masters_key.GetReference() )
			; escape
			Debug.Trace("[_sdras_slave] Master key stolen - Stop enslavement")

			fctOutfit.setDeviousOutfitArms ( bDevEquip = False, sDevMessage = "")
			fctOutfit.setDeviousOutfitLegs ( bDevEquip = False, sDevMessage = "")
			fctOutfit.setDeviousOutfitBlindfold ( bDevEquip = False, sDevMessage = "")
		
			if (Utility.RandomInt(0,100) < 90)
				fctOutfit.setDeviousOutfitCollar ( bDevEquip = False, sDevMessage = "")
				Debug.Messagebox("Your Master's Key helps you break free of your chains.")
			Else
				Debug.MessageBox("Your Master's Key helps you break free of your chains but the key snapped as you tried to force your collar open.")
			EndIf
			
			Self.GetOwningQuest().Stop()
			kSlave.RemoveItem(akItemReference, aiItemCount)
			_SDKP_trust_hands.SetValue(1) 
			_SDKP_trust_feet.SetValue(1) 
			Return
		ElseIf ( kSlave.WornHasKeyword( _SDKP_bound ) )
			Debug.Notification( "$SD_MESSAGE_MASTER_AWARE" )
			
			; kPotion = 46
			If ( iuType == 46 || akBaseItem.HasKeyword( _SDKP_food ) || akBaseItem.HasKeyword( _SDKP_food_raw ) || akBaseItem.HasKeyword( _SDKP_food_vendor ) )
				If ( GetCurrentRealTime() - fLastIngest > 5.0 && !fctOutfit.isGagEquipped(kSlave) )
					If ( aiItemCount - 1 > 0 )
						kSlave.DropObject(akBaseItem, aiItemCount - 1)
					EndIf
					kSlave.EquipItem(akBaseItem, True, True)
				Else
					If ( kSlave.WornHasKeyword( _SDKP_gagged ) )
						Debug.Notification( "$SD_MESSAGE_GAGGED" )
					EndIf
					If ( GetCurrentRealTime() - fLastIngest <= 5.0 )
						Debug.Notification( "$SD_MESSAGE_WAIT_5_SEC" )
					EndIf
					kSlave.DropObject(akBaseItem, aiItemCount)
				EndIf
				fLastIngest = GetCurrentRealTime()
			ElseIf ( iuType == 41 || iuType == 42 ) ; weapon or ammo
				If ( GetCurrentRealTime() - fLastEscape < 5.0 )
					Debug.Notification( "$SD_MESSAGE_WAIT_5_SEC" )
					kSlave.DropObject(akBaseItem, aiItemCount)
				ElseIf ( _SDGVP_state_caged.GetValueInt() )
					If ( kSlave.GetActorValue("Lockpicking") > Utility.RandomInt(0, 100) )
						Debug.Notification( "$SD_MESSAGE_MAKE_LOCKPICK" )
						kSlave.AddItem( _SDMOP_lockpick, 1 )
					Else
						Debug.Notification( "$SD_MESSAGE_FAIL_LOCKPICK" )
					EndIf
					kSlave.RemoveItem( akBaseItem, aiItemCount, False )
				ElseIf ( kMaster.GetSleepState() == 3 || !kMaster.HasLOS( kSlave ) )
					fDamage = ( akBaseItem as Weapon ).GetBaseDamage() as Float

					If ( fDamage <= 0.0 )
						fDamage = Utility.RandomFloat( 1.0, 4.0 )
					EndIf

					_SDFP_bindings_health -= fDamage
					If ( _SDFP_bindings_health < 0.0 )
						Debug.Trace("[_sdras_slave] Weak chains - Stop enslavement")
						Debug.Messagebox("You manage to break your chains with a weapon.")

						fctOutfit.setDeviousOutfitArms ( bDevEquip = False, sDevMessage = "")
						fctOutfit.setDeviousOutfitLegs ( bDevEquip = False, sDevMessage = "")
						fctOutfit.setDeviousOutfitBlindfold ( bDevEquip = False, sDevMessage = "")

						Self.GetOwningQuest().Stop()
						Return
					Else
						kSlave.DropObject(akBaseItem, aiItemCount)
					EndIf
				Else
					Debug.Notification( "$SD_MESSAGE_CAUGHT" )
					Self.GetOwningQuest().ModObjectiveGlobal( 2.0, _SDGVP_demerits, -1, _SDGVP_demerits_join.GetValue() as Float, False, True, _SDGVP_config_verboseMerits.GetValueInt() as Bool )

					kSlave.RemoveItem( akBaseItem, aiItemCount, False, kMaster )

					; Whipping
					_SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 5 )
				EndIf
				fLastEscape = GetCurrentRealTime()

			ElseIf ( iuType == 26 )  ; Armor
				If ( !akBaseItem.HasKeywordString("SOS_Underwear") &&  !akBaseItem.HasKeywordString("SOS_Genitals"))
					; kSlave.DropObject(akBaseItem, aiItemCount)
					; kSlave.EquipItem(akBaseItem, True, True)
				Else
					Debug.Trace( "[_sdras_slave] Could not equip clothing." )
				EndIf

			ElseIf ( kMaster.GetSleepState() != 0 && kMaster.HasLOS( kSlave ) )
				If ( !akBaseItem.HasKeywordString("SOS_Underwear") &&  !akBaseItem.HasKeywordString("SOS_Genitals"))
					; kSlave.RemoveItem( akBaseItem, aiItemCount, False, kMaster )
				EndIf
			EndIf
		EndIf
	EndEvent

EndState

State escape
	Event OnBeginState()
		Debug.Notification( "$SD_MESSAGE_ESCAPE_NOW" )
		enslavement.bEscapedSlave = True
		enslavement.bSearchForSlave = True

		freedomTimer ( _SDGVP_escape_timer.GetValue() )
		fEscapeTime = GetCurrentRealTime() + _SDGVP_escape_timer.GetValue()
		fEscapeUpdateTime = GetCurrentRealTime() + 60
		_SDFP_slaversFaction.ModCrimeGold( 1000 )

		If (_SDKP_trust_hands.GetValue() == 1)
			_SDKP_trust_hands.SetValue(0) 
		EndIf

		If (_SDKP_trust_feet.GetValue() == 1)
			_SDKP_trust_feet.SetValue(0) 
		EndIf

		_SDSP_SelfShock.Cast(kSlave as Actor)
		_SDSP_Weak.Cast(kSlave as Actor)

		Self.GetOwningQuest().ModObjectiveGlobal( 3.0, _SDGVP_demerits, -1, _SDGVP_demerits_join.GetValue() as Float, False, True, _SDGVP_config_verboseMerits.GetValueInt() as Bool )

 		; _SDKP_hunt.SendStoryEvent(akRef1 = kMaster, akRef2 =  kSlave, aiValue1 = 10)

	EndEvent
	
	Event OnEndState()
		Debug.Notification( "$SD_MESSAGE_ESCAPE_GONE" )

		kSlave.DispelSpell( _SDSP_SelfShock )
		kSlave.DispelSpell( _SDSP_Weak )

		If (kSlave.GetDistance(kMaster)< 200)
			Debug.Notification( "Where did you think you were going?" )

			Self.GetOwningQuest().ModObjectiveGlobal( 5.0, _SDGVP_demerits, -1, _SDGVP_demerits_join.GetValue() as Float, False, True, _SDGVP_config_verboseMerits.GetValueInt() as Bool )

			if (Utility.RandomInt(0,100)>70)
				; Punishment
				enslavement.PunishSlave(kMaster,kSlave)
				_SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 3, aiValue2 = RandomInt( 0, _SDGVP_punishments.GetValueInt() ) )
			Else
				; Whipping
				_SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 5 )
			EndIf
		EndIf
	EndEvent

	Event OnUpdate()
		While ( !Game.GetPlayer().Is3DLoaded() )
		EndWhile

		fDistance = kSlave.GetDistance( kMaster )

		If ((kSlave.GetParentCell() == kMaster.GetParentCell()) && (kMaster.GetParentCell().IsInterior()) )
			
			If (RandomInt( 0, 100 ) > 80 )
				Debug.Notification( "Your captors are watching. Don't stray too far...")
			EndIf
			If (kMaster.GetParentCell().IsInterior()) 
				; Debug.Notification( "Master inside") 
			Else
				; Debug.Notification( "Master outside")
			EndIf
			If (kMaster.GetParentCell() == kSlave.GetParentCell()) 
				; Debug.Notification( "Slave and master in same cell ") 
			Else
				; Debug.Notification( "Slave and master in diff cells ") 
			EndIf

			GoToState("monitor")
		Else

			If ( Self.GetOwningQuest().IsStopping() || Self.GetOwningQuest().IsStopped() )
				GoToState("waiting")
			ElseIf ( !enslavement.bEscapedSlave )
				GoToState("monitor")
			ElseIf ( _SDCP_sanguines_realms.Find( kSlave.GetParentCell() ) >= 0 )
				GoToState("monitor")
			ElseIf ( !Game.IsMovementControlsEnabled() )
				kSlave.PathToReference( kMaster, 1.0 )
				GoToState("monitor")
			ElseIf ( (fDistance > _SDGVP_escape_radius.GetValue()) && ((kSlave.GetParentCell() != kMaster.GetParentCell()) || (!kMaster.GetParentCell().IsInterior())) )
			If ( GetCurrentRealTime() > fEscapeUpdateTime )
				Debug.Notification( "Run!" )
				fTime = fEscapeTime - GetCurrentRealTime()
				fEscapeUpdateTime = GetCurrentRealTime() + 60
				freedomTimer ( fTime )

				If (_SDKP_trust_hands.GetValue() == 1)
					_SDKP_trust_hands.SetValue(0) 
				EndIf

				If (_SDKP_trust_feet.GetValue() == 1)
					_SDKP_trust_feet.SetValue(0) 
				EndIf

				_SDSP_SelfShock.Cast(kSlave as Actor)
				_SDSP_Weak.Cast(kSlave as Actor)

				Self.GetOwningQuest().ModObjectiveGlobal( 3.0, _SDGVP_demerits, -1, _SDGVP_demerits_join.GetValue() as Float, False, True, _SDGVP_config_verboseMerits.GetValueInt() as Bool )
			ElseIf ( GetCurrentRealTime() >= fEscapeTime )
				Debug.Trace("[_sdras_slave] Escaped - Stop enslavement")

				Self.GetOwningQuest().Stop()
				Return
				EndIf
			EndIf
		EndIf

		If ( Self.GetOwningQuest() )
			RegisterForSingleUpdate( fRFSU )
		EndIf
	EndEvent
EndState

State caged
	Event OnBeginState()
		enslavement.bEscapedSlave = False
		enslavement.bSearchForSlave = False
	EndEvent
	
	Event OnEndState()
	EndEvent

	Event OnUpdate()
		While ( !Game.GetPlayer().Is3DLoaded() )
		EndWhile
		
		If ( !_SDGVP_state_caged.GetValueInt() )
			GoToState("monitor")
		ElseIf ( _SDRAP_cage.GetReference().GetDistance( kSlave ) > 768 )
			GoToState("escape")
			_SDGVP_state_caged.SetValue( 0 )
		EndIf

		If ( Self.GetOwningQuest() )
			RegisterForSingleUpdate( fRFSU )
		EndIf
	EndEvent
EndState


GlobalVariable Property _SDGVP_state_joined  Auto  
GlobalVariable Property _SDGVP_state_housekeeping  Auto  

SexLabFramework Property SexLab  Auto  

Keyword Property _SDKP_collar  Auto  
Keyword Property _SDKP_gag  Auto  

ReferenceAlias Property _SDRAP_collar  Auto  

Armor Property _SDA_gag  Auto  
Armor Property _SDA_collar  Auto  
Armor Property _SDA_bindings  Auto  
Armor Property _SDA_shackles  Auto  

Keyword Property _SDKP_hunt  Auto  
