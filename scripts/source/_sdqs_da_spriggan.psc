Scriptname _SDQS_DA_Spriggan extends  daymoyl_QuestTemplate  

Actor akMaster
Actor akPlayer
; Quest does stuff here

Bool Function QuestCondition(Location akLocation, Actor akAggressor, Actor akFollower)
{Condition that must be satisfied for the quest to fire. Should be overloaded in the childs}
	akPlayer = Game.GetPlayer() as Actor

	Debug.Trace("[SD DA integration] QuestCondition - Spriggan")
	
	If    (Utility.RandomInt(0,100)<=_SDGVP_health_threshold.GetValue()) &&  ( ((akAggressor.GetRace() == sprigganRace) || (akAggressor.IsInFaction(SprigganFaction  )) )&& !(akPlayer as Form).HasKeywordString("_SD_infected") && ( StorageUtil.GetIntValue(Game.GetPlayer(), "SacrSpriggans_iSprigganInfected") != 1) ) 
		Debug.Trace("[SD DA integration] QuestCondition - Spriggan - Passed")
		return IsStopped()
	else
		Debug.Trace("[SD DA integration] QuestCondition - Spriggan - Failed")
		return false
	endif
	
EndFunction

 

_SDQS_functions Property funct  Auto
Race Property SprigganRace  Auto  
Faction  Property SprigganFaction  Auto  

GlobalVariable Property _SDGVP_health_threshold  Auto  

