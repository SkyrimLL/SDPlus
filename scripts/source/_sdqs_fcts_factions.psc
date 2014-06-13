Scriptname _sdqs_fcts_factions extends Quest  
{ USED }
Import Utility
Import SKSE


Bool Function actorFactionInList( Actor akActor, FormList akFactionList, FormList akBannedFactionList = None )
	Int index
	Int size
	Bool found = False
	Bool banned = False

	If ( akActor && !akActor.IsEssential() && !akActor.IsDead() )
		If ( akBannedFactionList )
			index = 0
			size = akBannedFactionList.GetSize()
			While ( index < size && !banned )
				banned = akActor.IsInFaction( akBannedFactionList.GetAt(index) as Faction )
				index += 1
			EndWhile
		EndIf

		If ( !banned )
			index = 0
			size = akFactionList.GetSize()
			While ( index < size && !found )
				found = akActor.IsInFaction( akFactionList.GetAt(index) as Faction )
				index += 1
			EndWhile
		EndIf
	EndIf

	Debug.Trace("_SD::actorFactionInList akActor:" + akActor + " found:" + found )
	Return found
EndFunction


Function resetAllyToActor( Actor akSlave, FormList alFactionListIn )
	Int index = 0
	Int size = alFactionListIn.GetSize()

	While ( index < size )
		Faction nTHfaction = alFactionListIn.GetAt(index) as Faction
		akSlave.RemoveFromFaction( nTHfaction )
		index += 1
	EndWhile

	alFactionListIn.Revert()
EndFunction


Bool Function allyToActor( Actor akMaster, Actor akSlave, FormList alFactionListIn, FormList alFactionListOut = None )
	Int index = 0
	Int size = alFactionListIn.GetSize()
	Bool ret = False

	If ( akMaster == None || akSlave == None )
		Return ret
	EndIf

	If ( alFactionListOut != None && alFactionListOut.GetSize() > 0 )
		resetAllyToActor( akSlave, alFactionListOut )
	EndIf

	If ( !qualifyActor( akMaster, False ) )
		Return ret
	EndIf

	While ( index < size )
		Faction nTHfaction = alFactionListIn.GetAt(index) as Faction

		If ( akMaster.IsInFaction( nTHfaction ) && !akSlave.IsInFaction( nTHfaction ) )
			If ( alFactionListOut != None )
				alFactionListOut.AddForm( nTHfaction )
			EndIf
			akSlave.AddToFaction( nTHfaction )
			ret = True
		EndIf
		index += 1
	EndWhile

	Return ret
EndFunction

Bool Function qualifyActor( Actor akActor, Bool abCheckInScene = True )
	Bool bOutOfScene = ( !abCheckInScene || ( abCheckInScene && akActor.GetCurrentScene() == None ) )
	Return ( !akActor.IsDead() && !akActor.IsDisabled() && bOutOfScene )
EndFunction



Function syncActorFactions( Actor akMaster, Actor akSlave, FormList alFactionListOut = None )

	Int iFormIndex = ( akMaster as ObjectReference ).GetNumItems()
	While ( iFormIndex > 0 )
		iFormIndex -= 1
		Form nthForm = ( akMaster as ObjectReference ).GetNthForm(iFormIndex)
		If ( nthForm && nthForm.GetType() == 11 )
			If ( alFactionListOut != None )
				alFactionListOut.AddForm( nthForm as Faction )
			EndIf
			akSlave.AddToFaction( nthForm as Faction )
		EndIf
	EndWhile

EndFunction
