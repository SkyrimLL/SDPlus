Scriptname _sdqs_fcts_factions extends Quest  
{ USED }
Import Utility
Import SKSE

_SDQS_functions Property funct  Auto

Keyword Property _SDKP_actorTypeNPC  Auto
FormList Property _SDFLP_banned_factions  Auto
FormList Property _SDFLP_banned_actors  Auto

Race Property FalmerRace  Auto  
Race Property SprigganRace  Auto  

FormList Property _SDFLP_falmer_factions  Auto
FormList Property _SDFLP_follower_factions  Auto
FormList Property _SDFLP_spriggan_factions  Auto
 
Race Property  HagravenRace   Auto
Race Property  WolfRace  Auto
Race Property  DogRace  Auto
Race Property  DogCompanionRace  Auto
Race Property  GiantRace  Auto
Race Property  ChaurusRace   Auto
Race Property  SpiderRace   Auto
Race Property  TrollRace  Auto
Race Property  FrostTrollRace  Auto
Race Property  DraugrRace  Auto
Race Property  DraugrMagicRace  Auto

int TYPE_FACTION = 11

;---------------------------------------------------
; For new race based slavery gear

FormList Property _SDFLP_humanoid_masters_races  Auto
FormList Property _SDFLP_beast_master_races  Auto

Function initHumanoidMastersList (  )
;   Init if master races storageUtil list doesn't exist
; 	Add races from _SDFLP_humanoid_masters_races form list
;	Set Master Race Type to Humanoid
; 	Set Master Race Name as a string

	Debug.Trace("[SD] Register race masters list - Humanoid")

	StorageUtil.SetFormValue(none, "_SD_fDefaultSlaveryRace", HagravenRace) ; useful later when race of aggressors is unkown
  
	; if (StorageUtil.FormListCount( none, "_SD_lRaceMastersList") != 0)
	;	Debug.Trace("[SD] Register race masters list - aborting - list already set - " + StorageUtil.FormListCount( none, "_SD_lRaceMastersList"))
	;	Return
	; EndIf	

	Int iIndex = _SDFLP_humanoid_masters_races.GetSize()
	Form kForm 

	While iIndex > 0
		iIndex -= 1
		kForm = _SDFLP_humanoid_masters_races.GetAt(iIndex)
		if (StorageUtil.FormListFind( none, "_SD_lRaceMastersList", kForm) <0)
			StorageUtil.FormListAdd( none, "_SD_lRaceMastersList", kForm)  

			StorageUtil.SetIntValue(kForm, "_SD_iSlaveryRace", 1)
			StorageUtil.SetStringValue( kForm, "_SD_sRaceType", "Humanoid")  
			StorageUtil.SetStringValue( kForm, "_SD_sRaceName", kForm.GetName())  
			Debug.Trace("		Form " + iIndex + " is " + kForm)
		endif
	EndWhile

	Debug.Trace("[SD] Register race masters list - count : " + StorageUtil.FormListCount( none, "_SD_lRaceMastersList"))

EndFunction

Function initBeastMastersList (  )
;   Init if master races storageUtil list doesn't exist
; 	Add races from _SDFLP_beast_master_races form list
;	Set Master Race Type to Beast
; 	Set Master Race Name as a string

	Debug.Trace("[SD] Register race masters list - Beast")	

	Int iIndex = _SDFLP_beast_master_races.GetSize()
	Form kForm 

	While iIndex > 0
		iIndex -= 1
		kForm = _SDFLP_beast_master_races.GetAt(iIndex)
		if (StorageUtil.FormListFind( none, "_SD_lRaceMastersList", kForm) <0)
			StorageUtil.FormListAdd( none, "_SD_lRaceMastersList", kForm)  

			StorageUtil.SetIntValue(kForm, "_SD_iSlaveryRace", 1)
			StorageUtil.SetStringValue( kForm, "_SD_sRaceType", "Beast")  
			StorageUtil.SetStringValue( kForm, "_SD_sRaceName", kForm.GetName())  
			Debug.Trace("		Form " + iIndex + " is " + kForm)
		endif
	EndWhile

	Debug.Trace("[SD] Register race masters list - count : " + StorageUtil.FormListCount( none, "_SD_lRaceMastersList"))

EndFunction

;---------------------------------------------------


Bool Function checkIfSlaver ( Actor akActor )
	Actor akPlayer = Game.getPlayer() as Actor
	Int  playerGender =akPlayer.GetLeveledActorBase().GetSex() as Int

	If (akActor == akPlayer)
		; Debug.Notification("[SD] Slaver is Player!" )
		; return False
	EndIf

	Bool isSlaver = ( (akActor.HasKeyword( _SDKP_actorTypeNPC ) && funct.checkGenderRestriction( akActor, Game.GetPlayer() ) )) && !akActor.IsGhost() && !actorFactionInList( akActor, _SDFLP_banned_factions ) && (!actorInList(_SDFLP_banned_actors, akActor))

	If (checkIfSpriggan ( akPlayer )) 
		isSlaver = False
	Endif
	
	If (akActor == ( StorageUtil.GetFormValue(akPlayer, "_SD_CurrentOwner") as Actor) ) 
		isSlaver = False
	Endif

	if (!isSlaver)
		Debug.Trace("[SD] Humanoid Enslavement check with actor [ " + akActor + " ] - FAILED")
	else
		Debug.Trace("[SD] Humanoid Enslavement check with actor [ " + akActor + " ] - SUCCEEDED")
	EndIf
	if (!akActor.HasKeyword( _SDKP_actorTypeNPC ))
		Debug.Trace("[SD] 		Actor is not an NPC - " )
	endif
	if (!funct.checkGenderRestriction( akActor, akPlayer ))
		Debug.Trace("[SD] 		Gender restriction failed" )
	endif
	if (akActor.IsGhost())
		Debug.Trace("[SD] 		Actor is Ghost" )
	endif
	; Debug.Trace("[SD] Actor is Player - " + (akActor != Game.GetPlayer()))
	if (actorFactionInList( akActor, _SDFLP_banned_factions ))
		Debug.Trace("[SD] 		Actor is Member of banned faction " )
	EndIf
	if (actorInList(_SDFLP_banned_actors , akActor))
		Debug.Trace("[SD] 		Actor is Member of banned actors " )
	endif
	If ((checkIfSpriggan ( akActor ))  || (StorageUtil.GetIntValue(akPlayer, "_SD_iSprigganPlayer") ==1))
		Debug.Trace("[SD] 		Actor is Spriggan - aborting normal enslavement")
	Endif
	If (akActor == ( StorageUtil.GetFormValue(akPlayer, "_SD_CurrentOwner") as Actor) ) 
		; Prevent new enslavement by current master
		Debug.Trace("[SD] 		Actor is already an owner")
	Endif	

	return isSlaver
EndFunction

Bool Function checkIfSlaverCreature ( Actor akActor )
	Actor akPlayer = Game.getPlayer() as Actor
	Int  playerGender = akPlayer.GetLeveledActorBase().GetSex() as Int

	If (akActor == akPlayer)
		Debug.Notification("[SD] Slaver is Player!" )
		return False
	EndIf

	Bool isSlaver = ( (   ( checkIfFalmer ( akActor) || checkIfSlaverCreatureRace(akActor) ) && (playerGender == 1) )) && !checkIfSpriggan ( akActor ) && !akActor.IsGhost() && !actorFactionInList( akActor, _SDFLP_banned_factions ) && (!actorInList(_SDFLP_banned_actors, akActor))
	
	If (akActor == ( StorageUtil.GetFormValue(akPlayer, "_SD_CurrentOwner") as Actor) ) 
		isSlaver = False
	Endif

	if (!isSlaver)
		Debug.Trace("[SD] Creature Enslavement check with actor [ " + akActor + " ] - FAILED")
	else
		Debug.Trace("[SD] Creature Enslavement check with actor [ " + akActor + " ] - SUCCEEDED")
	EndIf

 	if !(   ( checkIfFalmer ( akActor) || checkIfSlaverCreatureRace(akActor) ) && (playerGender == 1) )
 		Debug.Trace("[SD] 		Player is male or creature is not eligible.")
 	EndIf
	if (akActor.IsGhost())
		Debug.Trace("[SD] 		Actor is Ghost" )
	endif
	if (actorFactionInList( akActor, _SDFLP_banned_factions ))
		Debug.Trace("[SD] 		Actor is Member of banned faction " )
	EndIf
	if (actorInList(_SDFLP_banned_actors , akActor))
		Debug.Trace("[SD] 		Actor is Member of banned actors " )
	endif
	If ((checkIfSpriggan ( akActor )) || ( StorageUtil.GetIntValue(akPlayer, "_SD_iSprigganPlayer") ==1))
		Debug.Trace("[SD] 		Actor is Spriggan - aborting normal enslavement")
	Endif
	If (akActor == ( StorageUtil.GetFormValue(akPlayer, "_SD_CurrentOwner") as Actor) ) 
		; Prevent new enslavement by current master
		Debug.Trace("[SD] 		Actor is already an owner")
	Endif	


	return isSlaver
EndFunction

Bool Function checkIfNPC ( Actor akActor )
	Bool bIsNPC = False
	if (akActor.HasKeyword( _SDKP_actorTypeNPC ))
		Debug.Trace("[SD] 		Actor is an NPC - " )
		bIsNPC = True
	endif

	return bIsNPC
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

Bool Function checkIfSlaverCreatureRace ( Actor akActor )
	Bool bIsSlaverCreature = False
	ActorBase akActorBase = akActor.GetLeveledActorBase() as ActorBase
	Race actorRace = akActorBase.GetRace()

	bIsSlaverCreature = (StorageUtil.GetIntValue(actorRace, "_SD_iSlaveryRace") == 1)

  	Return bIsSlaverCreature
EndFunction

Bool Function checkIfSlaverCreatureCollar ( Actor akActor )
	Bool bIsSlaverCreatureCollar = False
	ActorBase akActorBase = akActor.GetLeveledActorBase() as ActorBase
	Race actorRace = akActorBase.GetRace()

	bIsSlaverCreatureCollar = (StorageUtil.GetIntValue(actorRace, "_SD_iSlaveryCollarOn") == 1)

  	Return bIsSlaverCreatureCollar
EndFunction

Bool Function checkIfSlaverWebCollar ( Actor akActor )
	Bool bIsSlaverCreatureCollar = False
	ActorBase akActorBase = akActor.GetLeveledActorBase() as ActorBase
	Race actorRace = akActorBase.GetRace()

	bIsSlaverCreatureCollar = (actorRace ==  ChaurusRace  ) || (actorRace ==   SpiderRace   ) 

  	Return bIsSlaverCreatureCollar
EndFunction

Bool Function checkIfSlaverCreatureBindings ( Actor akActor )
	Bool bIsSlaverCreatureBindings = False
	ActorBase akActorBase = akActor.GetLeveledActorBase() as ActorBase
	Race actorRace = akActorBase.GetRace()

	bIsSlaverCreatureBindings = (StorageUtil.GetIntValue(actorRace, "_SD_iSlaveryBindingsOn") == 1)

  	Return bIsSlaverCreatureBindings
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

; --------- Faction management

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

	Debug.Trace("			_SD::actorFactionInList akActor:" + akActor + " found:" + found )
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
	Form nthForm
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
		nthForm = nTHfaction as Form

		If ( akMaster.IsInFaction( nTHfaction ) && !akSlave.IsInFaction( nTHfaction ) )
			StorageUtil.FormListAdd( akSlave, "_SD_lSlaveFactions", nthForm )
			StorageUtil.SetIntValue( nthForm, "_SD_iDaysPassedJoinedFaction",  Game.QueryStat("Days Passed") )
			Debug.Notification("Slave faction joined: " + nthForm.GetName())

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
	Form nthForm

	Int iFormIndex = ( akMaster as ObjectReference ).GetNumItems()
	While ( iFormIndex > 0 )
		iFormIndex -= 1
		nthForm = ( akMaster as ObjectReference ).GetNthForm(iFormIndex)
		If ( nthForm )
			If ( nthForm.GetType() == TYPE_FACTION )
				if !akSlave.IsInFaction( nthForm as Faction )
					; Only add slave to faction he/she is not member of yet

					; TO DO: Add faction to list of temp joined factions + current game days to list of faction joined date

					StorageUtil.FormListAdd( akSlave, "_SD_lSlaveFactions", nthForm )
					StorageUtil.SetIntValue( nthForm, "_SD_iDaysPassedJoinedFaction",  Game.QueryStat("Days Passed") )
					Debug.Notification("Slave faction joined: " + nthForm.GetName())

					If ( alFactionListOut != None )
						alFactionListOut.AddForm( nthForm as Faction )
					EndIf

					akSlave.AddToFaction( nthForm as Faction )
				endif
			Endif
		EndIf
	EndWhile

EndFunction

; TO DO: Create function to remove factions after certain date is passed

Function expireSlaveFactions( Actor akSlave )
	; // iterate list from first added to last added
	Debug.Trace("[SD] Expire Slave Factions")

	int currentDaysPassed = Game.QueryStat("Days Passed")
	int valueCount = StorageUtil.FormListCount(akSlave, "_SD_lSlaveFactions")
	int i = 0
	int daysJoined 
	Form slaveFaction 

	while(i < valueCount)
		slaveFaction = StorageUtil.FormListGet(akSlave, "_SD_lSlaveFactions", i)
		daysJoined = currentDaysPassed - StorageUtil.GetIntValue( slaveFaction, "_SD_iDaysPassedJoinedFaction")

		if (daysJoined > StorageUtil.GetIntValue( akSlave, "_SD_iDaysMaxJoinedFaction") )
			Debug.Trace("[SD]      Slave Faction[" + i + "] expired: " + slaveFaction.GetName() + " " + slaveFaction + " Days Since Joined: " + daysJoined )

			StorageUtil.FormListRemoveAt( akSlave, "_SD_lSlaveFactions", i )
			StorageUtil.SetIntValue( slaveFaction, "_SD_iDaysPassedJoinedFaction",  -1 )
			Debug.Notification("Slave faction removed: " + slaveFaction.GetName())

			akSlave.RemoveFromFaction( slaveFaction as Faction )

		EndIf

		i += 1
	endwhile
EndFunction

Function displaySlaveFactions( Actor akSlave )
	; // iterate list from first added to last added
	Debug.Trace("[SD] List Slave Factions")

	int currentDaysPassed = Game.QueryStat("Days Passed")
	int valueCount = StorageUtil.FormListCount(akSlave, "_SD_lSlaveFactions")
	int i = 0
	int daysJoined 
	Form slaveFaction 

	while(i < valueCount)
		slaveFaction = StorageUtil.FormListGet(akSlave, "_SD_lSlaveFactions", i)
		daysJoined = currentDaysPassed - StorageUtil.GetIntValue( slaveFaction, "_SD_iDaysPassedJoinedFaction")

		Debug.Trace("[SD]      Slave Faction[" + i + "] = " + slaveFaction.GetName() + " " + slaveFaction + " Days Since Joined: " + daysJoined  + " - Days remaining: " + (StorageUtil.GetIntValue( akSlave, "_SD_iDaysMaxJoinedFaction") - daysJoined  ) )

		i += 1
	endwhile
EndFunction

