Scriptname _SDRAS_dreamer extends ReferenceAlias  

pDBEntranceQuestScript Property dbe Auto


ReferenceAlias Property _SDRAP_enter  Auto  
ReferenceAlias Property _SDRAP_leave  Auto  
ReferenceAlias Property _SDRAP_meridiana  Auto  
ReferenceAlias Property _SDRAP_naamah  Auto  
ReferenceAlias Property _SDRAP_eisheth  Auto  
ReferenceAlias Property _SDRAP_sanguine  Auto  

ReferenceAlias Property Alias__SDRA_lust_m  Auto
ReferenceAlias Property Alias__SDRA_lust_f  Auto

GlobalVariable Property _SDGVP_enslaved  Auto  
GlobalVariable Property _SDGVP_stats_enslaved  Auto  
GlobalVariable Property _SDGVP_config_lust auto
GlobalVariable Property _SDGVP_config_chance_dreamworld_on_sleep auto
GlobalVariable Property _SDGVP_sanguine_blessing auto
GlobalVariable Property _SDGVP_health_threshold auto
GlobalVariable Property _SDGVP_config_auto_start  Auto

Quest Property _SD_dreamQuest  Auto  
Quest Property ANightQuest  Auto  

Location Property _SDLOC_HaelgaBasement  Auto  
Location Property _SDLOC_SanguineShrine  Auto  
Location Property _SDLOC_SolitudeTemple  Auto  
Location Property _SDLOC_MarkarthTemple  Auto  
Location Property _SDLOC_RedWave  Auto  
Location Property _SDLOC_HonningbrewMeadery  Auto  
Location Property _SDLOC_Morvunskar  Auto  
Location Property _SDLOC_NightGateInn  Auto  
Location Property _SDLOC_MarkarthSilverBloodInn  Auto  
Location Property _SDLOC_RiftenBeeandBarbInn  Auto  
Location Property _SDLOC_SolitudeWinkingSkeeverInn  Auto  
Location Property _SDLOC_SanguineDreamworld  Auto  

_SD_ConfigMenu Property kConfig  Auto  
 
Spell Property _SDSP_freedom  Auto  



; _SDQS_dream dream


Float fRFSU = 0.1
Actor kSanguine
Actor kDreamer
Actor kMeridiana
Actor kNaamah
Actor kEisheth
ObjectReference kEnter
ObjectReference kLeave


Event OnInit()
	Debug.Trace("_SDRAS_dreamer.OnInit()")
	kDreamer = Self.GetReference() as Actor
	kSanguine = _SDRAP_sanguine.GetReference() as Actor
	kMeridiana = _SDRAP_meridiana.GetReference() as Actor
	kNaamah = _SDRAP_naamah.GetReference() as Actor
	kEisheth = _SDRAP_eisheth.GetReference() as Actor
	kEnter = _SDRAP_enter.GetReference() as ObjectReference
	kLeave = _SDRAP_leave.GetReference() as ObjectReference
	RegisterForSleep()
EndEvent


Event OnSleepStart(float afSleepStartTime, float afDesiredSleepEndTime)
	ObjectReference lust_f = Alias__SDRA_lust_f.GetReference() as ObjectReference
	ObjectReference lust_m = Alias__SDRA_lust_m.GetReference() as ObjectReference
	Actor kPlayer = Game.GetPlayer() as Actor
	Location kLocation = kPlayer.GetCurrentLocation()
	Bool bSendToDreamworld = False
	Int iDreamworldVisitModifier = 0
	Int iDreamworldVisitModifierMax = StorageUtil.GetIntValue(kPlayer, "_SD_iChanceDreamworldOnSleep" )

	; Disabling for now - removes locked devices instead of cleaning up items in inventory that are not worn
	; CleanupSlaveDevices(kPlayer)

	If (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved") != 1)  
		StorageUtil.SetIntValue(kPlayer, "_SD_iEnslavedSleepToken", 1) 
	Else
		StorageUtil.SetIntValue(kPlayer, "_SD_iEnslavedSleepToken", 0) 
	Endif

	If (StorageUtil.GetIntValue(kPlayer, "_SD_iDisableDreamworld") == 1) 
		Debug.Trace("[_sdras_dreamer] Dreamworld disabled by script - abort")
		Return
	Endif

	If (StorageUtil.GetIntValue(kPlayer, "_SD_iDisableDreamworldOnSleep") == 1)
		Debug.Trace("[_sdras_dreamer] Dreamworld on Sleep disabled: " + StorageUtil.GetIntValue(kPlayer, "_SD_iDisableDreamworldOnSleep"))
		Return
	Endif

	StorageUtil.SetIntValue(kPlayer, "_SD_iChanceDreamworldOnSleep", _SDGVP_config_chance_dreamworld_on_sleep.GetValue() as Int)

	Debug.Trace("[_sdras_dreamer] Auto start?: " + _SDGVP_config_auto_start.GetValue())
	; Debug.Trace("[_sdras_dreamer] Start after Night to remember?: " + _SDGVP_config_lust.GetValue())
	Debug.Trace("[_sdras_dreamer] Is Night to remember completed?: " + ANightQuest.IsCompleted())
	Debug.Trace("[_sdras_dreamer] Max chance on sleep: " + StorageUtil.GetIntValue(kPlayer, "_SD_iChanceDreamworldOnSleep" ))
	Debug.Trace("[_sdras_dreamer] Sanguine Blessing: " + _SDGVP_sanguine_blessing.GetValue())
	Debug.Trace("[_sdras_dreamer] Number times enslaved: " + _SDGVP_stats_enslaved.GetValueInt())

	If (_SDGVP_config_auto_start.GetValue() == 0)
		Debug.Trace("[_sdras_dreamer]    Dreamworld auto start disabled - skipping" )
	Else
		Debug.Trace("[_sdras_dreamer]    Dreamworld auto start" )

		; After Night to remember quest (100% chance)
		If  (!bSendToDreamworld) && (ANightQuest.IsCompleted())   
			Debug.Trace("[_sdras_dreamer]         Sleep after A Night to Remember" )
			bSendToDreamworld = True
			iDreamworldVisitModifier = iDreamworldVisitModifier + 20
		Endif

		; Compatibility with other mods 
		If 	(!bSendToDreamworld) && ( (StorageUtil.GetIntValue(none, "_SLS_iPlayerStartNordicQueen")==1) || (StorageUtil.GetIntValue(none, "_SLS_iPlayerStartSexbot")==1) || (StorageUtil.GetIntValue(none, "_SLS_iPlayerStartPet")==1) || (StorageUtil.GetIntValue(none, "_SLS_iPlayerStartAlicia")==1) || (StorageUtil.GetIntValue(none, "_SLS_iPlayerStartKin")==1)  || (StorageUtil.GetIntValue(none, "_SLS_iPlayerStartRedWave")==1) || (StorageUtil.GetIntValue(kPlayer, "_SLH_iDaedricInfluence")>30))
			Debug.Trace("[_sdras_dreamer]         Sleep after first enslavement and A Night to Remember" )
			bSendToDreamworld = True
			iDreamworldVisitModifier = iDreamworldVisitModifier + 20
		Endif

		; Chance of visit to Dreamworld based on location of sleep
		if (kLocation)
			If kLocation.IsSameLocation(_SDLOC_SanguineShrine) 
				Debug.Trace("[_sdras_dreamer]         OnSleep event by location - Sanguine Shrine" )
				iDreamworldVisitModifier = iDreamworldVisitModifier + 100
				iDreamworldVisitModifierMax = 100
				_SD_dreamQuest.SetObjectiveDisplayed(226,false)
				bSendToDreamworld = True
			  	
			elseif kLocation.IsSameLocation(_SDLOC_HaelgaBasement) 
				Debug.Trace("[_sdras_dreamer]         OnSleep event by location - Haelga basement" )
				iDreamworldVisitModifier = iDreamworldVisitModifier + 20
				bSendToDreamworld = True
			  	
			elseif kLocation.IsSameLocation(_SDLOC_SolitudeTemple) 
				Debug.Trace("[_sdras_dreamer]         OnSleep event by location - Solitude Temple" )
				iDreamworldVisitModifier = iDreamworldVisitModifier + 5
				bSendToDreamworld = True
			  	
			elseif (kLocation.IsSameLocation(_SDLOC_MarkarthTemple) && (StorageUtil.GetIntValue(none, "_SLSD_iDibellaSisterhood")!=1) )
				Debug.Trace("[_sdras_dreamer]         OnSleep event by location - Markarth Temple" )
				iDreamworldVisitModifier = iDreamworldVisitModifier + 10
				bSendToDreamworld = True
			  	
			elseif kLocation.IsSameLocation(_SDLOC_RedWave) 
				Debug.Trace("[_sdras_dreamer]         OnSleep event by location - Solitude RedWave" )
				iDreamworldVisitModifier = iDreamworldVisitModifier + 10
				bSendToDreamworld = True
			  	
			elseif kLocation.IsSameLocation(_SDLOC_HonningbrewMeadery) 
				Debug.Trace("[_sdras_dreamer]         OnSleep event by location - Honningbrew Meadery" )
				iDreamworldVisitModifier = iDreamworldVisitModifier + 20
				bSendToDreamworld = True

			elseif kLocation.IsSameLocation(_SDLOC_Morvunskar) 
				Debug.Trace("[_sdras_dreamer]         OnSleep event by location - Morvunskar" )
				iDreamworldVisitModifier = iDreamworldVisitModifier + 30
				bSendToDreamworld = True

			elseif kLocation.IsSameLocation(_SDLOC_NightGateInn) 
				Debug.Trace("[_sdras_dreamer]         OnSleep event by location - Nightgate Inn" )
				iDreamworldVisitModifier = iDreamworldVisitModifier + 5
				bSendToDreamworld = True

			elseif kLocation.IsSameLocation(_SDLOC_MarkarthSilverBloodInn) 
				Debug.Trace("[_sdras_dreamer]         OnSleep event by location - Silverblood Inn" )
				iDreamworldVisitModifier = iDreamworldVisitModifier + 5
				bSendToDreamworld = True
 
			elseif kLocation.IsSameLocation(_SDLOC_RiftenBeeandBarbInn) 
				Debug.Trace("[_sdras_dreamer]         OnSleep event by location - Bee and Barb Inn" )
				iDreamworldVisitModifier = iDreamworldVisitModifier + 5
				bSendToDreamworld = True
 
			elseif kLocation.IsSameLocation(_SDLOC_SolitudeWinkingSkeeverInn) 
				Debug.Trace("[_sdras_dreamer]         OnSleep event by location - Winking Skeever Inn" )
				iDreamworldVisitModifier = iDreamworldVisitModifier + 5  
				bSendToDreamworld = True
 
			EndIf
		EndIf

		; Increase chances from praying to the gods
		Int iNumberPrayersToGods = StorageUtil.GetIntValue(kPlayer, "_SD_iNumberPrayersToGods" )
		if ( iNumberPrayersToGods >= 25) ; cap prayers modifier to 25%
			iNumberPrayersToGods = 25 
		Endif

		if ( iNumberPrayersToGods > 0)
			Debug.Trace("[_sdras_dreamer]         Player prayers to Gods - iNumberPrayersToGods: " + iNumberPrayersToGods )
		    iDreamworldVisitModifier = iDreamworldVisitModifier + iNumberPrayersToGods
			bSendToDreamworld = True
		endIf

		; Increase chances when carrying Honningbrew mead
		Int iHonningbrewMeadBottles = kPlayer.GetItemCount(HonningbrewMead)
		if ( iHonningbrewMeadBottles > 0)
			Debug.Trace("[_sdras_dreamer]         Honningbrew mead in inventory - Bottles found: " + iHonningbrewMeadBottles )
		    iDreamworldVisitModifier = iDreamworldVisitModifier + (iHonningbrewMeadBottles * 2)
			bSendToDreamworld = True
		endIf

		; Chance of visits to Dreamworld on plain sleep based on exposure
		Int iSanguineVisits = (_SDGVP_sanguine_blessing.GetValue() as Int)
		if (!bSendToDreamworld) && (iSanguineVisits>1)
			Debug.Trace("[_sdras_dreamer]         OnSleep event by sanguine exposure - _SDGVP_sanguine_blessing: " + iSanguineVisits)
			if (iSanguineVisits>30)
				iSanguineVisits = 30
			Endif
			iDreamworldVisitModifier = iDreamworldVisitModifier + iSanguineVisits
			bSendToDreamworld = True
		EndIf		

		; Force start of Dreamworld if other conditions are met daedric quests completed or daedra killed
		Int iDragonSouls = Game.QueryStat("Dragon Souls Collected")
		if ((!bSendToDreamworld) && ((_SDGVP_sanguine_blessing.GetValue() as Int)==0) )
			if ((Game.QueryStat("Daedric Quests Completed") >= 1) || (Game.QueryStat("Daedra Killed") >= 1))
				Debug.Trace("[_sdras_dreamer]         OnSleep event - exposure to daedra killed or Daedric quest completed bonus" )
				iDreamworldVisitModifier = iDreamworldVisitModifier + 10
				bSendToDreamworld = True
			endif

			if ((iDragonSouls >= 1) && (iDragonSouls < 5)) 
				Debug.Trace("[_sdras_dreamer]         OnSleep event - Dragon Souls collected bonus" )
				iDreamworldVisitModifier = iDreamworldVisitModifier + iDragonSouls * 5
				bSendToDreamworld = True
			endif

			if (Game.QueryStat("Dragon Souls Collected") >= 5) 
				Debug.Trace("[_sdras_dreamer]         OnSleep event - Dragon Souls collected bonus" )
				iDreamworldVisitModifier = iDreamworldVisitModifier + 10
				bSendToDreamworld = True
			endif
		EndIf

		; Abort dreamworld if player is arrested or sleeping during Dark Brotherhood quest
		if ((!bSendToDreamworld) &&  ((dbe.pSleepyTime == 1)  || (kPlayer.IsArrested() == True) || (StorageUtil.GetIntValue(kPlayer, "xpoPCinJail")==1) || (_SDGVP_enslaved.GetValueInt() == 1)) )
			Debug.Trace("[_sdras_dreamer]         OnSleep event aborted (quest blocking, enslaved or arrested)" )
			bSendToDreamworld = False
		EndIf

		If (kLocation)
			if kLocation.IsSameLocation(_SDLOC_SanguineDreamworld) 
				Debug.Trace("[_sdras_dreamer]         OnSleep event by location - Dreamworld detected - teleport aborted" )
				bSendToDreamworld = False
			endIf
		endIf
		
		; First visit - Sleep after release from first enslavement and not currently enslaved
		; If  (bSendToDreamworld) && ( Self.GetOwningQuest().GetStage() == 0 ) 			
			; iDreamworldVisitModifier = 100
		; Endif
	EndIf

	; Send player to Dreamworld if true
	If (bSendToDreamworld)
		StorageUtil.SetIntValue(none, "DN_ONOFF", 1)

		If (iDreamworldVisitModifier > iDreamworldVisitModifierMax)
			iDreamworldVisitModifier = iDreamworldVisitModifierMax
		Endif

		Debug.Trace("[_sdras_dreamer]       iDreamworldVisitModifier: " + iDreamworldVisitModifier )
		Debug.Trace("[_sdras_dreamer]       iDreamworldVisitModifierMax: " + iDreamworldVisitModifierMax )

		If ( (StorageUtil.GetIntValue(kPlayer, "_SD_iChanceDreamworldOnSleep" )!= 0) && (Utility.RandomInt(0,iDreamworldVisitModifierMax)<  iDreamworldVisitModifier  )  )  
			; 	Debug.Notification("Reality slips away...")
			; 	Debug.Notification("[dream] Sanguine finds you in your dream")
	 		;	Game.FadeOutGame(true, true, 5.0, 10.0)

			If ((_SDGVP_sanguine_blessing.GetValue() == 0) || ( Self.GetOwningQuest().GetStage() == 0 )) 		
				startDreamworld()

			Else
				_SD_dreamQuest.SetStage(15)

			EndIf
		Else
			Debug.Trace("[_sdras_dreamer]         Better luck next time" )
		Endif

	else
		Debug.Trace("[_sdras_dreamer]         OnSleep event failed" )

	; elseif (Utility.RandomInt(0,100)>30) && (_SDGVP_sanguine_blessing.GetValue() > 0)
	; 		Debug.Trace("[SD] Sanguine items timer: OnSleep " )
	; 		_SDSP_freedom.RemoteCast( kPlayer, kPlayer, kPlayer )

	endif
EndEvent

Event OnSleepStop(bool abInterrupted)
	If abInterrupted
		If ( Self.GetOwningQuest().GetStage() == 0 && _SDGVP_stats_enslaved.GetValueInt() > 0 && _SDGVP_enslaved.GetValueInt() == 0 && dbe.pSleepyTime != 1 )



 	;		Game.FadeOutGame(false, true, 5.0, 10.0)
	;		kMeridiana.MoveToMyEditorLocation()
	;		kEisheth.MoveToMyEditorLocation()
	;		kSanguine.MoveToMyEditorLocation()
	;		Debug.SendAnimationEvent(kEisheth, "ZazAPCAO212")
		EndIf
	EndIf
EndEvent

function startDreamworld()
	Debug.Trace("[_sdras_dreamer] First visit to Dreamworld - welcome")

	_SDGVP_config_lust.SetValue(0)

	If ( !kConfig._SDBP_quests_primary_running[1] && !kConfig._SDBP_quests_primary_running[2])
		kConfig._SDBP_quests_primary_running[1] = True
		kConfig._SDQP_quests_primary[1].Start()
		kConfig._SDBP_quests_primary_running[2] = True
		kConfig._SDQP_quests_primary[2].Start()
	EndIf
			
	if ((_SDGVP_sanguine_blessing.GetValue() as Int)<=0)
		_SDGVP_sanguine_blessing.SetValue( 1 )
		StorageUtil.SetIntValue(Game.GetPlayer(), "_SD_iSanguineBlessings", _SDGVP_sanguine_blessing.GetValue() as Int )
	endif

	_SD_dreamQuest.SetStage(10)

endfunction


Function CleanupSlaveDevices(Actor akActor)
	; kSlave.RemoveAllItems(akTransferTo = _SDRAP_playerStorage.GetReference(), abKeepOwnership = True)

	Int iFormIndex = ( akActor as ObjectReference ).GetNumItems()
	Debug.Trace("[_sdras_dreamer] CleanupSlaveDevices - items to scan: " + iFormIndex )

	While ( iFormIndex > 0 )
		iFormIndex -= 1
		Form kForm = ( akActor as ObjectReference ).GetNthForm(iFormIndex)
		If ( kForm.GetType() == 26 && kForm.HasKeywordString("zad_Lockable") )
			Debug.Trace("[_sdras_dreamer]  		Removing : " + kForm )
			akActor.RemoveItem(kForm as Armor, 1, True )
		EndIf
	EndWhile	
EndFunction


Potion Property HonningbrewMead  Auto  
