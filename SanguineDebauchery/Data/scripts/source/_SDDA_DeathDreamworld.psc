Scriptname _SDDA_DeathDreamworld extends daymoyl_QuestTemplate  


GlobalVariable Property GameHour Auto

Location thisLocation
Actor thisPlayer
Actor thisAggressor

Bool Function QuestCondition(Location akLocation, Actor akAggressor, Actor akFollower)
{Condition that must be satisfied for the quest to fire. Should be overloaded in the childs}
	Debug.Trace("[SDDA] Death Dreamworld: condition")

	thisLocation = akLocation
	thisPlayer = Game.GetPlayer()
	thisAggressor = akAggressor

	Debug.Trace("[SDDA] Death Dreamworld start enslavement attempt (Humanoid):" + thisAggressor)
	Debug.Trace("	start master is Humanoid:" + StorageUtil.GetIntValue( thisAggressor, "_SD_bIsSlaverHumanoid"))
	
	if (StorageUtil.GetIntValue(thisPlayer, "_SD_iSanguineBlessings") > 0)  && (StorageUtil.GetIntValue(thisPlayer, "_SD_iEnslaved")==0)

		return true
	else
		return false
	endif

EndFunction

bool Function QuestStart(Location akLocation, Actor akAggressor, Actor akFollower)
	Debug.Trace("[SDDA] Death Dreamworld: selected")
	
	SendModEvent("da_StartRecoverSequence", numArg = 100, strArg = "KeepBlackScreen") ;Without this the "fall through floor bug occurs"
	
	registerforsingleupdate(4)

	SendModEvent("SDDreamworldPull", 100) 

	utility.wait(3)

	SendModEvent("da_StartRecoverSequence") ;The earlier call doesn't seem to clear the bleedout state so repeat the call
	
	return true
endFunction

Event OnUpdate()
	; Game.getplayer().moveto(SSLV_CageMark) 
	; SSLV_CageMark.Activate(Game.GetPlayer())


	GameHour.Mod(8.0) ; wait 8 hours game time 
endevent

