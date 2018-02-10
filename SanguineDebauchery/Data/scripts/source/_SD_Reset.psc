Scriptname _SD_Reset extends Quest  

_SDQS_fcts_slavery Property fctSlavery  Auto
_SDQS_fcts_factions Property fctFactions  Auto
_SDQS_fcts_outfit Property fctOutfit  Auto

Quest Property _SD_arrested Auto
Quest Property _SD_bountyslave  Auto
Quest Property _SD_controller  Auto
Quest Property _SD_crime  Auto
Quest Property _SD_dream  Auto
Quest Property _SD_dream_destinations  Auto
Quest Property _SD_enslavement  Auto
Quest Property _SD_enslavement_tasks  Auto
Quest Property _SD_mcm_001  Auto
Quest Property _SD_naked  Auto
Quest Property _SD_snp  Auto
Quest Property _SD_sprigganslave  Auto
Quest Property _SD_thugslave  Auto
Quest Property _SD_watcher  Auto
Quest Property _SD_whore  Auto
GlobalVariable Property _SDGVP_enslaved Auto
GlobalVariable Property _SDGVP_naked_rape_delay Auto
GlobalVariable Property _SDGVP_config_ChanceDreamworldOnSleep  Auto
GlobalVariable Property GameDaysPassed Auto
ReferenceAlias Property Alias__SDRA_master  Auto
GlobalVariable Property _SDGVP_config_enable_beast_master  Auto

Float fVersion = 0.0 ; DEPRECATED
Int iVersionNumber = 20180101

Function Maintenance()
	Actor kPlayer = Game.GetPlayer()

	; UnregisterForAllModEvents()
	; Debug.Trace("Reset SexLab events")
	; RegisterForModEvent("AnimationStart", "OnSexLabStart")
	; RegisterForModEvent("AnimationEnd",   "OnSexLabEnd")

	if (libs.GetVersion() < 2.83)
	    Debug.Messagebox("Your version of Devious Devices Integration is outdated. You have to upgrade it in order to run SD+ 3.0 correctly." )
	EndIf

	if (!StorageUtil.HasIntValue( none, "_SLD_version") )
	    Debug.Messagebox("SexLab Dialogues is updating. Sanguine Debauchery relies on SexLab Dialogues for topics during slavery. Check your load order and mod versions if you see this message more than once." )
	EndIf	
 
 	Faction DefeatDialogueBlockFaction = Game.GetFormFromFile(0x0008C862, "SexLabDefeat.esp") As Faction
	If (DefeatDialogueBlockFaction != None)
		StorageUtil.SetFormValue( none, "_SD_SexLabDefeatDialogueBlockFaction", DefeatDialogueBlockFaction as Form)
	Else
		StorageUtil.SetFormValue( none, "_SD_SexLabDefeatDialogueBlockFaction", None)
	Endif


	; Debug.Notification("Running SD+ version: " + fVersion as Int)
	; Reload every time
	fctOutfit.registerDeviousOutfits ( )

	If iVersionNumber < 20180125 ; <--- Edit this value when updating
		iVersionNumber = 20180125; and this
		_SDGVP_version.SetValue(fVersion)
		Debug.Notification("Updating to SD+ version: " + iVersionNumber )
		Debug.Trace("[SD] Updating to SD+ version: " + iVersionNumber)
		StorageUtil.SetIntValue( none, "_SD_version", iVersionNumber)

		StorageUtil.SetIntValue(none, "_SD_iSanguine", 1)
		
		StorageUtil.SetIntValue(kPlayer, "_SD_iEnableBeastMaster", _SDGVP_config_enable_beast_master.GetValue() as Int)
		; Update Code

		fctFactions.initHumanoidMastersList (  )
		fctFactions.initBeastMastersList (  )
		fctOutfit.initSlaveryGearByRace (  )
		fctFactions.initSlaveryFactionByRace (  )

		fctSlavery.InitPunishmentIdle()

		If (!StorageUtil.HasIntValue(kPlayer, "_SD_iDisableDreamworld"))
			StorageUtil.SetIntValue( kPlayer , "_SD_iDisableDreamworld", 0)
			StorageUtil.SetIntValue( kPlayer, "_SD_iMasterTravelDelay", 1) ; in Days
			StorageUtil.SetIntValue( kPlayer, "_SD_iDaysMaxJoinedFaction", 20)
			StorageUtil.SetIntValue( kPlayer, "_SL_iPlayerSexAnim", 0)
		endif

		If (StorageUtil.GetIntValue( kPlayer  , "_SD_iHandsFree") == 0) && (StorageUtil.GetIntValue( kPlayer  , "_SD_iEnableAction") == 1) 
			StorageUtil.SetIntValue( kPlayer  , "_SD_iHandsFree", 1 )
			StorageUtil.SetIntValue( kPlayer  , "_SD_iEnableAction", 1 )			
		Endif

		If (!StorageUtil.HasStringValue(kPlayer, "_SD_sSanguineGender"))
			StorageUtil.SetStringValue(kPlayer, "_SD_sSanguineGender","Both")
		Endif

		StorageUtil.SetIntValue(kPlayer, "_SD_iChanceDreamworldOnSleep", _SDGVP_config_ChanceDreamworldOnSleep.GetValue() as Int)

		If (StorageUtil.FormListFind(kPlayer, "_SD_lBannedSlaveryFactions", SexLabProhibitedFaction as Form)<0)
			StorageUtil.FormListAdd(kPlayer, "_SD_lBannedSlaveryFactions", SexLabProhibitedFaction as Form)
		Endif


		; kPlayer.SendModEvent( "PCSubStance" , "Standing")

		
		Float fNext = GameDaysPassed.GetValue() + Utility.RandomFloat( 0.125, 0.25 )
		_SDGVP_naked_rape_delay.SetValue( fNext )
		_SDGVP_naked_rape_chance.SetValue(25.0)

		If ( _SD_controller.IsRunning() )
		;	_SD_controller.Stop()
		;	Debug.Messagebox("Stopping main SD quest for maintenance.\n Open the SD menu and select BEGIN again." )
			_SD_controller.SetObjectiveDisplayed(0,false)
		EndIf

		If ( _SD_dream_destinations.IsRunning() )
			_SD_dream_destinations.Stop()
		EndIf

		If ( _SD_snp.IsRunning() )
			_SD_snp.Stop()
		EndIf

		; Maintenance code scaffold for now - not in use.
		; Find better way to restart these quests safely

		; If ( _SD_enslavement_tasks.IsRunning() )
			; Debug.Notification("Shutting down Enslavement Tasks Quest" )
			; _SD_enslavement_tasks.SetStage(1000)
		; EndIf

		If ( _SD_enslavement.IsRunning() )
			Debug.Messagebox("Enslavement Quest is running during an upgrade. Canceling enslavement to apply changes." )
			; SendModEvent("PCSubFree")

			; Disabled for now
			; - Sets slave faction to 0 in loop
			; - Breaks enslavement

			_SD_enslavement.Stop()
		EndIf

		If ( _SD_thugslave.IsRunning() )
			_SD_thugslave.Stop()
		EndIf

		; If ( _SD_dream.IsRunning() )
			; Debug.Messagebox("Stopping dream quest for maintenance.\n Run 'startquest _sd_dream' in the console if you do not see 'Sanguine is watching' after this message." )

			; Disabled for now
			; - Instantly brings player to dreamworld
			; - NPCs victims are messed up (two idle overlap)

			; _SD_dream.SetStage(999)
			; _SD_dream.Stop()
			; Utility.Wait(2.0)
			; _SD_dream.Start()
		; EndIf

		; Init slavery API
		If (StorageUtil.GetIntValue(kPlayer, "_SD_iAPIInit")!=1)
			fctSlavery.InitSlaveryState( kPlayer )
		EndIf


	EndIf

	Actor master = Alias__SDRA_master.GetReference() as Actor
	; Debug.Notification("Master:" + master.GetName() + " - Dead: " +  master.IsDead())
	If (master)
		If ( _SD_enslavement.GetStage() < 90 )  &&  (master.IsDead() )
			; Debug.Notification("Master is dead." )

			If ( _SDGVP_enslaved.GetValue() == 1)
				Debug.Notification("You are still enslaved." )
				Debug.Notification("Shutting down Enslavement Quest" )
				_SDGVP_enslaved.SetValue(0)
				_SD_enslavement.Stop()
			EndIf
		EndIf
	EndIf
EndFunction

 

GlobalVariable Property _SDGVP_naked_rape_chance  Auto  
GlobalVariable Property _SDGVP_version  Auto  

zadLibs Property libs Auto

Faction Property SexLabProhibitedFaction  Auto  
