Scriptname _sdqs_fcts_slavery extends Quest  

function InitSlaveryState( Actor kSlave )
	_SDGVP_enslaved.SetValue( 0 )

	; API variables
	StorageUtil.SetIntValue(kSlave, "_SD_iEnslaved", 0)
	StorageUtil.SetFloatValue(kSlave, "_SD_fEnslavedGameTime", 0.0)
	StorageUtil.SetFloatValue(kSlave, "_SD_fLastEnslavedGameTime", 0.0)
	StorageUtil.SetFloatValue(kSlave, "_SD_fLastReleasedGameTime", 0.0)
	StorageUtil.SetFloatValue(kSlave, "_SD_fPunishmentGameTime", 0.0)
	StorageUtil.SetFloatValue(kSlave, "_SD_fPunishmentDuration", 0.0)

	If (!StorageUtil.HasIntValue(kSlave, "_SD_iSlaveryLevel"))
		StorageUtil.SetIntValue(kSlave, "_SD_iSlaveryLevel", 0)
	EndIf

EndFunction


function StartSlavery( Actor kMaster, Actor kSlave)
	_SDGVP_enslaved.SetValue( 1 )

	; API variables
	StorageUtil.SetIntValue(kSlave, "_SD_iEnslaved", 1)
	StorageUtil.SetFloatValue(kSlave, "_SD_fLastEnslavedGameTime", StorageUtil.GetFloatValue(kSlave, "_SD_fEnslavedGameTime"))
	StorageUtil.SetFloatValue(kSlave, "_SD_fEnslavedGameTime", _SDGVP_gametime.GetValue())
	StorageUtil.SetFloatValue(kSlave, "_SD_fPunishmentGameTime", 0.0)
	StorageUtil.SetFloatValue(kSlave, "_SD_fPunishmentDuration", 0.0)

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

	If (!StorageUtil.HasIntValue(kMaster, "_SD_iRelationshipType"))
		StorageUtil.SetIntValue(kMaster, "_SD_iRelationshipType", -5) 
	EndIf
	If (!StorageUtil.HasIntValue(kMaster, "_SD_iForcedSlavery"))
		StorageUtil.SetIntValue(kMaster, "_SD_iForcedSlavery", 1) 
	EndIf

	If (!StorageUtil.HasIntValue(kSlave, "_SD_iSlaveryLevel"))
		StorageUtil.SetIntValue(kSlave, "_SD_iSlaveryLevel", 0)
	EndIf
	
	; Compatibility with other mods
	StorageUtil.StringListAdd(kMaster, "_DDR_DialogExclude", "SD+:Master")
EndFunction


function StopSlavery( Actor kMaster, Actor kSlave)
	_SDGVP_enslaved.SetValue( 0 )

	; API variables
	StorageUtil.SetIntValue(kSlave, "_SD_iEnslaved", 0)
	StorageUtil.SetFloatValue(kSlave, "_SD_fLastReleasedGameTime", _SDGVP_gametime.GetValue())
	StorageUtil.SetFloatValue(kSlave, "_SD_fPunishmentGameTime", 0.0)
	StorageUtil.SetFloatValue(kSlave, "_SD_fPunishmentDuration", 0.0)

	StorageUtil.SetIntValue(kMaster, "_SD_iRelationshipType", kMaster.GetRelationshipRank(kSlave) ) 

	; Compatibility with other mods
	StorageUtil.StringListRemove(kMaster, "_DDR_DialogExclude", "SD+:Master")
EndFunction

; function RefreshGlobalValues()
; function UpdateStatusHourly()
; function UpdateStatusDaily()

SexLabFrameWork Property SexLab Auto

GlobalVariable Property _SDGVP_gametime  Auto  
GlobalVariable Property _SDGVP_enslaved  Auto  
