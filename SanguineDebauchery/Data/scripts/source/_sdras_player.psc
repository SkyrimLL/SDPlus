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
GlobalVariable Property _SDGVP_slave_days_max Auto
GlobalVariable Property _SDGVP_config_healthMult Auto
GlobalVariable Property _SDGVP_state_caged  Auto 
GlobalVariable Property _SDGVP_state_playerRagdoll  Auto
GlobalVariable Property _SDGVP_frostfallMortality  Auto  

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

Message Property _SDMP_rape_menu  Auto

; spriggan enslavement
Keyword Property _SDKP_spriggan  Auto
Keyword Property _SDKP_spriggan_infected  Auto
FormList Property _SDFLP_spriggan_factions  Auto

; Thug enslavement
Quest Property _SDQP_thugs  Auto
Keyword Property _SDKP_thugs  Auto
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

ReferenceAlias Property _SDRAP_player_safe  Auto  

FormList Property _SDFL_banned_sex  Auto  

FormList Property _SDFL_allowed_creature_sex  Auto  

SPELL Property Calm  Auto  
SPELL Property _SDSP_SanguineBoundClear  Auto  
Message Property _SD_safetyMenu  Auto  
Message Property _SD_enslaveMenu Auto

GlobalVariable Property _SDGVP_sanguine_blessing auto

ObjectReference Property _SD_SprigganSwarm Auto

GlobalVariable Property _SDGVP_config_slavery_level_mult Auto

GlobalVariable Property _SDGVP_isPlayerEnslaved auto
GlobalVariable Property _SDGVP_isPlayerPregnant auto
GlobalVariable Property _SDGVP_isPlayerSuccubus auto
GlobalVariable Property _SDGVP_isPlayerHRT auto
GlobalVariable Property _SDGVP_isPlayerTG auto
GlobalVariable Property _SDGVP_isPlayerBimbo auto
GlobalVariable Property _SDGVP_allowPlayerHRT auto
GlobalVariable Property _SDGVP_allowPlayerTG auto
GlobalVariable Property _SDGVP_allowPlayerBimbo auto


GlobalVariable Property _SDGVP_sanguine_blessings auto

GlobalVariable Property _SDGVP_enable_parasites auto
GlobalVariable Property _SDGVP_enable_masterTravel auto
GlobalVariable Property _SDGVP_state_isMasterTraveller auto
GlobalVariable Property _SDGVP_state_isMasterInTransit auto
GlobalVariable Property _SDGVP_state_isMasterFollower auto
GlobalVariable Property _SDGVP_isLeashON auto

MiscObject Property Lockpick  Auto  

 
; local
Actor kPlayer
Actor kMasterToBe = None
; ObjectReference kLust
ObjectReference kPlayerSafe
ObjectReference kCrosshairTarget
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
Bool allowPlayerHRT = False
Bool allowPlayerTG = False
Bool allowPlayerBimbo = False

String lastStance = ""
bool bOk

Actor kCombatTarget = None
Actor kSubmitTarget = None


Event OnInit()
	Debug.Trace("_SDRAS_player.OnInit()")
	kPlayer = Self.GetReference() as Actor

	keys = New Int[4]

	_maintenance()

	GoToState("waiting")
	
	If ( Self.GetOwningQuest() )
		RegisterForSingleUpdate( 0.1 )
	EndIf
EndEvent



Function _Maintenance()
	If (!StorageUtil.HasIntValue(none, "_SD_iSD"))
		StorageUtil.SetIntValue(none, "_SD_iSD", 1)
	EndIf

 	UnregisterForAllModEvents()
	Debug.Trace("[_sdras_player] Register events")
	RegisterForModEvent("PCSubEnslave",   "OnSDEnslave")
	RegisterForModEvent("PCSubEnslaveRadius",   "OnSDEnslaveRadius")
	RegisterForModEvent("PCSubEnslaveMenu",   "OnSDEnslaveMenu")
	RegisterForModEvent("PCSubSubmit",   "OnSDSubmit")
	RegisterForModEvent("PCSubSurrender",   "OnSDSurrender")
	RegisterForModEvent("PCSubSex",   "OnSDStorySex")
	RegisterForModEvent("PCSubEntertain",   "OnSDStoryEntertain")
	RegisterForModEvent("PCSubWhip",   "OnSDStoryWhip")
	RegisterForModEvent("PCSubPunish",   "OnSDStoryPunish")
	RegisterForModEvent("PCSubTransfer",   "OnSDTransfer")
	RegisterForModEvent("PCSubFree",   "OnSDFree")
	RegisterForModEvent("PCSubStatus",   "OnSDStatusUpdate")
	RegisterForModEvent("PCSubMasterGold",   "OnSDMasterGold")
	RegisterForModEvent("SDSprigganEnslave",   "OnSDSprigganEnslave")
	RegisterForModEvent("SDSprigganPunish",   "OnSDSprigganPunish")
	RegisterForModEvent("SDSprigganFree",   "OnSDSprigganFree")
	; RegisterForModEvent("SDParasiteVag",   "OnSDParasiteVag")
	; RegisterForModEvent("SDParasiteAn",   "OnSDParasiteAn")
	RegisterForModEvent("SDDreamworldPull",   "OnSDDreamworldPull")
	RegisterForModEvent("SDDreamworldStart",   "OnSDDreamworldStart")
	RegisterForModEvent("SDDreamworldSuspend",   "OnSDDreamworldSuspend")
	RegisterForModEvent("SDDreamworldResume",   "OnSDDreamworldResume")
	RegisterForModEvent("SDEmancipateSlave",   "OnSDEmancipateSlave")
	RegisterForModEvent("SDPunishSlave",   "OnSDPunishSlave")
	RegisterForModEvent("SDRewardSlave",   "OnSDRewardSlave")
	RegisterForModEvent("SDHandsFreeSlave",   "OnSDHandsFreeSlave")
	RegisterForModEvent("SDHandsBoundSlave",   "OnSDHandsBoundSlave")
	RegisterForModEvent("SDEquipDevice",   "OnSDEquipDevice")
	RegisterForModEvent("SDClearDevice",   "OnSDClearDevice")
	RegisterForModEvent("SDClearSanguineDevices",   "OnSDClearSanguineDevices")
	RegisterForModEvent("SDEquipSlaveRags",   "OnSDEquipSlaveRags")
	RegisterForModEvent("PCSubStance",   "OnSDStance")
	RegisterForModEvent("PCSubTrustAction",   "OnSDTrustAction")
	RegisterForModEvent("PCSubTrustFight",   "OnSDTrustFight")
	RegisterForModEvent("PCSubUnleash",   "OnSDUnleash")
	RegisterForModEvent("PCSubLeash",   "OnSDLeash")
	RegisterForModEvent("PCSubMasterFollow",   "OnSDMasterFollow")
	RegisterForModEvent("PCSubMasterTravel",   "OnSDMasterTravel")
	RegisterForModEvent("SDSanguineBlessingMod",   "OnSDModSanguineBlessing") ; obsolete
	RegisterForModEvent("SDModSanguineBlessing",   "OnSDModSanguineBlessing")
	RegisterForModEvent("SDModMasterTrust",   "OnSDModMasterTrust")
	RegisterForModEvent("SDPickNextTask",   "OnSDPickNextTask")
	RegisterForModEvent("SDModTaskAmount",   "OnSDModTaskAmount")
	RegisterForModEvent("SDEndGame",   "OnSDEndGame")


	Debug.Trace("SexLab Dialogues: Reset SexLab events")
	RegisterForModEvent("AnimationStart", "OnSexLabStart")
	RegisterForModEvent("AnimationEnd",   "OnSexLabEnd")
	; RegisterForModEvent("OrgasmStart",    "OnSexLabOrgasm")

	RegisterForSleep()

	; Release player from enslavement if sent to Simple slavery cell
	RegisterForModEvent("SSLV Entry",   "OnSDFree")
	RegisterForCrosshairRef()

	; Check for DLC Races
	If (StorageUtil.GetFormValue(None, "_SD_Race_SprigganEarthMother") == none)
		Race SprigganEarthMotherRace = Game.GetFormFromFile(0x00013B77, "Dawnguard.esm") As Race
		Race DLC2SprigganBurntRace = Game.GetFormFromFile(0x0001B644, "Dragonborn.esm") As Race
		Race FalmerFrozenVampRace = Game.GetFormFromFile(0x0001AACC, "Dawnguard.esm") As Race

		StorageUtil.SetFormValue(None, "_SD_Race_SprigganEarthMother", SprigganEarthMotherRace)
		StorageUtil.SetFormValue(None, "_SD_Race_SprigganBurnt", DLC2SprigganBurntRace)
		StorageUtil.SetFormValue(None, "_SD_Race_FalmerFrozen", FalmerFrozenVampRace)
	Endif

	; Restore compatibility flags with Deviously Helpless on load if enslaved or infected

	kPlayer = Self.GetReference() as Actor
	If !kPlayer || kPlayer == none
		return
	EndIf
	If (StorageUtil.GetIntValue(kPlayer, "_SD_iSprigganInfected") == 1) || (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved")==1)

		SendModEvent("dhlp-Suspend")
	EndIf

	if ( StorageUtil.GetIntValue( kPlayer, "_SD_iEnslaved") > 0 )
		; Suspend Deviously Helpless attacks.
		SendModEvent("dhlp-Suspend")
	EndIf
 

	fctConstraints.InitAA()

	fctConstraints.UpdateStanceOverrides() 

	fctFactions.cleanSlaveryFactions( kPlayer ) 

	; If (kPlayer != Game.GetPlayer())
		; Debug.MessageBox("[SD] Player ref has changed. ")
	; Endif

	isPlayerEnslaved = StorageUtil.GetIntValue( kPlayer, "_SD_iEnslaved") as Bool
	isPlayerPregnant = StorageUtil.GetIntValue( kPlayer, "_SLH_isPregnant") as Bool
	isPlayerSuccubus = StorageUtil.GetIntValue( kPlayer, "_SLH_isSuccubus") as Bool
	isPlayerHRT = StorageUtil.GetIntValue( kPlayer, "_SLH_iHRT") as Bool
	isPlayerTG = StorageUtil.GetIntValue( kPlayer, "_SLH_iTG") as Bool
	isPlayerBimbo = StorageUtil.GetIntValue( kPlayer, "_SLH_iBimbo") as Bool
	allowPlayerHRT = StorageUtil.GetIntValue( kPlayer, "_SLH_allowHRT") as Bool
	allowPlayerTG = StorageUtil.GetIntValue( kPlayer, "_SLH_allowTG") as Bool
	allowPlayerBimbo = StorageUtil.GetIntValue( kPlayer, "_SLH_allowBimbo") as Bool

	_SDGVP_isPlayerPregnant.SetValue(isPlayerPregnant as Int)
	_SDGVP_isPlayerSuccubus.SetValue(isPlayerSuccubus as Int)
	_SDGVP_isPlayerEnslaved.SetValue(isPlayerEnslaved as Int)
	_SDGVP_isPlayerHRT.SetValue(isPlayerHRT as Int)
	_SDGVP_isPlayerTG.SetValue(isPlayerTG as Int)
	_SDGVP_isPlayerBimbo.SetValue(isPlayerBimbo as Int)
	_SDGVP_allowPlayerHRT.SetValue(allowPlayerHRT as Int)
	_SDGVP_allowPlayerTG.SetValue(allowPlayerTG as Int)
	_SDGVP_allowPlayerBimbo.SetValue(allowPlayerBimbo as Int)
 
EndFunction

Event OnSleepStop(bool abInterrupted)
	If ( (_SD_spriggan.IsRunning()) && (_SD_spriggan.GetStageDone(80)==1) )
		debug.Messagebox("The last of the Spriggan Sap flows out of your body.")
		SendModEvent("SDSprigganFree")
	Endif
EndEvent

Event OnSexLabStart(String _eventName, String _args, Float _argc, Form _sender)
	ObjectReference PlayerREF= kPlayer
	Actor PlayerActor= PlayerREF as Actor
	ActorBase pActorBase = PlayerActor.GetActorBase()
	Actor kCurrentMaster
    sslBaseAnimation animation = SexLab.HookAnimation(_args)

	if !Self || !SexLab 
		debugTrace(": Critical error on SexLab End")
		Return
	EndIf

	Actor[] actors  = SexLab.HookActors(_args)
	Actor   victim  = SexLab.HookVictim(_args)
	Actor[] victims = new Actor[1]
	victims[0] = victim

	If (funct._hasPlayer(actors)) 
		StorageUtil.SetIntValue(PlayerActor, "_SL_iPlayerSexAnim", 1)
	else
		StorageUtil.SetIntValue(PlayerActor, "_SL_iPlayerSexAnim", 0)
	endif

	If (StorageUtil.GetIntValue(PlayerActor, "_SD_iEnslaved") == 1)
		kCurrentMaster = StorageUtil.GetFormValue(PlayerActor, "_SD_CurrentOwner") as Actor

		; If (!funct._hasActor(actors, kCurrentMaster))  && (StorageUtil.GetStringValue(kPlayer, "_SD_sCurrentTaskTarget") == "MasterOnly" )
			; fctSlavery.ModTaskAmount(kPlayer, "MasterOnly", 1) ; player is having sex without master 
		; Endif
		
		If (StorageUtil.GetIntValue(PlayerActor, "_SL_iPlayerSexAnim") == 1)

			; Player hands are freed temporarily for sex

			if ( (fctOutfit.isWristRestraintEquipped( PlayerActor )) && (actors.Length > 1) && (Utility.RandomInt(0,100)>80) ); Exclude masturbation
				; Testing if devices automatically removed by DDi 3.0+
				; fctOutfit.equipDeviceByString ( "Armbinder" )
				; StorageUtil.SetIntValue(PlayerActor, "_SD_iHandsFreeSex", 1)
				fctOutfit.ClearSlavePunishment(PlayerActor , "WristRestraints", true )
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
		debugTrace(": Critical error on SexLab End")
		Return
	EndIf


	Actor[] actors  = SexLab.HookActors(_args)
	Actor   victim  = SexLab.HookVictim(_args)
	Actor[] victims = new Actor[1]
	victims[0] = victim

	
	; if config.bDebugMsg
	; 	_listActors("End: ", actors)
	; EndIf

	If (funct._hasPlayer(actors)) 
		StorageUtil.SetIntValue(PlayerActor, "_SL_iPlayerSexAnim", 1)
	else
		StorageUtil.SetIntValue(PlayerActor, "_SL_iPlayerSexAnim", 0)
	endif

	If (StorageUtil.GetIntValue(PlayerActor, "_SD_iEnslaved") == 1) && (funct._hasPlayer(actors))
		Actor kCurrentMaster = StorageUtil.GetFormValue(PlayerActor, "_SD_CurrentOwner") as Actor

		If (kCurrentMaster != None)  

			If (funct._hasActor(actors,kCurrentMaster))
				debugTrace(": Sex with your master")
				fctOutfit.setMasterGearByRace ( kCurrentMaster, PlayerActor  )

				fctSlavery.UpdateSlaveStatus( PlayerActor, "_SD_iSexCountToday", modValue = 1)
				fctSlavery.UpdateSlaveStatus( PlayerActor, "_SD_iSexCountTotal", modValue = 1)
				fctSlavery.UpdateSlaveStatus( PlayerActor, "_SD_iGoalSex", modValue = 1)
				fctSlavery.UpdateSlaveStatus( PlayerActor, "_SD_iSlaveryExposure", modValue = 1)

				if animation.HasTag("Oral")
					fctSlavery.ModSlaveryTask(PlayerActor, "Wash", 1)
				endIf
		
				; Debug.Notification("[SD]: Sex with your master: " + StorageUtil.GetIntValue(PlayerActor, "_SD_iGoalSex"))

				; If master is trusting slave, increased chance of hands free after sex
				If (StorageUtil.GetIntValue(kCurrentMaster, "_SD_iTrust")>0) && (Utility.RandomInt(0,100) > 70) && (actors.Length > 1) ; Exclude masturbation
				; Chance player will keep armbinders after sex
					Debug.Notification("Your hands remain free.. lucky you.")
					; fctOutfit.clearDeviceByString ( "WristRestraints" )

				ElseIf (!fctOutfit.isWristRestraintEquipped(PlayerActor)) && (StorageUtil.GetIntValue(PlayerActor, "_SD_iHandsFreeSex") == 1) && (StorageUtil.GetIntValue(PlayerActor, "_SD_iEnableAction") == 0) && (StorageUtil.GetIntValue(PlayerActor, "_SD_iEnslaved") == 1) && (StorageUtil.GetIntValue(PlayerActor, "_SD_iSlaveryBindingsOn")==1)

					; Testing if devices automatically removed by DDi 3.0+
					; fctOutfit.equipDeviceByString ( "Armbinder" )

					StorageUtil.SetIntValue(PlayerActor, "_SD_iHandsFree", 0)
				else
					Debug.Trace("[_sdras_player] Unable to find bound hands conditions.")
				EndIf

			Elseif (actors.Length > 1); Exclude masturbation
				fctOutfit.setMasterGearByRace ( actors[1], PlayerActor  )

				If (Utility.RandomInt(0,100) > 90)  
				; Chance player will keep armbinders after sex
					Debug.Notification("Your hands remain free.. lucky you.")
					fctOutfit.clearDeviceByString ( "WristRestraints" )

				ElseIf (!fctOutfit.isWristRestraintEquipped(PlayerActor)) && (StorageUtil.GetIntValue(PlayerActor, "_SD_iHandsFreeSex") == 1) && (StorageUtil.GetIntValue(PlayerActor, "_SD_iEnableAction") == 0) && (StorageUtil.GetIntValue(PlayerActor, "_SD_iEnslaved") == 1) && (StorageUtil.GetIntValue(PlayerActor, "_SD_iSlaveryBindingsOn")==1)

					; If player is enslaved, use player outfit, else, use generic device
					; fctOutfit.equipDeviceByString ( "Armbinder" )

					StorageUtil.SetIntValue(PlayerActor, "_SD_iHandsFree", 0)
				else
					Debug.Trace("[_sdras_player] Unable to find bound hands conditions.")
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
		debugTrace(": Critical error on SexLab Orgasm")
		Return
	EndIf

	Actor[] actors  = SexLab.HookActors(_args)
	Actor   victim  = SexLab.HookVictim(_args)
	Actor[] victims = new Actor[1]
	victims[0] = victim

	; If (funct._hasPlayer(actors))
	;	debugTrace(": Orgasm!")

	; EndIf
	
EndEvent

Event OnSDSprigganEnslave(String _eventName, String _args, Float _argc = 1.0, Form _sender)
 	Actor kActor = _sender as Actor
	Actor kNewMaster = StorageUtil.GetFormValue( kPlayer , "_SD_TempAggressor") as Actor
	ObjectReference kNewMasterRef
	Bool bAbort = False

	if (kActor != None)
		; StorageUtil _SD_TempAggressor is deprecated
		; Use _sender through kActor.SendModEvent("") in priority instead 
		kNewMaster = kActor
	EndIf
		
	Debug.Trace("[_sdras_player] Receiving 'spriggan enslave' event - New master: " + kNewMaster)

	; SexLab Hormones - chance of resistance to infection
	if (Utility.RandomFloat(1.0,100.0)<(100.0 - StorageUtil.GetFloatValue(kPlayer, "_SLH_fHormoneImmunity")))
		Debug.Trace("[_sdras_player]     Resisted disease - _SLH_fHormoneImmunity = " + StorageUtil.GetFloatValue(kPlayer, "_SLH_fHormoneImmunity"))
		bAbort = True
	endif

	If (kNewMaster != None)  &&  fctFactions.checkIfSpriggan (  kNewMaster ) && (!bAbort)
		; new master

		StorageUtil.SetFormValue(kPlayer, "_SD_TempAggressor", None)

		_SDKP_spriggan.SendStoryEvent(akRef1 = kNewMaster as ObjectReference, akRef2 = kPlayer, aiValue1 = 0, aiValue2 = 0)
 
	Elseif  (kNewMaster == None)
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


Event OnSDSprigganFree(String _eventName, String _args, Float _argc = 1.0, Form _sender)
	Debug.Trace("[_sdras_player] Receiving 'free spriggan slave' event") 

	If ( _SD_spriggan.IsRunning() )
		Debug.Trace("[_sdras_player] Stopping Spriggan quest")
		_SD_spriggan.setstage(90)
	endif

	Wait( fRFSU * 5.0 )
EndEvent

Event OnSDEnslaveMenu(String _eventName, String _args, Float _argc = 1.0, Form _sender)
 	Actor kActor = _sender as Actor
	Actor kTempAggressor = StorageUtil.GetFormValue( kPlayer, "_SD_TempAggressor") as Actor
 
	if (kActor != None)
		; StorageUtil _SD_TempAggressor is deprecated
		; Use _sender through kActor.SendModEvent("") in priority instead 
		kTempAggressor = kActor
	EndIf

	Debug.Trace("[_sdras_player] Receiving enslavement menu story event [" + _args  + "] [" + _argc as Int + "]")

	If (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved") == 1)
		kTempAggressor = _SD_Enslaved.GetMaster() as Actor
	EndIf
	If (kTempAggressor != None)
		StorageUtil.SetFormValue(kPlayer, "_SD_TempAggressor", None)
	Endif

	; New enslavement - changing ownership
	int AttackerStamina = kTempAggressor.GetActorValue("stamina") as int
	int VictimStamina = kPlayer.GetActorValue("stamina") as int

	Int IButton = _SD_enslaveMenu.Show()

	If IButton == 0 ; Enslaved
		StorageUtil.SetIntValue( kPlayer , "_SD_iSub", StorageUtil.GetIntValue( kPlayer, "_SD_iSub") + 2)
		; kTempAggressor.SendModEvent("PCSubEnslave")

		SDSurrender(kTempAggressor, "" )
	ElseIf IButton == 1 ; Sex
		StorageUtil.SetIntValue( kPlayer , "_SD_iSub", StorageUtil.GetIntValue( kPlayer, "_SD_iSub") + 1)
		funct.SanguineRape( kTempAggressor, kPlayer)

	else
		StorageUtil.SetIntValue( kPlayer , "_SD_iDom", StorageUtil.GetIntValue( kPlayer, "_SD_iDom") + 1)
		If IButton == 2 ; Resist
			if AttackerStamina > VictimStamina
				AttackerStamina = VictimStamina
				Debug.MessageBox("You try to resist with all your strength, but at the end the aggressor overwhelm you...")
				SDSurrender(kTempAggressor, "" )
			endIf
		EndIf
		kTempAggressor.DamageActorValue("stamina",AttackerStamina) 
		kPlayer.DamageActorValue("stamina",AttackerStamina)

	EndIf
EndEvent

Event OnSDSurrender(String _eventName, String _args, Float _argc = 1.0, Form _sender)
	SDSurrender(_sender as Actor, _args )
EndEvent

Event OnSDSubmit(String _eventName, String _args, Float _argc = 1.0, Form _sender)
	fctOutfit.initSlaveryGearByActor ( _sender as Actor )
	SDSurrender(_sender as Actor, _args )
EndEvent

Function SDSurrender(Actor kActor, String SurrenderMode)
 	; Actor kActor = _sender as Actor
	Actor kNewMaster = StorageUtil.GetFormValue( kPlayer , "_SD_TempAggressor") as Actor
	Actor kCurrentMaster

	if (kActor != None)
		; StorageUtil _SD_TempAggressor is deprecated
		; Use _sender through kActor.SendModEvent("") in priority instead 
		kNewMaster = kActor
	EndIf
		
	Debug.Trace("[_sdras_player] Receiving 'surrender' event - New master: " + kNewMaster)

	; If (kNewMaster)
		; Debug.Trace("[_sdras_player] Faction check: " + fctFactions.checkIfSlaver (  kNewMaster ) )
	; EndIf

	If (kNewMaster != None)  && (StorageUtil.GetIntValue(kPlayer, "_SD_iChanceSprigganInfection")>0) &&  (fctFactions.checkIfSpriggan (  kNewMaster ) )
		; if already enslaved, transfer of ownership
		SendModEvent("da_PacifyNearbyEnemies")
		StorageUtil.SetFormValue(kPlayer, "_SD_TempAggressor", None)

		_SDKP_spriggan.SendStoryEvent(akRef1 = kNewMaster as ObjectReference, akRef2 = kPlayer, aiValue1 = 0, aiValue2 = 0)
 

	ElseIf (kNewMaster != None) && (StorageUtil.GetIntValue(kPlayer, "_SD_iChanceEnslavement")>0) &&  (fctFactions.checkIfSlaver (  kNewMaster ) || fctFactions.checkIfSlaverCreature (  kNewMaster ) )
		; if already enslaved, transfer of ownership
		SendModEvent("da_PacifyNearbyEnemies")

		If (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved") == 1)
			kCurrentMaster = StorageUtil.GetFormValue(kPlayer, "_SD_CurrentOwner") as Actor

			If (!kCurrentMaster.IsDead()) && (kPlayer.GetDistance( kCurrentMaster ) <= ( StorageUtil.GetIntValue(kPlayer, "_SD_iLeashLength") * 2) ) && ( StorageUtil.GetIntValue(kPlayer, "_SD_iSold") != 1 )
				kCurrentMaster.SetRelationshipRank( kPlayer, StorageUtil.GetIntValue(kCurrentMaster, "_SD_iOriginalRelationshipRank") )
				If (Utility.RandomInt(0,100) >= 0) || ( StorageUtil.GetIntValue(kCurrentMaster, "_SD_iDisposition") > 0)
					Debug.Notification("Your previous owner fights back.")
					kCurrentMaster.StartCombat(kNewMaster)
				Else
					Debug.Notification("Your former owner leaves, disgusted.")
				EndIf
			EndIf

			StorageUtil.SetIntValue(kPlayer, "_SD_iSlaveTransfer",1)
			; _SDQP_enslavement.Stop()

			; While ( _SDQP_enslavement.IsStopping() )
			; EndWhile

			; Utility.wait(1.0)

		EndIf

		; new master

		StorageUtil.SetFormValue(kPlayer, "_SD_TempAggressor", None)

		If (SurrenderMode == "Consensual")
			StorageUtil.SetIntValue(kNewMaster, "_SD_iForcedSlavery", 0) 
			kNewMaster.SendModEvent("PCSubSubmit")
			Debug.MessageBox(" You submit to a new owner.\n [Give the game a few seconds to start the enslavement sequence. If it takes too long, open the console and wait for the sequence to start.]")
		else
			Debug.MessageBox(" You have been defeated and taken as a slave.\n [Give the game a few seconds to start the enslavement sequence. If it takes too long, open the console and wait for the sequence to start.]")
		EndIf

		; New enslavement - changing ownership
		If (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved") == 1)
			_SD_Enslaved.TransferSlave(kCurrentMaster, kNewMaster, kPlayer)
		else
			_SDKP_enslave.SendStoryEvent(akRef1 = kNewMaster, akRef2 = kPlayer, aiValue1 = 0, aiValue2 = 1)
 		endif

	ElseIf (kNewMaster != None)
		; kNewMaster.SendModEvent("PCSubSex")
		funct.SanguineRape( kNewMaster, kPlayer)
	Else
		Debug.Trace("[_sdras_player] Attempted enslavement to empty master " )
	EndIf
EndFunction

Event OnSDEnslaveRadius(String _eventName, String _args = "200.0", Float _argc = 1.0, Form _sender)
	float fRadius = _args as Float
	Actor kPotentialMaster
	Actor kIgnoreActor = _sender as Actor
	Int iAttempts = 0
	Bool bMasterFound = false

	While ((iAttempts<5) || (!bMasterFound))
		fRadius = fRadius + (iAttempts * 50.0)
		kPotentialMaster = SexLab.FindAvailableActor(kPlayer, fRadius)  
		if ( ( ((kIgnoreActor!=None) && (kPotentialMaster!=kIgnoreActor)) || (kIgnoreActor==None)) && (kPotentialMaster!=None))
			bMasterFound = True
		Else
			Debug.Trace("[_sdras_player] No potential master found around player - Radius:" + fRadius)
		Endif

		iAttempts = iAttempts + 1
	Endwhile

	if (bMasterFound)
		SDSurrender(kPotentialMaster, _args )
	else
		Debug.Trace("[_sdras_player] No potential master found around player" )
		SDFree()
	endif
EndEvent

Event OnSDEnslave(String _eventName, String _args, Float _argc = 1.0, Form _sender)
	SDSurrender(_sender as Actor, _args )
EndEvent


Event OnSDTransfer(String _eventName, String _args, Float _argc = 1.0, Form _sender)
	SDSurrender(_sender as Actor, _args )
EndEvent

Event OnSDFree(String _eventName, String _args, Float _argc = 1.0, Form _sender)
	Debug.Trace("[_sdras_player] Receiving 'free slave' event")
	; _SDSP_freedom.RemoteCast( kPlayer, kPlayer, kPlayer )

	SDFree()
EndEvent

Function SDFree()
	If (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved") == 1)
		Debug.Trace("[_sdras_player] Receiving 'slavery end (free)' event")
		_SDQP_enslavement.Stop()
		If ( _SDQP_thugs.IsRunning() )
			Debug.Trace("[_sdras_player] Stopping Thugs quest")
			_SDQP_thugs.setstage(50)
			; _SDQP_thugs.Stop()
 		endif

		Wait( fRFSU * 5.0 )
	Endif
EndFunction



Event OnSDStatusUpdate(String _eventName, String _args, Float _argc = 1.0, Form _sender)
	Actor kActor
 
	Debug.Trace("[_sdras_player] Receiving 'slavery status update' event")

	If (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved") == 1)
		kActor = _SD_Enslaved.GetMaster() as Actor
		fctSlavery.UpdateStatusDaily( kActor, kPlayer, true)

		if (_args == "UpdateSlaveState")
			_SD_Enslaved.UpdateSlaveState( kActor, kPlayer)
		EndIf
		
		fctSlavery.DisplaySlaveryLevelObjective( kActor, kPlayer, _SDQP_enslavement )

	EndIf

EndEvent


Event OnSDMasterGold(String _eventName, String _args, Float _argc = 1.0, Form _sender)
	Actor kActor
 
	Debug.Trace("[_sdras_player] Receiving 'player gives gold to master' event")

	If (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved") == 1)
		kActor = _SD_Enslaved.GetMaster() as Actor
		fctInventory.ProcessGoldAdded( kActor, kPlayer)

	EndIf

EndEvent

Event OnSDDreamworldStart(String _eventName, String _args, Float _argc = 0.0, Form _sender)
	int blessingsStart = _argc as Int
	; Dreamworld has to be visited at least once for this event to work
	Debug.Trace("[_sdras_player] Receiving dreamworld start story event [" + _args  + "] [" + _argc as Int + "]")
 
	If (blessingsStart<0)
		blessingsStart = 0
	EndIf

	_SDGVP_sanguine_blessing.SetValue(blessingsStart)
	StorageUtil.SetIntValue(kPlayer, "_SD_iSanguineBlessings", _SDGVP_sanguine_blessings.GetValue() as Int )

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

	If (_SD_dreamQuest.GetStageDone(10))
		If (_SDGVP_sanguine_blessing.GetValue() > 0) 
			_SD_dreamQuest.SetStage(stageID)
		EndIf
	Else
		_SD_dreamerScript.startDreamworld()
	Endif

EndEvent


Event OnSDDreamworldSuspend(String _eventName, String _args, Float _argc = 15.0, Form _sender)
	Debug.Trace("[_sdras_player] Receiving dreamworld suspend story event [" + _args  + "] [" + _argc as Int + "]")
	StorageUtil.SetIntValue(kPlayer, "_SD_iDisableDreamworld", 1)
EndEvent

Event OnSDDreamworldResume(String _eventName, String _args, Float _argc = 15.0, Form _sender)
	Debug.Trace("[_sdras_player] Receiving dreamworld resume story event [" + _args  + "] [" + _argc as Int + "]")
	StorageUtil.SetIntValue(kPlayer, "_SD_iDisableDreamworld", 0)
EndEvent

Event OnSDModSanguineBlessing(String _eventName, String _args, Float _argc = -1.0, Form _sender)
 	Actor kActor = _sender as Actor
	Int iEventCode = _argc as Int
	String iEventString = _args

	Debug.Trace("[_sdras_player] Receiving sanguine blessing mod story event [" + _args  + "] [" + _argc as Int + "]")
	if (iEventCode<=0)
		iEventCode=1
	endIf

		_SDGVP_sanguine_blessings.SetValue( _SDGVP_sanguine_blessings.GetValue() + iEventCode)
		StorageUtil.SetIntValue(kPlayer, "_SD_iSanguineBlessings", _SDGVP_sanguine_blessings.GetValue() as Int )
	; endif

	; if ((_SDGVP_sanguine_blessings.GetValue() >= 2 ) && (StorageUtil.GetIntValue(none, "_SLS_iStoriesPlayerAlicia")==0))
	;	SendModEvent("_SLS_PlayerAlicia")
	; endif

	debugTrace(" 	- Sanguine blessings: " + _SDGVP_sanguine_blessings.GetValue() )
EndEvent

Event OnSDModMasterTrust(String _eventName = "", String _args, Float _argc = -1.0, Form _sender)
 	Actor kActor = _sender as Actor
	Int iEventCode = _argc as Int
	String iEventString = _args
	Int iTrust

	Debug.Trace("[_sdras_player] Receiving master trust mod story event [" + _args  + "] [" + _argc as Int + "]")

	If (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved") == 1)
		kActor = _SD_Enslaved.GetMaster() as Actor
		iTrust = StorageUtil.GetIntValue(kActor, "_SD_iTrust")

		; iEventString = Recover, means mod changes only while master doesnt trust player (trust < 0)

		If (((iTrust<0) && (iEventString == "Recover")) || (iEventString == ""))
			fctSlavery.ModMasterTrust(kActor, iEventCode) 
		Endif
	EndIf
EndEvent

Event OnSDPickNextTask(String _eventName = "", String _args ="", Float _argc = 1.0, Form _sender)
 	Actor kActor = _sender as Actor
	Int iEventAmount = _argc as Int
	String iEventString = _args

	Debug.Trace("[_sdras_player] Receiving pick slavery task mod story event [" + _args  + "] [" + _argc as Int + "]")

	If (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved") == 1)
		If (iEventString=="") ; no task provided, pick at random
			fctSlavery.EvaluateSlaveryTaskList(kPlayer) ; First evaluate current task in case it can be completed 
		Else
			fctSlavery.PickSlaveryTask( kPlayer,  iEventString )
		endif

	EndIf 
EndEvent

Event OnSDModTaskAmount(String _eventName = "", String _args ="", Float _argc = 1.0, Form _sender)
 	Actor kActor = _sender as Actor
	Int iEventAmount = _argc as Int
	String iEventString = _args

	Debug.Trace("[_sdras_player] Receiving slavery task mod story event [" + _args  + "] [" + _argc as Int + "]")

	; Event strings:

	; Bring food
	; Bring gold
	; Bring armor
	; Bring weapon
	; Bring ingredient
	; Bring firewood
	; Bring book
	; Dance
	; Solo
	; Sex
	; Inspection
	; Training anal
	; Training vaginal
	; Training oral
	; Training posture
	; Wash
	; Ignore   

	If (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved") == 1)
		fctSlavery.ModSlaveryTask(kPlayer, iEventString, iEventAmount)
	EndIf
EndEvent

Event OnSDEndGame(String _eventName = "", String _args ="", Float _argc = 1.0, Form _sender)
 	Actor kActor = _sender as Actor
	Int iEventAmount = _argc as Int
	String iEventString = _args

	Debug.Trace("[_sdras_player] Receiving EndGame mod story event [" + _args  + "] [" + _argc as Int + "]")

 
	If (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved") == 1)
		SDFree()
	EndIf
	
	Bool bMariaEden = False
	Bool bWolfClub = False
	Bool bSimpleSlavery = False
	Bool bRedWave = False

	If (Utility.RandomInt(0,100) > 90) 
        ; Game.FadeOutGame(true, true, 0.5, 5)
		; (kSlave as ObjectReference).MoveTo( kSlaverDest )
		; Replace by code to dreamDestination


		If (Utility.RandomInt(0,100) > 70) 
			bWolfClub = funct.WolfClubEnslave() 
			
		ElseIf (Utility.RandomInt(0,100) > 50) 
			bSimpleSlavery = funct.SimpleSlaveryEnslave() 

		Else 
			bRedWave = funct.RedWaveEnslave()
		EndIf
	Endif 
		
	If (!bWolfClub) && (!bSimpleSlavery) && (!bRedWave)
        Game.FadeOutGame(true, true, 0.5, 5)

		funct.sendPlayerToSafety(kPlayer) 

		Game.FadeOutGame(false, true, 2.0, 20)

		Utility.Wait( 1.0 )

	Endif
 
EndEvent

Event OnSDStorySex(String _eventName, String _args, Float _argc = 0.0, Form _sender)
 	Actor kActor = _sender as Actor
	Actor kTempAggressor = StorageUtil.GetFormValue( kPlayer, "_SD_TempAggressor") as Actor
	Actor kMaster = None
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
		kMaster = _SD_Enslaved.GetMaster() as Actor
		kTempAggressor = kMaster
	Else
		Return
	EndIf

	fctOutfit.setMasterGearByRace ( kTempAggressor, kPlayer  )

	if (fctOutfit.isWristRestraintEquipped( kPlayer )) && (Utility.RandomInt(0,100) > 30)
		fctOutfit.clearDeviceByString ( "WristRestraints" )
		StorageUtil.SetIntValue(kPlayer, "_SD_iHandsFreeSex", 1)
	EndIf
 
	if  (_args == "Gangbang")
		fctSlavery.ModSlaveryTask( kPlayer, "Sex", 2)
		funct.SanguineGangRape( kTempAggressor, kPlayer, False, False)

	Elseif (_args == "Soloshow")
		fctSlavery.ModSlaveryTask( kPlayer, "Solo", 1)

		funct.SanguineGangRape( kTempAggressor, kPlayer, False, True)
	Else 
		; Debug.Trace("[_sdras_player] Sending sex story")
		fctSlavery.ModSlaveryTask( kPlayer, "Sex", 1)

		if  (_args == "") 
			_args = "Aggressive"
		endif

		; _SDKP_sex.SendStoryEvent(akRef1 = kTempAggressor, akRef2 = kPlayer, aiValue1 = 0, aiValue2 = 0 )
		if (_argc==0.0)
			funct.SanguineRape( kTempAggressor, kPlayer, _args)
		else
			funct.SanguineRapeMenu( kTempAggressor, kPlayer, _args)
		endIf

	EndIf
EndEvent

Event OnSDStoryEntertain(String _eventName, String _args, Float _argc = 1.0, Form _sender)
 	Actor kActor = _sender as Actor
	Actor kTempAggressor = StorageUtil.GetFormValue( kPlayer, "_SD_TempAggressor") as Actor
	Actor kMaster = None
	; int storyID = _argc as Int

	if (kActor != None)
		; StorageUtil _SD_TempAggressor is deprecated
		; Use _sender through kActor.SendModEvent("") in priority instead 
		kTempAggressor = kActor
	EndIf

	; Debug.Notification("[_sdras_player] Receiving dance story event [" + _args  + "] [" + _argc as Int + "]")
	Debug.Trace("[_sdras_player] Receiving dance story event [" + _args  + "] [" + _argc as Int + "]")

	If (kTempAggressor != None)
		StorageUtil.SetFormValue(kPlayer, "_SD_TempAggressor", None)
	ElseIf (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved") == 1)
		kMaster = _SD_Enslaved.GetMaster() as Actor
		kTempAggressor = kMaster
	Else
		Return
	EndIf

	fctOutfit.setMasterGearByRace ( kTempAggressor, kPlayer  )

	if (fctOutfit.isWristRestraintEquipped( kPlayer )) && (Utility.RandomInt(0,100) > 30)
		fctOutfit.ClearSinglePunishmentDevice(kPlayer , "WristRestraints" )
		StorageUtil.SetIntValue(kPlayer, "_SD_iHandsFreeSex", 1)
	EndIf

	if  (_args == "Gangbang")
		; Debug.Notification("[_sdras_player] Receiving Gangbang")
		fctSlavery.ModSlaveryTask( kPlayer, "Sex", 2)
		funct.SanguineGangRape( kTempAggressor, kPlayer, True, False)

	Elseif (_args == "Soloshow")
		; Debug.Notification("[_sdras_player] Receiving Show")

		fctSlavery.ModSlaveryTask( kPlayer, "Sex", 2)
		fctSlavery.ModSlaveryTask( kPlayer, "Solo", 1)
		funct.SanguineGangRape( kTempAggressor, kPlayer, True, True)
	Else 
		; Dance
		fctSlavery.ModSlaveryTask( kPlayer, "Dance", 2)
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

	If (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved") == 1)
		kTempAggressor = _SD_Enslaved.GetMaster() as Actor
	EndIf
	If (kTempAggressor != None)
		StorageUtil.SetFormValue(kPlayer, "_SD_TempAggressor", None)
	Endif

	funct.SanguineWhip( kTempAggressor )
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

	If (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved") == 1)
		kTempAggressor = _SD_Enslaved.GetMaster() as Actor
	EndIf
	If (kTempAggressor != None)
		StorageUtil.SetFormValue(kPlayer, "_SD_TempAggressor", None)
	Endif

	funct.SanguinePunishment( kTempAggressor )
EndEvent

Event OnSDEmancipateSlave(String _eventName, String _args, Float _argc = 1.0, Form _sender)
	Debug.Trace("[_sdras_player] Receiving emancipate slave event [" + _args  + "] [" + _argc as Int + "]")

	_SDGVP_can_join.SetValue(1) 
EndEvent

Event OnSDHandsFreeSlave(String _eventName, String _args, Float _argc = 1.0, Form _sender)
	Debug.Trace("[_sdras_player] Receiving hands free slave event [" + _args  + "] [" + _argc as Int + "]")
	SetHandsFreeSlave(kPlayer)
EndEvent

Event OnSDHandsBoundSlave(String _eventName, String _args, Float _argc = 1.0, Form _sender)
	Debug.Trace("[_sdras_player] Receiving hands bound slave event [" + _args  + "] [" + _argc as Int + "]")

	; If player is enslaved, use player outfit, else, use generic device
	If (StorageUtil.GetIntValue(kPlayer, "_SD_iSlaveryBindingsOn")==1) && (StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance") != "Crawling")
		If (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved") == 1) 
			Actor kTempAggressor = _SD_Enslaved.GetMaster() as Actor
			fctOutfit.setMasterGearByRace ( kTempAggressor, kPlayer  )
		endIf

		fctOutfit.equipDeviceByString ( "Armbinder" )

		StorageUtil.GetIntValue(kPlayer, "_SD_iHandsFree", 0)
		Debug.Notification("Your owner binds your hands.")
	endif
EndEvent

Event OnSDPunishSlave(String _eventName, String _args, Float _argc = 1.0, Form _sender)
	Debug.Trace("[_sdras_player] Receiving punish slave event [" + _args  + "] [" + _argc as Int + "]")
	String sDevice = _args
 	Actor kActor = _sender as Actor
	String sTags = ""
	Int iTagsIndex 

	; Split _args between Device and Tags (separated by ':')
	iTagsIndex = StringUtil.Find(_args, ":")
	if (iTagsIndex==-1)
	 	sDevice = _args
		sTags = ""
	else
		sDevice = StringUtil.Substring(_args, 0, iTagsIndex )
		sTags = StringUtil.Substring(_args, iTagsIndex +1 )
	endIf

	If (kActor == kPlayer) || (kActor == none)
		If (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved") == 1) && 	(StorageUtil.GetIntValue(kPlayer, "_SD_iSlaveryPunishmentOn") == 1)
			Actor kTempAggressor = _SD_Enslaved.GetMaster() as Actor
			fctOutfit.setMasterGearByRace ( kTempAggressor, kPlayer  )
			_SD_Enslaved.PunishSlave(kTempAggressor, kPlayer, sDevice )
		Else
			Return
		EndIf
	Elseif (kActor != none)
		fctOutfit.EquipDeviceNPCByString(kActor,sDevice,sTags )
	Endif

EndEvent

Event OnSDRewardSlave(String _eventName, String _args, Float _argc = 1.0, Form _sender)
	Debug.Trace("[_sdras_player] Receiving reward slave event [" + _args  + "] [" + _argc as Int + "]")
	String sDevice = _args
 	Actor kActor = _sender as Actor
	String sTags = ""
	Int iTagsIndex 

	; Split _args between Device and Tags (separated by ':')
	iTagsIndex = StringUtil.Find(_args, ":")
	if (iTagsIndex==-1)
	 	sDevice = _args
		sTags = ""
	else
		sDevice = StringUtil.Substring(_args, 0, iTagsIndex )
		sTags = StringUtil.Substring(_args, iTagsIndex +1 )
	endIf

	If (kActor == kPlayer) || (kActor == none)
		If (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved") == 1) && (StorageUtil.GetIntValue(kPlayer, "_SD_iSlaveryPunishmentOn") == 1)
			Actor kTempAggressor = _SD_Enslaved.GetMaster() as Actor
			fctOutfit.setMasterGearByRace ( kTempAggressor, kPlayer  )
			; _SD_Enslaved.RewardSlave(kTempAggressor, kPlayer, sDevice )
			fctOutfit.ClearSlavePunishment(kPlayer, sDevice, true)
		Else
			Return
		EndIf
	Elseif (kActor != none)
		fctOutfit.ClearDeviceNPCByString(kActor,sDevice,sTags )
	EndIf
EndEvent

Event OnSDEquipDevice(String _eventName, String _args, Float _argc = -1.0, Form _sender)
 	Actor kActor = _sender as Actor
	Int iOutfitID = _argc as Int
	String sDevice = _args
	String sTags = ""
	Int iTagsIndex 

	; Example:  forcing a gag on akSpeaker using additional tags
	; akSpeaker.SendModEvent("SDEquipDevice", "Gag|harness,panel") 

	Debug.Trace("[_sdras_player] Receiving device equip story event [" + _args  + "] [" + _argc as Int + "] [" + _argc + "]")

	; Split _args between Device and Tags (separated by '|')
	iTagsIndex = StringUtil.Find(_args, "|")
	if (iTagsIndex==-1)
	 	sDevice = _args
		sTags = ""
	else
		sDevice = StringUtil.Substring(_args, 0, iTagsIndex )
		sTags = StringUtil.Substring(_args, iTagsIndex +1 )
	endIf


	If (kActor == kPlayer)
		Debug.Trace("[_sdras_player] 	sDevice = "+ sDevice +" - sTags = " + sTags )

		if (iOutfitID == 1) ; Sanguine outfit - ignore tags
			fctOutfit.equipNonGenericDeviceByString ( sDeviceString = sDevice, sOutfitString = "Sanguine"  )
		else
			fctOutfit.setMasterGearByRace ( kActor, kPlayer  )
			fctOutfit.equipDeviceByString ( sDeviceString = sDevice, sDeviceTags = sTags )
		endif
	else
		if (iOutfitID == 1) ; Sanguine outfit - ignore tags
			fctOutfit.equipNonGenericDeviceNPCByString ( kActor, sDeviceString = sDevice, sOutfitString = "Sanguine"  )
		else
			fctOutfit.equipDeviceNPCByString (kActor, sDeviceString = sDevice, sDeviceTags = sTags )
		endif
	endIf

EndEvent

Event OnSDClearDevice(String _eventName, String _args, Float _argc = -1.0, Form _sender)
 	Actor kActor = _sender as Actor
	Int iOutfitID = _argc as Int
	String sDevice = _args 

	Debug.Trace("[_sdras_player] Receiving device clear story event [" + _args  + "] [" + _argc as Int + "]")

	If (kActor == kPlayer)

		if (iOutfitID == 1) ; Sanguine outfit - ignore tags
			fctOutfit.clearNonGenericDeviceByString ( sDeviceString = sDevice, sOutfitString = "Sanguine"  )
		else
			fctOutfit.setMasterGearByRace ( kActor, kPlayer  )
			fctOutfit.clearDeviceByString ( sDeviceString = sDevice )
		endif
	Else
		if (iOutfitID == 1) ; Sanguine outfit - ignore tags
			fctOutfit.clearNonGenericDeviceNPCByString ( kActor, sDeviceString = sDevice, sOutfitString = "Sanguine"  )
		else
			fctOutfit.clearDeviceNPCByString (kActor, sDeviceString = sDevice )
		endif
	Endif


EndEvent

Event OnSDEquipSlaveRags(String _eventName, String _args, Float _argc = -1.0, Form _sender)
 	Actor kActor = _sender as Actor
	String sDevice = _args

	Debug.Trace("[_sdras_player] Receiving slave rags story event [" + _args  + "] [" + _argc as Int + "]")

	; Example: akSpeaker forcing a gag on player using OutfitID = 1 [between 0 and 10] 
	; akSpeaker.SendModEvent("SDEquipDevice", "Gag", 1) 

	if (kActor == None)
		; StorageUtil _SD_TempAggressor is deprecated
		; Use _sender through kActor.SendModEvent("") in priority instead 
		kActor = kPlayer
	EndIf

	Debug.Trace("[_sdras_player] Receiving slave rags equip story event [" + _args  + "] [" + _argc as Int + "]")

	; _SD_Enslaved.EquipSlaveRags(kActor)
	fctOutfit.EquipSlaveRags(kActor)
 
EndEvent


Event OnSDStance(String _eventName, String _args, Float _argc = -1.0, Form _sender)
 	Actor kActor = _sender as Actor
	Int iEventCode = _argc as Int
	String iEventString = _args

	Debug.Trace("[_sdras_player] Receiving change stance story event [" + _args  + "] [" + _argc as Int + "]")


	if (iEventString == "Standing") || (iEventString == "Kneeling") || (iEventString == "Crawling")
		StorageUtil.SetStringValue( kPlayer, "_SD_sDefaultStance", iEventString)
	endIf

	; if (iEventString == "Standing")
	;	StorageUtil.SetIntValue( kPlayer, "_SD_iEnableStand", 1 )
	;	StorageUtil.SetIntValue( kPlayer, "_SD_iEnableKneel", 1 )
	;	StorageUtil.SetIntValue( kPlayer, "_SD_iEnableCrawl", 1 )

	;elseif (iEventString == "Kneeling")
	;	StorageUtil.SetIntValue( kPlayer, "_SD_iEnableStand", 0 )
	;	StorageUtil.SetIntValue( kPlayer, "_SD_iEnableKneel", 1 )
	;	StorageUtil.SetIntValue( kPlayer, "_SD_iEnableCrawl", 1 )

	;elseif (iEventString == "Crawling")
	;	StorageUtil.SetIntValue( kPlayer, "_SD_iEnableStand", 0 )
	;	StorageUtil.SetIntValue( kPlayer, "_SD_iEnableKneel", 0 )
	;	StorageUtil.SetIntValue( kPlayer, "_SD_iEnableCrawl", 1 )
	;endif

EndEvent
 
Event OnSDTrustAction(String _eventName, String _args, Float _argc = -1.0, Form _sender)
 	Actor kActor = _sender as Actor
	Int iEventCode = _argc as Int
	String iEventString = _args

	Debug.Trace("[_sdras_player] Receiving slave trust action story event [" + _args  + "] [" + _argc as Int + "]")

	StorageUtil.SetIntValue( kPlayer  , "_SD_iHandsFree", 1)
	StorageUtil.SetIntValue( kPlayer  , "_SD_iEnableAction", 1)
	StorageUtil.SetStringValue( kPlayer , "_SD_sDefaultStance", "Standing")
	StorageUtil.SetIntValue( kPlayer , "_SD_iEnableStand", 1 )

	SetHandsFreeSlave(kPlayer)
EndEvent
 
Event OnSDTrustFight(String _eventName, String _args, Float _argc = -1.0, Form _sender)
 	Actor kActor = _sender as Actor
	Int iEventCode = _argc as Int
	String iEventString = _args

	Debug.Trace("[_sdras_player] Receiving slave trust fight story event [" + _args  + "] [" + _argc as Int + "]")

 
	StorageUtil.SetIntValue( kPlayer  , "_SD_iHandsFree", 1)
	StorageUtil.SetIntValue( kPlayer  , "_SD_iEnableAction", 1)

	StorageUtil.SetIntValue( kPlayer , "_SD_iEnableWeaponEquip", 1)
	StorageUtil.SetIntValue( kPlayer  , "_SD_iEnableArmorEquip", 1)
	StorageUtil.SetIntValue( kPlayer  , "_SD_iEnableFight", 1)
	StorageUtil.SetStringValue( kPlayer , "_SD_sDefaultStance", "Standing")
	StorageUtil.SetIntValue( kPlayer , "_SD_iEnableStand", 1 )

	SetHandsFreeSlave(kPlayer)
EndEvent
 
Event OnSDClearSanguineDevices(String _eventName, String _args, Float _argc = -1.0, Form _sender)
 	Actor kActor = _sender as Actor
	Int iEventCode = _argc as Int
	String iEventString = _args

	Debug.Trace("[_sdras_player] Receiving Clear Sanguine Devices story event [" + _args  + "] [" + _argc as Int + "]")
 

	If (fctOutfit.countDeviousSlotsByKeyword (  kPlayer, "_SD_DeviousSanguine" )>0) 
			Debug.Trace("[_sdras_player]  Clean up sanguine devices ")
		_SDSP_SanguineBoundClear.RemoteCast( kPlayer, kPlayer, kPlayer )
	Else
			Debug.Trace("[_sdras_player]   No sanguine devices found")
	EndIf
EndEvent

Event OnSDUnleash(String _eventName, String _args, Float _argc = -1.0, Form _sender)
 	Actor kActor = _sender as Actor
	Int iEventCode = _argc as Int
	String iEventString = _args

	Debug.Trace("[_sdras_player] Receiving unleash slave story event [" + _args  + "] [" + _argc as Int + "]")
 

	StorageUtil.SetFormValue( kPlayer, "_SD_LeashCenter", kActor)
	StorageUtil.SetIntValue( kPlayer, "_SD_iEnableLeash", 0)
	; StorageUtil.SetIntValue(kActor,"_SD_iFollowSlave",0)
EndEvent
 
Event OnSDLeash(String _eventName, String _args, Float _argc = -1.0, Form _sender)
 	Actor kActor = _sender as Actor
	Int iEventCode = _argc as Int
	String iEventString = _args

	Debug.Trace("[_sdras_player] Receiving leash slave story event [" + _args  + "] [" + _argc as Int + "]")
 
 
	StorageUtil.SetFormValue( kPlayer, "_SD_LeashCenter", kActor)
	StorageUtil.SetIntValue( kPlayer, "_SD_iEnableLeash", 1)
	; StorageUtil.SetIntValue(kActor,"_SD_iFollowSlave",0)
EndEvent
 
Event OnSDMasterFollow(String _eventName, String _args, Float _argc = -1.0, Form _sender)
 	Actor kActor = _sender as Actor
	Int iEventCode = _argc as Int
	String iEventString = _args

	Debug.Trace("[_sdras_player] Receiving master follow story event [" + _args  + "] [" + _argc as Int + "]")
 
	Debug.Notification("Your owner starts following you around.")

	StorageUtil.SetFormValue( kPlayer, "_SD_LeashCenter", kActor)
	StorageUtil.SetIntValue( kPlayer, "_SD_iEnableLeash", 0)
	StorageUtil.SetIntValue(kActor,"_SD_iFollowSlave",1)
EndEvent
 
Event OnSDMasterTravel(String _eventName, String _args, Float _argc = -1.0, Form _sender)
 	Actor kActor = _sender as Actor
	Int iEventCode = _argc as Int
	String iEventString = _args

	Debug.Trace("[_sdras_player] Receiving master travel story event [" + _args  + "] [" + _argc as Int + "]")
 
 	if (iEventString == "Start") ||  (iEventString == "Resume")
		If ( _SDGVP_state_isMasterInTransit.GetValue() == 0 )
			Debug.Messagebox("Your owner is going on a walk. Don't stray too far or you will be punished!")
		EndIf

		StorageUtil.SetIntValue( kPlayer ,"_SD_iEnableLeash", 1)
		StorageUtil.SetIntValue( kActor,"_SD_iFollowSlave", 0)
		_SDGVP_state_isMasterFollower.SetValue(0) 

		if (iEventString == "Start")
			_SDGVP_state_isMasterTraveller.SetValue(1) 
			_SDGVP_isLeashON.SetValue(1)
			_SDGVP_state_isMasterInTransit.SetValue(1)
		Endif

		kActor.EvaluatePackage()
 		_SDGVP_enable_masterTravel.SetValue(1)


		If !( _SDQP_thugs.IsRunning() )
 			Debug.Trace("[_sdras_player]  >>> Starting Thugs quest")
			_SDKP_thugs.SendStoryEvent(akRef1 = kActor as ObjectReference, akRef2 = kPlayer as ObjectReference, aiValue1 = 0)
 		else
  			Debug.Trace("[_sdras_player]  >>> Thugs quest detected - starting walking scene")
			_SDQP_thugs.setstage(10)
 		endif

 	elseif  (iEventString == "Stop") ||  (iEventString == "Disable")
 		If (_SDGVP_state_isMasterInTransit.GetValue() == 1 )
			Debug.Messagebox("Your owner is staying put for now. Don't take that as a permission to wander off!!")
		EndIf

		StorageUtil.SetIntValue( kPlayer ,"_SD_iEnableLeash", 0)
		StorageUtil.SetIntValue( kActor,"_SD_iFollowSlave", 1)
		_SDGVP_state_isMasterFollower.SetValue(1) 
		_SDGVP_state_isMasterTraveller.SetValue(0) 
		_SDGVP_isLeashON.SetValue(0)
		_SDGVP_state_isMasterInTransit.SetValue(0)
		_SD_Enslaved.ResetCage( kPlayer)


		kActor.EvaluatePackage()
 		_SDGVP_enable_masterTravel.SetValue(1)

		If !( _SDQP_thugs.IsRunning() )
 			Debug.Trace("[_sdras_player]  >>> Starting Thugs quest")
			_SDKP_thugs.SendStoryEvent(akRef1 = kActor as ObjectReference, akRef2 = kPlayer as ObjectReference, aiValue1 = 0)
 		else
  			Debug.Trace("[_sdras_player]  >>> Thugs quest detected - pausing walking scene")
			_SDQP_thugs.setstage(11)
 		endif


		if  (iEventString == "Disable")
	  		_SDGVP_enable_masterTravel.SetValue(0)
	  	endIf
 	endIf

EndEvent



; Event OnLocationChange(Location akOldLoc, Location akNewLoc)
	; kCrosshairTarget = none ; reset target

	; fctConstraints.UpdateStanceOverrides(bForceRefresh=True) 

; EndEvent

State waiting
	Event OnUpdate()
		If ( Self.GetOwningQuest().IsRunning() )
			; Debug.Trace("_SDRAS_player.OnUpdate().GoToState('monitor')")
			GoToState("monitor")
		EndIf
		If ( kPlayer && Self.GetOwningQuest() )
			RegisterForSingleUpdate( 0.1 )
		EndIf
	EndEvent
EndState

State monitor
	Event OnBeginState()
		; If ( ( kPlayer.GetBaseObject() as ActorBase ).GetSex() == 1 )
		;	kLust = _SDRAP_lust_f.GetReference() as ObjectReference
		; Else
		; 	kLust = _SDRAP_lust_m.GetReference() as ObjectReference
		; EndIf
		
		; Key mapping reference - http://www.creationkit.com/Input_Script#DXScanCodes

		keys[0] = config._SDUIP_keys[1]
		keys[1] = config._SDUIP_keys[6]
		keys[2] = config._SDUIP_keys[2]
		keys[3] = config._SDUIP_keys[5]
		RegisterForKey( keys[0] )
		RegisterForKey( keys[1] )
		RegisterForKey( keys[2] )
		RegisterForKey( keys[3] )

		; RegisterForMenu( "Crafting Menu" )
		; RegisterForAnimationEvent(kPlayer, "RemoveCharacterControllerFromWorld")
		; RegisterForAnimationEvent(kPlayer, "GetUpEnd")
	EndEvent

	Event OnPlayerLoadGame()
		keys = New Int[4]
		keys[0] = config._SDUIP_keys[1]
		keys[1] = config._SDUIP_keys[6]
		keys[2] = config._SDUIP_keys[2]
		keys[3] = config._SDUIP_keys[5]
		RegisterForKey( keys[0] )
		RegisterForKey( keys[1] )
		RegisterForKey( keys[2] )
		RegisterForKey( keys[3] )

		Debug.Trace("[_sdras_load] Calling _sd_player maintenance")
		_Maintenance()

		; Debug.Notification("[SD] Registering keys" + keys.Length)


	    ;endif 
		If ( Self.GetOwningQuest() )
			RegisterForSingleUpdate( 0.1 )
		EndIf

	EndEvent

	Event OnEndState()
		; UnregisterForMenu( "Crafting Menu" )
		UnregisterForKey( keys[0] )
		UnregisterForKey( keys[1] )
		UnregisterForKey( keys[2] )
		UnregisterForKey( keys[3] )

		; UnregisterForAnimationEvent(kPlayer, "RemoveCharacterControllerFromWorld")
		; UnregisterForAnimationEvent(kPlayer, "GetUpEnd")
	EndEvent

	Event OnUpdate()
		If ( Self.GetOwningQuest().IsStopping() || Self.GetOwningQuest().IsStopped() ) ; wait for end of enslavement sequence
			GoToState("waiting")

			; Is this really necessary?  'waiting' state already has an update loop.

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
			; iCountSinceLastCheck += 1

			; if (iCountSinceLastCheck >= 500)
				; Debug.Notification( "[SD] Player status - hourly update")
			;	iCountSinceLastCheck = 0
				
			; EndIf

		Else ; day change - full update
			; Debug.Notification( "[SD] Player status - daily update")
			iGameDateLastCheck = daysPassed
			iCountSinceLastCheck = 0

			funct.checkGender(kPlayer)

			; Cooldown of slavery exposure when released

			; StorageUtil.GetIntValue( kPlayer , "_SD_iSlaveryLevel") - 0 to 6
			; StorageUtil.GetIntValue( kPlayer, "_SD_iDominance") - -10 to 10
			; _SDGVP_config_slavery_level_mult.GetValue() - 0 to 1

			If (fctOutfit.countDeviousSlotsByKeyword (  kPlayer, "_SD_DeviousSanguine" )>0) 
	 			Debug.Trace("[_sdras_player]  Clean up sanguine devices at night")
				_SDSP_SanguineBoundClear.RemoteCast( kPlayer, kPlayer, kPlayer )
			Else
	 			Debug.Trace("[_sdras_player]  No sanguine devices found")
			EndIf

			If (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved") != 1)   
				fOldExposure = (StorageUtil.GetIntValue(kPlayer, "_SD_iSlaveryExposure") as Float)
				fExposureMultiplier = (_SDGVP_config_slavery_level_mult.GetValue() as Float) 

				; Ajusted proposed changes to cooldown and clarified intent in comments below
				; Slower cooldown at high level of enslavement
				; Slavery level = 0 - rapid cooldown (0.1 * normal rate)
				; Slavery level = 6 - inverted cooldown (1.1 * normal rate) - sextoys don't get to cooldown
				fNewExposure =  fOldExposure * fExposureMultiplier * ( ( (0.1 +  StorageUtil.GetIntValue( kPlayer , "_SD_iSlaveryLevel") ) as Float) / 6.0)			

				If ( _SDQP_thugs.IsRunning() )
		 			Debug.Trace("[_sdras_player]  Clean up thugs quest after enslavement")
					_SDQP_thugs.SetStage(50)
		 		endif

				StorageUtil.SetIntValue(kPlayer, "_SD_iSlaveryExposure",  funct.intMax(0, fNewExposure as Int ))

				StorageUtil.SetIntValue( kPlayer, "_SD_iDaysMaxJoinedFaction", _SDGVP_slave_days_max.GetValue() as Int)
				fctFactions.expireSlaveFactions( kPlayer )
				fctOutfit.expireSlaveTats( kPlayer )
				; fctFactions.displaySlaveFactions( kPlayer )
				Utility.Wait(2.0)
			else
				fctFactions.displaySlaveFactions( kPlayer )

				; Release player if enslaved to a race that has been since removed from list of master races
				Actor kCurrentMaster = StorageUtil.GetFormValue(kPlayer, "_SD_CurrentOwner") as Actor
				; ActorBase akActorBase = kCurrentMaster.GetLeveledActorBase() as ActorBase
				; Race actorRace = akActorBase.GetRace()
				Race actorRace = kCurrentMaster.GetRace()

				; check if race is properly filled for a generic NPC
				if (StorageUtil.GetIntValue(actorRace as Form, "_SD_iSlaveryRace")==0)
		 			Debug.Trace("[_sdras_player]  Race of Master has no _SD_iSlaveryRace value: " + actorRace as Form)
					Debug.MessageBox("[You are enslaved to a master that has been removed from master races. Your enslavement was terminated.]")
					; kPlayer.SendModEvent("PCSubFree")
					SDFree()
				endif
			EndIf

			StorageUtil.SetIntValue(kPlayer, "_SD_iGenderRestrictions",  _SDGVP_config[3].GetValue() as Int )
			fctSlavery.UpdateSlaveryLevel(kPlayer) 
				
			; Debug.Notification( "[SD] Player status - slavery exposure: " + StorageUtil.GetIntValue(kPlayer, "_SD_iSlaveryExposure"))
		EndIf

		StorageUtil.SetIntValue(kPlayer, "_SD_iSanguineBlessings", _SDGVP_sanguine_blessings.GetValue() as Int )
		StorageUtil.SetIntValue(kPlayer, "_SD_iChanceEnslavement",_SDGVP_health_threshold.GetValue() as Int )
		StorageUtil.SetIntValue(kPlayer, "_SD_iChanceSprigganInfection",_SDGVP_config_healthMult.GetValue() as Int )
		StorageUtil.SetIntValue( kPlayer, "_SD_iFrostfallMortality", _SDGVP_frostfallMortality.GetValueInt( ) as Int)

		If ( keys[0] != config._SDUIP_keys[1] || keys[1] != config._SDUIP_keys[6] || keys[2] != config._SDUIP_keys[2] || keys[3] != config._SDUIP_keys[5] )
			UnregisterForKey( keys[0] )
			UnregisterForKey( keys[1] )
			UnregisterForKey( keys[2] )
			UnregisterForKey( keys[3] )
			keys[0] = config._SDUIP_keys[1]
			keys[1] = config._SDUIP_keys[6]
			keys[2] = config._SDUIP_keys[2]
			keys[3] = config._SDUIP_keys[5]
			RegisterForKey( keys[0] )
			RegisterForKey( keys[1] )
			RegisterForKey( keys[2] )
			RegisterForKey( keys[3] )
		EndIf

		; Detect change of stance and apply new idles if needed
  		if (lastStance != StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance"))
  			lastStance = StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance")

			fctConstraints.UpdateStanceOverrides()
		endIf

		; Compatibility issue - Captured Dream devices seem to block player menu after sex when SD is on.
		; Not sure why
		; Disabled for now - causing too many issues with other mods
		; If (!Game.IsMenuControlsEnabled()) && (Game.IsMovementControlsEnabled()) && !(kPlayer.IsBleedingOut())
			; If (!fctOutfit.DDIsBound( kPlayer )) && fctOutfit.ActorHasKeywordByString(kPlayer, "zad_Lockable")
			;	Debug.Trace("[_sdras_player] Locked out of menu after sex - this can happen with Captured Dream devices.. not sure why")
				; Monitor.SetPlayerControl(true)
			;	Game.EnablePlayerControls( abMenu = True )
				; fctOutfit.DDSetAnimating( kPlayer, false )
			;Endif
		;endif

		; Cap on kill state for better integration with DA (avoid immortal / frozen state)
		Bool isInKWeakenedState = funct.actorInWeakenedState( kPlayer, 15/100 )  
		Bool isInKillState = funct.actorInKillState( kPlayer, 0.5 )    

		; if (isInKillState)  
		;	Debug.Notification("You should be dead")
		; EndIf

		If (StorageUtil.GetIntValue(kPlayer, "_SD_iChanceSprigganInfection") > 0)
			If ( kPlayer.WornHasKeyword( _SDKP_spriggan_infected ) && (StorageUtil.GetIntValue(kPlayer, "_SD_iSprigganInfected") != 1) ) && (Utility.RandomInt(1,100)<= ( (StorageUtil.GetIntValue(kPlayer, "_SD_iChanceSprigganInfection") ) / 20) ) && (Utility.RandomInt(0,100)>=(StorageUtil.GetIntValue(kPlayer, "_SD_iSprigganEnslavedCount") * 50)) 
				; Chance of spriggan infection if slave is wearing a spriggan root armor item
				; Debug.Notification("[SD] Infected by spriggan roots...")
				SendModEvent("SDSprigganEnslave")
			EndIf	
		Endif		

		If ( kPlayer && Self.GetOwningQuest() )
			RegisterForSingleUpdate( 0.1 )
		EndIf
	EndEvent

	; See codes here - http://minecraft.gamepedia.com/Key_codes
	;0xC7 config._SDUIP_keys[0]  199  Home
	;0xCF config._SDUIP_keys[1]  207  End
	;0xC8 config._SDUIP_keys[2]  200   Up
	;0xCB config._SDUIP_keys[3]  203  Left Arrow
	;0xCD config._SDUIP_keys[4]  205  Right Arrow
	;0xD0 config._SDUIP_keys[5]  208   Down
	;0x25 config._SDUIP_keys[6]  49   /

	;0x2A    42  Left Shift
	;0x36    54  Right Shift
	Event OnKeyDown(Int aiKeyCode)
		Bool 	bIsWristRestraintEquipped = fctOutfit.isWristRestraintEquipped( kPlayer ) 

		shiftPress = ( Input.IsKeyPressed( 42 ) || Input.IsKeyPressed( 54 ) )
		altPress = ( Input.IsKeyPressed( 56 ) || Input.IsKeyPressed( 184 ) )

		If (UI.IsTextInputEnabled() || Utility.IsInMenuMode() )
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
 
			Bool isInKWeakenedState = funct.actorInWeakenedState( kPlayer, 25.0 /100.0 )  ; funct.actorInWeakenedState( kPlayer, _SDGVP_config[2].GetValue()/100 )
			Bool isInKillState = funct.actorInKillState( kPlayer, 0.5 )   ; funct.actorInKillState( kPlayer, _SDGVP_config[1].GetValue() )
			debugTrace(" Player in weakened state: " + isInKWeakenedState )
			debugTrace(" Player in kill state: " + isInKillState )

			if (!UI.IsMenuOpen("Console") && !UI.IsMenuOpen("InventoryMenu") && !UI.IsMenuOpen("GiftMenu") && !UI.IsMenuOpen("ContainerMenu"))

				Int IButton = _SD_safetyMenu.Show()

				Debug.Notification("You cling to your last breath...")
				; Monitor.SetBlackScreenEffect(false)
				; Monitor.SetPlayerControl(true)

				If (IButton == 0 ) 	
					debugTrace(" Surrender")
					; SendModEvent("da_PacifyNearbyEnemies", "Restore")
					GoToState("surrender")


				ElseIf (IButton == 1)
					; Pray to Sanguine

					If (!StorageUtil.HasIntValue(kPlayer, "_SD_iNumberPrayersToGods" ))
						StorageUtil.SetIntValue(kPlayer, "_SD_iNumberPrayersToGods" ,0 )
					EndIf

					; Number of prayers to gods increases chances of going to Sanguine up to 25%
					Int iNumberPrayersToGods = StorageUtil.GetIntValue(kPlayer, "_SD_iNumberPrayersToGods" )
					StorageUtil.SetIntValue(kPlayer, "_SD_iNumberPrayersToGods", iNumberPrayersToGods + 1 )

					; Monitor.GoToState("")
					; Debug.SetGodMode( True )
					; kPlayer.EndDeferredKill()

					If (Utility.RandomInt(0,100) > 70) && (_SDGVP_state_caged.GetValue() == 1) && (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved") != 1)   
						; player still enslaved and caged

						_SDGVP_state_caged.SetValue(0)
						kPlayer.AddItem(Lockpick, 5)
					
					ElseIf (StorageUtil.GetStringValue( kPlayer, "_SD_sDefaultStance") == "Kneeling")
						If (Utility.RandomInt(0,100) > 75) && (_SD_dreamQuest.GetStage() != 0) 
							; Send PC to Dreamworld

							_SD_dreamQuest.SetStage(100)

						ElseIf (Utility.RandomInt(0,100) > 50) && (!isInKWeakenedState)	
							; Send PC some help

							SendModEvent("da_StartSecondaryQuest", "Both")

						ElseIf (Utility.RandomInt(0,100) > 30) && (isInKWeakenedState)	
							; Send PC some help

							SendModEvent("da_StartSecondaryQuest", "Both")
							SendModEvent("da_StartRecoverSequence")
						Else
							Debug.Notification("Your prayer goes unanswered...")
						Endif

					ElseIf (StorageUtil.GetStringValue( kPlayer, "_SD_sDefaultStance") != "Kneeling")
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
						Else
							Debug.Notification("Your prayer goes unanswered...")
						Endif

					;ElseIf (Utility.RandomInt(0,100) > 30)	&& (isInKWeakenedState)
						; restore all hp	
						; Monitor.BufferDamageReceived(9999.0)  	

					Else
						Debug.Notification("Your prayer goes unanswered...")
					EndIf
				ElseIf IButton == 2
					; Debug

					; SendModEvent("da_UpdateBleedingDebuff")
					; SendModEvent("da_EndNearDeathDebuff")	

					Debug.SetGodMode( False )

					kPlayer.StopCombat()
					kPlayer.StopCombatAlarm()

					fctConstraints.actorCombatShutdown( kPlayer )

					fctConstraints.UpdateStanceOverrides(bForceRefresh=True) 

					; if (kPlayer.IsFlying())
					;	Debug.Notification("Player is stuck in flight. Reload your game.")
					; endif

					; UnregisterForMenu( "Crafting Menu" )
					; UnregisterForAnimationEvent(kPlayer, "RemoveCharacterControllerFromWorld")
					; UnregisterForAnimationEvent(kPlayer, "GetUpEnd")


				ElseIf (IButton == 3)
					; Ragdoll

					kPlayer.PushActorAway(kPlayer, 10.0)

					Game.SetPlayerAIDriven(false)
					Game.SetInCharGen(false, false, false)
					Game.EnablePlayerControls() ; just in case	
					; Game.EnablePlayerControls( abMovement = True )
					fctOutfit.DDSetAnimating( kPlayer, false )

					kPlayer.StopCombat()
					kPlayer.StopCombatAlarm()

					; Find a way to detect and fix situations when player is stuck 'flying' above ground

					Debug.SendAnimationEvent(kPlayer, "IdleForceDefaultState")
					SendModEvent("da_PacifyNearbyEnemies")


				ElseIf (IButton == 4)
					; Teleport

					SendModEvent("SDEndGame")

				ElseIf (IButton == 5)
					; Safeword
					Debug.MessageBox( "FPOON!: You are released from enslavement.")

					SendModEvent("PCSubFree")

				ElseIf (IButton == 6)
					; Cancel

				Else
					Debug.Notification("You still have life in you...")
				EndIf


			EndIf
 
		EndIf
		If (StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance")=="")
			StorageUtil.SetStringValue(kPlayer, "_SD_sDefaultStance", "Standing")
		EndIf
		If ( aiKeyCode == keys[2] )
			
			If (StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance") == "Crawling") ; && (StorageUtil.GetIntValue(kPlayer, "_SD_iEnableKneel") == 1 )
				; If (fctSlavery.CheckSlavePrivilege( kPlayer , "_SD_iEnableKneel") && (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved") == 1) ) || (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved") == 0)
					StorageUtil.SetStringValue(kPlayer, "_SD_sDefaultStance", "Kneeling")
					kPlayer.SendModEvent("SLDRefreshGlobals")
					Debug.Notification("Kneeling...")
				; Else
				; 	Debug.Notification("You are not allowed to kneel")
				; Endif

			elseIf (StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance") == "Kneeling")  ; && (StorageUtil.GetIntValue(kPlayer, "_SD_iEnableStand") == 1 )
				; If (fctSlavery.CheckSlavePrivilege( kPlayer , "_SD_iEnableStand") && (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved") == 1) ) || (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved") == 0)
					StorageUtil.SetStringValue(kPlayer, "_SD_sDefaultStance", "Standing")
					kPlayer.SendModEvent("SLDRefreshGlobals")
					Debug.Notification("Standing...")
				; Else
				; 	Debug.Notification("You are not allowed to stand")
				; Endif

			elseIf (StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance") == "Standing")  
				kPlayer.SendModEvent("SLDRefreshGlobals")
				Debug.Notification("Already standing...")
			Else
			 	debugTrace(" Problem with position: " + StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance"))
			 	Debug.Notification("[SD] Problem with position: " + StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance"))
			 	StorageUtil.SetStringValue(kPlayer, "_SD_sDefaultStance", "Standing")
			endif

			StorageUtil.SetStringValue(kPlayer, "_SD_sDefaultStanceFollower", StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance") ) 
			fctConstraints.UpdateStanceOverrides()
			; Debug.Notification("New stance: " + StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance"))
		endif
		If ( aiKeyCode == keys[3] )
 			If (StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance") == "Crawling")  
 				kPlayer.SendModEvent("SLDRefreshGlobals")
				Debug.Notification("Already crawling...")

			elseIf (StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance") == "Kneeling")  && (!bIsWristRestraintEquipped) ; && (StorageUtil.GetIntValue(kPlayer, "_SD_iEnableCrawl") == 1 )
				; If (fctSlavery.CheckSlavePrivilege( kPlayer , "_SD_iEnableCrawl") && (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved") == 1) ) || (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved") == 0)
					StorageUtil.SetStringValue(kPlayer, "_SD_sDefaultStance", "Crawling")
					kPlayer.SendModEvent("SLDRefreshGlobals")
					Debug.Notification("Crawling...")
				; Else
				; 	Debug.Notification("You are not allowed to crawl")
				; Endif

			elseIf (StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance") == "Standing") ; && (StorageUtil.GetIntValue(kPlayer, "_SD_iEnableKneel") == 1 )
				; If (fctSlavery.CheckSlavePrivilege( kPlayer , "_SD_iEnableKneel") && (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved") == 1) ) || (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved") == 0)
					StorageUtil.SetStringValue(kPlayer, "_SD_sDefaultStance", "Kneeling")
					kPlayer.SendModEvent("SLDRefreshGlobals")
					Debug.Notification("Kneeling...")
				; Else
				; 	Debug.Notification("You are not allowed to kneel")
				; Endif
			Else
			 	debugTrace(" Problem with position: " + StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance"))
			 	Debug.Notification("[SD] Problem with position: " + StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance"))
			 	StorageUtil.SetStringValue(kPlayer, "_SD_sDefaultStance", "Standing")

			endif

			StorageUtil.SetStringValue(kPlayer, "_SD_sDefaultStanceFollower", StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance") ) 
			fctConstraints.UpdateStanceOverrides()
			; Debug.Notification("New stance: " + StorageUtil.GetStringValue(kPlayer, "_SD_sDefaultStance"))

		endif

	EndEvent

	Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, Bool abPowerAttack, Bool abSneakAttack, Bool abBashAttack, Bool abHitBlocked)
		Actor akActor = akAggressor as Actor
		Actor PlayerRef = Game.GetPlayer()
		Bool bHitByMagic = FALSE  ; True if likely hit by Magic attack.
		Bool bHitByMelee = FALSE  ; True if likely hit by Melee attack.
		Bool bHitByRanged = FALSE ; True if likely his by Ranged attack.
		Bool bCheckForSlaver = FALSE
		 
		If (akAggressor != None) 
			IF akActor != PlayerRef && PlayerRef.IsInCombat() && akActor.IsHostileToActor(PlayerRef)
			; The above is really to rule out run of the mill physical traps.
			 
				IF ((akActor.GetEquippedItemType(0) == 8) || (akActor.GetEquippedItemType(1) == 8) \
					|| (akActor.GetEquippedItemType(0) == 9) || (akActor.GetEquippedItemType(1) == 9))  && akProjectile != None
					; bHitByMagic = TRUE

					If (Utility.RandomInt(0,100)<30) ; throttle checks for slavery way down in case of magick attack
						bCheckForSlaver = TRUE
					Endif

				ELSEIF (akActor .GetEquippedItemType(0) != 7) && akProjectile == None
					; bHitByMelee = TRUE
					bCheckForSlaver = TRUE

				ELSEIF (akActor .GetEquippedItemType(0) == 7)
					; bHitByRanged = TRUE
					bCheckForSlaver = TRUE
				ENDIF
			ENDIF

			If (bCheckForSlaver)
				if (StorageUtil.GetIntValue( akActor, "_SD_iDateSlaverChecked")==0)
					fctFactions.checkIfSlaver ( akActor )
				Endif

				if (StorageUtil.GetIntValue( akActor, "_SD_iDateBeastSlaverChecked")==0)
					fctFactions.checkIfSlaverCreature ( akActor )
				Endif
			Endif

		Endif
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
EndState

State surrender
	Event OnBeginState()
		; Key mapping reference - http://www.creationkit.com/Input_Script#DXScanCodes
		; Drop current weapon - Do this first to prevent camera stuck in combat mode
 		kCombatTarget = None
	  	kSubmitTarget = None

 		Debug.Notification("[SD] Entering surrender state")
 		debugTrace(" Entering surrender state")
 		StorageUtil.SetIntValue(kPlayer, "_SD_iSurrenderOn", 1)
 		StorageUtil.SetIntValue(kPlayer, "_SD_iSurrenderCrosshairUpdated", 0)

		if(kPlayer.IsWeaponDrawn())
			kPlayer.SheatheWeapon()
			Utility.Wait(1.0)
		endif

		keys[0] = config._SDUIP_keys[1]
		keys[1] = config._SDUIP_keys[6]
		RegisterForKey( keys[0] )
		RegisterForKey( keys[1] )

	EndEvent


	Event OnCrosshairRefChange(ObjectReference ref)
		ObjectReference PlayerREF= kPlayer
		Actor PlayerActor= PlayerREF as Actor

		If (StorageUtil.GetIntValue(PlayerActor, "_SD_iSurrenderOn")==1)
			If  (ref != none) && ( (ref as Actor) != none)

				if (ref.GetVoiceType() != none) && (!(ref as Actor).IsDead())  ;is this an actor?
					kCrosshairTarget = ref 
	 				StorageUtil.SetIntValue(kPlayer, "_SD_iSurrenderCrosshairUpdated", 1)
					debugTrace(" Looking at potential master - " + ref)
				endif

			EndIf
		Endif
	EndEvent

	Event OnUpdate()
		kCombatTarget = kPlayer.GetCombatTarget() as Actor
		kSubmitTarget = kCrosshairTarget as Actor

		If (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslavementInitSequenceOn")==1)
 			; Debug.Notification("[SD] Aborting surrender")
 			debugTrace(" Aborting surrender")
			StorageUtil.SetIntValue(kPlayer, "_SD_iSurrenderOn", 0)
			GoToState("monitor")
		Endif

		if (StorageUtil.GetIntValue(kPlayer, "_SD_iSurrenderCrosshairUpdated") == 1)
			if (kCombatTarget!=none) && (kPlayer.IsInCombat())
				Debug.Notification("[SD] Surrender to combat target")
				debugTrace(" Surrender to combat target")
				StorageUtil.SetIntValue(kPlayer, "_SD_iSurrenderOn", 0)
				; kCombatTarget.SendModEvent("PCSubSurrender")
				fctOutfit.initSlaveryGearByActor ( kCombatTarget )
				SDSurrender(kCombatTarget, "" )
				GoToState("monitor")

			elseif (kSubmitTarget!=none) 
				debugTrace(" Surrender to crosshair target")
				Debug.Notification("[SD] Surrender to crosshair target")
				StorageUtil.SetIntValue(kPlayer, "_SD_iSurrenderOn", 0)
				; kSubmitTarget.SendModEvent("PCSubSurrender")
				fctOutfit.initSlaveryGearByActor ( kSubmitTarget )
				SDSurrender(kSubmitTarget, "" )
				GoToState("monitor")

			else
				; Debug.Notification("[SD] Surrendering")
	 			StorageUtil.SetIntValue(kPlayer, "_SD_iSurrenderOn", 1)
			endif
		else
			; Debug.Notification("[SD] No crosshair target yet")
 			StorageUtil.SetIntValue(kPlayer, "_SD_iSurrenderOn", 1)
		endif

		If ( kPlayer && Self.GetOwningQuest() )
			RegisterForSingleUpdate( 0.1 )
		EndIf
	EndEvent

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
 			Debug.Notification("[SD] Aborting surrender")
			StorageUtil.SetIntValue(kPlayer, "_SD_iSurrenderOn", 0)
			GoToState("monitor")
		Endif
	Endevent

	Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, Bool abPowerAttack, Bool abSneakAttack, Bool abBashAttack, Bool abHitBlocked)
		Actor akActor = akAggressor as Actor

		If (akAggressor != None) 
			If (!akActor.IsDead())
				Debug.Notification("[SD] Surrender to aggressor")
				StorageUtil.SetIntValue(kPlayer, "_SD_iSurrenderOn", 0)
				; akActor.SendModEvent("PCSubSurrender")
				fctOutfit.initSlaveryGearByActor ( akActor )
				SDSurrender(akActor, "" )
				GoToState("monitor")

			Endif
		Endif
	EndEvent
	

EndState



Function SetHandsFreeSlave(Actor kActor)
	; fctOutfit.clearDeviceByString ( "Armbinder" )
	if (fctOutfit.isWristRestraintEquipped( kActor ))  
		fctOutfit.ClearSlavePunishment(kActor , "WristRestraints" , true )
	Endif
	StorageUtil.GetIntValue(kActor, "_SD_iHandsFree", 1)
	Debug.Notification("Your owner releases your hands.")

EndFunction

Function debugTrace(string traceMsg)
	if (StorageUtil.GetIntValue(none, "_SD_debugTraceON")==1)
		Debug.Trace("[_sdras_player]"  + traceMsg)
	endif
endFunction

