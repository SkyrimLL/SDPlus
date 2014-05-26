Scriptname _SDRAS_player extends ReferenceAlias
{ USED }
Import Utility

_SDQS_functions Property funct  Auto
_SDQS_config Property config Auto
_SDQS_snp Property snp Auto

Race Property FalmerRace  Auto  
SexLabFramework property SexLab auto

GlobalVariable[] Property _SDGVP_config  Auto
GlobalVariable Property _SDGVP_sprigganEnslaved  Auto
GlobalVariable Property _SDGVP_enslaved  Auto
GlobalVariable Property _SDGV_leash_length  Auto

; ragdolling
GlobalVariable Property _SDGVP_state_playerRagdoll  Auto

ReferenceAlias Property _SDRAP_lust_m  Auto
ReferenceAlias Property _SDRAP_lust_f  Auto

FormList Property _SDFLP_slavers  Auto
FormList Property _SDFLP_sex_items  Auto
FormList Property _SDFLP_punish_items  Auto
FormList Property _SDFLP_master_items  Auto
FormList Property _SDFL_daedric_items  Auto
FormList Property _SDFLP_banned_factions  Auto
FormList Property _SDFLP_escape_furn  Auto
Message Property _SDMP_scene_stalled  Auto
Message Property _SDMP_scene_stop  Auto
Keyword Property _SDKP_actorTypeNPC  Auto

; spriggan enslavement
Keyword Property _SDKP_spriggan  Auto
FormList Property _SDFLP_spriggan_factions  Auto

; Thug enslavement
Faction Property _SDFP_thugs  Auto
{quest: WIAddItem03 - WIThugFaction}

; Bounties
Faction Property _SDFP_bounty  Auto

Quest Property _SD_dreamQuest  Auto


; reg enslavement
Quest Property _SDQP_enslavement  Auto
ReferenceAlias Property _SDRAP_master  Auto
ReferenceAlias Property _SDRAP_bindings  Auto
ReferenceAlias Property _SDRAP_shackles  Auto
ReferenceAlias Property _SDRAP_collar  Auto
Keyword Property _SDKP_enslave  Auto
Keyword Property _SDKP_bound  Auto
Keyword Property _SDKP_punish  Auto
Keyword Property _SDKP_clothChest  Auto
Keyword Property _SDKP_armorCuirass  Auto
Keyword Property _SDKP_wrists  Auto
Keyword Property _SDKP_ankles  Auto
Keyword Property _SDKP_collar  Auto
Spell Property _SDSP_freedom  Auto  
Spell Property _SDSP_spent Auto
Quest Property _SD_spriggan  Auto
Faction Property _SDFP_humanoidCreatures  Auto

; local
Actor kPlayer
Actor kMasterToBe = None
ObjectReference kLust
ObjectReference kPlayerSafe
Int uiCarryWeight
Int iMsgResponse
Int iLustCount
Int iuType

Int[] keys

Bool shiftPress
Bool altPress
Bool keyPress2

Int iAnimObjTest = 0

Int raped = 0
Int rapeAttempts = 0

; GetSex()
; -1: None
; 0: Male
; 1: Female
; _SDGVP_config[3] - _SD_config_genderRestrictions
; 0: None
; 1: Same
; 2: Opposite
Bool Function checkGenderRestrictions( Actor akAggressor, Actor akPlayer )
	Bool bSameSex           = ( akPlayer.GetLeveledActorBase().GetSex() == akAggressor.GetLeveledActorBase().GetSex() )
	Int iConfigSex          = _SDGVP_config[3].GetValueInt()
	Bool bCheckOk           = ( ( iConfigSex == 0 ) || ( iConfigSex == 1 && bSameSex ) || ( iConfigSex == 2 && !bSameSex ) )
	Bool bNoGenderPlayer    = ( akPlayer.GetLeveledActorBase().GetSex() == -1 )
	Bool bNoGenderAggressor = ( akAggressor.GetLeveledActorBase().GetSex() == -1 )
	Bool bNoGender          = ( bNoGenderPlayer || bNoGenderAggressor )
	; Debug.Trace("_SD::checkGenderRestrictions bSameSex:" + bSameSex + " iConfigSex: 0=N, 1=S, 2=O: " + iConfigSex + " bCheckOk:" + bCheckOk + " bNoGender:" + bNoGender)
	If ( bNoGender )
		Debug.Trace("	_SD::bNoGender akPlayer:" + bNoGenderPlayer)
		Debug.Trace("	_SD::bNoGender akAggressor:" + bNoGenderAggressor)
	EndIf
	Return bCheckOk
EndFunction

Bool Function checkIfSpriggan ( Actor akActor )
	Bool bIsSpriggan = False
	Int index = 0
	Int size = _SDFLP_spriggan_factions.GetSize()
	While ( !bIsSpriggan && index < size )
		bIsSpriggan = akActor.IsInFaction( _SDFLP_spriggan_factions.GetAt(index) as Faction ) && !(akActor as Form).HasKeywordString("_SD_infected")
		index += 1
	EndWhile
	Return bIsSpriggan
EndFunction

Bool Function checkForEnslavement( Actor akAggressor, Actor akPlayer, Bool bVerbose )
	ObjectReference shackles = _SDRAP_shackles.GetReference() as ObjectReference
	ObjectReference bindings = _SDRAP_bindings.GetReference() as ObjectReference
	ObjectReference collar = _SDRAP_collar.GetReference() as ObjectReference

	; add option for simple stagger + chance of action

	; Debug.Notification( "You are pinned to the ground... " + raped + " / " + rapeAttempts)
	; _SDGVP_enslaved.SetValue(1)

	If (StorageUtil.GetIntValue(none, "_SD_iForcedSurrender") ==1) && ( (akAggressor.HasKeyword( _SDKP_actorTypeNPC ) || (akAggressor.GetRace() == falmerRace)) && funct.checkGenderRestriction( akAggressor, akPlayer ) ) && !funct.actorFactionInList( akAggressor, _SDFLP_banned_factions )

		StorageUtil.SetIntValue(none, "_SD_iForcedSurrender", 0) 
		Utility.Wait(4.0) ; if we could know for sure that the player is ragdolling, we could wait for the event sent at the end of ragdoll. --BM

		Debug.SendAnimationEvent(akPlayer , "ZazAPC057")
		_SDKP_enslave.SendStoryEvent( akLoc = akAggressor.GetCurrentLocation(), akRef1 = akAggressor as Actor, akRef2 = kPlayer, aiValue1 = 0, aiValue2 = 0)
	
	ElseIf (Utility.RandomInt(0,100) > 70) && (_SD_dreamQuest.GetStage() != 0) && (raped>=2)
		; Monitor.BufferDamageReceived(9999.0)  ; restore all hp		
		; SendModEvent("da_StartRecoverSequence")
		; Debug.SetGodMode( False )
		raped = 0
		_SD_dreamQuest.SetStage(100)

	ElseIf ( !checkIfSpriggan ( akAggressor ) && funct.actorFactionInList( akAggressor, _SDFL_allowed_creature_sex )  && ( funct.isPunishmentEquiped (akPlayer) && ( !akPlayer.WornHasKeyword( _SDKP_armorCuirass )) ) ) || ( akAggressor.IsInFaction( _SDFP_humanoidCreatures ) )  && !funct.actorFactionInList( akAggressor, _SDFL_banned_sex )   && (Utility.RandomInt(0,100)<= (rapeAttempts * 5) )
			; Debug.Notification( "(Rape attempt)")


		If  (SexLab.ValidateActor( akPlayer) > 0) &&  (SexLab.ValidateActor(akAggressor) > 0) && (Utility.RandomInt(0,100)>80)
			_SDSP_spent.Cast(akPlayer, akPlayer)
			raped = raped + 1
			rapeAttempts = 0

			Debug.Notification( "You aggressors are blinded by lust...")
			funct.actorCombatShutdown( akAggressor as Actor )
			funct.actorCombatShutdown( akPlayer as Actor )
			Utility.Wait(2.0)

			SexLab.QuickStart(SexLab.PlayerRef, akAggressor, Victim = SexLab.PlayerRef, AnimationTags = "Aggressive")


		Else
			; Debug.Notification( "(Rape attempt failed)")
			rapeAttempts = rapeAttempts + 1
		EndIf
	ElseIf ( !checkIfSpriggan ( akAggressor ) && ( akAggressor.HasKeyword( _SDKP_actorTypeNPC )) )  && (Utility.RandomInt(0,100)<= (rapeAttempts * 5) )
			; Debug.Notification( "(Rape attempt)")


		If  (SexLab.ValidateActor( akPlayer) > 0) &&  (SexLab.ValidateActor(akAggressor) > 0) && (Utility.RandomInt(0,100)>80)
			_SDSP_spent.Cast(akPlayer, akPlayer)
			raped = raped + 1
			rapeAttempts = 0

			Debug.Notification( "You aggressors are blinded by lust...")
			funct.actorCombatShutdown( akAggressor as Actor )
			funct.actorCombatShutdown( akPlayer as Actor )
			Utility.Wait(2.0)

			SexLab.QuickStart(SexLab.PlayerRef, akAggressor, Victim = SexLab.PlayerRef, AnimationTags = "Aggressive")


		Else
			; Debug.Notification( "(Rape attempt failed)")
			rapeAttempts = rapeAttempts + 1

		EndIf
	Else
		rapeAttempts = rapeAttempts + 1
	EndIf

	Return False
EndFunction

Bool Function qualifiedAggressor( Actor akAggressor, Actor akPlayer )
	Return ( akAggressor.IsHostileToActor( kPlayer ) && !akAggressor.IsEssential() )
EndFunction

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	If ( _SDFLP_sex_items.HasForm( akBaseItem ) || _SDFLP_punish_items.HasForm( akBaseItem ) || _SDFL_daedric_items.HasForm( akBaseItem ) )
		kPlayer.EquipItem(akBaseItem, True, True)
	EndIf

	iuType = akBaseItem.GetType()
	If ( !_SDGVP_enslaved.GetValueInt() && kPlayer.WornHasKeyword( _SDKP_bound ) && ( iuType == 41 || iuType == 42 ) )
		funct.removeItemsInList( kPlayer, _SDFLP_sex_items )
		funct.removeItemsInList( kPlayer, _SDFLP_punish_items )
		_SDSP_freedom.RemoteCast( kPlayer, kPlayer, kPlayer )
		Utility.Wait(0.5)
	EndIf
EndEvent

Event OnInit()
	Debug.Trace("_SDRAS_player.OnInit()")
	GoToState("waiting")

	kPlayer = Self.GetReference() as Actor
	keys = New Int[2]
	
	If ( Self.GetOwningQuest() )
		RegisterForSingleUpdate( 0.1 )
	EndIf
EndEvent

State waiting
	Event OnUpdate()
		If ( Self.GetOwningQuest().IsRunning() )
			Debug.Trace("_SDRAS_player.OnUpdate().GoToState('monitor')")
			GoToState("monitor")
		EndIf
		If ( kPlayer && Self.GetOwningQuest() )
			RegisterForSingleUpdate( 0.1 )
		EndIf
	EndEvent
EndState

State monitor
	Event OnBeginState()
		If ( ( kPlayer.GetBaseObject() as ActorBase ).GetSex() == 1 )
			kLust = _SDRAP_lust_f.GetReference() as ObjectReference
		Else
			kLust = _SDRAP_lust_m.GetReference() as ObjectReference
		EndIf
		
		keys[0] = config._SDUIP_keys[1]
		keys[1] = config._SDUIP_keys[6]
		RegisterForKey( keys[0] )
		RegisterForKey( keys[1] )

		RegisterForMenu( "Crafting Menu" )
		RegisterForAnimationEvent(kPlayer, "RemoveCharacterControllerFromWorld")
		RegisterForAnimationEvent(kPlayer, "GetUpEnd")
	EndEvent

	Event OnPlayerLoadGame()
		keys[0] = config._SDUIP_keys[1]
		keys[1] = config._SDUIP_keys[6]
		RegisterForKey( keys[0] )
		RegisterForKey( keys[1] )
	EndEvent

	Event OnEndState()
		UnregisterForMenu( "Crafting Menu" )
		UnregisterForKey( keys[0] )
		UnregisterForKey( keys[1] )

		UnregisterForAnimationEvent(kPlayer, "RemoveCharacterControllerFromWorld")
		UnregisterForAnimationEvent(kPlayer, "GetUpEnd")
	EndEvent

	Event OnUpdate()
		If ( Self.GetOwningQuest().IsStopping() || Self.GetOwningQuest().IsStopped() )
			GoToState("waiting")

			If ( Self.GetOwningQuest() )
				RegisterForSingleUpdate( 0.1 )
			EndIf
			Return
		EndIf
		
		If ( keys[0] != config._SDUIP_keys[1] || keys[1] != config._SDUIP_keys[6] )
			UnregisterForKey( keys[0] )
			UnregisterForKey( keys[1] )
			keys[0] = config._SDUIP_keys[1]
			keys[1] = config._SDUIP_keys[6]
			RegisterForKey( keys[0] )
			RegisterForKey( keys[1] )
		EndIf

		; Cap on kill state for better integration with DA (avoid immortal / frozen state)
		Bool isInKWeakenedState = funct.actorInWeakenedState( kPlayer, 15/100 )  
		Bool isInKillState = funct.actorInKillState( kPlayer, 0.5 )    

		; if (isInKillState)  
		;	Debug.Notification("You should be dead")

			If (StorageUtil.GetIntValue(none, "_SD_iForcedDreamworld") ==1) && (_SD_dreamQuest.GetStage() != 0) && (_SDGVP_config[4].GetValue() == 1) 
				Debug.MessageBox("The Daedric piercing brings you back to your true master...")

				Monitor.SetBlackScreenEffect(false)
				Monitor.SetPlayerControl(true)
				Monitor.BufferDamageReceived(9999.0)  ; restore all hp		
				Monitor.GoToState("")
				; Debug.SetGodMode( True )
				; kPlayer.EndDeferredKill()
				; Debug.SetGodMode( False )
				; kPlayer.StartDeferredKill()	

				Utility.Wait(1.0)

				Game.SetPlayerAIDriven(false)
				Game.SetInCharGen(false, false, false)
				; Game.EnablePlayerControls() ; just in case	
				Game.EnablePlayerControls( abMovement = True )
				; Debug.SendAnimationEvent(Game.GetPlayer(), "IdleForceDefaultState")

				StorageUtil.SetIntValue(none, "_SD_iForcedDreamworld", 0) 

				Utility.Wait(1.0)

				_SD_dreamQuest.SetStage(100)
			ElseIf (StorageUtil.GetIntValue(none, "_SD_iForcedDreamworld") ==1)
				; StorageUtil.SetIntValue(none, "_SD_iForcedDreamworld", 0) 
				; Debug.SetGodMode(false) 
				; kPlayer.EndDeferredKill()
				; kPlayer.KillEssential(kPlayer)

			EndIf
		; Else
		;	Debug.Notification("Not dead yet (Kill state failed)")
		; EndIf

		If ( kPlayer && Self.GetOwningQuest() )
			RegisterForSingleUpdate( 0.1 )
		EndIf
	EndEvent

	Event OnAnimationEvent(ObjectReference akSource, string asEventName)
		; Ragdoll control disabled - remnants from Sexis

		; Debug.Trace("_SD::OnAnimationEvent asEventName:" + asEventName )
		; Debug.Trace("  _SDGVP_state_playerRagdoll:" + _SDGVP_state_playerRagdoll.GetValue() )
		; If (akSource == kPlayer && asEventName == "RemoveCharacterControllerFromWorld" && _SDGVP_state_playerRagdoll.GetValueInt() == 0 )
		; 	_SDGVP_state_playerRagdoll.SetValue( 1 )
		; EndIf

		; If (akSource == kPlayer && asEventName == "GetUpEnd" && _SDGVP_state_playerRagdoll.GetValueInt() == 1 )
		; 	_SDGVP_state_playerRagdoll.SetValue( 0 )
		; EndIf
		; Debug.Notification("[_sdras_player]  _SDGVP_state_playerRagdoll:" + _SDGVP_state_playerRagdoll.GetValue() )
		Utility.Wait(0.5)
	EndEvent

	;0xC7 config._SDUIP_keys[0]  199  Home
	;0xCF config._SDUIP_keys[1]  207  End
	;0xC8 config._SDUIP_keys[2]  200  Up Arrow
	;0xCB config._SDUIP_keys[3]  203  Left Arrow
	;0xCD config._SDUIP_keys[4]  205  Right Arrow
	;0xD0 config._SDUIP_keys[5]  208  Down Arrow
	;0x25 config._SDUIP_keys[6]  37   K

	;0x2A    42  Left Shift
	;0x36    54  Right Shift
	Event OnKeyDown(Int aiKeyCode)
		shiftPress = ( Input.IsKeyPressed( 42 ) || Input.IsKeyPressed( 54 ) )
		altPress = ( Input.IsKeyPressed( 56 ) || Input.IsKeyPressed( 184 ) )

		If ( aiKeyCode == keys[0] )
			If ( shiftPress && !altPress )
				iMsgResponse = _SDMP_scene_stop.Show()
				If ( iMsgResponse == 0 && snp._SDSP_sexScenes.Find( kPlayer.GetCurrentScene() ) >= 0 )
					kPlayer.GetCurrentScene().Stop()
				EndIf
			ElseIf ( altPress && !kPlayer.IsInCombat() && funct.GetPlayerDialogueTarget() )
				kPlayer.PushActorAway( funct.GetPlayerDialogueTarget(), 0.0 )
			ElseIf ( _SDQP_enslavement.IsRunning() && _SDQP_enslavement.GetStage() < 90 )
				iMsgResponse = _SDMP_scene_stalled.Show()
				If ( iMsgResponse == 0 )
					kPlayer.MoveTo( _SDRAP_master.GetReference() as ObjectReference,  afXOffset = 100.0 )
				EndIf
			EndIf
		EndIf
		If ( aiKeyCode == keys[1] )
			; Disabled for DA compatibility

			; If ( kPlayer.GetCombatTarget() )
			; 	If ( kPlayer.IsInCombat() && _SDGVP_enslaved.GetValue() == 0 )
			; 		Debug.Notification("$SD_MESSAGE_TRYING_TO_SURRENDER")
			; 		checkForEnslavement( kPlayer.GetCombatTarget() as Actor, kPlayer, True )
			; 	EndIf
			; EndIf

			Bool isInKWeakenedState = funct.actorInWeakenedState( kPlayer, 25.0 /100.0 )  ; funct.actorInWeakenedState( kPlayer, _SDGVP_config[2].GetValue()/100 )
			Bool isInKillState = funct.actorInKillState( kPlayer, 0.5 )   ; funct.actorInKillState( kPlayer, _SDGVP_config[1].GetValue() )
			Debug.Trace("[SD] Surrender")
			Debug.Trace("[SD] Player in weakened state: " + isInKWeakenedState )
			Debug.Trace("[SD] Player in kill state: " + isInKillState )

			if (!UI.IsMenuOpen("Console") && !UI.IsMenuOpen("InventoryMenu") && !UI.IsMenuOpen("GiftMenu") && !UI.IsMenuOpen("ContainerMenu"))

				Int IButton = _SD_safetyMenu.Show()

				Debug.Notification("You cling to your last breath...")
				Monitor.SetBlackScreenEffect(false)
				Monitor.SetPlayerControl(true)


				Game.SetPlayerAIDriven(false)
				Game.SetInCharGen(false, false, false)
				; Game.EnablePlayerControls() ; just in case	
				Game.EnablePlayerControls( abMovement = True )

				; Debug.SendAnimationEvent(Game.GetPlayer(), "IdleForceDefaultState")

				; SendModEvent("da_UpdateBleedingDebuff")
				; SendModEvent("da_EndNearDeathDebuff")	

				Debug.SetGodMode( False )

				If (isInKWeakenedState)

					If IButton == 0  
						; Surrender to aggressor	
						StorageUtil.SetIntValue(none, "_SD_iForcedSurrender", 1)	


					ElseIf IButton == 1
						; Pray to Sanguine

						; Monitor.GoToState("")
						; Debug.SetGodMode( True )
						; kPlayer.EndDeferredKill()
						
						If (Utility.RandomInt(0,100) > 80) && (_SD_dreamQuest.GetStage() != 0) 
							; Send PC to Dreamworld

							_SD_dreamQuest.SetStage(100)

						ElseIf (Utility.RandomInt(0,100) > 40)	
							; Send PC some help

							SendModEvent("da_StartSecondaryQuest", "Both")
							SendModEvent("da_StartRecoverSequence")

						ElseIf (Utility.RandomInt(0,100) > 30)	
							; restore all hp	
							Monitor.BufferDamageReceived(9999.0)  	

						Else
							Debug.Notification("Your prayer goes unanswered...")
						EndIf
					ElseIf IButton == 2
						; Resist

					EndIf
				Else
					Debug.Notification("You still have life in you...")

				EndIf
			EndIf
 
		EndIf

	EndEvent

	Event OnCombatStateChanged(Actor akTarget, int aeCombatState)
	  if (akTarget != Game.GetPlayer())

	    rapeAttempts = 0

	  endIf
	endEvent

	Event OnMagicEffectApply(ObjectReference akCaster, MagicEffect akEffect)
		; Old trigger - disabled for compatibility with Death Alternative
 

	EndEvent

	Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
		; Debug.Notification("[_sdras_player] OnHit - Aggressor:" + akAggressor)

		; Cap on kill state for better integration with DA (avoid immortal / frozen state)
		Bool isInKWeakenedState = funct.actorInWeakenedState( kPlayer, 5/100 )  ; funct.actorInWeakenedState( kPlayer, _SDGVP_config[2].GetValue()/100 )
		Bool isInKillState = funct.actorInKillState( kPlayer, 0.5 )   ; funct.actorInKillState( 

		if (isInKWeakenedState) && checkForEnslavement( akAggressor as Actor, kPlayer as Actor, False )
			; Chance of rape on kill state
		Else
			; Debug.Notification("Not dead yet (Kill state failed)")
		EndIf
	EndEvent

	Event OnTrapHit(ObjectReference akTarget, float afXVel, float afYVel, float afZVel, float afXPos, float afYPos, float afZPos, int aeMaterial, bool abInitialHit, int aeMotionType)

		If (_SD_dreamQuest.GetStage() != 0)
			; While ( kPlayer.IsInKillMove() )
				;
			; EndWhile

			_SD_dreamQuest.SetStage(100)
		Else
			self.GetOwningQuest().SetStage(10)
		EndIf
		Utility.Wait(0.5)
		 
	endEvent

	Event OnSit(ObjectReference akFurniture)
		If ( !_SDGVP_enslaved.GetValueInt() && kPlayer.WornHasKeyword( _SDKP_bound ) && _SDFLP_escape_furn.HasForm( akFurniture.GetBaseObject() ) )  && (0==1)
			funct.removeItemsInList( kPlayer, _SDFLP_sex_items )
			funct.removeItemsInList( kPlayer, _SDFLP_punish_items )
			_SDSP_freedom.RemoteCast( kPlayer, kPlayer, kPlayer )
			_SDQP_enslavement.Stop()
			Utility.Wait(0.5)
		EndIf
	EndEvent
EndState


ReferenceAlias Property _SDRAP_player_safe  Auto  

FormList Property _SDFL_banned_sex  Auto  

FormList Property _SDFL_allowed_creature_sex  Auto  

SPELL Property Calm  Auto  
daymoyl_MonitorScript 		Property Monitor 		Auto
Message Property _SD_safetyMenu  Auto  


