Scriptname _SDRAS_player extends ReferenceAlias
{ USED }
Import Utility

_SDQS_functions Property funct  Auto
_SDQS_fcts_constraints Property fctConstraints  Auto
_SDQS_fcts_inventory Property fctInventory  Auto
_SDQS_fcts_factions Property fctFactions  Auto
_SDQS_fcts_outfit Property fctOutfit  Auto
_SDQS_fcts_slavery Property fctSlavery  Auto

_SDQS_config Property config Auto
_SDQS_snp Property snp Auto

Race Property FalmerRace  Auto  
SexLabFramework property SexLab auto

GlobalVariable[] Property _SDGVP_config  Auto
GlobalVariable Property _SDGVP_sprigganEnslaved  Auto
GlobalVariable Property _SDGVP_enslaved  Auto
GlobalVariable Property _SDGV_leash_length  Auto
GlobalVariable Property _SDGVP_health_threshold Auto
GlobalVariable Property _SDGVP_config_healthMult Auto
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
Keyword Property _SDKP_spriggan_infected  Auto
FormList Property _SDFLP_spriggan_factions  Auto

; Thug enslavement
Faction Property _SDFP_thugs  Auto
{quest: WIAddItem03 - WIThugFaction}

; Bounties
Faction Property _SDFP_bounty  Auto

Quest Property _SD_dreamQuest  Auto
_sdras_dreamer Property _SD_dreamerScript Auto

; reg enslavement
Quest Property _SDQP_enslavement  Auto
_SDQS_enslavement Property _SD_Enslaved Auto

ReferenceAlias Property _SDRAP_master  Auto
ReferenceAlias Property _SDRAP_bindings  Auto
ReferenceAlias Property _SDRAP_shackles  Auto
ReferenceAlias Property _SDRAP_collar  Auto
Keyword Property _SDKP_enslave  Auto
Keyword Property _SDKP_sex  Auto  
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
GlobalVariable Property _SDGVP_punishments  Auto  
GlobalVariable Property _SDGVP_can_join  Auto  

Armor Property _SD_SimpleBindings Auto     
Armor Property _SD_SimpleBindingsCosmetic Auto        	    

; local
Actor kPlayer
Actor kMasterToBe = None
ObjectReference kLust
ObjectReference kPlayerSafe
Int uiCarryWeight
Int iMsgResponse
Int iLustCount
Int iuType
int daysPassed
int iGameDateLastCheck = -1
int iDaysSinceLastCheck
int iCountSinceLastCheck
Float fOldExposure 
Float fExposureMultiplier 
Float fNewExposure

Int[] keys

Bool shiftPress
Bool altPress
Bool keyPress2

Int iAnimObjTest = 0

Int raped = 0
Int rapeAttempts = 0
Float fRFSU = 0.5
 
Bool isPlayerEnslaved = False
Bool isPlayerPregnant = False
Bool isPlayerSuccubus = False
Bool isPlayerHRT = False
Bool isPlayerTG = False
Bool isPlayerBimbo = False




Bool Function checkForEnslavement( Actor akAggressor, Actor akPlayer, Bool bVerbose )
	ObjectReference shackles = _SDRAP_shackles.GetReference() as ObjectReference
	ObjectReference bindings = _SDRAP_bindings.GetReference() as ObjectReference
	ObjectReference collar = _SDRAP_collar.GetReference() as ObjectReference

	; Disabled because of DA options
	; Return False

	; add option for simple stagger + chance of action

	Debug.Notification( "You are pinned to the ground... " ) ; + raped + " / " + rapeAttempts)
	; _SDGVP_enslaved.SetValue(1)



	; If (StorageUtil.GetIntValue(kPlayer, "_SD_iForcedSurrender") ==1)  &&  fctFactions.checkIfSlaver (  akAggressor )

		; Debug.Notification("Your aggressor accepts your surrender...")

		; StorageUtil.SetIntValue(kPlayer, "_SD_iForcedSurrender", 0) 
		; Utility.Wait(4.0) ; if we could know for sure that the player is ragdolling, we could wait for the event sent at the end of ragdoll. --BM

		; Debug.SendAnimationEvent(akPlayer , "ZazAPC057")
		; _SDKP_enslave.SendStoryEvent( akLoc = akAggressor.GetCurrentLocation(), akRef1 = akAggressor as Actor, akRef2 = kPlayer, aiValue1 = 0, aiValue2 = 0)
	
	; Else
	If (Utility.RandomInt(0,100) > 70) && (_SD_dreamQuest.GetStage() != 0) && (raped>=2)
		; Monitor.BufferDamageReceived(9999.0)  ; restore all hp		
		; SendModEvent("da_StartRecoverSequence")
		; Debug.SetGodMode( False )
		raped = 0
		_SD_dreamQuest.SetStage(100)

	ElseIf ( !fctFactions.checkIfSpriggan ( akAggressor ) && fctFactions.actorFactionInList( akAggressor, _SDFL_allowed_creature_sex )  && ( fctOutfit.isPunishmentEquipped (akPlayer) && ( !akPlayer.WornHasKeyword( _SDKP_armorCuirass )) ) ) || ( akAggressor.IsInFaction( _SDFP_humanoidCreatures ) )  && !fctFactions.actorFactionInList( akAggressor, _SDFL_banned_sex )   && (Utility.RandomInt(0,100)<= (rapeAttempts * 5) )
		
		Debug.Notification( "(Creature Rape attempt)")


		If  (SexLab.ValidateActor( akPlayer) > 0) &&  (SexLab.ValidateActor(akAggressor) > 0) && (Utility.RandomInt(0,100)>80)
			_SDSP_spent.Cast(akPlayer, akPlayer)
			raped = raped + 1
			rapeAttempts = 0

			Debug.Notification( "You aggressors are blinded by lust...")
			fctConstraints.actorCombatShutdown( akAggressor as Actor )
			fctConstraints.actorCombatShutdown( akPlayer as Actor )
			Utility.Wait(2.0)

			SexLab.QuickStart(kPlayer, akAggressor, Victim = kPlayer, AnimationTags = "Aggressive")


		Else
			; Debug.Notification( "(Rape attempt failed)")
			rapeAttempts = rapeAttempts + 1
		EndIf
	ElseIf ( !fctFactions.checkIfSpriggan ( akAggressor ) && ( akAggressor.HasKeyword( _SDKP_actorTypeNPC )) )  && (Utility.RandomInt(0,100)<= (rapeAttempts * 5) )
			
		Debug.Notification( "(Rape attempt)")


		If  (SexLab.ValidateActor( akPlayer) > 0) &&  (SexLab.ValidateActor(akAggressor) > 0) && (Utility.RandomInt(0,100)>80)
			_SDSP_spent.Cast(akPlayer, akPlayer)
			raped = raped + 1
			rapeAttempts = 0

			Debug.Notification( "You aggressors are blinded by lust...")
			fctConstraints.actorCombatShutdown( akAggressor as Actor )
			fctConstraints.actorCombatShutdown( akPlayer as Actor )
			Utility.Wait(2.0)

			SexLab.QuickStart(kPlayer, akAggressor, Victim = kPlayer, AnimationTags = "Aggressive")


		Else
			; Debug.Notification( "(Rape attempt failed)")
			rapeAttempts = rapeAttempts + 1

		EndIf
	Else
		rapeAttempts = rapeAttempts + 1
	EndIf

	If (StorageUtil.GetIntValue(kPlayer, "_SD_iForcedSurrender") ==1)
		StorageUtil.SetIntValue(kPlayer, "_SD_iForcedSurrender", 0) 
		Debug.Notification("You failed to surrender... try again...")
	EndIf

	Return False
EndFunction

Bool Function qualifiedAggressor( Actor akAggressor, Actor akPlayer )
	Return ( akAggressor.IsHostileToActor( kPlayer ) && !akAggressor.IsEssential() )
EndFunction

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	; If ( _SDFLP_sex_items.HasForm( akBaseItem ) || _SDFLP_punish_items.HasForm( akBaseItem ) || _SDFL_daedric_items.HasForm( akBaseItem ) )
	; 	kPlayer.EquipItem(akBaseItem, True, True)
	; EndIf

	; iuType = akBaseItem.GetType()
	; If ( !_SDGVP_enslaved.GetValueInt() && kPlayer.WornHasKeyword( _SDKP_bound ) && ( iuType == 41 || iuType == 42 ) )
	; 	funct.removeItemsInList( kPlayer, _SDFLP_sex_items )
	; 	funct.removeItemsInList( kPlayer, _SDFLP_punish_items )
	; 	_SDSP_freedom.RemoteCast( kPlayer, kPlayer, kPlayer )
	;	Utility.Wait(0.5)
	; EndIf

	; If ( kPlayer.WornHasKeyword( _SDKP_spriggan_infected ) && (StorageUtil.GetIntValue(kPlayer, "_SD_iSprigganInfected") != 1) ) && (Utility.RandomInt(0,100)<=_SDGVP_config_healthMult.GetValue())
	; 	Debug.Notification("[SD] Infected by spriggan roots...")
	;	SendModEvent("SDSprigganEnslave")

	; ElseIf kPlayer.WornHasKeyword( _SDKP_spriggan_infected )
	;	Debug.Notification("[SD] Playing with spriggan roots...")
	; EndIf
EndEvent

Event OnInit()
	Debug.Trace("_SDRAS_player.OnInit()")
	_maintenance()

	GoToState("waiting")

	kPlayer = Self.GetReference() as Actor
	keys = New Int[2]
	
	If ( Self.GetOwningQuest() )
		RegisterForSingleUpdate( 0.1 )
	EndIf
EndEvent

Function _Maintenance()
;	UnregisterForAllModEvents()
	Debug.Trace("[_sdras_player] Register events")
	RegisterForModEvent("PCSubEnslave",   "OnSDEnslave")
	RegisterForModEvent("PCSubSurrender",   "OnSDSurrender")
	RegisterForModEvent("PCSubSex",   "OnSDStorySex")
	RegisterForModEvent("PCSubEntertain",   "OnSDStoryEntertain")
	RegisterForModEvent("PCSubWhip",   "OnSDStoryWhip")
	RegisterForModEvent("PCSubPunish",   "OnSDStoryPunish")
	RegisterForModEvent("PCSubTransfer",   "OnSDTransfer")
	RegisterForModEvent("PCSubFree",   "OnSDFree")
	RegisterForModEvent("PCSubStatus",   "OnSDStatusUpdate")
	RegisterForModEvent("SDSprigganEnslave",   "OnSDSprigganEnslave")
	RegisterForModEvent("SDSprigganPunish",   "OnSDSprigganPunish")
	RegisterForModEvent("SDParasiteVag",   "OnSDParasiteVag")
	RegisterForModEvent("SDParasiteAn",   "OnSDParasiteAn")
	RegisterForModEvent("SDDreamworldPull",   "OnSDDreamworldPull")
	RegisterForModEvent("SDDreamworldStart",   "OnSDDreamworldStart")
	RegisterForModEvent("SDEmancipateSlave",   "OnSDEmancipateSlave")
	RegisterForModEvent("SDPunishSlave",   "OnSDPunishSlave")
	RegisterForModEvent("SDRewardSlave",   "OnSDRewardSlave")
	RegisterForModEvent("SDHandsFreeSlave",   "OnSDHandsFreeSlave")
	RegisterForModEvent("SDHandsBoundSlave",   "OnSDHandsBoundSlave")
	RegisterForModEvent("SDEquipDevice",   "OnSDEquipDevice")
	RegisterForModEvent("SDClearDevice",   "OnSDClearDevice")
	RegisterForModEvent("SDEquipSlaveRags",   "OnSDEquipSlaveRags")

	Debug.Trace("SexLab Dialogues: Reset SexLab events")
	RegisterForModEvent("AnimationStart", "OnSexLabStart")
	RegisterForModEvent("AnimationEnd",   "OnSexLabEnd")
	; RegisterForModEvent("OrgasmStart",    "OnSexLabOrgasm")

	; Check for DLC Races
	Race SprigganEarthMotherRace = Game.GetFormFromFile(0x00013B77, "Dawnguard.esm") As Race
	Race DLC2SprigganBurntRace = Game.GetFormFromFile(0x0001B644, "Dragonborn.esm") As Race
	Race FalmerFrozenVampRace = Game.GetFormFromFile(0x0001AACC, "Dawnguard.esm") As Race

	StorageUtil.SetFormValue(None, "_SD_Race_SprigganEarthMother", SprigganEarthMotherRace)
	StorageUtil.SetFormValue(None, "_SD_Race_SprigganBurnt", DLC2SprigganBurntRace)
	StorageUtil.SetFormValue(None, "_SD_Race_FalmerFrozen", FalmerFrozenVampRace)

	; Restore compatibility flags with Deviously Helpless on load if enslaved or infected

	If (StorageUtil.GetIntValue(kPlayer, "_SD_iSprigganInfected") == 1) || (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved")==1)

		SendModEvent("dhlp-Suspend")
	EndIf

	; Registering default outfit keywords for slave if not defined yet 
	fctOutfit.registerDeviousOutfitsKeywords (  kPlayer )

	If (kPlayer != Game.GetPlayer())
		Debug.MessageBox("[SD] Player ref has changed. ")
	Endif

	isPlayerEnslaved = StorageUtil.GetIntValue( kPlayer, "_SD_iEnslaved") as Bool
	isPlayerPregnant = StorageUtil.GetIntValue( kPlayer, "_SLH_isPregnant") as Bool
	isPlayerSuccubus = StorageUtil.GetIntValue( kPlayer, "_SLH_isSuccubus") as Bool
	isPlayerHRT = StorageUtil.GetIntValue( kPlayer, "_SLH_isHRT") as Bool
	isPlayerTG = StorageUtil.GetIntValue( kPlayer, "_SLH_isTG") as Bool
	isPlayerBimbo = StorageUtil.GetIntValue( kPlayer, "_SLH_isBimbo") as Bool

	_SDGVP_isPlayerPregnant.SetValue(isPlayerPregnant as Int)
	_SDGVP_isPlayerSuccubus.SetValue(isPlayerSuccubus as Int)
	_SDGVP_isPlayerEnslaved.SetValue(isPlayerEnslaved as Int)
	_SDGVP_isPlayerHRT.SetValue(isPlayerHRT as Int)
	_SDGVP_isPlayerTG.SetValue(isPlayerTG as Int)
	_SDGVP_isPlayerBimbo.SetValue(isPlayerBimbo as Int)

	StorageUtil.SetIntValue(kPlayer, "_SD_iForcedSurrender", 0)	
EndFunction

Event OnSexLabStart(String _eventName, String _args, Float _argc, Form _sender)
	ObjectReference PlayerREF= kPlayer
	Actor PlayerActor= PlayerREF as Actor
	ActorBase pActorBase = PlayerActor.GetActorBase()
    sslBaseAnimation animation = SexLab.HookAnimation(_args)

	if !Self || !SexLab 
		Debug.Trace("[SD]: Critical error on SexLab End")
		Return
	EndIf

	Actor[] actors  = SexLab.HookActors(_args)
	Actor   victim  = SexLab.HookVictim(_args)
	Actor[] victims = new Actor[1]
	victims[0] = victim

	If (StorageUtil.GetIntValue(PlayerActor, "_SD_iEnslaved") == 1)
		; Actor kCurrentMaster = StorageUtil.GetFormValue(PlayerActor, "_SD_CurrentOwner") as Actor
		
		If (funct._hasPlayer(actors)) 
			; Player hands are freed temporarily for sex

			if (fctOutfit.isArmbinderEquipped( PlayerActor )) && (actors.Length > 1) ; Exclude masturbation
				fctOutfit.setDeviousOutfitArms ( iDevOutfit =-1, bDevEquip = False, sDevMessage = "")
				StorageUtil.SetIntValue(PlayerActor, "_SD_iHandsFreeSex", 1)
			EndIf
		EndIf

		int listIndex
		int idx = 0
		while idx < actors.Length
			listIndex = StorageUtil.FormListFind(kPlayer, "_SD_lEnslavedFollower", actors[idx] as Form)
			; Debug.Notification("[SD]: Sex Master: " + kCurrentMaster)
			; Debug.Notification("[SD]: Index: " + listIndex)
			if  listIndex >= 0  				
				; Debug.Notification("[SD]: Sex with slave follower on")
				; actors[idx].UnequipItemSlot(  59 )	
				actors[idx].UnequipItem(  _SD_SimpleBindings , True, True )	
				actors[idx].EquipItem(  _SD_SimpleBindingsCosmetic , True, True )	
				StorageUtil.SetIntValue(actors[idx], "_SD_iHandsFreeSex", 1)
			endif
			; Debug.Notification("[SD]: Hands free: " + StorageUtil.GetIntValue(actors[idx], "_SD_iHandsFreeSex") )
			idx += 1
		endwhile

	EndIf

EndEvent

Event OnSexLabEnd(String _eventName, String _args, Float _argc, Form _sender)
	ObjectReference PlayerREF= kPlayer
	Actor PlayerActor= PlayerREF as Actor
	ActorBase pActorBase = PlayerActor.GetActorBase()
    sslBaseAnimation animation = SexLab.HookAnimation(_args)

	if !Self || !SexLab || (animation == None)
		Debug.Trace("[SD]: Critical error on SexLab End")
		Return
	EndIf


	Actor[] actors  = SexLab.HookActors(_args)
	Actor   victim  = SexLab.HookVictim(_args)
	Actor[] victims = new Actor[1]
	victims[0] = victim


	
	; if config.bDebugMsg
	; 	_listActors("End: ", actors)
	; EndIf

	; If (funct._hasPlayer(actors))
		;
	; EndIf

	if animation.HasTag("Chaurus") && (funct._hasPlayer(actors))
		If (Utility.RandomInt(0,100)> 60) && (!fctOutfit.isBeltEquipped(PlayerActor)) && !fctOutfit.isDeviceEquippedKeyword( kPlayer, "_SD_DeviousParasiteVag", "PlugVaginal" )

			kPlayer.SendModEvent("SDParasiteVag")

		EndIf
	EndIf

	if animation.HasTag("Spider") && (funct._hasPlayer(actors))
		If (Utility.RandomInt(0,100)> 60) && (!fctOutfit.isBeltEquipped(PlayerActor)) && !fctOutfit.isDeviceEquippedKeyword( kPlayer, "_SD_DeviousParasiteAn", "PlugAnal"  )

			kPlayer.SendModEvent("SDParasiteAn")

		EndIf
	EndIf

	If (StorageUtil.GetIntValue(PlayerActor, "_SD_iEnslaved") == 1)
		Actor kCurrentMaster = StorageUtil.GetFormValue(PlayerActor, "_SD_CurrentOwner") as Actor

		If (kCurrentMaster != None)  

			If (funct._hasActor(actors,kCurrentMaster))
				Debug.Trace("[SD]: Sex with your master")

				fctSlavery.UpdateSlaveStatus( PlayerActor, "_SD_iSexCountToday", modValue = 1)
				fctSlavery.UpdateSlaveStatus( PlayerActor, "_SD_iSexCountTotal", modValue = 1)
				fctSlavery.UpdateSlaveStatus( PlayerActor, "_SD_iGoalSex", modValue = 1)
				fctSlavery.UpdateSlaveStatus( PlayerActor, "_SD_iSlaveryExposure", modValue = 1)

				; Debug.Notification("[SD]: Sex with your master: " + StorageUtil.GetIntValue(PlayerActor, "_SD_iGoalSex"))

				; If master is trusting slave, increased chance of hands free after sex
				If (StorageUtil.GetIntValue(kCurrentMaster, "_SD_iTrust")>0) && (Utility.RandomInt(0,100) > 70) && (actors.Length > 1) ; Exclude masturbation
				; Chance player will keep armbinders after sex
					Debug.Notification("Your hands remain free.. lucky you.")

				ElseIf (!fctOutfit.isArmbinderEquipped(PlayerActor)) && (StorageUtil.GetIntValue(PlayerActor, "_SD_iHandsFreeSex") == 1) && (StorageUtil.GetIntValue(PlayerActor, "_SD_iEnableAction") == 0) && (StorageUtil.GetIntValue(PlayerActor, "_SD_iEnslaved") == 1)
					fctOutfit.setDeviousOutfitArms ( iDevOutfit =-1, bDevEquip = True, sDevMessage = "")
					StorageUtil.SetIntValue(PlayerActor, "_SD_iHandsFree", 0)
				EndIf
			Else


				If (Utility.RandomInt(0,100) > 90) && (actors.Length > 1) ; Exclude masturbation
				; Chance player will keep armbinders after sex
					Debug.Notification("Your hands remain free.. lucky you.")

				ElseIf (!fctOutfit.isArmbinderEquipped(PlayerActor)) && (StorageUtil.GetIntValue(PlayerActor, "_SD_iHandsFreeSex") == 1) && (StorageUtil.GetIntValue(PlayerActor, "_SD_iEnableAction") == 0) && (StorageUtil.GetIntValue(PlayerActor, "_SD_iEnslaved") == 1)
					fctOutfit.setDeviousOutfitArms ( iDevOutfit =-1, bDevEquip = True, sDevMessage = "")
					StorageUtil.SetIntValue(PlayerActor, "_SD_iHandsFree", 0)
				EndIf
			EndIf

			int idx = 0
			int listIndex 
			while idx < actors.Length
				listIndex = StorageUtil.FormListFind(kPlayer, "_SD_lEnslavedFollower", actors[idx] as Form)
				if  listIndex >= 0  
					; Debug.Notification("[SD]: Sex with slave follower off")
					actors[idx].UnequipItem(  _SD_SimpleBindingsCosmetic , True, True )	
					actors[idx].EquipItem(  _SD_SimpleBindings , True, True )	
					StorageUtil.SetIntValue(actors[idx], "_SD_iHandsFreeSex", 0)
				endif
				; Debug.Notification("[SD]: Hands free: " + StorageUtil.GetIntValue(actors[idx], "_SD_iHandsFreeSex") )
				idx += 1
			endwhile			

			StorageUtil.SetIntValue(PlayerActor, "_SD_iHandsFreeSex", 0)
		Endif
	EndIf



EndEvent 

Event OnSexLabOrgasm(String _eventName, String _args, Float _argc, Form _sender)
	ObjectReference PlayerREF= kPlayer
	Actor PlayerActor= PlayerREF as Actor
 

	if !Self || !SexLab 
		Debug.Trace("[SD]: Critical error on SexLab Orgasm")
		Return
	EndIf

	Actor[] actors  = SexLab.HookActors(_args)
	Actor   victim  = SexLab.HookVictim(_args)
	Actor[] victims = new Actor[1]
	victims[0] = victim

	; If (funct._hasPlayer(actors))
	;	Debug.Trace("[SD]: Orgasm!")

	; EndIf
	
EndEvent

Event OnSDParasiteVag(String _eventName, String _args, Float _argc = 1.0, Form _sender)
 	Actor kActor = _sender as Actor
 	Actor PlayerActor = kPlayer as Actor

	Debug.Trace("[_sdras_player] Receiving 'parasite vaginal' event - Actor: " + kActor)

	if (kActor == PlayerActor)

		fctOutfit.setDeviousOutfitPlugVaginal ( iDevOutfit = 9, bDevEquip = True, sDevMessage = "")

		If !StorageUtil.HasIntValue(PlayerActor, "_SD_iParasiteVagCount")
				StorageUtil.SetIntValue(PlayerActor, "_SD_iParasiteVagCount",  0)
		EndIf

		StorageUtil.SetIntValue(PlayerActor, "_SD_iParasiteVagCount",  StorageUtil.GetIntValue(PlayerActor, "_SD_iParasiteVagCount") + 1)
		SendModEvent("SDCParasiteVagInfection")

	EndIf
	
EndEvent

Event OnSDParasiteAn(String _eventName, String _args, Float _argc = 1.0, Form _sender)
 	Actor kActor = _sender as Actor
 	Actor PlayerActor = kPlayer as Actor

	Debug.Trace("[_sdras_player] Receiving 'parasite anal' event - Actor: " + kActor)

	if (kActor == PlayerActor)

		fctOutfit.setDeviousOutfitPlugAnal ( iDevOutfit = 9, bDevEquip = True, sDevMessage = "")

		If !StorageUtil.HasIntValue(PlayerActor, "_SD_iParasiteAnCount")
				StorageUtil.SetIntValue(PlayerActor, "_SD_iParasiteAnCount",  0)
		EndIf

		StorageUtil.SetIntValue(PlayerActor, "_SD_iParasiteAnCount",  StorageUtil.GetIntValue(PlayerActor, "_SD_iParasiteAnCount") + 1)
		SendModEvent("SDCParasiteAnInfection")

	EndIf
	
EndEvent


Event OnSDSprigganEnslave(String _eventName, String _args, Float _argc = 1.0, Form _sender)
 	Actor kActor = _sender as Actor
	Actor kNewMaster = StorageUtil.GetFormValue( kPlayer , "_SD_TempAggressor") as Actor
	ObjectReference kNewMasterRef

	if (kActor != None)
		; StorageUtil _SD_TempAggressor is deprecated
		; Use _sender through kActor.SendModEvent("") in priority instead 
		kNewMaster = kActor
	EndIf
		
	Debug.Trace("[_sdras_player] Receiving 'spriggan enslave' event - New master: " + kNewMaster)

	If (kNewMaster != None)  &&  fctFactions.checkIfSpriggan (  kNewMaster )
		; new master

		StorageUtil.SetFormValue(kPlayer, "_SD_TempAggressor", None)

		_SDKP_spriggan.SendStoryEvent(akRef1 = kNewMaster as ObjectReference, akRef2 = kPlayer, aiValue1 = 0, aiValue2 = 0)
 
	Else
		Debug.Trace("[_sdras_player] Attempted spriggan enslavement to empty master " )
		_SD_SprigganSwarm.MoveTo( kPlayer  as ObjectReference)

		; Debug.Notification("[SD] Sending spriggan story...")		
		_SDKP_spriggan.SendStoryEvent(akRef1 = _SD_SprigganSwarm as ObjectReference, akRef2 = kPlayer, aiValue1 = 0, aiValue2 = 0)

	EndIf
EndEvent

Event SDSprigganPunish(String _eventName, String _args, Float _argc = 1.0, Form _sender)
 	Actor kActor = _sender as Actor
	Actor kTempAggressor = StorageUtil.GetFormValue( kPlayer, "_SD_TempAggressor") as Actor

	if (kActor != None)
		; StorageUtil _SD_TempAggressor is deprecated
		; Use _sender through kActor.SendModEvent("") in priority instead 
		kTempAggressor = kActor
	EndIf

	Debug.Trace("[_sdras_player] Receiving spriggan punish event [" + _args  + "] [" + _argc as Int + "]")

	_SDKP_sex.SendStoryEvent(akRef1 = kTempAggressor as ObjectReference, akRef2 = kPlayer as ObjectReference, aiValue1 = 8, aiValue2 = 0 )
EndEvent


Event OnSDSurrender(String _eventName, String _args, Float _argc = 1.0, Form _sender)
 	Actor kActor = _sender as Actor
	Actor kNewMaster = StorageUtil.GetFormValue( kPlayer , "_SD_TempAggressor") as Actor
	Actor kCurrentMaster

	If (StorageUtil.GetIntValue(kPlayer, "_SD_iForcedSurrender") ==0)
		; Set surrender flag to block other enslavement events
		StorageUtil.SetIntValue(kPlayer, "_SD_iForcedSurrender",1) 
	Endif

	if (kActor != None)
		; StorageUtil _SD_TempAggressor is deprecated
		; Use _sender through kActor.SendModEvent("") in priority instead 
		kNewMaster = kActor
	EndIf
		
	Debug.Trace("[_sdras_player] Receiving 'enslave' event - New master: " + kNewMaster)

	If (kNewMaster != None)  &&  (fctFactions.checkIfSlaver (  kNewMaster ) || fctFactions.checkIfSlaverCreature (  kNewMaster ) )
		; if already enslaved, transfer of ownership

		If (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved") == 1)
			kCurrentMaster = StorageUtil.GetFormValue(kPlayer, "_SD_CurrentOwner") as Actor

			If (!kCurrentMaster.IsDead()) && (kPlayer.GetDistance( kCurrentMaster ) <= ( StorageUtil.GetIntValue(kPlayer, "_SD_iLeashLength") * 2) ) && ( StorageUtil.GetIntValue(kPlayer, "_SD_iSold") != 1 )
				kCurrentMaster.SetRelationshipRank( kPlayer, StorageUtil.GetIntValue(kCurrentMaster, "_SD_iOriginalRelationshipRank") )
				If (Utility.RandomInt(0,100) >= 0) || ( StorageUtil.GetIntValue(kCurrentMaster, "_SD_iDisposition") > 0)
					Debug.Notification("(Owner) Who do you think you are!")
					kCurrentMaster.StartCombat(kNewMaster)
				Else
					Debug.Notification("(Owner) Good riddance...")
				EndIf
			EndIf

			StorageUtil.SetIntValue(kPlayer, "_SD_iSlaveTransfer",1)
			_SDQP_enslavement.Stop()
			SendModEvent("da_PacifyNearbyEnemies", "Restore")

			While ( _SDQP_enslavement.IsStopping() )
			EndWhile

		EndIf

		; new master

		StorageUtil.SetFormValue(kPlayer, "_SD_TempAggressor", None)

		If (_args == "Consensual")
			StorageUtil.SetIntValue(kNewMaster, "_SD_iForcedSlavery", 0) 
		EndIf

		; New enslavement - changing ownership
		_SDKP_enslave.SendStoryEvent(akRef1 = kNewMaster, akRef2 = kPlayer, aiValue1 = 0)
	Else
		Debug.Trace("[_sdras_player] Attempted enslavement to empty master " )
	EndIf
EndEvent

Event OnSDEnslave(String _eventName, String _args, Float _argc = 1.0, Form _sender)
 	Actor kActor = _sender as Actor
	Actor kNewMaster = StorageUtil.GetFormValue( kPlayer , "_SD_TempAggressor") as Actor
	Actor kCurrentMaster

	If (StorageUtil.GetIntValue(kPlayer, "_SD_iForcedSurrender") ==1)
		; Ignore Enslave event if Surrender is ON
		Return
	Endif

	if (kActor != None)
		; StorageUtil _SD_TempAggressor is deprecated
		; Use _sender through kActor.SendModEvent("") in priority instead 
		kNewMaster = kActor
	EndIf
		
	Debug.Trace("[_sdras_player] Receiving 'enslave' event - New master: " + kNewMaster)

	If (kNewMaster != None)  &&  (fctFactions.checkIfSlaver (  kNewMaster ) || fctFactions.checkIfSlaverCreature (  kNewMaster ) )
		; if already enslaved, transfer of ownership

		If (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved") == 1)
			kCurrentMaster = StorageUtil.GetFormValue(kPlayer, "_SD_CurrentOwner") as Actor

			If (!kCurrentMaster.IsDead()) && (kPlayer.GetDistance( kCurrentMaster ) <= ( StorageUtil.GetIntValue(kPlayer, "_SD_iLeashLength") * 2) ) && ( StorageUtil.GetIntValue(kPlayer, "_SD_iSold") != 1 )
				kCurrentMaster.SetRelationshipRank( kPlayer, StorageUtil.GetIntValue(kCurrentMaster, "_SD_iOriginalRelationshipRank") )
				If (Utility.RandomInt(0,100) >= 0) || ( StorageUtil.GetIntValue(kCurrentMaster, "_SD_iDisposition") > 0)
					Debug.Notification("(Owner) Who do you think you are!")
					kCurrentMaster.StartCombat(kNewMaster)
				Else
					Debug.Notification("(Owner) Good riddance...")
				EndIf
			EndIf

			StorageUtil.SetIntValue(kPlayer, "_SD_iSlaveTransfer",1)
			_SDQP_enslavement.Stop()
			SendModEvent("da_PacifyNearbyEnemies", "Restore")

			While ( _SDQP_enslavement.IsStopping() )
			EndWhile

		EndIf

		; new master

		StorageUtil.SetFormValue(kPlayer, "_SD_TempAggressor", None)

		If (_args == "Consensual")
			StorageUtil.SetIntValue(kNewMaster, "_SD_iForcedSlavery", 0) 
		EndIf

		; New enslavement - changing ownership
		_SDKP_enslave.SendStoryEvent(akRef1 = kNewMaster, akRef2 = kPlayer, aiValue1 = 0)
	Else
		Debug.Trace("[_sdras_player] Attempted enslavement to empty master " )
	EndIf
EndEvent

Event OnSDTransfer(String _eventName, String _args, Float _argc = 1.0, Form _sender)
 	Actor kActor = _sender as Actor
	Actor kNewMaster = StorageUtil.GetFormValue( kPlayer, "_SD_TempAggressor") as Actor
	Actor kCurrentMaster

	If (StorageUtil.GetIntValue(kPlayer, "_SD_iForcedSurrender") ==1)
		; Ignore Enslave event if Surrender is ON
		Return
	Endif

	if (kActor != None)
		; StorageUtil _SD_TempAggressor is deprecated
		; Use _sender through kActor.SendModEvent("") in priority instead 
		kNewMaster = kActor
	EndIf
		
	Debug.Trace("[_sdras_player] Receiving 'transfer slave' event - New master: " + kNewMaster)

	If (kNewMaster)
		Debug.Trace("[_sdras_player] Faction check: " + fctFactions.checkIfSlaver (  kNewMaster ) )
	EndIf

	If (kNewMaster != None)   &&  (fctFactions.checkIfSlaver (  kNewMaster ) || fctFactions.checkIfSlaverCreature (  kNewMaster ) )
		If (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved") == 1)
			kCurrentMaster = StorageUtil.GetFormValue(kPlayer, "_SD_CurrentOwner") as Actor

			If (!kCurrentMaster.IsDead()) && (kPlayer.GetDistance( kCurrentMaster ) <= ( StorageUtil.GetIntValue(kPlayer, "_SD_iLeashLength") * 2 ) ) && ( StorageUtil.GetIntValue(kPlayer, "_SD_iSold") != 1 )
				kCurrentMaster.SetRelationshipRank( kPlayer, StorageUtil.GetIntValue(kCurrentMaster, "_SD_iOriginalRelationshipRank") )
				If (Utility.RandomInt(0,100) >= 0) || ( StorageUtil.GetIntValue(kCurrentMaster, "_SD_iDisposition") > 0)
					Debug.Notification("(Owner) Who do you think you are!")
					kCurrentMaster.StartCombat(kNewMaster)
				Else
					Debug.Notification("(Owner) Good riddance...")
				EndIf
			EndIf

			Debug.Trace("[_sdras_player] Slave transfer - stopping enslavement" )
			StorageUtil.SetIntValue(kPlayer, "_SD_iSlaveTransfer",1)
			_SDQP_enslavement.Stop()
			SendModEvent("da_PacifyNearbyEnemies", "Restore")

			While ( _SDQP_enslavement.IsStopping() )
			EndWhile

			Debug.Trace("[_sdras_player] Slave transfer - enslavement stopped" )

		EndIf

		StorageUtil.SetFormValue(kPlayer, "_SD_TempAggressor", None)

		If (_args == "Consensual")
			StorageUtil.SetIntValue(kNewMaster, "_SD_iForcedSlavery", 0) 
		EndIf

		Debug.Trace("[_sdras_player] Slave transfer - starting enslavement" )

		; New enslavement - changing ownership
		_SDKP_enslave.SendStoryEvent(akRef1 = kNewMaster as ObjectReference, akRef2 = kPlayer as ObjectReference, aiValue1 = 0)
	Else
		Debug.Trace("[_sdras_player] Attempted transfer to an empty or invalid master - Actor: " + kNewMaster)
		Debug.Notification("Nevermind...")	
	EndIf
EndEvent

Event OnSDFree(String _eventName, String _args, Float _argc = 1.0, Form _sender)
	Debug.Trace("[_sdras_slave] Receiving 'free slave' event")
	; _SDSP_freedom.RemoteCast( kPlayer, kPlayer, kPlayer )

	_SDQP_enslavement.Stop()
	Wait( fRFSU * 5.0 )


EndEvent

Event OnSDStatusUpdate(String _eventName, String _args, Float _argc = 1.0, Form _sender)
	Actor kActor
	Debug.Trace("[_sdras_slave] Receiving 'slavery status update' event")

	If (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved") == 1)
		kActor = _SD_Enslaved.GetMaster() as Actor
		fctSlavery.UpdateStatusDaily( kActor, Game.GetPlayer(), true)
		fctSlavery.DisplaySlaveryLevelObjective( kActor, Game.GetPlayer(), _SDQP_enslavement )

	EndIf

EndEvent

Event OnSDDreamworldStart(String _eventName, String _args, Float _argc = 15.0, Form _sender)
	int stageID 
	; Dreamworld has to be visited at least once for this event to work
	Debug.Trace("[_sdras_player] Receiving dreamworld start story event [" + _args  + "] [" + _argc as Int + "]")
	Debug.Trace("[_sdras_player] StageID: " + stageID)

	stageID = 10

	_SDGVP_sanguine_blessing.SetValue(0)
	_SD_dreamerScript.startDreamworld()

EndEvent

Event OnSDDreamworldPull(String _eventName, String _args, Float _argc = 15.0, Form _sender)
	int stageID = _args as Int
	; Dreamworld has to be visited at least once for this event to work
	Debug.Trace("[_sdras_player] Receiving dreamworld pull story event [" + _args  + "] [" + _argc as Int + "]")
	Debug.Trace("[_sdras_player] StageID: " + stageID)

	if (stageID == 0)
		stageID = 15
		Debug.Trace("[_sdras_player] StageID is 0, using this stage instead: " + stageID)
	endif

	If (_SDGVP_sanguine_blessing.GetValue() > 0) 
		_SD_dreamQuest.SetStage(stageID)
	EndIf

EndEvent

Event OnSDStorySex(String _eventName, String _args, Float _argc = 1.0, Form _sender)
 	Actor kActor = _sender as Actor
	Actor kTempAggressor = StorageUtil.GetFormValue( kPlayer, "_SD_TempAggressor") as Actor
	; int storyID = _argc as Int

	if (kActor != None)
		; StorageUtil _SD_TempAggressor is deprecated
		; Use _sender through kActor.SendModEvent("") in priority instead 
		kTempAggressor = kActor
	EndIf

	Debug.Trace("[_sdras_player] Receiving sex story event [" + _args  + "] [" + _argc as Int + "]")

	If (kTempAggressor != None)
		StorageUtil.SetFormValue(kPlayer, "_SD_TempAggressor", None)
	ElseIf (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved") == 1)
		kTempAggressor = _SD_Enslaved.GetMaster() as Actor
	Else
		Return
	EndIf

	if (fctOutfit.isArmbinderEquipped( kPlayer )) && (Utility.RandomInt(0,100) > 30)
		fctOutfit.setDeviousOutfitArms ( iDevOutfit =-1, bDevEquip = False, sDevMessage = "")
		StorageUtil.SetIntValue(kPlayer, "_SD_iHandsFreeSex", 1)
	EndIf
 
	if  (_args == "Gangbang")

		funct.SanguineGangRape( kTempAggressor, kPlayer, False, False)

	Elseif (_args == "Soloshow")

		funct.SanguineGangRape( kTempAggressor, kPlayer, False, True)
	Else 
		; Debug.Trace("[_sdras_player] Sending sex story")

		; _SDKP_sex.SendStoryEvent(akRef1 = kTempAggressor, akRef2 = kPlayer, aiValue1 = 0, aiValue2 = 0 )
		funct.SanguineRape( kTempAggressor, kPlayer, "Aggressive")

	EndIf
EndEvent

Event OnSDStoryEntertain(String _eventName, String _args, Float _argc = 1.0, Form _sender)
 	Actor kActor = _sender as Actor
	Actor kTempAggressor = StorageUtil.GetFormValue( kPlayer, "_SD_TempAggressor") as Actor
	; int storyID = _argc as Int

	if (kActor != None)
		; StorageUtil _SD_TempAggressor is deprecated
		; Use _sender through kActor.SendModEvent("") in priority instead 
		kTempAggressor = kActor
	EndIf

	; Debug.Notification("[_sdras_slave] Receiving dance story event [" + _args  + "] [" + _argc as Int + "]")
	Debug.Trace("[_sdras_player] Receiving dance story event [" + _args  + "] [" + _argc as Int + "]")

	If (kTempAggressor != None)
		StorageUtil.SetFormValue(kPlayer, "_SD_TempAggressor", None)
	ElseIf (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved") == 1)
		kTempAggressor = _SD_Enslaved.GetMaster() as Actor
	Else
		Return
	EndIf

	if (fctOutfit.isArmbinderEquipped( kPlayer )) && (Utility.RandomInt(0,100) > 30)
		fctOutfit.setDeviousOutfitArms ( iDevOutfit =-1, bDevEquip = False, sDevMessage = "")
		StorageUtil.SetIntValue(kPlayer, "_SD_iHandsFreeSex", 1)
	EndIf

	if  (_args == "Gangbang")
		; Debug.Notification("[_sdras_slave] Receiving Gangbang")
		funct.SanguineGangRape( kTempAggressor, kPlayer, True, False)

	Elseif (_args == "Soloshow")
		; Debug.Notification("[_sdras_slave] Receiving Show")

		funct.SanguineGangRape( kTempAggressor, kPlayer, True, True)
	Else 
		; Dance
		_SDKP_sex.SendStoryEvent(akRef1 = kTempAggressor as ObjectReference, akRef2 = kPlayer as ObjectReference, aiValue1 = 7, aiValue2 = 0 )
	EndIf

EndEvent

Event OnSDStoryWhip(String _eventName, String _args, Float _argc = 1.0, Form _sender)
 	Actor kActor = _sender as Actor
	Actor kTempAggressor = StorageUtil.GetFormValue( kPlayer, "_SD_TempAggressor") as Actor

	if (kActor != None)
		; StorageUtil _SD_TempAggressor is deprecated
		; Use _sender through kActor.SendModEvent("") in priority instead 
		kTempAggressor = kActor
	EndIf

	Debug.Trace("[_sdras_player] Receiving whip story event [" + _args  + "] [" + _argc as Int + "]")

	_SDKP_sex.SendStoryEvent(akRef1 = kTempAggressor as ObjectReference, akRef2 = kPlayer as ObjectReference, aiValue1 = 5, aiValue2 = 0 )
EndEvent

Event OnSDStoryPunish(String _eventName, String _args, Float _argc = 1.0, Form _sender)
 	Actor kActor = _sender as Actor
	Actor kTempAggressor = StorageUtil.GetFormValue( kPlayer, "_SD_TempAggressor") as Actor
 
	if (kActor != None)
		; StorageUtil _SD_TempAggressor is deprecated
		; Use _sender through kActor.SendModEvent("") in priority instead 
		kTempAggressor = kActor
	EndIf

	Debug.Trace("[_sdras_player] Receiving punish story event [" + _args  + "] [" + _argc as Int + "]")

	If (kTempAggressor != None)
		StorageUtil.SetFormValue(kPlayer, "_SD_TempAggressor", None)
	ElseIf (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved") == 1)
		kTempAggressor = _SD_Enslaved.GetMaster() as Actor
	Else
		Return
	EndIf
 
	_SDKP_sex.SendStoryEvent(akRef1 = kTempAggressor as ObjectReference, akRef2 = kPlayer as ObjectReference, aiValue1 = 3, aiValue2 = RandomInt( 0, _SDGVP_punishments.GetValueInt() ) )
EndEvent

Event OnSDEmancipateSlave(String _eventName, String _args, Float _argc = 1.0, Form _sender)
	Debug.Trace("[_sdras_player] Receiving emancipate slave event [" + _args  + "] [" + _argc as Int + "]")

	_SDGVP_can_join.SetValue(1) 
EndEvent

Event OnSDHandsFreeSlave(String _eventName, String _args, Float _argc = 1.0, Form _sender)
	Debug.Trace("[_sdras_player] Receiving hands free slave event [" + _args  + "] [" + _argc as Int + "]")

	fctOutfit.setDeviousOutfitArms ( iDevOutfit =-1, bDevEquip = False, sDevMessage = "")
	StorageUtil.GetIntValue(kPlayer, "_SD_iHandsFree", 1)
	Debug.Notification("Your owner releases your hands.")
EndEvent

Event OnSDHandsBoundSlave(String _eventName, String _args, Float _argc = 1.0, Form _sender)
	Debug.Trace("[_sdras_player] Receiving hands bound slave event [" + _args  + "] [" + _argc as Int + "]")

	fctOutfit.setDeviousOutfitArms ( iDevOutfit =-1, bDevEquip = True, sDevMessage = "")
	StorageUtil.GetIntValue(kPlayer, "_SD_iHandsFree", 0)
	Debug.Notification("Your owner binds your hands.")
EndEvent

Event OnSDPunishSlave(String _eventName, String _args, Float _argc = 1.0, Form _sender)
	Debug.Trace("[_sdras_player] Receiving punish slave event [" + _args  + "] [" + _argc as Int + "]")
	String sDevice = _args

	; TO DO - Add code to pass keyword to force a specific type of punishment item (use with Equip Device by Leyword)

	If (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved") == 1)
		_SD_Enslaved.PunishSlave(_SD_Enslaved.GetMaster() as Actor, kPlayer, sDevice )
	Else
		Return
	EndIf

EndEvent

Event OnSDRewardSlave(String _eventName, String _args, Float _argc = 1.0, Form _sender)
	Debug.Trace("[_sdras_player] Receiving reward slave event [" + _args  + "] [" + _argc as Int + "]")
	String sDevice = _args

	; TO DO - Add code to pass keyword to remove a specific type of punishment item (use with Equip Device by Leyword)

	If (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved") == 1)
		_SD_Enslaved.RewardSlave(_SD_Enslaved.GetMaster() as Actor, kPlayer, sDevice )
	Else
		Return
	EndIf

EndEvent

Event OnSDEquipDevice(String _eventName, String _args, Float _argc = -1.0, Form _sender)
 	Actor kActor = _sender as Actor
	Int iOutfitID = _argc as Int
	String sDevice = _args

	; Example: akSpeaker forcing a gag on player using OutfitID = 1 [between 0 and 10] 
	; akSpeaker.SendModEvent("SDEquipDevice", "Gag", 1) 

	Debug.Trace("[_sdras_player] Receiving device equip story event [" + _args  + "] [" + _argc as Int + "]")

	; if OutfitID is provided, override with outfit from sender NPC in priority
 	if (iOutfitID != -1)
 		If (StorageUtil.GetIntValue(kActor, "_SD_iOutfitID") > 0)
 			iOutfitID = StorageUtil.GetIntValue(kActor, "_SD_iOutfitID")
 		endif

 		if (sDevice == "PlugAnal") || (sDevice == "PlugVaginal")
  			fctOutfit.setDeviousOutfitPartByString (iOutfitID, "Belt", False)
  		endif

  		fctOutfit.setDeviousOutfitPartByString (iOutfitID, sDevice, True)

 		if (sDevice == "PlugAnal") || (sDevice == "PlugVaginal")
  			fctOutfit.setDeviousOutfitPartByString (iOutfitID, "Belt", True)
  		endif

 	Else
 		if (sDevice == "PlugAnal") || (sDevice == "PlugVaginal")
  			fctOutfit.clearDeviceByString ( sDeviceString = "Belt" )
  		endif

  		fctOutfit.equipDeviceByString ( sDeviceString = sDevice )

 		if (sDevice == "PlugAnal") || (sDevice == "PlugVaginal")
  			fctOutfit.equipDeviceByString ( sDeviceString = "Belt" )
  		endif

 	endif

EndEvent

Event OnSDClearDevice(String _eventName, String _args, Float _argc = -1.0, Form _sender)
 	Actor kActor = _sender as Actor
	Int iOutfitID = _argc as Int
	String sDevice = _args

	Debug.Trace("[_sdras_player] Receiving device clear story event [" + _args  + "] [" + _argc as Int + "]")

	; if OutfitID is provided, override with outfit from sender NPC in priority
 	if (iOutfitID != -1)
 		If (StorageUtil.GetIntValue(kActor, "_SD_iOutfitID") > 0)
 			iOutfitID = StorageUtil.GetIntValue(kActor, "_SD_iOutfitID")
 		endif

 		if (sDevice == "PlugAnal") || (sDevice == "PlugVaginal")
  			fctOutfit.setDeviousOutfitPartByString (iOutfitID, "Belt", False)
  		endif

  		fctOutfit.setDeviousOutfitPartByString (iOutfitID, sDevice, False)

 		if (sDevice == "PlugAnal") || (sDevice == "PlugVaginal")
  			fctOutfit.setDeviousOutfitPartByString (iOutfitID, "Belt", True)
  		endif

 	Else
 		if (sDevice == "PlugAnal") || (sDevice == "PlugVaginal")
  			fctOutfit.clearDeviceByString ( sDeviceString = "Belt" )
  		endif

  		fctOutfit.clearDeviceByString ( sDeviceString = sDevice )

 		if (sDevice == "PlugAnal") || (sDevice == "PlugVaginal")
  			fctOutfit.equipDeviceByString ( sDeviceString = "Belt" )
  		endif

 	endif

EndEvent

Event OnSDEquipSlaveRags(String _eventName, String _args, Float _argc = -1.0, Form _sender)
 	Actor kActor = _sender as Actor
	Int iOutfitID = _argc as Int
	String sDevice = _args

	; Example: akSpeaker forcing a gag on player using OutfitID = 1 [between 0 and 10] 
	; akSpeaker.SendModEvent("SDEquipDevice", "Gag", 1) 

	if (kActor == None)
		; StorageUtil _SD_TempAggressor is deprecated
		; Use _sender through kActor.SendModEvent("") in priority instead 
		kActor = Game.GetPlayer() as Actor
	EndIf

	Debug.Trace("[_sdras_player] Receiving slave rags equip story event [" + _args  + "] [" + _argc as Int + "]")

	_SD_Enslaved.EquipSlaveRags(kActor)

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
		
		; Key mapping reference - http://www.creationkit.com/Input_Script#DXScanCodes

		keys[0] = config._SDUIP_keys[1]
		keys[1] = config._SDUIP_keys[6]
		RegisterForKey( keys[0] )
		RegisterForKey( keys[1] )

		; RegisterForMenu( "Crafting Menu" )
		; RegisterForAnimationEvent(kPlayer, "RemoveCharacterControllerFromWorld")
		; RegisterForAnimationEvent(kPlayer, "GetUpEnd")
	EndEvent

	Event OnPlayerLoadGame()
		keys[0] = config._SDUIP_keys[1]
		keys[1] = config._SDUIP_keys[6]
		RegisterForKey( keys[0] )
		RegisterForKey( keys[1] )
		if ( StorageUtil.GetIntValue( kPlayer, "_SD_iEnslaved") > 0 )
			; Suspend Deviously Helpless attacks.
			SendModEvent("dhlp-Suspend")
		EndIf
	EndEvent

	Event OnEndState()
		; UnregisterForMenu( "Crafting Menu" )
		UnregisterForKey( keys[0] )
		UnregisterForKey( keys[1] )

		; UnregisterForAnimationEvent(kPlayer, "RemoveCharacterControllerFromWorld")
		; UnregisterForAnimationEvent(kPlayer, "GetUpEnd")
	EndEvent

	Event OnUpdate()
		If ( Self.GetOwningQuest().IsStopping() || Self.GetOwningQuest().IsStopped() )
			GoToState("waiting")

			If ( Self.GetOwningQuest() )
				RegisterForSingleUpdate( 0.1 )
			EndIf
			Return
		EndIf

	 	daysPassed = Game.QueryStat("Days Passed")

	 	if (iGameDateLastCheck == -1)
	 		iGameDateLastCheck = daysPassed
	 	EndIf

	 	iDaysSinceLastCheck = (daysPassed - iGameDateLastCheck ) as Int
	 	; Debug.Notification( "[SD] Player status - days: " + iDaysSinceLastCheck)

		If (iDaysSinceLastCheck == 0) ; same day - incremental updates
			iCountSinceLastCheck += 1

			if (iCountSinceLastCheck >= 500)
				; Debug.Notification( "[SD] Player status - hourly update")
				iCountSinceLastCheck = 0
				
			EndIf

		Else ; day change - full update
			; Debug.Notification( "[SD] Player status - daily update")
			iGameDateLastCheck = daysPassed
			iCountSinceLastCheck = 0

			; Cooldown of slavery exposure when released

			; StorageUtil.GetIntValue( kPlayer , "_SD_iSlaveryLevel") - 0 to 6
			; StorageUtil.GetIntValue( kPlayer, "_SD_iDominance") - -10 to 10
			; _SDGVP_config_slavery_level_mult.GetValue() - 0 to 1


			If (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved") != 1)   
				fOldExposure = (StorageUtil.GetIntValue(kPlayer, "_SD_iSlaveryExposure") as Float)
				fExposureMultiplier = 1.0 - (_SDGVP_config_slavery_level_mult.GetValue() as Float) 

				if ( StorageUtil.GetIntValue( kPlayer, "_SD_iDominance") > 0)
					fNewExposure =  fOldExposure - fOldExposure * fExposureMultiplier 
				Else
					fNewExposure =  fOldExposure - fOldExposure * fExposureMultiplier * ( ( (6 - StorageUtil.GetIntValue( kPlayer , "_SD_iSlaveryLevel") ) as Float) / 6.0)			
				endif


				StorageUtil.SetIntValue(kPlayer, "_SD_iSlaveryExposure",  funct.intMax(0, fNewExposure as Int ))
			EndIf

			StorageUtil.SetIntValue(kPlayer, "_SD_iGenderRestrictions",  _SDGVP_config[3].GetValue() as Int )
			fctSlavery.UpdateSlaveryLevel(kPlayer) 
				
			; Debug.Notification( "[SD] Player status - slavery exposure: " + StorageUtil.GetIntValue(kPlayer, "_SD_iSlaveryExposure"))
		EndIf

		StorageUtil.SetIntValue(kPlayer, "_SD_iSanguineBlessings", _SDGVP_sanguine_blessings.GetValue() as Int )
		
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
		; EndIf

		If (StorageUtil.GetIntValue(kPlayer, "_SD_iForcedDreamworld") ==1) && (_SD_dreamQuest.GetStage() != 0) && (_SDGVP_config[4].GetValue() == 1) 
			Debug.MessageBox("Your true master is calling you...")

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
			; Debug.SendAnimationEvent(kPlayer, "IdleForceDefaultState")

			StorageUtil.SetIntValue(kPlayer, "_SD_iForcedDreamworld", 0) 

			Utility.Wait(1.0)

			_SD_dreamQuest.SetStage(100)

		EndIf

		If ( kPlayer.WornHasKeyword( _SDKP_spriggan_infected ) && (StorageUtil.GetIntValue(kPlayer, "_SD_iSprigganInfected") != 1) ) && (Utility.RandomInt(1,100)<= ( (_SDGVP_config_healthMult.GetValue() as Int ) / 20) ) && (Utility.RandomInt(0,100)>=(StorageUtil.GetIntValue(kPlayer, "_SD_iSprigganEnslavedCount") * 50)) 
			; Chance of spriggan infection if slave is wearing a spriggan root armor item
			; Debug.Notification("[SD] Infected by spriggan roots...")
			SendModEvent("SDSprigganEnslave")
		EndIf			

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

		If (UI.IsTextInputEnabled())
			Return
		EndIf

		If ( aiKeyCode == keys[0] )
			If ( shiftPress && !altPress )
				iMsgResponse = _SDMP_scene_stop.Show()
				If ( iMsgResponse == 0 && snp._SDSP_sexScenes.Find( kPlayer.GetCurrentScene() ) >= 0 )
					kPlayer.GetCurrentScene().Stop()
				EndIf
			ElseIf ( altPress && !kPlayer.IsInCombat() && funct.GetPlayerDialogueTarget() )
				; kPlayer.PushActorAway( funct.GetPlayerDialogueTarget(), 0.0 )
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

				Actor kCombatTarget = kPlayer.GetCombatTarget() as Actor

				If (IButton == 0 ) 
					; StorageUtil.SetIntValue(kPlayer, "_SD_iForcedSurrender", 1)	
					SendModEvent("da_PacifyNearbyEnemies", "Restore")
					SendModEvent("PCSubSurrender")

				ElseIf (IButton == 1)
					; Pray to Sanguine

					; Monitor.GoToState("")
					; Debug.SetGodMode( True )
					; kPlayer.EndDeferredKill()
					
					If (Utility.RandomInt(0,100) > 95) && (_SD_dreamQuest.GetStage() != 0) 
						; Send PC to Dreamworld

						_SD_dreamQuest.SetStage(100)

					ElseIf (Utility.RandomInt(0,100) > 70) && (!isInKWeakenedState)	
						; Send PC some help

						SendModEvent("da_StartSecondaryQuest", "Both")

					ElseIf (Utility.RandomInt(0,100) > 40) && (isInKWeakenedState)	
						; Send PC some help

						SendModEvent("da_StartSecondaryQuest", "Both")
						SendModEvent("da_StartRecoverSequence")

					ElseIf (Utility.RandomInt(0,100) > 30)	&& (isInKWeakenedState)
						; restore all hp	
						Monitor.BufferDamageReceived(9999.0)  	

					Else
						Debug.Notification("Your prayer goes unanswered...")
					EndIf
				ElseIf IButton == 2
					; Resist

					Game.SetPlayerAIDriven(false)
					Game.SetInCharGen(false, false, false)
					; Game.EnablePlayerControls() ; just in case	
					Game.EnablePlayerControls( abMovement = True )
					fctOutfit.DDSetAnimating( kPlayer, false )
					StorageUtil.SetIntValue(kPlayer, "_SD_iForcedSurrender", 0)

					; Debug.SendAnimationEvent(kPlayer, "IdleForceDefaultState")

					; SendModEvent("da_UpdateBleedingDebuff")
					; SendModEvent("da_EndNearDeathDebuff")	

					Debug.SetGodMode( False )


					; UnregisterForMenu( "Crafting Menu" )
					; UnregisterForAnimationEvent(kPlayer, "RemoveCharacterControllerFromWorld")
					; UnregisterForAnimationEvent(kPlayer, "GetUpEnd")
				Else
					Debug.Notification("You still have life in you...")
				EndIf


			EndIf
 
		EndIf

	EndEvent

	Event OnCombatStateChanged(Actor akTarget, int aeCombatState)
	  if (akTarget != kPlayer)

	    rapeAttempts = 0
	    ; Clear forced surrender to fit only current combat
	    StorageUtil.SetIntValue(kPlayer, "_SD_iForcedSurrender",0) 

	  endIf
	endEvent

	Event OnMagicEffectApply(ObjectReference akCaster, MagicEffect akEffect)
		; Old trigger - disabled for compatibility with Death Alternative
		Actor kCaster = akCaster as Actor
 
		If (StorageUtil.GetIntValue(kPlayer, "_SD_iForcedSurrender") ==1) && (akCaster!=kPlayer)
			; StorageUtil.SetIntValue(kPlayer, "_SD_iForcedSurrender",0) 
				
			If (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved") != 1)  

				Debug.Trace("[_sdras_player] Forced surrender on magic effect - Start enslavement")
				Debug.Notification("You surrender to your aggressor...")
				; StorageUtil.SetFormValue( kPlayer , "_SD_TempAggressor", akCaster as Actor)

				kCaster.SendModEvent("PCSubSurrender") ; Enslavement

			ElseIf (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved") == 1) 

				Debug.Trace("[_sdras_player] Forced surrender on magic effect - Start transfer")
				Debug.Notification("You submit to your new master...")
				; StorageUtil.SetFormValue( kPlayer , "_SD_TempAggressor", akCaster as Actor)

				kCaster.SendModEvent("PCSubSurrender") ; Enslavement
			EndIf
		EndIf
	EndEvent

	Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
		Actor kAggressor = akAggressor as Actor

		; Debug.Notification("[_sdras_player] OnHit - Aggressor:" + akAggressor)

		If (StorageUtil.GetIntValue(kPlayer, "_SD_iForcedSurrender") ==1) 
			; StorageUtil.SetIntValue(kPlayer, "_SD_iForcedSurrender",0) 
			
			If (fctFactions.checkIfSlaver (  kAggressor ) || fctFactions.checkIfSlaverCreature (  kAggressor ) )	
				If (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved") != 1)  

					Debug.Trace("[_sdras_player] Forced surrender on hit - Start enslavement")
					Debug.Notification("You surrender to your aggressor...")
					; StorageUtil.SetFormValue(kPlayer , "_SD_TempAggressor", akAggressor as Actor)

					kAggressor.SendModEvent("PCSubSurrender") ; Enslavement

				ElseIf (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved") == 1) 

					Debug.Trace("[_sdras_player] Forced surrender on hit - Start transfer")
					Debug.Notification("You submit to your new master...")
					; StorageUtil.SetFormValue( kPlayer , "_SD_TempAggressor", akAggressor as Actor)

					kAggressor.SendModEvent("PCSubSurrender") ; Enslavement
				EndIf
			Else
					Debug.Trace("[_sdras_player] Forced surrender on hit - Start rape")
					Debug.Notification("You submit to your aggressor...")
					; StorageUtil.SetFormValue( kPlayer , "_SD_TempAggressor", akAggressor as Actor)

					Debug.SendAnimationEvent(kPlayer, "Unequip")
					Debug.SendAnimationEvent(kPlayer, "UnequipNoAnim")

					; Drop current weapon 
					if(kPlayer.IsWeaponDrawn())
						kPlayer.SheatheWeapon()
						Utility.Wait(2.0)
					endif

					fctOutfit.toggleActorClothing (  kPlayer,  bStrip = True,  bDrop = False )
					fctConstraints.actorCombatShutdown( kPlayer )
					fctConstraints.actorCombatShutdown( kAggressor )

					StorageUtil.SetIntValue(kPlayer, "_SD_iForcedSurrender", 0)	

					kAggressor.SendModEvent("PCSubSex") ; Enslavement
			EndIf
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
		; Disabled  for now - Why would sitting on furniture cancel enslavement ????

		; If ( !_SDGVP_enslaved.GetValueInt() && kPlayer.WornHasKeyword( _SDKP_bound ) && _SDFLP_escape_furn.HasForm( akFurniture.GetBaseObject() ) )  && (0==1)
		;	funct.removeItemsInList( kPlayer, _SDFLP_sex_items )
		;	funct.removeItemsInList( kPlayer, _SDFLP_punish_items )
		;	_SDSP_freedom.RemoteCast( kPlayer, kPlayer, kPlayer )
		;	_SDQP_enslavement.Stop()
		;	Utility.Wait(0.5)
		; EndIf
	EndEvent
EndState


ReferenceAlias Property _SDRAP_player_safe  Auto  

FormList Property _SDFL_banned_sex  Auto  

FormList Property _SDFL_allowed_creature_sex  Auto  

SPELL Property Calm  Auto  
daymoyl_MonitorScript 		Property Monitor 		Auto
Message Property _SD_safetyMenu  Auto  

GlobalVariable Property _SDGVP_sanguine_blessing auto

ObjectReference Property _SD_SprigganSwarm Auto

GlobalVariable Property _SDGVP_config_slavery_level_mult Auto

GlobalVariable Property _SDGVP_isPlayerPregnant auto
GlobalVariable Property _SDGVP_isPlayerSuccubus auto
GlobalVariable Property _SDGVP_isPlayerHRT auto
GlobalVariable Property _SDGVP_isPlayerTG auto
GlobalVariable Property _SDGVP_isPlayerBimbo auto
GlobalVariable Property _SDGVP_isPlayerEnslaved auto

GlobalVariable Property _SDGVP_sanguine_blessings auto