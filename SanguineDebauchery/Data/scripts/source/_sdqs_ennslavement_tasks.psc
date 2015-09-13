Scriptname _SDQS_ennslavement_tasks extends Quest Conditional

Bool Property _SDBP_task_complete = False Auto Conditional
String[] Property _SDSTRP_stat  Auto  
{ http://www.creationkit.com/QueryStat_-_Game }
Int[] Property _SDUIP_quantity  Auto  
Bool[] Property _SDBP_autostop  Auto  
Class[] Property _SDCP_master_class  Auto  
Faction[] Property _SDFP_master_faction  Auto  

Int iNextStage
Int iStatWatch
Int iStatIndex
Int iObjective

Event OnStoryScript(Keyword akKeyword, Location akLocation, ObjectReference akRef1, ObjectReference akRef2, int aiValue1, int aiValue2)
	; pause for quest startup else scene won't start
	While ( !Self.IsRunning() )
	EndWhile

	iObjective = aiValue1
	iStatIndex = Math.Floor(aiValue1/10) - 1
	iNextStage = aiValue1 + 1
	iStatWatch = Game.QueryStat( _SDSTRP_stat[iStatIndex] ) + _SDUIP_quantity[iStatIndex]
	_SDBP_task_complete = False
	
	Self.SetStage( iObjective )
	Self.SetObjectiveDisplayed( iObjective, True, True )
	
	RegisterForTrackedStatsEvent()
	RegisterForSingleUpdateGameTime( aiValue2 as Float )
EndEvent

Event OnTrackedStatsEvent(string asStatFilter, int aiStatValue)
	If ( asStatFilter == _SDSTRP_stat[iStatIndex] && aiStatValue >= iStatWatch && Self.GetStage() < iNextStage )
		_SDBP_task_complete = True
		Self.SetObjectiveCompleted( iObjective )
		Self.SetStage( iNextStage )
		
		If ( _SDBP_autostop[iStatIndex] )
			Self.Stop()
		EndIf
	EndIf
EndEvent

Event OnUpdateGameTime()
	If ( Self.GetStage() != iNextStage )
		Self.SetObjectiveDisplayed( iObjective, False )
		Self.SetStage( iNextStage )

		If ( _SDBP_autostop[iStatIndex] )
			Self.Stop()
		EndIf
	EndIf
EndEvent
