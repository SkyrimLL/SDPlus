Scriptname _SDQS_DA_DreamworldDeath extends daymoyl_QuestTemplate

daymoyl_MonitorVariables 	Property Variables Auto
daymoyl_MonitorUtility 		Property Util 		Auto

Location thisLocation
Actor thisPlayer
Actor thisAggressor

bool	bFirstUpdate

Bool Function QuestCondition(Location akLocation, Actor akAggressor, Actor akFollower)
{Condition that must be satisfied for the quest to fire. Should be overloaded in the childs}
	Debug.Trace("SD DA dreamworld death condition")

	thisLocation = akLocation
	thisPlayer = Game.GetPlayer()
	thisAggressor = akAggressor

	UnregisterForModEvent("da_PlayerRecovered")
	
	if (StorageUtil.GetIntValue(none, "_SD_iForcedDreamworld") ==1) || (_SD_dreamQuest.GetStage() != 0) 
		return true
	else
		return false
	endif
EndFunction
 
bool Function QuestStart(Location akLocation, Actor akAggressor, Actor akFollower)
	Debug.Trace("SD DA dreamworld death: selected")

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
		Debug.Trace("SD DA dreamworld death failed: Timeout")
		UnregisterForModEvent("da_PlayerRecovered")	
		
		; what to do? do we risk starting enslavement anyway?
		Debug.Trace("SD DA dreamworld death: Teleport anyway")
		_SD_dreamQuest.SetStage(100)
	endif
endEvent


Event EnslaveAtEndOfBleedout(string eventName, string strArg, float numArg, Form sender) ; player has finished ragdolling/animating and controls are all back

	Debug.Trace("SD DA dreamworld death end")
	UnregisterForUpdate()
	UnregisterForModEvent("da_PlayerRecovered")

	_SD_dreamQuest.SetStage(100)

endEvent

Quest  Property _SD_dreamQuest  Auto  

