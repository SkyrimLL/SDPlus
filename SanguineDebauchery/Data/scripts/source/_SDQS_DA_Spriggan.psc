Scriptname _SDQS_DA_Spriggan extends  daymoyl_QuestTemplate  

daymoyl_MonitorVariables 	Property Variables Auto
daymoyl_MonitorUtility 		Property Util 		Auto

Location thisLocation
Actor thisPlayer
Actor thisAggressor

bool	bFirstUpdate

Bool Function QuestCondition(Location akLocation, Actor akAggressor, Actor akFollower)
{Condition that must be satisfied for the quest to fire. Should be overloaded in the childs}
	Debug.Trace("SD DA spriggan: condition")

	thisLocation = akLocation
	thisPlayer = Game.GetPlayer()
	thisAggressor = akAggressor

	UnregisterForModEvent("da_PlayerRecovered")

	; StorageUtil.GetIntValue(kSlave, "_SD_iSprigganEnslavedCount")
	Debug.Trace("SD Blackout start infection attempt (Spriggan):" + thisAggressor)
	Debug.Trace("	start master is Spriggan:" + StorageUtil.GetIntValue( thisAggressor, "_SD_bIsSpriggan"))
	
	If    (Utility.RandomInt(1,100)<=_SDGVP_config_healthMult.GetValue())  && ( !(thisPlayer as Form).HasKeywordString("_SD_infected") && ( StorageUtil.GetIntValue(thisPlayer, "_SD_iSprigganInfected") != 1) )  && (StorageUtil.GetIntValue(thisPlayer, "_SD_iEnslavementInitSequenceOn")!=1)   && (StorageUtil.GetIntValue( thisAggressor, "_SD_bIsSpriggan") == 1)  ; Simplified check for DA only - SD mod event will handle complex faction checks
		Debug.Trace("[SD DA integration] QuestCondition - Spriggan - Passed")
		return true
	else
		Debug.Trace("[SD DA integration] QuestCondition - Spriggan - Failed")
		return false
	endif
	
EndFunction

bool Function QuestStart(Location akLocation, Actor akAggressor, Actor akFollower)
	Debug.Trace("SD DA Spriggan : selected")

	thisLocation = akLocation
	thisPlayer = Game.GetPlayer()
	thisAggressor = akAggressor

	SendModEvent("da_StartRecoverSequence", numArg = 100, strArg = "KeepBlackScreen") ;Without this the "fall through floor bug occurs"
	
	registerforsingleupdate(4)

	Debug.Trace("SD DA Spriggan end master:" + thisAggressor)
	; Debug.Notification("SD DA Spriggan end master:" + thisAggressor)

	; _SDKP_spriggan.SendStoryEvent(akRef1 = thisAggressor, akRef2 = thisPlayer, aiValue1 = 0, aiValue2 = 0)
  	if (thisAggressor)
		Debug.Trace("[SD] Sending spriggan enslavement story for actor: " + thisAggressor)
		; StorageUtil.SetIntValue(thisAggressor, "_SD_iForcedSlavery", 1)
		; StorageUtil.SetIntValue(thisAggressor, "_SD_iSpeakingNPC", 0)
		thisAggressor.SendModEvent("SDSprigganEnslave")
	else
		Debug.Trace("[SD] Problem - Aggressor was reset before enslavement in _sd_da_spriggan.")
	EndIf
	utility.wait(3)

	SendModEvent("da_StartRecoverSequence") ;The earlier call doesn't seem to clear the bleedout state so repeat the call
	
	return true
endFunction

Event OnUpdate()
	; Game.getplayer().moveto(SSLV_CageMark) 
	; SSLV_CageMark.Activate(Game.GetPlayer())
	; GameHour.Mod(1.0) ; wait 8 hours game time 
endevent
 

_SDQS_functions Property funct  Auto
_SDQS_fcts_factions Property fctFactions  Auto

Race Property SprigganRace  Auto  
Faction  Property SprigganFaction  Auto  

GlobalVariable Property _SDGVP_health_threshold  Auto  
GlobalVariable Property _SDGVP_config_healthMult  Auto


Keyword Property _SDKP_spriggan  Auto