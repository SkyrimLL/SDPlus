Scriptname _SDQS_DA_Dreamworld extends  daymoyl_QuestTemplate  Hidden

Bool Function QuestCondition(Location akLocation, Actor akAggressor, Actor akFollower)
{Condition that must be satisfied for the quest to fire. Should be overloaded in the childs}

	Debug.Trace("[SD DA integration] QuestCondition - Dreamworld")
	
	if (_SDGVP_sanguine_blessing.GetValue() > 0)  && (_SDGVP_enslaved.GetValue() == 0)

		return IsStopped()
	else
		return false
	endif
EndFunction

GlobalVariable Property  _SDGVP_sanguine_blessing Auto

 
GlobalVariable Property _SDGVP_enslaved  Auto  
