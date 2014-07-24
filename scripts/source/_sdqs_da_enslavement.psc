Scriptname _SDQS_DA_Enslavement extends  daymoyl_QuestTemplate  


daymoyl_MonitorVariables 	Property Variables Auto
daymoyl_MonitorUtility 		Property Util 		Auto


bool	bFirstUpdate

Location thisLocation
Actor thisPlayer
Actor thisAggressor

Bool Function QuestCondition(Location akLocation, Actor akAggressor, Actor akFollower)
{Condition that must be satisfied for the quest to fire. Should be overloaded in the childs}
	Debug.Trace("SD Blackout: condition")
	Actor akPlayer = Game.GetPlayer()
	UnregisterForModEvent("da_PlayerRecovered")

	thisLocation = akLocation
	thisPlayer = Game.GetPlayer()
	thisAggressor = akAggressor

	Debug.Trace("SD Blackout start master:" + thisAggressor)
	; Debug.Notification("SD Blackout start master:" + thisAggressor)
	
	if (Utility.RandomInt(0,100)<=_SDGVP_health_threshold.GetValue()) && ( (thisAggressor.HasKeyword( _SDKP_actorTypeNPC ) || (  fctFactions.checkIfFalmer ( akAggressor) )) && funct.checkGenderRestriction( thisAggressor, thisPlayer ) ) && !fctFactions.actorFactionInList( thisAggressor, _SDFLP_banned_factions )
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
		Debug.Trace("SD Blackout failed: Timeout")
		UnregisterForModEvent("da_PlayerRecovered")	
		
		; what to do? do we risk starting enslavement anyway?
	endif
endEvent


Event EnslaveAtEndOfBleedout(string eventName, string strArg, float numArg, Form sender) ; player has finished ragdolling/animating and controls are all back

	Debug.Trace("SD Blackout end")
	UnregisterForUpdate()
	UnregisterForModEvent("da_PlayerRecovered")

		; Debug.SendAnimationEvent(akPlayer , "ZazAPC057")
		; _SDGV_leash_length.SetValue(400)

	Debug.Trace("SD Blackout end master:" + thisAggressor)
	; Debug.Notification("Blackout end master:" + thisAggressor)

	if (thisAggressor)
		_SDKP_enslave.SendStoryEvent( akLoc = thisLocation, akRef1 = thisAggressor, akRef2 = thisPlayer, aiValue1 = 0, aiValue2 = 0)
	else
		; Debug.MessageBox("[SD] Problem - Aggressor was reset before enslavement in _sd_da_enslavement.")
	EndIf

endEvent



_SDQS_functions Property funct  Auto
_SDQS_fcts_factions Property fctFactions  Auto
Race Property FalmerRace  Auto  
Keyword Property _SDKP_actorTypeNPC  Auto
FormList Property _SDFLP_banned_factions  Auto

Keyword 			Property _SDKP_enslave  Auto

GlobalVariable Property _SDGVP_health_threshold  Auto  

ReferenceAlias Property Alias_theBandit  Auto  
