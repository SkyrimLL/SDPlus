Scriptname sd_addon_mcm extends SKI_ConfigBase  


;quick reference - to add new races
;duplicate the three race OIDs - int var, bool property, and int optionflags
;duplicate 	if (StorageUtil.FormListFind( none, "_SD_lRaceMastersList", ##########) >=0)		where wildcards are race property name
;add toggleoption
;add onoptionselect
;add onoptionhighlight
;add the race to the racesadd() function
;add the race and faction properties


int versionNum = 6

int function GetVersion()
    return versionNum
endFunction
;------------------------------------------------------------------------------------------------------------------------------------------Item list OIDs
int flags  ;for disabling gear options if there is no current master

string[] ItemListCollar
int ItemListCollarOID
int ItemListCollarIndex = 0

string[] ItemListArmbinder
int ItemListArmbinderOID
int ItemListArmbinderIndex = 0

string[] ItemListLegs
int ItemListLegsOID
int ItemListLegsIndex = 0

string[] ItemListGag
int ItemListGagOID
int ItemListGagIndex = 0

string[] ItemListBelt
int ItemListBeltOID
int ItemListBeltIndex = 0

string[] ItemListPlugVaginal
int ItemListPlugVaginalOID
int ItemListPlugVaginalIndex = 0

string[] ItemListPlugAnal
int ItemListPlugAnalOID
int ItemListPlugAnalIndex = 0

string[] ItemListBlindfold
int ItemListBlindfoldOID
int ItemListBlindfoldIndex = 0

string[] ItemListPlayerCollar
int ItemListPlayerCollarOID
int ItemListPlayerCollarIndex = 0

string[] ItemListPlayerArmbinder
int ItemListPlayerArmbinderOID
int ItemListPlayerArmbinderIndex = 0

string[] ItemListPlayerLegs
int ItemListPlayerLegsOID
int ItemListPlayerLegsIndex = 0

string[] ItemListPlayerGag
int ItemListPlayerGagOID
int ItemListPlayerGagIndex = 0

string[] ItemListPlayerBelt
int ItemListPlayerBeltOID
int ItemListPlayerBeltIndex = 0

string[] ItemListPlayerPlugVaginal
int ItemListPlayerPlugVaginalOID
int ItemListPlayerPlugVaginalIndex = 0

string[] ItemListPlayerPlugAnal
int ItemListPlayerPlugAnalOID
int ItemListPlayerPlugAnalIndex = 0

string[] ItemListPlayerBlindfold
int ItemListPlayerBlindfoldOID
int ItemListPlayerBlindfoldIndex = 0

;------------------------------------------------------------------------------------------------------------------------------------------Other OIDs
;race oids
int var_race_riekling
int var_race_rieklingthirsk
int var_race_rieklingmounted
int var_race_snowelf
int var_race_gargoyle
int var_race_gargoyleboss
int var_race_gargoylegreen
int var_race_lurker
int var_race_netch
int var_race_netchcalf
;toggle states
bool property race_riekling = false auto
bool property race_rieklingthirsk  = false auto
bool property race_rieklingmounted = false auto
bool property race_snowelf = false auto
bool property race_gargoyle = false auto
bool property race_gargoyleboss = false auto
bool property race_gargoylegreen = false auto
bool property race_lurker = false auto
bool property race_netch = false auto
bool property race_netchcalf = false auto
int racesoptionflagsriekling ;for disabling races after selected
int racesoptionflagsrieklingmounted ;for disabling races after selected
int racesoptionflagsrieklingthirsk ;for disabling races after selected
int racesoptionflagssnowelf ;for disabling races after selected
int racesoptionflagsgargoyle ;for disabling races after selected
int racesoptionflagsgargoyleboss ;for disabling races after selected
int racesoptionflagsgargoylegreen ;for disabling races after selected
int racesoptionflagslurker ;for disabling races after selected
int racesoptionflagsnetch ;for disabling races after selected
int racesoptionflagsnetchcalf ;for disabling races after selected


;------------------------------------------------------------------------------------------------------------------------------------------Init
event OnConfigInit()
	AddItemLists()
	AddItemListPlayers()

	Pages = new string[2]
	Pages[0] = "Device settings"
	Pages[1] = "Races added"	
endevent

event OnVersionUpdate(int a_version)
	if (a_version >= versionNum && CurrentVersion < versionNum)
		Debug.Notification("SD Addons - installing version " + a_version)
		Debug.Trace("SD Addons - installing version " + a_version)
		OnConfigInit()
	endIf
endEvent
    
;------------------------------------------------------------------------------------------------------------------------------------------Pages and settings
event OnPageReset(string Page)
	SetCursorFillMode(TOP_TO_BOTTOM)
	If (StorageUtil.GetIntValue(Game.GetPlayer(), "_SD_iEnslaved") == 0)
		flags = OPTION_FLAG_DISABLED
	else
		flags = OPTION_FLAG_NONE
	endif
	if (StorageUtil.FormListFind( none, "_SD_lRaceMastersList", dlc2rieklingrace) >=0)
		SetOptionFlags(var_race_riekling, OPTION_FLAG_DISABLED)		
;		racesoptionflagsriekling = OPTION_FLAG_DISABLED
		endif
	if (StorageUtil.FormListFind( none, "_SD_lRaceMastersList", dlc2mountedrieklingrace) >=0)
		SetOptionFlags(var_race_rieklingmounted, OPTION_FLAG_DISABLED)
;		racesoptionflagsrieklingmounted = OPTION_FLAG_DISABLED		
		endif
	if (StorageUtil.FormListFind( none, "_SD_lRaceMastersList", dlc2thirskrieklingrace) >=0)
		SetOptionFlags(var_race_rieklingthirsk, OPTION_FLAG_DISABLED)
;		racesoptionflagsrieklingthirsk = OPTION_FLAG_DISABLED
		endif
	if (StorageUtil.FormListFind( none, "_SD_lRaceMastersList", snowelfrace) >=0)
		SetOptionFlags(var_race_snowelf, OPTION_FLAG_DISABLED)
;		racesoptionflagssnowelf = OPTION_FLAG_DISABLED
		endif
	if (StorageUtil.FormListFind( none, "_SD_lRaceMastersList", dlc1gargoylerace) >=0)
		SetOptionFlags(var_race_gargoyle, OPTION_FLAG_DISABLED)
;		racesoptionflagsgargoyle = OPTION_FLAG_DISABLED
		endif
	if (StorageUtil.FormListFind( none, "_SD_lRaceMastersList", dlc1gargoylevariantbossrace) >=0)
		SetOptionFlags(var_race_gargoyleboss, OPTION_FLAG_DISABLED)
;		racesoptionflagsgargoyleboss = OPTION_FLAG_DISABLED
		endif
	if (StorageUtil.FormListFind( none, "_SD_lRaceMastersList", dlc1gargoylevariantgreenrace) >=0)
		SetOptionFlags(var_race_gargoylegreen, OPTION_FLAG_DISABLED)
;		racesoptionflagsgargoylegreen = OPTION_FLAG_DISABLED
		endif
	if (StorageUtil.FormListFind( none, "_SD_lRaceMastersList", dlc2lurkerrace) >=0)
		SetOptionFlags(var_race_lurker, OPTION_FLAG_DISABLED)
;		racesoptionflagslurker = OPTION_FLAG_DISABLED
		endif
	if (StorageUtil.FormListFind( none, "_SD_lRaceMastersList", dlc2netchrace) >=0)
		SetOptionFlags(var_race_netch, OPTION_FLAG_DISABLED)
;		racesoptionflagsnetch = OPTION_FLAG_DISABLED
		endif
	if (StorageUtil.FormListFind( none, "_SD_lRaceMastersList", dlc2netchcalfrace) >=0)
		SetOptionFlags(var_race_netchcalf, OPTION_FLAG_DISABLED)
;		racesoptionflagsnetchcalf = OPTION_FLAG_DISABLED
		endif
	
	if page == ""
		LoadCustomContent("coco/sdaddon.dds")
		SetTitleText("SD Addons")
		return
	Else
		UnloadCustomContent()
	EndIf

	if page == "Device settings"
		If (StorageUtil.GetIntValue(Game.GetPlayer(), "_SD_iEnslaved") == 0)
			AddHeaderOption("WARNING: YOU ARE NOT CURRENTLY ENSLAVED")
		endif
		AddEmptyOption()
		AddHeaderOption("Master Gear Preference")
		ItemListCollarOID = AddMenuOption("Collar Style", ItemListCollar[itemListCollarIndex], flags)
		ItemListArmbinderOID = AddMenuOption("Armbinder Style", ItemListArmbinder[itemListArmbinderIndex], flags)
		ItemListLegsOID = AddMenuOption("Leg Cuff Style", ItemListLegs[itemListLegsIndex], flags)
		ItemListGagOID = AddMenuOption("Gag Style", ItemListGag[itemListGagIndex], flags)
		ItemListBeltOID = AddMenuOption("Belt Style", ItemListBelt[itemListBeltIndex], flags)
		ItemListPlugVaginalOID = AddMenuOption("Vaginal Plug Style", ItemListPlugVaginal[itemListPlugVaginalIndex], flags)
		ItemListPlugAnalOID = AddMenuOption("Anal Plug Style", ItemListPlugAnal[itemListPlugAnalIndex], flags)
		ItemListBlindfoldOID = AddMenuOption("Blindfold Style", ItemListBlindfold[itemListBlindfoldIndex], flags)

		SetCursorPosition(1)
		AddEmptyOption()
		AddHeaderOption("Player Gear Preference")
		ItemListPlayerCollarOID = AddMenuOption("Collar Style", ItemListPlayerCollar[ItemListPlayerCollarIndex])
		ItemListPlayerArmbinderOID = AddMenuOption("Armbinder Style", ItemListPlayerArmbinder[ItemListPlayerArmbinderIndex])
		ItemListPlayerLegsOID = AddMenuOption("Leg Cuff Style", ItemListPlayerLegs[ItemListPlayerLegsIndex])
		ItemListPlayerGagOID = AddMenuOption("Gag Style", ItemListPlayerGag[ItemListPlayerGagIndex])
		ItemListPlayerBeltOID = AddMenuOption("Belt Style", ItemListPlayerBelt[ItemListPlayerBeltIndex])
		ItemListPlayerPlugVaginalOID = AddMenuOption("Vaginal Plug Style", ItemListPlayerPlugVaginal[ItemListPlayerPlugVaginalIndex])
		ItemListPlayerPlugAnalOID = AddMenuOption("Anal Plug Style", ItemListPlayerPlugAnal[ItemListPlayerPlugAnalIndex])
		ItemListPlayerBlindfoldOID = AddMenuOption("Blindfold Style", ItemListPlayerBlindfold[ItemListPlayerBlindfoldIndex])
		
	elseif page == "Races added"
		var_race_riekling = AddToggleOption(" Riekling", race_riekling, racesoptionflagsriekling)
		var_race_rieklingthirsk = AddToggleOption(" Mounted Riekling", race_rieklingthirsk, racesoptionflagsrieklingmounted)
		var_race_rieklingmounted = AddToggleOption(" Thirsk Riekling", race_rieklingmounted, racesoptionflagsrieklingthirsk)
		var_race_snowelf = AddToggleOption(" Snow Elf", race_snowelf, racesoptionflagssnowelf)
		var_race_gargoyle = AddToggleOption(" Gargoyle", race_gargoyle, racesoptionflagsgargoyle)
		var_race_gargoyleboss = AddToggleOption(" Gargoyle Boss", race_gargoyleboss, racesoptionflagsgargoyleboss)
		var_race_gargoylegreen = AddToggleOption(" Green Gargoyle", race_gargoylegreen, racesoptionflagsgargoylegreen)
		var_race_lurker = AddToggleOption(" Lurker", race_lurker, racesoptionflagslurker)
		var_race_netch = AddToggleOption(" Netch", race_netch, racesoptionflagsnetch)
		var_race_netchcalf = AddToggleOption(" Netch Calf", race_netchcalf, racesoptionflagsnetchcalf)
		
	endif		;end pages if/elif
endEvent	;end pages

;------------------------------------------------------------------------------------------------------------------------------------------Events: Options creation
;item lists menus
event OnOptionMenuOpen(int option)
	if (option == itemListCollarOID)
		SetMenuDialogOptions(itemListCollar)
		SetMenuDialogStartIndex(itemListCollarIndex)
		SetMenuDialogDefaultIndex(0)
	elseif (option == itemListArmbinderOID)
		SetMenuDialogOptions(itemListArmbinder)
		SetMenuDialogStartIndex(itemListArmbinderIndex)
		SetMenuDialogDefaultIndex(0)
	elseif (option == itemListLegsOID)
		SetMenuDialogOptions(itemListLegs)
		SetMenuDialogStartIndex(itemListLegsIndex)
		SetMenuDialogDefaultIndex(0)
	elseif (option == itemListGagOID)
		SetMenuDialogOptions(itemListGag)
		SetMenuDialogStartIndex(itemListGagIndex)
		SetMenuDialogDefaultIndex(0)
	elseif (option == itemListBeltOID)
		SetMenuDialogOptions(itemListBelt)
		SetMenuDialogStartIndex(itemListBeltIndex)
		SetMenuDialogDefaultIndex(0)
	elseif (option == itemListPlugVaginalOID)
		SetMenuDialogOptions(itemListPlugVaginal)
		SetMenuDialogStartIndex(itemListPlugVaginalIndex)
		SetMenuDialogDefaultIndex(0)
	elseif (option == itemListPlugAnalOID)
		SetMenuDialogOptions(itemListPlugAnal)
		SetMenuDialogStartIndex(itemListPlugAnalIndex)
		SetMenuDialogDefaultIndex(0)
	elseif (option == itemListBlindfoldOID)
		SetMenuDialogOptions(itemListBlindfold)
		SetMenuDialogStartIndex(itemListBlindfoldIndex)
		SetMenuDialogDefaultIndex(0)
	elseif (option == ItemListPlayerCollarOID)
		SetMenuDialogOptions(ItemListPlayerCollar)
		SetMenuDialogStartIndex(ItemListPlayerCollarIndex)
		SetMenuDialogDefaultIndex(0)
	elseif (option == ItemListPlayerArmbinderOID)
		SetMenuDialogOptions(ItemListPlayerArmbinder)
		SetMenuDialogStartIndex(ItemListPlayerArmbinderIndex)
		SetMenuDialogDefaultIndex(0)
	elseif (option == ItemListPlayerLegsOID)
		SetMenuDialogOptions(ItemListPlayerLegs)
		SetMenuDialogStartIndex(ItemListPlayerLegsIndex)
		SetMenuDialogDefaultIndex(0)
	elseif (option == ItemListPlayerGagOID)
		SetMenuDialogOptions(ItemListPlayerGag)
		SetMenuDialogStartIndex(ItemListPlayerGagIndex)
		SetMenuDialogDefaultIndex(0)
	elseif (option == ItemListPlayerBeltOID)
		SetMenuDialogOptions(ItemListPlayerBelt)
		SetMenuDialogStartIndex(ItemListPlayerBeltIndex)
		SetMenuDialogDefaultIndex(0)
	elseif (option == ItemListPlayerPlugVaginalOID)
		SetMenuDialogOptions(ItemListPlayerPlugVaginal)
		SetMenuDialogStartIndex(ItemListPlayerPlugVaginalIndex)
		SetMenuDialogDefaultIndex(0)
	elseif (option == ItemListPlayerPlugAnalOID)
		SetMenuDialogOptions(ItemListPlayerPlugAnal)
		SetMenuDialogStartIndex(ItemListPlayerPlugAnalIndex)
		SetMenuDialogDefaultIndex(0)
	elseif (option == ItemListPlayerBlindfoldOID)
		SetMenuDialogOptions(ItemListPlayerBlindfold)
		SetMenuDialogStartIndex(ItemListPlayerBlindfoldIndex)
		SetMenuDialogDefaultIndex(0)
		
	endif
endevent

;race toggles
event OnOptionSelect(int option)
	if (option == var_race_riekling)
		if race_riekling == true
			race_riekling = false
			debug.trace("SD Addons - Disabling race")
			StorageUtil.SetIntValue(dlc2rieklingrace, "_SD_iSlaveryRace", -1)
			SetToggleOptionValue(var_race_riekling, race_riekling)
		elseif race_riekling == false
			race_riekling = true
			RacesAdd(1)
			SetToggleOptionValue(var_race_riekling, race_riekling)
		endif
	elseif (option == var_race_rieklingthirsk)
		if race_rieklingthirsk == true
			race_rieklingthirsk = false
			debug.trace("SD Addons - Disabling race")
			StorageUtil.SetIntValue(dlc2thirskrieklingrace, "_SD_iSlaveryRace", -1)
			SetToggleOptionValue(var_race_rieklingthirsk, race_rieklingthirsk)
		elseif race_rieklingthirsk == false
			race_rieklingthirsk = true
			RacesAdd(3)			;oops, backwards
			SetToggleOptionValue(var_race_rieklingthirsk, race_rieklingthirsk)
		endif
	elseif (option == var_race_rieklingmounted)
		if race_rieklingmounted == true
			race_rieklingmounted = false
			debug.trace("SD Addons - Disabling race")
			StorageUtil.SetIntValue(dlc2mountedrieklingrace, "_SD_iSlaveryRace", -1)
			SetToggleOptionValue(var_race_rieklingmounted, race_rieklingmounted)
		elseif race_rieklingmounted == false
			race_rieklingmounted = true
			RacesAdd(2)			;oops, backwards
			SetToggleOptionValue(var_race_rieklingmounted, race_rieklingmounted)
		endif
	elseif (option == var_race_snowelf)
		if race_snowelf == true
			race_snowelf = false
			debug.trace("SD Addons - Disabling race")
			StorageUtil.SetIntValue(snowelfrace, "_SD_iSlaveryRace", -1)
			SetToggleOptionValue(var_race_snowelf, race_snowelf)
		elseif race_snowelf == false
			race_snowelf = true
			RacesAdd(4)
			SetToggleOptionValue(var_race_snowelf, race_snowelf)
		endif
	elseif (option == var_race_gargoyle)
		if race_gargoyle == true
			race_gargoyle = false
			debug.trace("SD Addons - Disabling race")
			StorageUtil.SetIntValue(dlc1gargoylerace, "_SD_iSlaveryRace", -1)
			SetToggleOptionValue(var_race_gargoyle, race_gargoyle)
		elseif race_gargoyle == false
			race_gargoyle = true
			RacesAdd(5)
			SetToggleOptionValue(var_race_gargoyle, race_gargoyle)
		endif
	elseif (option == var_race_gargoyleboss)
		if race_gargoyleboss == true
			race_gargoyleboss = false
			debug.trace("SD Addons - Disabling race")
			StorageUtil.SetIntValue(dlc1gargoylevariantbossrace, "_SD_iSlaveryRace", -1)
			SetToggleOptionValue(var_race_gargoyleboss, race_gargoyleboss)
		elseif race_gargoyleboss == false
			race_gargoyleboss = true
			RacesAdd(6)
			SetToggleOptionValue(var_race_gargoyleboss, race_gargoyleboss)
		endif
	elseif (option == var_race_gargoylegreen)
		if race_gargoylegreen == true
			race_gargoylegreen = false
			debug.trace("SD Addons - Disabling race")
			StorageUtil.SetIntValue(dlc1gargoylevariantgreenrace, "_SD_iSlaveryRace", -1)
			SetToggleOptionValue(var_race_gargoylegreen, race_gargoylegreen)
		elseif race_gargoylegreen == false
			race_gargoylegreen = true
			RacesAdd(7)
			SetToggleOptionValue(var_race_gargoylegreen, race_gargoylegreen)
		endif
	elseif (option == var_race_lurker)
		if race_lurker == true
			race_lurker = false
			debug.trace("SD Addons - Disabling race")
			StorageUtil.SetIntValue(dlc2lurkerrace, "_SD_iSlaveryRace", -1)
			SetToggleOptionValue(var_race_lurker, race_lurker)
		elseif race_lurker == false
			race_lurker = true
			RacesAdd(8)
			SetToggleOptionValue(var_race_lurker, race_lurker)
		endif
	elseif (option == var_race_netch)
		if race_netch == true
			race_netch = false
			debug.trace("SD Addons - Disabling race")
			StorageUtil.SetIntValue(dlc2netchrace, "_SD_iSlaveryRace", -1)
			SetToggleOptionValue(var_race_netch, race_netch)
		elseif race_netch == false
			race_netch = true
			RacesAdd(9)
			SetToggleOptionValue(var_race_netch, race_netch)
		endif
	elseif (option == var_race_netchcalf)
		if race_netchcalf == true
			race_netchcalf = false
			debug.trace("SD Addons - Disabling race")
			StorageUtil.SetIntValue(dlc2netchcalfrace, "_SD_iSlaveryRace", -1)
			SetToggleOptionValue(var_race_netchcalf, race_netchcalf)
		elseif race_netchcalf == false
			race_netchcalf = true
			RacesAdd(10)
			SetToggleOptionValue(var_race_netchcalf, race_netchcalf)
		endif	
		
	endif
endevent

;------------------------------------------------------------------------------------------------------------------------------------------Events: On Accept
event OnOptionMenuAccept(int option, int index)
	if (option == ItemListCollarOID)
		itemListCollarIndex = index
		SetMenuOptionValue(ItemListCollarOID, ItemListCollar[ItemListCollarIndex])
		SetEquipment("Collar", ItemListCollar[ItemListCollarIndex])
	elseif (option == ItemListArmbinderOID)
		itemListArmbinderIndex = index
		SetMenuOptionValue(ItemListArmbinderOID, ItemListArmbinder[ItemListArmbinderIndex])
		SetEquipment("Armbinders", ItemListArmbinder[ItemListArmbinderIndex])
	elseif (option == ItemListLegsOID)
		itemListLegsIndex = index
		SetMenuOptionValue(ItemListLegsOID, ItemListLegs[ItemListLegsIndex])
		SetEquipment("LegCuffs", ItemListLegs[ItemListLegsIndex])
	elseif (option == ItemListGagOID)
		itemListGagIndex = index
		SetMenuOptionValue(ItemListGagOID, ItemListGag[ItemListGagIndex])
		SetEquipment("Gag", ItemListGag[ItemListGagIndex])
	elseif (option == ItemListBeltOID)
		itemListBeltIndex = index
		SetMenuOptionValue(ItemListBeltOID, ItemListBelt[ItemListBeltIndex])
		SetEquipment("Belt", ItemListBelt[ItemListBeltIndex])
	elseif (option == ItemListPlugVaginalOID)
		itemListPlugVaginalIndex = index
		SetMenuOptionValue(ItemListPlugVaginalOID, ItemListPlugVaginal[ItemListPlugVaginalIndex])
		SetEquipment("PlugVaginal", ItemListPlugVaginal[ItemListPlugVaginalIndex])
	elseif (option == ItemListPlugAnalOID)
		itemListPlugAnalIndex = index
		SetMenuOptionValue(ItemListPlugAnalOID, ItemListPlugAnal[ItemListPlugAnalIndex])
		SetEquipment("PlugAnal", ItemListPlugAnal[ItemListPlugAnalIndex])
	elseif (option == ItemListBlindfoldOID)
		itemListBlindfoldIndex = index
		SetMenuOptionValue(ItemListBlindfoldOID, ItemListBlindfold[ItemListBlindfoldIndex])
		SetEquipment("Blindfold", ItemListBlindfold[ItemListBlindfoldIndex])
	elseif (option == ItemListPlayerCollarOID)
		ItemListPlayerCollarIndex = index
		SetMenuOptionValue(ItemListPlayerCollarOID, ItemListPlayerCollar[ItemListPlayerCollarIndex])
		SetEquipment("Collar", ItemListPlayerCollar[ItemListPlayerCollarIndex])
	elseif (option == ItemListPlayerArmbinderOID)
		ItemListPlayerArmbinderIndex = index
		SetMenuOptionValue(ItemListPlayerArmbinderOID, ItemListPlayerArmbinder[ItemListPlayerArmbinderIndex])
		SetEquipment("Armbinders", ItemListPlayerArmbinder[ItemListPlayerArmbinderIndex])
	elseif (option == ItemListPlayerLegsOID)
		ItemListPlayerLegsIndex = index
		SetMenuOptionValue(ItemListPlayerLegsOID, ItemListPlayerLegs[ItemListPlayerLegsIndex])
		SetEquipment("LegCuffs", ItemListPlayerLegs[ItemListPlayerLegsIndex])
	elseif (option == ItemListPlayerGagOID)
		ItemListPlayerGagIndex = index
		SetMenuOptionValue(ItemListPlayerGagOID, ItemListPlayerGag[ItemListPlayerGagIndex])
		SetEquipment("Gag", ItemListPlayerGag[ItemListPlayerGagIndex])
	elseif (option == ItemListPlayerBeltOID)
		ItemListPlayerBeltIndex = index
		SetMenuOptionValue(ItemListPlayerBeltOID, ItemListPlayerBelt[ItemListPlayerBeltIndex])
		SetEquipment("Belt", ItemListPlayerBelt[ItemListPlayerBeltIndex])
	elseif (option == ItemListPlayerPlugVaginalOID)
		ItemListPlayerPlugVaginalIndex = index
		SetMenuOptionValue(ItemListPlayerPlugVaginalOID, ItemListPlayerPlugVaginal[ItemListPlayerPlugVaginalIndex])
		SetEquipment("PlugVaginal", ItemListPlayerPlugVaginal[ItemListPlayerPlugVaginalIndex])
	elseif (option == ItemListPlayerPlugAnalOID)
		ItemListPlayerPlugAnalIndex = index
		SetMenuOptionValue(ItemListPlayerPlugAnalOID, ItemListPlayerPlugAnal[ItemListPlayerPlugAnalIndex])
		SetEquipment("PlugAnal", ItemListPlayerPlugAnal[ItemListPlayerPlugAnalIndex])
	elseif (option == ItemListPlayerBlindfoldOID)
		ItemListPlayerBlindfoldIndex = index
		SetMenuOptionValue(ItemListPlayerBlindfoldOID, ItemListPlayerBlindfold[ItemListPlayerBlindfoldIndex])
		SetEquipment("Blindfold", ItemListPlayerBlindfold[ItemListPlayerBlindfoldIndex])
			
	endif
endevent

;------------------------------------------------------------------------------------------------------------------------------------------Highlight
event OnOptionHighlight(int option)
	if (option == ItemListCollarOID)
		SetInfoText("Set your master's preferred collar type")
	elseif (option == ItemListArmbinderOID)
		SetInfoText("Set your master's preferred armbinder type")
	elseif (option == ItemListLegsOID)
		SetInfoText("Set your master's preferred leg cuff type")
	elseif (option == ItemListGagOID)
		SetInfoText("Set your master's preferred gag type")
	elseif (option == ItemListBeltOID)
		SetInfoText("Set your master's preferred belt type")
	elseif (option == ItemListBlindfoldOID)
		SetInfoText("Set your master's preferred blindfold type")
	elseif (option == ItemListPlugVaginalOID)
		SetInfoText("Set your master's preferred vaginal plug type")
	elseif (option == ItemListPlugAnalOID)
		SetInfoText("Set your master's preferred anal plug type")
	elseif (option == ItemListPlayerCollarOID)
		SetInfoText("Set your preferred collar type")
	elseif (option == ItemListPlayerArmbinderOID)
		SetInfoText("Set your preferred armbinder type")
	elseif (option == ItemListPlayerLegsOID)
		SetInfoText("Set your preferred leg cuff type")
	elseif (option == ItemListPlayerGagOID)
		SetInfoText("Set your preferred gag type")
	elseif (option == ItemListPlayerBeltOID)
		SetInfoText("Set your preferred belt type")
	elseif (option == ItemListPlayerBlindfoldOID)
		SetInfoText("Set your preferred blindfold type")
	elseif (option == ItemListPlayerPlugVaginalOID)
		SetInfoText("Set your preferred vaginal plug type")
	elseif (option == ItemListPlayerPlugAnalOID)
		SetInfoText("Set your preferred anal plug type")
	elseif (option == var_race_riekling)
		SetInfoText("Toggle Rieklings as SD+ masters")
	elseif (option == var_race_rieklingthirsk)
		SetInfoText("Toggle Thirsk Rieklings as SD+ masters")
	elseif (option == var_race_rieklingmounted)
		SetInfoText("Toggle Mounted Rieklings as SD+ masters")
	elseif (option == var_race_snowelf)
		SetInfoText("Toggle Snow Elves as SD+ masters")
	elseif (option == var_race_gargoyle)
		SetInfoText("Toggle Gargoyles as SD+ masters")
	elseif (option == var_race_gargoyleboss)
		SetInfoText("Toggle Boss Gargoyles as SD+ masters")
	elseif (option == var_race_gargoylegreen)
		SetInfoText("Toggle Green Gargoyles as SD+ masters")
	elseif (option == var_race_lurker)
		SetInfoText("Toggle Lurkers as SD+ masters")
	elseif (option == var_race_netch)
		SetInfoText("Toggle Netches as SD+ masters")
	elseif (option == var_race_netchcalf)
		SetInfoText("Toggle Netch Calves as SD+ masters")

	endif
	
endevent

;	debug.trace("SD Addons - setting preferred equipment - " + sd_device + " to " + sd_tag)
;------------------------------------------------------------------------------------------------------------------------------------------Functions
; I can't believe this bullshit function has to exist.
; Papyrus has auto-conversion of hardoced special strings and will change "Imperial" to "IMPERIAL" automatically.
; No... really.

String Function sanitizeStringCode(String sText)
	String sReturnText = ""

	if (sText == "Argonian") || (sText == "argonian") || (sText == "ARGONIAN")
		sReturnText += "ARGONIAN"
	ElseIf (sText == "Bear") || (sText == "bear") || (sText == "BEAR")
		sReturnText += "BEAR"
	ElseIf (sText == "Breton")  || (sText == "breton") || (sText == "BRETON")
		sReturnText += "BRETON"
	ElseIf (sText == "Cat") || (sText == "cat") || (sText == "CAT") 
		sReturnText += "CAT"
	ElseIf (sText == "Chaurus") || (sText == "chaurus") || (sText == "CHAURUS") 
		sReturnText += "CHAURUS"
	ElseIf (sText == "Dog") || (sText == "dog") || (sText == "DOG") 
		sReturnText += "DOG"
	ElseIf (sText == "Draugr")  || (sText == "draugr") || (sText == "DRAUGR")
		sReturnText += "DRAUGR"
	ElseIf (sText == "Dremora") || (sText == "dremora") || (sText == "DREMORA") 
		sReturnText += "dremora"
	ElseIf (sText == "Elf")  || (sText == "elf") || (sText == "ELF")
		sReturnText += "ELF"
	ElseIf (sText == "Giant")  || (sText == "giant") || (sText == "GIANT")
		sReturnText += "GIANT"
	ElseIf (sText == "Hagraven")  || (sText == "hagraven") || (sText == "HAGRAVEN")
		sReturnText += "HAGRAVEN"
	ElseIf (sText == "Imperial")  || (sText == "imperial") || (sText == "IMPERIAL")
		sReturnText += "IMPERIAL"
	ElseIf (sText == "Khajiit")  || (sText == "khajiit") || (sText == "KHAJIIT")
		sReturnText += "KHAJIIT"
	ElseIf (sText == "Orc")  || (sText == "orc") || (sText == "ORC")
		sReturnText += "ORC"
	ElseIf (sText == "Redguard")  || (sText == "redguard") || (sText == "REDGUARD")
		sReturnText += "REDGUARD"
	ElseIf (sText == "Spider")  || (sText == "spider") || (sText == "SPIDER")
		sReturnText += "SPIDER"
	ElseIf (sText == "Troll")  || (sText == "troll") || (sText == "TROLL")
		sReturnText += "TROLL"
	ElseIf (sText == "Wolf")  || (sText == "wolf") || (sText == "WOLF")
		sReturnText += "WOLF"
	ElseIf (sText == "Falmer")  || (sText == "falmer") || (sText == "FALMER")
		sReturnText += "FALMER"
	ElseIf (sText == "Nord")  || (sText == "nord") || (sText == "NORD")
		sReturnText += "NORD"

	ElseIf (sText == "Collar")  || (sText == "collar") || (sText == "COLLAR")
		sReturnText += "collar"
	ElseIf (sText == "Corset")  || (sText == "corset") || (sText == "CORSET")
		sReturnText += "corset"
	ElseIf (sText == "Gloves")  || (sText == "gloves") || (sText == "GLOVES")
		sReturnText += "Gloves"
	ElseIf (sText == "Boots")  || (sText == "boots") || (sText == "BOOTS")
		sReturnText += "boots"

	ElseIf (sText == "WristRestraint")  || (sText == "wristrestraint") || (sText == "WRISTRESTRAINT")
		sReturnText += "WristRestraint"
	ElseIf (sText == "ArmCuffs")  || (sText == "legcuffs") || (sText == "LEGCUFFS")
		sReturnText += "ArmCuffs"
	ElseIf (sText == "LegCuffs")  || (sText == "legcuffs") || (sText == "LEGCUFFS")
		sReturnText += "LegCuffs"
	ElseIf (sText == "Belt")  || (sText == "belt") || (sText == "BELT")
		sReturnText += "belt"
	ElseIf (sText == "PlugVaginal")  || (sText == "plugvaginal") || (sText == "PLUGVAGINAL")
		sReturnText += "PlugVaginal"
	ElseIf (sText == "PlugAnal")  || (sText == "pluganal") || (sText == "PLUGANAL")
		sReturnText += "PlugAnal"
	ElseIf (sText == "Blindfold")  || (sText == "blindfold") || (sText == "BLINDFOLD")
		sReturnText += "Blindfold"
 	ElseIf (sText == "Gag")  || (sText == "gag") || (sText == "GAG")
		sReturnText += "Gag"
 	ElseIf (sText == "Yoke")  || (sText == "yoke") || (sText == "YOKE")
		sReturnText += "Yoke"
 	ElseIf (sText == "VaginalPiercing")  || (sText == "vaginalpiercing") || (sText == "VAGINALPIERCING")
		sReturnText += "VaginalPiercing"
 
	Else
		debug.notification(" No sanitized match found for " + sText)
		; debugTrace(" No match found for " + sText)
	Endif

	; Deprecated strings
	; "_SD_DeviousSanguine" )  
	; "_SD_DeviousEnslaved" ) || (deviousKeyword == "Enslaved") 
	; "_SD_DeviousEnslavedCommon" ) || (deviousKeyword == "EnslavedCommon") 
	; "_SD_DeviousEnslavedMagic" ) || (deviousKeyword == "EnslavedMagic") 
	; "_SD_DeviousEnslavedPrimitive" ) || (deviousKeyword == "EnslavedPrimitive") 
	; "_SD_DeviousEnslavedWealthy" ) || (deviousKeyword == "EnslavedWealthy") 
	; "_SD_DeviousParasiteAn" ) || (deviousKeyword == "ParasiteAnal") 
	; "_SD_DeviousParasiteVag" ) || (deviousKeyword == "ParasiteVaginal") 
	;"_SD_DeviousSpriggan" ) || (deviousKeyword == "Spriggan") 

	; debugTrace("sanitizeStringCode - sText: " + sText + " - sReturnText: " + sReturnText )

	Return sReturnText
EndFunction

Event SetEquipment(string sd_device, string sd_tag)
	if sd_tag != "Default"
		debug.trace("SD Addons - setting preferred equipment - " + sd_device + " to " + sd_tag + " on master " + (StorageUtil.GetFormValue(Game.GetPlayer(), "_SD_CurrentOwner") as actor))
		StorageUtil.SetStringValue((StorageUtil.GetFormValue(Game.GetPlayer(), "_SD_CurrentOwner") as actor), "_SD_" + sanitizeStringCode(sd_device) + "_material", sd_tag)
	endif
endevent

Event SetPlayerEquipment(string sd_device, string sd_tag)
	if sd_tag != "Default"
		debug.trace("SD Addons - setting preferred equipment - " + sd_device + " to " + sd_tag + " on player.")
		StorageUtil.SetStringValue(game.getplayer(), "_SD_" + sanitizeStringCode(sd_device) + "_material", sd_tag)
	endif
endevent

event AddItemLists()
	debug.trace("SD Addons - Setting up item type lists")
	ItemListCollar = new string[5]
	ItemListCollar[0] = "Default"
	ItemListCollar[1] = "Rusted"
	ItemListCollar[2] = "Iron"
	ItemListCollar[3] = "Leather"
	ItemListCollar[4] = "Rope"
	
	ItemListArmbinder = new string[5]
	ItemListArmbinder[0] = "Default"
	ItemListArmbinder[1] = "Rusted"
	ItemListArmbinder[2] = "Iron"
	ItemListArmbinder[3] = "Leather"
	ItemListArmbinder[4] = "Rope"
	
	ItemListLegs = new string[5]
	ItemListLegs[0] = "Default"
	ItemListLegs[1] = "Rusted"
	ItemListLegs[2] = "Iron"
	ItemListLegs[3] = "Leather"
	ItemListLegs[4] = "Rope"
	
	ItemListGag = new string[5]
	ItemListGag[0] = "Default"
	ItemListGag[1] = "Rusted"
	ItemListGag[2] = "Iron"
	ItemListGag[3] = "Leather"
	ItemListGag[4] = "Rope"
	
	ItemListBelt = new string[5]
	ItemListBelt[0] = "Default"
	ItemListBelt[1] = "Rusted"
	ItemListBelt[2] = "Iron"
	ItemListBelt[3] = "Leather"
	ItemListBelt[4] = "Rope"
	
	ItemListPlugVaginal = new string[5]
	ItemListPlugVaginal[0] = "Default"
	ItemListPlugVaginal[1] = "Rusted"
	ItemListPlugVaginal[2] = "Iron"
	ItemListPlugVaginal[3] = "Leather"
	ItemListPlugVaginal[4] = "Rope"

	ItemListPlugAnal = new string[5]
	ItemListPlugAnal[0] = "Default"
	ItemListPlugAnal[1] = "Rusted"
	ItemListPlugAnal[2] = "Iron"
	ItemListPlugAnal[3] = "Leather"
	ItemListPlugAnal[4] = "Rope"
	
	ItemListBlindfold = new string[5]
	ItemListBlindfold[0] = "Default"
	ItemListBlindfold[1] = "Rusted"
	ItemListBlindfold[2] = "Iron"
	ItemListBlindfold[3] = "Leather"
	ItemListBlindfold[4] = "Rope"

endevent

event AddItemListPlayers()
	debug.trace("SD Addons - Setting up item type lists")
	ItemListPlayerCollar = new string[5]
	ItemListPlayerCollar[0] = "Default"
	ItemListPlayerCollar[1] = "Rusted"
	ItemListPlayerCollar[2] = "Iron"
	ItemListPlayerCollar[3] = "Leather"
	ItemListPlayerCollar[4] = "Rope"
	
	ItemListPlayerArmbinder = new string[5]
	ItemListPlayerArmbinder[0] = "Default"
	ItemListPlayerArmbinder[1] = "Rusted"
	ItemListPlayerArmbinder[2] = "Iron"
	ItemListPlayerArmbinder[3] = "Leather"
	ItemListPlayerArmbinder[4] = "Rope"
	
	ItemListPlayerLegs = new string[5]
	ItemListPlayerLegs[0] = "Default"
	ItemListPlayerLegs[1] = "Rusted"
	ItemListPlayerLegs[2] = "Iron"
	ItemListPlayerLegs[3] = "Leather"
	ItemListPlayerLegs[4] = "Rope"
	
	ItemListPlayerGag = new string[5]
	ItemListPlayerGag[0] = "Default"
	ItemListPlayerGag[1] = "Rusted"
	ItemListPlayerGag[2] = "Iron"
	ItemListPlayerGag[3] = "Leather"
	ItemListPlayerGag[4] = "Rope"
	
	ItemListPlayerBelt = new string[5]
	ItemListPlayerBelt[0] = "Default"
	ItemListPlayerBelt[1] = "Rusted"
	ItemListPlayerBelt[2] = "Iron"
	ItemListPlayerBelt[3] = "Leather"
	ItemListPlayerBelt[4] = "Rope"
	
	ItemListPlayerPlugVaginal = new string[5]
	ItemListPlayerPlugVaginal[0] = "Default"
	ItemListPlayerPlugVaginal[1] = "Rusted"
	ItemListPlayerPlugVaginal[2] = "Iron"
	ItemListPlayerPlugVaginal[3] = "Leather"
	ItemListPlayerPlugVaginal[4] = "Rope"

	ItemListPlayerPlugAnal = new string[5]
	ItemListPlayerPlugAnal[0] = "Default"
	ItemListPlayerPlugAnal[1] = "Rusted"
	ItemListPlayerPlugAnal[2] = "Iron"
	ItemListPlayerPlugAnal[3] = "Leather"
	ItemListPlayerPlugAnal[4] = "Rope"
	
	ItemListPlayerBlindfold = new string[5]
	ItemListPlayerBlindfold[0] = "Default"
	ItemListPlayerBlindfold[1] = "Rusted"
	ItemListPlayerBlindfold[2] = "Iron"
	ItemListPlayerBlindfold[3] = "Leather"
	ItemListPlayerBlindfold[4] = "Rope"

endevent

Event RacesAdd(int raceadd)		;instead of ints, why not use strings? makes more sense that way, and code is more easily readable. ALSO - by default, add ALL options instead of a debug trace saying NULL, that way oninit() doesn't need to have so much in it
	
	if raceadd==1
		debug.trace("SD Addon - Adding race - Rieklings base race")
		if (StorageUtil.FormListFind( none, "_SD_lRaceMastersList", dlc2rieklingrace) <0)
			StorageUtil.FormListAdd( none, "_SD_lRaceMastersList", dlc2rieklingrace)  
			StorageUtil.SetIntValue(dlc2rieklingrace, "_SD_iSlaveryRace", 1)
			StorageUtil.SetStringValue(dlc2rieklingrace, "_SD_sRaceType", "Beast")  ; or "humanoid" if race members can speak
			StorageUtil.SetStringValue(dlc2rieklingrace, "_SD_sRaceName", dlc2rieklingrace.GetName())   
			StorageUtil.SetFormValue(dlc2rieklingrace, "_SD_sRaceFaction", dlc2rieklingfaction)  
			SetOptionFlags(var_race_riekling, OPTION_FLAG_DISABLED)
		endif
	
	elseif raceadd==2
		debug.trace("SD Addon - Adding race - Rieklings Mounted race")
		if (StorageUtil.FormListFind( none, "_SD_lRaceMastersList", dlc2mountedrieklingrace) <0)
			StorageUtil.FormListAdd( none, "_SD_lRaceMastersList", dlc2mountedrieklingrace)  
			StorageUtil.SetIntValue(dlc2mountedrieklingrace, "_SD_iSlaveryRace", 1)
			StorageUtil.SetStringValue(dlc2mountedrieklingrace, "_SD_sRaceType", "Beast")  ; or "humanoid" if race members can speak
			StorageUtil.SetStringValue(dlc2mountedrieklingrace, "_SD_sRaceName", dlc2mountedrieklingrace.GetName())   
			StorageUtil.SetFormValue(dlc2mountedrieklingrace, "_SD_sRaceFaction", dlc2rieklingfaction)  
			SetOptionFlags(var_race_rieklingmounted, OPTION_FLAG_DISABLED)
			endif
	
	elseif raceadd==3
		debug.trace("SD Addon - Adding race - Rieklings Thirsk race")
		if (StorageUtil.FormListFind( none, "_SD_lRaceMastersList", dlc2thirskrieklingrace) <0)
			StorageUtil.FormListAdd( none, "_SD_lRaceMastersList", dlc2thirskrieklingrace)  
			StorageUtil.SetIntValue(dlc2thirskrieklingrace, "_SD_iSlaveryRace", 1)
			StorageUtil.SetStringValue(dlc2thirskrieklingrace, "_SD_sRaceType", "Beast")  ; or "humanoid" if race members can speak
			StorageUtil.SetStringValue(dlc2thirskrieklingrace, "_SD_sRaceName", dlc2thirskrieklingrace.GetName())   
			StorageUtil.SetFormValue(dlc2thirskrieklingrace, "_SD_sRaceFaction", dlc2rieklingfaction)  
			SetOptionFlags(var_race_rieklingthirsk, OPTION_FLAG_DISABLED)
		endif
	
	elseif raceadd==4
		debug.trace("SD Addon - Adding race - Snow Elf race")
		if (StorageUtil.FormListFind( none, "_SD_lRaceMastersList", snowelfrace) <0)
			StorageUtil.FormListAdd( none, "_SD_lRaceMastersList", snowelfrace)  
			StorageUtil.SetIntValue(snowelfrace, "_SD_iSlaveryRace", 1)
			StorageUtil.SetStringValue(snowelfrace, "_SD_sRaceType", "Humanoid")  ; or "humanoid" if race members can speak
			StorageUtil.SetStringValue(snowelfrace, "_SD_sRaceName", snowelfrace.GetName())   
			StorageUtil.SetFormValue(snowelfrace, "_SD_sRaceFaction", dlc1geleborfaction)
			SetOptionFlags(var_race_snowelf, OPTION_FLAG_DISABLED)
		endif
	
	elseif raceadd==5
		debug.trace("SD Addon - Adding race - Gargoyle race")
		if (StorageUtil.FormListFind( none, "_SD_lRaceMastersList", dlc1gargoylerace) <0)
			StorageUtil.FormListAdd( none, "_SD_lRaceMastersList", dlc1gargoylerace)  
			StorageUtil.SetIntValue(dlc1gargoylerace, "_SD_iSlaveryRace", 1)
			StorageUtil.SetStringValue(dlc1gargoylerace, "_SD_sRaceType", "Beast")  ; or "humanoid" if race members can speak
			StorageUtil.SetStringValue(dlc1gargoylerace, "_SD_sRaceName", dlc1gargoylerace.GetName())   
			StorageUtil.SetFormValue(dlc1gargoylerace, "_SD_sRaceFaction", dlc1vampirecompanionfaction)
			SetOptionFlags(var_race_gargoyle, OPTION_FLAG_DISABLED)
		endif
	
	elseif raceadd==6
		debug.trace("SD Addon - Adding race - Gargoyle Boss race")
		if (StorageUtil.FormListFind( none, "_SD_lRaceMastersList", dlc1gargoylevariantbossrace) <0)
			StorageUtil.FormListAdd( none, "_SD_lRaceMastersList", dlc1gargoylevariantbossrace)  
			StorageUtil.SetIntValue(dlc1gargoylevariantbossrace, "_SD_iSlaveryRace", 1)
			StorageUtil.SetStringValue(dlc1gargoylevariantbossrace, "_SD_sRaceType", "Beast")  ; or "humanoid" if race members can speak
			StorageUtil.SetStringValue(dlc1gargoylevariantbossrace, "_SD_sRaceName", dlc1gargoylevariantbossrace.GetName())   
			StorageUtil.SetFormValue(dlc1gargoylevariantbossrace, "_SD_sRaceFaction", dlc1vampirecompanionfaction)  
			SetOptionFlags(var_race_gargoyleboss, OPTION_FLAG_DISABLED)
		endif
	
	elseif raceadd==7
		debug.trace("SD Addon - Adding race - Gargoyle Green race")
		if (StorageUtil.FormListFind( none, "_SD_lRaceMastersList", dlc1gargoylevariantgreenrace) <0)
			StorageUtil.FormListAdd( none, "_SD_lRaceMastersList", dlc1gargoylevariantgreenrace)  
			StorageUtil.SetIntValue(dlc1gargoylevariantgreenrace, "_SD_iSlaveryRace", 1)
			StorageUtil.SetStringValue(dlc1gargoylevariantgreenrace, "_SD_sRaceType", "Beast")  ; or "humanoid" if race members can speak
			StorageUtil.SetStringValue(dlc1gargoylevariantgreenrace, "_SD_sRaceName", dlc1gargoylevariantgreenrace.GetName())   
			StorageUtil.SetFormValue(dlc1gargoylevariantgreenrace, "_SD_sRaceFaction", dlc1vampirecompanionfaction)  
			SetOptionFlags(var_race_gargoylegreen, OPTION_FLAG_DISABLED)
		endif
	
	elseif raceadd==8
		debug.trace("SD Addon - Adding race - Lurker race")
		if (StorageUtil.FormListFind( none, "_SD_lRaceMastersList", dlc2lurkerrace) <0)
			StorageUtil.FormListAdd( none, "_SD_lRaceMastersList", dlc2lurkerrace)  
			StorageUtil.SetIntValue(dlc2lurkerrace, "_SD_iSlaveryRace", 1)
			StorageUtil.SetStringValue(dlc2lurkerrace, "_SD_sRaceType", "Beast")  ; or "humanoid" if race members can speak
			StorageUtil.SetStringValue(dlc2lurkerrace, "_SD_sRaceName", dlc2lurkerrace.GetName())   
			StorageUtil.SetFormValue(dlc2lurkerrace, "_SD_sRaceFaction", dlc2benthiclurkerfaction)  
			SetOptionFlags(var_race_lurker, OPTION_FLAG_DISABLED)
		endif
		
	elseif raceadd==9
		debug.trace("SD Addon - Adding race - Netch race")
		if (StorageUtil.FormListFind( none, "_SD_lRaceMastersList", dlc2netchrace) <0)
			StorageUtil.FormListAdd( none, "_SD_lRaceMastersList", dlc2netchrace)  
			StorageUtil.SetIntValue(dlc2netchrace, "_SD_iSlaveryRace", 1)
			StorageUtil.SetStringValue(dlc2netchrace, "_SD_sRaceType", "Beast")  ; or "humanoid" if race members can speak
			StorageUtil.SetStringValue(dlc2netchrace, "_SD_sRaceName", dlc2netchrace.GetName())   
			StorageUtil.SetFormValue(dlc2netchrace, "_SD_sRaceFaction", dlc2netchfaction)
			SetOptionFlags(var_race_netch, OPTION_FLAG_DISABLED)
		endif

	elseif raceadd==10
		debug.trace("SD Addon - Adding race - Netch Calf race")
		if (StorageUtil.FormListFind( none, "_SD_lRaceMastersList", dlc2netchcalfrace) <0)
			StorageUtil.FormListAdd( none, "_SD_lRaceMastersList", dlc2netchcalfrace)  
			StorageUtil.SetIntValue(dlc2netchcalfrace, "_SD_iSlaveryRace", 1)
			StorageUtil.SetStringValue(dlc2netchcalfrace, "_SD_sRaceType", "Beast")  ; or "humanoid" if race members can speak
			StorageUtil.SetStringValue(dlc2netchcalfrace, "_SD_sRaceName", dlc2netchcalfrace.GetName())   
			StorageUtil.SetFormValue(dlc2netchcalfrace, "_SD_sRaceFaction", dlc2netchfaction)
			SetOptionFlags(var_race_netchcalf, OPTION_FLAG_DISABLED)
		endif
		
	else
		debug.trace("SD Addon - Attempted to add a NULL race")
	endif

endevent


;------------------------------------------------------------------------------------------------------------------------------------------Properties
race property dlc2rieklingrace auto
race property dlc2thirskrieklingrace auto
race property dlc2mountedrieklingrace auto
race property snowelfrace auto
race property dlc1gargoylerace auto
race property dlc1gargoylevariantbossrace auto
race property dlc1gargoylevariantgreenrace auto
race property dlc2lurkerrace auto
race property dlc2netchrace auto
race property dlc2netchcalfrace auto
faction property dlc2rieklingfaction auto
faction property dlc1geleborfaction auto
faction property dlc1vampirecompanionfaction auto
faction property dlc2benthiclurkerfaction auto
faction property dlc2netchfaction auto