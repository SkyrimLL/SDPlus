Scriptname _SDQS_DA_DreamworldDeath extends daymoyl_QuestTemplate

; Quest does stuff here
Actor akMaster
Actor akPlayer

Bool Function QuestCondition(Location akLocation, Actor akAggressor, Actor akFollower)
{Condition that must be satisfied for the quest to fire. Should be overloaded in the childs}
	akPlayer = Game.GetPlayer() as Actor

	Debug.Trace("[SD DA integration] QuestCondition - Death / Dreamworld")
	
	if (StorageUtil.GetIntValue(none, "_SD_iForcedDreamworld") ==1) || (_SD_dreamQuest.GetStage() != 0) 
		return IsStopped()
	else
		return false
	endif
EndFunction
 

Quest  Property _SD_dreamQuest  Auto  

