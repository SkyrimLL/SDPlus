Scriptname _SD_ConfigMenu extends SKI_ConfigBase

Import StringUtil

_SDQS_config Property config  Auto

GlobalVariable Property _SDGVP_config_essential  Auto
GlobalVariable Property _SDGVP_config_healthMult  Auto
GlobalVariable Property _SDGVP_config_healthThreshold  Auto
GlobalVariable Property _SDGVP_config_buyout  Auto
GlobalVariable Property _SDGVP_config_escape_radius  Auto
GlobalVariable Property _SDGVP_config_escape_timer  Auto
GlobalVariable Property _SDGVP_config_work_start  Auto
GlobalVariable Property _SDGVP_config_join_days  Auto
GlobalVariable Property _SDGVP_config_safeword  Auto
GlobalVariable Property _SDGVP_config_lust  Auto
GlobalVariable Property _SDGVP_config_auto_start  Auto
GlobalVariable Property _SDGVP_config_cbbe  Auto
GlobalVariable Property _SDGVP_config_custom_cloths  Auto
GlobalVariable Property _SDGVP_config_itemRemovalType  Auto
GlobalVariable Property _SDGVP_config_maleflacid  Auto
GlobalVariable Property _SDGVP_uninstall  Auto
GlobalVariable Property _SDGVP_enslaved  Auto
GlobalVariable Property _SDGVP_sprigganenslaved  Auto
GlobalVariable Property _SDGVP_config_genderRestrictions  Auto
GlobalVariable Property _SDGVP_config_verboseMerits  Auto
GlobalVariable Property _SDGVP_state_mcm  Auto
GlobalVariable Property _SDGVP_config_enableTrainRun  Auto
GlobalVariable Property _SDGVP_config_blindnessLevel  Auto
GlobalVariable Property _SDGVP_config_hardcore  Auto

GlobalVariable Property _SDGVP_config_enable_beast_master  Auto
GlobalVariable Property _SDGVP_config_ArmbinderKnee  Auto
GlobalVariable Property _SDGVP_config_SlaveOnKnees  Auto
GlobalVariable Property _SDGVP_config_RemoveArmBinder  Auto
GlobalVariable Property _SDGVP_config_RemovePunishment  Auto
GlobalVariable Property _SDGVP_config_GagType  Auto

GlobalVariable Property _SDGVP_config_min_slavery_level Auto
GlobalVariable Property _SDGVP_config_max_slavery_level Auto
GlobalVariable Property _SDGVP_config_slavery_level_mult Auto
GlobalVariable Property _SDGVP_config_disposition_threshold Auto

String[] Property _SDSP_config_genderRestrictions  Auto

Quest Property WIAddItem03  Auto  
ReferenceAlias Property pThug1  Auto  
ReferenceAlias Property pThug2  Auto  
ReferenceAlias Property pThug3  Auto  
Message Property _SDMP_wiadditem03  Auto  

Quest[] Property _SDQP_quests_primary  Auto
Bool[] Property _SDBP_quests_primary_running  Auto
Bool[] Property _SDBP_quests_primary_default  Auto
Quest[] Property _SDQP_quests_secondary  Auto
Bool[] Property _SDBP_quests_secondary_running  Auto
Bool[] Property _SDBP_quests_secondary_default  Auto
Quest[] Property _SDQP_quests_support  Auto
Bool[] Property _SDBP_quests_support_running  Auto
Bool[] Property _SDBP_quests_support_default  Auto
Quest[] Property _SDQP_quests_optional  Auto
Bool[] Property _SDBP_quests_optional_running  Auto
Bool[] Property _SDBP_quests_optional_default  Auto

Quest[] Property _SDQP_quests_addon  Auto
Int[] Property _SDBP_quests_addon_refid  Auto
String[] Property _SDSP_quests_addon_name  Auto
Int[] Property _SDSP_quests_addon_required  Auto
{ points to the idx of _SDBP_support_mods_installed }
Bool[] Property _SDBP_quests_addon_running  Auto
GlobalVariable[] Property _SDGVP_quests_addon_subToggle  Auto
String[] Property _SDGVP_quests_addon_subToggle_name  Auto

Int[] Property _SDIP_support_mods_refid  Auto
String[] Property _SDSP_support_mods_name  Auto
Bool[] Property _SDBP_support_mods_installed  Auto


; PRIVATE VARIABLES -------------------------------------------------------------------------------

; OIDs (T:Text B:Toggle S:Slider M:Menu, C:Color, K:Key)
Int _SDOID_config_T1
Int _SDOID_config_T2
Int _SDOID_config_B1
Int _SDOID_config_B2
Int _SDOID_config_B21
Int _SDOID_config_B3
Int _SDOID_config_B4
Int _SDOID_config_B5
Int _SDOID_config_B6
Int _SDOID_config_B7
Int _SDOID_config_B8
Int _SDOID_config_B9
Int _SDOID_config_B10
Int _SDOID_config_B11
Int _SDOID_config_B12
Int _SDOID_config_B13
Int _SDOID_config_B14

Int _SDOID_config_S1
Float _SDOID_config_S1_min = 0.0
Float _SDOID_config_S1_max = 100.0 ; 3.0
Float _SDOID_config_S1_default = 100.0 ; 1.0
Float _SDOID_config_S1_inc = 5.0 ; 0.1
Int _SDOID_config_S2
Float _SDOID_config_S2_min = 0.0
Float _SDOID_config_S2_max = 100.0
Float _SDOID_config_S2_default = 100.0
Float _SDOID_config_S2_inc = 5.0
Int _SDOID_config_S3
Float _SDOID_config_S3_min = 250.0
Float _SDOID_config_S3_max = 1500.0
Float _SDOID_config_S3_default = 500.0
Float _SDOID_config_S3_inc = 10.0
Int _SDOID_config_S4
Float _SDOID_config_S4_min = 1536.0
Float _SDOID_config_S4_max = 3072.0
Float _SDOID_config_S4_default = 3072.0
Float _SDOID_config_S4_inc = 32.0
Int _SDOID_config_S5
Float _SDOID_config_S5_min = 15.0
Float _SDOID_config_S5_max = 600.0
Float _SDOID_config_S5_default = 300.0
Float _SDOID_config_S5_inc = 5.0
Int _SDOID_config_S6
Float _SDOID_config_S6_min = 0.0
Float _SDOID_config_S6_max = 15.0
Float _SDOID_config_S6_default = 0.125
Float _SDOID_config_S6_inc = 0.125
Int _SDOID_config_S7
Float _SDOID_config_S7_min = 50.0
Float _SDOID_config_S7_max = 100.0
Float _SDOID_config_S7_default = 100.0
Float _SDOID_config_S7_inc = 10.0
Int _SDOID_config_S8
Float _SDOID_config_S8_min = 1.0
Float _SDOID_config_S8_max = 6.0
Float _SDOID_config_S8_default = 0.0
Float _SDOID_config_S8_inc = 1.0
Int _SDOID_config_S9
Float _SDOID_config_S9_min = 1.0
Float _SDOID_config_S9_max = 6.0
Float _SDOID_config_S9_default = 6.0
Float _SDOID_config_S9_inc = 1.0
Int _SDOID_config_S10
Float _SDOID_config_S10_min = 0.0
Float _SDOID_config_S10_max = 2.0
Float _SDOID_config_S10_default = 0.8
Float _SDOID_config_S10_inc = 0.1
Int _SDOID_config_S11
Float _SDOID_config_S11_min = 1.0
Float _SDOID_config_S11_max = 20.0
Float _SDOID_config_S11_default = 5.0
Float _SDOID_config_S11_inc = 1.0

Int _SDOID_config_M1 ;unused

Int _SDOID_config_K1
Int _SDOID_config_K2
Int _SDOID_config_K3
Int _SDOID_config_K4
Int _SDOID_config_K5
Int _SDOID_config_K6
Int _SDOID_config_K7


Int[] _SDOID_quests_p
Int[] _SDOID_quests_s
Int[] _SDOID_quests_o
Int _SDOID_quests_o_flag
Int[] _SDOID_quests_a
Int[] _SDOID_quests_ast

Int _SDOID_help_T1
Int _SDOID_help_T2
Int _SDOID_help_T3
Int _SDOID_help_T4
Int _SDOID_help_T5
Int _SDOID_help_T6
Int _SDOID_help_T7
Int _SDOID_help_T8

; State

; ...

; Internal
String[] s_config_T1_text
String[] s_config_T1_value
Int[] i_config_T1_flag
Int[] i_config_B2_flag
Int i_T1_action
Int idx
Bool bRunning
Quest fDawnGuardPatchQuest

_SD_ConfigQuests kQuests

; PRIVATE FUNCTIONS -------------------------------------------------------------------------------
string Function decimalDaysToString( Float afDays )
	Return "$SD_CONCAT_{" + Math.Floor( afDays ) as String + "}DAYS_{" + (( afDays * 24.0 ) as Int % 24 ) as String  + "}HOURS"
EndFunction

; Simple C++ like sprintf
; %%    a percent sign
; %s    a string
; %d    a signed integer
; %f    a floating-point number
;
; @asSource String - The format string containing the % tokens
; @asReplacements String Array - The stack of replacements for the % tokens
String Function sPrintF(String asSource, String[] asReplacements )
	Int iStart = 0
	Int iEnd = 0
	Int iIndex  = 0
	String sReturn = ""
	String sOperator = ""
	
	iEnd = StringUtil.Find(asSource, "%", iStart)
	If ( iEnd == -1 )
		Debug.Trace( "You are passing an unformatted string into sprintf: " + asSource )
		Return asSource
	Else
		While ( iEnd != -1 && iIndex < asReplacements.Length )
			sOperator = getNthChar(asSource, iEnd + 1)

			If ( sOperator == "%" )
				sReturn += Substring(asSource, iStart, iEnd) + "%"
			ElseIf ( sOperator == "s" )
				sReturn += Substring(asSource, iStart, iEnd) + asReplacements[ iIndex ] as String
			ElseIf ( sOperator == "d" )
				sReturn += Substring(asSource, iStart, iEnd) + asReplacements[ iIndex ] as Int
			ElseIf ( sOperator == "f" )
				sReturn += Substring(asSource, iStart, iEnd) + asReplacements[ iIndex ] as Float
			Else
				Debug.Trace( "Improper format for sprintf: " + asSource )
				Return asSource
			EndIf

			iIndex += 1
			iStart = iEnd + 2
			iEnd = StringUtil.Find(asSource, "%", iStart)
		EndWhile

		sReturn += Substring(asSource, iStart)
	EndIf
	
	Return sReturn
EndFunction

string Function unitsToRealWorld( Float afUnits, Bool abMetric = False )
	If ( abMetric )
		Float fMeters = (afUnits * 0.9144)/ 64.0
		Float fFmeters = Math.Floor( fMeters ) as Int
		Float fCmeters = Math.Ceiling( fMeters ) as Int

		If ( fFmeters == fCmeters )
			Return "$SD_CONCAT_EXACTLY{" + fCmeters + "}METERS"
		Else
			Return "$SD_CONCAT_BETWEEN{" + fFmeters + "}AND{" + fCmeters + "}METERS"
		EndIf
	Else
		Float fYards = afUnits / 64.0
		Float fFyards = Math.Floor( fYards ) as Int
		Float fCyards = Math.Ceiling( fYards ) as Int

		If ( fFyards == fCyards )
			Return "$SD_CONCAT_EXACTLY{" + fCyards + "}YARDS"
		Else
			Return "$SD_CONCAT_BETWEEN{" + fFyards + "}AND{" + fCyards + "}YARDS"
		EndIf
	EndIf

EndFunction

Bool Function modInstalled( String asMod )
	; ugly patch to allow upgrades to Frostfall 3.0 while game is running
	if (asMod == "Chesko_Frostfall.esp")
		asMod = "Frostfall.esp"
	endIf

	Int thisIdx = _SDSP_support_mods_name.RFind(asMod)

	If ( thisIdx >= 0 )
		Return _SDBP_support_mods_installed[thisIdx]
	Else
		Return False
	EndIf
EndFunction

Bool Function requiredParentModInstalled( Int aiIdx )
	; uglier patch to allow upgrades to Frostfall 3.0 while game is running
	if (!_SDBP_support_mods_installed[3]) 
		if (Game.GetModByName("Frostfall.esp") != 255)
			_SDBP_support_mods_installed[3] = true
		endif
	endif

	Return _SDBP_support_mods_installed[ _SDSP_quests_addon_required[aiIdx] ]
EndFunction

; SCRIPT VERSION ----------------------------------------------------------------------------------
;                 2147483647
Int _SD_mcm_ver = 20150125

int function GetVersion()
	; patch to fix a screw up
	If ( CurrentVersion == 2147483647 )
		CurrentVersion = _SD_mcm_ver
		initMod()

	EndIf

	return _SD_mcm_ver
endFunction

; INITIALIZATION ----------------------------------------------------------------------------------
Function initMod( Bool bResetGlobals = False )
	Debug.Trace("=============== _SD::START IGNORE: Testing loaded addons & mods. ==================")
	idx = 0
	While idx < _SDSP_quests_addon_name.Length
		Debug.Trace("Testing for: " + _SDSP_quests_addon_name[idx])
		_SDQP_quests_addon[idx] = Game.GetFormFromFile(_SDBP_quests_addon_refid[idx], _SDSP_quests_addon_name[idx]) as Quest
		idx += 1
	EndWhile
	idx = 0
	While idx < _SDSP_support_mods_name.Length
		; Debug.Trace("Testing for: " + _SDSP_support_mods_name[idx])
		; _SDBP_support_mods_installed[idx] = Game.GetFormFromFile(_SDIP_support_mods_refid[idx], _SDSP_support_mods_name[idx]) as Bool
		if (idx==3) 
			Debug.Trace("Testing for: Frostfall.esp" )
			if (Game.GetModByName("Frostfall.esp") != 255)
				_SDSP_support_mods_name[3] = "Frostfall.esp"
				_SDBP_support_mods_installed[3] = true
			endif
		endif
		idx += 1
	EndWhile
	Debug.Trace("=============== _SD::END IGNORE: Testing loaded addons & mods. ====================")

	kQuests = ( Self as Quest ) as _SD_ConfigQuests
	
	If ( bResetGlobals )
		kQuests.resetGlobals()
	EndIf

	if (pThug1)
		pThug1.GetActorReference().Delete()
	EndIf
	if (pThug2)
		pThug2.GetActorReference().Delete()
	EndIf
	if (pThug3)
		pThug3.GetActorReference().Delete()
	EndIf
	WIAddItem03.Stop()

	Pages = New String[5]
	Pages[0] = "$SD_PAGE_CONFIG"
	Pages[1] = "$SD_PAGE_STATUS"
	Pages[2] = "$SD_PAGE_CONTROL"
	Pages[3] = "$SD_PAGE_ADDONS"
	Pages[4] = "$SD_PAGE_HELP"


	_SDSP_config_genderRestrictions = New String[4]
	_SDSP_config_genderRestrictions[0] = "$SD_GENDER_NO"
	_SDSP_config_genderRestrictions[1] = "$SD_GENDER_SAME"
	_SDSP_config_genderRestrictions[2] = "$SD_GENDER_OPPOSITE"
	_SDSP_config_genderRestrictions[3] = "SEXLAB"

	; primary
	_SDOID_quests_p      = New Int[ 5 ]
	_SDOID_quests_p[0]   = -1
	_SDOID_quests_p[1]   = -1
	_SDOID_quests_p[2]   = -1
	_SDOID_quests_p[3]   = -1
	_SDOID_quests_p[4]   = -1
	; secondary
	_SDOID_quests_s      = New Int[ 7 ]
	_SDOID_quests_s[0]   = -1
	_SDOID_quests_s[1]   = -1
	_SDOID_quests_s[2]   = -1
	_SDOID_quests_s[3]   = -1
	_SDOID_quests_s[4]   = -1
	_SDOID_quests_s[5]   = -1
	_SDOID_quests_s[6]   = -1
	; optional
	_SDOID_quests_o      = New Int[ 2 ]
	_SDOID_quests_o[0]   = -1
	_SDOID_quests_o[1]   = -1
	; addon
	_SDOID_quests_a      = New Int[ 3 ]
	_SDOID_quests_a[0]   = -1
	_SDOID_quests_a[1]   = -1
	_SDOID_quests_a[2]   = -1
	_SDOID_quests_ast    = New Int[ 3 ]
	_SDOID_quests_ast[0] = -1
	_SDOID_quests_ast[1] = -1
	_SDOID_quests_ast[2] = -1

	s_config_T1_text   = New String[5]
	s_config_T1_value  = New String[5]
	i_config_T1_flag   = New Int[5]
	i_config_B2_flag   = New Int[5]
	s_config_T1_text[0]   = "$SD_MOD_STATE_RUNNING"
	s_config_T1_text[1]   = "$SD_MOD_STATE_READY_TO_INSTALL"
	s_config_T1_text[2]   = "$SD_MOD_STATE_READY_TO_BEGIN"
	s_config_T1_text[3]   = "$SD_MOD_STATE_PREPARE_FOR_UNINSTALL"
	s_config_T1_text[4]   = "$SD_MOD_STATE_UNINSTALLED"
	s_config_T1_value[0]  = "$SD_MOD_STATE_LOCKED"
	s_config_T1_value[1]  = "$SD_MOD_STATE_INSTALL"
	s_config_T1_value[2]  = "$SD_MOD_STATE_BEGIN"
	s_config_T1_value[3]  = "$SD_MOD_STATE_UNINSTALL"
	s_config_T1_value[4]  = "$SD_MOD_STATE_RE_INSTALL"
	i_config_T1_flag[0]   = OPTION_FLAG_DISABLED
	i_config_T1_flag[1]   = OPTION_FLAG_NONE
	i_config_T1_flag[2]   = OPTION_FLAG_NONE
	i_config_T1_flag[3]   = OPTION_FLAG_NONE
	i_config_T1_flag[4]   = OPTION_FLAG_NONE
	i_config_B2_flag[0]   = OPTION_FLAG_DISABLED
	i_config_B2_flag[1]   = OPTION_FLAG_NONE
	i_config_B2_flag[2]   = OPTION_FLAG_NONE
	i_config_B2_flag[3]   = OPTION_FLAG_DISABLED
	i_config_B2_flag[4]   = OPTION_FLAG_DISABLED
EndFunction

; @implements SKI_ConfigBase
event OnConfigInit()
	{Called when this config menu is initialized}
	initMod()
endEvent

; @implements SKI_QuestBase
event OnVersionUpdate(int a_version)
	{Called when a version update of this script has been detected}
	If ( a_version != _SD_mcm_ver || CurrentVersion != _SD_mcm_ver )
		Debug.Notification("[SD] Updating script to version " + _SD_mcm_ver)
		Debug.Trace("[SD] Updating script to version " + _SD_mcm_ver)
		initMod( True )
	EndIf
endEvent

; EVENTS ------------------------------------------------------------------------------------------

; @implements SKI_ConfigBase
event OnPageReset(string a_page)
	{Called when a new page is selected, including the initial empty page}
	; Load custom .swf for animated logo that's displayed when no page is selected yet.
	if (a_page == "" || !Self.IsRunning() )
		;SetTitleText( "$SD_CONCAT{" + CurrentVersion as String + "}VERSION" )
		SetTitleText( "Version: " + _SD_mcm_ver as String + "" )
		LoadCustomContent("_SD_/sanguine_rose.dds", 171, 97)
		return
	else
		UnloadCustomContent()
	endIf

	; CONFIG
	If ( a_page == Pages[0] )
		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption("$SD_HEADER_P0_COMBAT") ;0 - 1
		; _SDOID_config_S1 = AddSliderOption("$SD_OPTION_P0_BUFFER", _SDGVP_config_healthMult.GetValue() as Float, "$SD_HEALTH", OPTION_FLAG_DISABLED) ;2 - 2
		; _SDOID_config_S2 = AddSliderOption("$SD_OPTION_P0_WEAKENED_AT", _SDGVP_config_healthThreshold.GetValue() as Float, "$SD_PERCENT_HEALTH") ;4 - 3
		_SDOID_config_S2 = AddSliderOption("Chance of enslavement", _SDGVP_config_healthThreshold.GetValue() as Float, "{1} %")  
		_SDOID_config_S1 = AddSliderOption("Chance of spriggan infection", _SDGVP_config_healthMult.GetValue() as Float, "{1} %")  
		; _SDOID_config_B1 = AddToggleOption("$SD_OPTION_P0_ESSENTIAL_WHILE_WEAKENED", _SDGVP_config_essential.GetValue() as Bool, OPTION_FLAG_DISABLED) ;6 - 4
		AddHeaderOption("$SD_HEADER_P0_ITEMS") ;8 - 5
		_SDOID_config_B3 = AddToggleOption("$SD_OPTION_P0_LIMITED_REMOVAL", _SDGVP_config_itemRemovalType.GetValue() as Bool) ;10 - 6
		AddHeaderOption("$SD_HEADER_P0_ORIENTATION") ;12 - 7
		_SDOID_config_T2 = AddTextOption("$SD_OPTION_P0_GENDER_RESTRICTION", _SDSP_config_genderRestrictions[ _SDGVP_config_genderRestrictions.GetValueInt() ] as String ) ;14 - 8
		; AddHeaderOption("$SD_HEADER_P0_NOTIFICATION") ;16 - 9
		; _SDOID_config_B6 = AddToggleOption("$SD_OPTION_P0_SHOW_DEMERIT_CHANGES", _SDGVP_config_verboseMerits.GetValue() as Bool) ;18 - 10
		AddHeaderOption("$SD_HEADER_P0_NPC_REACTION") ;20 - 11
		_SDOID_config_B8 = AddToggleOption("$SD_OPTION_P0_ENABLE_TRAIN_RUN", _SDGVP_config_enableTrainRun.GetValue() as Bool) ;22 - 12
		;# SDpatch #
		;###############################################################################################
		AddHeaderOption("Slave Options")
		_SDOID_config_B10 = AddToggleOption("Enable Armbinder Kneeling", _SDGVP_config_ArmbinderKnee.GetValue() as Bool) ;
		_SDOID_config_B11 = AddToggleOption("Enable Beast Enslavement", _SDGVP_config_enable_beast_master.GetValue() as Bool) ;
		; _SDOID_config_B12 = AddToggleOption("Remove Punishing Items During Punishments", _SDGVP_config_RemovePunishment.GetValue() as Bool) ;
		; _SDOID_config_B13 = AddToggleOption("Harness Gag Instead of Strap Gag", _SDGVP_config_GagType.GetValue() as Bool) ;
		_SDOID_config_S8 = AddSliderOption("Min slavery level", _SDGVP_config_min_slavery_level.GetValue() as Float)
		_SDOID_config_S9 = AddSliderOption("Max slavery level", _SDGVP_config_max_slavery_level.GetValue() as Float)
		_SDOID_config_S10 = AddSliderOption("Slavery exposure cooldown multiplier", _SDGVP_config_slavery_level_mult.GetValue() as Float,"{1}")
		;###############################################################################################
		SetCursorPosition(1)
		AddHeaderOption("$SD_HEADER_P0_BODY") ;1 - 1
		_SDOID_config_B4 = AddToggleOption("$SD_OPTION_P0_USING_CBBE", _SDGVP_config_cbbe.GetValue() as Bool) ;3 - 2
		_SDOID_config_B7 = AddToggleOption("$SD_OPTION_P0_USE_CUSTOM_CLOTHING", _SDGVP_config_custom_cloths.GetValue() as Bool) ;5 - 3
		; _SDOID_config_B5 = AddToggleOption("$SD_OPTION_P0_USE_MALE_ERRECT_BODYSUIT", _SDGVP_config_maleflacid.GetValue() as Bool) ;7 - 4
		AddHeaderOption("$SD_HEADER_P0_ESCAPE") ;9 - 5
		_SDOID_config_S3 = AddSliderOption("$SD_SLIDER_P0_BYOUT_AMOUNT", _SDGVP_config_buyout.GetValue() as Float, "$SD_GOLD") ;11 - 6
		_SDOID_config_S4 = AddSliderOption("$SD_SLIDER_P0_ESCAPE_RADIUS", _SDGVP_config_escape_radius.GetValue() as Float, "$SD_UNITS") ;13 - 7
		_SDOID_config_S5 = AddSliderOption("$SD_SLIDER_P0_ESCAPE_TIMER", _SDGVP_config_escape_timer.GetValue() as Float, "$SD_SECONDS") ;15 - 8
		; _SDOID_config_S6 = AddSliderOption("$SD_SLIDER_P0_DAYS_TO_START_TASKS", _SDGVP_config_work_start.GetValue() as Float, "$SD_DAYS") ; 17 - 9
		_SDOID_config_S11 = AddSliderOption("Disposition threshold", _SDGVP_config_disposition_threshold.GetValue() as Float,"{1}")
		_SDOID_config_S6 = AddSliderOption("Min days to join", _SDGVP_config_join_days.GetValue() as Float, "$SD_DAYS") ; 17 - 9
		_SDOID_config_B9 = AddToggleOption("$SD_OPTION_P0_HARDCORE", _SDGVP_config_hardcore.GetValue() as Bool) ;19 - 10
		; AddHeaderOption("$SD_HEADER_P0_EFFECTS") ;21 - 11
		; _SDOID_config_S7 = AddSliderOption("$SD_SLIDER_P0_BLINDNESS_LEVEL", _SDGVP_config_blindnessLevel.GetValue() as Float, "$SD_PERCENT") ; 23 - 12

	; STATUS
	ElseIf ( a_page == Pages[1] )
		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption( "$SD_HEADER_P1_PRIMARY_QUESTS" )
		idx = 0
		While idx < _SDQP_quests_primary.Length
			bRunning = ( _SDQP_quests_primary[idx].IsRunning() || _SDQP_quests_primary[idx].IsStarting() )
			_SDBP_quests_primary_running[idx] = bRunning
			_SDOID_quests_p[idx] = AddToggleOption(_SDQP_quests_primary[idx].GetName(), bRunning, OPTION_FLAG_DISABLED)
			idx += 1
		EndWhile
		SetCursorPosition(1)
		AddHeaderOption( "$SD_HEADER_P1_SECONDARY_QUESTS" )
		idx = 0
		While idx < _SDQP_quests_secondary.Length
			bRunning = ( _SDQP_quests_secondary[idx].IsRunning() || _SDQP_quests_secondary[idx].IsStarting() )
			_SDBP_quests_secondary_running[idx] = bRunning
			_SDOID_quests_s[idx] = AddToggleOption(_SDQP_quests_secondary[idx].GetName(), bRunning, OPTION_FLAG_DISABLED)
			idx += 1
		EndWhile
		idx = 0
		While idx < _SDQP_quests_support.Length
			bRunning = _SDQP_quests_support[idx].IsRunning() || _SDQP_quests_support[idx].IsStarting()
			_SDBP_quests_support_running[idx] = bRunning
			idx += 1
		EndWhile

		If( _SDQP_quests_primary[3].IsRunning() || _SDQP_quests_primary[4].IsRunning() )
			i_T1_action = 0
		ElseIf( !_SDQP_quests_primary[0].IsRunning() && !_SDQP_quests_primary[1].IsRunning() )
			i_T1_action = 1
		ElseIf( _SDQP_quests_primary[0].IsRunning() && !_SDQP_quests_primary[1].IsRunning() )
			i_T1_action = 2
		ElseIf( _SDQP_quests_primary[0].IsRunning() && _SDQP_quests_primary[1].IsRunning() )
			i_T1_action = 3
		Else
			i_T1_action = 4
		EndIf

		SetCursorPosition( _SDQP_quests_primary.Length * 2 + 4)
		;AddHeaderOption( "$SD_CONCAT{" + _SDGVP_state_mcm.GetValueInt() as String + "}STATUS" )
		AddHeaderOption( "Update Status: " + _SDGVP_state_mcm.GetValueInt() as String + "" )
		If ( _SDGVP_state_mcm.GetValueInt() == 0 )
			_SDOID_config_T1 = AddTextOption(s_config_T1_text[i_T1_action], s_config_T1_value[i_T1_action], i_config_T1_flag[i_T1_action])
			AddToggleOption("$SD_TOGGLE_P1_IS_PLAYER_ENSLAVED", _SDGVP_enslaved.GetValue() as Bool, OPTION_FLAG_DISABLED)
			; _SDOID_config_B2 = AddToggleOption("$SD_TOGGLE_P1_IS_ARTIFACT_ENABLED", _SDGVP_config_lust.GetValue() as Bool, i_config_B2_flag[i_T1_action] )
			_SDOID_config_B2 = AddToggleOption("Start after A Night to remember", _SDGVP_config_lust.GetValue() as Bool )
			_SDOID_config_B14 = AddToggleOption("Start after first escape", _SDGVP_config_auto_start.GetValue() as Bool )
			If (_SDGVP_enslaved.GetValue() as Bool) || (_SDGVP_sprigganenslaved.GetValue() as Bool)
				_SDOID_config_B21 = AddToggleOption("SAFE WORD", False )
			Else
				AddToggleOption("SAFE WORD", _SDGVP_config_safeword.GetValue() as Bool, OPTION_FLAG_DISABLED )
			EndIf

			; ------ List slavery factions
			; // iterate list from first added to last added
			Actor kPlayer = Game.GetPlayer()
			Debug.Trace("[SD] Expire Slave Factions")

			int currentDaysPassed = Game.QueryStat("Days Passed")
			int valueCount = StorageUtil.FormListCount(kPlayer, "_SD_lSlaveFactions")
			int i = 0
			int daysJoined 
			Form slaveFaction 
			String sFactionName

			while(i < valueCount)
				slaveFaction = StorageUtil.FormListGet(kPlayer, "_SD_lSlaveFactions", i)
				If (slaveFaction!=None)
					daysJoined = currentDaysPassed - StorageUtil.GetIntValue( slaveFaction, "_SD_iDaysPassedJoinedFaction")
					sFactionName = slaveFaction.GetName()

					;	Debug.Trace("[SD]      Slave Faction[" + i + "] expired: " + slaveFaction.GetName() + " " + slaveFaction + " Days Since Joined: " + daysJoined )
					if ( (daysJoined > StorageUtil.GetIntValue( kPlayer, "_SD_iDaysMaxJoinedFaction") ) || (!kPlayer.IsInFaction( slaveFaction as Faction )) || (StringUtil.Find(sFactionName, "SexLab")!= -1)  || (StringUtil.Find(sFactionName, "SOS")!= -1)  || (StringUtil.Find(sFactionName, "Schlong")!= -1) || (StringUtil.Find(sFactionName, "Dialogue Disable")!= -1) )
						kPlayer.RemoveFromFaction( slaveFaction as Faction )
					else
						AddTextOption(" Faction[" + i + "] : " + slaveFaction.GetName() , OPTION_FLAG_DISABLED)
						AddTextOption("     Days Since Joined: " + daysJoined, "", OPTION_FLAG_DISABLED)
					
					Endif
				Endif


				i += 1
			endwhile
			; ------
						
			SetCursorPosition( _SDQP_quests_secondary.Length * 2 + 5)

			If ( i_T1_action > 1 && i_T1_action < 4 )
				_SDOID_quests_o_flag = OPTION_FLAG_NONE
			Else
				_SDOID_quests_o_flag = OPTION_FLAG_DISABLED
			EndIf

			AddHeaderOption("$SD_HEADER_P1_ENABLE_DISABLE")
			idx = 0
			While idx < _SDQP_quests_optional.Length
				bRunning = _SDQP_quests_optional[idx].IsRunning() || _SDQP_quests_optional[idx].IsStarting()
				_SDBP_quests_optional_running[idx] = bRunning
				_SDOID_quests_o[idx] = AddToggleOption(_SDQP_quests_optional[idx].GetName(), bRunning, _SDOID_quests_o_flag)
				idx += 1
			EndWhile

		Else
			AddTextOption("$SD_UPDATING_QUEST_MSG_LINE_1", "", OPTION_FLAG_DISABLED)
			AddTextOption("$SD_UPDATING_QUEST_MSG_LINE_2", "", OPTION_FLAG_DISABLED)
			AddTextOption("$SD_UPDATING_QUEST_MSG_LINE_3", "", OPTION_FLAG_DISABLED)
		EndIf

	; CONTROLS
	ElseIf ( a_page == Pages[2] )
		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption("$SD_HEADER_P2_KEYS")
		_SDOID_config_K1 = AddKeyMapOption("$SD_KEYMAP_P2_POSITION_RESET", config._SDUIP_keys[0])
		_SDOID_config_K2 = AddKeyMapOption("$SD_KEYMAP_P2_UNSTICK", config._SDUIP_keys[1])
		_SDOID_config_K3 = AddKeyMapOption("$SD_KEYMAP_P2_MOVE_UP", config._SDUIP_keys[2])
		; _SDOID_config_K4 = AddKeyMapOption("$SD_KEYMAP_P2_MOVE_CLOSER", config._SDUIP_keys[3], OPTION_FLAG_DISABLED)
		; _SDOID_config_K5 = AddKeyMapOption("$SD_KEYMAP_P2_MOVE_AWAY", config._SDUIP_keys[4], OPTION_FLAG_DISABLED)
		_SDOID_config_K6 = AddKeyMapOption("$SD_KEYMAP_P2_MOVE_DOWN", config._SDUIP_keys[5])
		_SDOID_config_K7 = AddKeyMapOption("$SD_KEYMAP_P2_SURRENDER", config._SDUIP_keys[6])

		SetCursorPosition(1) 
		AddHeaderOption("$SD_HEADER_P2_KEY_FUNCTIONS")
		AddTextOption("$SD_OPTION_P2_POSITION_RESET_EXPLAIN", "", OPTION_FLAG_DISABLED)
		AddTextOption("$SD_OPTION_P2_UNSTICK_EXPLAIN", "", OPTION_FLAG_DISABLED)
		; AddTextOption("$SD_OPTION_P2_UNSTICK_EXPLAIN_SHIFT", "", OPTION_FLAG_DISABLED)
		; AddTextOption("$SD_OPTION_P2_UNSTICK_EXPLAIN_ALT", "", OPTION_FLAG_DISABLED)
		; AddTextOption("$SD_OPTION_P2_MOVE_UP_EXPLAIN", "", OPTION_FLAG_DISABLED)
		; AddTextOption("$SD_OPTION_P2_MOVE_CLOSER_EXPLAIN", "", OPTION_FLAG_DISABLED)
		; AddTextOption("$SD_OPTION_P2_MOVE_AWAY_EXPLAIN", "", OPTION_FLAG_DISABLED)
		; AddTextOption("$SD_OPTION_P2_MOVE_DOWN_EXPLAIN", "", OPTION_FLAG_DISABLED)
		; AddTextOption("$SD_OPTION_P2_MOVE_DOWN_EXPLAIN_SHIFT", "", OPTION_FLAG_DISABLED)
		; AddTextOption("$SD_OPTION_P2_SURRENDER_EXPLAIN", "", OPTION_FLAG_DISABLED)
		AddTextOption("The surrender key gives you the option to surrender willingly to your opponent or pray to Sanguine for help. In all cases, pressing this key will apply some safety checks and get you unstuck if you cannot move.", "", OPTION_FLAG_DISABLED)

	; ADDONS
	ElseIf ( a_page == Pages[3] )
		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption("$SD_HEADER_P3_ADDONS")
		If ( _SDGVP_state_mcm.GetValueInt() == 0 )
			idx = 0
			While idx < _SDQP_quests_addon.Length
				; Only display Frostfall addon entry
				If (idx==2) && ( _SDQP_quests_addon[idx] != None  && requiredParentModInstalled(idx) )
					bRunning = _SDQP_quests_addon[idx].IsRunning() || _SDQP_quests_addon[idx].IsStarting()
					_SDOID_quests_a[idx] = AddToggleOption( _SDSP_quests_addon_name[idx], bRunning, OPTION_FLAG_NONE)
					If ( _SDGVP_quests_addon_subToggle[idx] != None && bRunning )
						_SDOID_quests_ast[idx] = AddToggleOption("> " + _SDGVP_quests_addon_subToggle_name[idx], _SDGVP_quests_addon_subToggle[idx].GetValue() as Bool)
					EndIf
				; Else
				; 	_SDOID_quests_a[idx] = AddToggleOption( _SDSP_quests_addon_name[idx], False, OPTION_FLAG_DISABLED)
				EndIf
				idx += 1
			EndWhile
		Else
			AddTextOption("$SD_OPTION_P3_UPDATING_MUST_EXIT", "", OPTION_FLAG_DISABLED)
		EndIf

		SetCursorPosition(1)
		AddHeaderOption("$SD_HEADER_P3_MODS")
		idx = 0
		While idx < _SDSP_support_mods_name.Length
			; Only display Frostfall addon entry
			If (idx==3) 
				AddToggleOption( _SDSP_support_mods_name[idx], _SDBP_support_mods_installed[idx], OPTION_FLAG_DISABLED)
			Endif
			idx += 1
		EndWhile

	; HELP
	ElseIf ( a_page == Pages[4] )
		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption("$SD_HEADER_P4_HOWTO")
		_SDOID_help_T1 = AddTextOption("$SD_TEXT_P4_START_HELP", "$SD_HELP", OPTION_FLAG_NONE)
		_SDOID_help_T2 = AddTextOption("$SD_TEXT_P4_STOP_HELP", "$SD_HELP", OPTION_FLAG_NONE)
		_SDOID_help_T3 = AddTextOption("$SD_TEXT_P4_GET_ENSLAVED_HELP", "$SD_HELP", OPTION_FLAG_NONE)
		_SDOID_help_T4 = AddTextOption("$SD_TEXT_P4_ESCAPE_HELP", "$SD_HELP", OPTION_FLAG_NONE)

		AddHeaderOption("$SD_HEADER_P4_QUESTS")
		_SDOID_help_T5 = AddTextOption("$SD_TEXT_P4_THUGS_HELP", "$SD_HELP", OPTION_FLAG_NONE)
		_SDOID_help_T6 = AddTextOption("$SD_TEXT_P4_SPRIGGAN_ARMOR_HELP", "$SD_HELP", OPTION_FLAG_NONE)
		_SDOID_help_T7 = AddTextOption("$SD_TEXT_P4_ENSLAVEMENT_COMPLETED_HELP", "$SD_HELP", OPTION_FLAG_NONE)

		AddHeaderOption("$SD_HEADER_P4_OTHER")
		_SDOID_help_T8 = AddTextOption("$SD_TEXT_P4_ARMOR_N_RACES_HELP", "$SD_HELP", OPTION_FLAG_NONE)

		; SetCursorPosition(1)
		; AddHeaderOption("$SD_HEADER_P4_VERIFIED_CONFLICTS")
		; AddTextOption("SPERG", "", OPTION_FLAG_DISABLED)
		; AddTextOption("PCEA - PC Exclusive Animation Path", "", OPTION_FLAG_DISABLED)
		; AddTextOption("WARZONES - Civil Unrest", "", OPTION_FLAG_DISABLED)
		; AddTextOption("Tundra Defence", "", OPTION_FLAG_DISABLED)
		; AddTextOption("Locational damage and more dynamic injuries", "", OPTION_FLAG_DISABLED)
		; AddTextOption("Duel - Combat Realism", "", OPTION_FLAG_DISABLED)
		; AddTextOption("SkyBoost and TES V Acceleration Layer", "", OPTION_FLAG_DISABLED)
		; AddTextOption("Animated Prostitution", "", OPTION_FLAG_DISABLED)
		; AddTextOption("Syynxs Perky", "", OPTION_FLAG_DISABLED)
	EndIf
endEvent

; @implements SKI_ConfigBase
event OnOptionHighlight(int a_option)
	{Called when highlighting an option}
	If ( a_option == _SDOID_config_T1 )
		SetInfoText("$_SDOID_config_T1")
	ElseIf ( a_option == _SDOID_config_T2 )
		SetInfoText("$_SDOID_config_T2")
	ElseIf ( a_option == _SDOID_config_B1 )
		SetInfoText("$_SDOID_config_B1")
	ElseIf ( a_option == _SDOID_config_B2 )
		; SetInfoText("$_SDOID_config_B2")
		SetInfoText("Check if you want to delay visits to Dreamworld until after 'A Night to Remember' (Level 14).")
	ElseIf ( a_option == _SDOID_config_B14)
		SetInfoText("Uncheck if you want to delay visits to Dreamworld indefinitely. If this is unchecked, the previous option will be ignored and you will have to sleep in front of Sanguine's shrine to start the Dreamworld aspect of the mod.")
	ElseIf ( a_option == _SDOID_config_B21 )
		SetInfoText("Emergency release from your current master - useful in case of friendly fire or static NPC.")
	ElseIf ( a_option == _SDOID_config_B3 )
		SetInfoText("$_SDOID_config_B3")
	ElseIf ( a_option == _SDOID_config_B4 )
		SetInfoText("$_SDOID_config_B4")
	ElseIf ( a_option == _SDOID_config_B5 )
		SetInfoText("$_SDOID_config_B5")
	ElseIf ( a_option == _SDOID_config_B6 )
		SetInfoText("$_SDOID_config_B6")
	ElseIf ( a_option == _SDOID_config_B7 )
		SetInfoText("$_SDOID_config_B7")
	ElseIf ( a_option == _SDOID_config_B8 )
		SetInfoText("$_SDOID_config_B8")
	ElseIf ( a_option == _SDOID_config_B9 )
		SetInfoText("$_SDOID_config_B9")
	;#################################################################################################
	ElseIf ( a_option == _SDOID_config_B10 )
		SetInfoText("Toggle this ON to kneel before your Master while wearing an armbinder. ")
	ElseIf ( a_option == _SDOID_config_B11 )
		SetInfoText("Toggle this ON to enable enslavement attempts from beasts (wolf, trols, draugr, etc). ")
	ElseIf ( a_option == _SDOID_config_B12 )
		SetInfoText("Toggle this ON to remove punishing items (i.e. belt) during punishments. ")
	ElseIf ( a_option == _SDOID_config_B13 )
		SetInfoText("Toggle this ON to equip harness gag instead of strap one. Make this selection before enslavement. ")
	ElseIf ( a_option == _SDOID_config_S8 )
		SetInfoText("Minimum value for slavery level (0 = defiant, 6 = total submissive). Should be lower than Max Slavery Level.")
	ElseIf ( a_option == _SDOID_config_S9 )
		SetInfoText("Maximum value for slavery level (0 = defiant, 6 = total submissive). Should be higher than Min Slavery Level.")
	ElseIf ( a_option == _SDOID_config_S10 )
		SetInfoText("Value multiplier to reduce (or increase) slavery exposure after each day of freedom. 0 removes slavery exposure after one night , 1.0 maintains slavery exposure at the same level, 2.0 increases slavery exposure over time (similar to withdrawal)")
	ElseIf ( a_option == _SDOID_config_S11 )
		SetInfoText("Overall disposition to be considered for slave to be released (or disposed of). Use this as an Enslavement Difficulty setting.")
	;#################################################################################################			
	ElseIf ( a_option == _SDOID_config_S1 )
		; SetInfoText("$_SDOID_config_S1")
		SetInfoText("Adds a chance of success to the Death Alternative quests defined for Spriggan infection by SD.")
	ElseIf ( a_option == _SDOID_config_S2 )
		; SetInfoText("$_SDOID_config_S2")
		SetInfoText("Adds a chance of success to the Death Alternative quests defined for enslavement by SD.")
	ElseIf ( a_option == _SDOID_config_S3 )
		SetInfoText("$_SDOID_config_S3")
	ElseIf ( a_option == _SDOID_config_S4 )
		SetInfoText( unitsToRealWorld( _SDGVP_config_escape_radius.GetValue() as Float ) )
	ElseIf ( a_option == _SDOID_config_S5 )
		SetInfoText("$_SDOID_config_S5")
	ElseIf ( a_option == _SDOID_config_S6 )
		SetInfoText( decimalDaysToString( _SDGVP_config_join_days.GetValue() as Float ) )
	ElseIf ( a_option == _SDOID_config_S7 )
		SetInfoText("$_SDOID_config_S7")
	ElseIf ( a_option == _SDOID_config_M1 )

	ElseIf ( _SDOID_quests_o.Find( a_option ) >= 0 )

	ElseIf ( _SDOID_quests_a.Find( a_option ) >= 0 )

	EndIf
endEvent

; @implements SKI_ConfigBase
event OnOptionSelect(int a_option)
	{Called when a non-interactive option has been selected}
	If ( a_option == _SDOID_config_T1 )
		_SDGVP_state_mcm.SetValue( i_T1_action )
	ElseIf ( a_option == _SDOID_config_T2 )
		_SDGVP_config_genderRestrictions.SetValue( ( _SDGVP_config_genderRestrictions.GetValueInt() + 1 ) % _SDSP_config_genderRestrictions.Length )
		StorageUtil.SetIntValue( Game.GetPlayer()  , "_SD_iGenderRestrictions",  _SDGVP_config_genderRestrictions.GetValueInt() )
		SetTextOptionValue(a_option, _SDSP_config_genderRestrictions[ _SDGVP_config_genderRestrictions.GetValueInt() ] as String )
	ElseIf ( a_option == _SDOID_help_T1 )
		ShowMessage("$_SDOID_help_T1_1" , False, "$SD_OK")
	ElseIf ( a_option == _SDOID_help_T2 )
		ShowMessage("$_SDOID_help_T2_1", False, "$SD_OK")
	ElseIf ( a_option == _SDOID_help_T3 )
		ShowMessage("$_SDOID_help_T3_1", False, "$SD_OK")
	ElseIf ( a_option == _SDOID_help_T4 )
		ShowMessage("$_SDOID_help_T4_1", False, "$SD_OK")
	ElseIf ( a_option == _SDOID_help_T5 )
		ShowMessage("$_SDOID_help_T5_1", False, "$SD_OK")
	ElseIf ( a_option == _SDOID_help_T6 )
		ShowMessage("$_SDOID_help_T6_1", False, "$SD_OK")
	ElseIf ( a_option == _SDOID_help_T7 )
		ShowMessage("$_SDOID_help_T7_1", False, "$SD_OK")
	ElseIf ( a_option == _SDOID_help_T8 )
		ShowMessage("$_SDOID_help_T8_1", False, "$SD_OK")
	ElseIf ( a_option == _SDOID_config_B1 )
		_SDGVP_config_essential.SetValue( Math.LogicalXor( 1, _SDGVP_config_essential.GetValueInt() ) )
		SetToggleOptionValue(a_option, _SDGVP_config_essential.GetValue() as Bool )
	ElseIf ( a_option == _SDOID_config_B2 )
		_SDGVP_config_lust.SetValue( Math.LogicalXor( 1, _SDGVP_config_lust.GetValueInt() ) )
		SetToggleOptionValue(a_option, _SDGVP_config_lust.GetValue() as Bool )
	ElseIf ( a_option == _SDOID_config_B14 )
		_SDGVP_config_auto_start.SetValue( Math.LogicalXor( 1, _SDGVP_config_auto_start.GetValueInt() ) )
		SetToggleOptionValue(a_option, _SDGVP_config_auto_start.GetValue() as Bool )
	ElseIf ( a_option == _SDOID_config_B21 )
		_SDGVP_config_safeword.SetValue(1) 
		Debug.MessageBox("Quit this menu to cancel your enslavement.")
	ElseIf ( a_option == _SDOID_config_B3 )
		_SDGVP_config_itemRemovalType.SetValue( Math.LogicalXor( 1, _SDGVP_config_itemRemovalType.GetValueInt() ) )
		SetToggleOptionValue(a_option, _SDGVP_config_itemRemovalType.GetValue() as Bool )
	ElseIf ( a_option == _SDOID_config_B4 )
		_SDGVP_config_cbbe.SetValue( Math.LogicalXor( 1, _SDGVP_config_cbbe.GetValueInt() ) )
		SetToggleOptionValue(a_option, _SDGVP_config_cbbe.GetValue() as Bool )
	ElseIf ( a_option == _SDOID_config_B5 )
		_SDGVP_config_maleflacid.SetValue( Math.LogicalXor( 1, _SDGVP_config_maleflacid.GetValueInt() ) )
		SetToggleOptionValue(a_option, _SDGVP_config_maleflacid.GetValue() as Bool )
	ElseIf ( a_option == _SDOID_config_B6 )
		_SDGVP_config_verboseMerits.SetValue( Math.LogicalXor( 1, _SDGVP_config_verboseMerits.GetValueInt() ) )
		SetToggleOptionValue(a_option, _SDGVP_config_verboseMerits.GetValue() as Bool )
	ElseIf ( a_option == _SDOID_config_B7 )
		_SDGVP_config_custom_cloths.SetValue( Math.LogicalXor( 1, _SDGVP_config_custom_cloths.GetValueInt() ) )
		SetToggleOptionValue(a_option, _SDGVP_config_custom_cloths.GetValue() as Bool )
		If ( _SDGVP_config_custom_cloths.GetValue() == 1 )
			ShowMessage("$_SDOID_config_B7_MSG" , False, "$SD_OK")
		EndIf
	ElseIf ( a_option == _SDOID_config_B8 )
		_SDGVP_config_enableTrainRun.SetValue( Math.LogicalXor( 1, _SDGVP_config_enableTrainRun.GetValueInt() ) )
		SetToggleOptionValue(a_option, _SDGVP_config_enableTrainRun.GetValue() as Bool )
	ElseIf ( a_option == _SDOID_config_B9 )
		_SDGVP_config_hardcore.SetValue( Math.LogicalXor( 1, _SDGVP_config_hardcore.GetValueInt() ) )
		SetToggleOptionValue(a_option, _SDGVP_config_hardcore.GetValue() as Bool )
		
	;#################################################################################################
	ElseIf ( a_option == _SDOID_config_B10 )
		_SDGVP_config_ArmBinderKnee.SetValue( Math.LogicalXor( 1, _SDGVP_config_ArmBinderKnee.GetValueInt() ) )
		SetToggleOptionValue(a_option, _SDGVP_config_ArmBinderKnee.GetValue() as Bool )
		;_SDGVP_config_SlaveOnKnees.SetValue(1)
	ElseIf ( a_option == _SDOID_config_B11 )
		_SDGVP_config_enable_beast_master.SetValue( Math.LogicalXor( 1, _SDGVP_config_enable_beast_master.GetValueInt() ) )
		SetToggleOptionValue(a_option, _SDGVP_config_enable_beast_master.GetValue() as Bool )
 		StorageUtil.SetIntValue(Game.GetPlayer(), "_SD_iEnableBeastMaster",  _SDGVP_config_enable_beast_master.GetValueInt() )

	ElseIf ( a_option == _SDOID_config_B12 )
		_SDGVP_config_RemovePunishment.SetValue( Math.LogicalXor( 1, _SDGVP_config_RemovePunishment.GetValueInt() ) )
		SetToggleOptionValue(a_option, _SDGVP_config_RemovePunishment.GetValue() as Bool )
	ElseIf ( a_option == _SDOID_config_B13 )
		_SDGVP_config_GagType.SetValue( Math.LogicalXor( 1, _SDGVP_config_GagType.GetValueInt() ) )
		SetToggleOptionValue(a_option, _SDGVP_config_GagType.GetValue() as Bool )

	;#################################################################################################
	ElseIf ( _SDOID_quests_o.Find( a_option ) >= 0 )
		idx = _SDOID_quests_o.Find( a_option )
		_SDBP_quests_optional_running[idx] = !_SDBP_quests_optional_running[idx]
		SetToggleOptionValue(a_option, _SDBP_quests_optional_running[idx] )
		_SDGVP_state_mcm.SetValue( 255 )
	ElseIf ( _SDOID_quests_a.Find( a_option ) >= 0 )
		idx = _SDOID_quests_a.Find( a_option )
		_SDBP_quests_addon_running[idx] = !_SDBP_quests_addon_running[idx]
		SetToggleOptionValue(a_option, _SDBP_quests_addon_running[idx] )
		_SDGVP_state_mcm.SetValue( 254 )
	ElseIf ( _SDOID_quests_ast.Find( a_option ) >= 0 )
		idx = _SDOID_quests_ast.Find( a_option )
		_SDGVP_quests_addon_subToggle[idx].SetValue( Math.LogicalXor( 1, _SDGVP_quests_addon_subToggle[idx].GetValueInt() ) )
		SetToggleOptionValue(a_option, _SDGVP_quests_addon_subToggle[idx].GetValue() as Bool )
	EndIf

	ForcePageReset()
endEvent

; @implements SKI_ConfigBase
event OnOptionDefault(int a_option)
	{Called when resetting an option to its default value}
	If ( a_option == _SDOID_config_B1 )
		_SDGVP_config_essential.SetValue( 1 )
		SetToggleOptionValue(a_option, _SDGVP_config_essential.GetValue() as Bool )
	ElseIf ( a_option == _SDOID_config_B2 )
		_SDGVP_config_lust.SetValue( 0 )
		SetToggleOptionValue(a_option, _SDGVP_config_lust.GetValue() as Bool )
	ElseIf ( a_option == _SDOID_config_B14 )
		_SDGVP_config_auto_start.SetValue( 1 )
		SetToggleOptionValue(a_option, _SDGVP_config_auto_start.GetValue() as Bool )
	ElseIf ( a_option == _SDOID_config_B3 )
		_SDGVP_config_itemRemovalType.SetValue( 0 )
		SetToggleOptionValue(a_option, _SDGVP_config_itemRemovalType.GetValue() as Bool )
	ElseIf ( a_option == _SDOID_config_S1 )
		; _SDGVP_config_healthMult.SetValue( _SDOID_config_S1_default )
		_SDGVP_config_healthMult.SetValue( 80 )
		SetSliderDialogStartValue( _SDGVP_config_healthMult.GetValue() as Float )
	ElseIf ( a_option == _SDOID_config_S2 )
		; _SDGVP_config_healthThreshold.SetValue( _SDOID_config_S2_default )
		_SDGVP_config_healthThreshold.SetValue( 70.0 )
		SetSliderDialogStartValue( _SDGVP_config_healthThreshold.GetValue() as Float )
	ElseIf ( a_option == _SDOID_config_S3 )
		_SDGVP_config_buyout.SetValue( _SDOID_config_S3_default )
		SetSliderDialogStartValue( _SDGVP_config_buyout.GetValue() as Float )
	ElseIf ( a_option == _SDOID_config_S4 )
		_SDGVP_config_escape_radius.SetValue( _SDOID_config_S4_default )
		SetSliderDialogStartValue( _SDGVP_config_escape_radius.GetValue() as Float )
	ElseIf ( a_option == _SDOID_config_S5 )
		_SDGVP_config_escape_timer.SetValue( _SDOID_config_S5_default )
		SetSliderDialogStartValue( _SDGVP_config_escape_timer.GetValue() as Float )
	ElseIf ( a_option == _SDOID_config_S6 )
		_SDGVP_config_join_days.SetValue( _SDOID_config_S6_default )
		SetSliderDialogStartValue( _SDGVP_config_join_days.GetValue() as Float )
	ElseIf ( a_option == _SDOID_config_T2 )
		_SDGVP_config_genderRestrictions.SetValue( 0 )
		SetTextOptionValue(a_option, _SDSP_config_genderRestrictions[ _SDGVP_config_genderRestrictions.GetValueInt() ] as String )
	EndIf
endEvent

; @implements SKI_ConfigBase
event OnOptionSliderOpen(int a_option)
	{Called when a slider option has been selected}
	If ( a_option == _SDOID_config_S1 )
;		SetSliderDialogStartValue( _SDGVP_config_healthMult.GetValue() as Float )
;		SetSliderDialogDefaultValue( _SDOID_config_S1_default )
;		SetSliderDialogRange( _SDOID_config_S1_min, _SDOID_config_S1_max )
;		SetSliderDialogInterval( _SDOID_config_S1_inc )
		SetSliderDialogStartValue( _SDGVP_config_healthMult.GetValue() as Float )
		SetSliderDialogDefaultValue( 80.0 )
		SetSliderDialogRange( 0.0, 100.0 )
		SetSliderDialogInterval( 5.0 )
	ElseIf ( a_option == _SDOID_config_S2 )
;		SetSliderDialogStartValue( _SDGVP_config_healthThreshold.GetValue() as Float )
;		SetSliderDialogDefaultValue( _SDOID_config_S2_default )
;		SetSliderDialogRange( _SDOID_config_S2_min, _SDOID_config_S2_max )
;		SetSliderDialogInterval( _SDOID_config_S2_inc )
		SetSliderDialogStartValue( _SDGVP_config_healthThreshold.GetValue() as Float )
		SetSliderDialogDefaultValue( 70.0 )
		SetSliderDialogRange( 0.0, 100.0 )
		SetSliderDialogInterval( 5.0 )
	ElseIf ( a_option == _SDOID_config_S3 )
		SetSliderDialogStartValue( _SDGVP_config_buyout.GetValue() as Float )
		SetSliderDialogDefaultValue( _SDOID_config_S3_default )
		SetSliderDialogRange( _SDOID_config_S3_min, _SDOID_config_S3_max )
		SetSliderDialogInterval( _SDOID_config_S3_inc )
	ElseIf ( a_option == _SDOID_config_S4 )
		SetSliderDialogStartValue( _SDGVP_config_escape_radius.GetValue() as Float )
		SetSliderDialogDefaultValue( _SDOID_config_S4_default )
		SetSliderDialogRange( _SDOID_config_S4_min, _SDOID_config_S4_max )
		SetSliderDialogInterval( _SDOID_config_S4_inc )
	ElseIf ( a_option == _SDOID_config_S5 )
		SetSliderDialogStartValue( _SDGVP_config_escape_timer.GetValue() as Float )
		SetSliderDialogDefaultValue( _SDOID_config_S5_default )
		SetSliderDialogRange( _SDOID_config_S5_min, _SDOID_config_S5_max )
		SetSliderDialogInterval( _SDOID_config_S5_inc )
	ElseIf ( a_option == _SDOID_config_S6 )
		SetSliderDialogStartValue( _SDGVP_config_join_days.GetValue() as Float )
		SetSliderDialogDefaultValue( _SDOID_config_S6_default )
		SetSliderDialogRange( _SDOID_config_S6_min, _SDOID_config_S6_max )
		SetSliderDialogInterval( _SDOID_config_S6_inc )
	ElseIf ( a_option == _SDOID_config_S7 )
		SetSliderDialogStartValue( _SDGVP_config_blindnessLevel.GetValue() as Float )
		SetSliderDialogDefaultValue( _SDOID_config_S7_default )
		SetSliderDialogRange( _SDOID_config_S7_min, _SDOID_config_S7_max )
		SetSliderDialogInterval( _SDOID_config_S7_inc )
	ElseIf ( a_option == _SDOID_config_S8 )
		SetSliderDialogStartValue( _SDGVP_config_min_slavery_level.GetValue() as Float )
		SetSliderDialogDefaultValue( _SDOID_config_S8_default )
		SetSliderDialogRange( _SDOID_config_S8_min, _SDOID_config_S8_max )
		SetSliderDialogInterval( _SDOID_config_S8_inc )
	ElseIf ( a_option == _SDOID_config_S9 )
		SetSliderDialogStartValue( _SDGVP_config_max_slavery_level.GetValue() as Float )
		SetSliderDialogDefaultValue( _SDOID_config_S9_default )
		SetSliderDialogRange( _SDOID_config_S9_min, _SDOID_config_S9_max )
		SetSliderDialogInterval( _SDOID_config_S9_inc )
	ElseIf ( a_option == _SDOID_config_S10 )
		SetSliderDialogStartValue( _SDGVP_config_slavery_level_mult.GetValue() as Float )
		SetSliderDialogDefaultValue( _SDOID_config_S10_default )
		SetSliderDialogRange( _SDOID_config_S10_min, _SDOID_config_S10_max )
		SetSliderDialogInterval( _SDOID_config_S10_inc )
	ElseIf ( a_option == _SDOID_config_S11 )
		SetSliderDialogStartValue( _SDGVP_config_disposition_threshold.GetValue() as Float )
		SetSliderDialogDefaultValue( _SDOID_config_S11_default )
		SetSliderDialogRange( _SDOID_config_S11_min, _SDOID_config_S11_max )
		SetSliderDialogInterval( _SDOID_config_S11_inc )
	EndIf
endEvent

; @implements SKI_ConfigBase
event OnOptionSliderAccept(int a_option, float a_value)
	{Called when a new slider value has been accepted}
	If ( a_option == _SDOID_config_S1 )
		_SDGVP_config_healthMult.SetValue( a_value )
		; SetSliderOptionValue(_SDOID_config_S1, a_value, "$SD_HEALTH")
		SetSliderOptionValue(_SDOID_config_S1, a_value, "{1} %")
	ElseIf ( a_option == _SDOID_config_S2 )
		_SDGVP_config_healthThreshold.SetValue( a_value )
		; SetSliderOptionValue(_SDOID_config_S2, a_value, "$SD_PERCENT_HEALTH")
		SetSliderOptionValue(_SDOID_config_S2, a_value, "{1} %")
	ElseIf ( a_option == _SDOID_config_S3 )
		_SDGVP_config_buyout.SetValue( a_value )
		SetSliderOptionValue(_SDOID_config_S3, a_value, "$SD_GOLD")
	ElseIf ( a_option == _SDOID_config_S4 )
		_SDGVP_config_escape_radius.SetValue( a_value )
		SetSliderOptionValue(_SDOID_config_S4, a_value, "$SD_UNITS")
	ElseIf ( a_option == _SDOID_config_S5 )
		_SDGVP_config_escape_timer.SetValue( a_value )
		SetSliderOptionValue(_SDOID_config_S5, a_value, "$SD_SECONDS")
	ElseIf ( a_option == _SDOID_config_S6 )
		_SDGVP_config_join_days.SetValue( a_value )
		SetSliderOptionValue(_SDOID_config_S6, a_value, "$SD_DAYS")
	ElseIf ( a_option == _SDOID_config_S7 )
		_SDGVP_config_blindnessLevel.SetValue( a_value )
		SetSliderOptionValue(_SDOID_config_S7, a_value, "$SD_PERCENT")
	ElseIf ( a_option == _SDOID_config_S8 )
		if ( a_value > (_SDGVP_config_max_slavery_level.GetValue( ) as Float) )
			a_value =  (_SDGVP_config_max_slavery_level.GetValue( ) as Float) 
		EndIf
		_SDGVP_config_min_slavery_level.SetValue( a_value )
		SetSliderOptionValue(_SDOID_config_S8, a_value)
	ElseIf ( a_option == _SDOID_config_S9 )
		if ( a_value < (_SDGVP_config_min_slavery_level.GetValue( ) as Float) )
			a_value =  (_SDGVP_config_min_slavery_level.GetValue( ) as Float) 
		EndIf
		_SDGVP_config_max_slavery_level.SetValue( a_value )
		SetSliderOptionValue(_SDOID_config_S9, a_value)
	ElseIf ( a_option == _SDOID_config_S10 )
		_SDGVP_config_slavery_level_mult.SetValue( a_value )
		SetSliderOptionValue(_SDOID_config_S10, a_value,"{1}")
	ElseIf ( a_option == _SDOID_config_S11 )
		_SDGVP_config_disposition_threshold.SetValue( a_value )
		SetSliderOptionValue(_SDOID_config_S11, a_value,"{1}")
	EndIf
endEvent


; @implements SKI_ConfigBase
event OnOptionMenuOpen(int a_option)
	{Called when a menu option has been selected}

	If ( a_option == _SDOID_config_M1 )

	EndIf
endEvent

; @implements SKI_ConfigBase
event OnOptionMenuAccept(int a_option, int a_index)
	{Called when a menu entry has been accepted}

	If ( a_option == _SDOID_config_M1 )

	EndIf
endEvent

; @implements SKI_ConfigBase
event OnOptionColorOpen(int a_option)
	{Called when a color option has been selected}

	; ...
endEvent

; @implements SKI_ConfigBase
event OnOptionColorAccept(int a_option, int a_color)
	{Called when a new color has been accepted}

	; ...
endEvent

; @implements SKI_ConfigBase
event OnOptionKeyMapChange(int a_option, int a_keyCode, string a_conflictControl, string a_conflictName)
	{Called when a key has been remapped}
	Bool continue = true

	If ( a_conflictControl != "" )
		String msg
		String[] replacements = New String[2]
		replacements[0] = a_conflictControl
		If (a_conflictName != "")
			replacements[1] = a_conflictName
			msg = sPrintF( "This key is already mapped to '%s' (%s). Are you sure you want to continue?", replacements )
			;msg = "$SD_CONCAT_KEYMAP{" + a_conflictControl as String  + "}_CONFLICT{" + a_conflictName as String  + "}_CONTUNUE"
		Else
			msg = sPrintF( "This key is already mapped to '%s'. Are you sure you want to continue?", replacements )
			;msg = "$SD_CONCAT_KEYMAP{" + a_conflictControl as String + "}_CONTUNUE"
		EndIf

		continue = ShowMessage(msg, True, "$SD_YES", "$SD_NO")
	EndIf

	If ( continue )
		If ( a_option == _SDOID_config_K1 )
			config._SDUIP_keys[0] = a_keyCode
		ElseIf ( a_option == _SDOID_config_K2 )
			config._SDUIP_keys[1] = a_keyCode
		ElseIf ( a_option == _SDOID_config_K3 )
			config._SDUIP_keys[2] = a_keyCode
		ElseIf ( a_option == _SDOID_config_K4 )
			config._SDUIP_keys[3] = a_keyCode
		ElseIf ( a_option == _SDOID_config_K5 )
			config._SDUIP_keys[4] = a_keyCode
		ElseIf ( a_option == _SDOID_config_K6 )
			config._SDUIP_keys[5] = a_keyCode
		ElseIf ( a_option == _SDOID_config_K7 )
			config._SDUIP_keys[6] = a_keyCode
		EndIf
		SetKeymapOptionValue(a_option, a_keyCode)
	EndIf
endEvent

