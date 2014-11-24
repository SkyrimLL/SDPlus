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

	If  ( ( _SDGVP_sanguine_blessing.GetValue() == 0 && ( Self.GetOwningQuest().GetStage() == 0 && _SDGVP_stats_enslaved.GetValueInt() > 0 && _SDGVP_enslaved.GetValueInt() == 0 ) ) || ( _SDGVP_sanguine_blessing.GetValue() > 0 && (Utility.RandomInt(0,100)<= ( (_SDGVP_health_threshold.GetValue() as Int) / 20))  && (StorageUtil.GetIntValue(kPlayer, "_SD_iDisableDreamworldOnSleep") != 1) ) ) && dbe.pSleepyTime != 1

			; Debug.Notification("Reality slips away...")
			; Debug.Notification("[dream] Sanguine finds you in your dream")
 	;		Game.FadeOutGame(true, true, 5.0, 10.0)

			StorageUtil.SetIntValue(none, "DN_ONOFF", 1)
			If (_SDGVP_sanguine_blessing.GetValue() == 0) 
				If ( !kConfig._SDBP_quests_primary_running[1] && !kConfig._SDBP_quests_primary_running[2])
					kConfig._SDBP_quests_primary_running[1] = True
					kConfig._SDQP_quests_primary[1].Start()
					kConfig._SDBP_quests_primary_running[2] = True
					kConfig._SDQP_quests_primary[2].Start()
				EndIf

				_SD_dreamQuest.SetStage(10)
			Else
				_SD_dreamQuest.SetStage(15)
			EndIf

	;		Utility.Wait(1.0)

	elseif Game.GetPlayer().GetCurrentLocation().IsSameLocation(_SDLOC_HaelgaBasement) && (Utility.RandomInt(0,100)<= (( _SDGVP_health_threshold.GetValue() as Int) / 4))  && (_SDGVP_sanguine_blessing.GetValue() > 0)  && (StorageUtil.GetIntValue(kPlayer, "_SD_iDisableDreamworldOnSleep") != 1)
			StorageUtil.SetIntValue(none, "DN_ONOFF", 1)
	  	_SD_dreamQuest.SetStage(15)
	  	
	elseif Game.GetPlayer().GetCurrentLocation().IsSameLocation(_SDLOC_SanguineShrine) 
			StorageUtil.SetIntValue(none, "DN_ONOFF", 1)
			If (_SDGVP_sanguine_blessing.GetValue() == 0) 
				If ( !kConfig._SDBP_quests_primary_running[1] && !kConfig._SDBP_quests_primary_running[2])
					kConfig._SDBP_quests_primary_running[1] = True
					kConfig._SDQP_quests_primary[1].Start()
					kConfig._SDBP_quests_primary_running[2] = True
					kConfig._SDQP_quests_primary[2].Start()
				EndIf

				_SD_dreamQuest.SetStage(10)
			Else
				_SD_dreamQuest.SetStage(15)
			EndIf
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


Quest Property _SD_dreamQuest  Auto  

Location Property _SDLOC_HaelgaBasement  Auto  

Location Property _SDLOC_SanguineShrine  Auto  
_SD_ConfigMenu Property kConfig  Auto  

 
Spell Property _SDSP_freedom  Auto  

