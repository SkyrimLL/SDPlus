Scriptname _sdqs_fcts_factions extends Quest  
{ USED }
Import Utility
Import SKSE

_SDQS_functions Property funct  Auto

Keyword Property _SDKP_actorTypeNPC  Auto
FormList Property _SDFLP_banned_factions  Auto
FormList Property _SDFLP_banned_actors  Auto

Bool Function checkIfSlaver ( Actor akActor )
	Int  playerGender = Game.GetPlayer().GetLeveledActorBase().GetSex() as Int
	Actor akPlayer = Game.getPlayer() as Actor

	If (akActor == akPlayer)
		; Debug.Notification("[SD] Slaver is Player!" )
		; return False
	EndIf

	Bool isSlaver = ( (akActor.HasKeyword( _SDKP_actorTypeNPC ) && funct.checkGenderRestriction( akActor, Game.GetPlayer() ) )) && !akActor.IsGhost() && !actorFactionInList( akActor, _SDFLP_banned_factions ) && (!actorInList(_SDFLP_banned_actors, akActor))

	Debug.Trace("[SD] Enslavement check - " + akActor)
	Debug.Trace("[SD] Actor is NPC - " + akActor.HasKeyword( _SDKP_actorTypeNPC ))
	Debug.Trace("[SD] Gender restriction check - " + funct.checkGenderRestriction( akActor, Game.GetPlayer() ))
	; Debug.Trace("[SD] Actor is Falmer - " + checkIfFalmer ( akActor))
	Debug.Trace("[SD] Actor is Ghost - " + akActor.IsGhost())
	; Debug.Trace("[SD] Actor is Player - " + (akActor != Game.GetPlayer()))
	Debug.Trace("[SD] Member of banned faction - " + actorFactionInList( akActor, _SDFLP_banned_factions ))
	Debug.Trace("[SD] Member of banned actors - " + actorInList(_SDFLP_banned_actors , akActor))
	; Debug.Trace("[SD] Enslavement check - " + akActor)
	Debug.Trace("[SD] Result - Actor Is Slaver - " + isSlaver + " --------- ")

	If (checkIfSpriggan ( Game.GetPlayer() )) 
		isSlaver = False
	Endif
	
	If (akActor == ( StorageUtil.GetFormValue(akPlayer, "_SD_CurrentOwner") as Actor) ) 
		; Prevent new enslavement by current master
		isSlaver = False
	Endif
	
	return isSlaver
EndFunction

Bool Function checkIfSlaverCreature ( Actor akActor )
	Int  playerGender = Game.GetPlayer().GetLeveledActorBase().GetSex() as Int
	Actor akPlayer = Game.getPlayer() as Actor

	If (akActor == akPlayer)
		Debug.Notification("[SD] Slaver is Player!" )
		return False
	EndIf

	Bool isSlaver = ( (   checkIfFalmer ( akActor) && (playerGender == 1) )) && !checkIfSpriggan ( akActor ) && !akActor.IsGhost() && !actorFactionInList( akActor, _SDFLP_banned_factions ) && (!actorInList(_SDFLP_banned_actors, akActor))

	; Debug.Trace("[SD] Enslavement check - " + akActor)
	; Debug.Trace("[SD] Actor is NPC - " + akActor.HasKeyword( _SDKP_actorTypeNPC ))
	; Debug.Trace("[SD] Gender restriction check - " + funct.checkGenderRestriction( akActor, Game.GetPlayer() ))
	; Debug.Trace("[SD] Actor is Falmer - " + checkIfFalmer ( akActor))
	; Debug.Trace("[SD] Actor is Ghost - " + akActor.IsGhost())
	; Debug.Trace("[SD] Actor is Player - " + (akActor != Game.GetPlayer()))
	; Debug.Trace("[SD] Member of banned faction - " + actorFactionInList( akActor, _SDFLP_banned_factions ))
	; Debug.Trace("[SD] Member of banned actors - " + actorInList(_SDFLP_banned_actors , akActor))
	; Debug.Trace("[SD] Enslavement check - " + akActor)
	; Debug.Trace("[SD] Result - Actor Is Slaver - " + isSlaver + " --------- ")

	If (checkIfSpriggan ( Game.GetPlayer() ))
		isSlaver = False
	Endif

	If (akActor == ( StorageUtil.GetFormValue(akPlayer, "_SD_CurrentOwner") as Actor) ) 
		; Prevent new enslavement by current master
		isSlaver = False
	Endif

	return isSlaver
EndFunction

Bool Function actorInList(FormList akActorsList, Actor thisActor)
	Actor kActor
	int idx = 0
	while idx < akActorsList.GetSize()
		kActor = akActorsList.GetAt(idx) as Actor
		if kActor == thisActor as ObjectReference
			return True
		endif
		idx += 1
	endwhile
	Return False
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


; Function registerDeviousOutfitsKeywords ( Actor kActor )
;	Debug.Trace("[SD] Register devious keywords")
  
;	if (StorageUtil.FormListCount( kActor, "_SD_lDevicesKeyword") != 0)
;		Debug.Trace("[SD] Register devious keywords - aborting - list already set - " + StorageUtil.FormListCount( kActor, "_SD_lDevicesKeyword"))
;		Return
;	EndIf	

	; Register list of reference keywords for each device in list
;	StorageUtil.FormListAdd( kActor, "_SD_lDevicesKeyword", libs.zad_DeviousCollar) ; 0 - Collar - Unused
;	StorageUtil.FormListAdd( kActor, "_SD_lDevicesKeyword", libs.zad_DeviousArmbinder) ; 1 - Arms cuffs
;	StorageUtil.FormListAdd( kActor, "_SD_lDevicesKeyword", libs.zad_DeviousLegCuffs ) ; 2 - Legs cuffs
;	StorageUtil.FormListAdd( kActor, "_SD_lDevicesKeyword", libs.zad_DeviousGag ) ; 3 - Gag
;	StorageUtil.FormListAdd( kActor, "_SD_lDevicesKeyword", libs.zad_DeviousBlindfold ) ; 4 - Blindfold
;	StorageUtil.FormListAdd( kActor, "_SD_lDevicesKeyword", libs.zad_DeviousBelt ) ; 5 - Belt
;	StorageUtil.FormListAdd( kActor, "_SD_lDevicesKeyword", libs.zad_DeviousPlugAnal) ; 6 - Plug Anal
;	StorageUtil.FormListAdd( kActor, "_SD_lDevicesKeyword", libs.zad_DeviousPlugVaginal) ; 7 - Plug Vaginal

; EndFunction

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
			bIsSpriggan = (akActor.IsInFaction( _SDFLP_spriggan_factions.GetAt(index) as Faction ) && !(akActor as Form).HasKeywordString("_SD_infected")) || (akActor.GetRace() == SprigganRace) || ( (_SD_Race_SprigganEarthMother!=None) && (akActor.GetRace() == _SD_Race_SprigganEarthMother)) || ( (_SD_Race_SprigganBurnt!=None) && (akActor.GetRace() == _SD_Race_SprigganBurnt))  && !actorFactionInList( akActor, _SDFLP_banned_factions )


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
			bIsFalmer = akActor.IsInFaction( _SDFLP_falmer_factions.GetAt(index) as Faction ) || akActor.GetRace() == FalmerRace  || ( (_SD_Race_FalmerFrozen!=None) && (akActor.GetRace() == _SD_Race_FalmerFrozen)) && !actorFactionInList( akActor, _SDFLP_banned_factions )


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