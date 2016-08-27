Scriptname _sdqs_fcts_factions extends Quest  
{ USED }
Import Utility
Import SKSE

_SDQS_functions Property funct  Auto
zbfSlaveControl Property ZazSlaveControl Auto

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
Race Property  SaberCatRace  Auto
Race Property  BearRace  Auto
Race Property  DogRace  Auto
Race Property  DogCompanionRace  Auto
Race Property  GiantRace  Auto
Race Property  ChaurusRace   Auto
Race Property  SpiderRace   Auto
Race Property  TrollRace  Auto
Race Property  FrostTrollRace  Auto
Race Property  DraugrRace  Auto
Race Property  DraugrMagicRace  Auto

Faction Property  HagravenFaction   Auto   	; HagravenFaction 
Faction Property  WolfFaction  Auto			; WolfFaction
Faction Property  DogFaction  Auto 			; DogFaction
Faction Property  SaberCatFaction  Auto 	; DogFaction
Faction Property  BearFaction  Auto 		; DogFaction
Faction Property  GiantFaction  Auto		; GiantFaction
Faction Property  ChaurusFaction   Auto		; ChaurusFaction
Faction Property  SpiderFaction   Auto		; SpiderFaction
Faction Property  TrollFaction  Auto 		; TrollFaction
Faction Property  DraugrFaction  Auto 		; DraugrFaction
Faction Property  FalmerFaction  Auto 		; FalmerFaction

Faction Property  NordFaction  Auto 		; CWSonsAlly
Faction Property  BretonFaction  Auto 		; ForswornFaction
Faction Property  ImperialFaction  Auto 	; CWImperialAlly
Faction Property  OrcFaction  Auto 			; OrcFriendFaction
Faction Property  ElfFaction  Auto 			; ThalmorFaction
Faction Property  RedguardFaction  Auto 	; HunterFaction
Faction Property  KhajiitFaction  Auto 		; KhajiitCaravanFaction
Faction Property  ArgonianFaction  Auto 	; HunterFaction
Faction Property  DremoraFaction  Auto 		; DremoraFaction


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

Function initSlaveryFactionByRace (  )
; 	For each race in master races storageUtil
;		registerSlaveryOptions( Race, allowCollar, allowArmbinders, allowPunishmentDevice, allowPunishmentScene, allowWhippingScene, defaultStance )
; 		Register devices for slavery gear - collar, armbinders, leg cuffs, belt, vaginal plug, anal plug
;			registerSlaveryGearDevice( Race, deviceString, deviceKeyword, deviceInventory, deviceRendered )

	Int valueCount = StorageUtil.FormListCount(none, "_SD_lRaceMastersList")
	int i = 0
	Form thisRace
	String sRaceName
 
 	Debug.Trace("[SD] Registering race factions")

	while(i < valueCount)
		thisRace = StorageUtil.FormListGet(none, "_SD_lRaceMastersList", i)
		sRaceName = thisRace.GetName()
		Debug.Trace("	Race [" + i + "] = " + sRaceName)

		If (StorageUtil.GetStringValue( thisRace, "_SD_sRaceType") == "Beast"  )
			; Falmer   
			If (StringUtil.Find(sRaceName, "Falmer")!= -1)
				StorageUtil.SetFormValue( thisRace, "_SD_sRaceFaction", FalmerFaction) 

			; Hagraven    
			ElseIf (StringUtil.Find(sRaceName, "Hagraven")!= -1)
				StorageUtil.SetFormValue( thisRace, "_SD_sRaceFaction", HagravenFaction) 

			; Wolf   
			ElseIf (StringUtil.Find(sRaceName, "Wolf")!= -1)
				StorageUtil.SetFormValue( thisRace, "_SD_sRaceFaction", WolfFaction) 

			; Dog    
			ElseIf (StringUtil.Find(sRaceName, "Dog")!= -1)
				StorageUtil.SetFormValue( thisRace, "_SD_sRaceFaction", DogFaction) 

			; SaberCat    
			ElseIf (StringUtil.Find(sRaceName, "Cat")!= -1)
				StorageUtil.SetFormValue( thisRace, "_SD_sRaceFaction", SaberCatFaction) 

			; Bear    
			ElseIf (StringUtil.Find(sRaceName, "Bear")!= -1)
				StorageUtil.SetFormValue( thisRace, "_SD_sRaceFaction", BearFaction) 

			; Giant   
			ElseIf (StringUtil.Find(sRaceName, "Giant")!= -1)
				StorageUtil.SetFormValue( thisRace, "_SD_sRaceFaction", GiantFaction) 

			; Chaurus   
			ElseIf (StringUtil.Find(sRaceName, "Chaurus")!= -1)
				StorageUtil.SetFormValue( thisRace, "_SD_sRaceFaction", FalmerFaction) 

			; Spider    
			ElseIf (StringUtil.Find(sRaceName, "Spider")!= -1)
				StorageUtil.SetFormValue( thisRace, "_SD_sRaceFaction", SpiderFaction) 

			; Troll   
			ElseIf (StringUtil.Find(sRaceName, "Troll")!= -1)
				StorageUtil.SetFormValue( thisRace, "_SD_sRaceFaction", TrollFaction) 

			; Draugr    
			ElseIf (StringUtil.Find(sRaceName, "Draugr")!= -1)
				StorageUtil.SetFormValue( thisRace, "_SD_sRaceFaction", DraugrFaction) 

			endif
		endIf

		If (StorageUtil.GetStringValue( thisRace, "_SD_sRaceType") == "Humanoid"  )
			; Nord  
			If (StringUtil.Find(sRaceName, "Nord")!= -1)
				StorageUtil.SetFormValue( thisRace, "_SD_sRaceFaction", NordFaction) 

			; Breton
			ElseIf (StringUtil.Find(sRaceName, "Breton")!= -1)
				StorageUtil.SetFormValue( thisRace, "_SD_sRaceFaction", BretonFaction) 

			; Imperial
			ElseIf (StringUtil.Find(sRaceName, "Imperial")!= -1)
				StorageUtil.SetFormValue( thisRace, "_SD_sRaceFaction", ImperialFaction) 

			; Redguard
			ElseIf (StringUtil.Find(sRaceName, "Redguard")!= -1)
				StorageUtil.SetFormValue( thisRace, "_SD_sRaceFaction", RedguardFaction) 

			; Orc
			ElseIf (StringUtil.Find(sRaceName, "Orc")!= -1)
				StorageUtil.SetFormValue( thisRace, "_SD_sRaceFaction", OrcFaction) 

			; Elf
			ElseIf (StringUtil.Find(sRaceName, "Elf")!= -1)
				StorageUtil.SetFormValue( thisRace, "_SD_sRaceFaction", ElfFaction) 

			; Khajit
			ElseIf (StringUtil.Find(sRaceName, "Khajiit")!= -1)
				StorageUtil.SetFormValue( thisRace, "_SD_sRaceFaction", KhajiitFaction) 

			; Argonian
			ElseIf (StringUtil.Find(sRaceName, "Argonian")!= -1)
				StorageUtil.SetFormValue( thisRace, "_SD_sRaceFaction", ArgonianFaction) 

			; Dremora
			ElseIf (StringUtil.Find(sRaceName, "Dremora")!= -1)
				StorageUtil.SetFormValue( thisRace, "_SD_sRaceFaction", DremoraFaction) 

			endif
		endif

		i += 1
	endwhile
EndFunction

;---------------------------------------------------


Bool Function checkIfSlaver ( Actor akActor )
	Actor akPlayer = Game.getPlayer() as Actor
	Int  playerGender =akPlayer.GetLeveledActorBase().GetSex() as Int
	Bool isSlaver
	Bool isActorAlreadySlaver
	Bool isPlayerAlreadyOwned

	; If (akActor == akPlayer)
		; Debug.Notification("[SD] Slaver is Player!" )
		; return False
	; EndIf

	if (StorageUtil.GetIntValue( akActor, "_SD_iDateSlaverChecked")==0)
		StorageUtil.SetIntValue( akActor, "_SD_iDateSlaverChecked", Game.QueryStat("Days Passed"))

		isSlaver = ( (akActor.HasKeyword( _SDKP_actorTypeNPC ) && funct.checkGenderRestriction( akActor, Game.GetPlayer() ) )) && !akActor.IsGhost() && !actorFactionInList( akActor, _SDFLP_banned_factions ) && (!actorInList(_SDFLP_banned_actors, akActor))

		If ((checkIfSpriggan ( akActor )) || ( StorageUtil.GetIntValue(akPlayer, "_SD_iSprigganPlayer") ==1))
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

		isActorAlreadySlaver = ZazSlaveControl.IsMaster(akActor)
		isPlayerAlreadyOwned = ZazSlaveControl.IsOwnedByMod(akPlayer)  
		
		If (isActorAlreadySlaver || isPlayerAlreadyOwned )
			Debug.Trace("[SD] 		Actor is already an slaver in another ZAP compatible mod - aborting")
			isSlaver = False
		Endif


		StorageUtil.SetIntValue( akActor, "_SD_bIsSlaver", isSlaver as Int) 
		StorageUtil.SetIntValue( akActor, "_SD_bIsSlaverHumanoid", isSlaver as Int) 
	else
		isSlaver = StorageUtil.GetIntValue( akActor, "_SD_bIsSlaverHumanoid") as Bool
	endIf

	return isSlaver
EndFunction

Bool Function checkIfSlaverCreature ( Actor akActor )
	Actor akPlayer = Game.getPlayer() as Actor
	Int  playerGender = akPlayer.GetLeveledActorBase().GetSex() as Int
	Bool isSlaver

	; If (akActor == akPlayer)
	;	Debug.Notification("[SD] Slaver is Player!" )
	;	return False
	; EndIf

	If (StorageUtil.GetIntValue(akPlayer, "_SD_iEnableBeastMaster") == 0)
		return False
	Endif

	if (StorageUtil.GetIntValue( akActor, "_SD_iDateBeastSlaverChecked")==0)
		StorageUtil.SetIntValue( akActor, "_SD_iDateBeastSlaverChecked", Game.QueryStat("Days Passed"))

		isSlaver = (   checkIfFalmer ( akActor) || checkIfSlaverCreatureRace(akActor) ) && !checkIfSpriggan ( akActor ) && !akActor.IsGhost() && !actorFactionInList( akActor, _SDFLP_banned_factions ) && (!actorInList(_SDFLP_banned_actors, akActor))
		
		If (akActor == ( StorageUtil.GetFormValue(akPlayer, "_SD_CurrentOwner") as Actor) ) 
			isSlaver = False
		Endif

		If (StorageUtil.GetIntValue( akActor, "_SD_bIsSlaverHumanoid") == 1)
			Debug.Trace("[SD] 		Actor is already an humanoid slaver")
			isSlaver = False
		Endif	

		if (!isSlaver)
			Debug.Trace("[SD] Creature Enslavement check with actor [ " + akActor + " ] - FAILED")
		else
			Debug.Trace("[SD] Creature Enslavement check with actor [ " + akActor + " ] - SUCCEEDED")
		EndIf

	 	; if !(   ( checkIfFalmer ( akActor) || checkIfSlaverCreatureRace(akActor) ) && (playerGender == 1) )
	 	;	Debug.Trace("[SD] 		Player is male or creature is not eligible.")
	 	; EndIf
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



		StorageUtil.SetIntValue( akActor, "_SD_bIsSlaver", isSlaver as Int) 
		StorageUtil.SetIntValue( akActor, "_SD_bIsSlaverCreature", isSlaver as Int) 
	else
		isSlaver = StorageUtil.GetIntValue( akActor, "_SD_bIsSlaverCreature") as Bool
	endIf

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
		if (StorageUtil.GetIntValue( akActor, "_SD_iDateSprigganChecked")==0)
			StorageUtil.SetIntValue( akActor, "_SD_iDateSprigganChecked", Game.QueryStat("Days Passed"))

			Int index = 0
			Int size = _SDFLP_spriggan_factions.GetSize()
			While ( !bIsSpriggan && index < size )
				bIsSpriggan = (akActor.IsInFaction( _SDFLP_spriggan_factions.GetAt(index) as Faction ) && !(akActor as Form).HasKeywordString("_SD_infected")) || (akActor.GetRace() == SprigganRace) || ( (_SD_Race_SprigganEarthMother!=None) && (akActor.GetRace() == _SD_Race_SprigganEarthMother)) || ( (_SD_Race_SprigganBurnt!=None) && (akActor.GetRace() == _SD_Race_SprigganBurnt))  && !actorFactionInList( akActor, _SDFLP_banned_factions )


				index += 1
			EndWhile

			StorageUtil.SetIntValue( akActor, "_SD_bIsSpriggan", bIsSpriggan as Int) 
		else
			bIsSpriggan = StorageUtil.GetIntValue( akActor, "_SD_bIsSpriggan") as Bool
		endIf
	EndIf

	
	Return bIsSpriggan
EndFunction

Bool Function checkIfFalmer ( Actor akActor )
	Bool bIsFalmer = False
	Race _SD_Race_FalmerFrozen = StorageUtil.GetFormValue(None, "_SD_Race_FalmerFrozen") as Race

	if (akActor)
		if (StorageUtil.GetIntValue( akActor, "_SD_iDateFalmerChecked")==0)
			StorageUtil.SetIntValue( akActor, "_SD_iDateFalmerChecked", Game.QueryStat("Days Passed"))

			Int index = 0
			Int size = _SDFLP_falmer_factions.GetSize()
			While ( !bIsFalmer && index < size )
				bIsFalmer = akActor.IsInFaction( _SDFLP_falmer_factions.GetAt(index) as Faction ) || akActor.GetRace() == FalmerRace  || ( (_SD_Race_FalmerFrozen!=None) && (akActor.GetRace() == _SD_Race_FalmerFrozen)) && !actorFactionInList( akActor, _SDFLP_banned_factions )


				index += 1
			EndWhile

			StorageUtil.SetIntValue( akActor, "_SD_bIsFalmer", bIsFalmer as Int) 
		else
			bIsFalmer = StorageUtil.GetIntValue( akActor, "_SD_bIsFalmer") as Bool
		endIf
	EndIf
	
	Return bIsFalmer
EndFunction

Bool Function checkIfSlaverCreatureRace ( Actor akActor )
	Bool bIsSlaverCreature = False
	ActorBase akActorBase = akActor.GetLeveledActorBase() as ActorBase
	Race actorRace = akActorBase.GetRace()
	String sMasterRaceName
	String sRaceName
	Form foundRace = none


	If (StorageUtil.GetIntValue(actorRace as Form, "_SD_iSlaveryRace") == 1) 
		If (StorageUtil.GetStringValue( actorRace as Form, "_SD_sRaceType") == "Beast"  )
			bIsSlaverCreature = True
		Endif
	else

		if (StorageUtil.GetFormValue( akActor, "_SD_sRaceMatch")==none)

			Int valueCount = StorageUtil.FormListCount(none, "_SD_lRaceMastersList")
			int i = 0
			Form thisRace = None 

			If (sMasterRaceName == "")
				sMasterRaceName = actorRace as String
			endif
		 
		 	Debug.Trace("[SD] Searching for a racial match for " + sMasterRaceName)

			while(i < valueCount) && (foundRace==none)
				thisRace = StorageUtil.FormListGet(none, "_SD_lRaceMastersList", i)
				sRaceName = thisRace.GetName()

				If (StringUtil.Find(sRaceName, sMasterRaceName)!= -1)
					Debug.Trace("	Race [" + i + "] = " + sRaceName)
					Debug.Trace("[SD] Master race match found - " + thisRace)
					foundRace = thisRace
				endIf

				i += 1
			EndWhile

			if (foundRace!=none)
				StorageUtil.SetFormValue( akActor, "_SD_sRaceMatch",foundRace)
				If (StorageUtil.GetIntValue(foundRace, "_SD_iSlaveryRace") == 1)
					bIsSlaverCreature = True
				Endif
			endif
		else
			If (StorageUtil.GetIntValue(StorageUtil.GetFormValue( akActor, "_SD_sRaceMatch"), "_SD_iSlaveryRace") == 1)
				bIsSlaverCreature = True
			Endif
		endIf

	endif

  	Return bIsSlaverCreature
EndFunction

Bool Function checkIfSlaverCreatureCollar ( Actor akActor )
	Bool bIsSlaverCreatureCollar = False
	ActorBase akActorBase = akActor.GetLeveledActorBase() as ActorBase
	Race actorRace = akActorBase.GetRace()

	bIsSlaverCreatureCollar = (StorageUtil.GetIntValue(actorRace as Form, "_SD_iSlaveryCollarOn") == 1)

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


Bool Function qualifyActor( Actor akActor, Bool abCheckInScene = True )
	Bool bOutOfScene = ( !abCheckInScene || ( abCheckInScene && akActor.GetCurrentScene() == None ) )
	Return ( !akActor.IsDead() && !akActor.IsDisabled() && bOutOfScene )
EndFunction
 

Function syncActorFactions( Actor akMaster, Actor akSlave, FormList alFactionListOut = None )
	Faction nthFaction
	Form nthForm
	Faction[] MasterFactions = akMaster.GetFactions(-128, 127);The maximum range allowed.
	String sFactionName

	Debug.Trace("[SD] Checking slave factions for " + akMaster)
	Debug.Trace("[SD] Master is a part of the following factions: " + MasterFactions)

	Int iFormIndex = MasterFactions.Length
	While ( iFormIndex > 0 )
		iFormIndex -= 1
		nthFaction = MasterFactions[iFormIndex]
		nthForm = nthFaction as Form
		If ( nthFaction )
			; Debug.Notification("	Master Faction: " + nthFaction)
			Debug.Trace("	Master Faction: " + nthFaction)
			sFactionName = nthForm.GetName()
			if !akSlave.IsInFaction( nthFaction ) && (StringUtil.Find(sFactionName, "SexLab")== -1) && (StringUtil.Find(sFactionName, "SOS")== -1) && (StringUtil.Find(sFactionName, "Dialogue Disable")== -1)
				; Only add slave to faction he/she is not member of yet

				StorageUtil.FormListAdd( akSlave, "_SD_lSlaveFactions", nthForm )
				StorageUtil.SetIntValue( nthForm, "_SD_iDaysPassedJoinedFaction",  Game.QueryStat("Days Passed") )
				; Debug.Notification("[SD] Slave faction joined: " + nthFaction)
				Debug.Trace("[SD]		- Slave faction joined: " + nthFaction)

				If ( alFactionListOut != None )
					alFactionListOut.AddForm( nthFaction )
				EndIf

				akSlave.AddToFaction( nthFaction )
			else
				Debug.Trace("[SD]			- Slave already in faction: " + nthFaction )

			endif
		EndIf
	EndWhile

EndFunction


Form Function findMatchingRace( Actor akMaster )
	ActorBase akActorBase = akMaster.GetLeveledActorBase() as ActorBase
	Form masterRace = akActorBase.GetRace() as Form
	String sMasterRaceName = masterRace.GetName()
	Form foundRace = None

	; check if storageutil for default faction is assigned for this master
	; if it is, use it
	; if not, calculate it

	if (StorageUtil.GetFormValue( akMaster, "_SD_sRaceMatch")==none)

		Int valueCount = StorageUtil.FormListCount(none, "_SD_lRaceMastersList")
		int i = 0
		Form thisRace = None
		String sRaceName

		If (sMasterRaceName == "")
			sMasterRaceName = masterRace as String
		endif
	 
	 	Debug.Trace("[SD] Searching for a racial match for " + sMasterRaceName)

		while(i < valueCount) && (foundRace==none)
			thisRace = StorageUtil.FormListGet(none, "_SD_lRaceMastersList", i)
			sRaceName = thisRace.GetName()

			If (StringUtil.Find(sRaceName, sMasterRaceName)!= -1)
				Debug.Trace("	Race [" + i + "] = " + sRaceName)
				Debug.Trace("[SD] Master race match found - " + thisRace)
				foundRace = thisRace
			endIf

			i += 1
		EndWhile

		if (foundRace==none)
			Debug.Trace("[SD] Master race match not found - using default")
			foundRace = akActorBase.GetRace() as Form
		endif

		StorageUtil.SetFormValue( akMaster, "_SD_sRaceMatch", foundRace) 
	else
		foundRace = StorageUtil.GetFormValue( akMaster, "_SD_sRaceMatch") 
	endIf

	Return foundRace

EndFunction

Function syncActorFactionsByRace( Actor akMaster, Actor akSlave, FormList alFactionListOut = None )
	ActorBase akActorBase = akMaster.GetLeveledActorBase() as ActorBase
	Form nthForm
	Form masterRace = None
	String sFactionName
	Faction slaveFaction

	if (akMaster != none)

		Debug.Trace("[SD] Master Sync Faction by race: " + masterRace)

		; Form masterRace = akActorBase.GetRace() as Form
		masterRace = findMatchingRace( akMaster )
 
		nthForm = StorageUtil.GetFormValue( masterRace, "_SD_sRaceFaction")

		If ( nthForm == None )
			Debug.Trace("[SD] Master Faction not found - using default: " + nthForm)
			nthForm = RedguardFaction as Form
		else
			Debug.Trace("[SD] Master Faction found: " + nthForm)

		endIf

		slaveFaction = nthForm as Faction

		Debug.Notification("[SD] Master Default Faction: " + nthForm)
		Debug.Trace("[SD] Master Default Faction: " + nthForm)
		if (!akSlave.IsInFaction( slaveFaction ) && (StringUtil.Find(sFactionName, "SexLab")== -1)  && (StringUtil.Find(sFactionName, "SOS")== -1)  && (StringUtil.Find(sFactionName, "Schlong")== -1) && (StringUtil.Find(sFactionName, "Dialogue Disable")== -1) )
			; Only add slave to faction he/she is not member of yet
			sFactionName = slaveFaction.GetName()

			StorageUtil.FormListAdd( akSlave, "_SD_lSlaveFactions", nthForm )
			StorageUtil.SetIntValue( nthForm, "_SD_iDaysPassedJoinedFaction",  Game.QueryStat("Days Passed") )
			Debug.Notification("[SD] Slave faction joined: " + nthForm)
			Debug.Trace("[SD]		- Slave faction joined: " + nthForm)

			If ( alFactionListOut != None )
				alFactionListOut.AddForm( nthForm as Faction )
			EndIf

			akSlave.AddToFaction( nthForm as Faction )
		else
			Debug.Trace("[SD]		- Slave already in faction: " + nthForm )

		endif
	endIf
EndFunction

; TO DO: Create function to remove factions after certain date is passed

Function expireSlaveFactions( Actor akSlave )
	; // iterate list from first added to last added
	Debug.Trace("[SD] Expire Slave Factions for " + akSlave)

	int currentDaysPassed = Game.QueryStat("Days Passed")
	int valueCount = StorageUtil.FormListCount(akSlave, "_SD_lSlaveFactions")
	int i = 0
	int daysJoined 
	Form slaveFaction 

	while(i < valueCount)
		slaveFaction = StorageUtil.FormListGet(akSlave, "_SD_lSlaveFactions", i)
		If (slaveFaction != none)

			daysJoined = currentDaysPassed - StorageUtil.GetIntValue( slaveFaction, "_SD_iDaysPassedJoinedFaction")

			If !akSlave.IsInFaction( slaveFaction as Faction ) && (StorageUtil.GetIntValue( slaveFaction, "_SD_iDaysPassedJoinedFaction" )!=-1)
				StorageUtil.SetIntValue( slaveFaction, "_SD_iDaysPassedJoinedFaction",  -1 )
			Endif

			if akSlave.IsInFaction( slaveFaction as Faction ) && (daysJoined > StorageUtil.GetIntValue( akSlave, "_SD_iDaysMaxJoinedFaction") )  && (StorageUtil.GetIntValue( slaveFaction, "_SD_iDaysPassedJoinedFaction" )!=-1)

				Debug.Trace("[SD]      Slave Faction[" + i + "] expired: " + slaveFaction.GetName() + " " + slaveFaction + " Days Since Joined: " + daysJoined )

				; StorageUtil.FormListRemoveAt( akSlave, "_SD_lSlaveFactions", i )
				StorageUtil.SetIntValue( slaveFaction, "_SD_iDaysPassedJoinedFaction",  -1 )
				Debug.Notification("Slave faction removed: " + slaveFaction.GetName())

				akSlave.RemoveFromFaction( slaveFaction as Faction )

			EndIf
		Endif

		i += 1
	endwhile
EndFunction

Function clearSlaveFactions( Actor akSlave )
	; // iterate list from first added to last added
	Debug.Trace("[SD] Clear Slave Factions for " + akSlave)

	int currentDaysPassed = Game.QueryStat("Days Passed")
	int valueCount = StorageUtil.FormListCount(akSlave, "_SD_lSlaveFactions")
	int i = 0
	int daysJoined 
	Form slaveFaction 

	while(i < valueCount)
		slaveFaction = StorageUtil.FormListGet(akSlave, "_SD_lSlaveFactions", i)
		If (slaveFaction != none)
			daysJoined = currentDaysPassed - StorageUtil.GetIntValue( slaveFaction, "_SD_iDaysPassedJoinedFaction")

			Debug.Trace("[SD]      Slave Faction[" + i + "] expired: " + slaveFaction.GetName() + " " + slaveFaction + " Days Since Joined: " + daysJoined )

			; StorageUtil.FormListRemoveAt( akSlave, "_SD_lSlaveFactions", i )
			StorageUtil.SetIntValue( slaveFaction, "_SD_iDaysPassedJoinedFaction",  -1 )
			Debug.Notification("Slave faction removed: " + slaveFaction.GetName())

			akSlave.RemoveFromFaction( slaveFaction as Faction )
		Endif

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

; ----------- Deprecated 


Bool Function allyToActor( Actor akMaster, Actor akSlave, FormList alFactionListIn, FormList alFactionListOut = None )
	Form nthForm
	Int index = 0
	Int size = alFactionListIn.GetSize()
	Bool ret = False

	If ( akMaster == None || akSlave == None )
		Return ret
	EndIf

	; old faction system
	; If ( alFactionListOut != None && alFactionListOut.GetSize() > 0 )
	;	resetAllyToActor( akSlave, alFactionListOut )
	; EndIf

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



Function resetAllyToActor( Actor akSlave, FormList alFactionListIn )
	Int index = 0
	; Int size = alFactionListIn.GetSize()

	; While ( index < size )
	; 	Faction nTHfaction = alFactionListIn.GetAt(index) as Faction
	; 	akSlave.RemoveFromFaction( nTHfaction )
	; 	index += 1
	; EndWhile

	; alFactionListIn.Revert()
EndFunction
