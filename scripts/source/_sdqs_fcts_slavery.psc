Scriptname _sdqs_fcts_slavery extends Quest  

_SDQS_fcts_constraints Property fctConstraints  Auto
_SDQS_fcts_outfit Property fctOutfit  Auto
_SDQS_fcts_factions Property fctFactions  Auto

; Properties redefined to allow upgrade to SD+ V3 without a need for a new save game
; Older properties may have None value baked into save game at this point
_SDQS_fcts_constraints Property fctConstraintsV3  Auto
_SDQS_fcts_outfit Property fctOutfitV3  Auto
_SDQS_fcts_factions Property fctFactionsV3  Auto

Keyword Property ActorTypeNPC  Auto  

function InitSlaveryState( Actor kSlave )
	; Called during SD initialization - Sanguine is watching
	_SDGVP_enslaved.SetValue( 0 )
	StorageUtil.SetIntValue(kSlave, "_SD_iAPIInit", 1)

	; API variables
	StorageUtil.SetIntValue(kSlave, "_SD_iEnslaved", 0)
	StorageUtil.SetFormValue(kSlave, "_SD_CurrentOwner", None)
	StorageUtil.SetFormValue(kSlave, "_SD_DesiredOwner", None)
	StorageUtil.SetFormValue(kSlave, "_SD_LastOwner", None)

	StorageUtil.SetFloatValue(kSlave, "_SD_fEnslavedGameTime", 0.0)
	StorageUtil.SetFloatValue(kSlave, "_SD_fLastEnslavedGameTime", 0.0)
	StorageUtil.SetFloatValue(kSlave, "_SD_fLastReleasedGameTime", 0.0)
	StorageUtil.SetFloatValue(kSlave, "_SD_fPunishmentGameTime", 0.0)
	StorageUtil.SetFloatValue(kSlave, "_SD_fPunishmentDuration", 0.0)
 	StorageUtil.SetIntValue(kSlave, "_SD_iSlaveryLevel", 0)

	; Gameplay preferences
	StorageUtil.SetIntValue(kSlave, "_SD_iDisablePlayerMovementWhipping", 0)
	StorageUtil.SetIntValue(kSlave, "_SD_iDisablePlayerMovementPunishment", 1)
	StorageUtil.SetIntValue(kSlave, "_SD_iDisablePlayerAutoKneeling", 0)
 	StorageUtil.SetIntValue(kSlave, "_SD_iDisableDreamworldOnSleep", 0)
 
EndFunction



function StartSlavery( Actor kMaster, Actor kSlave)
	_SDGVP_enslaved.SetValue( 1 )
	_SDGVP_can_join.SetValue( 0 )
	
	; API variables
	StorageUtil.SetIntValue(kSlave, "_SD_iSold", 0)
	StorageUtil.SetIntValue(kSlave, "_SD_iEnslaved", 1)
	StorageUtil.SetFormValue(kSlave, "_SD_CurrentOwner", kMaster)
	StorageUtil.SetFormValue(kSlave, "_SD_DesiredOwner", None)

	StorageUtil.SetIntValue(kSlave, "_SD_iTimeBuffer", 20)  ; number of seconds allowed away from Master

	StorageUtil.SetIntValue(kMaster,"_SD_iFollowSlave", 0)

	StorageUtil.SetFormValue(kSlave, "_SD_LeashCenter", kMaster)
	StorageUtil.SetIntValue(kSlave, "_SD_iLeashLength", 200)
	StorageUtil.SetStringValue(kSlave, "_SD_sDefaultStance", "Kneeling")

	StorageUtil.SetFloatValue(kSlave, "_SD_fLastEnslavedGameTime", StorageUtil.GetFloatValue(kSlave, "_SD_fEnslavedGameTime"))
	StorageUtil.SetFloatValue(kSlave, "_SD_fEnslavedGameTime", _SDGVP_gametime.GetValue())
	StorageUtil.SetFloatValue(kSlave, "_SD_fPunishmentGameTime", 0.0)
	StorageUtil.SetFloatValue(kSlave, "_SD_fPunishmentDuration", 0.0)
	StorageUtil.SetFloatValue(kSlave, "_SD_iEnslavementDays", 0)

	; Acts performed today
	StorageUtil.SetIntValue(kSlave, "_SD_iSexCountToday", 0)
	StorageUtil.SetIntValue(kSlave, "_SD_iPunishmentCountToday", 0)
	StorageUtil.SetIntValue(kSlave, "_SD_iSubmissiveCountToday", 0)
	StorageUtil.SetIntValue(kSlave, "_SD_iAngerCountToday", 0)

	; Acts performed since start of mod
	If (!StorageUtil.HasIntValue(kMaster, "_SD_iSexCountTotal"))
		StorageUtil.SetIntValue(kSlave, "_SD_iSexCountTotal", 0)
	EndIf
	If (!StorageUtil.HasIntValue(kMaster, "_SD_iPunishmentCountTotal"))
		StorageUtil.SetIntValue(kSlave, "_SD_iPunishmentCountTotal", 0)
	EndIf
	If (!StorageUtil.HasIntValue(kMaster, "_SD_iSubmissiveCountTotal"))
		StorageUtil.SetIntValue(kSlave, "_SD_iSubmissiveCountTotal", 0)
	EndIf
	If (!StorageUtil.HasIntValue(kMaster, "_SD_iAngerCountTotal"))
		StorageUtil.SetIntValue(kSlave, "_SD_iAngerCountTotal", 0)
	EndIf

	; Relationship type with NPC ( -4 to 4 is normal Skyrim relationship rank)

	; 7: Slave (submissive)
	; 6: Slave (neutral)
	; 5: Slave (hostile)
	; 4: Lover
	; 3: Ally
	; 2: Confidant
	; 1: Friend
	; 0: Acquaintance
	; -1: Rival
	; -2: Foe
	; -3: Enemy
	; -4: Archnemesis
	; -5: Master (hostile)
	; -6: Master (neutral)
	; -7: Master (submissive)

	StorageUtil.SetIntValue(kMaster, "_SD_iOriginalRelationshipRank", kMaster.GetRelationshipRank(kSlave)) 

	If (!StorageUtil.HasIntValue(kMaster, "_SD_iRelationshipType"))
		StorageUtil.SetIntValue(kMaster, "_SD_iRelationshipType", -5 ) 
	EndIf
	If (!StorageUtil.HasIntValue(kMaster, "_SD_iForcedSlavery"))
		StorageUtil.SetIntValue(kMaster, "_SD_iForcedSlavery", 1) 
	EndIf

	If (!StorageUtil.HasIntValue(kSlave, "_SD_iSlaveryLevel")) || (StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryLevel") == 0)
		StorageUtil.SetIntValue(kSlave, "_SD_iSlaveryLevel", 1)
	EndIf
	If (!StorageUtil.HasIntValue(kSlave, "_SD_iSlaveryExposure")) || (StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryExposure") == 0)
		StorageUtil.SetIntValue(kSlave, "_SD_iSlaveryExposure", 1)
	EndIf


	; - Master personality profile
	; 0 - Simple profile. No additional constraints
	;				Endgame: Sell slave to slave trader.
	; 1 - Comfortable - Must complete or exceed food goal
	;				Endgame: Sell slave to inn-keeper.
	; 2 - Horny - Must complete or exceed sex goal
	;				Endgame: Sell slave to soldier barracks.
	; 3 - Sadistic - Must complete or exceed punishment goals
	;				Endgame: Kill slave or left for dead.
	; 4 - Gambler - Must complete or exceed gold goals. 
	;				Endgame: Sell slave to dog fighting ring.
	; 5 - Caring - Seeks full compliance for one goal at least
	;				Endgame: Banish slave (get out of my sight).
	; 6 - Perfectionist - Seeks full compliance for all goals
	;				Endgame: Hunt, Kill slave or left for dead.

	If (!StorageUtil.HasIntValue(kMaster, "_SD_iPersonalityProfile"))
		int profileChance =  Utility.RandomInt(0,100)

		if (profileChance >= 95)
			StorageUtil.SetIntValue(kMaster, "_SD_iPersonalityProfile", 6 ) 
		elseif (profileChance >= 80)
			StorageUtil.SetIntValue(kMaster, "_SD_iPersonalityProfile", 5 ) 
		elseif (profileChance >= 70)
			StorageUtil.SetIntValue(kMaster, "_SD_iPersonalityProfile", 4 ) 
		elseif (profileChance >= 60)
			StorageUtil.SetIntValue(kMaster, "_SD_iPersonalityProfile", 3 ) 
		elseif (profileChance >= 50)
			StorageUtil.SetIntValue(kMaster, "_SD_iPersonalityProfile", 2 ) 
		elseif (profileChance >= 40)
			StorageUtil.SetIntValue(kMaster, "_SD_iPersonalityProfile", 1 ) 
		else
			StorageUtil.SetIntValue(kMaster, "_SD_iPersonalityProfile", 0 ) 
		endif
	EndIf

	; Master satisfaction - negative = angry / positive = happy
	If (!StorageUtil.HasIntValue(kMaster, "_SD_iNPCDisposition"))
		If (StorageUtil.GetIntValue(kMaster, "_SD_iForcedSlavery") == 1)
			StorageUtil.SetIntValue(kMaster, "_SD_iDisposition", Utility.RandomInt(-5,10)   )
		else
			StorageUtil.SetIntValue(kMaster, "_SD_iDisposition", Utility.RandomInt(-10,5)   )
		EndIf
	Else
		StorageUtil.SetIntValue(kMaster, "_SD_iDisposition", StorageUtil.GetIntValue(kMaster, "_SD_iDisposition") * 2   )
	EndIf
	StorageUtil.SetIntValue(kMaster, "_SD_iOverallDisposition", 0)

	; Master need and trust ranges - plus or minus value around 0
	; Some masters are easier to please than others
	If (!StorageUtil.HasIntValue(kMaster, "_SD_iNeedRange"))
		StorageUtil.SetIntValue(kMaster, "_SD_iNeedRange", Utility.RandomInt(2,5)   )
	EndIf
	; Some masters are easier to convince than others
	If (!StorageUtil.HasIntValue(kMaster, "_SD_iTrustRange"))
		StorageUtil.SetIntValue(kMaster, "_SD_iTrustRange", Utility.RandomInt(5,15)   )
	EndIf

	StorageUtil.SetIntValue(kMaster, "_SD_iGoalFood", Utility.RandomInt(5,10))
	StorageUtil.SetIntValue(kMaster, "_SD_iGoalSex",  Utility.RandomInt(5,10))
	StorageUtil.SetIntValue(kMaster, "_SD_iGoalPunishment",  Utility.RandomInt(5,10))
	StorageUtil.SetIntValue(kMaster, "_SD_iGoalGold",  Utility.RandomInt(15,50))
	; Special needs based on faction
	; Special items (firewood, ingredients)
	; Blood feedings (Vampire)

	; Slave daily progress
	StorageUtil.SetIntValue(kSlave, "_SD_iGoalFood", 0)
	StorageUtil.SetIntValue(kSlave, "_SD_iGoalSex", 0)
	StorageUtil.SetIntValue(kSlave, "_SD_iGoalPunishment", 0)
	StorageUtil.SetIntValue(kSlave, "_SD_iGoalGold", 0)

	; Master trust - number of merit points necessary for master to trust slave
	If (!StorageUtil.HasIntValue(kMaster, "_SD_iTrustThreshold"))
		StorageUtil.SetIntValue(kMaster, "_SD_iTrustThreshold", 20 )
	else
		StorageUtil.SetIntValue(kMaster, "_SD_iTrustThreshold", StorageUtil.GetIntValue(kMaster, "_SD_iTrustThreshold") + 10)
	EndIf

	; Slave privileges
	StorageUtil.SetIntValue(kSlave, "_SD_iMeritPoints", 0)  ; Trust earned by slave

	; StorageUtil.SetIntValue(kSlave, "_SD_iEnableLeash", 1)
	UpdateSlavePrivilege(kSlave, "_SD_iEnableLeash", True)

	; StorageUtil.SetIntValue(kSlave, "_SD_iEnableStand", 0)
	UpdateSlavePrivilege(kSlave, "_SD_iEnableStand", False)
	; StorageUtil.SetIntValue(kSlave, "_SD_iEnableMovement", 0)
	UpdateSlavePrivilege(kSlave, "_SD_iEnableMovement", False)
	; StorageUtil.SetIntValue(kSlave, "_SD_iEnableAction", 0)
	UpdateSlavePrivilege(kSlave, "_SD_iEnableAction", False)
	; StorageUtil.SetIntValue(kSlave, "_SD_iEnableFight", 0)
	UpdateSlavePrivilege(kSlave, "_SD_iEnableFight", False)

	; StorageUtil.SetIntValue(kSlave, "_SD_iEnableInventory", 0)
	UpdateSlavePrivilege(kSlave, "_SD_iEnableInventory", False)
	; StorageUtil.SetIntValue(kSlave, "_SD_iEnableSprint", 0)
	UpdateSlavePrivilege(kSlave, "_SD_iEnableSprint", False)
	; StorageUtil.SetIntValue(kSlave, "_SD_iEnableRideHorse", 0)
	UpdateSlavePrivilege(kSlave, "_SD_iEnableRideHorse", False)
	; StorageUtil.SetIntValue(kSlave, "_SD_iEnableFastTravel", 0)
	UpdateSlavePrivilege(kSlave, "_SD_iEnableFastTravel", False)
	; StorageUtil.SetIntValue(kSlave, "_SD_iEnableWait", 0)
	UpdateSlavePrivilege(kSlave, "_SD_iEnableWait", False)

	; StorageUtil.SetIntValue(kSlave, "_SD_iEnableSpellEquip", 0)
	UpdateSlavePrivilege(kSlave, "_SD_iEnableSpellEquip", False)
	; StorageUtil.SetIntValue(kSlave, "_SD_iEnableShoutEquip", 0)
	UpdateSlavePrivilege(kSlave, "_SD_iEnableShoutEquip", False)
	; StorageUtil.SetIntValue(kSlave, "_SD_iEnableClothingEquip", 0)
	UpdateSlavePrivilege(kSlave, "_SD_iEnableClothingEquip", False)
	; StorageUtil.SetIntValue(kSlave, "_SD_iEnableArmorEquip", 0)
	UpdateSlavePrivilege(kSlave, "_SD_iEnableArmorEquip", False)
	; StorageUtil.SetIntValue(kSlave, "_SD_iEnableWeaponEquip", 0)
	UpdateSlavePrivilege(kSlave, "_SD_iEnableWeaponEquip", False)
	; StorageUtil.SetIntValue(kSlave, "_SD_iEnableMoney", 0)
	UpdateSlavePrivilege(kSlave, "_SD_iEnableMoney", False)

	; Slavery items preferences
	; List initialization if it hasn't been set yet
	fctOutfitV3.registerDeviousOutfits ( )

	; Outfit selection - Commoner by default
	int outfitID = 0
	ActorBase PlayerBase = Game.GetPlayer().GetActorBase()
				
	if (kMaster.HasKeyword( ActorTypeNPC ))
		if (PlayerBase.GetSex() == 0)
				; Player is male - force outfit 1 for model compatibility
				outfitID = 1

		Elseif ( (kMaster.GetAV("Magicka") as Int) > (kMaster.GetAV("Health") as Int) ) && ( (kMaster.GetAV("Magicka") as Int) > (kMaster.GetAV("Stamina") as Int) )
			; Greater magicka - use magicka outfit
			outfitID = 2

		Elseif ( (kMaster.GetAV("Health") as Int) > (kMaster.GetAV("Magicka") as Int) ) && ( (kMaster.GetAV("Health") as Int) > (kMaster.GetAV("Stamina") as Int) )
			; Greater health - use wealthy outfit
			outfitID = 1

		EndIf
	ElseIf ( fctFactions.checkIfFalmer ( kMaster) )
		outfitID = 5
	Else
		outfitID = 3
	EndIf

	StorageUtil.SetIntValue(kMaster, "_SD_iOutfitID", outfitID)

	Debug.Trace("[SD] Init master devices: List count: " + StorageUtil.StringListCount( kMaster, "_SD_lDevices"))

	if (StorageUtil.StringListCount( kMaster, "_SD_lDevices") == 0)
		InitMasterDevices( kMaster, outfitID)

	EndIf

	; Compatibility with other mods
	StorageUtil.StringListAdd(kMaster, "_DDR_DialogExclude", "SD+:Master")
	StorageUtil.GetIntValue(kSlave, "_SD_iDisableDreamworldOnSleep", 1)

	UpdateStatusDaily(  kMaster,  kSlave)
EndFunction

function InitMasterDevices( Actor kMaster, Int iOutfit)

	Debug.Trace("[SD] Init master devices - outfitID: " + iOutfit)

	fctOutfitV3.registerDeviousOutfitsKeywords (  kMaster )

	if (iOutfit == 0) ; Iron
		StorageUtil.StringListAdd( kMaster, "_SD_lDevices", "collar") ; 0 - Collar - Unused
		StorageUtil.StringListAdd( kMaster, "_SD_lDevices", "cuffs,arms,metal,iron,zap") ; 1 - Arms cuffs
		StorageUtil.StringListAdd( kMaster, "_SD_lDevices", "cuffs,legs,metal,iron,zap") ; 2 - Legs cuffs
		StorageUtil.StringListAdd( kMaster, "_SD_lDevices", "gag,leather,zap") ; 3 - Gag
		StorageUtil.StringListAdd( kMaster, "_SD_lDevices", "blindfold,leather,zap") ; 4 - Blindfold
		StorageUtil.StringListAdd( kMaster, "_SD_lDevices", "belt,metal,iron") ; 5 - Belt
		StorageUtil.StringListAdd( kMaster, "_SD_lDevices", "plug,anal") ; 6 - Plug Anal
		StorageUtil.StringListAdd( kMaster, "_SD_lDevices", "plug,vaginal") ; 7 - Plug Vaginal

		; Harness disabled for now as it overlaps with collar
		; StorageUtil.StringListAdd(Game.GetPlayer(), "_SD_lDevices", "harness,leather,black") ; 6 - Harness

	Elseif (iOutfit == 1) ; Leather
		StorageUtil.StringListAdd( kMaster, "_SD_lDevices", "collar") ; 0 - Collar - Unused
		StorageUtil.StringListAdd( kMaster, "_SD_lDevices", "cuffs,arms,metal,iron,zap") ; 1 - Arms cuffs
		StorageUtil.StringListAdd( kMaster, "_SD_lDevices", "cuffs,legs,metal,iron,zap") ; 2 - Legs cuffs
		StorageUtil.StringListAdd( kMaster, "_SD_lDevices", "gag,leather,black") ; 3 - Gag
		StorageUtil.StringListAdd( kMaster, "_SD_lDevices", "blindfold,leather,black") ; 4 - Blindfold
		StorageUtil.StringListAdd( kMaster, "_SD_lDevices", "belt,metal,iron") ; 5 - Belt
		StorageUtil.StringListAdd( kMaster, "_SD_lDevices", "plug,anal") ; 6 - Plug Anal
		StorageUtil.StringListAdd( kMaster, "_SD_lDevices", "plug,vaginal") ; 7 - Plug Vaginal

	Elseif (iOutfit == 2) ; Random
		StorageUtil.StringListAdd( kMaster, "_SD_lDevices", "collar") ; 0 - Collar - Unused
		StorageUtil.StringListAdd( kMaster, "_SD_lDevices", "cuffs,arms,metal,iron,zap") ; 1 - Arms cuffs
		StorageUtil.StringListAdd( kMaster, "_SD_lDevices", "cuffs,legs,metal,iron,zap") ; 2 - Legs cuffs
		StorageUtil.StringListAdd( kMaster, "_SD_lDevices", "gag") ; 3 - Gag
		StorageUtil.StringListAdd( kMaster, "_SD_lDevices", "blindfold") ; 4 - Blindfold
		StorageUtil.StringListAdd( kMaster, "_SD_lDevices", "belt") ; 5 - Belt
		StorageUtil.StringListAdd( kMaster, "_SD_lDevices", "plug,anal") ; 6 - Plug Anal
		StorageUtil.StringListAdd( kMaster, "_SD_lDevices", "plug,vaginal") ; 7 - Plug Vaginal
	Else ; Other
		StorageUtil.StringListAdd( kMaster, "_SD_lDevices", "collar") ; 0 - Collar - Unused
		StorageUtil.StringListAdd( kMaster, "_SD_lDevices", "cuffs,arms,metal,iron,zap") ; 1 - Arms cuffs
		StorageUtil.StringListAdd( kMaster, "_SD_lDevices", "cuffs,legs,metal,iron,zap") ; 2 - Legs cuffs
		StorageUtil.StringListAdd( kMaster, "_SD_lDevices", "gag,leather,zap") ; 3 - Gag
		StorageUtil.StringListAdd( kMaster, "_SD_lDevices", "blindfold,leather,zap") ; 4 - Blindfold
		StorageUtil.StringListAdd( kMaster, "_SD_lDevices", "belt,metal,iron") ; 5 - Belt
		StorageUtil.StringListAdd( kMaster, "_SD_lDevices", "plug,anal") ; 6 - Plug Anal
		StorageUtil.StringListAdd( kMaster, "_SD_lDevices", "plug,vaginal") ; 7 - Plug Vaginal
	EndIf
EndFunction


function StopSlavery( Actor kMaster, Actor kSlave)

	; API variables
	StorageUtil.SetFormValue(kSlave, "_SD_LastOwner", kMaster)

	StorageUtil.SetFloatValue(kSlave, "_SD_fLastReleasedGameTime", _SDGVP_gametime.GetValue())
	StorageUtil.SetFloatValue(kSlave, "_SD_fPunishmentGameTime", 0.0)
	StorageUtil.SetFloatValue(kSlave, "_SD_fPunishmentDuration", 0.0)

	; Restore original relationship rank with slave
	kMaster.SetRelationshipRank(kSlave, StorageUtil.GetIntValue(kMaster, "_SD_iOriginalRelationshipRank") ) 

	StorageUtil.SetFormValue(kSlave, "_SD_LeashCenter", kMaster)
	StorageUtil.SetIntValue(kSlave, "_SD_iLeashLength", 0)

	StorageUtil.SetIntValue(kSlave, "_SD_iEnslaved", 0)
	StorageUtil.SetIntValue(kSlave, "_SD_iSold", 0)
	_SDGVP_enslaved.SetValue( 0 )

	; Compatibility with other mods
	StorageUtil.StringListRemove(kMaster, "_DDR_DialogExclude", "SD+:Master")
	StorageUtil.GetIntValue(kSlave, "_SD_iDisableDreamworldOnSleep", 0)
EndFunction

; I know - these two functions could be turned into one. I am keeping them separate for now in case I need to treat master and slave differently later on

; modify master status ( disposition amount, trust amount )
; modify master goal (goal ID, amount)
function UpdateMasterValue( Actor kMaster, string modVariable, int modValue =0, int setNewValue =0)

	; _SD_iNPCDisposition
	; _SD_iTrustThreshold
	; _SD_iGoalFood
	; _SD_iGoalSex
	; _SD_iGoalPunishment
 	; _SD_iGoalGold

	if (modValue != 0)
		StorageUtil.SetIntValue(kMaster, modVariable, StorageUtil.GetIntValue(kMaster, modVariable) + modValue )
	elseif (setNewValue != 0)
		StorageUtil.SetIntValue(kMaster, modVariable, setNewValue )
	endif

 
EndFunction

; modify slave status ( merit points, slavery level )
; modify slave progress (goal ID, amount)
function UpdateSlaveStatus( Actor kSlave, string modVariable, int modValue =0, int setNewValue =0)
	string storageUtilVariable = ""

	; _SD_iSlaveryLevel
	; _SD_iMeritPoints
	; _SD_iTimeBuffer
	; _SD_iGoalFood
	; _SD_iGoalSex
	; _SD_iGoalPunishment
	; _SD_iGoalGold

	if (modValue != 0)
		StorageUtil.SetIntValue(kSlave, modVariable, StorageUtil.GetIntValue(kSlave, modVariable) + modValue )
	elseif (setNewValue != 0)
		StorageUtil.SetIntValue(kSlave, modVariable, setNewValue )
	endif

EndFunction

; fctSlavery.UpdateSlaveStatus(kSlave, "_SD_iGoalSex", modValue = 1)
function UpdateSlaveryVariable( Actor kActor, string modVariable, int modValue =0, int setNewValue =0)
	string storageUtilVariable = ""

	if (modValue != 0)
		StorageUtil.SetIntValue(kActor, modVariable, StorageUtil.GetIntValue(kActor, modVariable) + modValue )
	elseif (setNewValue != 0)
		StorageUtil.SetIntValue(kActor, modVariable, setNewValue )
	endif

EndFunction

; add/remove privileges 
Bool function CheckSlavePrivilege( Actor kSlave, string modVariable)
	Return StorageUtil.GetIntValue(kSlave,modVariable) as Bool
EndFunction

function UpdateSlavePrivilege( Actor kSlave, string modVariable, bool modValue = True)
	Bool enableMove = StorageUtil.GetIntValue(kSlave,"_SD_iEnableMovement") as Bool
	Bool enableAct = StorageUtil.GetIntValue(kSlave,"_SD_iEnableAction") as Bool
	Bool enableFight = StorageUtil.GetIntValue(kSlave,"_SD_iEnableFight") as Bool

	If (modVariable == "_SD_iEnableLeash")
			StorageUtil.SetIntValue(kSlave, modVariable,  modValue as Int)

			; fctConstraintsV3.playerAutoPilot(modValue)  - not necessary for now
	EndIf

	If (modVariable == "_SD_iEnableMovement")
			StorageUtil.SetIntValue(kSlave, modVariable,  modValue as Int)
			enableMove = modValue
			fctConstraintsV3.togglePlayerControlsOn(abMove = enableMove, abAct = enableAct, abFight = enableFight)
	EndIf

	If (modVariable == "_SD_iEnableAction")
			StorageUtil.SetIntValue(kSlave, modVariable,  modValue as Int)
			enableAct = modValue
			fctConstraintsV3.togglePlayerControlsOn(abMove = enableMove, abAct = enableAct, abFight = enableFight)
	EndIf

	If (modVariable == "_SD_iEnableFight")
			StorageUtil.SetIntValue(kSlave, modVariable,  modValue as Int)
			enableFight = modValue
			fctConstraintsV3.togglePlayerControlsOn(abMove = enableMove, abAct = enableAct, abFight = enableFight)
	EndIf

	If (modVariable == "_SD_iEnableInventory")
			StorageUtil.SetIntValue(kSlave, modVariable,  modValue as Int)
			; See - http://www.creationkit.com/RegisterForMenu_-_Form
			; Register for menus and exit menu if not allowed
			; See example from SD and crafting
			; List of menus - http://www.creationkit.com/UI_Script
	EndIf

	If (modVariable == "_SD_iEnableSprint")
			StorageUtil.SetIntValue(kSlave, modVariable,  modValue as Int)
			; How to disable?
	EndIf

	If (modVariable == "_SD_iEnableRideHorse")
			StorageUtil.SetIntValue(kSlave, modVariable,  modValue as Int)
			; How to disable? Detect if riding mount and force dismount?
			; See - http://www.creationkit.com/IsOnMount_-_Actor
	EndIf

	If (modVariable == "_SD_iEnableFastTravel")
			StorageUtil.SetIntValue(kSlave, modVariable,  modValue as Int)

			if (modValue)
				; Enable fast travel
				Game.EnableFastTravel()
			else
				; Disable fast travel
				Game.EnableFastTravel(false)
			endif
	EndIf

	If (modVariable == "_SD_iEnableWait")
			StorageUtil.SetIntValue(kSlave, modVariable,  modValue as Int)

			if (modValue)
				; Disable waiting
			;	Game.SetInChargen(false, false, false)
			Else
			;	Game.SetInChargen(false, true, true)
			EndIf
	EndIf


	If (modVariable == "_SD_iEnableSpellEquip")
			StorageUtil.SetIntValue(kSlave, modVariable,  modValue as Int)
			; Augment OnEquip event for slave based on this storageUtil value
	EndIf

	If (modVariable == "_SD_iEnableShoutEquip")
			StorageUtil.SetIntValue(kSlave, modVariable,  modValue as Int)
			; Augment OnEquip event for slave based on this storageUtil value
	EndIf

	If (modVariable == "_SD_iEnableClothingEquip")
			StorageUtil.SetIntValue(kSlave, modVariable,  modValue as Int)
			; Augment OnEquip event for slave based on this storageUtil value
	EndIf

	If (modVariable == "_SD_iEnableArmorEquip")
			StorageUtil.SetIntValue(kSlave, modVariable,  modValue as Int)
			; Augment OnEquip event for slave based on this storageUtil value
	EndIf

	If (modVariable == "_SD_iEnableWeaponEquip")
			StorageUtil.SetIntValue(kSlave, modVariable,  modValue as Int)
			; Augment OnEquip event for slave based on this storageUtil value
	EndIf

	If (modVariable == "_SD_iEnableMoney")
			StorageUtil.SetIntValue(kSlave, modVariable,  modValue as Int)
			; Augment OnItemAdded event for slave based on this storageUtil value
	EndIf

 

EndFunction

; Slavery has to be initiated using SendStory. 
; Remember to use StopSlavery to clean things up before transfer to new master

; refreshGlobalValues() - map some storageUtil values to GlobalValues for use with dialogue conditions
function SlaveryRefreshGlobalValues( Actor kMaster, Actor kSlave)
	Int masterTrust = StorageUtil.GetIntValue(kSlave, "_SD_iTrustPoints") - StorageUtil.GetIntValue(kMaster, "_SD_iTrustThreshold") 
	Int masterDisposition = StorageUtil.GetIntValue(kMaster, "_SD_iDisposition")
	Int overallMasterDisposition = StorageUtil.GetIntValue(kMaster, "_SD_iOverallDisposition")
	int masterPersonalityType = StorageUtil.GetIntValue(kMaster, "_SD_iPersonalityProfile")
	Int masterSexNeed = StorageUtil.GetIntValue(kSlave, "_SD_iGoalSex") - StorageUtil.GetIntValue(kMaster, "_SD_iGoalSex")
	Int masterPunishNeed = StorageUtil.GetIntValue(kSlave, "_SD_iGoalPunish") - StorageUtil.GetIntValue(kMaster, "_SD_iGoalPunish")
	Int masterFoodNeed = StorageUtil.GetIntValue(kSlave, "_SD_iGoalFood") - StorageUtil.GetIntValue(kMaster, "_SD_iGoalFood")
	Int masterGoldNeed = StorageUtil.GetIntValue(kSlave, "_SD_iGoalGold") - StorageUtil.GetIntValue(kMaster, "_SD_iGoalGold")

	_SDGVP_MasterDisposition.SetValue( masterDisposition ) 
	_SDGVP_MasterDispositionOverall.SetValue( overallMasterDisposition ) 
	_SDGVP_MasterTrust.SetValue( masterTrust ) 
	_SDGVP_MasterPersonalityType.SetValue( masterPersonalityType ) 
	_SDGVP_MasterNeedFood.SetValue( masterFoodNeed ) 
	_SDGVP_MasterNeedGold.SetValue( masterGoldNeed ) 
	_SDGVP_MasterNeedSex.SetValue( masterSexNeed ) 
	_SDGVP_MasterNeedPunishment.SetValue( masterPunishNeed ) 
	_SDGVP_SlaveryLevel.SetValue( StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryLevel") )
EndFunction

Function UpdateSlaveryLevel(Actor kSlave)
	Int exposure = StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryExposure")

	; Update exposure level
	If (exposure == 0) ; level 0 - free
		StorageUtil.SetIntValue(kSlave, "_SD_iSlaveryLevel", 0)
	ElseIf (exposure >= 1) && (exposure <20) ; level 1 - rebelious
		StorageUtil.SetIntValue(kSlave, "_SD_iSlaveryLevel", 1)
	ElseIf (exposure >= 20) && (exposure <60) ; level 2 - reluctant
		StorageUtil.SetIntValue(kSlave, "_SD_iSlaveryLevel", 2)
	ElseIf (exposure >= 60) && (exposure <120) ; level 3 - accepting
		StorageUtil.SetIntValue(kSlave, "_SD_iSlaveryLevel", 3)
	ElseIf (exposure >= 120) && (exposure < 200) ; level 4 - not so bad 
		StorageUtil.SetIntValue(kSlave, "_SD_iSlaveryLevel", 4)
	ElseIf (exposure >= 200) && (exposure < 300) ; level 5 - getting to like it
		StorageUtil.SetIntValue(kSlave, "_SD_iSlaveryLevel", 5)
	ElseIf (exposure >= 300)  ; level 6 - begging for it
		StorageUtil.SetIntValue(kSlave, "_SD_iSlaveryLevel", 6)
	EndIf

	; Correct slavery level based on user preference
	If ( StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryLevel") < _SDGVP_config_min_slavery_level.GetValue() )
		StorageUtil.SetIntValue(kSlave, "_SD_iSlaveryLevel", _SDGVP_config_min_slavery_level.GetValue() as Int )
	EndIf

	If ( StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryLevel") > _SDGVP_config_max_slavery_level.GetValue() )
		StorageUtil.SetIntValue(kSlave, "_SD_iSlaveryLevel", _SDGVP_config_max_slavery_level.GetValue() as Int )
	EndIf

	Debug.Trace("[_sdqs_fcts_slavery] SLavery exposure: " + StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryExposure") + " - level: " + StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryLevel"))
EndFunction

Function UpdateSlaveryRelationshipType(Actor kMaster, Actor kSlave)
	Int exposure = StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryExposure")

	; Update exposure level
	If (exposure == 0) ; level 0 - free
		StorageUtil.SetIntValue(kMaster, "_SD_iRelationshipType", -5 )
	ElseIf (exposure >= 1) && (exposure <20) ; level 1 - rebelious
		StorageUtil.SetIntValue(kMaster, "_SD_iRelationshipType", -5 ) 
	ElseIf (exposure >= 20) && (exposure <60) ; level 2 - reluctant
		StorageUtil.SetIntValue(kMaster, "_SD_iRelationshipType", -6 ) 
	ElseIf (exposure >= 60) && (exposure <120) ; level 3 - accepting
		StorageUtil.SetIntValue(kMaster, "_SD_iRelationshipType", -6 ) 
	ElseIf (exposure >= 120) && (exposure < 200) ; level 4 - not so bad 
		StorageUtil.SetIntValue(kMaster, "_SD_iRelationshipType", -6 ) 
	ElseIf (exposure >= 200) && (exposure < 300) ; level 5 - getting to like it
		StorageUtil.SetIntValue(kMaster, "_SD_iRelationshipType", -7 ) 
	ElseIf (exposure >= 300)  ; level 6 - begging for it
		StorageUtil.SetIntValue(kMaster, "_SD_iRelationshipType", -7 ) 
	EndIf
EndFunction

; automatic refresh - updateStatusHourly() - refresh privileges and variables based on storageUtilValues
function UpdateStatusHourly( Actor kMaster, Actor kSlave)
	; Disabled for now - daily update makes more sense

EndFunction

; automatic refresh - updateStatusDaily() - make duration configurable in MCM 
function UpdateStatusDaily( Actor kMaster, Actor kSlave)
	int slaveryLevel = StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryLevel")
	Int masterTrust = StorageUtil.GetIntValue(kSlave, "_SD_iTrustPoints") - StorageUtil.GetIntValue(kMaster, "_SD_iTrustThreshold") 
	Int masterDisposition = StorageUtil.GetIntValue(kMaster, "_SD_iDisposition")
	Int overallMasterDisposition = StorageUtil.GetIntValue(kMaster, "_SD_iOverallDisposition")
	int masterPersonalityType = StorageUtil.GetIntValue(kMaster, "_SD_iPersonalityProfile")
	Int masterSexNeed = StorageUtil.GetIntValue(kSlave, "_SD_iGoalSex") - StorageUtil.GetIntValue(kMaster, "_SD_iGoalSex")
	Int masterPunishNeed = StorageUtil.GetIntValue(kSlave, "_SD_iGoalPunish") - StorageUtil.GetIntValue(kMaster, "_SD_iGoalPunish")
	Int masterFoodNeed = StorageUtil.GetIntValue(kSlave, "_SD_iGoalFood") - StorageUtil.GetIntValue(kMaster, "_SD_iGoalFood")
	Int masterGoldNeed = StorageUtil.GetIntValue(kSlave, "_SD_iGoalGold") - StorageUtil.GetIntValue(kMaster, "_SD_iGoalGold")
	int masterNeedRange =  StorageUtil.GetIntValue(kMaster, "_SD_iNeedRange")
	int masterTrustRange =  StorageUtil.GetIntValue(kMaster, "_SD_iTrustRange")

	int iSexComplete = 0
	int iPunishComplete = 0
	int iFoodComplete = 0
	int iGoldComplete = 0

	UpdateSlaveryLevel(kSlave)
	UpdateSlaveryRelationshipType(kMaster, kSlave)

	; If slavery level changed, display new level info
	If (slaveryLevel != StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryLevel"))
		DisplaySlaveryLevel(  kMaster, kSlave)
		slaveryLevel = StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryLevel")
	EndIf

	; Default privileges unlocked per level
	If (slaveryLevel >= 1)
		UpdateSlavePrivilege(kSlave, "_SD_iEnableWait", True)
	EndIf
	
	; - Add tracking of master s needs, mood, trust
	; :: Compare slave counts against master needs (sex, punish, gold, food)
	; :: If counts lower than master personality type, master mood -2
	; Do not count negative disposition for missing food and gold targets at early slavery stages
	If (masterSexNeed < (-1 * masterNeedRange))
		masterDisposition -= 1
	EndIf
	If (masterPunishNeed <  (-1 * masterNeedRange))
		masterDisposition -= 1
	EndIf
	If (masterGoldNeed <  (-1 * masterNeedRange)) && (slaveryLevel >= 1)
		masterDisposition -= 1
	EndIf
	If (masterFoodNeed <  (-1 * masterNeedRange)) && (slaveryLevel >= 2)
		masterDisposition -= 1
	EndIf

	; :: If counts match master personality type, master mood +1
	If (masterSexNeed >= (-1 * masterNeedRange)) && (masterSexNeed <= masterNeedRange)
		masterDisposition += 2
		iSexComplete += 1
	EndIf
	If (masterPunishNeed >= (-1 * masterNeedRange)) && (masterPunishNeed <= masterNeedRange)
		masterDisposition += 2
		iPunishComplete += 1
	EndIf
	If (masterGoldNeed >= (-1 * masterNeedRange)) && (masterGoldNeed <= masterNeedRange) 
		masterDisposition += 2
		iFoodComplete += 1
	EndIf
	If (masterFoodNeed >= (-1 * masterNeedRange)) && (masterFoodNeed <= masterNeedRange) 
		masterDisposition += 2
		iGoldComplete += 1
	EndIf

	; :: If counts exceed master personality, master mood +2
	If (masterSexNeed > masterNeedRange)
		masterDisposition += 4
		iSexComplete += 2 
	EndIf
	If (masterPunishNeed > masterNeedRange)
		masterDisposition += 4
		iPunishComplete += 2 
	EndIf
	If (masterGoldNeed > masterNeedRange) 
		masterDisposition += 4
		iFoodComplete += 2
	EndIf
	If (masterFoodNeed > masterNeedRange) 
		masterDisposition += 4
		iGoldComplete += 2 
	EndIf

	; - Master personality profile
	; If (masterPersonalityType == 0) ; 0 - Simple profile. No additional constraints
	If (masterPersonalityType == 1) ; 1 - Comfortable - Must complete or exceed food goal
		if (iFoodComplete > 0)
			masterDisposition += 3
		EndIf
	ElseIf (masterPersonalityType == 2) ; 2 - Horny - Must complete or exceed sex goal
		if (iSexComplete > 0)
			masterDisposition += 3
		EndIf
	ElseIf (masterPersonalityType == 3) ; 3 - Sadistic - Must complete or exceed punishment goals
		if (iPunishComplete > 0)
			masterDisposition += 3
		EndIf
	ElseIf (masterPersonalityType == 4) ; 4 - Gambler - Must complete or exceed gold goals.
		if (iGoldComplete > 0)
			masterDisposition += 3
		EndIf
	ElseIf (masterPersonalityType == 5) ; 5 - Caring - Seeks full compliance for one goal at least
		if (iFoodComplete == 1) || (iGoldComplete == 1) || (iPunishComplete == 1) || (iGoldComplete == 1)
			masterDisposition += 3
		EndIf
	ElseIf (masterPersonalityType == 6) ; 6 - Perfectionist - Seeks full compliance for all goals
		if (iFoodComplete == 1) && (iGoldComplete == 1) && (iPunishComplete == 1) && (iGoldComplete == 1)
			masterDisposition += 3
		EndIf
	EndIf

	; :: If master mood between -5 and +5, trust +1
	if (masterDisposition >= (-1 * masterTrustRange) ) && (masterDisposition <= masterTrustRange)
		StorageUtil.SetIntValue(kSlave, "_SD_iTrustPoints", StorageUtil.GetIntValue(kSlave, "_SD_iTrustPoints") + 1 )
	EndIf

	masterTrust = StorageUtil.GetIntValue(kSlave, "_SD_iTrustPoints") - StorageUtil.GetIntValue(kMaster, "_SD_iTrustThreshold") 

	StorageUtil.SetIntValue(kMaster, "_SD_iDisposition", masterDisposition)
	StorageUtil.SetIntValue(kMaster, "_SD_iTrust", masterTrust)

	if (masterTrust > 0)
		StorageUtil.SetIntValue(kSlave, "_SD_iTimeBuffer", StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryLevel") * 10)  
		StorageUtil.SetIntValue(kMaster,"_SD_iFollowSlave", 1)
		StorageUtil.SetIntValue(kSlave, "_SD_iLeashLength", StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryLevel") * 100)
	Else
		StorageUtil.SetIntValue(kSlave, "_SD_iTimeBuffer", StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryLevel") * 5)  
		StorageUtil.SetIntValue(kMaster,"_SD_iFollowSlave", 0)
		StorageUtil.SetIntValue(kSlave, "_SD_iLeashLength", 150 + StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryLevel") * 50)
	EndIf

	If fctFactions.checkIfFalmer (  kMaster ) 
		; Falmers follow slave by default
		StorageUtil.SetIntValue(kMaster,"_SD_iFollowSlave", 1)
	EndIf

	; Reset daily counts for slave
	StorageUtil.SetIntValue(kSlave, "_SD_iSexCountToday", 0)
	StorageUtil.SetIntValue(kSlave, "_SD_iPunishmentCountToday", 0)
	StorageUtil.SetIntValue(kSlave, "_SD_iSubmissiveCountToday", 0)
	StorageUtil.SetIntValue(kSlave, "_SD_iAngerCountToday", 0)
	StorageUtil.SetIntValue(kSlave, "_SD_iGoalSex", 0)
	StorageUtil.SetIntValue(kSlave, "_SD_iGoalPunishment", 0)
	StorageUtil.SetIntValue(kSlave, "_SD_iGoalFood", 0)
	StorageUtil.SetIntValue(kSlave, "_SD_iGoalGold", 0)

	; :: End of the day, if master unhappy, trust * 0.8 (cooldown)
	if (masterDisposition < 0)
		StorageUtil.SetIntValue(kSlave, "_SD_iTrustPoints", StorageUtil.GetIntValue(kSlave, "_SD_iTrustPoints") * 8 / 10 )
	EndIf

	overallMasterDisposition = StorageUtil.GetIntValue(kMaster, "_SD_iOverallDisposition")
	If (StorageUtil.GetIntValue(kMaster, "_SD_iDisposition") < 0)
		overallMasterDisposition -= 1
	Else
		overallMasterDisposition += 1
	EndIf
	StorageUtil.SetIntValue(kMaster, "_SD_iOverallDisposition", overallMasterDisposition)

 	SlaveryRefreshGlobalValues( kMaster, kSlave)

	; Debug.Notification("[SD] master needs: " + masterSexNeed + " "  + masterPunishNeed + " " + masterFoodNeed + " " + masterGoldNeed )
	; Debug.Notification("[SD] Master: OverallDisposition: " + overallMasterDisposition + " - GoldTotal: " + StorageUtil.GetIntValue(kMaster, "_SD_iGoldCountTotal"))
	; Debug.Notification("[SD] Master: Mood: " + masterDisposition + " - Trust: " + masterTrust + " - Type: " + masterPersonalityType)

	String statusSex = "Horny - "
	String statusPunishment = "Vicious \n"
	String statusFood = "Hungry - "
	String statusGold = "Greedy \n"
	String statusMood = "Angry - "
	String statusTrust = "Suspicious \n"

	If (iSexComplete==1)
		statusSex = ""
	Endif
	If (iPunishComplete==1)
		statusPunishment = ""
	Endif
	If (iFoodComplete==1)
		statusFood = ""
	Endif
	If (iGoldComplete==1)
		statusGold = ""
	Endif
	If (masterDisposition>=0)
		statusMood = "Happy - "
	EndIf
	If (masterTrust>=0)
		statusTrust = "Trusting \n"
	Endif

	Debug.Messagebox("It's a new day as a slave.\n Today your owner is .. \n" + statusSex + statusPunishment + statusFood + statusGold + statusMood + statusTrust )

	StorageUtil.SetStringValue(kSlave, "_SD_sSlaveryStatus", "It's a new day as a slave.\n Today your owner is .. \n" + statusSex + statusPunishment + statusFood + statusGold + statusMood + statusTrust)

	Debug.Trace("[SD] --- Slavery update" )
	Debug.Trace("[SD] Master: OverallDisposition: " + overallMasterDisposition + " - GoldTotal: " + StorageUtil.GetIntValue(kMaster, "_SD_iGoldCountTotal"))
	Debug.Trace("[SD] Master: Mood: " + masterDisposition + " - Trust: " + masterTrust + " - Type: " + masterPersonalityType)
	Debug.Trace("[SD] masterSexNeed: " + masterSexNeed )
	Debug.Trace("[SD] masterPunishNeed: " + masterPunishNeed )
	Debug.Trace("[SD] masterFoodNeed: " + masterFoodNeed )
	Debug.Trace("[SD] masterGoldNeed: " + masterGoldNeed )
	Debug.Trace("[SD] masterNeedRange: " + masterNeedRange )
	Debug.Trace("[SD] masterTrustRange: " + masterTrustRange )
	Debug.Trace("[SD] iSexComplete: " + iSexComplete )
	Debug.Trace("[SD] iPunishComplete: " + iPunishComplete )
	Debug.Trace("[SD] iFoodComplete: " + iFoodComplete )
	Debug.Trace("[SD] iGoldComplete: " + iGoldComplete )

EndFunction

; add/remove outfit items and punishment devices

function DisplaySlaveryLevel( Actor kMaster, Actor kSlave )
	int slaveryLevel = StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryLevel")
	int masterPersonalityType = StorageUtil.GetIntValue(kMaster, "_SD_iPersonalityProfile")

	If (slaveryLevel == 1) ; collared but resisting
		Debug.MessageBox("As the cold iron clamps shut around your neck and wrists, you are now at the mercy of your new owner. You feel exposed and helpless. The rage of defeat fuels your desire to escape at the first occasion. ")
			
	ElseIf (slaveryLevel == 2) ; not resisting but sobbing
		If (masterPersonalityType == 0) || (masterPersonalityType == 5) || (masterPersonalityType == 6)
			; 0 - Simple profile. No additional constraints
			; 5 - Caring - Seeks full compliance for one goal at least
			; 6 - Perfectionist - Seeks full compliance for all goals
			Debug.MessageBox("The succession of rapes and punishments starts giving way to more mundane tasks. If you don't loose yourself first, your only option is to play along and wait for the right time to take action. ")

		ElseIf (masterPersonalityType == 1) ||  (masterPersonalityType == 2) ||  (masterPersonalityType == 3) ||  (masterPersonalityType == 4)
			; 1 - Comfortable - Must complete or exceed food goal
			; 2 - Horny - Must complete or exceed sex goal
			; 3 - Sadistic - Must complete or exceed punishment goals
			; 4 - Gambler - Must complete or exceed gold goals.
			Debug.MessageBox("The succession of rapes and punishments threaten to break your resolve. If you don't loose yoursel first, your only option is to learn more about your owner and wait for the right time to take action. ")
 
		EndIf
	ElseIf (slaveryLevel == 3) ; accepting fate
		If (masterPersonalityType == 0) ; 0 - Simple profile. No additional constraints
			Debug.MessageBox("The reality of your situation starts to sink in. Escaping the grasp of your owner will take more time than you were hoping for. Maybe if you became useful, your owner will become distracted long enough for you to escape or even strike back.")

		ElseIf (masterPersonalityType == 1) ; 1 - Comfortable - Must complete or exceed food goal
			Debug.MessageBox("The reality of your situation starts to sink in. Escaping the grasp of your owner will take more time than you were hoping for. Surely, tending to your owner's needs will buy you enough time to find a way to escape or even strike back. ")
			
		ElseIf (masterPersonalityType == 2) ; 2 - Horny - Must complete or exceed sex goal
			Debug.MessageBox("The reality of your situation starts to sink in. Escaping the grasp of your owner will take more time than you were hoping for. Surely, tending to your owner's needs will buy you enough time to find a way to escape or even strike back. ")
			
		ElseIf (masterPersonalityType == 3) ; 3 - Sadistic - Must complete or exceed punishment goals
			Debug.MessageBox("The reality of your situation starts to sink in. Escaping the grasp of your owner will take more time than you were hoping for. Surely, keeping your owner happy will buy you enough time to find a way to escape or even strike back. ")
			
		ElseIf (masterPersonalityType == 4) ; 4 - Gambler - Must complete or exceed gold goals.
			Debug.MessageBox("The reality of your situation starts to sink in. Escaping the grasp of your owner will take more time than you were hoping for. Surely, keeping your owner happy will buy you enough time to find a way to escape or even strike back. ")
			
		ElseIf (masterPersonalityType == 5) ; 5 - Caring - Seeks full compliance for one goal at least
			Debug.MessageBox("The reality of your situation starts to sink in. Escaping the grasp of your owner will take more time than you were hoping for. If you pretend to comply, you may distract your owner long enough to escape or even strike back. ")
			
		ElseIf (masterPersonalityType == 6) ; 6 - Perfectionist - Seeks full compliance for all goals
			Debug.MessageBox("The reality of your situation starts to sink in. Escaping the grasp of your owner will take more time than you were hoping for. If you pretend to comply, you may distract your owner long enough to escape or even strike back. ")
			
		EndIf	 
	ElseIf (slaveryLevel == 4) ; not too bad after all
		Debug.MessageBox("You desperately try to keep the idea of an escape alive as you are going through the motions of serving your owner. If only you could earn your keep long enough to become a trusted slave...")
			
	ElseIf (slaveryLevel == 5) ; getting to enjoy it
		Debug.MessageBox("The collar locked around your neck feels strangely familiar. Freedom feels like a distant memory. An echo of your former life. You are meant to serve.. that much is clear by now. Better make the best of it.")
			
	ElseIf (slaveryLevel == 6) ; totally submissive, masochist and sex addict 
		Debug.MessageBox("Serving your owner in every way possible makes you so happy. The crawings burning deep inside you are satisfied only when you feel your owner's whip marking your skin or, even better, when you are finally allowed to serve your owner sexually. ")
			
	EndIf
	
EndFunction

Float Function GetEnslavementDuration(Actor kSlave)
	Return ( _SDGVP_gametime.GetValue() -	StorageUtil.GetFloatValue(kSlave, "_SD_fEnslavedGameTime" ) )
EndFunction

SexLabFrameWork Property SexLab Auto

GlobalVariable Property _SDGVP_gametime  Auto  
GlobalVariable Property _SDGVP_enslaved  Auto  
GlobalVariable Property _SDGVP_can_join  Auto  
 
GlobalVariable Property _SDGVP_config_min_slavery_level Auto
GlobalVariable Property _SDGVP_config_max_slavery_level Auto
GlobalVariable Property _SDGVP_config_slavery_level_mult Auto

GlobalVariable Property _SDGVP_MasterDisposition  Auto  
GlobalVariable Property _SDGVP_MasterDispositionOverall  Auto  
GlobalVariable Property _SDGVP_MasterTrust  Auto  
GlobalVariable Property _SDGVP_MasterPersonalityType  Auto  
GlobalVariable Property _SDGVP_MasterNeedFood  Auto  
GlobalVariable Property _SDGVP_MasterNeedGold  Auto  
GlobalVariable Property _SDGVP_MasterNeedSex  Auto  
GlobalVariable Property _SDGVP_MasterNeedPunishment  Auto  
GlobalVariable Property _SDGVP_SlaveryLevel  Auto  


