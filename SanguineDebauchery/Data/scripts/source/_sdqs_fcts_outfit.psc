Scriptname _sdqs_fcts_outfit extends Quest  
{ USED }
Import Utility
Import SKSE


 
;  http://wiki.tesnexus.com/index.php/Skyrim_bodyparts_number
;
;  This is the list of the body parts used by Bethesda and named in the Creation Kit:
;    30   - head
;    31     - hair
;    32   - body (full)
;    33   - hands
;    34   - forearms
;    35   - amulet
;    36   - ring
;    37   - feet
;    38   - calves
;    39   - shield
;    40   - tail
;    41   - long hair
;    42   - circlet
;    43   - ears
;    50   - decapitated head
;    51   - decapitate
;    61   - FX01
;  
;  Other body parts that exist in vanilla nif models
;    44   - Used in bloodied dragon heads, so it is free for NPCs
;    45   - Used in bloodied dragon wings, so it is free for NPCs
;    47   - Used in bloodied dragon tails, so it is free for NPCs
;    130   - Used in helmetts that conceal the whole head and neck inside
;    131   - Used in open faced helmets\hoods (Also the nightingale hood)
;    141   - Disables Hair Geometry like 131 and 31
;    142   - Used in circlets
;    143   - Disabled Ear geometry to prevent clipping issues?
;    150   - The gore that covers a decapitated head neck
;    230   - Neck, where 130 and this meets is the decapitation point of the neck
;  
;  Free body slots and reference usage
;    44   - face/mouth
;    45   - neck (like a cape, scarf, or shawl, neck-tie etc)
;    46   - chest primary or outergarment
;    47   - back (like a backpack/wings etc)
;    48   - misc/FX (use for anything that doesnt fit in the list)
;    49   - pelvis primary or outergarment
;    52   - pelvis secondary or undergarment
;    53   - leg primary or outergarment or right leg
;    54   - leg secondary or undergarment or leftt leg
;    55   - face alternate or jewelry
;    56   - chest secondary or undergarment
;    57   - shoulder
;    58   - arm secondary or undergarment or left arm
;    59   - arm primary or outergarment or right arm
;    60   - misc/FX (use for anything that doesnt fit in the list)



; Devious Devices 2.9
; Gags: 44
; Collars: 45
; Armbinder: 46
; Plugs (Anal): 48
; Chastity Belts: 49
; Vaginal Piercings: 50
; Nipple Piercings: 51
; Cuffs (Legs): 53
; Blindfold: 55
; Chastity Bra: 56
; Plugs (Vaginal): 57
; Body Harness: 58
; Cuffs (Arms): 59



Function equipDeviceByString ( String sDeviceString = "", String sOutfitString = "", bool skipEvents = false, bool skipMutex = false )
	; Armor kCollar = libs.GetWornDeviceFuzzyMatch(libs.PlayerRef, libs.zad_DeviousCollar  )
	Keyword kwDeviceKeyword = getDeviousKeywordByString(sDeviceString)
	; Keyword kwOutfitKeyword = getDeviousKeywordByString(sOutfitString)
	Actor PlayerActor = Game.GetPlayer()
	Actor kMaster = None
	Int iDevOutfit
	Int iDevOutfitPart

	; If player enslaved, give priority to outfits for Gag, Blindfold, Belt, PlugAnal, PlugVaginal, Armbinder, LegCuffs
	;	- set outfitString to Enslaved
	;   - get outfitID from master
	If (StorageUtil.GetIntValue(PlayerActor, "_SD_iEnslaved")==1) && ( getDeviousOutfitPartByString(sDeviceString) != -1 )
		sOutfitString = "Enslaved"
	Endif
 
	If (sOutfitString=="") && (kwDeviceKeyword != None)

		if !PlayerActor.WornHasKeyword(kwDeviceKeyword)
			Debug.Trace("[SD] equip device string: " + sDeviceString)  
			Debug.Trace("[SD] equip device keyword: " + kwDeviceKeyword)  

			libs.ManipulateGenericDeviceByKeyword(PlayerActor, kwDeviceKeyword, True, skipEvents,  skipMutex)
		else
			Debug.Trace("[SD] player is already wearing: " + sDeviceString)  
		endIf

	ElseIf (sOutfitString!="") && (kwDeviceKeyword != None)

		if !PlayerActor.WornHasKeyword(kwDeviceKeyword)
			If (StorageUtil.GetIntValue(PlayerActor, "_SD_iEnslaved")==1)
				kMaster = StorageUtil.GetFormValue(PlayerActor, "_SD_CurrentOwner") as Actor
				iDevOutfit = StorageUtil.GetIntValue(kMaster, "_SD_iOutfitID")
			Else
				iDevOutfit = getDeviousOutfitByString(sOutfitString)
			Endif
			iDevOutfitPart = getDeviousOutfitPartByString(sDeviceString)

			if (iDevOutfit!=-1) && (iDevOutfitPart!=-1)
				Debug.Trace("[SD] equip device string: " + sDeviceString)  

				; setDeviousOutfitByKeyword ( iOutfit= iDevOutfit, iOutfitPart = -1, ddArmorKeyword=kwDeviceKeyword, bEquip = true, sMessage = "")
				setDeviousOutfitByTags ( iDevOutfit, iDevOutfitPart, true)
			else
				Debug.Trace("[SD] unknown outfit to equip: " + iDevOutfit)  
				Debug.Trace("[SD] unknown outfit part to equip: " + iDevOutfitPart)  
			endif

		else
			Debug.Trace("[SD] player is already wearing: " + sDeviceString)  
		endIf
	else
		Debug.Trace("[SD] unknown device to equip " )  

	endif
EndFunction

Function clearDeviceByString ( String sDeviceString = "", String sOutfitString = "", bool skipEvents = false, bool skipMutex = false )
	; Armor kCollar = libs.GetWornDeviceFuzzyMatch(libs.PlayerRef, libs.zad_DeviousCollar  )
	Keyword kwDeviceKeyword = getDeviousKeywordByString(sDeviceString)
	; Keyword kwOutfitKeyword = getDeviousKeywordByString(sOutfitString)
	Actor PlayerActor = Game.GetPlayer()
	Int iDevOutfit
	Int iDevOutfitPart
 
	If (sOutfitString=="") && (kwDeviceKeyword != None)

		if PlayerActor.WornHasKeyword(kwDeviceKeyword)
			Debug.Trace("[SD] clearing device string: " + sDeviceString)  
			Debug.Trace("[SD] clearing device keyword: " + kwDeviceKeyword)  

			libs.ManipulateGenericDeviceByKeyword(PlayerActor, kwDeviceKeyword, False, skipEvents,  skipMutex)
		else
			Debug.Trace("[SD] player is not wearing: " + sDeviceString)  
		endIf

	ElseIf (sOutfitString!="") && (kwDeviceKeyword != None)

		if PlayerActor.WornHasKeyword(kwDeviceKeyword)
			iDevOutfit = getDeviousOutfitByString(sOutfitString)
			iDevOutfitPart = getDeviousOutfitPartByString(sDeviceString)

			if (iDevOutfit!=-1) && (iDevOutfitPart!=-1)
				Debug.Trace("[SD] clearing device string: " + sDeviceString)  

				; setDeviousOutfitByKeyword ( iOutfit= iDevOutfit, iOutfitPart = iDevOutfitPart, ddArmorKeyword=kwDeviceKeyword, bEquip = false, sMessage = "")
				setDeviousOutfitByTags ( iDevOutfit, iDevOutfitPart, false)
			else
				Debug.Trace("[SD] unknown outfit to clear: " + iDevOutfit)  
				Debug.Trace("[SD] unknown outfit part to clear: " + iDevOutfitPart)  
			endif
		else
			Debug.Trace("[SD] player is not wearing: " + sDeviceString)  
		endIf
	else
		Debug.Trace("[SD] unknown device to clear " )  

	endif
EndFunction

Function clearDevicesForEnslavement()
	; OutfitPart set to -1 to force the use of ManipulateGenericDeviceByKeyword when clearing items

	If !isDeviceEquippedKeyword( Game.getPlayer(),  "_SD_DeviousSanguine", "Collar"  ) && !isDeviceEquippedKeyword( Game.getPlayer(),  "_SD_DeviousEnslaved", "Collar"  )
		; setDeviousOutfitByKeyword ( iOutfit = -1, iOutfitPart = -1, ddArmorKeyword = libs.zad_DeviousCollar, bEquip = False, sMessage = "" , bDestroy = True)
		clearDeviceByString ( sDeviceString = "Collar", skipEvents = true, skipMutex = true )
	EndIf

	If !isDeviceEquippedKeyword( Game.getPlayer(),  "_SD_DeviousSanguine", "Armbinder"  ) && !isDeviceEquippedKeyword( Game.getPlayer(),  "_SD_DeviousSpriggan", "Armbinder"  ) && !isDeviceEquippedKeyword( Game.getPlayer(),  "_SD_DeviousEnslaved", "Armbinder"  )
		; setDeviousOutfitByKeyword ( iOutfit = -1, iOutfitPart = -1, ddArmorKeyword = libs.zad_DeviousArmCuffs, bEquip = False, sMessage = "" , bDestroy = True)
		clearDeviceByString ( sDeviceString = "ArmCuffs", skipEvents = true, skipMutex = true )
	EndIf

	If !isDeviceEquippedKeyword( Game.getPlayer(),  "_SD_DeviousSanguine", "LegCuffs"  ) && !isDeviceEquippedKeyword( Game.getPlayer(),  "_SD_DeviousSpriggan", "LegCuffs"   ) && !isDeviceEquippedKeyword( Game.getPlayer(),  "_SD_DeviousEnslaved", "LegCuffs"   )
		; setDeviousOutfitByKeyword ( iOutfit = -1, iOutfitPart = -1, ddArmorKeyword = libs.zad_DeviousLegCuffs, bEquip = False, sMessage = "" , bDestroy = True)
		clearDeviceByString ( sDeviceString = "LegCuffs", skipEvents = true, skipMutex = true )
	EndIf

EndFunction




Keyword Function getDeviousKeywordByString(String deviousKeyword = ""  )
	Keyword thisKeyword = None
 
	if (deviousKeyword == "_SD_DeviousSanguine" ) || (deviousKeyword == "Sanguine") 
		thisKeyword = _SDKP_DeviousSanguine

	elseif (deviousKeyword == "_SD_DeviousSpriggan" ) || (deviousKeyword == "Spriggan") 
		thisKeyword = _SDKP_DeviousSpriggan

	elseif (deviousKeyword == "_SD_DeviousEnslaved" ) || (deviousKeyword == "Enslaved") 
		thisKeyword = _SDKP_DeviousEnslaved

	elseif (deviousKeyword == "_SD_DeviousEnslavedCommon" ) || (deviousKeyword == "EnslavedCommon") 
		thisKeyword = _SDKP_DeviousEnslavedCommon

	elseif (deviousKeyword == "_SD_DeviousEnslavedMagic" ) || (deviousKeyword == "EnslavedMagic") 
		thisKeyword = _SDKP_DeviousEnslavedMagic

	elseif (deviousKeyword == "_SD_DeviousEnslavedPrimitive" ) || (deviousKeyword == "EnslavedPrimitive") 
		thisKeyword = _SDKP_DeviousEnslavedPrimitive

	elseif (deviousKeyword == "_SD_DeviousEnslavedWealthy" ) || (deviousKeyword == "EnslavedWealthy") 
		thisKeyword = _SDKP_DeviousEnslavedWealthy

	elseif (deviousKeyword == "_SD_DeviousParasiteAn" ) || (deviousKeyword == "ParasiteAnal") 
		thisKeyword = _SDKP_DeviousParasiteAn

	elseif (deviousKeyword == "_SD_DeviousParasiteVag" ) || (deviousKeyword == "ParasiteVaginal") 
		thisKeyword = _SDKP_DeviousParasiteVag
		
	elseif (deviousKeyword == "zad_BlockGeneric")
		thisKeyword = libs.zad_BlockGeneric
		
	elseif (deviousKeyword == "zad_Lockable")
		thisKeyword = libs.zad_Lockable

	elseif (deviousKeyword == "zad_DeviousCollar") || (deviousKeyword == "Collar") 
		thisKeyword = libs.zad_DeviousCollar

	elseif (deviousKeyword == "zad_DeviousArmbinder") || (deviousKeyword == "Armbinder") 
		thisKeyword = libs.zad_DeviousArmbinder

	elseif (deviousKeyword == "zad_DeviousLegCuffs") || (deviousKeyword == "LegCuffs") 
		thisKeyword = libs.zad_DeviousLegCuffs

	elseif (deviousKeyword == "zad_DeviousGag") || (deviousKeyword == "Gag") 
		thisKeyword = libs.zad_DeviousGag

	elseif (deviousKeyword == "zad_DeviousBlindfold") || (deviousKeyword == "Blindfold") 
		thisKeyword = libs.zad_DeviousBlindfold

	elseif (deviousKeyword == "zad_DeviousBelt") || (deviousKeyword == "Belt") 
		thisKeyword = libs.zad_DeviousBelt

	elseif (deviousKeyword == "zad_DeviousPlugAnal") || (deviousKeyword == "PlugAnal") 
		thisKeyword = libs.zad_DeviousPlugAnal

	elseif (deviousKeyword == "zad_DeviousPlugVaginal") || (deviousKeyword == "PlugVaginal") 
		thisKeyword = libs.zad_DeviousPlugVaginal

	elseif (deviousKeyword == "zad_DeviousBra") || (deviousKeyword == "Bra") 
		thisKeyword = libs.zad_DeviousBra

	elseif (deviousKeyword == "zad_DeviousArmCuffs") || (deviousKeyword == "ArmCuffs") 
		thisKeyword = libs.zad_DeviousArmCuffs

	elseif (deviousKeyword == "zad_DeviousYoke") || (deviousKeyword == "Yoke") 
		thisKeyword = libs.zad_DeviousYoke

	elseif (deviousKeyword == "zad_DeviousCorset") || (deviousKeyword == "Corset") 
		thisKeyword = libs.zad_DeviousCorset

	elseif (deviousKeyword == "zad_DeviousClamps") || (deviousKeyword == "Clamps") 
		thisKeyword = libs.zad_DeviousClamps

	elseif (deviousKeyword == "zad_DeviousGloves") || (deviousKeyword == "Gloves") 
		thisKeyword = libs.zad_DeviousGloves

	elseif (deviousKeyword == "zad_DeviousHood") || (deviousKeyword == "Hood") 
		thisKeyword = libs.zad_DeviousHood

	elseif (deviousKeyword == "zad_DeviousSuit") || (deviousKeyword == "Suits") 
		thisKeyword = libs.zad_DeviousSuit

	elseif (deviousKeyword == "zad_DeviousGagPanel") || (deviousKeyword == "GagPanel") 
		thisKeyword = libs.zad_DeviousGagPanel

	elseif (deviousKeyword == "zad_DeviousPlug") || (deviousKeyword == "Plug") 
		thisKeyword = libs.zad_DeviousPlug

	elseif (deviousKeyword == "zad_DeviousHarness") || (deviousKeyword == "Harness") 
		thisKeyword = libs.zad_DeviousHarness

	elseif (deviousKeyword == "zad_DeviousBoots") || (deviousKeyword == "Boots") 
		thisKeyword = libs.zad_DeviousBoots

	elseif (deviousKeyword == "zad_DeviousPiercingsNipple") || (deviousKeyword == "PiercingNipple") 
		thisKeyword = libs.zad_DeviousPiercingsNipple

	elseif (deviousKeyword == "zad_DeviousPiercingsVaginal") || (deviousKeyword == "PiercingVaginal") 
		thisKeyword = libs.zad_DeviousPiercingsVaginal

	else
		Debug.Notification("[SD] Unknown generic keyword: " + deviousKeyword)  
	endIf

	return thisKeyword
EndFunction

Keyword function getDeviousKeywordByOutfitPart(Int iDevOutfitPart)
	Keyword thisKeyword = None

	If (iDevOutfitPart == 0 )
		thisKeyword =  libs.zad_DeviousCollar  ; 0 - Collar - Unused

	ElseIf (iDevOutfitPart == 1 )
		thisKeyword =  libs.zad_DeviousArmbinder ; 1 - Arms cuffs

	ElseIf (iDevOutfitPart == 2 )
		thisKeyword =  libs.zad_DeviousLegCuffs   ; 2 - Legs cuffs

	ElseIf (iDevOutfitPart == 3 )
		thisKeyword =  libs.zad_DeviousGag   ; 3 - Gag

	ElseIf (iDevOutfitPart == 4 )
		thisKeyword =  libs.zad_DeviousBlindfold   ; 4 - Blindfold

	ElseIf (iDevOutfitPart == 5 )
		thisKeyword =  libs.zad_DeviousBelt   ; 5 - Belt

	ElseIf (iDevOutfitPart == 6 )
		thisKeyword =  libs.zad_DeviousPlugAnal  ; 6 - Plug Anal

	ElseIf (iDevOutfitPart == 7 )
		thisKeyword =  libs.zad_DeviousPlugVaginal ; 7 - Plug Vaginal

	Else
		Debug.Notification("[SD] Not a default outfit part - " + iDevOutfitPart)
	endIf

	return thisKeyword
EndFunction

Int Function getDeviousOutfitByString(String deviousKeyword = ""  )
	Int thisOutfit = -1

	if (deviousKeyword == "_SD_DeviousSanguine" ) || (deviousKeyword == "Sanguine") 
		thisOutfit = 10

	elseif (deviousKeyword == "_SD_DeviousSpriggan" ) || (deviousKeyword == "Spriggan") 
		thisOutfit = 7

	elseif (deviousKeyword == "_SD_DeviousEnslaved" ) || (deviousKeyword == "Enslaved") 
		thisOutfit = 0

	elseif (deviousKeyword == "_SD_DeviousParasiteAn" ) || (deviousKeyword == "ParasiteAnal")  || (deviousKeyword == "Parasite") 
		thisOutfit = 9

	elseif (deviousKeyword == "_SD_DeviousParasiteVag" ) || (deviousKeyword == "ParasiteVaginal")  || (deviousKeyword == "Parasite")
		thisOutfit = 9

	else
		Debug.Notification("[SD] unknown non-generic outfit: " + deviousKeyword)  
	endif

	return thisOutfit
EndFunction

Int Function getDeviousOutfitPartByString(String deviousKeyword = ""  )
	Int thisOutfitPart = -1
	; 0 - Collar
	; 1 - Arms
	; 2 - Legs
	; 3 - Gag
	; 4 - Blindfold
	; 5 - Belt
	; 6 - Plug Anal
	; 7 - Plug Vaginal 
	if (deviousKeyword == "zad_DeviousCollar") || (deviousKeyword == "Collar") 
		thisOutfitPart = 0

	elseif (deviousKeyword == "zad_DeviousArmbinder") || (deviousKeyword == "Armbinder") 
		thisOutfitPart = 1

	elseif (deviousKeyword == "zad_DeviousLegCuffs") || (deviousKeyword == "LegCuffs") 
		thisOutfitPart = 2

	elseif (deviousKeyword == "zad_DeviousGag") || (deviousKeyword == "Gag") 
		thisOutfitPart = 3

	elseif (deviousKeyword == "zad_DeviousBlindfold") || (deviousKeyword == "Blindfold") 
		thisOutfitPart = 4

	elseif (deviousKeyword == "zad_DeviousBelt") || (deviousKeyword == "Belt") 
		thisOutfitPart = 5

	elseif (deviousKeyword == "zad_DeviousPlugAnal") || (deviousKeyword == "PlugAnal") 
		thisOutfitPart = 6

	elseif (deviousKeyword == "zad_DeviousPlugVaginal") || (deviousKeyword == "PlugVaginal") 
		thisOutfitPart = 7

	else
		Debug.Notification("[SD] unknown non-generic part: " + deviousKeyword)  
	endIf

	return thisOutfitPart
EndFunction

Bool Function isDeviceEquippedString( Actor akActor,  String sDeviceString  )

	Return akActor.WornHasKeyword(getDeviousKeywordByString(sDeviceString))
EndFunction

Bool Function isDeviceEquippedKeyword( Actor akActor,  String sKeyword, String sDeviceString  )
	; Debug.Trace("[SD] isDeviceEquippedKeyword -  getDeviousOutfitPartByString:" + getDeviousOutfitPartByString(sDeviceString))  
	; Debug.Trace("[SD] isDeviceEquippedKeyword -  isDeviousOutfitPartByKeyword:" + isDeviousOutfitPartByKeyword (  akActor, getDeviousOutfitPartByString(sDeviceString), sKeyword ) )  

	Return isDeviousOutfitPartByKeyword (  akActor, getDeviousOutfitPartByString(sDeviceString), sKeyword )
EndFunction

Bool Function isDeviousOutfitPartByKeyword (  Actor akActor, Int iOutfitPart = -1, String deviousKeyword = "zad_Lockable"  )
	Form kForm
	Keyword kKeyword
	Int[] uiSlotMask = New Int[10]
	uiSlotMask[0] = 0x00008000 ;45  Collar / DD Collars / DD Cuffs (Neck)
	uiSlotMask[1] = 0x20000000 ;59  DD Cuffs (Arms) 
	uiSlotMask[2] = 0x00800000 ;53  DD Cuffs (Legs)
	uiSlotMask[3] = 0x00004000 ;44  DD Gags Mouthpieces
	uiSlotMask[4] = 0x02000000 ;55  DD Blindfold
	uiSlotMask[5] = 0x00080000 ;49  DD Chastity Belts
	uiSlotMask[6] = 0x00040000 ;48  DD plugs (Anal)
	uiSlotMask[7]=  0x08000000 ;57  DD Plugs (Vaginal)
	uiSlotMask[8]=  0x00100000 ;50  DD Piercings
	uiSlotMask[9] = 0x00010000 ;46  DD Armbinder  
 

	Int iFormIndex = uiSlotMask.Length 

	If (iOutfitPart>=0)
		kForm = akActor.GetWornForm( uiSlotMask[iOutfitPart] ) 
		If (kForm != None)
			Armor kArmor = kForm  as Armor
			; Debug.Trace("[SD] SetOutfit: test part " + iOutfitPart + " for keyword " +  deviousKeyword   )
			return (kForm.HasKeywordString(deviousKeyword) ) 
		Else
			; Debug.Trace("[SD] SetOutfit: test part " + iOutfitPart + " for keyword " +  deviousKeyword + " - nothing equipped "  )
			Return False
		EndIf

	EndIf
 
	Return False
EndFunction

Function registerDeviousOutfits ( )
	; Collar not registered - contains enchantment secific to SD
	; libs.RegisterGenericDevice(zazIronCollar		, "collar,arms,metal,iron,zap")
	Debug.Trace("[SD] Register devious outfits")

	; These devices can be shared
	libs.RegisterGenericDevice(zazIronCuffs			, "cuffs,arms,metal,iron,zap")
	libs.RegisterGenericDevice(zazIronShackles		, "cuffs,legs,metal,iron,zap")
	libs.RegisterGenericDevice(zazWoodenBit			, "gag,leather,wood,zap")
	libs.RegisterGenericDevice(zazBlinds 			, "blindfold,leather,zap")

EndFunction

Function registerDeviousOutfitsKeywords ( Actor kActor )
	Debug.Trace("[SD] Register devious keywords")
  
	if (StorageUtil.FormListCount( kActor, "_SD_lDevicesKeyword") != 0)
		Debug.Trace("[SD] Register devious keywords - aborting - list already set - " + StorageUtil.FormListCount( kActor, "_SD_lDevicesKeyword"))
		Return
	EndIf	

	; Register list of reference keywords for each device in list
	StorageUtil.FormListAdd( kActor, "_SD_lDevicesKeyword", libs.zad_DeviousCollar) ; 0 - Collar - Unused
	StorageUtil.FormListAdd( kActor, "_SD_lDevicesKeyword", libs.zad_DeviousArmbinder) ; 1 - Arms cuffs
	StorageUtil.FormListAdd( kActor, "_SD_lDevicesKeyword", libs.zad_DeviousLegCuffs ) ; 2 - Legs cuffs
	StorageUtil.FormListAdd( kActor, "_SD_lDevicesKeyword", libs.zad_DeviousGag ) ; 3 - Gag
	StorageUtil.FormListAdd( kActor, "_SD_lDevicesKeyword", libs.zad_DeviousBlindfold ) ; 4 - Blindfold
	StorageUtil.FormListAdd( kActor, "_SD_lDevicesKeyword", libs.zad_DeviousBelt ) ; 5 - Belt
	StorageUtil.FormListAdd( kActor, "_SD_lDevicesKeyword", libs.zad_DeviousPlugAnal) ; 6 - Plug Anal
	StorageUtil.FormListAdd( kActor, "_SD_lDevicesKeyword", libs.zad_DeviousPlugVaginal) ; 7 - Plug Vaginal

EndFunction

; -------------------------------------------------------- Old Functions

Bool Function isArmorRemovable ( Form kForm )
	If ( !kForm  )
	;	Debug.Trace("[SD] Armor: " + kForm )
		Return False
	EndIf

	Bool isLocked = (kForm.HasKeywordString("_SD_nounequip")  || kForm.HasKeywordString("_SD_DeviousSanguine")  || kForm.HasKeywordString("_SD_DeviousSpriggan") || kForm.HasKeywordString("SOS_Underwear")  || kForm.HasKeywordString("SOS_Genitals") || kForm.HasKeywordString("_SLMC_MCdevice") || !SexLab.IsStrippable(kForm) || kForm.HasKeywordString("zad_Lockable") || kForm.HasKeywordString("zad_BlockGeneric") )

	Debug.Trace("[SD] Armor: " + kForm + " - " + kForm.GetNumKeywords())
	; Debug.Trace("[SD] _SD_nounequip: " + kForm.HasKeywordString("_SD_nounequip") )
	; Debug.Trace("[SD] _SD_DeviousSanguine: " + kForm.HasKeywordString("_SD_DeviousSanguine") )
	; Debug.Trace("[SD] _SD_DeviousSpriggan: " + kForm.HasKeywordString("_SD_DeviousSpriggan") )
	; Debug.Trace("[SD] SOS_Underwear: " + kForm.HasKeywordString("SOS_Underwear") )
	; Debug.Trace("[SD] SOS_Genitals: " + kForm.HasKeywordString("SOS_Genitals") )
	; Debug.Trace("[SD] _SLMC_MCdevice: " + kForm.HasKeywordString("_SLMC_MCdevice") )
	Debug.Trace("[SD] SexLabNoStrip: " + kForm.HasKeywordString("SexLabNoStrip") )
	Debug.Trace("[SD] NoStrip: " + SexLab.IsStrippable(kForm) )
	; Debug.Trace("[SD] zad_Lockable: " + kForm.HasKeywordString("zad_Lockable") )
	; Debug.Trace("[SD] VendorNoSale: " + kForm.HasKeywordString("VendorNoSale") )
	Debug.Trace("[SD] isLocked: "+ isLocked)

	Return !isLocked

EndFunction

Int Function countRemovable ( Actor akActor )
	If ( !akActor || akActor.IsDead() )
		Return -1
	EndIf
	
	Int[] uiSlotMask = New Int[7]
	uiSlotMask[0]  = 0x00000004 ;32  Body
	uiSlotMask[1]  = 0x00000008 ;33  Hands
	uiSlotMask[2]  = 0x00000010 ;34  Forearms
	uiSlotMask[3]  = 0x00000080 ;37  Feet
	uiSlotMask[4]  = 0x00000100 ;38  Calves
	uiSlotMask[5]  = 0x00000200 ;39  Shield
	uiSlotMask[6]  = 0x00001000 ;42  Circlet


	Int iRemovable = 0

	Int iFormIndex = uiSlotMask.Length
	While ( iFormIndex > 0 )
		iFormIndex -= 1
		Form kForm = akActor.GetWornForm( uiSlotMask[iFormIndex] ) 

		Armor kArmor = kForm as Armor
		If ( kArmor && isArmorRemovable( kForm ) )
			iRemovable += 1
			Debug.Trace("[SD] Found removable: " + kArmor + " - slot index: " + iFormIndex)
		EndIf
	EndWhile	

	Return iRemovable

EndFunction


Bool Function isWeaponRemovable ( Weapon kWeapon )
	If ( !kWeapon  )
		Return False
	EndIf

	Return (!kWeapon.HasKeywordString("_SD_nounequip")  )

EndFunction

Bool Function isSpellRemovable ( Spell kSpell )
	If ( !kSpell  )
		Return False
	EndIf

	Return (!kSpell.HasKeywordString("_SD_nounequip")  )

EndFunction

Bool Function isShoutRemovable ( Shout kShout )
	If ( !kShout  )
		Return False
	EndIf

	Return (!kShout.HasKeywordString("_SD_nounequip")  )

EndFunction

Bool Function isPunishmentEquipped (  Actor akActor )

	Bool bDeviousDeviceEquipped = isGagEquipped(akActor) || isBlindfoldEquipped(akActor) || isBeltEquipped(akActor) || isPlugEquipped(akActor)

	Return bDeviousDeviceEquipped

EndFunction

Bool Function isRestraintEquipped (  Actor akActor )

	Bool bDeviousDeviceEquipped = isCollarEquipped(akActor) || isBindingEquipped(akActor)

	Return bDeviousDeviceEquipped

EndFunction

Bool Function isBindingEquipped (  Actor akActor )


	if akActor.WornHasKeyword(libs.zad_DeviousArmbinder) || akActor.WornHasKeyword(libs.zad_DeviousLegCuffs)
	  	return True 
	Else
		Return False
	endIf

EndFunction

Bool Function isArmsEquipped (  Actor akActor )


	if akActor.WornHasKeyword(libs.zad_DeviousArmbinder) || akActor.WornHasKeyword(libs.zad_DeviousArmCuffs)
	  	return True 
	Else
		Return False
	endIf

EndFunction


Bool Function isPlugEquipped (  Actor akActor )

	if akActor.WornHasKeyword(libs.zad_DeviousPlugAnal) || akActor.WornHasKeyword(libs.zad_DeviousPlugVaginal)
	  	return True 
	Else
		Return False
	endIf

EndFunction


Bool Function isActorNaked( Actor akActor )
	if akActor.WornHasKeyword(ArmorCuirass) || akActor.WornHasKeyword(ClothingBody)
	  	return True 
	Else
		Return False
	endIf
EndFunction



Bool Function isCollarEquipped (  Actor akActor )

	if akActor.WornHasKeyword(libs.zad_DeviousCollar)
	  	return True 
	Else
		Return False
	endIf

EndFunction



Bool Function isLegsEquipped (  Actor akActor )


	if akActor.WornHasKeyword(libs.zad_DeviousLegCuffs)
	  	return True 
	Else
		Return False
	endIf

EndFunction

Bool Function isArmbinderEquipped (  Actor akActor )

	if akActor.WornHasKeyword(libs.zad_DeviousArmbinder)
	  	return True 
	Else
		Return False
	endIf

EndFunction


Bool Function isCuffsEquipped (  Actor akActor )

	if akActor.WornHasKeyword(libs.zad_DeviousArmCuffs)
	  	return True 
	Else
		Return False
	endIf

EndFunction

Bool Function isYokeEquipped (  Actor akActor )

	if akActor.WornHasKeyword(libs.zad_DeviousYoke)
	  	return True 
	Else
		Return False
	endIf

EndFunction

Bool Function isShacklesEquipped (  Actor akActor )

	if akActor.WornHasKeyword(libs.zad_DeviousLegCuffs)
	  	return True 
	Else
		Return False
	endIf

EndFunction


Bool Function isGagEquipped (  Actor akActor )


	if akActor.WornHasKeyword(libs.zad_DeviousGag)
	  	return True 
	Else
		Return False
	endIf
 
EndFunction

Bool Function isBlindfoldEquipped (  Actor akActor )

	if akActor.WornHasKeyword(libs.zad_DeviousBlindfold)
	  	return True 
	Else
		Return False
	endIf

EndFunction


Bool Function isPlugAnalEquipped (  Actor akActor )

	if akActor.WornHasKeyword(libs.zad_DeviousPlugAnal) 
	  	return True 
	Else
		Return False
	endIf

EndFunction

Bool Function isPlugVaginalEquipped (  Actor akActor )

	if akActor.WornHasKeyword(libs.zad_DeviousPlugVaginal)
	  	return True 
	Else
		Return False
	endIf

EndFunction

Bool Function isBeltEquipped (  Actor akActor )

	if akActor.WornHasKeyword(libs.zad_DeviousBelt)
	  	return True 
	Else
		Return False
	endIf

EndFunction

Bool Function isBraEquipped (  Actor akActor )

	if akActor.WornHasKeyword(libs.zad_DeviousBra)
	  	return True 
	Else
		Return False
	endIf

EndFunction

Bool Function isBootsEquipped (  Actor akActor )

	if akActor.WornHasKeyword(libs.zad_DeviousBoots)
	  	return True 
	Else
		Return False
	endIf

EndFunction

Bool Function isHarnessEquipped (  Actor akActor )

	if akActor.WornHasKeyword(libs.zad_DeviousHarness)
	  	return True 
	Else
		Return False
	endIf

EndFunction

Bool Function isArmorCuirassEquipped( Actor akActor )
	if akActor.WornHasKeyword(ArmorCuirass) 
	  	return True 
	Else
		Return False
	endIf
EndFunction

Bool Function isClothingBodyEquipped( Actor akActor )
	if  akActor.WornHasKeyword(ClothingBody)
	  	return True 
	Else
		Return False
	endIf
EndFunction


Function toggleActorClothing ( Actor akActor, Bool bStrip = True, Bool bDrop = False )
	If ( !akActor || akActor.IsDead() )
		Return
	EndIf
	
	Int[] uiSlotMask = New Int[17]
	uiSlotMask[0]  = 0x00000001 ;30
	uiSlotMask[1]  = 0x00000004 ;32
	uiSlotMask[2]  = 0x00000008 ;33
	uiSlotMask[3]  = 0x00000010 ;34
	uiSlotMask[4]  = 0x00000080 ;37
	uiSlotMask[5]  = 0x00000100 ;38
	uiSlotMask[6]  = 0x00000200 ;39
	uiSlotMask[7]  = 0x00001000 ;42
	uiSlotMask[8]  = 0x00008000 ;45
	uiSlotMask[9]  = 0x00010000 ;46
	uiSlotMask[10] = 0x00020000 ;47
	uiSlotMask[11] = 0x00080000 ;49
	uiSlotMask[12] = 0x00400000 ;52
	uiSlotMask[13] = 0x01000000 ;54
	uiSlotMask[14] = 0x04000000 ;56
	uiSlotMask[15] = 0x08000000 ;57
	uiSlotMask[16] = 0x40000000 ;60	
	Bool bDeviousDeviceEquipped = False
	
	If ( bStrip || bDrop )
		Int iFormIndex = 0 ; uiSlotMask.Length
		; ---- Skip removal of items based on slots because of DD
		While ( iFormIndex > 0 )
			iFormIndex -= 1
			Form kForm = akActor.GetWornForm( uiSlotMask[iFormIndex] ) 

			Armor kArmor = kForm as Armor
			If ( kArmor && isArmorRemovable( kForm ) )
				If ( bDrop )
				;	akActor.DropObject(kArmor as Armor, 1 )
				Else
				;	akActor.UnequipItem(kArmor as Armor, False, True )
				EndIf
			EndIf
		EndWhile	
		; ---- End skipped

		Weapon krHand = akActor.getEquippedWeapon()
		If ( krHand && isWeaponRemovable(krHand) )
			If ( bDrop )
				akActor.DropObject( krHand, 1 )
			Else
				akActor.UnequipItem( krHand, False, True )
			EndIf
		EndIf
		Weapon klHand = akActor.getEquippedWeapon( True )
		If ( klHand &&  isWeaponRemovable(klHand) )
			If ( bDrop )
				akActor.DropObject( klHand, 1 )
			Else
				akActor.UnequipItem( klHand, False, True )
			EndIf
		EndIf
		Armor kShield = akActor.GetEquippedShield()
		If ( kShield && isArmorRemovable( kShield as Form) )
			If ( bDrop )
				akActor.DropObject( kShield, 1 )
			Else
				akActor.UnequipItem( kShield, False, True )
			EndIf
		EndIf
		Shout kShout = akActor.GetEquippedShout()
		If ( kShout && isShoutRemovable( kShout) )
			akActor.UnequipShout( kShout )
		EndIf
		Spell kSpellLeft = akActor.GetEquippedSpell(0)
		If ( kSpellLeft && isSpellRemovable(kSpellLeft) )
			akActor.UnequipSpell( kSpellLeft, 0)
		EndIf
		Spell kSpellRight = akActor.GetEquippedSpell(1)
		If ( kSpellRight && isSpellRemovable(kSpellRight) )
			akActor.UnequipSpell( kSpellRight, 1)
		EndIf
		Spell kSpellOther = akActor.GetEquippedSpell(2)
		If ( kSpellOther && isSpellRemovable(kSpellOther) )
			akActor.UnequipSpell( kSpellOther, 2)
		EndIf
	ElseIf( akActor != Game.GetPlayer() )
		; without having to assign a property
		; this makes this script portable
		Armor ClothesPrisonerShoes = Game.GetFormFromFile( 0x0003CA00, "Skyrim.esm") as Armor
		akActor.AddItem(ClothesPrisonerShoes, 1, true)
		akActor.RemoveItem(ClothesPrisonerShoes, 1, true)
	EndIf
EndFunction


Int Function countDeviousSlotsByKeyword (  Actor akActor, String deviousKeyword = "zad_Lockable" )
 
	Form kForm
	Int[] uiSlotMask = New Int[12]
	uiSlotMask[0] = 0x00008000 ;45  Collar / DD Collars / DD Cuffs (Neck)
	uiSlotMask[1] = 0x20000000 ;59  DD Cuffs (Arms) 
	uiSlotMask[2] = 0x00800000 ;53  DD Cuffs (Legs)
	uiSlotMask[3] = 0x00004000 ;44  DD Gags Mouthpieces
	uiSlotMask[4] = 0x02000000 ;55  DD Blindfold
	uiSlotMask[5] = 0x00080000 ;49  DD Chastity Belts
	uiSlotMask[6] = 0x00040000 ;48  DD plugs (Anal)
	uiSlotMask[7]=  0x08000000 ;57  DD Plugs (Vaginal)
	uiSlotMask[8] = 0x04000000 ;56  DD Chastity Bra
	uiSlotMask[9]= 0x00000004 ;32  Spriggan host
	uiSlotMask[10]= 0x00100000 ;50  DD Gag Straps
	uiSlotMask[11] = 0x00010000 ;46  DD Armbinder 

	Int iFormIndex = uiSlotMask.Length 
	Int devicesCount = 0

	While ( iFormIndex > 0 )
		iFormIndex -= 1
		kForm = akActor.GetWornForm( uiSlotMask[iFormIndex] ) 
 
		If (kForm != None)
			Armor kArmor = kForm  as Armor
			If (kForm.HasKeywordString(deviousKeyword) ) 
				devicesCount = devicesCount + 1
			EndIf
		EndIf

	EndWhile
			
	Debug.Trace("[SD] Count devices slots by keyword " +  deviousKeyword  + " : " + devicesCount )

	Return devicesCount
EndFunction

Function setDeviousOutfitCollar ( Int iDevOutfit =-1, Bool bDevEquip = True, String sDevMessage = "")
	setDeviousOutfitPartByString (iDevOutfit, "Collar", bDevEquip)
EndFunction

Function setDeviousOutfitArms ( Int iDevOutfit =-1, Bool bDevEquip = True, String sDevMessage = "")
	setDeviousOutfitPartByString (iDevOutfit, "Armbinder", bDevEquip)
EndFunction

Function setDeviousOutfitLegs ( Int iDevOutfit =-1, Bool bDevEquip = True, String sDevMessage = "")
	setDeviousOutfitPartByString (iDevOutfit, "LegCuffs", bDevEquip)
EndFunction

Function setDeviousOutfitBelt ( Int iDevOutfit =-1, Bool bDevEquip = True, String sDevMessage = "")
	setDeviousOutfitPartByString (iDevOutfit, "Belt", bDevEquip)
EndFunction

Function setDeviousOutfitGag ( Int iDevOutfit =-1, Bool bDevEquip = True, String sDevMessage = "")
	setDeviousOutfitPartByString (iDevOutfit, "Gag", bDevEquip)
EndFunction

Function setDeviousOutfitBlindfold ( Int iDevOutfit =-1, Bool bDevEquip = True, String sDevMessage = "")
	setDeviousOutfitPartByString (iDevOutfit, "Blindfold", bDevEquip)
EndFunction

Function setDeviousOutfitPlugAnal ( Int iDevOutfit =-1, Bool bDevEquip = True, String sDevMessage = "")
	setDeviousOutfitPartByString (iDevOutfit, "PlugAnal", bDevEquip)
EndFunction

Function setDeviousOutfitPlugVaginal ( Int iDevOutfit =-1, Bool bDevEquip = True, String sDevMessage = "")	
	setDeviousOutfitPartByString (iDevOutfit, "PlugVaginal", bDevEquip)
EndFunction

Function setDeviousOutfitBra ( Int iDevOutfit =-1, Bool bDevEquip = True, String sDevMessage = "")
	setDeviousOutfitPartByString (iDevOutfit, "Bra", bDevEquip)
EndFunction

Function setDeviousOutfitBoots( Int iDevOutfit =-1, Bool bDevEquip = True, String sDevMessage = "")
	setDeviousOutfitPartByString (iDevOutfit, "Boots", bDevEquip)
EndFunction

Function setDeviousOutfitHarness( Int iDevOutfit =-1, Bool bDevEquip = True, String sDevMessage = "")
	setDeviousOutfitPartByString (iDevOutfit, "Harness", bDevEquip)
EndFunction

Function setDeviousOutfitYoke( Int iDevOutfit =-1, Bool bDevEquip = True, String sDevMessage = "")
	setDeviousOutfitPartByString (iDevOutfit, "Yoke", bDevEquip)
EndFunction




Function setDeviousOutfitID ( Int iOutfit, String sMessage = "")
	StorageUtil.SetIntValue(Game.GetPlayer(), "_SD_iOutfit", iOutfit)

	If (sMessage != "")
		Debug.MessageBox(sMessage)
	EndIf
EndFunction


Function setDeviousOutfit ( Int iOutfitID, Int iOutfitPart = -1, Bool bEquip = True, String sMessage = "")
	; iOutfitPart = -1 means 'equip all items in outfit'
	; bEquip = True means 'equip item' (False means remove item)

	Actor kMaster = StorageUtil.GetFormValue(Game.GetPlayer(), "_SD_CurrentOwner") as Actor
	Actor kSlave = Game.GetPlayer() as Actor
	int masterPersonalityType = StorageUtil.GetIntValue(kMaster, "_SD_iPersonalityProfile")
	String sDeviceTags

	Armor ddArmorInventory
	Armor ddArmorRendered
	Keyword ddArmorKeyword
	Bool bDestroy = False

	Debug.Trace("[SD] Slave set - Outfit: " + iOutfitID + " - Part: " + iOutfitPart + " - Equip: " + bEquip )

	; List initialization if it hasn't been set yet
	; int valueCount = StorageUtil.IntListCount(Game.GetPlayer(), "_SD_lSlaveOutfitList")
	; if (valueCount == 0)
	;	valueCount = 10
	;	while(valueCount > 0)
	;		valueCount -= 1
	;		StorageUtil.IntListAdd(Game.GetPlayer(), "_SD_lSlaveOutfitList", -1)
			; Debug.Notification("List[" + valueCount + "] = " + StorageUtil.IntListGet(Game.GetPlayer(), "_SD_lSlaveOutfitList", valueCount))
	;	endwhile
	; EndIf

	; --------------------------------------------------------------------------------------------
	If (iOutfitID <= 2) ; Default outfit - Zaz or DDi slave items based on personality type

		If ( (iOutfitPart==0) || (iOutfitPart==-1) )
			; 0 - Collar - Zaz Iron Collar

			If (masterPersonalityType == 0)
				; 0 - Simple, Common
				ddArmorRendered = zazIronCollarRendered 
				ddArmorInventory = zazIronCollar
				ddArmorKeyword = libs.zad_DeviousCollar 

			ElseIf (masterPersonalityType == 4) ||  (masterPersonalityType == 5)
				; 4 - Gambler, 5 - Caring
				ddArmorRendered = DDiCuffLeatherCollarRendered
				ddArmorInventory = DDiCuffLeatherCollar
				ddArmorKeyword = libs.zad_DeviousCollar 

			ElseIf (masterPersonalityType == 3) ||  (masterPersonalityType == 6)
				; 3 - Sadistic, 6 - Perfectionist
				ddArmorRendered = DDiPostureSteelCollarRendered
				ddArmorInventory = DDiPostureSteelCollar
				ddArmorKeyword = libs.zad_DeviousCollar 

			ElseIf (masterPersonalityType == 1) ||  (masterPersonalityType == 2)
				; 1 - Comfortable , 2 - Horny
				ddArmorRendered = zazLeatherCollarRendered
				ddArmorInventory = zazLEatherCollar
				ddArmorKeyword = libs.zad_DeviousCollar 
			EndIf

			setDeviousOutfitPart ( iOutfitID, iOutfitPart, bEquip,  ddArmorInventory,  ddArmorRendered,  ddArmorKeyword)
		Else
			setDeviousOutfitByTags ( iOutfitID, iOutfitPart, bEquip, sMessage, True  )

		EndIf

	; --------------------------------------------------------------------------------------------
	ElseIf (iOutfitID == 3) ; Primitive outfit - Ropes only (Forsworn, Giants, Hagravens)
		If ( (iOutfitPart==0) || (iOutfitPart==-1) )
			; 0 - Collar - Zaz Iron Collar
			ddArmorRendered = zazIronCollarRendered 
			ddArmorInventory = zazIronCollar
			ddArmorKeyword = libs.zad_DeviousCollar 

			setDeviousOutfitPart ( iOutfitID, iOutfitPart, bEquip,  ddArmorInventory,  ddArmorRendered,  ddArmorKeyword)
		EndIf
		If ( (iOutfitPart==1) || (iOutfitPart==-1) )
			; 1 - Arms - Zaz Iron Cuffs
			ddArmorRendered = zazIronCuffsRendered 
			ddArmorInventory = zazIronCuffs
			ddArmorKeyword = libs.zad_DeviousArmbinder 

			setDeviousOutfitPart ( iOutfitID, iOutfitPart, bEquip,  ddArmorInventory,  ddArmorRendered,  ddArmorKeyword)
		EndIf


	; --------------------------------------------------------------------------------------------
	ElseIf (iOutfitID == 4) ; Spider outfit - Zaz spider web



	; --------------------------------------------------------------------------------------------
	ElseIf (iOutfitID == 5) ; Falmer outfit - Chaurus textured Zaz spider web
		If ( (iOutfitPart==0) || (iOutfitPart==-1) )
			; 0 - Collar - Zaz Iron Collar
			ddArmorRendered = zazIronCollarRendered 
			ddArmorInventory = zazIronCollar
			ddArmorKeyword = libs.zad_DeviousCollar 

			setDeviousOutfitPart ( iOutfitID, iOutfitPart, bEquip,  ddArmorInventory,  ddArmorRendered,  ddArmorKeyword)
		EndIf
		If ( (iOutfitPart==1) || (iOutfitPart==-1) )
			; 1 - Arms - Zaz Iron Cuffs
			ddArmorRendered = zazIronCuffsRendered 
			ddArmorInventory = zazIronCuffs
			ddArmorKeyword = libs.zad_DeviousArmbinder 

			setDeviousOutfitPart ( iOutfitID, iOutfitPart, bEquip,  ddArmorInventory,  ddArmorRendered,  ddArmorKeyword)
		EndIf


	; --------------------------------------------------------------------------------------------
	ElseIf (iOutfitID == 6) ; Animal outfit - Dirt and scratches textures Zaz spider web



	; --------------------------------------------------------------------------------------------
	ElseIf (iOutfitID == 7) ; Spriggan Host outfit - Vegetal armor
		if (!bEquip)
			bDestroy = True
		EndIf

		If ( (iOutfitPart==1) || (iOutfitPart==-1) )
			; 1 - Arms - Spriggan host hands
			ddArmorRendered = zazSprigganHandsRendered 
			ddArmorInventory = zazSprigganHands
			ddArmorKeyword = libs.zad_DeviousArmbinder 

			setDeviousOutfitPart ( iOutfitID, iOutfitPart, bEquip,  ddArmorInventory,  ddArmorRendered,  ddArmorKeyword, bDestroy)
		EndIf
		If ( (iOutfitPart==2) || (iOutfitPart==-1) )
			; 2 - Legs - Spriggan host feet
			ddArmorRendered = zazSprigganFeetRendered 
			ddArmorInventory = zazSprigganFeet
			ddArmorKeyword = libs.zad_DeviousLegCuffs 

			setDeviousOutfitPart ( iOutfitID, iOutfitPart, bEquip,  ddArmorInventory,  ddArmorRendered,  ddArmorKeyword, bDestroy)
		EndIf

		If ( (iOutfitPart==4) || (iOutfitPart==-1) )
			; 4 - Blindfold - Spriggan host mask
			ddArmorRendered = zazSprigganMaskRendered 
			ddArmorInventory = zazSprigganMask
			ddArmorKeyword = libs.zad_DeviousBlindfold 

			setDeviousOutfitPart ( iOutfitID, iOutfitPart, bEquip,  ddArmorInventory,  ddArmorRendered,  ddArmorKeyword, bDestroy)
		EndIf

		If ( (iOutfitPart==5) || (iOutfitPart==-1) )
			; 5 - Belt - Spriggan belt
			ddArmorRendered = zazSprigganBodyRendered
			ddArmorInventory = zazSprigganBody
			ddArmorKeyword = libs.zad_DeviousBelt 

			setDeviousOutfitPart ( iOutfitID, iOutfitPart, bEquip,  ddArmorInventory,  ddArmorRendered,  ddArmorKeyword, bDestroy)
		EndIf



	; --------------------------------------------------------------------------------------------
	ElseIf (iOutfitID == 8) ; Tentacle outfit -  Biological armor



	; --------------------------------------------------------------------------------------------
	ElseIf (iOutfitID == 9) ; Queen of Chaurus outfit - Based on Brood Mother

		If ( (iOutfitPart==6) || (iOutfitPart==-1) )
			; 6 - Plug Anal - Spider eggs cluster
			ddArmorRendered = SDEggAnalRendered
			ddArmorInventory = SDEggAnal
			ddArmorKeyword = libs.zad_DeviousPlugVaginal 

			setDeviousOutfitPart ( iOutfitID, iOutfitPart, bEquip,  ddArmorInventory,  ddArmorRendered,  ddArmorKeyword, bDestroy)
		EndIf

		If ( (iOutfitPart==7) || (iOutfitPart==-1) )
			; 7 - Plug Vaginal - Chaurus worm
			ddArmorRendered = SDEggVaginalRendered
			ddArmorInventory = SDEggVaginal
			ddArmorKeyword = libs.zad_DeviousPlugVaginal 

			setDeviousOutfitPart ( iOutfitID, iOutfitPart, bEquip,  ddArmorInventory,  ddArmorRendered,  ddArmorKeyword, bDestroy)
		EndIf

	; --------------------------------------------------------------------------------------------
	ElseIf (iOutfitID == 10) ; Sanguine Artefacts - Spectral bondage devices
		if (!bEquip)
			bDestroy = True
		EndIf

		If ( (iOutfitPart==0) || (iOutfitPart==-1) )
			; 0 - Collar - Sanguine Bound FX 
			ddArmorRendered = zazSanguineCollarRendered
			ddArmorInventory = zazSanguineCollar
			ddArmorKeyword = libs.zad_DeviousCollar 

			setDeviousOutfitPart ( iOutfitID, iOutfitPart, bEquip,  ddArmorInventory,  ddArmorRendered,  ddArmorKeyword, bDestroy)
		EndIf
		If ( (iOutfitPart==1) || (iOutfitPart==-1) )
			; 1 - Arms - Sanguine Bound FX 
			ddArmorRendered = zazSanguineCuffsRendered
			ddArmorInventory = zazSanguineCuffs
			ddArmorKeyword = libs.zad_DeviousArmbinder 

			setDeviousOutfitPart ( iOutfitID, iOutfitPart, bEquip,  ddArmorInventory,  ddArmorRendered,  ddArmorKeyword, bDestroy)
		EndIf
		If ( (iOutfitPart==2) || (iOutfitPart==-1) )
			; 2 - Legs - Sanguine Bound FX 
			ddArmorRendered = zazSanguineShacklesRendered
			ddArmorInventory = zazSanguineShackles
			ddArmorKeyword = libs.zad_DeviousLegCuffs 

			setDeviousOutfitPart ( iOutfitID, iOutfitPart, bEquip,  ddArmorInventory,  ddArmorRendered,  ddArmorKeyword, bDestroy)
		EndIf
		If ( (iOutfitPart==3) || (iOutfitPart==-1) )
			; 3 - Gag - Sanguine Bound FX 
			ddArmorRendered = zazSanguineWoodenBitRendered
			ddArmorInventory = zazSanguineWoodenBit
			ddArmorKeyword = libs.zad_DeviousGag 

			setDeviousOutfitPart ( iOutfitID, iOutfitPart, bEquip,  ddArmorInventory,  ddArmorRendered,  ddArmorKeyword, bDestroy)
		EndIf
		If ( (iOutfitPart==4) || (iOutfitPart==-1) )
			; 4 - Blindfold
			ddArmorRendered = zazSanguineBlindsRendered
			ddArmorInventory = zazSanguineBlinds
			ddArmorKeyword = libs.zad_DeviousBlindfold 

			setDeviousOutfitPart ( iOutfitID, iOutfitPart, bEquip,  ddArmorInventory,  ddArmorRendered,  ddArmorKeyword, bDestroy)
		EndIf
		If ( (iOutfitPart==5) || (iOutfitPart==-1) )
			; 5 - Belt - DDBelt Iron
			ddArmorRendered = libs.beltIronRendered
			ddArmorInventory = libs.beltIron
			ddArmorKeyword = libs.zad_DeviousBelt 

			setDeviousOutfitPart ( iOutfitID, iOutfitPart, bEquip,  ddArmorInventory,  ddArmorRendered,  ddArmorKeyword, bDestroy)
		EndIf
		If ( (iOutfitPart==6) || (iOutfitPart==-1) )
			; 6 - Plug Anal - DD Soul Gem Plug Anal
			ddArmorRendered = libs.plugSoulgemAnRendered
			ddArmorInventory = libs.plugSoulgemAn
			ddArmorKeyword = libs.zad_DeviousPlugAnal 

			setDeviousOutfitPart ( iOutfitID, iOutfitPart, bEquip,  ddArmorInventory,  ddArmorRendered,  ddArmorKeyword, bDestroy)
		EndIf
		If ( (iOutfitPart==7) || (iOutfitPart==-1) )
			; 7 - Plug Vaginal - Sanguine's Artifact
			ddArmorRendered = zazSanguineArtifactRendered
			ddArmorInventory = zazSanguineArtifact
			ddArmorKeyword = libs.zad_DeviousPiercingsVaginal 

			setDeviousOutfitPart ( iOutfitID, iOutfitPart, bEquip,  ddArmorInventory,  ddArmorRendered,  ddArmorKeyword, bDestroy)
		EndIf

	; --------------------------------------------------------------------------------------------
	ElseIf (iOutfitID == -1) ; No special outfit ID provided... fall back on generic item add/removal
		if (!bEquip)
			bDestroy = True
		EndIf

		setDeviousOutfitByTags ( iOutfitID, iOutfitPart, bEquip, sMessage, True  )

	EndIf

	Utility.Wait(0.5)

	If (sMessage != "")
		Debug.MessageBox(sMessage)
	EndIf

EndFunction


Function setDeviousOutfitPartByString (Int iOutfit = -1, String sDeviceString, Bool bEquip = True, String sMessage = "" , Bool bDestroy = False)
	Actor kSlave = Game.GetPlayer() as Actor
	; Int iOutfit = getDeviousOutfitByString(sOutfitString)
	Int iOutfitPart = getDeviousOutfitPartByString(sDeviceString)
	Keyword kwDeviceKeyword = getDeviousKeywordByString(sDeviceString)

	If (iOutfitPart!=-1) && (iOutfit!=-1)
		; SD Outfit device
		if (kwDeviceKeyword != None)
			if ((!kslave.WornHasKeyword(kwDeviceKeyword)) && (bEquip)) || ((kslave.WornHasKeyword(kwDeviceKeyword)) && (!bEquip))
				; setDeviousOutfitByTags ( iOutfit, iOutfitPart, bEquip, sMessage , bDestroy )
				setDeviousOutfit ( iOutfit, iOutfitPart, bEquip, sMessage )
			endIf
		else
			Debug.Notification("[SD] setDeviousOutfitPartByString - bad keyword - " + sDeviceString)
		endif
	else
		; Generic device
		; setDeviousOutfitByKeyword ( iOutfit, iOutfitPart, kwDeviceKeyword, bEquip, sMessage , bDestroy )

		if (bEquip)
			equipDeviceByString ( sDeviceString )
		else
			clearDeviceByString ( sDeviceString )
		endif 
	endIf

EndFunction

Function setDeviousOutfitByTags ( Int iOutfit, Int iOutfitPart = -1, Bool bEquip = True, String sMessage = "" , Bool bDestroy = False)
	Actor kMaster = StorageUtil.GetFormValue(Game.GetPlayer(), "_SD_CurrentOwner") as Actor
	Actor kSlave = Game.GetPlayer() as Actor
	String sDeviceTags

	Armor ddArmorInventory = None
	Armor ddArmorRendered = None
	Keyword ddArmorKeyword

	If (iOutfitPart!=-1) 
		Debug.Trace("[SD] Set device by tags" )

		If (StorageUtil.GetIntValue(kSlave, "_SD_iEnslaved"))
			Debug.Trace("[SD] Looking in Master list - " + kMaster.getName())
			ddArmorKeyword = StorageUtil.FormListGet( kMaster, "_SD_lDevicesKeyword", iOutfitPart) as Keyword 
		Else
			Debug.Trace("[SD] Looking in Slave list - " + kSlave.getName())
			ddArmorKeyword = StorageUtil.FormListGet( kSlave, "_SD_lDevicesKeyword", iOutfitPart) as Keyword 
		EndIf

		if (ddArmorKeyword==None)
			Debug.Trace("[SD] Keyword not found. Fallback on default. " )
			ddArmorKeyword = getDeviousKeywordByOutfitPart(iOutfitPart)
		endIf

		Debug.Trace("[SD] Device keyword: " + ddArmorKeyword )

		If (bEquip)
			sDeviceTags = StorageUtil.StringListGet(kMaster, "_SD_lDevices", iOutfitPart)  

			Debug.Trace("[SD] Device tags: " + sDeviceTags )

			ddArmorInventory = libs.GetDeviceByTags(ddArmorKeyword, sDeviceTags)
		Else
			ddArmorInventory = libs.GetWornDevice(libs.PlayerRef, ddArmorKeyword)
		EndIf

		Debug.Trace("[SD] Equip: " + bEquip + " - Device inventory: "  + ddArmorInventory  )

		If (ddArmorInventory!=None)
			ddArmorRendered = libs.GetRenderedDevice(ddArmorInventory)
		EndIf

		Debug.Trace("[SD] Device rendered: " + ddArmorRendered  )

		If (ddArmorInventory!=None) && (ddArmorRendered!=None)

			setDeviousOutfitPart ( iOutfit, iOutfitPart, bEquip,  ddArmorInventory,  ddArmorRendered,  ddArmorKeyword, bDestroy)
		Else
			Debug.Trace("[SD] setDeviousOutfitByTags - no device found"  )
		EndIf
	Else
		Debug.Trace("[SD] setDeviousOutfitByTags - no outfit provided"  )

	EndIf

EndFunction

Function setDeviousOutfitByKeyword ( Int iOutfit, Int iOutfitPart = -1, Keyword ddArmorKeyword, Bool bEquip = True, String sMessage = "" , Bool bDestroy = False)
	Actor kMaster = StorageUtil.GetFormValue(Game.GetPlayer(), "_SD_CurrentOwner") as Actor
	Actor kSlave = Game.GetPlayer() as Actor
	String sDeviceTags

	Armor ddArmorInventory = None
	Armor ddArmorRendered = None

	If (iOutfitPart!=-1) 

		Debug.Trace("[SD] Set device by part"  + iOutfitPart + " and keyword: " + ddArmorKeyword )

		If (bEquip)
			sDeviceTags = StorageUtil.StringListGet(kMaster, "_SD_lDevices", iOutfitPart)  

			Debug.Trace("[SD] Device tags: " + sDeviceTags )

			ddArmorInventory = libs.GetDeviceByTags(ddArmorKeyword, sDeviceTags)
		Else
			ddArmorInventory = libs.GetWornDevice(kSlave, ddArmorKeyword)
		EndIf

		Debug.Trace("[SD] Equip: " + bEquip + " - Device inventory: "  + ddArmorInventory  )

		If (ddArmorInventory!=None)
			ddArmorRendered = libs.GetRenderedDevice(ddArmorInventory)
		EndIf

		Debug.Trace("[SD] Device rendered: " + ddArmorRendered  )

		If (ddArmorInventory!=None) && (ddArmorRendered!=None)

			setDeviousOutfitPart ( iOutfit, iOutfitPart, bEquip,  ddArmorInventory,  ddArmorRendered,  ddArmorKeyword, bDestroy)
		Else
			Debug.Trace("[SD] Aborting device update - no device found"  )
		EndIf
	Else
		; If iOutfitPart = -1, use purely generic device functions

		Debug.Trace("[SD] Set device by keyword only: " + ddArmorKeyword )

		libs.ManipulateGenericDeviceByKeyword(kSlave, ddArmorKeyword, bEquip, skipEvents = false, skipMutex = false)

	EndIf

EndFunction

Function setDeviousOutfitPart ( Int iOutfitID, Int iOutfitPart = -1, Bool bEquip = True, Armor ddArmorInventory, Armor ddArmorRendered, Keyword ddArmorKeyword, Bool bDestroy = False)
	Actor kSlave = Game.GetPlayer() as Actor
	Keyword kwWornKeyword

	if (iOutfitPart!=-1) 
		libs.Log("[SD] SetOutfit: ID:" + iOutfitID + " - Part: "  + iOutfitPart + " - Equip: "  + bEquip )

		if (bEquip) 
			kwWornKeyword = getDeviousKeywordByOutfitPart (iOutfitPart )

			if (kwWornKeyword != None)
				if (!kslave.WornHasKeyword(kwWornKeyword))

					libs.Log("[SD] SetOutfit: equip - " + iOutfitID + " [ " + iOutfitPart + "]")
					libs.EquipDevice(libs.PlayerRef, ddArmorInventory , ddArmorRendered , ddArmorKeyword)
				Else
					libs.Log("[SD] SetOutfit: equip - " + iOutfitID + "skipped - device already equipped " )
				EndIf
			Else
				Debug.Notification("[SD] setDeviousOutfitPart - bad outfitpart: " + iOutfitPart )
			endIf

		Else

			If (bDestroy)
				libs.Log("[SD] SetOutfit: destroy - " + iOutfitID + " [ " + iOutfitPart + "] " )

				if libs.PlayerRef.GetItemCount(ddArmorInventory) > 0
	 				libs.RemoveDevice(kSlave, ddArmorInventory , ddArmorRendered , ddArmorKeyword, True, False, True)
	 			Else
	 			 	libs.Log("[SD] No matching item found in inventory - " + ddArmorInventory)
				EndIf
	 			
	 			; libs.ManipulateGenericDeviceByKeyword(libs.PlayerRef, ddArmorKeyword, bEquip, True, False)
			Else
				libs.Log("[SD] SetOutfit: remove - " + iOutfitID + " [ " + iOutfitPart + "] " )

				if kSlave.GetItemCount(ddArmorInventory) > 0
	 				libs.RemoveDevice(kSlave, ddArmorInventory , ddArmorRendered , ddArmorKeyword, False, False, False)
	 			Else
	 			 	libs.Log("[SD] No matching item found in inventory - " + ddArmorInventory)
				EndIf

	 			; libs.ManipulateGenericDeviceByKeyword(libs.PlayerRef, ddArmorKeyword, bEquip, False, False)
			EndIf

		EndIf
	EndIf

EndFunction


Function addPunishment(Bool bDevGag = False, Bool bDevBlindfold = False, Bool bDevBelt = False, Bool bDevPlugAnal = False, Bool bDevPlugVaginal = False, Bool bDevArmbinder = False)
	Debug.Notification("[SD] Call to deprecated addPunishment")
EndFunction

Function addPunishmentDevice(String sDevice)
	Actor kPlayer = Game.getPlayer() as Actor
	Int    playerGender = kPlayer.GetLeveledActorBase().GetSex() as Int
	Actor kMaster = StorageUtil.GetFormValue(Game.GetPlayer(), "_SD_CurrentOwner") as Actor
	Int 	isMasterSpeaking = StorageUtil.GetIntValue(kMaster, "_SD_iSpeakingNPC")

	If (sDevice == "PlugAnal") ; && (isMasterSpeaking==1)
		Debug.MessageBox("'Your ass is still too tight for my taste slave... this will teach you to disobey me.'\n Your owner viciously inserts a cold plug inside your ass." )
		Debug.Trace("[_sdqs_fcts_outfit] Adding punishment item: Anal plug" )
			
		; setDeviousOutfitBelt ( bDevEquip = False, sDevMessage = "")
		; setDeviousOutfitPlugAnal ( bDevEquip = True, sDevMessage = "")
		; setDeviousOutfitBelt ( bDevEquip = True, sDevMessage = "")
		clearDeviceByString ( sDeviceString = "Belt")
		equipDeviceByString ( sDeviceString = "PlugAnal")
		equipDeviceByString ( sDeviceString = "Belt")
	EndIf

	If (sDevice == "PlugVaginal") && (playerGender==1) ; && (isMasterSpeaking==1)
		Debug.MessageBox("'Your are a cunt and need to be treated like one.'\n Your owner smiles wickedly and shoves a cold plug into your abused womb." )
		Debug.Trace("[_sdqs_fcts_outfit] Adding punishment item: Vaginal plug" )
		
		; setDeviousOutfitBelt ( bDevEquip = False, sDevMessage = "")
		; setDeviousOutfitPlugVaginal ( bDevEquip = True, sDevMessage = "")
		; setDeviousOutfitBelt ( bDevEquip = True, sDevMessage = "")
		clearDeviceByString ( sDeviceString = "Belt")
		equipDeviceByString ( sDeviceString = "PlugVaginal")
		equipDeviceByString ( sDeviceString = "Belt")
	EndIf

	; Belt
	If (sDevice == "Belt")  ; && (isMasterSpeaking==1)
		Debug.MessageBox("'Let's watch you squirm... that will change me from your attitude.'\n Your owner locks a chastity belt around your waist, making a point to let the metal pieces bite harshly into your skin." )
		Debug.Trace("[_sdqs_fcts_outfit] Adding punishment item: Belt" )
			
		; setDeviousOutfitBelt ( bDevEquip = True, sDevMessage = "")
		equipDeviceByString ( sDeviceString = "Belt")
	EndIf

	; Blinds
	If (sDevice == "Blindfold")
		Debug.MessageBox("Your owner sternly glares at you and covers your eyes with a blindfold, leaving you helpless." )
		Debug.Trace("[_sdqs_fcts_outfit] Adding punishment item: Blinds" )
			
		; setDeviousOutfitBlindfold ( bDevEquip = True, sDevMessage = "")
		equipDeviceByString ( sDeviceString = "Blindfold")
	EndIf

	; Gag

	If (sDevice == "Gag") ; && (isMasterSpeaking==1)
		Debug.MessageBox("'I don't want to hear one more word from you!'\n Your owner shoves a gag into your mouth to muffle your screams and stop your constant whining." )
		Debug.Trace("[_sdqs_fcts_outfit] Adding punishment item: Gag" )

		; setDeviousOutfitGag ( bDevEquip = True, sDevMessage = "")
		equipDeviceByString ( sDeviceString = "Gag")

	EndIf

EndFunction

Function removePunishment(Bool bDevGag = False, Bool bDevBlindfold = False, Bool bDevBelt = False, Bool bDevPlugAnal = False, Bool bDevPlugVaginal = False, Bool bDevArmbinder = False)
	Debug.Notification("[SD] Call to deprecated removePunishment")
EndFunction

Function removePunishmentDevice(String sDevice)
	Actor kPlayer = Game.getPlayer() as Actor
	Int    playerGender = kPlayer.GetLeveledActorBase().GetSex() as Int
	Actor kMaster = StorageUtil.GetFormValue(Game.GetPlayer(), "_SD_CurrentOwner") as Actor
	Int 	isMasterSpeaking = StorageUtil.GetIntValue(kMaster, "_SD_iSpeakingNPC")

	If (sDevice == "PlugAnal") && !isDeviceEquippedKeyword( kPlayer, "_SD_DeviousParasiteAn", "PlugAnal"  ) ; && (isMasterSpeaking==1)
		Debug.MessageBox("The anal plug is removed, leaving you terribly sore and empty." )
		Debug.Trace("[_sdqs_fcts_outfit] Removing punishment item: Anal plug" )
			
		; setDeviousOutfitBelt ( bDevEquip = False, sDevMessage = "")
		; setDeviousOutfitPlugAnal ( bDevEquip = False, sDevMessage = "")
		; setDeviousOutfitBelt ( bDevEquip = True, sDevMessage = "")
		clearDeviceByString ( sDeviceString = "Belt")
		clearDeviceByString ( sDeviceString = "PlugAnal")
		equipDeviceByString ( sDeviceString = "Belt")
	EndIf

	If (sDevice == "PlugVaginal") && !isDeviceEquippedKeyword( kPlayer, "_SD_DeviousParasiteVag", "PlugVaginal"  ) ; && (isMasterSpeaking==1)
		Debug.MessageBox("The vaginal plug is drenched as it is removed." )
		Debug.Trace("[_sdqs_fcts_outfit] Removing punishment item: Vaginal plug" )
			
		; setDeviousOutfitBelt ( bDevEquip = False, sDevMessage = "")
		; setDeviousOutfitPlugVaginal ( bDevEquip = False, sDevMessage = "")
		; setDeviousOutfitBelt ( bDevEquip = True, sDevMessage = "")
		clearDeviceByString ( sDeviceString = "Belt")
		clearDeviceByString ( sDeviceString = "PlugVaginal")
		equipDeviceByString ( sDeviceString = "Belt")
	EndIf

	; Belt
	If (sDevice == "Belt") ; && (isMasterSpeaking==1)
		Debug.MessageBox("The belt finally lets go of its grasp around your hips." )
		Debug.Trace("[_sdqs_fcts_outfit] Removing punishment item: Belt" )
			
		; setDeviousOutfitBelt ( bDevEquip = False, sDevMessage = "")
		clearDeviceByString ( sDeviceString = "Belt")
	EndIf

	; Blinds
	If (sDevice == "Blindfold")
		Debug.MessageBox("A flood of painful light makes you squint as the blindfold is removed." )
		Debug.Trace("[_sdqs_fcts_outfit] Removing punishment item: Blinds" )
			
		; setDeviousOutfitBlindfold ( bDevEquip = False, sDevMessage = "")
		clearDeviceByString ( sDeviceString = "Blindfold")
	EndIf

	; Gag

	If (sDevice == "Gag") ; && (isMasterSpeaking==1)
		Debug.MessageBox("The gag is finally removed, leaving a screaming pain in your jaw." )
		Debug.Trace("[_sdqs_fcts_outfit] Removing punishment item: Gag "  )

		; setDeviousOutfitGag ( bDevEquip = False, sDevMessage = "")
		clearDeviceByString ( sDeviceString = "Gag")

	EndIf

EndFunction

Function DDSetAnimating( Actor akActor, Bool isAnimating )
	libs.SetAnimating( akActor, isAnimating )
EndFunction

; STRemoveAllSectionTattoo(Form _form, String _section, bool _ignoreLock, bool _silent): remove all tattoos from determined section (ie, the folder name on disk, like "Bimbo")

; STAddTattoo(Form _form, String _section, String _name, int _color, bool _last, bool _silent, int _glowColor, bool _gloss, bool _lock): add a tattoo with more parameters, including glow, gloss (use it to apply makeup, looks much better) and locked tattoos.

function sendSlaveTatModEvent(actor akActor, string sType, string sTatooName, int iColor = 0x99000000)
	; SlaveTats.simple_add_tattoo(bimbo, "Bimbo", "Tramp Stamp", last = false, silent = true)
  	int STevent = ModEvent.Create("STSimpleAddTattoo")  

  	if (STevent) 
        ModEvent.PushForm(STevent, akActor)      	; Form - actor
        ModEvent.PushString(STevent, sType)    	; String - type of tattoo?
        ModEvent.PushString(STevent, sTatooName)  	; String - name of tattoo
        ModEvent.PushInt(STevent, iColor)  			; Int - color
        ModEvent.PushBool(STevent, false)        	; Bool - last = false
        ModEvent.PushBool(STevent, true)         	; Bool - silent = true

        ModEvent.Send(STevent)
  	else
  		Debug.Trace("[_sdqs_fcts_outfit]  Send slave tat event failed.")
	endIf
endfunction


Function toggleActorClothing_old ( Actor akActor, Bool strip = True )
	If ( akActor.IsDead() )
		Return
	EndIf

	; Generally, a quest item has to have the VendorNoSale & MagicDisallowEnchanting
	; keywords to prevent it's sale and to prevent the player from disenchanting  it
	; if it's magical
	; SKSE 1.6.4  GetWornForm not working. Use .UnequipItemSlot( Int )??
	If ( strip )
		Int iFormIndex = ( akActor as ObjectReference ).GetNumItems()
		While ( iFormIndex > 0 )
			iFormIndex -= 1
			Form kForm = ( akActor as ObjectReference ).GetNthForm(iFormIndex)
			If ( kForm.GetType() == 26 && akActor.IsEquipped(kForm) && !kForm.HasKeywordString("VendorNoSale") && !kForm.HasKeywordString("MagicDisallowEnchanting"))
				akActor.UnequipItem(kForm as Armor, False, True )
			EndIf
		EndWhile	

		Weapon krHand = akActor.getEquippedWeapon()
		If ( krHand )
			akActor.UnequipItem( krHand )
		EndIf
		Weapon klHand = akActor.getEquippedWeapon( True )
		If ( klHand )
			akActor.UnequipItem( klHand )
		EndIf
		Shout kShout = akActor.GetEquippedShout()
		If ( kShout )
			akActor.UnequipShout( kShout )
		EndIf
		Spell kSpellLeft = akActor.GetEquippedSpell(0)
		If ( kSpellLeft )
			akActor.UnequipSpell( kSpellLeft, 0)
		EndIf
		Spell kSpellRight = akActor.GetEquippedSpell(1)
		If ( kSpellRight )
			akActor.UnequipSpell( kSpellRight, 1)
		EndIf
		Spell kSpellOther = akActor.GetEquippedSpell(2)
		If ( kSpellOther )
			akActor.UnequipSpell( kSpellOther, 2)
		EndIf
	ElseIf( akActor != Game.GetPlayer() )
		; without having to assign a property
		; this makes this script portable
		Armor ClothesPrisonerShoes = Game.GetFormFromFile( 0x0003CA00, "Skyrim.esm") as Armor
		akActor.AddItem(ClothesPrisonerShoes, 1, true)
		akActor.RemoveItem(ClothesPrisonerShoes, 1, true)
	EndIf
EndFunction


Keyword Property _SDKP_punish Auto
Keyword Property _SDKP_bound Auto
Keyword Property _SDKP_gagged Auto
Keyword Property ArmorCuirass  Auto  
Keyword Property ClothingBody  Auto  

Keyword Property _SDKP_DeviousSanguine  Auto  
Keyword Property _SDKP_DeviousEnslaved  Auto  
Keyword Property _SDKP_DeviousEnslavedCommon  Auto  
Keyword Property _SDKP_DeviousEnslavedMagic  Auto  
Keyword Property _SDKP_DeviousEnslavedPrimitive  Auto  
Keyword Property _SDKP_DeviousEnslavedWealthy  Auto  
Keyword Property _SDKP_DeviousSpriggan  Auto  
Keyword Property _SDKP_DeviousParasiteAn  Auto  
Keyword Property _SDKP_DeviousParasiteVag  Auto  


zadLibs Property libs Auto
SexLabFrameWork Property SexLab Auto

Armor Property DDiPostureSteelCollarRendered Auto         ; Internal Device
Armor Property DDiPostureSteelCollar Auto        	       ; Inventory Device
 
Armor Property DDiCuffLeatherCollarRendered Auto         ; Internal Device
Armor Property DDiCuffLeatherCollar Auto        	       ; Inventory Device
 
Armor Property zazLeatherCollarRendered Auto         ; Internal Device
Armor Property zazLeatherCollar Auto        	       ; Inventory Device
Armor Property zazIronCollarRendered Auto         ; Internal Device
Armor Property zazIronCollar Auto        	       ; Inventory Device
Armor Property zazIronCuffsRendered Auto         ; Internal Device
Armor Property zazIronCuffs Auto        	       ; Inventory Device
Armor Property zazIronShacklesRendered Auto         ; Internal Device
Armor Property zazIronShackles Auto        	       ; Inventory Device
Armor Property zazWoodenBitRendered Auto         ; Internal Device
Armor Property zazWoodenBit Auto        	       ; Inventory Device
Armor Property zazBlindsRendered Auto         ; Internal Device
Armor Property zazBlinds Auto        	       ; Inventory Device

Armor Property zazSprigganHandsRendered Auto         ; Internal Device
Armor Property zazSprigganHands Auto        	       ; Inventory Device
Armor Property zazSprigganFeetRendered Auto         ; Internal Device
Armor Property zazSprigganFeet Auto        	       ; Inventory Device
Armor Property zazSprigganMaskRendered Auto         ; Internal Device
Armor Property zazSprigganMask Auto        	       ; Inventory Device
Armor Property zazSprigganBodyRendered Auto         ; Internal Device
Armor Property zazSprigganBody Auto        	       ; Inventory Device

Armor Property zazSanguineCollarRendered Auto         ; Internal Device
Armor Property zazSanguineCollar Auto        	       ; Inventory Device
Armor Property zazSanguineCuffsRendered Auto         ; Internal Device
Armor Property zazSanguineCuffs Auto        	       ; Inventory Device
Armor Property zazSanguineShacklesRendered Auto         ; Internal Device
Armor Property zazSanguineShackles Auto        	       ; Inventory Device
Armor Property zazSanguineWoodenBitRendered Auto         ; Internal Device
Armor Property zazSanguineWoodenBit Auto        	       ; Inventory Device
Armor Property zazSanguineBlindsRendered Auto         ; Internal Device
Armor Property zazSanguineBlinds Auto        	       ; Inventory Device
Armor Property zazSanguineArtifactRendered Auto         ; Internal Device
Armor Property zazSanguineArtifact Auto        	       ; Inventory Device

Armor Property SDEggVaginalRendered Auto         ; Internal Device
Armor Property SDEggVaginal Auto        	       ; Inventory Device
Armor Property SDEggAnalRendered Auto         ; Internal Device
Armor Property SDEggAnal Auto        	       ; Inventory Device
