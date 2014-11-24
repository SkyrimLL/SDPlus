Scriptname _SD_ConfigQuests extends Quest

_SDQS_functions Property funct  Auto
_SDQS_fcts_factions Property fctFactions  Auto

FormList Property _SDFLP_uninstall_dispel  Auto
FormList Property _SDFLP_uninstall_items  Auto
FormList Property _SDFLP_forced_joined  Auto  

GlobalVariable Property _SDGVP_state_mcm  Auto
GlobalVariable[] Property _SDGVP_reset  Auto  
Float[] Property _SDFP_global_defaults  Auto  

; local vars
_SD_ConfigMenu kConfig
Int idx
Float fRFSU = 5.0
Actor player
Spell nthSpell
Armor nthArmor
Int iCount

Float fSKSEMinVer
Float fSKSE

String sSDactionIs
String sSDactionHasBeen

Function removeSDSpells()
	idx = 0

	While idx < _SDFLP_uninstall_dispel.GetSize()
		nthSpell = _SDFLP_uninstall_dispel.GetAt(idx) as Spell
		player.DispelSpell( nthSpell )
		player.RemoveSpell( nthSpell )
		idx += 1
	EndWhile
EndFunction

Function removeSDItems()
	Actor kActor = Game.GetPlayer()
	Game.EnablePlayerControls()
	Game.SetInChargen(false, false, false)

	Debug.Notification("Cleaning up devices")

		If (kActor.WornHasKeyword(Libs.zad_DeviousBlindfold))
			libs.ManipulateGenericDeviceByKeyword(kActor, libs.zad_DeviousBlindfold, false, false, false)
		EndIf
		
		Utility.Wait(3.0)
		If (kActor.WornHasKeyword(Libs.zad_Deviousgag))
			libs.ManipulateGenericDeviceByKeyword(kActor, libs.zad_Deviousgag, false, false, false)
		EndIf
		
		Utility.Wait(3.0)
		If (kActor.WornHasKeyword(libs.zad_DeviousArmbinder))
			libs.ManipulateGenericDeviceByKeyword(kActor, libs.zad_DeviousArmbinder, false, false, false)
		EndIf	
		
		Utility.Wait(3.0)
		If (kActor.WornHasKeyword(libs.zad_DeviousCollar))
			libs.ManipulateGenericDeviceByKeyword(kActor, libs.zad_DeviousCollar, false, false, false)
		EndIf

	Debug.Notification("Done cleaning up devices")

EndFunction

Function resetGlobals()
	idx = 0
	While idx < _SDGVP_reset.Length
		_SDGVP_reset[idx].SetValue( _SDFP_global_defaults[idx] )
		idx += 1
	EndWhile
EndFunction

Event OnInit()
	player = Game.GetPlayer() as Actor
	kConfig = ( Self as Quest ) as _SD_ConfigMenu
	GotoState("waiting")
	If ( Self )
		RegisterForSingleUpdate( fRFSU )
	EndIf
EndEvent

Auto State waiting
	Event OnUpdate()
		While( player && !player.Is3DLoaded() )
		EndWhile
	
		fSKSEMinVer = 1.0613
		If ( SKSE.GetVersion() + SKSE.GetVersionMinor() * 0.01 + SKSE.GetVersionBeta() * 0.0001 != fSKSE )
			fSKSE = SKSE.GetVersion() + SKSE.GetVersionMinor() * 0.01 + SKSE.GetVersionBeta() * 0.0001
			If ( fSKSE < fSKSEMinVer )
				; pause the script while the Player
				; is loading
				Debug.MessageBox("Current SKSE Version: " + fSKSE + "\nRequired SKSE Version: " + fSKSEMinVer + "\n\nGet the latest version at\nhttp://skse.silverlock.org/")
			EndIf
		EndIf

		While ( Utility.IsInMenuMode() )
			Utility.WaitMenuMode(5.0)
		EndWhile

		; s_config_T1_value[0]  = "Locked"
		; s_config_T1_value[1]  = "Install"
		; s_config_T1_value[2]  = "Begin"
		; s_config_T1_value[3]  = "Uninstall"
		; s_config_T1_value[4]  = "Re-Install"

		If ( _SDGVP_state_mcm.GetValueInt() == 0 )
			; do nothing
		ElseIf ( _SDGVP_state_mcm.GetValueInt() == 1 && Self.GetState() != "install" )
			sSDactionIs = "$SD_STATUS_INSTALLING"
			sSDactionHasBeen = "$SD_STATUS_INSTALLED"
			GotoState("install")
		ElseIf ( _SDGVP_state_mcm.GetValueInt() == 2 && Self.GetState() != "starting" )
			sSDactionIs = "$SD_STATUS_STARTING"
			sSDactionHasBeen = "$SD_STATUS_STARTED"
			GotoState("starting")
		ElseIf ( _SDGVP_state_mcm.GetValueInt() == 3 && Self.GetState() != "stopping" )
			sSDactionIs = "$SD_STATUS_STOPPING"
			sSDactionHasBeen = "$SD_STATUS_STOPPED"
			GotoState("stopping")
		ElseIf ( _SDGVP_state_mcm.GetValueInt() == 4 && Self.GetState() != "resetting" )
			sSDactionIs = "$SD_STATUS_RESETTING"
			sSDactionHasBeen = "$SD_STATUS_RESET"
			GotoState("resetting")
		ElseIf ( _SDGVP_state_mcm.GetValueInt() == 255 && Self.GetState() != "optional" )
			sSDactionIs = "$SD_STATUS_UPDATING"
			sSDactionHasBeen = "$SD_STATUS_UPDATED"
			GotoState("optional")
		ElseIf ( _SDGVP_state_mcm.GetValueInt() == 254 && Self.GetState() != "addons" )
			sSDactionIs = "$SD_STATUS_UPDATING"
			sSDactionHasBeen = "$SD_STATUS_UPDATED"
			GotoState("addons")
		EndIf

		If ( player )
			RegisterForSingleUpdate( fRFSU )
		EndIf
	EndEvent
EndState


State addons
	Event OnUpdate()
		GotoState("waiting")
		Debug.Notification(sSDactionIs)
		idx = 0
		While idx < kConfig._SDQP_quests_addon.Length
			If ( kConfig._SDBP_quests_addon_running[idx] )
				kConfig._SDQP_quests_addon[idx].Start()
			Else
				kConfig._SDQP_quests_addon[idx].Stop()
			EndIf
			idx += 1
		EndWhile

		Debug.Notification(sSDactionHasBeen)
		_SDGVP_state_mcm.SetValue( 0 )
		If ( player )
			RegisterForSingleUpdate( fRFSU )
		EndIf
	EndEvent
EndState

State optional
	Event OnUpdate()
		GotoState("waiting")
		Debug.Notification(sSDactionIs)
		idx = 0
		While idx < kConfig._SDQP_quests_optional.Length
			If ( kConfig._SDBP_quests_optional_running[idx] )
				kConfig._SDQP_quests_optional[idx].Start()
			Else
				kConfig._SDQP_quests_optional[idx].Stop()
			EndIf
			idx += 1
		EndWhile

		Debug.Notification(sSDactionHasBeen)
		_SDGVP_state_mcm.SetValue( 0 )
		If ( player )
			RegisterForSingleUpdate( fRFSU )
		EndIf
	EndEvent
EndState

State install
	Event OnUpdate()
		GotoState("waiting")
		Debug.Notification( sSDactionIs )
		kConfig._SDBP_quests_primary_running[0] = True
		kConfig._SDQP_quests_primary[0].Start()

		Debug.Notification( sSDactionHasBeen )
		_SDGVP_state_mcm.SetValue( 0 )
		If ( player )
			RegisterForSingleUpdate( fRFSU )
		EndIf
	EndEvent
EndState

State starting
	Event OnUpdate()
		GotoState("waiting")
		Debug.Notification( sSDactionIs )
		kConfig._SDBP_quests_primary_running[1] = True
		kConfig._SDQP_quests_primary[1].Start()
		kConfig._SDBP_quests_primary_running[2] = True
		kConfig._SDQP_quests_primary[2].Start()

		Debug.Notification( sSDactionHasBeen )
		_SDGVP_state_mcm.SetValue( 0 )
		If ( player )
			RegisterForSingleUpdate( fRFSU )
		EndIf
	EndEvent
EndState

State stopping
	Event OnUpdate()
		GotoState("")
		Debug.Notification("$SD_STATUS_UNINSTALL_1")
		Utility.Wait( 3.0 )
		Debug.Notification("$SD_STATUS_UNINSTALL_2")

		idx = 0
		While idx < kConfig._SDQP_quests_primary.Length
			kConfig._SDBP_quests_primary_running[idx] = False
			kConfig._SDQP_quests_primary[idx].Stop()
			idx += 1
		EndWhile
		idx = 0
		While idx < kConfig._SDQP_quests_secondary.Length
			kConfig._SDBP_quests_secondary_running[idx] = False
			kConfig._SDQP_quests_secondary[idx].Stop()
			idx += 1
		EndWhile
		idx = 0
		While idx < kConfig._SDQP_quests_support.Length
			kConfig._SDBP_quests_support_running[idx] = False
			kConfig._SDQP_quests_support[idx].Stop()
			idx += 1
		EndWhile
		idx = 0
		While idx < kConfig._SDQP_quests_addon.Length
			kConfig._SDBP_quests_addon_running[idx] = False
			kConfig._SDQP_quests_addon[idx].Stop()
			idx += 1
		EndWhile

		resetGlobals()
		removeSDSpells()
		removeSDItems()
		
		fctFactions.resetAllyToActor(player, _SDFLP_forced_joined )

		Debug.Notification("$SD_STATUS_UNINSTALL_3")
		Utility.WaitGameTime( 2.0 )
		Debug.Notification("$SD_STATUS_UNINSTALL_4")
		_SDGVP_state_mcm.SetValue( 0 )
		Self.Stop()
	EndEvent
EndState

State resetting
	Event OnUpdate()
		Debug.Notification( sSDactionIs )
		GotoState("waiting")

		While idx < kConfig._SDQP_quests_primary.Length
			kConfig._SDBP_quests_primary_running[idx] = kConfig._SDBP_quests_primary_default[idx]
			kConfig._SDQP_quests_primary[idx].Stop()
			While ( kConfig._SDQP_quests_primary[idx].IsStopping() )
			EndWhile
			If ( kConfig._SDBP_quests_primary_default[idx] )
				kConfig._SDQP_quests_primary[idx].Start()
			EndIf
			idx += 1
		EndWhile
		idx = 0
		While idx < kConfig._SDQP_quests_secondary.Length
			kConfig._SDBP_quests_secondary_running[idx] = kConfig._SDBP_quests_secondary_default[idx]
			kConfig._SDQP_quests_secondary[idx].Stop()
			While ( kConfig._SDQP_quests_secondary[idx].IsStopping() )
			EndWhile
			If ( kConfig._SDBP_quests_secondary_default[idx] )
				kConfig._SDQP_quests_secondary[idx].Start()
			EndIf
			idx += 1
		EndWhile
		idx = 0
		While idx < kConfig._SDQP_quests_support.Length
			kConfig._SDBP_quests_support_running[idx] = kConfig._SDBP_quests_support_default[idx]
			kConfig._SDQP_quests_support[idx].Stop()
			While ( kConfig._SDQP_quests_support[idx].IsStopping() )
			EndWhile
			If ( kConfig._SDBP_quests_support_default[idx] )
				kConfig._SDQP_quests_support[idx].Start()
			EndIf
			idx += 1
		EndWhile
		idx = 0
		While idx < kConfig._SDQP_quests_addon.Length
			kConfig._SDBP_quests_addon_running[idx] = False
			kConfig._SDQP_quests_addon[idx].Stop()
			idx += 1
		EndWhile
		
		removeSDSpells()
		removeSDItems()

		Debug.Notification( sSDactionHasBeen )
		_SDGVP_state_mcm.SetValue( 0 )
		If ( player )
			RegisterForSingleUpdate( fRFSU )
		EndIf
	EndEvent
EndState


zadLibs Property libs Auto