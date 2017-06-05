Scriptname _SDRAS_dreamer extends ReferenceAlias  

pDBEntranceQuestScript Property dbe Auto

GlobalVariable Property _SDGVP_enslaved  Auto  
GlobalVariable Property _SDGVP_stats_enslaved  Auto  
ReferenceAlias Property _SDRAP_enter  Auto  
ReferenceAlias Property _SDRAP_leave  Auto  
ReferenceAlias Property _SDRAP_meridiana  Auto  
ReferenceAlias Property _SDRAP_naamah  Auto  
ReferenceAlias Property _SDRAP_eisheth  Auto  
ReferenceAlias Property _SDRAP_sanguine  Auto  

ReferenceAlias Property Alias__SDRA_lust_m  Auto
ReferenceAlias Property Alias__SDRA_lust_f  Auto

GlobalVariable Property _SDGVP_config_lust auto
GlobalVariable Property _SDGVP_sanguine_blessing auto
GlobalVariable Property _SDGVP_health_threshold auto
GlobalVariable Property _SDGVP_config_auto_start  Auto
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

	; Disabling for now - removes locked devices instead of cleaning up items in inventory that are not worn
	; CleanupSlaveDevices(kPlayer)

	If (StorageUtil.GetIntValue(kPlayer, "_SD_iDisableDreamworld") == 1) 
		Debug.Trace("[_sdras_dreamer] Dreamworld disabled by script")
		Return
	Endif

	If (StorageUtil.GetIntValue(kPlayer, "_SD_iDisableDreamworldOnSleep") == 1)
		Debug.Trace("[_sdras_dreamer] Dreamworld on Sleep disabled: " + StorageUtil.GetIntValue(kPlayer, "_SD_iDisableDreamworldOnSleep"))
		Return
	Endif

	StorageUtil.SetIntValue(kPlayer, "_SD_iChanceDreamworldOnSleep", _SDGVP_sanguine_blessing.GetValue() as Int)

	Debug.Trace("[_sdras_dreamer] Auto start?: " + _SDGVP_config_auto_start.GetValue())
	Debug.Trace("[_sdras_dreamer] Start after Night to remember?: " + _SDGVP_config_lust.GetValue())
	Debug.Trace("[_sdras_dreamer] Is Night to remember completed?: " + ANightQuest.IsCompleted())
	Debug.Trace("[_sdras_dreamer] Chance on sleep: " + StorageUtil.GetIntValue(kPlayer, "_SD_iChanceDreamworldOnSleep" ))
	Debug.Trace("[_sdras_dreamer] Sanguine Blessing: " + _SDGVP_sanguine_blessing.GetValue())
	Debug.Trace("[_sdras_dreamer] Number times enslaved: " + _SDGVP_stats_enslaved.GetValueInt())

	If  (_SDGVP_config_auto_start.GetValue() == 1) && ( Self.GetOwningQuest().GetStage() == 0 ) && (_SDGVP_stats_enslaved.GetValueInt() > 0) && (_SDGVP_enslaved.GetValueInt() == 0) 
		; First visit - Sleep after release from first enslavement and not currently enslaved

		If  (_SDGVP_config_lust.GetValue()==1) && (ANightQuest.IsCompleted())   
			Debug.Trace("[_sdras_dreamer]         Sleep after first enslavement and A Night to Remember" )
			bSendToDreamworld = True

		elseIf  (_SDGVP_config_lust.GetValue()==0)
			Debug.Trace("[_sdras_dreamer]         Sleep after first enslavement only" )
			bSendToDreamworld = True
		Endif

	elseif ( (_SDGVP_sanguine_blessing.GetValue() > 0) && (Utility.RandomInt(1,100)<  StorageUtil.GetIntValue(kPlayer, "_SD_iChanceDreamworldOnSleep" ))  && (StorageUtil.GetIntValue(kPlayer, "_SD_iDisableDreamworldOnSleep") != 1) )  
		; Subsequent visits  
		
		Debug.Trace("[_sdras_dreamer]         Randomly sent to Dreamworld after first visit" )
		; 	Debug.Notification("Reality slips away...")
		; 	Debug.Notification("[dream] Sanguine finds you in your dream")
 		;	Game.FadeOutGame(true, true, 5.0, 10.0)
		bSendToDreamworld = True

	elseif ((kLocation) && (StorageUtil.GetIntValue(kPlayer, "_SD_iDisableDreamworldOnSleep") != 1) )  
		Debug.Trace("[_sdras_dreamer]         OnSleep event by location" )

		If kLocation.IsSameLocation(_SDLOC_HaelgaBasement) && (Utility.RandomInt(1,100)< (StorageUtil.GetIntValue(kPlayer, "_SD_iChanceDreamworldOnSleep" ) * 2))  && (_SDGVP_sanguine_blessing.GetValue() > 0)  
			bSendToDreamworld = True
		  	
		elseif kLocation.IsSameLocation(_SDLOC_SanguineShrine) 
			bSendToDreamworld = True
		EndIf
	EndIf

	; Disable Dreamworld on Sleep if delay option is checked and DA14 quest not done yet
	If  ( (_SDGVP_config_lust.GetValue()==1) && (!ANightQuest.IsCompleted()) ) && (_SDGVP_config_auto_start.GetValue() == 1)
		Debug.Trace("[_sdras_dreamer]         OnSleep event aborted (Night to remember not done yet)" )
		bSendToDreamworld = False
	
	EndIf

	; Abort dreamworld if player is arrested or sleeping during Dark Brotherhood quest
	if (dbe.pSleepyTime == 1)  || (kPlayer.IsArrested() == True)
		Debug.Trace("[_sdras_dreamer]         OnSleep event aborted (quest or arrested)" )
		bSendToDreamworld = False
	EndIf

	; Send player to Dreamworld if true
	If (bSendToDreamworld)
		StorageUtil.SetIntValue(none, "DN_ONOFF", 1)

		Debug.Trace("[_sdras_dreamer] Sanguine blessings" + _SDGVP_sanguine_blessing.GetValue())

		If (_SDGVP_sanguine_blessing.GetValue() == 0) 
			
			startDreamworld()

		Else
			_SD_dreamQuest.SetStage(15)

		EndIf
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

Quest Property _SD_dreamQuest  Auto  

Location Property _SDLOC_HaelgaBasement  Auto  

Location Property _SDLOC_SanguineShrine  Auto  
_SD_ConfigMenu Property kConfig  Auto  

 
Spell Property _SDSP_freedom  Auto  


Quest Property ANightQuest  Auto  
