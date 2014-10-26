Scriptname _sdqs_fcts_slavery extends Quest  

_SDQS_fcts_constraints Property fctConstraints  Auto
_SDQS_fcts_outfit Property fctOutfit  Auto

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

	; API variables
	StorageUtil.SetIntValue(kSlave, "_SD_iEnslaved", 1)
	StorageUtil.SetFormValue(kSlave, "_SD_CurrentOwner", kMaster)
	StorageUtil.SetFormValue(kSlave, "_SD_DesiredOwner", None)

	StorageUtil.SetIntValue(kSlave, "_SD_iSlaveTimeBuffer", 20)  ; number of seconds allowed away from Master
	StorageUtil.SetIntValue(kMaster,"_SD_iMasterFollowSlave", 0)

	StorageUtil.SetFormValue(kSlave, "_SD_LeashCenter", kMaster)
	StorageUtil.SetIntValue(kSlave, "_SD_iLeashLength", 200)
	StorageUtil.SetStringValue(kSlave, "_SD_sSlaveDefaultStance", "Kneeling")

	StorageUtil.SetFloatValue(kSlave, "_SD_fLastEnslavedGameTime", StorageUtil.GetFloatValue(kSlave, "_SD_fEnslavedGameTime"))
	StorageUtil.SetFloatValue(kSlave, "_SD_fEnslavedGameTime", _SDGVP_gametime.GetValue())
	StorageUtil.SetFloatValue(kSlave, "_SD_fPunishmentGameTime", 0.0)
	StorageUtil.SetFloatValue(kSlave, "_SD_fPunishmentDuration", 0.0)

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
	If (!StorageUtil.HasIntValue(kMaster, "_SD_iMasterDisposition"))
		If (StorageUtil.GetIntValue(kMaster, "_SD_iForcedSlavery") == 1)
			StorageUtil.SetIntValue(kMaster, "_SD_iMasterDisposition", Utility.RandomInt(-5,10)   )
		else
			StorageUtil.SetIntValue(kMaster, "_SD_iMasterDisposition", Utility.RandomInt(-10,5)   )
		EndIf
	Else
		StorageUtil.SetIntValue(kMaster, "_SD_iMasterDisposition", StorageUtil.GetIntValue(kMaster, "_SD_iMasterDisposition") * 2   )
	EndIf

	; Master need and trust ranges - plus or minus value around 0
	; Some masters are easier to please than others
	If (!StorageUtil.HasIntValue(kMaster, "_SD_iMasterNeedRange"))
		StorageUtil.SetIntValue(kMaster, "_SD_iMasterNeedRange", Utility.RandomInt(2,5)   )
	EndIf
	; Some masters are easier to convince than others
	If (!StorageUtil.HasIntValue(kMaster, "_SD_iMasterTrustRange"))
		StorageUtil.SetIntValue(kMaster, "_SD_iMasterTrustRange", Utility.RandomInt(5,15)   )
	EndIf

	StorageUtil.SetIntValue(kMaster, "_SD_iMasterGoalFood", Utility.RandomInt(5,10))
	StorageUtil.SetIntValue(kMaster, "_SD_iMasterGoalSex",  Utility.RandomInt(5,10))
	StorageUtil.SetIntValue(kMaster, "_SD_iMasterGoalPunishment",  Utility.RandomInt(5,10))
	StorageUtil.SetIntValue(kMaster, "_SD_iMasterGoalGold",  Utility.RandomInt(15,50))
	; Special needs based on faction
	; Special items (firewood, ingredients)
	; Blood feedings (Vampire)

	; Slave daily progress
	StorageUtil.SetIntValue(kSlave, "_SD_iSlaveGoalFood", 0)
	StorageUtil.SetIntValue(kSlave, "_SD_iSlaveGoalSex", 0)
	StorageUtil.SetIntValue(kSlave, "_SD_iSlaveGoalPunishment", 0)
	StorageUtil.SetIntValue(kSlave, "_SD_iSlaveGoalGold", 0)

	; Master trust - number of merit points necessary for master to trust slave
	If (!StorageUtil.HasIntValue(kMaster, "_SD_iMasterTrustThreshold"))
		StorageUtil.SetIntValue(kMaster, "_SD_iMasterTrustThreshold", 20 )
	else
		StorageUtil.SetIntValue(kMaster, "_SD_iMasterTrustThreshold", StorageUtil.GetIntValue(kMaster, "_SD_iMasterTrustThreshold") + 10)
	EndIf

	; Slave privileges
	StorageUtil.SetIntValue(kSlave, "_SD_iSlaveMeritPoints", 0)  ; Trust earned by slave

	; StorageUtil.SetIntValue(kSlave, "_SD_iSlaveEnableLeash", 1)
	UpdateSlavePrivilege(kSlave, "_SD_iSlaveEnableLeash", True)

	; StorageUtil.SetIntValue(kSlave, "_SD_iSlaveEnableStand", 0)
	UpdateSlavePrivilege(kSlave, "_SD_iSlaveEnableStand", False)
	; StorageUtil.SetIntValue(kSlave, "_SD_iSlaveEnableMovement", 0)
	UpdateSlavePrivilege(kSlave, "_SD_iSlaveEnableMovement", False)
	; StorageUtil.SetIntValue(kSlave, "_SD_iSlaveEnableAction", 0)
	UpdateSlavePrivilege(kSlave, "_SD_iSlaveEnableAction", False)
	; StorageUtil.SetIntValue(kSlave, "_SD_iSlaveEnableFight", 0)
	UpdateSlavePrivilege(kSlave, "_SD_iSlaveEnableFight", False)

	; StorageUtil.SetIntValue(kSlave, "_SD_iSlaveEnableInventory", 0)
	UpdateSlavePrivilege(kSlave, "_SD_iSlaveEnableInventory", False)
	; StorageUtil.SetIntValue(kSlave, "_SD_iSlaveEnableSprint", 0)
	UpdateSlavePrivilege(kSlave, "_SD_iSlaveEnableSprint", False)
	; StorageUtil.SetIntValue(kSlave, "_SD_iSlaveEnableRideHorse", 0)
	UpdateSlavePrivilege(kSlave, "_SD_iSlaveEnableRideHorse", False)
	; StorageUtil.SetIntValue(kSlave, "_SD_iSlaveEnableFastTravel", 0)
	UpdateSlavePrivilege(kSlave, "_SD_iSlaveEnableFastTravel", False)
	; StorageUtil.SetIntValue(kSlave, "_SD_iSlaveEnableWait", 0)
	UpdateSlavePrivilege(kSlave, "_SD_iSlaveEnableWait", False)

	; StorageUtil.SetIntValue(kSlave, "_SD_iSlaveEnableSpellEquip", 0)
	UpdateSlavePrivilege(kSlave, "_SD_iSlaveEnableSpellEquip", False)
	; StorageUtil.SetIntValue(kSlave, "_SD_iSlaveEnableShoutEquip", 0)
	UpdateSlavePrivilege(kSlave, "_SD_iSlaveEnableShoutEquip", False)
	; StorageUtil.SetIntValue(kSlave, "_SD_iSlaveEnableClothingEquip", 0)
	UpdateSlavePrivilege(kSlave, "_SD_iSlaveEnableClothingEquip", False)
	; StorageUtil.SetIntValue(kSlave, "_SD_iSlaveEnableArmorEquip", 0)
	UpdateSlavePrivilege(kSlave, "_SD_iSlaveEnableArmorEquip", False)
	; StorageUtil.SetIntValue(kSlave, "_SD_iSlaveEnableWeaponEquip", 0)
	UpdateSlavePrivilege(kSlave, "_SD_iSlaveEnableWeaponEquip", False)
	; StorageUtil.SetIntValue(kSlave, "_SD_iSlaveEnableMoney", 0)
	UpdateSlavePrivilege(kSlave, "_SD_iSlaveEnableMoney", False)

	; Compatibility with other mods
	StorageUtil.StringListAdd(kMaster, "_DDR_DialogExclude", "SD+:Master")
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
	_SDGVP_enslaved.SetValue( 0 )

	; Compatibility with other mods
	StorageUtil.StringListRemove(kMaster, "_DDR_DialogExclude", "SD+:Master")
EndFunction

; I know - these two functions could be turned into one. I am keeping them separate for now in case I need to treat master and slave differently later on

; modify master status ( disposition amount, trust amount )
; modify master goal (goal ID, amount)
function UpdateMasterValue( Actor kMaster, string modVariable, int modValue =0, int setNewValue =0)

	; _SD_iMasterDisposition
	; _SD_iMasterTrustThreshold
	; _SD_iMasterGoalFood
	; _SD_iMasterGoalSex
	; _SD_iMasterGoalPunishment
 	; _SD_iMasterGoalGold

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
	; _SD_iSlaveMeritPoints
	; _SD_iSlaveTimeBuffer
	; _SD_iSlaveGoalFood
	; _SD_iSlaveGoalSex
	; _SD_iSlaveGoalPunishment
	; _SD_iSlaveGoalGold

	if (modValue != 0)
		StorageUtil.SetIntValue(kSlave, modVariable, StorageUtil.GetIntValue(kSlave, modVariable) + modValue )
	elseif (setNewValue != 0)
		StorageUtil.SetIntValue(kSlave, modVariable, setNewValue )
	endif

EndFunction

; fctSlavery.UpdateSlaveStatus(kSlave, "_SD_iSlaveGoalSex", modValue = 1)
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
	Bool enableMove = StorageUtil.GetIntValue(kSlave,"_SD_iSlaveEnableMovement") as Bool
	Bool enableAct = StorageUtil.GetIntValue(kSlave,"_SD_iSlaveEnableAction") as Bool
	Bool enableFight = StorageUtil.GetIntValue(kSlave,"_SD_iSlaveEnableFight") as Bool

	If (modVariable == "_SD_iSlaveEnableLeash")
			StorageUtil.SetIntValue(kSlave, modVariable,  modValue as Int)

			; fctConstraints.playerAutoPilot(modValue)  - not necessary for now
	EndIf

	If (modVariable == "_SD_iSlaveEnableMovement")
			StorageUtil.SetIntValue(kSlave, modVariable,  modValue as Int)
			enableMove = modValue
			fctConstraints.togglePlayerControlsOn(abMove = enableMove, abAct = enableAct, abFight = enableFight)
	EndIf

	If (modVariable == "_SD_iSlaveEnableAction")
			StorageUtil.SetIntValue(kSlave, modVariable,  modValue as Int)
			enableAct = modValue
			fctConstraints.togglePlayerControlsOn(abMove = enableMove, abAct = enableAct, abFight = enableFight)
	EndIf

	If (modVariable == "_SD_iSlaveEnableFight")
			StorageUtil.SetIntValue(kSlave, modVariable,  modValue as Int)
			enableFight = modValue
			fctConstraints.togglePlayerControlsOn(abMove = enableMove, abAct = enableAct, abFight = enableFight)
	EndIf

	If (modVariable == "_SD_iSlaveEnableInventory")
			StorageUtil.SetIntValue(kSlave, modVariable,  modValue as Int)
			; See - http://www.creationkit.com/RegisterForMenu_-_Form
			; Register for menus and exit menu if not allowed
			; See example from SD and crafting
			; List of menus - http://www.creationkit.com/UI_Script
	EndIf

	If (modVariable == "_SD_iSlaveEnableSprint")
			StorageUtil.SetIntValue(kSlave, modVariable,  modValue as Int)
			; How to disable?
	EndIf

	If (modVariable == "_SD_iSlaveEnableRideHorse")
			StorageUtil.SetIntValue(kSlave, modVariable,  modValue as Int)
			; How to disable? Detect if riding mount and force dismount?
			; See - http://www.creationkit.com/IsOnMount_-_Actor
	EndIf

	If (modVariable == "_SD_iSlaveEnableFastTravel")
			StorageUtil.SetIntValue(kSlave, modVariable,  modValue as Int)

			if (modValue)
				; Enable fast travel
				Game.EnableFastTravel()
			else
				; Disable fast travel
				Game.EnableFastTravel(false)
			endif
	EndIf

	If (modVariable == "_SD_iSlaveEnableWait")
			StorageUtil.SetIntValue(kSlave, modVariable,  modValue as Int)

			if (modValue)
				; Disable waiting
				Game.SetInChargen(false, false, false)
			Else
				Game.SetInChargen(false, true, true)
			EndIf
	EndIf


	If (modVariable == "_SD_iSlaveEnableSpellEquip")
			StorageUtil.SetIntValue(kSlave, modVariable,  modValue as Int)
			; Augment OnEquip event for slave based on this storageUtil value
	EndIf

	If (modVariable == "_SD_iSlaveEnableShoutEquip")
			StorageUtil.SetIntValue(kSlave, modVariable,  modValue as Int)
			; Augment OnEquip event for slave based on this storageUtil value
	EndIf

	If (modVariable == "_SD_iSlaveEnableClothingEquip")
			StorageUtil.SetIntValue(kSlave, modVariable,  modValue as Int)
			; Augment OnEquip event for slave based on this storageUtil value
	EndIf

	If (modVariable == "_SD_iSlaveEnableArmorEquip")
			StorageUtil.SetIntValue(kSlave, modVariable,  modValue as Int)
			; Augment OnEquip event for slave based on this storageUtil value
	EndIf

	If (modVariable == "_SD_iSlaveEnableWeaponEquip")
			StorageUtil.SetIntValue(kSlave, modVariable,  modValue as Int)
			; Augment OnEquip event for slave based on this storageUtil value
	EndIf

	If (modVariable == "_SD_iSlaveEnableMoney")
			StorageUtil.SetIntValue(kSlave, modVariable,  modValue as Int)
			; Augment OnItemAdded event for slave based on this storageUtil value
	EndIf

 

EndFunction

; Slavery has to be initiated using SendStory. 
; Remember to use StopSlavery to clean things up before transfer to new master

; refreshGlobalValues() - map some storageUtil values to GlobalValues for use with dialogue conditions
function SlaveryRefreshGlobalValues( Actor kMaster, Actor kSlave)


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

	Debug.Notification("[_sdqs_fcts_slavery] SLavery exposure: " + StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryExposure"))
	Debug.Notification("[_sdqs_fcts_slavery] SLavery level: " + StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryLevel"))
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

	Int masterTrust = StorageUtil.GetIntValue(kSlave, "_SD_iSlaveTrustPoints") - StorageUtil.GetIntValue(kMaster, "_SD_iMasterTrustThreshold") 
	Int masterDisposition = StorageUtil.GetIntValue(kMaster, "_SD_iMasterDisposition")
	int masterPersonalityType = StorageUtil.GetIntValue(kMaster, "_SD_iPersonalityProfile")
	Int masterSexNeed = StorageUtil.GetIntValue(kSlave, "_SD_iSlaveGoalSex") - StorageUtil.GetIntValue(kMaster, "_SD_iMasterGoalSex")
	Int masterPunishNeed = StorageUtil.GetIntValue(kSlave, "_SD_iSlaveGoalPunish") - StorageUtil.GetIntValue(kMaster, "_SD_iMasterGoalPunish")
	Int masterFoodNeed = StorageUtil.GetIntValue(kSlave, "_SD_iSlaveGoalFood") - StorageUtil.GetIntValue(kMaster, "_SD_iMasterGoalFood")
	Int masterGoldNeed = StorageUtil.GetIntValue(kSlave, "_SD_iSlaveGoalGold") - StorageUtil.GetIntValue(kMaster, "_SD_iMasterGoalGold")
	int masterNeedRange =  StorageUtil.GetIntValue(kMaster, "_SD_iMasterNeedRange")
	int masterTrustRange =  StorageUtil.GetIntValue(kMaster, "_SD_iMasterTrustRange")

	int iSexComplete = 0
	int iPunishComplete = 0
	int iFoodComplete = 0
	int iGoldComplete = 0

	Debug.Trace("[SD] --- Slavery update" )
	Debug.Trace("[SD] before masterDisposition: " + masterDisposition)
	Debug.Trace("[SD] before masterTrust: " + masterTrust )
	Debug.Trace("[SD] masterPersonalityType: " + masterPersonalityType )
	Debug.Trace("[SD] masterSexNeed: " + masterSexNeed )
	Debug.Trace("[SD] masterPunishNeed: " + masterPunishNeed )
	Debug.Trace("[SD] masterFoodNeed: " + masterFoodNeed )
	Debug.Trace("[SD] masterGoldNeed: " + masterGoldNeed )
	Debug.Trace("[SD] masterNeedRange: " + masterNeedRange )
	Debug.Trace("[SD] masterTrustRange: " + masterTrustRange )

	Debug.Notification("[SD] master needs: " + masterSexNeed + " "  + masterPunishNeed + " " + masterFoodNeed + " " + masterGoldNeed )

	UpdateSlaveryLevel(kSlave)
	UpdateSlaveryRelationshipType(kMaster, kSlave)

	; - Add tracking of master s needs, mood, trust
	; :: Compare slave counts against master needs (sex, punish, gold, food)
	; :: If counts lower than master personality type, master mood -2
	If (masterSexNeed < (-1 * masterNeedRange))
		masterDisposition -= 2
	EndIf
	If (masterPunishNeed <  (-1 * masterNeedRange))
		masterDisposition -= 2
	EndIf
	If (masterGoldNeed <  (-1 * masterNeedRange))
		masterDisposition -= 2
	EndIf
	If (masterFoodNeed <  (-1 * masterNeedRange))
		masterDisposition -= 2
	EndIf

	; :: If counts match master personality type, master mood +1
	If (masterSexNeed >= (-1 * masterNeedRange)) && (masterSexNeed <= masterNeedRange)
		masterDisposition += 1
		iSexComplete += 1
	EndIf
	If (masterPunishNeed >= (-1 * masterNeedRange)) && (masterPunishNeed <= masterNeedRange)
		masterDisposition += 1
		iPunishComplete += 1
	EndIf
	If (masterGoldNeed >= (-1 * masterNeedRange)) && (masterGoldNeed <= masterNeedRange)
		masterDisposition += 1
		iFoodComplete += 1
	EndIf
	If (masterFoodNeed >= (-1 * masterNeedRange)) && (masterFoodNeed <= masterNeedRange)
		masterDisposition += 1
		iGoldComplete += 1
	EndIf

	; :: If counts exceed master personality, master mood +2
	If (masterSexNeed > masterNeedRange)
		masterDisposition += 2
		iSexComplete += 2 
	EndIf
	If (masterPunishNeed > masterNeedRange)
		masterDisposition += 2
		iPunishComplete += 2 
	EndIf
	If (masterGoldNeed > masterNeedRange)
		masterDisposition += 2
		iFoodComplete += 2
	EndIf
	If (masterFoodNeed > masterNeedRange)
		masterDisposition += 2
		iGoldComplete += 2 
	EndIf

	Debug.Trace("[SD] iSexComplete: " + iSexComplete )
	Debug.Trace("[SD] iPunishComplete: " + iPunishComplete )
	Debug.Trace("[SD] iFoodComplete: " + iFoodComplete )
	Debug.Trace("[SD] iGoldComplete: " + iGoldComplete )

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

	StorageUtil.SetIntValue(kMaster, "_SD_iMasterDisposition", masterDisposition)

	; :: If master mood between -5 and +5, trust +1
	if (masterDisposition >= (-1 * masterTrustRange) ) && (masterDisposition <= masterTrustRange)
		StorageUtil.SetIntValue(kSlave, "_SD_iSlaveTrustPoints", StorageUtil.GetIntValue(kSlave, "_SD_iSlaveTrustPoints") + 1 )
	EndIf

	masterTrust = StorageUtil.GetIntValue(kSlave, "_SD_iSlaveTrustPoints") - StorageUtil.GetIntValue(kMaster, "_SD_iMasterTrustThreshold") 

	if (masterTrust > 0)
		StorageUtil.SetIntValue(kSlave, "_SD_iSlaveTimeBuffer", StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryLevel") * 10)  
		StorageUtil.SetIntValue(kMaster,"_SD_iMasterFollowSlave", 1)
		StorageUtil.SetIntValue(kSlave, "_SD_iLeashLength", StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryLevel") * 100)
	Else
		StorageUtil.SetIntValue(kSlave, "_SD_iSlaveTimeBuffer", StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryLevel") * 5)  
		StorageUtil.SetIntValue(kMaster,"_SD_iMasterFollowSlave", 0)
		StorageUtil.SetIntValue(kSlave, "_SD_iLeashLength", 150 + StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryLevel") * 50)
	EndIf

	Debug.Notification("[SD] masterDisposition: " + masterDisposition + " - masterTrust: " + masterTrust )

	Debug.Trace("[SD] after masterDisposition: " + masterDisposition + " - masterTrust: " + masterTrust )
EndFunction

; automatic refresh - updateStatusDaily() - make duration configurable in MCM 
function UpdateStatusDaily( Actor kMaster, Actor kSlave)
	Int masterDisposition = StorageUtil.GetIntValue(kMaster, "_SD_iMasterDisposition")
	int masterTrustRange =  StorageUtil.GetIntValue(kMaster, "_SD_iMasterTrustRange")

	; Refresh latest status
	UpdateStatusHourly(  kMaster,  kSlave)

	; Daily specific updates

	; Reset daily counts for slave
	StorageUtil.SetIntValue(kSlave, "_SD_iSexCountToday", 0)
	StorageUtil.SetIntValue(kSlave, "_SD_iPunishmentCountToday", 0)
	StorageUtil.SetIntValue(kSlave, "_SD_iSubmissiveCountToday", 0)
	StorageUtil.SetIntValue(kSlave, "_SD_iAngerCountToday", 0)
	StorageUtil.SetIntValue(kSlave, "_SD_iSlaveGoalSex", 0)
	StorageUtil.SetIntValue(kSlave, "_SD_iSlaveGoalPunishment", 0)
	StorageUtil.SetIntValue(kSlave, "_SD_iSlaveGoalFood", 0)
	StorageUtil.SetIntValue(kSlave, "_SD_iSlaveGoalGold", 0)

	; :: End of the day, if master unhappy, trust * 0.8 (cooldown)
	if (masterDisposition < (-1 * masterTrustRange))
		StorageUtil.SetIntValue(kSlave, "_SD_iSlaveTrustPoints", StorageUtil.GetIntValue(kSlave, "_SD_iSlaveTrustPoints") * 8 / 10 )
	EndIf
EndFunction

; add/remove outfit items and punishment devices

function DisplaySlaveryLevel( Actor kMaster, Actor kSlave )
	int slaveryLevel = StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryLevel")
	int masterPersonalityType = StorageUtil.GetIntValue(kMaster, "_SD_iPersonalityProfile")

	If (slaveryLevel == 1) ; collared but resisting
		Debug.MessageBox("As the cold iron clams shut around your neck and wrists, you are now at the mercy of your new owner. You feel exposed and helpless. The rage of defeat fuels your desire to escape at the first occasion. ")
			
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

SexLabFrameWork Property SexLab Auto

GlobalVariable Property _SDGVP_gametime  Auto  
GlobalVariable Property _SDGVP_enslaved  Auto  
