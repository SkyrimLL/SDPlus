Scriptname _sdqs_DA_DreamworldBlackout extends daymoyl_QuestTemplate

daymoyl_MonitorVariables 	Property Variables Auto
daymoyl_MonitorUtility 		Property Util 		Auto

Location thisLocation
Actor thisPlayer
Actor thisAggressor

bool	bFirstUpdate

Bool Function QuestCondition(Location akLocation, Actor akAggressor, Actor akFollower)
{Condition that must be satisfied for the quest to fire. Should be overloaded in the childs}
	Debug.Trace("SD DA dreamworld blackout: condition")

	thisLocation = akLocation
	thisPlayer = Game.GetPlayer()
	thisAggressor = akAggressor

	UnregisterForModEvent("da_PlayerRecovered")

	
	if (Utility.RandomInt(0,100)<=_SDGVP_health_threshold.GetValue()) && ( _SDGVP_Sanguine_Blessing.GetValue() >0) && ( (akAggressor.HasKeyword( _SDKP_actorTypeNPC ) || (akAggressor.GetRace() == falmerRace)) && funct.checkGenderRestriction( akAggressor, thisPlayer ) ) && !fctFactions.actorFactionInList( akAggressor, _SDFLP_banned_factions ) 
		return true
	else
		return false
	endif
EndFunction
 
bool Function QuestStart(Location akLocation, Actor akAggressor, Actor akFollower)
	Debug.Trace("SD DA dreamworld blackout: selected")

	thisLocation = akLocation
	thisPlayer = Game.GetPlayer()
	thisAggressor = akAggressor
	
	Util.WaitGameHours(Variables.BlackoutTimeLapse * 24.0)
	; if you need to move the player, do it here
	
	bFirstUpdate = true
	RegisterForSingleUpdate(Variables.BlackoutRealTimeLapse)
		; this is necessary because we need to wait a few sec for a nice transition but this function needs to return asap.
	return true
endFunction


Event OnUpdate()
	if(bFirstUpdate)
		RegisterForModEvent("da_PlayerRecovered", "EnslaveAtEndOfBleedout")
		SendModEvent("da_StartRecoverSequence", numArg = 9999.0)		
		RegisterForSingleUpdate(10.0)
		bFirstUpdate = false
	else
		Debug.Trace("SD DA dreamworld blackout failed: Timeout")
		UnregisterForModEvent("da_PlayerRecovered")	
		
		; what to do? do we risk starting enslavement anyway?
	endif
endEvent


Event EnslaveAtEndOfBleedout(string eventName, string strArg, float numArg, Form sender) ; player has finished ragdolling/animating and controls are all back

	Debug.Trace("SD DA dreamworld blackout end")
	UnregisterForUpdate()
	UnregisterForModEvent("da_PlayerRecovered")

	_SD_dreamQuest.SetStage(100)

endEvent

_SDQS_functions Property funct  Auto
_SDQS_fcts_factions Property fctFactions  Auto

Race Property FalmerRace  Auto  
Keyword Property _SDKP_actorTypeNPC  Auto
FormList Property _SDFLP_banned_factions  Auto


Quest Property _SD_dreamQuest  Auto

GlobalVariable Property _SDGVP_health_threshold  Auto  

GlobalVariable Property _SDGVP_Sanguine_Blessing  Auto  
