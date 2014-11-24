Scriptname _sdqs_fcts_factions extends Quest  
{ USED }
Import Utility
Import SKSE

_SDQS_functions Property funct  Auto

Keyword Property _SDKP_actorTypeNPC  Auto
FormList Property _SDFLP_banned_factions  Auto

Bool Function checkIfSlaver ( Actor akActor )
	Bool isSlaver = ( (akActor.HasKeyword( _SDKP_actorTypeNPC ) && funct.checkGenderRestriction( akActor, Game.GetPlayer() ) ) || (   checkIfFalmer ( akActor) )) && !akActor.IsGhost() && !actorFactionInList( akActor, _SDFLP_banned_factions )

	; Debug.Trace("[SD] Enslavement check - " + akActor)
	; Debug.Trace("[SD] Actor is NPC - " + akActor.HasKeyword( _SDKP_actorTypeNPC ))
	; Debug.Trace("[SD] Gender restriction check - " + funct.checkGenderRestriction( akActor, Game.GetPlayer() ))
	; Debug.Trace("[SD] Actor is Falmer - " + checkIfFalmer ( akActor))
	; Debug.Trace("[SD] Actor is Ghost - " + akActor.IsGhost())
	; Debug.Trace("[SD] Actor is Player - " + (akActor != Game.GetPlayer()))
	; Debug.Trace("[SD] Member of banned faction - " + actorFactionInList( akActor, _SDFLP_banned_factions ))
	; Debug.Trace("[SD] Enslavement check - " + akActor)
	; Debug.Trace("[SD] Result - Actor Is Slaver - " + isSlaver + " --------- ")

	return isSlaver
EndFunction

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

Bool Function checkIfSpriggan ( Actor akActor )
	Bool bIsSpriggan = False
	Race _SD_Race_SprigganEarthMother = StorageUtil.GetFormValue(None, "_SD_Race_SprigganEarthMother") as Race
	Race _SD_Race_SprigganBurnt = StorageUtil.GetFormValue(None, "_SD_Race_SprigganBurnt") as Race


	if (akActor)
		Int index = 0
		Int size = _SDFLP_spriggan_factions.GetSize()
		While ( !bIsSpriggan && index < size )
			bIsSpriggan = (akActor.IsInFaction( _SDFLP_spriggan_factions.GetAt(index) as Faction ) && !(akActor as Form).HasKeywordString("_SD_infected")) || (akActor.GetRace() == SprigganRace) || ( (_SD_Race_SprigganEarthMother!=None) && (akActor.GetRace() == _SD_Race_SprigganEarthMother)) || ( (_SD_Race_SprigganBurnt!=None) && (akActor.GetRace() == _SD_Race_SprigganBurnt))
			index += 1
		EndWhile
	EndIf
	
	Return bIsSpriggan
EndFunction

Bool Function checkIfFalmer ( Actor akActor )
	Bool bIsFalmer = False
	Race _SD_Race_FalmerFrozen = StorageUtil.GetFormValue(None, "_SD_Race_FalmerFrozen") as Race

	if (akActor)
		Int index = 0
		Int size = _SDFLP_falmer_factions.GetSize()
		While ( !bIsFalmer && index < size )
			bIsFalmer = akActor.IsInFaction( _SDFLP_falmer_factions.GetAt(index) as Faction ) || akActor.GetRace() == FalmerRace  || ( (_SD_Race_FalmerFrozen!=None) && (akActor.GetRace() == _SD_Race_FalmerFrozen))
			index += 1
		EndWhile
	EndIf
	
	Return bIsFalmer
EndFunction

  
Bool Function checkIfFollower ( Actor akActor )
	Bool bIsFollower = False

	if (akActor)
		Int index = 0
		Int size = _SDFLP_follower_factions.GetSize()
		While ( !bIsFollower && index < size )
			bIsFollower = akActor.IsInFaction( _SDFLP_follower_factions.GetAt(index) as Faction )  
			index += 1
		EndWhile
	EndIf
	
	Return bIsFollower
EndFunction


Race Property FalmerRace  Auto  
Race Property SprigganRace  Auto  
FormList Property _SDFLP_falmer_factions  Auto
FormList Property _SDFLP_follower_factions  Auto
FormList Property _SDFLP_spriggan_factions  Auto