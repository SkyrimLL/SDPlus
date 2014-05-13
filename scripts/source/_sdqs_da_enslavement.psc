Scriptname _SDQS_DA_Enslavement extends  daymoyl_QuestTemplate  


; Quest does stuff here
Actor akMaster
Actor akPlayer

Bool Function QuestCondition(Location akLocation, Actor akAggressor, Actor akFollower)
{Condition that must be satisfied for the quest to fire. Should be overloaded in the childs}
	akPlayer = Game.GetPlayer() as Actor

	Debug.Trace("[SD DA integration] QuestCondition - Enslavement")
	
	if (Utility.RandomInt(0,100)<=_SDGVP_health_threshold.GetValue()) && ( (akAggressor.HasKeyword( _SDKP_actorTypeNPC ) || (akAggressor.GetRace() == falmerRace)) && funct.checkGenderRestriction( akAggressor, akPlayer ) ) && !funct.actorFactionInList( akAggressor, _SDFLP_banned_factions ) 
		return IsStopped()
	else
		return false
	endif
EndFunction
 

_SDQS_functions Property funct  Auto
Race Property FalmerRace  Auto  
Keyword Property _SDKP_actorTypeNPC  Auto
FormList Property _SDFLP_banned_factions  Auto



GlobalVariable Property _SDGVP_health_threshold  Auto  
