Scriptname _sdqs_fcts_slavery extends Quest  

_SDQS_functions Property funct  Auto
_SDQS_fcts_constraints Property fctConstraints  Auto
_SDQS_fcts_outfit Property fctOutfit  Auto
_SDQS_fcts_factions Property fctFactions  Auto
zbfSlaveControl Property ZazSlaveControl Auto
_SDQS_enslavement Property enslavement  Auto

SexLabFrameWork Property SexLab Auto

GlobalVariable Property _SDGVP_gametime  Auto  
GlobalVariable Property _SDGVP_enslaved  Auto  
GlobalVariable Property _SDGVP_can_join  Auto  
GlobalVariable Property _SDGVP_sanguine_blessings Auto  
GlobalVariable Property _SDGVP_enslavedCount  Auto  
GlobalVariable Property _SDGVP_falmerEnslavedCount  Auto  
GlobalVariable Property _SDGVP_CurrentTaskID  Auto  
GlobalVariable Property _SDGVP_CurrentTaskStatus  Auto  

 
GlobalVariable Property _SDGVP_config_min_slavery_level Auto
GlobalVariable Property _SDGVP_config_max_slavery_level Auto
GlobalVariable Property _SDGVP_config_slavery_level_mult Auto
GlobalVariable Property _SDGVP_config_min_days_before_master_travel Auto
GlobalVariable Property _SDGVP_isMasterTraveller  Auto  

GlobalVariable Property _SDGVP_MasterDisposition  Auto  
GlobalVariable Property _SDGVP_MasterDispositionOverall  Auto  
GlobalVariable Property _SDGVP_MasterTrust  Auto  
GlobalVariable Property _SDGVP_MasterPersonalityType  Auto  
GlobalVariable Property _SDGVP_MasterNeedFood  Auto  
GlobalVariable Property _SDGVP_MasterNeedGold  Auto  
GlobalVariable Property _SDGVP_MasterNeedSex  Auto  
GlobalVariable Property _SDGVP_MasterNeedPunishment  Auto  
GlobalVariable Property _SDGVP_SlaveryLevel  Auto  
GlobalVariable Property _SDGVP_state_caged  Auto 

Keyword Property _SDTSK_BRING_FOOD  Auto  
Keyword Property _SDTSK_BRING_GOLD  Auto  
Keyword Property _SDTSK_BRING_ARMOR  Auto  
Keyword Property _SDTSK_BRING_WEAPON  Auto  
Keyword Property _SDTSK_BRING_INGREDIENT  Auto  
Keyword Property _SDTSK_BRING_FIREWOOD  Auto 
Keyword Property _SDTSK_BRING_BOOK  Auto  
Keyword Property _SDTSK_ENTERTAIN_DANCE  Auto  
Keyword Property _SDTSK_ENTERTAIN_SOLO  Auto  
Keyword Property _SDTSK_ENTERTAIN_SEX Auto  
Keyword Property _SDTSK_INSPECTION  Auto  
Keyword Property _SDTSK_TRAINING_ANAL  Auto  
Keyword Property _SDTSK_TRAINING_VAGINAL  Auto  
Keyword Property _SDTSK_TRAINING_ORAL  Auto  
Keyword Property _SDTSK_TRAINING_POSTURE  Auto  
Keyword Property _SDTSK_WASH  Auto  
Keyword Property _SDTSK_IGNORE  Auto  



 
Quest Property slaveryQuest  Auto  

; Properties redefined to allow upgrade to SD+ V3 without a need for a new save game
; Older properties may have None value baked into save game at this point
; _SDQS_fcts_constraints Property fctConstraintsV3  Auto
; _SDQS_fcts_outfit Property fctOutfitV3  Auto
; _SDQS_fcts_factions Property fctFactionsV3  Auto

Keyword Property ActorTypeNPC  Auto  

Int iNumberTasks 
Int iDaysPassed 
Float fTimePassed 
int iGameDateLastCheck = -1
int iDaysSinceLastCheck
int iCountSinceLastCheck
int iHoursLastCheck 
float TaskTickerLastCallTime = 0.0
float TaskTickerThisCallTime = 0.0
float TaskTickerPeriod = 0.05  ; ingame time (days) for Hourly ticker, about 0.04 is enough


function InitSlaveryState( Actor kSlave )
	; Called during SD initialization - Sanguine is watching
	_SDGVP_enslaved.SetValue( 0 )
	StorageUtil.SetIntValue(kSlave, "_SD_iAPIInit", 1)

	if (!StorageUtil.GetIntValue( none, "_SD_iSanguine")==1)
	    Debug.Notification("$[SD] SD+ IS INSTALLING. ")
	    Debug.Notification("$MAKE SURE TO SAVE AND RELOAD ONCE ALL MESSAGES HAVE STOPPED." )
	EndIf

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
	StorageUtil.SetIntValue(kSlave, "_SD_iDisableFollowerAutoKneeling", 0)
 	StorageUtil.SetIntValue(kSlave, "_SD_iDisableDreamworldOnSleep", 0)
 
EndFunction



function StartSlavery( Actor kMaster, Actor kSlave)


	_SDGVP_enslaved.SetValue( 1 )
	_SDGVP_can_join.SetValue( 0 )
	
	; API variables
	StorageUtil.SetIntValue(kSlave, "_SD_iSold", 0)
	StorageUtil.SetIntValue(kSlave, "_SD_iEnslaved", 1)
	If StorageUtil.HasIntValue(kSlave, "_SD_iEnslavedCount")
		StorageUtil.SetIntValue(kMaster, "_SD_iSlaverCount", StorageUtil.GetIntValue(kMaster, "_SD_iSlaverCount") + 1)
		StorageUtil.SetIntValue(kSlave, "_SD_iEnslavedCount", StorageUtil.GetIntValue(kSlave, "_SD_iEnslavedCount") + 1)
		_SDGVP_enslavedCount.SetValue(StorageUtil.GetIntValue(kSlave, "_SD_iEnslavedCount"))
	Else
		StorageUtil.SetIntValue(kMaster, "_SD_iSlaverCount", 1)
		StorageUtil.SetIntValue(kSlave, "_SD_iEnslavedCount", 1)
		_SDGVP_enslavedCount.SetValue(StorageUtil.GetIntValue(kSlave, "_SD_iEnslavedCount"))
	EndIf

	StorageUtil.SetFormValue(kSlave, "_SD_CurrentOwner", kMaster)
	StorageUtil.SetFormValue(kSlave, "_SD_DesiredOwner", None)

	StorageUtil.SetIntValue(kSlave, "_SD_iTimeBuffer", 30)  ; number of seconds allowed away from Master

	StorageUtil.SetIntValue(kMaster,"_SD_iFollowSlave", 0)

	StorageUtil.SetFormValue(kSlave, "_SD_LeashCenter", kMaster)
	StorageUtil.SetIntValue(kSlave, "_SD_iLeashLength", 200)
	StorageUtil.SetStringValue(kSlave, "_SD_sExpectedStance", "Standing")
	StorageUtil.SetStringValue(kSlave, "_SD_sDefaultStance", "Kneeling")
	StorageUtil.SetStringValue(kSlave, "_SD_sDefaultStanceFollower", "Kneeling" )

	StorageUtil.SetFloatValue(kSlave, "_SD_fLastEnslavedGameTime", StorageUtil.GetFloatValue(kSlave, "_SD_fEnslavedGameTime"))
	StorageUtil.SetFloatValue(kSlave, "_SD_fEnslavedGameTime", _SDGVP_gametime.GetValue())
	StorageUtil.SetFloatValue(kSlave, "_SD_fEnslavementDuration", 0.0)
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

	If (!StorageUtil.HasIntValue(kSlave, "_SD_iSlaveryLevel")) || (StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryLevel") <= 0)
		StorageUtil.SetIntValue(kSlave, "_SD_iSlaveryLevel", 1)
	EndIf
	If (!StorageUtil.HasIntValue(kSlave, "_SD_iSlaveryExposure")) || (StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryExposure") <= 0)
		StorageUtil.SetIntValue(kSlave, "_SD_iSlaveryExposure", 1)
	EndIf
	
	StorageUtil.SetIntValue(kSlave, "_SD_iSanguineBlessings", _SDGVP_sanguine_blessings.GetValue() as Int )
	; Tracking also _SD_iSub and _SD_iDom (through the player's answers to Resist or Submit menus

	If (fctFactions.checkIfSlaverCreatureRace( kMaster))
		StorageUtil.SetIntValue(kMaster, "_SD_iMasterIsCreature", 1)
	else
		StorageUtil.SetIntValue(kMaster, "_SD_iMasterIsCreature", 0)
	endif

	; - Master personality profile
	; StorageUtil.SetIntValue(kMaster, "_SD_iPersonalityProfile", 6 )
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

		If (StorageUtil.GetIntValue(kMaster, "_SD_iMasterIsCreature")==0)

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
		else
			if (profileChance >= 95)
				StorageUtil.SetIntValue(kMaster, "_SD_iPersonalityProfile", 6 ) 
			elseif (profileChance >= 80)
				StorageUtil.SetIntValue(kMaster, "_SD_iPersonalityProfile", 5 ) 
			elseif (profileChance >= 50)
				StorageUtil.SetIntValue(kMaster, "_SD_iPersonalityProfile", 2 ) 
			elseif (profileChance >= 40)
				StorageUtil.SetIntValue(kMaster, "_SD_iPersonalityProfile", 1 ) 
			else
				StorageUtil.SetIntValue(kMaster, "_SD_iPersonalityProfile", 0 ) 
			endif
		EndIf

	EndIf

	If (_SDGVP_config_min_days_before_master_travel.GetValue()>0)
		StorageUtil.SetIntValue(kMaster, "_SD_iDaysBeforeTravel", Utility.RandomInt(1,5)   )
		_SDGVP_isMasterTraveller.SetValue(0)
	endif

	If (!StorageUtil.HasStringValue(kMaster, "_SD_sColorProfile"))
		int colorChance =  Utility.RandomInt(0,100)

		if (colorChance >= 60)
			StorageUtil.SetStringValue(kMaster, "_SD_sColorProfile", ",black" ) 
		elseif (colorChance >= 40)
			StorageUtil.SetStringValue(kMaster, "_SD_sColorProfile", ",red" ) 
		elseif (colorChance >= 20)
			StorageUtil.SetStringValue(kMaster, "_SD_sColorProfile", ",white" ) 
		endif
	EndIf

	If (kMaster.GetActorValue("Aggression")==3)
		kMaster.SetActorValue("Aggression",2)
	Endif

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

	StorageUtil.SetIntValue(kMaster, "_SD_iGoalSex",  Utility.RandomInt(2,5))
	StorageUtil.SetIntValue(kMaster, "_SD_iGoalPunishment",  Utility.RandomInt(1,5))
	StorageUtil.SetIntValue(kMaster, "_SD_iGoalFood", Utility.RandomInt(1,2))
	StorageUtil.SetIntValue(kMaster, "_SD_iGoalGold",  Utility.RandomInt(1,50))
	; Special needs based on faction
	; Special items (firewood, ingredients)
	; Blood feedings (Vampire)

	; Slave daily progress
	StorageUtil.SetIntValue(kSlave, "_SD_iGoalSex", 0)
	StorageUtil.SetIntValue(kSlave, "_SD_iGoalPunishment", 0)
	StorageUtil.SetIntValue(kSlave, "_SD_iGoalFood", 0)
	StorageUtil.SetIntValue(kSlave, "_SD_iGoalGold", 0)

	; Master trust - number of merit points necessary for master to trust slave
	If (!StorageUtil.HasIntValue(kMaster, "_SD_iTrustThreshold"))
		StorageUtil.SetIntValue(kMaster, "_SD_iTrustThreshold", 10 )
	else
		StorageUtil.SetIntValue(kMaster, "_SD_iTrustThreshold", StorageUtil.GetIntValue(kMaster, "_SD_iTrustThreshold") + 3)
	EndIf

	StorageUtil.SetIntValue(kMaster, "_SD_iTrust", 2 - Utility.RandomInt(0, 5))  
	StorageUtil.SetIntValue(kSlave, "_SD_iTrustPoints", 2 - Utility.RandomInt(0, 5))  

	; Slave privileges
	StorageUtil.SetIntValue(kSlave, "_SD_iMeritPoints", 0)  ; Trust earned by slave

	StorageUtil.SetIntValue(kSlave, "_SD_iHandsFree", 0)

	; StorageUtil.SetIntValue(kSlave, "_SD_iEnableLeash", 1)
	UpdateSlavePrivilege(kSlave, "_SD_iEnableLeash", True)

	; StorageUtil.SetIntValue(kSlave, "_SD_iEnableStand", 0)
	UpdateSlavePrivilege(kSlave, "_SD_iEnableStand", True)
	UpdateSlavePrivilege(kSlave, "_SD_iEnableKneel", True)
	UpdateSlavePrivilege(kSlave, "_SD_iEnableCrawl", True)
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

	; Outfit selection - Commoner by default
	int outfitID = 0
	ActorBase PlayerBase = Game.GetPlayer().GetActorBase()

	fctOutfit.setMasterGearByRace ( kMaster, kSlave  )

	Form masterRace = StorageUtil.GetFormValue(kSlave, "_SD_fSlaveryGearRace")

	; Set slave constraints based on master's race
	if (masterRace!= none) && ((StorageUtil.GetStringValue( masterRace, "_SD_sRaceType") == "Beast"  ) || (StorageUtil.GetStringValue( masterRace, "_SD_sRaceType") == "Humanoid"  ))
		debugTrace(" Master race found - using racial settings for " + masterRace)
		StorageUtil.SetIntValue(kSlave, "_SD_iSlaveryCollarOn", StorageUtil.GetIntValue(masterRace, "_SD_iSlaveryCollarOn") )
		StorageUtil.SetIntValue(kSlave, "_SD_iSlaveryBindingsOn",  StorageUtil.GetIntValue(masterRace, "_SD_iSlaveryBindingsOn"))
		StorageUtil.SetIntValue(kSlave, "_SD_iSlaveryPunishmentOn",  StorageUtil.GetIntValue(masterRace, "_SD_iSlaveryPunishmentOn"))
		StorageUtil.SetIntValue(kSlave, "_SD_iSlaveryPunishmentSceneOn",  StorageUtil.GetIntValue(masterRace, "_SD_iSlaveryPunishmentSceneOn"))
		StorageUtil.SetIntValue(kSlave, "_SD_iSlaveryWhippingSceneOn",  StorageUtil.GetIntValue(masterRace, "_SD_iSlaveryWhippingSceneOn"))

		StorageUtil.SetStringValue(kSlave, "_SD_sSlaveryExpectedStance",  StorageUtil.GetStringValue(masterRace, "_SD_sSlaveryDefaultStance"))
		StorageUtil.SetStringValue(kSlave, "_SD_sSlaveryDefaultStance",  StorageUtil.GetStringValue(masterRace, "_SD_sSlaveryDefaultStance"))
		StorageUtil.SetStringValue( kSlave, "_SD_sDefaultStance", StorageUtil.GetStringValue(masterRace, "_SD_sSlaveryDefaultStance"))

		StorageUtil.SetStringValue(kSlave, "_SD_sSlaverySlaveTat",  StorageUtil.GetStringValue(masterRace, "_SD_sSlaverySlaveTat"))
		StorageUtil.SetIntValue(kSlave, "_SD_iSlaverySlaveTatDuration",  StorageUtil.GetIntValue(masterRace, "_SD_iSlaverySlaveTatDuration"))
	else
		If (fctFactions.checkIfNPC ( kMaster )) ; Defaults for humanoid masters
			debugTrace(" Master race not recognized - using default settings for humanoids " )
			StorageUtil.SetIntValue(kSlave, "_SD_iSlaveryCollarOn", 1 )
			StorageUtil.SetIntValue(kSlave, "_SD_iSlaveryBindingsOn",  1)
			StorageUtil.SetIntValue(kSlave, "_SD_iSlaveryPunishmentOn",  1)
			StorageUtil.SetIntValue(kSlave, "_SD_iSlaveryPunishmentSceneOn",  1)
			StorageUtil.SetIntValue(kSlave, "_SD_iSlaveryWhippingSceneOn",  1)

			; StorageUtil.SetStringValue(kSlave, "_SD_sSlaveryDefaultStance",  "Kneeling")
			; StorageUtil.SetStringValue( kSlave, "_SD_sDefaultStance", "Kneeling")
			StorageUtil.SetStringValue(kSlave, "_SD_sSlaveryExpectedStance",  "Standing")
			StorageUtil.SetStringValue(kSlave, "_SD_sSlaveryDefaultStance",  "Standing")
			StorageUtil.SetStringValue( kSlave, "_SD_sDefaultStance", "Standing")

			StorageUtil.SetStringValue(kSlave, "_SD_sSlaverySlaveTat",  "")
			StorageUtil.SetIntValue(kSlave, "_SD_iSlaverySlaveTatDuration",  0)

		Else 									; Defaults for beast masters
			debugTrace(" Master race not recognized - using default settings for beasts " )
			StorageUtil.SetIntValue(kSlave, "_SD_iSlaveryCollarOn", 0 )
			StorageUtil.SetIntValue(kSlave, "_SD_iSlaveryBindingsOn",  0)
			StorageUtil.SetIntValue(kSlave, "_SD_iSlaveryPunishmentOn",  0)
			StorageUtil.SetIntValue(kSlave, "_SD_iSlaveryPunishmentSceneOn",  0)
			StorageUtil.SetIntValue(kSlave, "_SD_iSlaveryWhippingSceneOn",  0)

			; StorageUtil.SetStringValue(kSlave, "_SD_sSlaveryDefaultStance",  "Crawling")
			; StorageUtil.SetStringValue( kSlave, "_SD_sDefaultStance", "Crawling")
			StorageUtil.SetStringValue(kSlave, "_SD_sSlaveryExpectedStance",  "Standing")
			StorageUtil.SetStringValue(kSlave, "_SD_sSlaveryDefaultStance",  "Standing")
			StorageUtil.SetStringValue( kSlave, "_SD_sDefaultStance", "Standing")

			StorageUtil.SetStringValue(kSlave, "_SD_sSlaverySlaveTat",  "")
			StorageUtil.SetIntValue(kSlave, "_SD_iSlaverySlaveTatDuration",  0)
		EndIf
	EndIf

;	StorageUtil.SetIntValue(kMaster, "_SD_iOutfitID", outfitID)
;	StorageUtil.SetIntValue(kSlave, "_SD_iOutfitID", outfitID)
;	debugTrace(" Master outfit: " + outfitID)
;	debugTrace(" Init master devices: List count: " + StorageUtil.StringListCount( kMaster, "_SD_lDevices"))

	If fctFactions.checkIfFalmer ( kMaster)
		If StorageUtil.HasIntValue(kSlave, "_SD_iFalmerEnslavedCount")
			StorageUtil.SetIntValue(kSlave, "_SD_iFalmerEnslavedCount", StorageUtil.GetIntValue(kSlave, "_SD_iFalmerEnslavedCount") + 1)
			_SDGVP_falmerEnslavedCount.SetValue(StorageUtil.GetIntValue(kSlave, "_SD_iFalmerEnslavedCount"))
		Else
			StorageUtil.SetIntValue(kSlave, "_SD_iFalmerEnslavedCount", 1)
			_SDGVP_falmerEnslavedCount.SetValue(StorageUtil.GetIntValue(kSlave, "_SD_iFalmerEnslavedCount"))
		EndIf
	Endif


	; Compatibility with other mods
	StorageUtil.StringListAdd(kMaster, "_DDR_DialogExclude", "SD+:Master")
	StorageUtil.SetIntValue(kSlave, "_SD_iDisableDreamworldOnSleep", 1)
	StorageUtil.SetStringValue(kSlave, "_SD_sSleepPose", "ZazAPCAO009") ; default sleep pose - pillory idle
	ZazSlaveControl.EnslaveActor(kSlave,"SD")
	ZazSlaveControl.SetPlayerMaster(kMaster,"SD")

	UpdateStatusDaily(  kMaster,  kSlave, false)

	SendModEvent("SDEnslavedStart") 

EndFunction
 
function StopSlavery( Actor kMaster, Actor kSlave)


	; API variables
	StorageUtil.SetFormValue(kSlave, "_SD_LastOwner", kMaster)
	StorageUtil.SetFormValue(kSlave, "_SD_CurrentOwner", None)
	StorageUtil.SetFormValue(kSlave, "_SD_DesiredOwner", None)
	
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
	ZazSlaveControl.ReleaseSlave(kSlave,"SD",true)
	ZazSlaveControl.SetPlayerMaster(None,"SD")
	StorageUtil.StringListRemove(kMaster, "_DDR_DialogExclude", "SD+:Master")
	StorageUtil.SetIntValue(kSlave, "_SD_iDisableDreamworldOnSleep", 0)
	StorageUtil.SetStringValue(kSlave, "_SD_sSleepPose", "") ; default sleep pose - reset
	; StorageUtil.SetStringValue(kSlave, "_SD_sDefaultStance", "Standing")
	kSlave.SendModEvent( "PCSubStance" , "Standing")

	StorageUtil.FormListClear(kMaster, "_SD_lEnslavedFollower")
	ResetSlaveryTaskList(kSlave)  

	fctConstraints.UpdateStanceOverrides()

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
			fctConstraints.togglePlayerControlsOn(abMove = enableMove, abAct = enableAct, abFight = enableFight)
	EndIf

	If (modVariable == "_SD_iEnableAction")
			StorageUtil.SetIntValue(kSlave, modVariable,  modValue as Int)
			enableAct = modValue
			fctConstraints.togglePlayerControlsOn(abMove = enableMove, abAct = enableAct, abFight = enableFight)
			StorageUtil.SetIntValue(kSlave, "_SD_iHandsFree", enableAct as Int)
	EndIf

	If (modVariable == "_SD_iEnableFight")
			StorageUtil.SetIntValue(kSlave, modVariable,  modValue as Int)
			enableFight = modValue
			fctConstraints.togglePlayerControlsOn(abMove = enableMove, abAct = enableAct, abFight = enableFight)
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


	If (modVariable == "_SD_iEnableSpellEquip") || (modVariable == "_SD_iEnableShoutEquip") || (modVariable == "_SD_iEnableClothingEquip") ||(modVariable == "_SD_iEnableArmorEquip") || (modVariable == "_SD_iEnableWeaponEquip") || (modVariable == "_SD_iEnableMoney")
			StorageUtil.SetIntValue(kSlave, modVariable,  modValue as Int) 
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
	; StorageUtil.SetIntValue(kMaster, "_SD_iTrust", masterTrust)

	_SDGVP_MasterDisposition.SetValue( masterDisposition ) 
	_SDGVP_MasterDispositionOverall.SetValue( overallMasterDisposition ) 
	_SDGVP_MasterTrust.SetValue( masterTrust ) 
	_SDGVP_MasterPersonalityType.SetValue( masterPersonalityType ) 
	_SDGVP_MasterNeedFood.SetValue( masterFoodNeed ) 
	_SDGVP_MasterNeedGold.SetValue( masterGoldNeed ) 
	_SDGVP_MasterNeedSex.SetValue( masterSexNeed ) 
	_SDGVP_MasterNeedPunishment.SetValue( masterPunishNeed ) 
	_SDGVP_SlaveryLevel.SetValue( StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryLevel") )
	_SDGVP_sanguine_blessings.SetValue( StorageUtil.GetIntValue(kSlave, "_SD_iSanguineBlessings")  )
EndFunction

Function UpdateSlaveryLevel(Actor kSlave)
	Int exposure = StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryExposure")

	; Update exposure level
	If (exposure == 0) ; level 0 - free
		StorageUtil.SetIntValue(kSlave, "_SD_iSlaveryLevel", 0)
		; slaveryQuest.SetObjectiveDisplayed(9, abDisplayed = true)

	ElseIf (exposure >= 1) && (exposure <10) ; level 1 - rebelious
		StorageUtil.SetIntValue(kSlave, "_SD_iSlaveryLevel", 1)

	ElseIf (exposure >= 10) && (exposure <30) ; level 2 - reluctant
		StorageUtil.SetIntValue(kSlave, "_SD_iSlaveryLevel", 2)

	ElseIf (exposure >= 30) && (exposure <50) ; level 3 - accepting
		StorageUtil.SetIntValue(kSlave, "_SD_iSlaveryLevel", 3)

	ElseIf (exposure >= 50) && (exposure < 80) ; level 4 - not so bad 
		StorageUtil.SetIntValue(kSlave, "_SD_iSlaveryLevel", 4)

	ElseIf (exposure >= 80) && (exposure < 100) ; level 5 - getting to like it
		StorageUtil.SetIntValue(kSlave, "_SD_iSlaveryLevel", 5)

	ElseIf (exposure >= 100)  ; level 6 - begging for it
		StorageUtil.SetIntValue(kSlave, "_SD_iSlaveryLevel", 6)

	EndIf

	; Correct slavery level based on user preference
	If ( StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryLevel") < _SDGVP_config_min_slavery_level.GetValue() )
		StorageUtil.SetIntValue(kSlave, "_SD_iSlaveryLevel", _SDGVP_config_min_slavery_level.GetValue() as Int )
	EndIf

	If ( StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryLevel") > _SDGVP_config_max_slavery_level.GetValue() )
		StorageUtil.SetIntValue(kSlave, "_SD_iSlaveryLevel", _SDGVP_config_max_slavery_level.GetValue() as Int )
	EndIf

	debugTrace(" SLavery exposure: " + StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryExposure") + " - level: " + StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryLevel"))
EndFunction

Function UpdateSlaveryRelationshipType(Actor kMaster, Actor kSlave)
	Int exposure = StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryExposure")

	; Update exposure level
	If (exposure == 0) ; level 0 - free
		StorageUtil.SetIntValue(kMaster, "_SD_iRelationshipType", -5 )
	ElseIf (exposure >= 1) && (exposure <10) ; level 1 - rebelious
		StorageUtil.SetIntValue(kMaster, "_SD_iRelationshipType", -5 ) 
	ElseIf (exposure >= 10) && (exposure <20) ; level 2 - reluctant
		StorageUtil.SetIntValue(kMaster, "_SD_iRelationshipType", -6 ) 
	ElseIf (exposure >= 20) && (exposure <40) ; level 3 - accepting
		StorageUtil.SetIntValue(kMaster, "_SD_iRelationshipType", -6 ) 
	ElseIf (exposure >= 40) && (exposure < 80) ; level 4 - not so bad 
		StorageUtil.SetIntValue(kMaster, "_SD_iRelationshipType", -6 ) 
	ElseIf (exposure >= 80) && (exposure < 100) ; level 5 - getting to like it
		StorageUtil.SetIntValue(kMaster, "_SD_iRelationshipType", -7 ) 
	ElseIf (exposure >= 100)  ; level 6 - begging for it
		StorageUtil.SetIntValue(kMaster, "_SD_iRelationshipType", -7 ) 
	EndIf
EndFunction

; automatic refresh - updateStatusHourly() - refresh privileges and variables based on storageUtilValues
function UpdateStatusHourly( Actor kMaster, Actor kSlave)
	; Disabled for now - daily update makes more sense

EndFunction

; automatic refresh - updateStatusDaily() - make duration configurable in MCM 
function UpdateStatusDaily( Actor kMaster, Actor kSlave, Bool bDisplayStatus = true)
	int slaveryLevel = StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryLevel")
	Int exposure = StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryExposure")
	Int masterTrust = StorageUtil.GetIntValue(kSlave, "_SD_iTrustPoints") - StorageUtil.GetIntValue(kMaster, "_SD_iTrustThreshold") 
	Int masterDisposition = StorageUtil.GetIntValue(kMaster, "_SD_iDisposition")
	Int overallMasterDisposition = StorageUtil.GetIntValue(kMaster, "_SD_iOverallDisposition")
	int masterPersonalityType = StorageUtil.GetIntValue(kMaster, "_SD_iPersonalityProfile")
	Int masterSexNeed = StorageUtil.GetIntValue(kSlave, "_SD_iGoalSex") - StorageUtil.GetIntValue(kMaster, "_SD_iGoalSex")
	Int masterPunishNeed = StorageUtil.GetIntValue(kSlave, "_SD_iGoalPunishment") - StorageUtil.GetIntValue(kMaster, "_SD_iGoalPunishment")
	Int masterFoodNeed = StorageUtil.GetIntValue(kSlave, "_SD_iGoalFood") - StorageUtil.GetIntValue(kMaster, "_SD_iGoalFood")
	Int masterGoldNeed = StorageUtil.GetIntValue(kSlave, "_SD_iGoalGold") - StorageUtil.GetIntValue(kMaster, "_SD_iGoalGold")
	int masterNeedRange =  StorageUtil.GetIntValue(kMaster, "_SD_iNeedRange")
	int masterTrustRange =  StorageUtil.GetIntValue(kMaster, "_SD_iTrustRange")

	Int iSub = StorageUtil.GetIntValue( kSlave , "_SD_iSub")
	Int iDom = StorageUtil.GetIntValue( kSlave , "_SD_iDom") - 2 ; cooldown of dominance during slavery
	Int iDominance = iDom - iSub

	int iSexComplete = 0
	int iPunishComplete = 0
	int iFoodComplete = 0
	int iGoldComplete = 0
	
	if (iSub>10)
		iSub = 10
	elseif (iSub<-10)
		iSub = -10
	EndIf

	if (iDom>10)
		iDom = 10
	elseif (iDom<-10)
		iDom = -10
	EndIf

	StorageUtil.SetIntValue( kSlave , "_SD_iSub",iSub)
	StorageUtil.SetIntValue( kSlave , "_SD_iDom",iDom)

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
	If (masterSexNeed < 0)
		masterDisposition -= 1
	EndIf
	If (masterPunishNeed <  0)
		masterDisposition -= 1
	EndIf
	; Change of rules - food and gold goals are now optional at low levels
	; Masters will not be mad if you miss targets but they will be happy if you complete them
	If (masterFoodNeed <  0) && (slaveryLevel >= 1) && (slaveryLevel <= 5)
		masterDisposition -= 1
	EndIf
	If (masterGoldNeed <  0) && (slaveryLevel >= 2) && (slaveryLevel <= 5)
		masterDisposition -= 1
	EndIf


	; :: If counts match master personality type, master mood +1
	If (StorageUtil.GetIntValue(kSlave, "_SD_iGoalSex") > 0) && (masterSexNeed >= (-1 * masterNeedRange) ) && (masterSexNeed <= masterNeedRange)
	 	masterDisposition += 2
	 	iSexComplete += 1
	EndIf
	If (StorageUtil.GetIntValue(kSlave, "_SD_iGoalPunishment") > 0) && (masterPunishNeed >= (-1 * masterNeedRange) )  && (masterPunishNeed <= masterNeedRange) 
	 	masterDisposition += 2
		iPunishComplete += 1
	EndIf
	If (StorageUtil.GetIntValue(kSlave, "_SD_iGoalFood") > 0) && (masterFoodNeed >= (-1 * masterNeedRange) )  && (masterFoodNeed <= masterNeedRange) 
	 	masterDisposition += 2
	 	iFoodComplete += 1
	EndIf
	If (StorageUtil.GetIntValue(kSlave, "_SD_iGoalGold") > 0) && (masterGoldNeed >= (-5 * masterNeedRange) )  && (masterGoldNeed <= (masterNeedRange * 5)) 
	 	masterDisposition += 2
	 	iGoldComplete += 1
	EndIf


	; :: If counts exceed master personality, master mood +2
	If (masterSexNeed > masterNeedRange)
		masterDisposition += 2
		iSexComplete += 1 
	EndIf
	If (masterPunishNeed > masterNeedRange) && (StorageUtil.GetIntValue(kMaster, "_SD_iMasterIsCreature")==0)
		masterDisposition += 2
		iPunishComplete += 1 
	EndIf
	If (masterFoodNeed > masterNeedRange) 
		masterDisposition += 2
		iFoodComplete += 1 
	EndIf
	If (masterGoldNeed > (masterNeedRange * 5))  && (StorageUtil.GetIntValue(kMaster, "_SD_iMasterIsCreature")==0)
		masterDisposition += 2
		iGoldComplete += 1
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
		if (iFoodComplete >= 1) || (iGoldComplete >= 1) || (iPunishComplete >= 1) || (iSexComplete >= 1)
			masterDisposition += 3
		EndIf
	ElseIf (masterPersonalityType == 6) ; 6 - Perfectionist - Seeks full compliance for all goals
		if (iFoodComplete >= 1) && (iGoldComplete >= 1) && (iPunishComplete >= 1) && (iSexComplete >= 1)
			masterDisposition += 3
		EndIf
	EndIf

	; Note for later - turn '10' limit into a Difficulty parameter
	if (masterDisposition>10)
		masterDisposition = 10
	elseif (masterDisposition<-10)
		masterDisposition = -10
	EndIf

	; :: If master mood > 0, trust +1
	if (masterDisposition >= 0)
		StorageUtil.SetIntValue(kSlave, "_SD_iTrustPoints", StorageUtil.GetIntValue(kSlave, "_SD_iTrustPoints") + 2 + (slaveryLevel / 2))
	EndIf

	if (iDominance>10)
		iDominance = 10
	elseif (iDominance<-10)
		iDominance = -10
	EndIf


	Int iTrustBonus = 0

	If (iDominance < 0)
		iTrustBonus += slaveryLevel
	Else
	;	iTrustBonus -= 2
	EndIf

	If (iFoodComplete>=1)
		iTrustBonus += 1
	Endif

	If (iGoldComplete>=1)
		iTrustBonus += 1
	Endif

	If (iPunishComplete>=1)
		iTrustBonus -= 1
	Endif

	StorageUtil.SetIntValue(kSlave, "_SD_iTrustPoints", StorageUtil.GetIntValue(kSlave, "_SD_iTrustPoints") + iTrustBonus)
	masterTrust = StorageUtil.GetIntValue(kSlave, "_SD_iTrustPoints") - StorageUtil.GetIntValue(kMaster, "_SD_iTrustThreshold")

	if (masterTrust>0)
		ModMasterTrust(kMaster, slaveryLevel)
	else
		ModMasterTrust(kMaster, -1 * slaveryLevel)
	endif

	StorageUtil.SetIntValue(kMaster, "_SD_iDisposition", masterDisposition)
	StorageUtil.SetIntValue(kSlave, "_SD_iDominance", iDominance)

	if (masterTrust > 0)
		StorageUtil.SetIntValue(kSlave, "_SD_iTimeBuffer", 20 + slaveryLevel * 10)  
		StorageUtil.SetIntValue(kMaster,"_SD_iFollowSlave", 1)
		StorageUtil.SetIntValue(kSlave, "_SD_iLeashLength", 300 + slaveryLevel * 100)
	Else
		StorageUtil.SetIntValue(kSlave, "_SD_iTimeBuffer", 10 + slaveryLevel * 5)  
		StorageUtil.SetIntValue(kMaster,"_SD_iFollowSlave", 0)
		StorageUtil.SetIntValue(kSlave, "_SD_iLeashLength", 150 + slaveryLevel * 50)
		StorageUtil.SetIntValue(kSlave, "_SD_iHandsFree", 0)
		StorageUtil.SetIntValue(kSlave, "_SD_iEnableWeaponEquip", 0)
	EndIf
 
	if (masterDisposition <= 0)
		StorageUtil.SetIntValue(kSlave, "_SD_iEnableClothingEquip", 0)
		StorageUtil.SetIntValue(kSlave, "_SD_iEnableArmorEquip", 0)
	EndIf

	If (StorageUtil.GetIntValue(kMaster, "_SD_iMasterIsCreature") == 1) 
		; Creatures follow slave by default
		StorageUtil.SetIntValue(kSlave,"_SD_iEnableLeash", 1)
		StorageUtil.SetIntValue(kMaster,"_SD_iFollowSlave", 1)
		StorageUtil.SetIntValue(kSlave, "_SD_iTimeBuffer", 10 + slaveryLevel * 10)  
		StorageUtil.SetIntValue(kSlave, "_SD_iLeashLength", 100 + slaveryLevel * 100)
	EndIf

	overallMasterDisposition = StorageUtil.GetIntValue(kMaster, "_SD_iOverallDisposition")

	Int iGoalsComplete = iSexComplete + iPunishComplete + iFoodComplete + iGoldComplete
	If ( iGoalsComplete >=2 ) || (masterDisposition > 0)
		overallMasterDisposition += 2
	ElseIf ( iGoalsComplete <= 1 )  || (masterDisposition < 0)
		overallMasterDisposition -= 1
	Else
		overallMasterDisposition += 1
	EndIf

	StorageUtil.SetIntValue(kMaster, "_SD_iOverallDisposition", overallMasterDisposition)
	StorageUtil.SetIntValue(kMaster, "_SD_iGoldCountTotal", 0)

 	SlaveryRefreshGlobalValues( kMaster, kSlave)

	; Debug.Notification("[SD] master needs: " + masterSexNeed + " "  + masterPunishNeed + " " + masterFoodNeed + " " + masterGoldNeed )
	; Debug.Notification("[SD] Master: OverallDisposition: " + overallMasterDisposition + " - GoldTotal: " + StorageUtil.GetIntValue(kMaster, "_SD_iGoldCountTotal"))
	; Debug.Notification("[SD] Master: Mood: " + masterDisposition + " - Trust: " + masterTrust + " - Type: " + masterPersonalityType)

	String statusSex = "Sex, "
	String statusPunishment = "Beating you, \n"
	String statusFood = "Food, "
	String statusGold = "Gold, \n"
	String statusMood = "Angry - "
	String statusTrust = "Suspicious \n"
	String statusDominance = "Submissive \n"

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
	If (iDominance>=0)
		statusDominance = "Defiant \n"
	Endif

	String statusMessage = "It's a new day as a slave." 

	; Keeping these messages for (simplified) display 
	statusMessage =  statusMessage + "\nDisposition: " + masterDisposition  + "\n(Overall: "  + overallMasterDisposition +"/"+ StorageUtil.GetIntValue(kMaster, "_SD_iDispositionThreshold") +")"
	statusMessage =  statusMessage + "\nDays enslaved: " + (StorageUtil.GetFloatValue(kSlave, "_SD_fEnslavementDuration") as Int) + "/" +  (StorageUtil.GetFloatValue(kMaster, "_SD_iMinJoinDays") as Int)

	if (StorageUtil.GetIntValue(kMaster, "_SD_iMasterIsCreature")!=1)
		if ((StorageUtil.GetFloatValue(kMaster, "_SD_iMasterBuyOut") as Int)<=0)
			statusMessage =  statusMessage + "\nBuyout gold : " + ( -1 * (StorageUtil.GetFloatValue(kMaster, "_SD_iMasterBuyOut") as Int)) + " to go"
		else
			statusMessage =  statusMessage + "\nBuyout gold : " + (StorageUtil.GetFloatValue(kMaster, "_SD_iMasterBuyOut") as Int) + " over"
		EndIf
	Endif

	If (StorageUtil.GetIntValue(kMaster, "_SD_iTrust")>0)
		statusMessage =  statusMessage + "\nAllowance: " + StorageUtil.GetIntValue(kMaster, "_SD_iTrust")  + " hours free."
	else
		statusMessage =  statusMessage + "\nAllowance: " + -1 * StorageUtil.GetIntValue(kMaster, "_SD_iTrust")  + " hours owed."
	EndIf

	statusMessage =  statusMessage + "\nYou are mostly " + statusDominance + " (" + iDominance + ")"
	statusMessage =  statusMessage + "\nSlavery level: " + slaveryLevel 

	If (bDisplayStatus)
		Debug.Messagebox(statusMessage)
	Endif

	; StorageUtil.SetStringValue(kSlave, "_SD_sSlaveryStatus", statusMessage)

	; Keeping these messages for trace only
	statusMessage =  statusMessage + "\n Today your owner needs .. \n" + statusSex + statusPunishment + statusFood + statusGold + statusMood + statusTrust
	statusMessage =  statusMessage + "\n Trust: " + masterTrust 
	statusMessage =  statusMessage + "\n (Exposure: " + exposure + ")"

	debugTrace(" --- Slavery update" )
	debugTrace(" " + statusMessage)
	debugTrace(" Slavery level: " + slaveryLevel  + " (Exposure: " + exposure + ")")
	debugTrace(" iSexComplete: " + iSexComplete + " Count: " + StorageUtil.GetIntValue(kSlave, "_SD_iGoalSex") + " / " + StorageUtil.GetIntValue(kMaster, "_SD_iGoalSex") + " - Need: " + masterSexNeed + " +/- " + masterNeedRange)
	debugTrace(" iPunishComplete: " + iPunishComplete  + " Count: " + StorageUtil.GetIntValue(kSlave, "_SD_iGoalPunishment") + " / " + StorageUtil.GetIntValue(kMaster, "_SD_iGoalPunishment") + " - Need: " + masterPunishNeed + " +/- " + masterNeedRange)
	debugTrace(" iFoodComplete: " + iFoodComplete  + " Count: " + StorageUtil.GetIntValue(kSlave, "_SD_iGoalFood") + " / " + StorageUtil.GetIntValue(kMaster, "_SD_iGoalFood") + " - Need: " + masterFoodNeed + " +/- " + masterNeedRange)
	debugTrace(" iGoldComplete: " + iGoldComplete  + " Count: " + StorageUtil.GetIntValue(kSlave, "_SD_iGoalGold") + " / " + StorageUtil.GetIntValue(kMaster, "_SD_iGoalGold") + " - Need: " + masterGoldNeed + " +/- " + masterNeedRange)
	debugTrace(" Master: Mood: " + masterDisposition + " - Trust: " + masterTrust + " - Personality Type: " + masterPersonalityType)
	debugTrace(" Master: Overall Disposition: " + overallMasterDisposition )
	debugTrace(" Master: Slave trust points: " + StorageUtil.GetIntValue(kSlave, "_SD_iTrustPoints") + " - Master trust threshold: " + StorageUtil.GetIntValue(kMaster, "_SD_iTrustThreshold") )
	debugTrace(" Master: GoldTotal: " + StorageUtil.GetIntValue(kMaster, "_SD_iGoldCountTotal"))


EndFunction


function ResetDailyCounts( Actor kMaster, Actor kSlave)

	; Reset daily counts for slave
	StorageUtil.SetIntValue(kSlave, "_SD_iSexCountToday", 0)
	StorageUtil.SetIntValue(kSlave, "_SD_iPunishmentCountToday", 0)
	StorageUtil.SetIntValue(kSlave, "_SD_iSubmissiveCountToday", 0)
	StorageUtil.SetIntValue(kSlave, "_SD_iAngerCountToday", 0)
	StorageUtil.SetIntValue(kSlave, "_SD_iGoalSex", 0)
	StorageUtil.SetIntValue(kSlave, "_SD_iGoalPunishment", 0)
	StorageUtil.SetIntValue(kSlave, "_SD_iGoalFood", 0)
	StorageUtil.SetIntValue(kSlave, "_SD_iGoalGold", 0)

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
		Debug.MessageBox("Serving your owner in every way possible makes you so happy. The cravings burning deep inside you are satisfied only when you feel your owner's whip marking your skin or, even better, when you are finally allowed to serve your owner sexually. ")
		
	EndIf
	
EndFunction

function DisplaySlaveryLevelObjective( Actor kMaster, Actor kSlave, Quest qSlaveryQuest )
	int slaveryLevel = StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryLevel")
	int masterPersonalityType = StorageUtil.GetIntValue(kMaster, "_SD_iPersonalityProfile")


	if (StorageUtil.GetIntValue(kSlave, "_SD_iEnslaved") == 1)
		qSlaveryQuest.SetObjectiveDisplayed(21, abDisplayed = false)
		qSlaveryQuest.SetObjectiveDisplayed(22, abDisplayed = false)
		qSlaveryQuest.SetObjectiveDisplayed(23, abDisplayed = false)
		qSlaveryQuest.SetObjectiveDisplayed(24, abDisplayed = false)
		qSlaveryQuest.SetObjectiveDisplayed(25, abDisplayed = false)
		qSlaveryQuest.SetObjectiveDisplayed(26, abDisplayed = false)

		If (slaveryLevel == 1) ; collared but resisting
			slaveryQuest.SetStage(21)

		ElseIf (slaveryLevel == 2) ; not resisting but sobbing
			slaveryQuest.SetStage(22)

		ElseIf (slaveryLevel == 3) ; accepting fate
			slaveryQuest.SetStage(23)

		ElseIf (slaveryLevel == 4) ; not too bad after all
			slaveryQuest.SetStage(24)

		ElseIf (slaveryLevel == 5) ; getting to enjoy it
			slaveryQuest.SetStage(25)

		ElseIf (slaveryLevel == 6) ; totally submissive, masochist and sex addict 
			slaveryQuest.SetStage(26)

		EndIf
	endif
	
EndFunction

Int Function ModMasterTrust(Actor kMaster, int iModValue)
	Actor kPlayer = Game.GetPlayer()
	Int iSlaveryLevel = StorageUtil.GetIntValue(kPlayer, "_SD_iSlaveryLevel")
	Int iTrust = StorageUtil.GetIntValue(kMaster, "_SD_iTrust")  
	Int iMaxTrust = 50
	Int iMinTrust = -50

	If (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved") == 0)
		; Catch calls when slave has been released
		Return iTrust
	Endif

	; double penalty if player is not in same cell as master
	If (kPlayer.GetParentCell() != kMaster.GetParentCell())
		iModValue = iModValue * 2
	Endif

	debugTrace(" Trust pool before update: " + iTrust)

	iTrust = iTrust + iModValue

	If (StorageUtil.GetIntValue(kMaster, "_SD_iOverallDisposition")>2)
		iMaxTrust = 10 + iSlaveryLevel * 10
		iMinTrust = -10
	else
		iMaxTrust = 10  
		iMinTrust = -10 - (6 - iSlaveryLevel) * 10
	endif

	if (iTrust>iMaxTrust) ; 2 days * 24 hours = 48 points
		iTrust = iMaxTrust
	elseif (iTrust<iMinTrust)
		iTrust = iMinTrust
	EndIf

	StorageUtil.SetIntValue(kMaster, "_SD_iTrust", iTrust)
	Debug.Notification("[SD] Slave allowance points: " + iTrust)

	debugTrace(" Trust pool after update: " + iTrust + "(Min:" + iMinTrust + " / Max:" + iMaxTrust + ")")

	Return iTrust
EndFunction

function InitPunishmentIdle( )
	Actor kPlayer = Game.getPlayer()
	ObjectReference kPlayerRef = Game.getPlayer() as ObjectReference
	Int iRandomNum  

	debugTrace(" Init punishment idles")

	if (StorageUtil.StringListCount( kPlayer, "_SD_lPunishmentsIndoors") == 0)
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPCAO301")
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPCAO302")
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPCAO303")
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPCAO304")
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPCAO305")
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPC019")
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPCAO001") ;   AnimObjectZazAPCAO001		PostGibbetKneel				
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPCAO002") ;   AnimObjectZazAPCAO002		PostGibbetSit			
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPCAO003") ;   AnimObjectZazAPCAO003		PostGibbetStand
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPCAO004") ;   AnimObjectZazAPCAO004		PostGibbetStandHandsBehind
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPCAO005") ;   AnimObjectZazAPCAO005		WallGibbetKneel	
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPCAO006") ;   AnimObjectZazAPCAO006		WallGibbetSit
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPCAO007") ;   AnimObjectZazAPCAO007		WallGibbetStand
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPCAO008") ;   AnimObjectZazAPCAO008		WallGibbetStandHandsBehind
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPCAO011") ;   AnimObjectZazAPCAO011		PostRestraintStandHandBehind
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPCAO012") ;   AnimObjectZazAPCAO012		PostRestraintKneelHandBehind
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPCAO013") ;   AnimObjectZazAPCAO013		PostRestraintStandHandSpread
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPCAO014") ;   AnimObjectZazAPCAO014		PostRestraintStandHandUp
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPCAO015") ;   AnimObjectZazAPCAO015		PostRestraintUpsideDown
 		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPCAO016") ;   AnimObjectZazAPCAO016		PostRestraintDisplayed
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPCAO017") ;   AnimObjectZazAPCAO017		WallRestraintStandHandBehind
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPCAO018") ;   AnimObjectZazAPCAO018		WallRestraintKneelHandBehind
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPCAO019") ;   AnimObjectZazAPCAO019		WallRestraintStandHandSpread
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPCAO020") ;   AnimObjectZazAPCAO020		WallRestraintStandHandUp
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPCAO021") ;   AnimObjectZazAPCAO021		WallRestraintUpsideDown
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPCAO022") ;   AnimObjectZazAPCAO022		WallRestraintDisplayed
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPCAO023") ;   AnimObjectZazAPCAO023		Vertical Pillory
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPCAO201") ;   AnimObjectZazAPCAO201		FacingPostStand
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPCAO202") ;   AnimObjectZazAPCAO202		BackFacingPostStand
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPCAO203") ;   AnimObjectZazAPCAO203		BackFacingPostHung
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPCAO204") ;   AnimObjectZazAPCAO204		BackFacingPostKneel
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPCAO205") ;   AnimObjectZazAPCAO205		BackFacingPostSit
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPCAO251") ;   AnimObjectZazAPCAO251		Normal
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPCAO252") ;   AnimObjectZazAPCAO252		KneesBent
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPC006") ;  		HandsBehindSitFloor						
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPC007") ;  		HandsBehindSitFloorLegSpread					
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPC008") ;  		HandsBehindSitFloorKneestoChest					
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPC009") ;  		HandsBehindSitFloorKneestoChestLegSpread			
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPC010") ;  		HandsBehindSitFloorSide						
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPC011") ;  		HandsBehindLieFaceDown						
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPC012") ;  		HandsBehindLieSide						
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPC013") ;  		HandsBehindLieFaceUp						
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPC014") ;  		HandsBehindLieSideCurlUp					
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPC015") ; 		HandsBehindLieHogtieFaceDown					
 		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPC016") ;  		HandsBehindKneelHigh						
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPC017") ;  		HandsBehindKneelHighLegSpread					
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPC018") ;  		HandsBehindKneelLow
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPC019") ;  		HandsBehindKneelLegSpread					
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPC020") ;  	    HandsBehindKneelBowDown
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPC054") ;  		HandsBehindLieFaceUpLegsSpread-Struggle I
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPC055") ;  		HandsBehindLieFaceUpLegsSpread-Struggle II
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPC056") ;  		HogTieFaceDownLegsSpread
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPC057") ;  		FrogTieFaceDownStruggle
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsIndoors", "ZazAPC058") ;  		HandsBehindKneel
 	EndIf

	if (StorageUtil.StringListCount( kPlayer, "_SD_lPunishmentsOutdoors") == 0)
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsOutdoors", "ZazAPCAO014")
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsOutdoors", "ZazAPCAO011")
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsOutdoors", "ZazAPCAO201")
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsOutdoors", "ZazAPCAO203")
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsOutdoors", "ZazAPCAO201")
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsOutdoors", "ZazAPCAO016")
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsOutdoors", "ZazAPCAO009") ;  AnimObjectZazAPCAO009		PilloryIdle	
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsOutdoors", "ZazAPCAO010") ;   AnimObjectZazAPCAO010		PilloryPose
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsOutdoors", "ZazAPCAO024") ;   AnimObjectZazAPCAO024		Wooden Horse
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsOutdoors", "ZazAPCAO025") ;   AnimObjectZazAPCAO025		X Cross
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsOutdoors", "ZazAPCAO261") ;   AnimObjectZazAPCAO261		NormalWheel
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsOutdoors", "ZazAPCAO262") ;   AnimObjectZazAPCAO262		HighWheel
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsOutdoors", "ZazAPCAO263") ;   AnimObjectZazAPCAO263		Tilted Wheel	
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsOutdoors", "ZazAPC006") ;  		HandsBehindSitFloor						
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsOutdoors", "ZazAPC007") ;  		HandsBehindSitFloorLegSpread					
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsOutdoors", "ZazAPC008") ;  		HandsBehindSitFloorKneestoChest					
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsOutdoors", "ZazAPC009") ;  		HandsBehindSitFloorKneestoChestLegSpread			
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsOutdoors", "ZazAPC010") ;  		HandsBehindSitFloorSide						
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsOutdoors", "ZazAPC011") ;  		HandsBehindLieFaceDown						
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsOutdoors", "ZazAPC012") ;  		HandsBehindLieSide						
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsOutdoors", "ZazAPC013") ;  		HandsBehindLieFaceUp						
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsOutdoors", "ZazAPC014") ;  		HandsBehindLieSideCurlUp					
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsOutdoors", "ZazAPC015") ;  		HandsBehindLieHogtieFaceDown					
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsOutdoors", "ZazAPC016") ;  		HandsBehindKneelHigh						
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsOutdoors", "ZazAPC017") ;  		HandsBehindKneelHighLegSpread					
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsOutdoors", "ZazAPC018") ;  		HandsBehindKneelLow
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsOutdoors", "ZazAPC019") ;  		HandsBehindKneelLegSpread					
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsOutdoors", "ZazAPC020") ;  	    HandsBehindKneelBowDown
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsOutdoors", "ZazAPC054") ;  		HandsBehindLieFaceUpLegsSpread-Struggle I
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsOutdoors", "ZazAPC055") ;  		HandsBehindLieFaceUpLegsSpread-Struggle II
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsOutdoors", "ZazAPC056") ;  		HogTieFaceDownLegsSpread
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsOutdoors", "ZazAPC057") ;  		FrogTieFaceDownStruggle
		StorageUtil.StringListAdd( kPlayer, "_SD_lPunishmentsOutdoors", "ZazAPC058") ;  		HandsBehindKneel
	EndIf
EndFunction

function PlayPunishmentIdle( string sPunishmentIdle = "" )
	Actor kPlayer = Game.getPlayer()
	ObjectReference kPlayerRef = Game.getPlayer() as ObjectReference
	Int iRandomNum  

	If (sPunishmentIdle != "")
		Debug.SendAnimationEvent( kPlayerRef , sPunishmentIdle )
	else
		If ( kPlayer.GetParentCell().IsInterior())
			iRandomNum = Utility.RandomInt(0, StorageUtil.StringListCount( kPlayer, "_SD_lPunishmentsIndoors") - 1 )
			sPunishmentIdle = StorageUtil.StringListGet(kPlayer, "_SD_lPunishmentsIndoors", iRandomNum)  
			Debug.SendAnimationEvent( kPlayerRef , sPunishmentIdle )

		Else
			iRandomNum = Utility.RandomInt(0, StorageUtil.StringListCount( kPlayer, "_SD_lPunishmentsOutdoors") - 1)
			sPunishmentIdle = StorageUtil.StringListGet(kPlayer, "_SD_lPunishmentsOutdoors", iRandomNum)  
			Debug.SendAnimationEvent( kPlayerRef , sPunishmentIdle )

		EndIf
	Endif

	debugTrace(" Play punishment idle: " + sPunishmentIdle)

EndFunction

Float Function GetEnslavementDuration(Actor kSlave)
	Return ( _SDGVP_gametime.GetValue() -	StorageUtil.GetFloatValue(kSlave, "_SD_fEnslavedGameTime" ) )
EndFunction

;----- Enslavement task system

Function InitSlaveryTaskList()
	debugTrace(" Initialize tasks list")

	StorageUtil.FormListClear(none, "_SD_lSlaveryTaskList")
	StorageUtil.FormListClear(none, "_SD_lSlaveryCurrentTaskList")
	; Initialize form list of active task forms
	; _SDGVP_CurrentTaskID.SetValue(iTaskID)
	; _SDGVP_CurrentTaskStatus.SetValue(0)  ; -1 fail / 0 started / 1 completed

	; Bring food
	RegisterSlaveryTask(iTaskID= 1, fKeyword=_SDTSK_BRING_FOOD  as Form, sTaskName = "Bring food", iTaskChance = 90, fTaskDuration=6.0, fTaskTargetItem=None, iTaskTargetCount=Utility.RandomInt(5,10), iTaskTargetDifference=0, iTaskPositiveMod=1, sTaskPositiveReward="Food", iTaskNegativeMod= -1, sTaskNegativeReward="Comment", sTaskTags="creature master" )  
	; Bring Gold
	RegisterSlaveryTask(iTaskID= 2, fKeyword=_SDTSK_BRING_GOLD  as Form, sTaskName = "Bring gold", iTaskChance = 90, fTaskDuration=6.0, fTaskTargetItem=None, iTaskTargetCount=Utility.RandomInt(50,100), iTaskTargetDifference=0, iTaskPositiveMod=1, sTaskPositiveReward="Comment", iTaskNegativeMod= -1, sTaskNegativeReward="Comment", sTaskTags="" )  
	; Bring armor  
	RegisterSlaveryTask(iTaskID= 3, fKeyword=_SDTSK_BRING_ARMOR  as Form, sTaskName = "Bring armor", iTaskChance = 50, fTaskDuration=6.0, fTaskTargetItem=None, iTaskTargetCount=1, iTaskTargetDifference=0, iTaskPositiveMod=2, sTaskPositiveReward="Comment", iTaskNegativeMod= -2, sTaskNegativeReward="Comment", sTaskTags="" )  
	; Bring weapon   
	RegisterSlaveryTask(iTaskID= 4, fKeyword=_SDTSK_BRING_WEAPON  as Form, sTaskName = "Bring weapon", iTaskChance = 50, fTaskDuration=6.0, fTaskTargetItem=None, iTaskTargetCount=1, iTaskTargetDifference=0, iTaskPositiveMod=3, sTaskPositiveReward="Comment", iTaskNegativeMod= -3, sTaskNegativeReward="Comment", sTaskTags="" ) 
	; Bring ingredient    
	RegisterSlaveryTask(iTaskID= 5, fKeyword=_SDTSK_BRING_INGREDIENT  as Form, sTaskName = "Bring ingredient", iTaskChance = 70, fTaskDuration=6.0, fTaskTargetItem=None, iTaskTargetCount=Utility.RandomInt(5,10), iTaskTargetDifference=0, iTaskPositiveMod=1, sTaskPositiveReward="Comment", iTaskNegativeMod= -1, sTaskNegativeReward="Comment", sTaskTags="creature master" )     
	; Bring firewood
	RegisterSlaveryTask(iTaskID= 6, fKeyword=_SDTSK_BRING_FIREWOOD  as Form, sTaskName = "Bring firewood", iTaskChance = 40, fTaskDuration=6.0, fTaskTargetItem=None, iTaskTargetCount=Utility.RandomInt(1,5), iTaskTargetDifference=0, iTaskPositiveMod=1, sTaskPositiveReward="Comment", iTaskNegativeMod= -1, sTaskNegativeReward="Comment", sTaskTags="" )    
	; Bring book
	RegisterSlaveryTask(iTaskID= 7, fKeyword=_SDTSK_BRING_BOOK  as Form, sTaskName = "Bring book", iTaskChance = 30, fTaskDuration=6.0, fTaskTargetItem=None, iTaskTargetCount=1, iTaskTargetDifference=0, iTaskPositiveMod=1, sTaskPositiveReward="Comment", iTaskNegativeMod= -1, sTaskNegativeReward="Comment", sTaskTags="" )    
	; Entertain - Dance 
	RegisterSlaveryTask(iTaskID= 8, fKeyword=_SDTSK_ENTERTAIN_DANCE  as Form, sTaskName = "Dance", iTaskChance = 70, fTaskDuration=4.0, fTaskTargetItem=None, iTaskTargetCount=1, iTaskTargetDifference=0, iTaskPositiveMod=1, sTaskPositiveReward="NipplePiercing", iTaskNegativeMod= -1, sTaskNegativeReward="Whip", sTaskTags="" )  
	; Entertain - Solo show   
	RegisterSlaveryTask(iTaskID= 9, fKeyword=_SDTSK_ENTERTAIN_SOLO  as Form, sTaskName = "Solo", iTaskChance = 90, fTaskDuration=4.0, fTaskTargetItem=None, iTaskTargetCount=1, iTaskTargetDifference=0, iTaskPositiveMod=2, sTaskPositiveReward="VaginalPiercing", iTaskNegativeMod= -2, sTaskNegativeReward="Whip", sTaskTags="" )  
	; Entertain - Sex   
	RegisterSlaveryTask(iTaskID= 10, fKeyword=_SDTSK_ENTERTAIN_SEX as Form, sTaskName = "Sex", iTaskChance = 90, fTaskDuration=4.0, fTaskTargetItem=None, iTaskTargetCount=1, iTaskTargetDifference=0, iTaskPositiveMod=2, sTaskPositiveReward="Comment", iTaskNegativeMod= -2, sTaskNegativeReward="Punishment", sTaskTags="creature master" )  
	; Inspection   
	RegisterSlaveryTask(iTaskID= 11, fKeyword=_SDTSK_INSPECTION  as Form, sTaskName = "Inspection", iTaskChance = 80, fTaskDuration=6.0, fTaskTargetItem=None, iTaskTargetCount=1, iTaskTargetDifference=0, iTaskPositiveMod=1, sTaskPositiveReward="Comment", iTaskNegativeMod= -1, sTaskNegativeReward="WristRestraint", sTaskTags="" )     
	; Training anal
	RegisterSlaveryTask(iTaskID= 12, fKeyword=_SDTSK_TRAINING_ANAL  as Form, sTaskName = "Training anal", iTaskChance = 20, fTaskDuration=6.0 + Utility.RandomInt(0,18)*1.0, fTaskTargetItem=None, iTaskTargetCount=1, iTaskTargetDifference=0, iTaskPositiveMod=1, sTaskPositiveReward="Comment", iTaskNegativeMod= -1, sTaskNegativeReward="Belt", sTaskTags="" )     
	; Training vaginal
	RegisterSlaveryTask(iTaskID= 13, fKeyword=_SDTSK_TRAINING_VAGINAL  as Form, sTaskName = "Training vaginal", iTaskChance = 20, fTaskDuration= 6.0 + Utility.RandomInt(0,18)*1.0, fTaskTargetItem=None, iTaskTargetCount=1, iTaskTargetDifference=0, iTaskPositiveMod=1, sTaskPositiveReward="Comment", iTaskNegativeMod= -1, sTaskNegativeReward="Belt", sTaskTags="female player" )     
	; Training oral
	RegisterSlaveryTask(iTaskID= 14, fKeyword=_SDTSK_TRAINING_ORAL  as Form, sTaskName = "Training oral", iTaskChance = 20, fTaskDuration= 6.0 + Utility.RandomInt(0,18)*1.0, fTaskTargetItem=None, iTaskTargetCount=1, iTaskTargetDifference=0, iTaskPositiveMod=1, sTaskPositiveReward="Comment", iTaskNegativeMod= -1, sTaskNegativeReward="Belt", sTaskTags="" )     
	; Training posture
	RegisterSlaveryTask(iTaskID= 15, fKeyword=_SDTSK_TRAINING_POSTURE  as Form, sTaskName = "Training posture", iTaskChance = 20, fTaskDuration=6.0 + Utility.RandomInt(0,18)*1.0, fTaskTargetItem=None, iTaskTargetCount=1, iTaskTargetDifference=0, iTaskPositiveMod=1, sTaskPositiveReward="Comment", iTaskNegativeMod= -1, sTaskNegativeReward="Yoke", sTaskTags="" )     
	; Wash
	RegisterSlaveryTask(iTaskID= 16, fKeyword=_SDTSK_WASH  as Form, sTaskName = "Wash", iTaskChance = 20, fTaskDuration=4.0, fTaskTargetItem=None, iTaskTargetCount=1, iTaskTargetDifference=0, iTaskPositiveMod=1, sTaskPositiveReward="Comment", iTaskNegativeMod= -1, sTaskNegativeReward="Gag", sTaskTags="" )     
	; Ignore
	RegisterSlaveryTask(iTaskID= 17, fKeyword=_SDTSK_IGNORE  as Form, sTaskName = "Ignore", iTaskChance = 10, fTaskDuration=Utility.RandomInt(4,8)*1.0, fTaskTargetItem=None, iTaskTargetCount=0, iTaskTargetDifference= -1 * Utility.RandomInt(1,5), iTaskPositiveMod=2, sTaskPositiveReward="Comment", iTaskNegativeMod= -2, sTaskNegativeReward="Gag", sTaskTags="creature master" )     

	iNumberTasks = StorageUtil.FormListCount( none, "_SD_lTaskList")
EndFunction

Function RegisterSlaveryTask(Int iTaskID, Form fKeyword, String sTaskName, Int iTaskChance, Float fTaskDuration, Form fTaskTargetItem, Int iTaskTargetCount, Int iTaskTargetDifference, Int iTaskPositiveMod, String sTaskPositiveReward, Int iTaskNegativeMod, String sTaskNegativeReward, String sTaskTags)
	if (StorageUtil.FormListFind( none, "_SD_lTaskList", fKeyword) <0)
		debugTrace(" Registering slavery task: " + iTaskID)

		StorageUtil.FormListAdd( none, "_SD_lTaskList", fKeyword)  ; form ID / keyword - anchor for task parameters

		StorageUtil.SetIntValue(fKeyword, "_SD_iTaskID",  iTaskID ) ; task ID - easier to handle than form for conditions, dialogue topcis...
		StorageUtil.SetStringValue(fKeyword, "_SD_sTaskName",  sTaskName ) ; task name - for more readable coding
		StorageUtil.SetFloatValue(fKeyword, "_SD_iTaskChance",  iTaskChance ) ; chance of triggering the task
		StorageUtil.SetFloatValue(fKeyword, "_SD_fTaskDuration",  fTaskDuration ) ; duration of task, roughly in hours
		StorageUtil.SetFormValue(fKeyword, "_SD_fTaskTargetItem",  fTaskTargetItem ) ; Form - can be direct item Form ID or Form List to pick from. If None, detection should be handled according to taks ID
		StorageUtil.SetIntValue(fKeyword, "_SD_iTaskTargetCount",  iTaskTargetCount ) ; number of expected items to complete task 
		StorageUtil.SetIntValue(fKeyword, "_SD_iTaskTargetDifference",  iTaskTargetDifference ) ; expected difference between positive and negative counts. Use 0 to ignore (optional)
		StorageUtil.SetIntValue(fKeyword, "_SD_iTaskPositiveMod",  iTaskPositiveMod  ) ; trust points as a reward for successful task
		StorageUtil.SetStringValue(fKeyword, "_SD_sTaskPositiveReward",  sTaskPositiveReward ) ; string - type of reward for successful task
		StorageUtil.SetIntValue(fKeyword, "_SD_iTaskNegativeMod",  iTaskNegativeMod  ) ; trust points as a reward for failed task
		StorageUtil.SetStringValue(fKeyword, "_SD_sTaskNegativeReward",  sTaskNegativeReward ) ; string - type of reward for failed task
		StorageUtil.SetStringValue(fKeyword, "_SD_sTaskTags",  sTaskTags ) ; string - tags to apply constraints to tasks (male player, female player, creature master)

		; parameters set by task management system when task is triggered
		StorageUtil.SetFloatValue(fKeyword, "_SD_fTaskStartDate",  0.0  ) ; 
		StorageUtil.SetIntValue(fKeyword, "_SD_iTaskPositiveCount",  0  ) 
		StorageUtil.SetIntValue(fKeyword, "_SD_iTaskNegativeCount",  0  ) 

		; Add to form list of active task forms
		; _SDGVP_CurrentTaskID.SetValue(iTaskID)
		; _SDGVP_CurrentTaskStatus.SetValue(0)  ; -1 fail / 0 started / 1 completed

	endif
EndFunction


Function PickSlaveryTask(Actor kSlave, String sTaskName = "")
	Actor kMaster = StorageUtil.GetFormValue(kSlave, "_SD_CurrentOwner") as Actor
	ObjectReference kSlaveRef = kSlave as ObjectReference
	Form fKeyword = None
	Bool bFound = false
	Int iTaskID = 0
	Int iSlaveLevel = StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryLevel") 

	If (StorageUtil.GetIntValue(kMaster, "_SD_iMasterIsCreature")== 1)
		debugTrace(" Evaluate slavery task list - creature master found - aborting tasks")
		Return
	endif

	If (_SDGVP_state_caged.GetValue( )== 1)
		debugTrace(" Evaluate slavery task list - player is caged - aborting tasks")
		Return
	endif

	If ( kSlave.IsOnMount() || kSlave.IsInCombat() || kSlave.IsWeaponDrawn() ) ; || (kSlaveRef.GetCurrentScene()!=None) 
		; Debug.Notification("[SD] Evaluate slavery task list - player is busy - aborting tasks")
		debugTrace(" Evaluate slavery task list - player is busy - aborting tasks")
		debugTrace("         IsOnMount:" +kSlave.IsOnMount() )
		debugTrace("         IsInCombat:" +kSlave.IsInCombat() )
		; debugTrace("         InScene:" +(kSlaveRef.GetCurrentScene()) )
		debugTrace("         IsWeaponDrawn:" +kSlave.IsWeaponDrawn())
		return
	EndIf

	If (sTaskName == "") ; pick random task
		int valueCount = StorageUtil.FormListCount(none, "_SD_lTaskList")
		int i = 0

		debugTrace(" Pick random slavery task: " )
		while(i < iSlaveLevel) && (!bFound) ; allow for iSlaveLevel attempts at picking a task - ie. up to iSlaveLevel tasks active at a time
			iTaskID = Utility.RandomInt(1,valueCount)
			fKeyword = GetSlaveryTaskFromID(iTaskID)
			if (StorageUtil.GetFloatValue(fKeyword, "_SD_fTaskStartDate")==0) && (Utility.RandomInt(0,100) <= StorageUtil.GetIntValue(fKeyword, "_SD_fTaskChance"))
				debugTrace("      Task found: " + iTaskID + " [" + fKeyword + "]")
				bFound = true
				StartSlaveryTask(kSlave, iTaskID)
			endif
			i += 1
		endwhile
	Else
		debugTrace(" Pick slavery task by name: " + sTaskName )
		fKeyword = GetSlaveryTaskFromName(sTaskName)
		iTaskID = StorageUtil.GetIntValue(fKeyword, "_SD_iTaskID")
		if (StorageUtil.GetFloatValue(fKeyword, "_SD_fTaskStartDate")==0)
			debugTrace("      Task found: " + iTaskID + " [" + fKeyword + "]")
			StartSlaveryTask(kSlave, iTaskID)
		Endif
	Endif

EndFunction


Function StartSlaveryTask(Actor kSlave, Int iTaskID)
	Form fKeyword 
	int valueCount = StorageUtil.FormListCount(none, "_SD_lTaskList")
	Int iSlaveLevel = StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryLevel") 
	int i = 0
	String sTaskName
	Bool bIsFemale = funct.isFemale(kSlave)

	If ((iTaskID < 1) || (iTaskID > iNumberTasks))
		debugTrace(" Start a new task - bad task ID: " + iTaskID)
		debugTrace("                  - iNumberTasks: " + iNumberTasks)
		Return
	endif

	If (_SDGVP_state_caged.GetValue( )== 1)
		debugTrace(" Evaluate slavery task list - player is caged - aborting tasks")
		Return
	endif

	fKeyword = GetSlaveryTaskFromID(iTaskID)
	sTaskName = StorageUtil.GetStringValue(fKeyword, "_SD_sTaskName" )

	; Test task compatibility with player
	If (StorageUtil.GetStringValue(fKeyword, "_SD_sTaskTags" )=="female player") && (!bIsFemale)
		debugTrace(" Evaluate slavery task list - Task is for female only - player is not female")
		Return
	EndIf

	; grant rights, remove or equip items based on task (training devices for example)

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

	; redirect Vaginal tasks to Anal for males
	If (sTaskName=="Training vaginal") 
		if (!fctOutfit.isDeviceEquippedString(kSlave,"PlugVaginal")) && (iSlaveLevel>=1) && (iSlaveLevel<=2)
			fctOutfit.QueueSlavePunishment(kSlave, "TrainingPlugVaginal", 1.0 + Utility.RandomFloat(1.0, 23.0))
		Else
			Return ; abort
		Endif
	ElseIf (sTaskName=="Training anal") 
		if (!fctOutfit.isDeviceEquippedString(kSlave,"PlugAnal")) && (iSlaveLevel>=2) && (iSlaveLevel<=4)  
			fctOutfit.QueueSlavePunishment(kSlave, "TrainingPlugAnal", 1.0 + Utility.RandomFloat(1.0, 23.0))
		Else
			Return ; abort
		Endif
	ElseIf (sTaskName=="Training oral")
		if (!fctOutfit.isDeviceEquippedString(kSlave,"Gag")) && (iSlaveLevel>=1) && (iSlaveLevel<=6)  
			fctOutfit.QueueSlavePunishment(kSlave, "TrainingGag", 1.0 + Utility.RandomFloat(1.0, 23.0))
		Else
			Return ; abort
		Endif
	ElseIf (sTaskName=="Training posture")
		if (!fctOutfit.isDeviceEquippedString(kSlave,"Boots")) && (iSlaveLevel>=3) && (iSlaveLevel<=6)  
			fctOutfit.QueueSlavePunishment(kSlave, "TrainingBoots", 1.0 + Utility.RandomFloat(1.0, 23.0))
		Else
			Return ; abort
		Endif
	Endif

	; Wash
	; Ignore   

	DisplaySlaveryTaskStartMessage(kSlave,fKeyword)

	; Replace with form list of active task forms
	_SDGVP_CurrentTaskID.SetValue(iTaskID)
	_SDGVP_CurrentTaskStatus.SetValue(0)  ; -1 fail / 0 started / 1 completed

	StorageUtil.SetFloatValue(fKeyword, "_SD_fTaskStartDate",   Utility.GetCurrentGameTime()  ); _SDGVP_gametime.GetValue() as Float  ) ; 
	StorageUtil.SetIntValue(fKeyword, "_SD_iTaskPositiveCount",  0  ) 
	StorageUtil.SetIntValue(fKeyword, "_SD_iTaskNegativeCount",  0  ) 
	StorageUtil.SetIntValue(fKeyword, "_SD_iTaskForceCompletion",  0  ) 

	; reset past slavery task objectives
	; while(i < valueCount)
	; 	slaveryQuest.SetObjectiveDisplayed( 50 + iTaskID, abDisplayed = false)
	; 	i += 1
	; endwhile

	; slaveryQuest.SetStage( 50 + iTaskID )
	slaveryQuest.SetObjectiveDisplayed( 50 + iTaskID, abDisplayed = true)

	StorageUtil.FormListAdd( none, "_SD_lCurrentTaskList", fKeyword)   

EndFunction

Function EvaluateSlaveryTaskList(Actor kSlave)
	Actor kMaster = StorageUtil.GetFormValue(kSlave, "_SD_CurrentOwner") as Actor
	Form fKeyword = None 
	Int iSlaveLevel = StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryLevel") 
	Float fCurrentDate = _SDGVP_gametime.GetValue() as Float
	Float fHoursCount = 0
	String sTaskName

	int valueCount = StorageUtil.FormListCount(none, "_SD_lCurrentTaskList")
	int i = 0
	int iTaskID = 0

	If (StorageUtil.GetIntValue(kMaster, "_SD_iMasterIsCreature")== 1)
		debugTrace(" Evaluate slavery task list - creature master found - aborting tasks")
		Return
	endif

	; Debug.Notification("[SD] Evaluate slavery task list: " + valueCount)
	debugTrace(" Evaluate slavery task list: " + valueCount )
	while(i < valueCount)   
		fKeyword = StorageUtil.FormListGet( none, "_SD_lCurrentTaskList", i)
		EvaluateSlaveryTask( kSlave,  fKeyword)

		i += 1
	endwhile

	valueCount = StorageUtil.FormListCount(none, "_SD_lCurrentTaskList")

	If (valueCount < iSlaveLevel) && (Utility.RandomInt(0,100)>(40 + iSlaveLevel*10))
		PickSlaveryTask(kSlave)
	Endif

EndFunction

Function DisplayTaskTimer(Form fKeyword)
	; Float fCurrentDate = _SDGVP_gametime.GetValue() as Float

	debugTrace(" Evaluate slavery task: " + StorageUtil.GetStringValue(fKeyword, "_SD_sTaskName") )
	debugTrace("      _SD_fTaskDuration: " + StorageUtil.GetFloatValue(fKeyword, "_SD_fTaskDuration") )
	debugTrace("      _SD_fTaskStartDate: " + StorageUtil.GetFloatValue(fKeyword, "_SD_fTaskStartDate") )
	; debugTrace("      fCurrentDate: " + fCurrentDate )

EndFunction


Function EvaluateSlaveryTask(Actor kSlave, Form fKeyword)
	Actor kMaster = StorageUtil.GetFormValue(kSlave, "_SD_CurrentOwner") as Actor
	Float fCurrentDate = _SDGVP_gametime.GetValue() as Float
	Int  iHoursCount = 0
	Int iTimeLeft = 0
	String sTaskName
	Bool bIsFemale = funct.isFemale(kSlave)

	if (fKeyword != None)
		; Debug.MessageBox("Good slave, you COMPLETED your task (" + sTaskName + ")")
	Else
		Debug.Notification("$[SD] Error - empty task keyword - check logs for details")
		Return
	Endif

	TaskTickerThisCallTime = Utility.GetCurrentGameTime()

 	fTimePassed =  TaskTickerThisCallTime - StorageUtil.GetFloatValue(fKeyword, "_SD_fTaskStartDate")

	; if ((fTimePassed-TaskTickerLastCallTime)>= (TaskTickerPeriod * fSlaveLevel) ) ; same day - incremental updates
	iHoursCount = ((fTimePassed)/ (TaskTickerPeriod) ) as Int
	if (iHoursCount<1)
		iHoursCount = 0
	EndIf

	sTaskName = StorageUtil.GetStringValue(fKeyword, "_SD_sTaskName" )
	iTimeLeft = ( (StorageUtil.GetFloatValue(fKeyword, "_SD_fTaskDuration") as Int) - iHoursCount )

	; fHoursCount = (fCurrentDate - StorageUtil.GetFloatValue(fKeyword, "_SD_fTaskStartDate")) * 24
	DisplayTaskTimer(fKeyword)
	debugTrace("      fTimePassed: " + fTimePassed )
	debugTrace("      iHoursCount: " + iHoursCount )
	debugTrace("      Time Left: " + iTimeLeft )

	If (_SDGVP_state_caged.GetValue( )== 1)
		debugTrace(" Evaluate slavery task - player is caged - skipping")
		StorageUtil.SetFloatValue(fKeyword, "_SD_fTaskStartDate", StorageUtil.GetFloatValue(fKeyword, "_SD_fTaskStartDate") + (TaskTickerThisCallTime - TaskTickerLastCallTime))

	Elseif (iTimeLeft <= 0) || (StorageUtil.GetIntValue(fKeyword, "_SD_iTaskForceCompletion") == 1)
		If (StorageUtil.GetIntValue(fKeyword, "_SD_iTaskTargetDifference")<0)
			debugTrace("      Evaluating negative task" )
			If (StorageUtil.GetIntValue(fKeyword, "_SD_iTaskNegativeCount" ) > StorageUtil.GetIntValue(fKeyword, "_SD_iTaskTargetDifference") )
				CompleteSlaveryTask( kSlave,  fKeyword)
			Else
				FailSlaveryTask( kSlave,  fKeyword)
			Endif
		Else
			debugTrace("      Evaluating positive task" )
			; check if training devices are still on
			If (sTaskName=="Training vaginal")
				if (fctOutfit.isDeviceEquippedString(kSlave,"PlugVaginal"))  
					StorageUtil.SetIntValue(fKeyword, "_SD_iTaskPositiveCount", 1)
				Endif
			ElseIf (sTaskName=="Training anal")
				if (fctOutfit.isDeviceEquippedString(kSlave,"PlugAnal"))  
					StorageUtil.SetIntValue(fKeyword, "_SD_iTaskPositiveCount", 1)
				Endif
			ElseIf (sTaskName=="Training oral")
				if (fctOutfit.isDeviceEquippedString(kSlave,"Gag"))  
					StorageUtil.SetIntValue(fKeyword, "_SD_iTaskPositiveCount", 1)
				Endif
			ElseIf (sTaskName=="Training posture")
				if (fctOutfit.isDeviceEquippedString(kSlave,"Boots"))  
					StorageUtil.SetIntValue(fKeyword, "_SD_iTaskPositiveCount", 1)
				Endif
			Endif

			debugTrace("      _SD_iTaskPositiveCount: " + StorageUtil.GetIntValue(fKeyword, "_SD_iTaskPositiveCount" ) )
			debugTrace("      _SD_iTaskTarget: " + StorageUtil.GetIntValue(fKeyword, "_SD_iTaskTarget") )

			If (StorageUtil.GetIntValue(fKeyword, "_SD_iTaskPositiveCount" ) > StorageUtil.GetIntValue(fKeyword, "_SD_iTaskTarget") )
				CompleteSlaveryTask( kSlave,  fKeyword)
			Else
				FailSlaveryTask( kSlave,  fKeyword)
			Endif
		Endif
	endif

	TaskTickerLastCallTime = Utility.GetCurrentGameTime()

EndFunction

Function CompleteSlaveryTask(Actor kSlave, Form fKeyword)
	Actor kMaster = StorageUtil.GetFormValue(kSlave, "_SD_CurrentOwner") as Actor
	String sTaskPositiveReward = StorageUtil.GetStringValue(fKeyword, "_SD_sTaskPositiveReward")
	Float fMasterDistance = kSlave.GetDistance( kMaster )
	String sTaskName = StorageUtil.GetStringValue(fKeyword, "_SD_sTaskName" )
	Bool bIsFemale = funct.isFemale(kSlave)

	debugTrace("[SD] You succeded Task : " + sTaskName )
	debugTrace(" Completing Task : " + StorageUtil.GetIntValue(fKeyword, "_SD_iTaskID") + " [" + fKeyword + "]")

	if (sTaskName != "")
		Debug.Trace("[SD] Good slave, you COMPLETED your task (" + sTaskName + ")")
		Debug.Notification("Good slave.")
	Else
		Debug.Notification("$[SD] Error - task name is empty - check logs for details")
		Return
	Endif

	If (fMasterDistance >= 900)
		Debug.Notification("$Your owner is too far to reward you.")
		ModMasterTrust(kMaster, -1) ; Master is disappointed
		Return
	endif


	; clear training devices
	If (sTaskName=="Training vaginal")
		if (fctOutfit.isDeviceEquippedString(kSlave,"PlugVaginal"))  
			fctOutfit.ClearSlavePunishment(kSlave,"PlugVaginal", true)
			ModMasterTrust(kMaster, 3)  
		Endif
	ElseIf (sTaskName=="Training anal")
		if (fctOutfit.isDeviceEquippedString(kSlave,"PlugAnal"))  
			fctOutfit.ClearSlavePunishment(kSlave,"PlugAnal", true)
			ModMasterTrust(kMaster, 3)  
		Endif
	ElseIf (sTaskName=="Training oral")
		if (fctOutfit.isDeviceEquippedString(kSlave,"Gag"))  
			fctOutfit.ClearSlavePunishment(kSlave,"Gag", true)
			ModMasterTrust(kMaster, 1)  
		Endif
	ElseIf (sTaskName=="Training posture")
		if (fctOutfit.isDeviceEquippedString(kSlave,"Boots"))  
			fctOutfit.ClearSlavePunishment(kSlave,"Boots", true)
			ModMasterTrust(kMaster, 2)  
		Endif
	Endif


	; select reward based on label
	If (sTaskPositiveReward=="Comment")
		; Add diverse comments based on task and mood of master

	ElseIf (sTaskPositiveReward=="Food")
		kMaster.SendModEvent("SLDGiftNPC","Hungry")

	ElseIf (sTaskPositiveReward=="NipplePiercing")
		fctOutfit.equipDeviceByString(sDeviceString="NipplePiercing", sOutfitString = "", sDeviceTags = "")

	ElseIf (sTaskPositiveReward=="VaginalPiercing")
		fctOutfit.equipDeviceByString(sDeviceString="VaginalPiercing", sOutfitString = "", sDeviceTags = "")
	EndIf

	ModMasterTrust(kMaster, StorageUtil.GetIntValue(fKeyword, "_SD_iTaskPositiveMod"))
	; Debug.Notification("[SD]       Reward : " + sTaskPositiveReward )
	debugTrace("       Reward : " + sTaskPositiveReward )

	ResetSlaveryTask( fKeyword)

	If (Utility.RandomInt(0,100) > 90)
		PickSlaveryTask(kSlave)
	Endif
EndFunction

Function FailSlaveryTask(Actor kSlave, Form fKeyword)
	Actor kMaster = StorageUtil.GetFormValue(kSlave, "_SD_CurrentOwner") as Actor
	String sTaskNegativeReward = StorageUtil.GetStringValue(fKeyword, "_SD_sTaskNegativeReward")
	Float fMasterDistance = kSlave.GetDistance( kMaster )
	String sTaskName = StorageUtil.GetStringValue(fKeyword, "_SD_sTaskName" )
	Bool bIsFemale = funct.isFemale(kSlave)

	debugTrace("[SD] You failed Task : " + sTaskName )
	debugTrace(" Failing Task : " + StorageUtil.GetIntValue(fKeyword, "_SD_iTaskID") + " [" + fKeyword + "]")
	; Debug.Notification("[SD] You failed Task : " + sTaskName )

	if (sTaskName != "")
		Debug.MessageBox("Bad slave, you FAILED your task (" + sTaskName + ")")
	Else
		Debug.Notification("$[SD] Error - task name is empty - check logs for details")
		Return
	Endif

	If (fMasterDistance >= 900)
		Debug.Notification("$Your owner is too far to punish you.")
		ModMasterTrust(kMaster, -2) ; Master is disappointed
		Return
	endif


	; select punishment based on label
	If (sTaskNegativeReward=="Comment")

		; Add diverse comments based on task and mood of master

	ElseIf (sTaskNegativeReward=="Whip")
		funct.SanguineWhip( kMaster )

	ElseIf (sTaskNegativeReward=="Punishment")
		funct.SanguinePunishment( kMaster )

	ElseIf (sTaskNegativeReward=="Belt")
		if (!fctOutfit.isDeviceEquippedString(kSlave,"Belt"))  
			fctOutfit.QueueSlavePunishment(kSlave, "Belt", 1.0 + Utility.RandomFloat(1.0, 23.0))
		Endif

	ElseIf (sTaskNegativeReward=="Yoke")
		if (!fctOutfit.isDeviceEquippedString(kSlave,"Yoke"))  
			fctOutfit.QueueSlavePunishment(kSlave, "Yoke", 1.0 + Utility.RandomFloat(1.0, 23.0))
		Endif

	ElseIf (sTaskNegativeReward=="WristRestraint")
		if (!fctOutfit.isDeviceEquippedString(kSlave,"WristRestraint"))  
			fctOutfit.QueueSlavePunishment(kSlave, "WristRestraint", 1.0 + Utility.RandomFloat(1.0, 23.0))
		Endif

	ElseIf (sTaskNegativeReward=="Gag")
		if (!fctOutfit.isDeviceEquippedString(kSlave,"Gag"))  
			fctOutfit.QueueSlavePunishment(kSlave, "Gag", 1.0 + Utility.RandomFloat(1.0, 23.0))
		Endif
	Endif


	ModMasterTrust(kMaster, StorageUtil.GetIntValue(fKeyword, "_SD_iTaskNegativeMod"))
	; Debug.Notification("[SD]       Punishment : " + sTaskNegativeReward )
	debugTrace("       Punishment : " + sTaskNegativeReward )
	
	ResetSlaveryTask( fKeyword)

	If (Utility.RandomInt(0,100) > 60)
		PickSlaveryTask(kSlave)
	Endif
EndFunction

Function ResetSlaveryTaskList(Actor kSlave)
	Actor kMaster = StorageUtil.GetFormValue(kSlave, "_SD_CurrentOwner") as Actor
	Form fKeyword = None 
	Int iSlaveLevel = StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryLevel") 
	Float fCurrentDate = _SDGVP_gametime.GetValue() as Float
	Float fHoursCount = 0
	String sTaskName

	int valueCount = StorageUtil.FormListCount(none, "_SD_lTaskList")
	int i = 0
	int iTaskID = 0

	If (StorageUtil.GetIntValue(kMaster, "_SD_iMasterIsCreature")== 1)
		debugTrace(" Reset slavery task list - creature master found - aborting tasks")
		Return
	endif

	; Debug.Notification("[SD] Reset slavery task list: " + valueCount)
	debugTrace(" Reset slavery task list: " + valueCount )
	while(i < valueCount)   
		fKeyword = StorageUtil.FormListGet( none, "_SD_lTaskList", i)
		ResetSlaveryTask( fKeyword)

		i += 1
	endwhile

	StorageUtil.FormListClear(none, "_SD_lCurrentTaskList")

EndFunction

Function ResetSlaveryTask(Form fKeyword)
	Int iTaskID = StorageUtil.GetIntValue(fKeyword, "_SD_iTaskID")
	If (iTaskID>0)
		debugTrace(" Resetting Task : " + iTaskID )
		; slaveryQuest.SetStage( 50 + iTaskID )
		slaveryQuest.SetObjectiveDisplayed( 50 + iTaskID, abDisplayed = false)
		StorageUtil.SetFloatValue(fKeyword, "_SD_fTaskStartDate",   0 ) ; 
		StorageUtil.SetIntValue(fKeyword, "_SD_iTaskPositiveCount",  0  ) 
		StorageUtil.SetIntValue(fKeyword, "_SD_iTaskNegativeCount",  0  ) 
		StorageUtil.SetIntValue(fKeyword, "_SD_iTaskForceCompletion",  0  ) 
		StorageUtil.FormListRemove( none, "_SD_lCurrentTaskList", fKeyword)   
	Else
		debugTrace(" Resetting Task - TaskID = 0 - aborting" )
	Endif
EndFunction

Function ModSlaveryTask(Actor kSlave, String sTaskName, Int iModValue)
	Form fKeyword = GetSlaveryTaskFromName( sTaskName)
	Int iTaskID = StorageUtil.GetIntValue(fKeyword, "_SD_iTaskID")
	Actor kMaster = StorageUtil.GetFormValue(kSlave, "_SD_CurrentOwner") as Actor
	Float fMasterDistance = kSlave.GetDistance( kMaster )
	Int iTaskValue = 0
	Int iCompletionPercent = 0
	String sTaskMessage 

	If (fKeyword != None)
		; only increment active tasks
		If (StorageUtil.GetFloatValue(fKeyword, "_SD_fTaskStartDate")>0.0)
			DisplayTaskTimer(fKeyword)

			; force refresh of quest objective if it is missing
			If (!slaveryQuest.IsObjectiveDisplayed(50 + iTaskID))
				slaveryQuest.SetObjectiveDisplayed( 50 + iTaskID, abDisplayed = true)
			Endif


			If (iModValue > 0)
				iTaskValue = StorageUtil.GetIntValue(fKeyword, "_SD_iTaskPositiveCount") 
				StorageUtil.SetIntValue(fKeyword, "_SD_iTaskPositiveCount", iTaskValue + iModValue)
				iCompletionPercent = (100 * StorageUtil.GetIntValue(fKeyword, "_SD_iTaskPositiveCount") ) / StorageUtil.GetIntValue(fKeyword, "_SD_iTaskTargetCount")

				if (iCompletionPercent>100)
					iCompletionPercent = 100
				EndIf

				sTaskMessage = "[" + sTaskName + "] completion before success: %" + iCompletionPercent 
				debugTrace("   " + sTaskMessage )
				debugTrace("  		Positive count : " + (iTaskValue + iModValue) )
				Debug.Notification(sTaskMessage )

				If (iCompletionPercent>=100) && ((fMasterDistance < 900))
					; StorageUtil.SetIntValue(fKeyword, "_SD_iTaskForceCompletion", 1) 
					; EvaluateSlaveryTask( kSlave,  fKeyword)
					CompleteSlaveryTask( kSlave,  fKeyword)

				Endif


			else
				iTaskValue = StorageUtil.GetIntValue(fKeyword, "_SD_iTaskNegativeCount"  ) 
				StorageUtil.SetIntValue(fKeyword, "_SD_iTaskNegativeCount", iTaskValue + iModValue)
				iCompletionPercent = (100 * StorageUtil.GetIntValue(fKeyword, "_SD_iTaskNegativeCount") ) / StorageUtil.GetIntValue(fKeyword, "_SD_iTaskTargetDifference")

				if (iCompletionPercent>100)
					iCompletionPercent = 100
				EndIf
				
				sTaskMessage = "[" + sTaskName + "] completion before fail: %" + iCompletionPercent 
				debugTrace("   " + sTaskMessage )
				debugTrace("  		Negative count : " + (iTaskValue + iModValue) )

				Debug.Notification(sTaskMessage )

				If (iCompletionPercent>=100) && ((fMasterDistance < 900))
					; StorageUtil.SetIntValue(fKeyword, "_SD_iTaskForceCompletion", 1) 
					; EvaluateSlaveryTask( kSlave,  fKeyword)
					FailSlaveryTask( kSlave,  fKeyword)
				Endif


			endif
		Endif
	Else
		debugTrace("      Task not found: " + sTaskName )
	EndIf
EndFunction

Form Function GetSlaveryTaskFromName(String sTaskName)
	Form fKeyword = None
	Bool bFound = false

	int valueCount = StorageUtil.FormListCount(none, "_SD_lTaskList")
	int i = 0

	debugTrace(" Looking up slavery task: " + sTaskName)
	while(i < valueCount) && (!bFound)
		fKeyword = StorageUtil.FormListGet( none, "_SD_lTaskList", i)
		if (StorageUtil.GetStringValue(fKeyword, "_SD_sTaskName")==sTaskName)
			debugTrace("      Task found: " + fKeyword)
			bFound = true
		endif
		i += 1
	endwhile

	Return fKeyword
EndFunction

Form Function GetSlaveryTaskFromID(Int iTaskID)
	Form fKeyword = None
	Bool bFound = false

	int valueCount = StorageUtil.FormListCount(none, "_SD_lTaskList")
	int i = 0

	debugTrace(" Looking up slavery task ID: " + iTaskID)
	while(i < valueCount) && (!bFound)
		fKeyword = StorageUtil.FormListGet( none, "_SD_lTaskList", i)
		if (StorageUtil.GetIntValue(fKeyword, "_SD_iTaskID")==iTaskID)
			debugTrace("      Task found: " + fKeyword)
			bFound = true
		endif
		i += 1
	endwhile

	Return fKeyword
EndFunction

Function DisplaySlaveryTaskStartMessage(Actor kSlave, Form fKeyword)
	Actor kMaster = StorageUtil.GetFormValue(kSlave, "_SD_CurrentOwner") as Actor
	String	sTaskName = StorageUtil.GetStringValue(fKeyword, "_SD_sTaskName" )

	; customize display messages based on master mood / personality (pet names, from dog, to slave, to pet)

	If (sTaskName=="Bring food")
		StorageUtil.SetIntValue(fKeyword, "_SD_iTaskTargetCount",  Utility.RandomInt(5,10) )
		Debug.MessageBox("I am starving. Bring me something to eat.")

	ElseIf (sTaskName=="Bring gold")
		StorageUtil.SetIntValue(fKeyword, "_SD_iTaskTargetCount",  Utility.RandomInt(50,100) )
		Debug.MessageBox("You better earn your keep. Bring me some valuables.")

	ElseIf (sTaskName=="Bring armor")
		Debug.MessageBox("Fetch me an armor. I don't care where you find it.")

	ElseIf (sTaskName=="Bring weapon")
		Debug.MessageBox("Bring me something else to protect myself with.")

	ElseIf (sTaskName=="Bring ingredient")
		StorageUtil.SetIntValue(fKeyword, "_SD_iTaskTargetCount",  Utility.RandomInt(5,10) )
		Debug.MessageBox("Bring me some ingredients. I would like to brew something.")
 
	ElseIf (sTaskName=="Bring firewood")
		StorageUtil.SetIntValue(fKeyword, "_SD_iTaskTargetCount",  Utility.RandomInt(1,5) )
		Debug.MessageBox("We need new wood for the fire.")

 	ElseIf (sTaskName=="Bring book")
		Debug.MessageBox("I am bored. Bring me something to read.")

 	ElseIf (sTaskName=="Dance")
		Debug.MessageBox("It's too quiet here. We need some entertainment.")

 	ElseIf (sTaskName=="Solo")
		Debug.MessageBox("Let's have some fun. Give us a good show.")
   
 	ElseIf (sTaskName=="Sex")
		Debug.MessageBox("Stay close. You are making me horny.")
   
 	ElseIf (sTaskName=="Inspection")
		Debug.MessageBox("Come closer. I want to see what you've got.")
		kMaster.SendModEvent("SLDRobPlayer")
   
	ElseIf (sTaskName=="Training vaginal")
		StorageUtil.SetFloatValue(fKeyword, "_SD_fTaskDuration",  6.0 + Utility.RandomInt(0,18)*1.0 )
		Debug.MessageBox("You need to learn to be lubricated at all times. This should do the trick.")

	ElseIf (sTaskName=="Training anal")
		StorageUtil.SetFloatValue(fKeyword, "_SD_fTaskDuration",  6.0 + Utility.RandomInt(0,18)*1.0 )
		Debug.MessageBox("Wear this for a while. That will stretch you a bit.")

	ElseIf (sTaskName=="Training oral")
		StorageUtil.SetFloatValue(fKeyword, "_SD_fTaskDuration",  6.0 + Utility.RandomInt(0,18)*1.0 )
		Debug.MessageBox("Your mouth is mine. Wear this for a while so you can put your tongue to good use.")
		
	ElseIf (sTaskName=="Training posture")
		StorageUtil.SetFloatValue(fKeyword, "_SD_fTaskDuration",  6.0 + Utility.RandomInt(0,18)*1.0 )
		Debug.MessageBox("Stop slouching about. Here is something to improve your posture.")
		
 	ElseIf (sTaskName=="Wash")
		Debug.MessageBox("Look how horny you made me. Get on your knees and clean this up with your tongue.")
		kMaster.SendModEvent("PCSubSex","Oral")

 	ElseIf (sTaskName=="Ignore")
		StorageUtil.SetFloatValue(fKeyword, "_SD_fTaskDuration",  Utility.RandomInt(4,8)*1.0 )
		StorageUtil.SetIntValue(fKeyword, "_SD_iTaskTargetDifference",  -1 * Utility.RandomInt(1,5) )
		Debug.MessageBox("Be quiet now. I am busy.")

	Endif
  
EndFunction


Function debugTrace(string traceMsg)
	if (StorageUtil.GetIntValue(none, "_SD_debugTraceON")==1)
		Debug.Trace("[_sdqs_fcts_slavery]"  + traceMsg)
	endif
endFunction 
