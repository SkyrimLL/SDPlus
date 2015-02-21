Scriptname _SDQS_DA_Falmer extends  daymoyl_QuestTemplate  

daymoyl_MonitorVariables 	Property Variables Auto
daymoyl_MonitorUtility 		Property Util 		Auto

Location thisLocation
Actor thisPlayer
Actor thisAggressor

bool	bFirstUpdate

Bool Function QuestCondition(Location akLocation, Actor akAggressor, Actor akFollower)
{Condition that must be satisfied for the quest to fire. Should be overloaded in the childs}
	Debug.Trace("SD DA Falmer: condition")

	thisLocation = akLocation
	thisPlayer = Game.GetPlayer()
	thisAggressor = akAggressor

	UnregisterForModEvent("da_PlayerRecovered")

	
	If    (Utility.RandomInt(0,100)<=_SDGVP_health_threshold.GetValue()) && !fctFactions.checkIfSlaver (  thisAggressor )  && fctFactions.checkIfSlaverCreature (  thisAggressor ) && fctFactions.checkIfFalmer (  thisAggressor )  &&  !fctFactions.checkIfFollower (  thisAggressor ) 
		Debug.Trace("[SD DA integration] QuestCondition - Falmer - Passed")
		return true
	else
		Debug.Trace("[SD DA integration] QuestCondition - Falmer - Failed")
		return false
	endif
	
EndFunction

bool Function QuestStart(Location akLocation, Actor akAggressor, Actor akFollower)
	Debug.Trace("SD DA Falmer: selected")

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
		Debug.Trace("SD DA falmer failed: Timeout")
		UnregisterForModEvent("da_PlayerRecovered")	
		
		; what to do? do we risk starting enslavement anyway?
	endif
endEvent


Event EnslaveAtEndOfBleedout(string eventName, string strArg, float numArg, Form sender) ; player has finished ragdolling/animating and controls are all back

	Debug.Trace("SD DA falmer end")
	UnregisterForUpdate()
	UnregisterForModEvent("da_PlayerRecovered")

 	if (thisAggressor)
		Debug.Trace("[SD] Sending enslavement story for actor: " + thisAggressor)
		thisAggressor.SendModEvent("PCSubEnslave")
	else
		Debug.Trace("[SD] Problem - Aggressor was reset before enslavement in _sd_da_enslavement.")
	EndIf

endEvent 

_SDQS_functions Property funct  Auto
_SDQS_fcts_factions Property fctFactions  Auto

Race Property FalmerRace  Auto  
Faction  Property FalmerFaction  Auto  

GlobalVariable Property _SDGVP_health_threshold  Auto  


Keyword Property _SDKP_falmer  Auto