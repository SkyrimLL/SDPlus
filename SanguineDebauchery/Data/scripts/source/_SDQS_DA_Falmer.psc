Scriptname _SDQS_DA_Falmer extends  daymoyl_QuestTemplate  

daymoyl_MonitorVariables 	Property Variables Auto
daymoyl_MonitorUtility 		Property Util 		Auto

Location thisLocation
Actor thisPlayer
Actor thisAggressor

bool	bFirstUpdate

Bool Function QuestCondition(Location akLocation, Actor akAggressor, Actor akFollower)
{Condition that must be satisfied for the quest to fire. Should be overloaded in the childs}
	Debug.Trace("SD Blackout: condition")
	Actor akPlayer = Game.GetPlayer()
	UnregisterForModEvent("da_PlayerRecovered")

	thisLocation = akLocation
	thisPlayer = Game.GetPlayer()
	thisAggressor = akAggressor

	Debug.Trace("SD Blackout start enslavement attempt (Creature):" + thisAggressor)
	Debug.Trace("	start master is Humanoid:" + StorageUtil.GetIntValue( thisAggressor, "_SD_bIsSlaverCreature"))
	; Debug.Notification("SD Blackout start master:" + thisAggressor)
	
	if (Utility.RandomInt(1,100)<=_SDGVP_health_threshold.GetValue()) && (StorageUtil.GetIntValue(thisPlayer, "_SD_iEnslavementInitSequenceOn")!=1) && (StorageUtil.GetIntValue( thisAggressor, "_SD_bIsSlaverCreature") == 1)  ; Simplified check for DA only - SD mod event will handle complex faction checks
		return true
	else
		return false
	endif
EndFunction
 
 
bool Function QuestStart(Location akLocation, Actor akAggressor, Actor akFollower)
	Debug.Trace("SD Blackout : selected")

	thisLocation = akLocation
	thisPlayer = Game.GetPlayer()
	thisAggressor = akAggressor

	SendModEvent("da_StartRecoverSequence", numArg = 100, strArg = "KeepBlackScreen") ;Without this the "fall through floor bug occurs"
	
	registerforsingleupdate(4)

	Debug.Trace("SD Blackout end master:" + thisAggressor)
	; Debug.Notification("Blackout end master:" + thisAggressor)

	if (thisAggressor)
		; Debug.Trace("[SD] Sending enslavement story.")
 		StorageUtil.SetIntValue(thisAggressor, "_SD_iForcedSlavery", 1)
		StorageUtil.SetIntValue(thisAggressor, "_SD_iSpeakingNPC", 1)
		thisAggressor.SendModEvent("PCSubEnslave")
	else
		Debug.Trace("[SD] Problem - Aggressor was reset before enslavement in _sd_da_enslavement.")
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

Race Property FalmerRace  Auto  
Faction  Property FalmerFaction  Auto  

GlobalVariable Property _SDGVP_health_threshold  Auto  


Keyword Property _SDKP_falmer  Auto