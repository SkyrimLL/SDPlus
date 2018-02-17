Scriptname _sdqs_fcts_outfit extends Quest  
{ USED }
Import Utility
Import SKSE
zadLibs Property libs Auto
zadxLibs Property xlibs Auto
SexLabFrameWork Property SexLab Auto

_SDQS_fcts_factions Property fctFactions  Auto

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

Armor Property zazFalmerCollarRendered Auto         ; Internal Device
Armor Property zazFalmerCollar Auto        	       ; Inventory Device
Armor Property zazFalmerCuffsRendered Auto         ; Internal Device
Armor Property zazFalmerCuffs Auto        	       ; Inventory Device

Armor Property zazWebCuffsRendered Auto         ; Internal Device
Armor Property zazWebCuffs Auto        	       ; Inventory Device
Armor Property zazWebCollarRendered Auto         ; Internal Device
Armor Property zazWebCollar Auto        	       ; Inventory Device

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

GlobalVariable Property _SDGVP_gametime  Auto  
Armor Property SDSlaveRags  Auto
Armor Property SDSlaveRags1  Auto
Armor Property SDSlaveRags2  Auto
Armor Property SDSlaveRags3  Auto
Armor Property SDSlaveRags4  Auto
Armor Property SDSlaveRags5  Auto
Armor Property SDSlaveRags6  Auto 

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

Function registerDeviousOutfits ( )
	Debug.Trace("[SD] Register devious outfits")

	if (StorageUtil.FormListFind( libs.zad_DeviousCollar, "zad.GenericDevice", zazLeatherCollar) <0)
		Debug.Trace("[SD] 		Registering leather collar")
		libs.RegisterGenericDevice(zazLeatherCollar		, "collar,leather,zap")
	Endif

	if (StorageUtil.FormListFind( libs.zad_DeviousCollar, "zad.GenericDevice", zazIronCollar) <0)
		Debug.Trace("[SD] 		Registering iron collar")
		libs.RegisterGenericDevice(zazIronCollar		, "collar,metal,iron,zap")
	Endif
	
	if (StorageUtil.FormListFind( libs.zad_DeviousArmbinder, "zad.GenericDevice", zazIronCuffs) <0)
		Debug.Trace("[SD] 		Registering iron arm cuffs")
		libs.RegisterGenericDevice(zazIronCuffs			, "armbinder,arms,metal,iron,zap")
	Endif
	
	if (StorageUtil.FormListFind( libs.zad_DeviousLegCuffs, "zad.GenericDevice", zazIronShackles) <0)
		Debug.Trace("[SD] 		Registering iron leg cuffs")
		libs.RegisterGenericDevice(zazIronShackles		, "cuffs,legs,metal,iron,zap")
	Endif
	
	if (StorageUtil.FormListFind( libs.zad_DeviousGag, "zad.GenericDevice", zazWoodenBit) <0)
		Debug.Trace("[SD] 		Registering wooden gag")
		libs.RegisterGenericDevice(zazWoodenBit			, "gag,leather,wood,zap")
	Endif
	
	if (StorageUtil.FormListFind( libs.zad_DeviousBlindfold, "zad.GenericDevice", zazBlinds) <0)
		Debug.Trace("[SD] 		Registering leather blinds")
		libs.RegisterGenericDevice(zazBlinds 			, "blindfold,leather,zap")
	Endif
	
	; if (StorageUtil.FormListCount( libs.zad_DeviousYoke, "zad.GenericDevice")==0)
	;	Debug.Trace("[SD] Register generic devious devices")
	;	libs.RegisterDevices() 
	; Endif
	
EndFunction


;---------------------------------------------------
; TO DO:
;
; - Add support for forceful removal of racial devices (Sanguine, etc)

;---------------------------------------------------
; For new race based slavery gear


Function initSlaveryGearByRace (  )
; 	For each race in master races storageUtil
;		registerSlaveryOptions( Race, allowCollar, allowArmbinders, allowPunishmentDevice, allowPunishmentScene, allowWhippingScene, defaultStance )
; 		Register devices for slavery gear - collar, armbinders, leg cuffs, belt, vaginal plug, anal plug
;			registerSlaveryGearDevice( Race, deviceString, deviceKeyword, deviceInventory, deviceRendered )

	Int valueCount = StorageUtil.FormListCount(none, "_SD_lRaceMastersList")
	int i = 0
	Form thisRace
 
 	Debug.Trace("[SD] Registering racial slavery gear")

	while(i < valueCount)
		thisRace = StorageUtil.FormListGet(none, "_SD_lRaceMastersList", i)
		Debug.Trace("	Race [" + i + "] = " + thisRace.GetName())
		initSlaveryGearForThisRace ( thisRace )
		i += 1
	endwhile
EndFunction

Function initSlaveryGearByActor ( Actor kActor )
	Form thisRace = kActor.GetRace()
	Bool bIsNewRace = false

	; Add race to potential slavers if not in list yet
	bIsNewRace = fctFactions.initGenericMaster ( kActor )

	if (bIsNewRace)
		; Init slavery gear for that race
		If (StorageUtil.GetStringValue( thisRace, "_SD_sRaceType") == "Beast"  )
			registerSlaveryOptions( fRace=thisRace, allowCollar=1, allowArmbinders=0, allowPunishmentDevice=0, allowPunishmentScene=0, allowWhippingScene=0, defaultStance="Crawling", raceSlaveTat="Hagraven Tribal (breast)", raceSlaveTatDuration=8 )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Collar", deviceKeyword=libs.zad_DeviousCollar, genericDeviceTags="", deviceInventory=zazSanguineCollar, deviceRendered=zazSanguineCollarRendered )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="WristRestraint", deviceKeyword=libs.zad_DeviousHeavyBondage , genericDeviceTags="none" )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="LegCuffs", deviceKeyword=libs.zad_DeviousLegCuffs , genericDeviceTags="none" )
		Else
			registerSlaveryOptions( fRace=thisRace, allowCollar=1, allowArmbinders=1, allowPunishmentDevice=1, allowPunishmentScene=1, allowWhippingScene=1, defaultStance="Kneeling", raceSlaveTat="Redguard Scrawl (belly)" )
			registerSlaveryGearDevice( fRace=thisRace, deviceString="Collar", deviceKeyword=libs.zad_DeviousCollar, genericDeviceTags="collar,metal,padded,zap" )
			registerSlaveryGearDevice( fRace=thisRace, deviceString="WristRestraint", deviceKeyword=libs.zad_DeviousHeavyBondage, genericDeviceTags="armbinder,arms,metal,iron,zap"  )
			registerSlaveryGearDevice( fRace=thisRace, deviceString="LegCuffs", deviceKeyword=libs.zad_DeviousLegCuffs , genericDeviceTags="cuffs,legs,metal,padded,zap" )
			registerSlaveryGearDevice( fRace=thisRace, deviceString="Belt", deviceKeyword=libs.zad_DeviousBelt , genericDeviceTags="belt,metal,iron"  )
			registerSlaveryGearDevice( fRace=thisRace, deviceString="PlugVaginal", deviceKeyword=libs.zad_DeviousPlugVaginal , genericDeviceTags="plug,vaginal,iron"  )
			registerSlaveryGearDevice( fRace=thisRace, deviceString="PlugAnal", deviceKeyword=libs.zad_DeviousPlugAnal , genericDeviceTags="plug,anal,iron"  )
			registerSlaveryGearDevice( fRace=thisRace, deviceString="Gag", deviceKeyword=libs.zad_DeviousGag , genericDeviceTags="gag,leather"  )
			registerSlaveryGearDevice( fRace=thisRace, deviceString="Blindfold", deviceKeyword=libs.zad_DeviousBlindfold, genericDeviceTags="blindfold,leather"  )
		EndIf
	Endif
EndFunction

Function initSlaveryGearForThisRace ( Form thisRace )
	String sRaceName
	Int slaveTatColor = 0 

		sRaceName = thisRace.GetName()

		If (StorageUtil.GetStringValue( thisRace, "_SD_sRaceType") == "Beast"  )
			; Falmer   
			If (StringUtil.Find(sRaceName, "Falmer")!= -1)
				slaveTatColor = Math.LeftShift(255, 24) + Math.LeftShift(0, 16) + Math.LeftShift(204, 8) + 255

				registerSlaveryOptions( fRace=thisRace, allowCollar=1, allowArmbinders=1, allowPunishmentDevice=1, allowPunishmentScene=0, allowWhippingScene=1, defaultStance="Kneeling", raceSlaveTat="Falmer Glow (body)", raceSlaveTatDuration=5, raceSlaveTatColor = slaveTatColor, raceSlaveTatGlow = 1  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Collar", deviceKeyword=libs.zad_DeviousCollar, genericDeviceTags="", deviceInventory=zazFalmerCollar, deviceRendered=zazFalmerCollarRendered  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="WristRestraint", deviceKeyword=libs.zad_DeviousHeavyBondage, genericDeviceTags="", deviceInventory=zazFalmerCuffs, deviceRendered=zazFalmerCuffsRendered   )
				; registerSlaveryGearDevice( fRace=thisRace, deviceString="LegCuffs", deviceKeyword=libs.None, deviceInventory=None, deviceRendered=None  )
				; registerSlaveryGearDevice( fRace=thisRace, deviceString="Belt", deviceKeyword=None, deviceInventory=None, deviceRendered=None  )
				; registerSlaveryGearDevice( fRace=thisRace, deviceString="PlugVaginal", deviceKeyword=libs.None, deviceInventory=None, deviceRendered=None  )
				; registerSlaveryGearDevice( fRace=thisRace, deviceString="PlugAnal", deviceKeyword=libs.None, deviceInventory=None, deviceRendered=None  )
				; registerSlaveryGearDevice( fRace=thisRace, deviceString="Gag", genericDeviceTags=""  )
				; registerSlaveryGearDevice( fRace=thisRace, deviceString="Blindfold", genericDeviceTags=""  )

			; Hagraven    
			ElseIf (StringUtil.Find(sRaceName, "Hagraven")!= -1)
				registerSlaveryOptions( fRace=thisRace, allowCollar=1, allowArmbinders=1, allowPunishmentDevice=1, allowPunishmentScene=1, allowWhippingScene=1, defaultStance="Kneeling", raceSlaveTat="Hagraven Tribal (breast)", raceSlaveTatDuration=8 )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Collar", deviceKeyword=libs.zad_DeviousCollar, genericDeviceTags="collar,rusty,heretic" )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="WristRestraint", deviceKeyword=libs.zad_DeviousHeavyBondage, genericDeviceTags="handcuffs,front,metal,rusty,heretic"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="LegCuffs", deviceKeyword=libs.zad_DeviousLegCuffs , genericDeviceTags="boots,ballet,blocking,metal,rusty,heretic" )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Belt", deviceKeyword=libs.zad_DeviousBelt , genericDeviceTags="belt,metal,iron"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="PlugVaginal", deviceKeyword=libs.zad_DeviousPlugVaginal , genericDeviceTags="plug,vaginal,soulgem"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="PlugAnal", deviceKeyword=libs.zad_DeviousPlugAnal , genericDeviceTags="plug,anal,soulgem"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Gag", deviceKeyword=libs.zad_DeviousGag , genericDeviceTags="gag,leather,zap"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Blindfold", deviceKeyword=libs.zad_DeviousBlindfold, genericDeviceTags="blindfold,leather,zap"  )

			; Wolf   
			ElseIf (StringUtil.Find(sRaceName, "Wolf")!= -1)
				registerSlaveryOptions( fRace=thisRace, allowCollar=1, allowArmbinders=0, allowPunishmentDevice=0, allowPunishmentScene=0, allowWhippingScene=0, defaultStance="Crawling", raceSlaveTat="Wolf scratches (back)", raceSlaveTatDuration=5 )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Collar", deviceKeyword=libs.zad_DeviousCollar, genericDeviceTags="", deviceInventory=zazSanguineCollar, deviceRendered=zazSanguineCollarRendered )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="WristRestraint", deviceKeyword=libs.zad_DeviousHeavyBondage , genericDeviceTags="none" )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="LegCuffs", deviceKeyword=libs.zad_DeviousLegCuffs , genericDeviceTags="none" )

			; Dog    
			ElseIf (StringUtil.Find(sRaceName, "Dog")!= -1)
				registerSlaveryOptions( fRace=thisRace, allowCollar=1, allowArmbinders=0, allowPunishmentDevice=0, allowPunishmentScene=0, allowWhippingScene=0, defaultStance="Crawling", raceSlaveTat="Dog scratches (breast)", raceSlaveTatDuration=5 )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Collar", deviceKeyword=libs.zad_DeviousCollar, genericDeviceTags="", deviceInventory=zazSanguineCollar, deviceRendered=zazSanguineCollarRendered )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="WristRestraint", deviceKeyword=libs.zad_DeviousHeavyBondage , genericDeviceTags="none" )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="LegCuffs", deviceKeyword=libs.zad_DeviousLegCuffs , genericDeviceTags="none" )

			; SaberCat    
			ElseIf (StringUtil.Find(sRaceName, "Cat")!= -1)
				registerSlaveryOptions( fRace=thisRace, allowCollar=1, allowArmbinders=0, allowPunishmentDevice=0, allowPunishmentScene=0, allowWhippingScene=0, defaultStance="Crawling", raceSlaveTat="Wolf scratches (breast)", raceSlaveTatDuration=5 )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Collar", deviceKeyword=libs.zad_DeviousCollar, genericDeviceTags="", deviceInventory=zazSanguineCollar, deviceRendered=zazSanguineCollarRendered )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="WristRestraint", deviceKeyword=libs.zad_DeviousHeavyBondage , genericDeviceTags="none" )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="LegCuffs", deviceKeyword=libs.zad_DeviousLegCuffs , genericDeviceTags="none" )

			; Bear    
			ElseIf (StringUtil.Find(sRaceName, "Bear")!= -1)
				registerSlaveryOptions( fRace=thisRace, allowCollar=1, allowArmbinders=0, allowPunishmentDevice=0, allowPunishmentScene=0, allowWhippingScene=0, defaultStance="Crawling", raceSlaveTat="Troll Bites (body)", raceSlaveTatDuration=5 )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Collar", deviceKeyword=libs.zad_DeviousCollar, genericDeviceTags="", deviceInventory=zazSanguineCollar, deviceRendered=zazSanguineCollarRendered )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="WristRestraint", deviceKeyword=libs.zad_DeviousHeavyBondage , genericDeviceTags="none" )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="LegCuffs", deviceKeyword=libs.zad_DeviousLegCuffs , genericDeviceTags="none" )

			; Giant   
			ElseIf (StringUtil.Find(sRaceName, "Giant")!= -1)
				registerSlaveryOptions( fRace=thisRace, allowCollar=1, allowArmbinders=0, allowPunishmentDevice=0, allowPunishmentScene=0, allowWhippingScene=0, defaultStance="Standing", raceSlaveTat="Giant Paint (body)", raceSlaveTatDuration=20 )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Collar", deviceKeyword=libs.zad_DeviousCollar, genericDeviceTags="", deviceInventory=zazIronCollar, deviceRendered=zazIronCollarRendered )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="WristRestraint", deviceKeyword=libs.zad_DeviousHeavyBondage, genericDeviceTags="armbinder,arms,metal,iron,zap"  )
			; Chaurus   
			ElseIf (StringUtil.Find(sRaceName, "Chaurus")!= -1)
				registerSlaveryOptions( fRace=thisRace, allowCollar=1, allowArmbinders=0, allowPunishmentDevice=0, allowPunishmentScene=0, allowWhippingScene=0, defaultStance="Crawling", raceSlaveTat="Chaurus Vaginal (body)", raceSlaveTatDuration=2 )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Collar", deviceKeyword=libs.zad_DeviousCollar, genericDeviceTags="", deviceInventory=zazWebCollar, deviceRendered=zazWebCollarRendered )  ; ADD Chaurus slimy collar later
				registerSlaveryGearDevice( fRace=thisRace, deviceString="WristRestraint", deviceKeyword=libs.zad_DeviousHeavyBondage , genericDeviceTags="none" )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="LegCuffs", deviceKeyword=libs.zad_DeviousLegCuffs , genericDeviceTags="none" )

			; Spider    
			ElseIf (StringUtil.Find(sRaceName, "Spider")!= -1)
				registerSlaveryOptions( fRace=thisRace, allowCollar=1, allowArmbinders=0, allowPunishmentDevice=0, allowPunishmentScene=0, allowWhippingScene=0, defaultStance="Crawling", raceSlaveTat="Spider Anal (butt)", raceSlaveTatDuration=2 )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Collar", deviceKeyword=libs.zad_DeviousCollar, genericDeviceTags="", deviceInventory=zazWebCollar, deviceRendered=zazWebCollarRendered )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="WristRestraint", deviceKeyword=libs.zad_DeviousHeavyBondage , genericDeviceTags="none" )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="LegCuffs", deviceKeyword=libs.zad_DeviousLegCuffs , genericDeviceTags="none" )

			; Troll   
			ElseIf (StringUtil.Find(sRaceName, "Troll")!= -1)
				registerSlaveryOptions( fRace=thisRace, allowCollar=1, allowArmbinders=0, allowPunishmentDevice=0, allowPunishmentScene=0, allowWhippingScene=0, defaultStance="Crawling", raceSlaveTat="Troll Bites (body)", raceSlaveTatDuration=3 )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Collar", deviceKeyword=libs.zad_DeviousCollar, genericDeviceTags="", deviceInventory=zazIronCollar, deviceRendered=zazIronCollarRendered )  ; ADD Troll rusted collar later
				registerSlaveryGearDevice( fRace=thisRace, deviceString="WristRestraint", deviceKeyword=libs.zad_DeviousHeavyBondage , genericDeviceTags="none" )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="LegCuffs", deviceKeyword=libs.zad_DeviousLegCuffs , genericDeviceTags="none" )

			; Draugr    
			ElseIf (StringUtil.Find(sRaceName, "Draugr")!= -1)
				slaveTatColor = Math.LeftShift(255, 24) + Math.LeftShift(100, 51) + Math.LeftShift(100, 102) + 153

				registerSlaveryOptions( fRace=thisRace, allowCollar=1, allowArmbinders=1, allowPunishmentDevice=1, allowPunishmentScene=0, allowWhippingScene=1, defaultStance="Kneeling", raceSlaveTat="Draugr Runes (breast)", raceSlaveTatDuration=20, raceSlaveTatColor = slaveTatColor, raceSlaveTatGlow = 1  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Collar", deviceKeyword=libs.zad_DeviousCollar, genericDeviceTags="", deviceInventory=zazIronCollar, deviceRendered=zazIronCollarRendered )  ; ADD Draugr ancient collar later
				registerSlaveryGearDevice( fRace=thisRace, deviceString="WristRestraint", deviceKeyword=libs.zad_DeviousHeavyBondage, genericDeviceTags="armbinder,arms,metal,iron,zap"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="LegCuffs", deviceKeyword=libs.zad_DeviousLegCuffs , genericDeviceTags="cuffs,legs,metal,iron,zap" )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Belt", deviceKeyword=libs.zad_DeviousBelt , genericDeviceTags="belt,metal,iron"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="PlugVaginal", deviceKeyword=libs.zad_DeviousPlugVaginal , genericDeviceTags="plug,vaginal,metal,rusty,pear,heretic"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="PlugAnal", deviceKeyword=libs.zad_DeviousPlugAnal , genericDeviceTags="plug,anal,metal,rusty,pear,heretic"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Gag", deviceKeyword=libs.zad_DeviousGag , genericDeviceTags="gag,strap,bit,rusty,heretic"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Blindfold", deviceKeyword=libs.zad_DeviousBlindfold, genericDeviceTags="blindfold,leather,zap"  )
			endif
		endIf

		If (StorageUtil.GetStringValue( thisRace, "_SD_sRaceType") == "Humanoid"  )
			; Nord  
			If (StringUtil.Find(sRaceName, "Nord")!= -1)
				registerSlaveryOptions( fRace=thisRace, allowCollar=1, allowArmbinders=1, allowPunishmentDevice=1, allowPunishmentScene=1, allowWhippingScene=1, defaultStance="Kneeling", raceSlaveTat="Nord Ankle (leg)" )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Collar", deviceKeyword=libs.zad_DeviousCollar, genericDeviceTags="collar,metal,iron,zap" )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="WristRestraint", deviceKeyword=libs.zad_DeviousHeavyBondage, genericDeviceTags="armbinder,arms,metal,iron,zap"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="LegCuffs", deviceKeyword=libs.zad_DeviousLegCuffs , genericDeviceTags="cuffs,legs,metal,iron,zap" )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Belt", deviceKeyword=libs.zad_DeviousBelt , genericDeviceTags="belt,metal,iron"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="PlugVaginal", deviceKeyword=libs.zad_DeviousPlugVaginal , genericDeviceTags="plug,vaginal,primitive"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="PlugAnal", deviceKeyword=libs.zad_DeviousPlugAnal , genericDeviceTags="plug,anal,primitive"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Gag", deviceKeyword=libs.zad_DeviousGag , genericDeviceTags="gag,leather,zap"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Blindfold", deviceKeyword=libs.zad_DeviousBlindfold, genericDeviceTags="blindfold,leather,zap"  )

			; Breton
			ElseIf (StringUtil.Find(sRaceName, "Breton")!= -1)
				registerSlaveryOptions( fRace=thisRace, allowCollar=1, allowArmbinders=1, allowPunishmentDevice=1, allowPunishmentScene=1, allowWhippingScene=1, defaultStance="Kneeling", raceSlaveTat="Breton Wheel (belly)" )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Collar", deviceKeyword=libs.zad_DeviousCollar, genericDeviceTags="collar,metal" )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="WristRestraint", deviceKeyword=libs.zad_DeviousHeavyBondage, genericDeviceTags="armbinder,arms,metal,iron,zap"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="LegCuffs", deviceKeyword=libs.zad_DeviousLegCuffs , genericDeviceTags="cuffs,legs,metal,iron,zap" )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Belt", deviceKeyword=libs.zad_DeviousBelt , genericDeviceTags="belt,metal,iron"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="PlugVaginal", deviceKeyword=libs.zad_DeviousPlugVaginal , genericDeviceTags="plug,vaginal,iron"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="PlugAnal", deviceKeyword=libs.zad_DeviousPlugAnal , genericDeviceTags="plug,anal,iron"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Gag", deviceKeyword=libs.zad_DeviousGag , genericDeviceTags="gag,leather,zap"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Blindfold", deviceKeyword=libs.zad_DeviousBlindfold, genericDeviceTags="blindfold,leather,zap"  )

			; Imperial
			ElseIf (StringUtil.Find(sRaceName, "Imperial")!= -1)
				registerSlaveryOptions( fRace=thisRace, allowCollar=1, allowArmbinders=1, allowPunishmentDevice=1, allowPunishmentScene=1, allowWhippingScene=1, defaultStance="Kneeling", raceSlaveTat="Imperial Stamp (butt)" )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Collar", deviceKeyword=libs.zad_DeviousCollar, genericDeviceTags="collar,harness,leather,black" )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="WristRestraint", deviceKeyword=libs.zad_DeviousHeavyBondage, genericDeviceTags="armbinder,leather,black"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="LegCuffs", deviceKeyword=libs.zad_DeviousLegCuffs , genericDeviceTags="cuffs,legs,leather,black" )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Belt", deviceKeyword=libs.zad_DeviousBelt , genericDeviceTags="belt,padded"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="PlugVaginal", deviceKeyword=libs.zad_DeviousPlugVaginal , genericDeviceTags="plug,vaginal,inflatable"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="PlugAnal", deviceKeyword=libs.zad_DeviousPlugAnal , genericDeviceTags="plug,anal,inflatable"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Gag", deviceKeyword=libs.zad_DeviousGag , genericDeviceTags="gag,harness,black"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Blindfold", deviceKeyword=libs.zad_DeviousBlindfold, genericDeviceTags="blindfold,leather,black"  )

			; Redguard
			ElseIf (StringUtil.Find(sRaceName, "Redguard")!= -1)
				registerSlaveryOptions( fRace=thisRace, allowCollar=1, allowArmbinders=1, allowPunishmentDevice=1, allowPunishmentScene=1, allowWhippingScene=1, defaultStance="Kneeling", raceSlaveTat="Redguard Scrawl (belly)" )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Collar", deviceKeyword=libs.zad_DeviousCollar, genericDeviceTags="collar,metal,padded,zap" )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="WristRestraint", deviceKeyword=libs.zad_DeviousHeavyBondage, genericDeviceTags="DDi,yoke,metal"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="LegCuffs", deviceKeyword=libs.zad_DeviousLegCuffs , genericDeviceTags="cuffs,legs,metal,padded,zap" )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Belt", deviceKeyword=libs.zad_DeviousBelt , genericDeviceTags="belt,metal,iron"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="PlugVaginal", deviceKeyword=libs.zad_DeviousPlugVaginal , genericDeviceTags="plug,vaginal,iron"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="PlugAnal", deviceKeyword=libs.zad_DeviousPlugAnal , genericDeviceTags="plug,anal,iron"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Gag", deviceKeyword=libs.zad_DeviousGag , genericDeviceTags="gag,leather"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Blindfold", deviceKeyword=libs.zad_DeviousBlindfold, genericDeviceTags="blindfold,leather"  )

			; Orc
			ElseIf (StringUtil.Find(sRaceName, "Orc")!= -1)
				registerSlaveryOptions( fRace=thisRace, allowCollar=1, allowArmbinders=1, allowPunishmentDevice=1, allowPunishmentScene=1, allowWhippingScene=1, defaultStance="Kneeling", raceSlaveTat="Orc Scrawl (head)" )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Collar", deviceKeyword=libs.zad_DeviousCollar, genericDeviceTags="collar,short,metal,rusty,heretic,ddx" )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="WristRestraint", deviceKeyword=libs.zad_DeviousHeavyBondage, genericDeviceTags="yoke,metal,steel,zaz,ddx"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="LegCuffs", deviceKeyword=libs.zad_DeviousLegCuffs , genericDeviceTags="cuffs,legs,metal,iron,zap" )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Belt", deviceKeyword=libs.zad_DeviousBelt , genericDeviceTags="belt,metal,iron"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="PlugVaginal", deviceKeyword=libs.zad_DeviousPlugVaginal , genericDeviceTags="plug,vaginal,iron"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="PlugAnal", deviceKeyword=libs.zad_DeviousPlugAnal , genericDeviceTags="plug,anal,iron"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Gag", deviceKeyword=libs.zad_DeviousGag , genericDeviceTags="gag,strap,bit,iron,heretic,ddx"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Blindfold", deviceKeyword=libs.zad_DeviousBlindfold, genericDeviceTags="blindfold,leather"  )

			; Elf
			ElseIf (StringUtil.Find(sRaceName, "Elf")!= -1)
				registerSlaveryOptions( fRace=thisRace, allowCollar=1, allowArmbinders=1, allowPunishmentDevice=1, allowPunishmentScene=1, allowWhippingScene=1, defaultStance="Kneeling", raceSlaveTat="Elf Slavers Hand (back)" )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Collar", deviceKeyword=libs.zad_DeviousCollar, genericDeviceTags="collar,posture,leather,red" )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="WristRestraint", deviceKeyword=libs.zad_DeviousHeavyBondage, genericDeviceTags="armbinder,leather,red"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="LegCuffs", deviceKeyword=libs.zad_DeviousLegCuffs , genericDeviceTags="cuffs,legs,leather,red" )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Belt", deviceKeyword=libs.zad_DeviousBelt , genericDeviceTags="belt,metal,padded"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="PlugVaginal", deviceKeyword=libs.zad_DeviousPlugVaginal , genericDeviceTags="plug,vaginal,soulgem"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="PlugAnal", deviceKeyword=libs.zad_DeviousPlugAnal , genericDeviceTags="plug,anal,soulgem"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Gag", deviceKeyword=libs.zad_DeviousGag , genericDeviceTags="gag,leather,red"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Blindfold", deviceKeyword=libs.zad_DeviousBlindfold, genericDeviceTags="blindfold,leather,red"  )

			; Khajit
			ElseIf (StringUtil.Find(sRaceName, "Khajiit")!= -1)
				registerSlaveryOptions( fRace=thisRace, allowCollar=1, allowArmbinders=1, allowPunishmentDevice=1, allowPunishmentScene=1, allowWhippingScene=1, defaultStance="Kneeling", raceSlaveTat="Khajiit Slavers Hand (back)" )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Collar", deviceKeyword=libs.zad_DeviousCollar, genericDeviceTags="collar,leather,zap" )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="WristRestraint", deviceKeyword=libs.zad_DeviousHeavyBondage, genericDeviceTags="handcuffs,front,metal,rusty,heretic,ddx"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="LegCuffs", deviceKeyword=libs.zad_DeviousLegCuffs , genericDeviceTags="cuffs,legs,metal,iron,zap" )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Belt", deviceKeyword=libs.zad_DeviousBelt , genericDeviceTags="belt,metal,iron"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="PlugVaginal", deviceKeyword=libs.zad_DeviousPlugVaginal , genericDeviceTags="plug,vaginal,primitive"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="PlugAnal", deviceKeyword=libs.zad_DeviousPlugAnal , genericDeviceTags="plug,anal,primitive"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Gag", deviceKeyword=libs.zad_DeviousGag , genericDeviceTags="gag,leather,zap"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Blindfold", deviceKeyword=libs.zad_DeviousBlindfold, genericDeviceTags="blindfold,leather,zap"  )

			; Argonian
			ElseIf (StringUtil.Find(sRaceName, "Argonian")!= -1)
				registerSlaveryOptions( fRace=thisRace, allowCollar=1, allowArmbinders=1, allowPunishmentDevice=1, allowPunishmentScene=1, allowWhippingScene=1, defaultStance="Kneeling", raceSlaveTat="Argonian Slavers Hand (belly)" )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Collar", deviceKeyword=libs.zad_DeviousCollar, genericDeviceTags="collar,short,metal,iron,heretic,ddx" )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="WristRestraint", deviceKeyword=libs.zad_DeviousHeavyBondage, genericDeviceTags="yoke,arms,metal,iron,zap"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="LegCuffs", deviceKeyword=libs.zad_DeviousLegCuffs , genericDeviceTags="cuffs,legs,metal,iron,zap" )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Belt", deviceKeyword=libs.zad_DeviousBelt , genericDeviceTags="belt,metal,iron"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="PlugVaginal", deviceKeyword=libs.zad_DeviousPlugVaginal , genericDeviceTags="plug,vaginal,simple,locking,metal,rusty,pear,bell,heretic,ddx"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="PlugAnal", deviceKeyword=libs.zad_DeviousPlugAnal , genericDeviceTags="plug,anal,simple,locking,metal,rusty,pear,heretic,ddx"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Gag", deviceKeyword=libs.zad_DeviousGag , genericDeviceTags="gag,strap,bit,rusty,heretic,ddx"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Blindfold", deviceKeyword=libs.zad_DeviousBlindfold, genericDeviceTags="blindfold,leather,zap"  )

			; Dremora
			ElseIf (StringUtil.Find(sRaceName, "Dremora")!= -1)
				slaveTatColor = Math.LeftShift(255, 24) + Math.LeftShift(255, 16) + Math.LeftShift(0, 8) + 0

				registerSlaveryOptions( fRace=thisRace, allowCollar=1, allowArmbinders=1, allowPunishmentDevice=1, allowPunishmentScene=1, allowWhippingScene=1, defaultStance="Kneeling", raceSlaveTat="Dremora Mark (body)", raceSlaveTatDuration=10, raceSlaveTatColor = slaveTatColor, raceSlaveTatGlow = 1 )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Collar", deviceKeyword=libs.zad_DeviousCollar, genericDeviceTags="", deviceInventory=zazSanguineCollar, deviceRendered=zazSanguineCollarRendered )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="WristRestraint", deviceKeyword=libs.zad_DeviousHeavyBondage , genericDeviceTags="", deviceInventory=zazSanguineCuffs, deviceRendered=zazSanguineCuffsRendered )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="LegCuffs", deviceKeyword=libs.zad_DeviousLegCuffs , genericDeviceTags="", deviceInventory=zazSanguineShackles, deviceRendered=zazSanguineShacklesRendered )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Belt", deviceKeyword=libs.zad_DeviousBelt , genericDeviceTags="belt,metal,iron"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="PlugVaginal", deviceKeyword=libs.zad_DeviousPlugVaginal , genericDeviceTags="plug,vaginal,soulgem"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="PlugAnal", deviceKeyword=libs.zad_DeviousPlugAnal , genericDeviceTags="plug,anal,soulgem"  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Gag", deviceKeyword=libs.zad_DeviousGag  , genericDeviceTags="", deviceInventory=zazSanguineWoodenBit , deviceRendered=zazSanguineWoodenBitRendered  )
				registerSlaveryGearDevice( fRace=thisRace, deviceString="Blindfold", deviceKeyword=libs.zad_DeviousBlindfold  , genericDeviceTags="blindfold,leather,zap"  )

			endif
		endif
EndFunction


Function registerSlaveryOptions ( Form fRace, Bool allowCollar, Bool allowArmbinders, Bool allowPunishmentDevice, Bool allowPunishmentScene, Bool allowWhippingScene, String defaultStance, String raceSlaveTat, Int raceSlaveTatDuration = 0 , Int raceSlaveTatColor = 0, Int raceSlaveTatGlow = 0 )
; 	For this Race
;		Set options: allowCollar, allowArmbinders, allowPunishmentDevice, allowPunishmentScene, allowWhippingScene, defaultStance, raceSlaveTat
;			
;		Later - if device not defined for race, use generic or spectral
	Debug.Trace("		Slavery Options")

	StorageUtil.SetIntValue(fRace, "_SD_iSlaveryCollarOn", allowCollar as Int)
	StorageUtil.SetIntValue(fRace, "_SD_iSlaveryBindingsOn", allowArmbinders as Int)
	StorageUtil.SetIntValue(fRace, "_SD_iSlaveryPunishmentOn", allowPunishmentDevice as Int)
	StorageUtil.SetIntValue(fRace, "_SD_iSlaveryPunishmentSceneOn", allowPunishmentDevice as Int)
	StorageUtil.SetIntValue(fRace, "_SD_iSlaveryWhippingSceneOn", allowPunishmentDevice as Int)
	StorageUtil.SetIntValue(fRace, "_SD_iSlaveryTatDuration", raceSlaveTatDuration )
	StorageUtil.SetIntValue(fRace, "_SD_iSlaveryTatColor", raceSlaveTatColor )
	StorageUtil.SetIntValue(fRace, "_SD_iSlaveryTatGlow", raceSlaveTatGlow )
	StorageUtil.SetStringValue(fRace, "_SD_sSlaveryExpectedStance", defaultStance)
	StorageUtil.SetStringValue(fRace, "_SD_sSlaveryDefaultStance", defaultStance)
	StorageUtil.SetStringValue(fRace, "_SD_sSlaveryTat", raceSlaveTat)
	StorageUtil.SetStringValue(fRace, "_SD_sSlaveryTatType", "SD+")

EndFunction

Function registerSlaveryGearDevice( Form fRace, String deviceString, Keyword deviceKeyword, String genericDeviceTags="", Armor deviceInventory=None, Armor deviceRendered=None )
; 		Register devices for slavery gear - collar, armbinders, leg cuffs, belt, vaginal plug, anal plug
	Debug.Trace("		Slavery device - " + deviceString + " - keyword: " + deviceKeyword + " - tags: " + genericDeviceTags)

	StorageUtil.SetFormValue(fRace, "_SD_" + deviceString + "_keyword", deviceKeyword as Form)
	StorageUtil.SetFormValue(fRace, "_SD_" + deviceString + "_inventory", deviceInventory as Form)
	StorageUtil.SetFormValue(fRace, "_SD_" + deviceString + "_rendered", deviceRendered as Form)
	StorageUtil.SetStringValue(fRace, "_SD_" + deviceString + "_tags", genericDeviceTags)



EndFunction

Function setMasterGearByRace ( Actor kMaster, Actor kSlave  )
;	Set enslavement options + default slavery gear items based on race
;	If race not listed and actorNPC keyword is found, use default gear
	form masterRace
	Actor slaveryGearActor = StorageUtil.GetFormValue(kSlave, "_SD_fSlaveryGearActor") as Actor

	if (kMaster != none) 
		ActorBase akActorBase = kMaster.GetLeveledActorBase() as ActorBase

		if (slaveryGearActor != kMaster)
			; Form masterRace = akActorBase.GetRace() as Form
			masterRace = fctFactions.findMatchingRace( kMaster )

			Debug.Trace("[SD] setMasterGearByRace -- Setting race to " + masterRace)

			StorageUtil.SetFormValue(kSlave, "_SD_fSlaveryGearRace", masterRace)
			StorageUtil.SetFormValue(kSlave, "_SD_fSlaveryGearActor", kMaster)
		endif
	else
		; Use this to force default set if necessary later - for now, going with 'none' to force generic devices instead
		; StorageUtil.SetFormValue(kSlave, "_SD_fSlaveryGearRace", StorageUtil.GetFormValue(none, "_SD_fDefaultSlaveryRace") )

		StorageUtil.SetFormValue(kSlave, "_SD_fSlaveryGearRace", none ) ; 
		StorageUtil.SetFormValue(kSlave, "_SD_fSlaveryGearActor", none)
	endIf


EndFunction

;---------------------------------------------------

Function equipDeviceByString ( String sDeviceString = "", String sOutfitString = "", bool skipEvents = false, bool skipMutex = false,  String sDeviceTags = "")
	Keyword kwDeviceKeyword = none
	Actor PlayerActor = Game.GetPlayer()
	Actor kMaster = None
	Armor aWornDevice = none
	Armor aRenderedDevice = none
	String sGenericDeviceTags = ""
	String sDeviceTagsOverride = ""
	Form kForm	
	Form fRaceOverride = StorageUtil.GetFormValue(PlayerActor, "_SD_fSlaveryGearRace")
	Form fActorOverride = StorageUtil.GetFormValue(PlayerActor, "_SD_fSlaveryGearActor")
	Bool bDeviceOverride = False
	Bool bDeviceEquipSuccess = False

	; If master Race is set, check if override device is set for this race and use it first

	If ( fActorOverride!= none)
		; Debug.Trace("[SD] equipDeviceByString - Actor override detected")  
		if (StorageUtil.GetFormValue(fActorOverride, "_SD_" + sDeviceString + "_keyword")!=none)
			Debug.Trace("[SD] 	- Actor override detected for " + sDeviceString)  
			bDeviceOverride = True
			kwDeviceKeyword = 	StorageUtil.GetFormValue(fActorOverride, "_SD_" + sDeviceString + "_keyword") as Keyword
			aWornDevice = StorageUtil.GetFormValue(fActorOverride, "_SD_" + sDeviceString + "_inventory" ) as Armor
			aRenderedDevice = StorageUtil.GetFormValue(fActorOverride, "_SD_" + sDeviceString + "_rendered" ) as Armor
			sGenericDeviceTags = StorageUtil.GetStringValue(fActorOverride, "_SD_" + sDeviceString + "_tags" )
		else
			Debug.Trace("[SD] 	- Actor override not found for " + sDeviceString)  
		endIf
	EndIf
	
	If ( fRaceOverride!= none) && (!bDeviceOverride)
		; Debug.Trace("[SD] equipDeviceByString - Race override detected")  
		if (StorageUtil.GetFormValue(fRaceOverride, "_SD_" + sDeviceString + "_keyword")!=none)
			Debug.Trace("[SD] 	- Racial override detected for " + sDeviceString)  
			bDeviceOverride = True
			kwDeviceKeyword = 	StorageUtil.GetFormValue(fRaceOverride, "_SD_" + sDeviceString + "_keyword") as Keyword
			aWornDevice = StorageUtil.GetFormValue(fRaceOverride, "_SD_" + sDeviceString + "_inventory" ) as Armor
			aRenderedDevice = StorageUtil.GetFormValue(fRaceOverride, "_SD_" + sDeviceString + "_rendered" ) as Armor
			sGenericDeviceTags = StorageUtil.GetStringValue(fRaceOverride, "_SD_" + sDeviceString + "_tags" )
		else
			Debug.Trace("[SD] 	- Racial override not found for " + sDeviceString)  
		endIf
	EndIf

	; If player override is set, intercept selection with player override instead
	If (!bDeviceOverride) ; generic item
		Debug.Trace("[SD] equipDeviceByString - NO override detected - " + sDeviceTags)  
		kwDeviceKeyword = 	getDeviousKeywordByString(sDeviceString)
		aWornDevice = none
		aRenderedDevice = none

		if (sDeviceTags=="")
			sDeviceTags = "DDi"
		endif
		if (sOutfitString == "Generic") ; generic override - force selection of a generic item with these tags
			sGenericDeviceTags = sDeviceTags
		else ; add current tag to generic item selection
			if (StorageUtil.GetStringValue(PlayerActor, "_SD_" + sDeviceString + "_tags" )!="")
				Debug.Trace("[SD] found player tag overrides - " + StorageUtil.GetStringValue(PlayerActor, "_SD_" + sDeviceString + "_tags" ))  
				sDeviceTagsOverride = StorageUtil.GetStringValue(PlayerActor, "_SD_" + sDeviceString + "_tags" ) + ","
			endIf
			sGenericDeviceTags = sDeviceTagsOverride + sDeviceTags
		endif

			
	endIf

	If (StorageUtil.GetIntValue(PlayerActor, "_SD_iEnslaved")==1) 
		; Any tweaks during slavery goes here - color in tags based on master personality maybe?
	Endif
 
 	; If override forms are set, use them first
 	; ElseIf generic device tag is set, use it
 	; Else force random generic item

 	if (sGenericDeviceTags=="none")
 		Debug.Trace("[SD]   'none' generic tag detected - aborting device" )  
		return
 	endif

	If (kwDeviceKeyword != None)

		if !PlayerActor.WornHasKeyword(kwDeviceKeyword)
			if (sOutfitString!="")
				Debug.Messagebox("[SD] equipDeviceByString called with message: " + sOutfitString)  
			Endif

			Debug.Trace("[SD] equipDeviceByString: " + sDeviceString)  
			Debug.Trace("[SD] 		keyword: " + kwDeviceKeyword)  

			if ( (aWornDevice!=none) && (aRenderedDevice!=none))
				; preferred device

				Debug.Trace("[SD] 		equipDeviceByString - preferred: " + aRenderedDevice + " - Device inventory: "  + aWornDevice  )

				bDeviceEquipSuccess = equipDevice ( aWornDevice,  aRenderedDevice,  kwDeviceKeyword)

			else


				if (sGenericDeviceTags!="")
					; preferred tags
					Debug.Trace("[SD] 		equipDeviceByString - tags: " + sGenericDeviceTags  )

					aWornDevice = libs.GetDeviceByTags(kwDeviceKeyword, sGenericDeviceTags)

					If (aWornDevice!=None)
						aRenderedDevice = libs.GetRenderedDevice(aWornDevice)
					EndIf

					Debug.Trace("[SD] 		Device rendered: " + aRenderedDevice  )

					If (aWornDevice!=None) && (aRenderedDevice!=None)
						bDeviceEquipSuccess = equipDevice ( aWornDevice,  aRenderedDevice,  kwDeviceKeyword)
					Else
						Debug.Trace("[SD] 		equipDeviceByString - no device found"  )
					EndIf
				EndIf

				if (!bDeviceEquipSuccess)
					; generic device
					Debug.Trace("[SD] 		equipDeviceByString - generic: ")
	 
					aWornDevice = libs.GetGenericDeviceByKeyword(kwDeviceKeyword)

					; Debug.Trace("[SD] 		equipDeviceByString - Generic devices registered: "  + StorageUtil.FormListCount(kwDeviceKeyword, "zad.GenericDevice")  )
					;Int i=StorageUtil.FormListCount(kwDeviceKeyword, "zad.GenericDevice") 
					;While (i>0)
					;	i = i - 1
					;	Debug.Trace("[SD] 							- Generic device: "  + StorageUtil.FormListGet(kwDeviceKeyword, "zad.GenericDevice", i)  )
					; EndWhile

					Debug.Trace("[SD] 		equipDeviceByString - Device inventory: "  + aWornDevice  )

					If (aWornDevice!=None)
						aRenderedDevice = libs.GetRenderedDevice(aWornDevice)
					EndIf

					Debug.Trace("[SD] 		Device rendered: " + aRenderedDevice  )

					If (aWornDevice!=None) && (aRenderedDevice!=None)

						bDeviceEquipSuccess = equipDevice ( aWornDevice,  aRenderedDevice,  kwDeviceKeyword)
					Else
						Debug.Trace("[SD] 		equipDeviceByString - no device found"  )
					EndIf
				Endif
			endif

			If (!bDeviceEquipSuccess)
				Debug.Trace("[SD] 		equipDeviceByString - device equip FAILED for " + sDeviceString)
				Debug.Notification("[SD] equipDeviceByString FAILED: " + sDeviceString)
			endIf
 
		else
			Debug.Trace("[SD] player is already wearing: " + sDeviceString)  
		endIf

	else
		Debug.Trace("[SD] unknown device to equip " )  

	endif
EndFunction

Function equipDeviceNPCByString ( Actor akActor, String sDeviceString = "", String sOutfitString = "", bool skipEvents = false, bool skipMutex = false,  String sDeviceTags = "")
	Keyword kwDeviceKeyword = none
	Armor aWornDevice = none
	Armor aRenderedDevice = none
	String sGenericDeviceTags = ""
	Form kForm	
	Bool bDeviceEquipSuccess = False

 	if (akActor == none)
 		Return
 	endif

	kwDeviceKeyword = 	getDeviousKeywordByString(sDeviceString)
	aWornDevice = none
	aRenderedDevice = none
	sGenericDeviceTags = sDeviceTags

	If (kwDeviceKeyword != None)

		if !akActor.WornHasKeyword(kwDeviceKeyword)
			if (sOutfitString!="")
				Debug.Messagebox("[SD] equipDeviceByString called with message: " + sOutfitString)  
			Endif

			Debug.Trace("[SD] equipDeviceByString: " + sDeviceString)  
			Debug.Trace("[SD] 		keyword: " + kwDeviceKeyword)  

			if (sGenericDeviceTags!="")
				; preferred tags
				Debug.Trace("[SD] 		equipDeviceByString - tags: " + sGenericDeviceTags  )

				aWornDevice = libs.GetDeviceByTags(kwDeviceKeyword, sGenericDeviceTags)

				If (aWornDevice!=None)
					aRenderedDevice = libs.GetRenderedDevice(aWornDevice)
				EndIf

				Debug.Trace("[SD] 		Device rendered: " + aRenderedDevice  )

				If (aWornDevice!=None) && (aRenderedDevice!=None)

					bDeviceEquipSuccess = equipDeviceNPC ( akActor, aWornDevice,  aRenderedDevice,  kwDeviceKeyword)
				Else
					Debug.Trace("[SD] 		equipDeviceByString - no device found"  )
				EndIf
			Else
				Debug.Trace("[SD] 		equipDeviceByString - no generic tag provided"  )
			EndIf

			if (!bDeviceEquipSuccess)
				; generic device
				Debug.Trace("[SD] 		equipDeviceByString - generic: ")
 
				aWornDevice = libs.GetGenericDeviceByKeyword(kwDeviceKeyword)

				Debug.Trace("[SD] 		equipDeviceByString - Device inventory: "  + aWornDevice  )

				If (aWornDevice!=None)
					aRenderedDevice = libs.GetRenderedDevice(aWornDevice)
				EndIf

				Debug.Trace("[SD] 		Device rendered: " + aRenderedDevice  )

				If (aWornDevice!=None) && (aRenderedDevice!=None)

					bDeviceEquipSuccess = equipDeviceNPC ( akActor, aWornDevice,  aRenderedDevice,  kwDeviceKeyword)
				Else
					Debug.Trace("[SD] 		equipDeviceByString - no device found"  )
				EndIf
			endif


			If (!bDeviceEquipSuccess)
				Debug.Trace("[SD] 		equipDeviceByString - device equip FAILED for " + sDeviceString)
				Debug.Notification("[SD] equipDeviceByString FAILED: " + sDeviceString)
			endIf
 
		else
			Debug.Trace("[SD] player is already wearing: " + sDeviceString)  
		endIf

	else
		Debug.Trace("[SD] unknown device to equip " )  

	endif
EndFunction



Function clearDeviceByString ( String sDeviceString = "", String sOutfitString = "", bool skipEvents = false, bool skipMutex = false )
	Keyword kwDeviceKeyword = none
	Actor PlayerActor = Game.GetPlayer() as Actor
	Armor aWornDevice = none
	Armor aRenderedDevice = none
	String sGenericDeviceTags = ""
	Form kForm
	Form fRaceOverride = StorageUtil.GetFormValue(PlayerActor, "_SD_fSlaveryGearRace")
	Form fActorOverride = StorageUtil.GetFormValue(PlayerActor, "_SD_fSlaveryGearActor")
	Bool bDeviceOverride = False

	; If master Race is set, check if override device is set for this race and use it first

	If ( fActorOverride!= none)
		; Debug.Trace("[SD] clearDeviceByString - Actor override detected")  
		if (StorageUtil.GetFormValue(fActorOverride, "_SD_" + sDeviceString + "_keyword")!=none)
			Debug.Trace("[SD] 	- Actor override detected for " + sDeviceString)  
			bDeviceOverride = True
			kwDeviceKeyword = 	StorageUtil.GetFormValue(fActorOverride, "_SD_" + sDeviceString + "_keyword") as Keyword
		else
			Debug.Trace("[SD] 	- Actor override not found for " + sDeviceString)  
		endIf
	endIf

	If ( fRaceOverride!= none) && (!bDeviceOverride)
		; Debug.Trace("[SD] clearDeviceByString - Race override detected")  
		if (StorageUtil.GetFormValue(fRaceOverride, "_SD_" + sDeviceString + "_keyword")!=none)
			Debug.Trace("[SD] 	- Racial override detected for " + sDeviceString)  
			bDeviceOverride = True
			kwDeviceKeyword = 	StorageUtil.GetFormValue(fRaceOverride, "_SD_" + sDeviceString + "_keyword") as Keyword
		else
			Debug.Trace("[SD] 	- Racial override not found for " + sDeviceString)  
		endIf
	EndIf

	If(!bDeviceOverride) ; generic item
		Debug.Trace("[SD] clearDeviceByString - NO override detected")  
			kwDeviceKeyword = 	getDeviousKeywordByString(sDeviceString)
	endIf
 
	If (kwDeviceKeyword != None)

		if PlayerActor.WornHasKeyword(kwDeviceKeyword)
			if (sOutfitString!="")
				Debug.Messagebox("[SD] clearDeviceByString called with message: " + sOutfitString)  
			Endif

			Debug.Trace("[SD] clearing device string: " + sDeviceString)  
			Debug.Trace("[SD] clearing device keyword: " + kwDeviceKeyword)  

			aWornDevice = libs.GetWornDeviceFuzzyMatch(PlayerActor, kwDeviceKeyword) as Armor
			if (aWornDevice != None)
				aRenderedDevice = libs.GetRenderedDevice(aWornDevice) as Armor
				kForm = aWornDevice as Form

				; if (kForm.HasKeywordString(libs.zad_BlockGeneric) )
				if ((kForm.HasKeyword(libs.zad_BlockGeneric) ) || (kForm.HasKeyword(libs.zad_QuestItem) ))
					; Debug.Notification("[SD] removing zad_BlockGeneric device!")  
					Debug.Trace("[SD]    zad_BlockGeneric keyword detected - Can't clear device")  
				else
					clearDevice ( aWornDevice,  aRenderedDevice,  kwDeviceKeyword, true)
				endif
			else
				Debug.Trace("[SD]    Can't get worn device")
			endif
			
			; libs.ManipulateGenericDeviceByKeyword(PlayerActor, kwDeviceKeyword, False, skipEvents,  skipMutex)


		else
			Debug.Trace("[SD] player is not wearing: " + sDeviceString)  
		endIf

	else
		Debug.Trace("[SD] unknown device to clear " )  

	endif
EndFunction

Function clearDeviceNPCByString ( Actor akActor, String sDeviceString = "", String sOutfitString = "", bool skipEvents = false, bool skipMutex = false )
	Keyword kwDeviceKeyword = none 
	Armor aWornDevice = none
	Armor aRenderedDevice = none
	String sGenericDeviceTags = ""
	Form kForm

 
	Debug.Trace("[SD] clearDeviceByString - NO override detected")  
	kwDeviceKeyword = 	getDeviousKeywordByString(sDeviceString)
	aWornDevice = none
	aRenderedDevice = none
	sGenericDeviceTags = none
 
	If (kwDeviceKeyword != None)

		if akActor.WornHasKeyword(kwDeviceKeyword)
			; RemoveDevice(actor akActor, armor deviceInventory, armor deviceRendered, keyword zad_DeviousDevice, bool destroyDevice=false, bool skipEvents=false, bool skipMutex=false)
 
			if (sOutfitString!="")
				Debug.Messagebox("[SD] clearDeviceByString called with message: " + sOutfitString)  
			Endif
			Debug.Trace("[SD] clearing device string: " + sDeviceString)  
			Debug.Trace("[SD] clearing device keyword: " + kwDeviceKeyword)  

			; generic device
			Debug.Trace("[SD] 		equipDeviceByString - generic: ")

			aWornDevice = libs.GetWornDeviceFuzzyMatch(akActor, kwDeviceKeyword) as Armor
			if (aWornDevice != None)
				aRenderedDevice = libs.GetRenderedDevice(aWornDevice) as Armor
				kForm = aWornDevice as Form

				; if (kForm.HasKeywordString(libs.zad_BlockGeneric) )
				if ((kForm.HasKeyword(libs.zad_BlockGeneric) ) || (kForm.HasKeyword(libs.zad_QuestItem) ))
					; Debug.Notification("[SD] removing zad_BlockGeneric device!")  
					Debug.Trace("[SD]    zad_BlockGeneric keyword detected - Can't clear device")  
				else
					clearDeviceNPC ( akActor, aWornDevice,  aRenderedDevice,  kwDeviceKeyword)
				endif
			else
				Debug.Trace("[SD]    Can't get worn device")
			endif
			
			; libs.ManipulateGenericDeviceByKeyword(PlayerActor, kwDeviceKeyword, False, skipEvents,  skipMutex)

		else
			Debug.Trace("[SD] player is not wearing: " + sDeviceString)  
		endIf

	else
		Debug.Trace("[SD] unknown device to clear " )  

	endif
EndFunction

Bool Function equipDevice ( Armor ddArmorInventory, Armor ddArmorRendered, Keyword ddArmorKeyword)
	Actor kSlave = Game.GetPlayer() as Actor
	Keyword kwWornKeyword
	Bool bDeviceEquipSuccess = False

	libs.Log("[SD] equipDevice " )

	if (ddArmorKeyword != None)
		if (!kslave.WornHasKeyword(ddArmorKeyword))

			bDeviceEquipSuccess = libs.EquipDevice(kSlave, ddArmorInventory , ddArmorRendered , ddArmorKeyword)
			bDeviceEquipSuccess = True
		Else
			libs.Log("[SD]   	skipped - device already equipped " )
		EndIf
	Else
		Debug.Notification("[SD] equipDevice - bad keyword " )
	endIf

	return bDeviceEquipSuccess
EndFunction

Bool Function equipDeviceNPC ( Actor akActor, Armor ddArmorInventory, Armor ddArmorRendered, Keyword ddArmorKeyword)
	Keyword kwWornKeyword
	Bool bDeviceEquipSuccess = False

	libs.Log("[SD] equipDevice " )

	if (ddArmorKeyword != None)
		if (!akActor.WornHasKeyword(ddArmorKeyword))

			bDeviceEquipSuccess = libs.EquipDevice(akActor, ddArmorInventory , ddArmorRendered , ddArmorKeyword)
			bDeviceEquipSuccess = True
		Else
			libs.Log("[SD]   	skipped - device already equipped " )
		EndIf
	Else
		Debug.Notification("[SD] equipDevice - bad keyword " )
	endIf

	return bDeviceEquipSuccess
EndFunction


Bool Function clearDevice ( Armor ddArmorInventory, Armor ddArmorRendered, Keyword ddArmorKeyword, Bool bDestroy = False)
	Actor kSlave = Game.GetPlayer() as Actor
	Keyword kwWornKeyword
	Bool bDeviceRemoveSuccess = False

	If (bDestroy)
		libs.Log("[SD] clearDevice - destroy: " + ddArmorKeyword )
	Else
		libs.Log("[SD] clearDevice - remove: " + ddArmorKeyword  )
	endIf

	; RemoveDevice(actor akActor, armor deviceInventory, armor deviceRendered, keyword zad_DeviousDevice, bool destroyDevice=false, bool skipEvents=false, bool skipMutex=false)
	libs.RemoveDevice(kSlave, ddArmorInventory , ddArmorRendered , ddArmorKeyword, bDestroy, False, True)

	; libs.ManipulateGenericDevice(actor akActor, armor device, bool equipOrUnequip, bool skipEvents = false , bool skipMutex = false)
	; libs.ManipulateGenericDevice(actor akActor, armor device, bool equipOrUnequip, bool skipEvents = false , bool skipMutex = false)
 
	bDeviceRemoveSuccess = True
 
	return bDeviceRemoveSuccess
EndFunction

Bool Function clearDeviceNPC ( Actor akActor, Armor ddArmorInventory, Armor ddArmorRendered, Keyword ddArmorKeyword, Bool bDestroy = False) 
	Keyword kwWornKeyword
	Bool bDeviceRemoveSuccess = False

	If (bDestroy)
		libs.Log("[SD] clearDevice - destroy: " + ddArmorKeyword )
	Else
		libs.Log("[SD] clearDevice - remove: " + ddArmorKeyword  )
	endIf

	; RemoveDevice(actor akActor, armor deviceInventory, armor deviceRendered, keyword zad_DeviousDevice, bool destroyDevice=false, bool skipEvents=false, bool skipMutex=false)
	libs.RemoveDevice(akActor, ddArmorInventory , ddArmorRendered , ddArmorKeyword, bDestroy, False, True)
 
	bDeviceRemoveSuccess = True
 
	return bDeviceRemoveSuccess
EndFunction


Function clearDevicesForEnslavement()
	; OutfitPart set to -1 to force the use of ManipulateGenericDeviceByKeyword when clearing items
	Actor kPlayer = Game.GetPlayer()

	If !isDeviceEquippedKeyword( kPlayer,  "_SD_DeviousSanguine", "Collar"  ) 
		clearDeviceByString ( sDeviceString = "Collar", skipEvents = true, skipMutex = true )
	EndIf

	If !isDeviceEquippedKeyword( kPlayer,  "_SD_DeviousSanguine", "Armbinder"  ) && !isDeviceEquippedKeyword( kPlayer,  "_SD_DeviousSpriggan", "ArmCuffs"  ) 
		clearDeviceByString ( sDeviceString = "ArmCuffs", skipEvents = true, skipMutex = true )
		clearDeviceByString ( sDeviceString = "Armbinder", skipEvents = true, skipMutex = true )
	EndIf

	If !isDeviceEquippedKeyword( kPlayer,  "_SD_DeviousSanguine", "LegCuffs"  ) && !isDeviceEquippedKeyword( kPlayer,  "_SD_DeviousSpriggan", "LegCuffs"   ) 
		clearDeviceByString ( sDeviceString = "LegCuffs", skipEvents = true, skipMutex = true )
	EndIf

EndFunction

Function lockDeviceByString(Actor akActor, String sDeviceString = "")
	Keyword kwDeviceKeyword = 	getDeviousKeywordByString(sDeviceString)

	if (kwDeviceKeyword != none)
		libs.JamLock(akActor, kwDeviceKeyword)
	endIf
EndFunction

Function unLockDeviceByString(Actor akActor, String sDeviceString = "")
	Keyword kwDeviceKeyword = 	getDeviousKeywordByString(sDeviceString)

	if (kwDeviceKeyword != none)
		libs.UnJamLock(akActor, kwDeviceKeyword)
	endIf
EndFunction



Bool Function hasTagByString ( Actor akActor, String sDeviceString = "", String sTag="")
	Keyword kwDeviceKeyword = none 
	Armor aWornDevice = none
	Armor aRenderedDevice = none
	String sGenericDeviceTags = ""
	Form kForm 
 
	; Debug.Trace("[SD] clearDeviceByString - NO override detected")  
	kwDeviceKeyword = 	getDeviousKeywordByString(sDeviceString)
 
	If (kwDeviceKeyword != None)

		if akActor.WornHasKeyword(kwDeviceKeyword)
			; RemoveDevice(actor akActor, armor deviceInventory, armor deviceRendered, keyword zad_DeviousDevice, bool destroyDevice=false, bool skipEvents=false, bool skipMutex=false)

			; Debug.Trace("[SD] hasTagByString device string: " + sDeviceString)  
			; Debug.Trace("[SD] hasTagByString device keyword: " + kwDeviceKeyword)  

			; generic device
			; Debug.Trace("[SD] 		equipDeviceByString - generic: ")

			aWornDevice = libs.GetWornDeviceFuzzyMatch(akActor, kwDeviceKeyword) as Armor
			if (aWornDevice != None)

				if (libs.HasTag(aWornDevice,sTag) )
					; Debug.Notification("[SD] hasTagByString found for - " + sTag)  
					Return true
				else
					; Debug.Notification("[SD] hasTagByString NOT found for - " + sTag)  

				endif
			else
				; Debug.Trace("[SD]    Can't get worn device")
			endif

		else
			; Debug.Trace("[SD] player is not wearing: " + sDeviceString)  
		endIf

	else
		; Debug.Trace("[SD] unknown device to clear " )  

	endif

	return False
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
		thisKeyword = libs.zad_DeviousPlugAnal ; _SDKP_DeviousParasiteAn

	elseif (deviousKeyword == "_SD_DeviousParasiteVag" ) || (deviousKeyword == "ParasiteVaginal") 
		thisKeyword = libs.zad_DeviousPlugVaginal ; _SDKP_DeviousParasiteVag
		
	elseif (deviousKeyword == "zad_BlockGeneric")
		thisKeyword = libs.zad_BlockGeneric
		
	elseif (deviousKeyword == "zad_Lockable")
		thisKeyword = libs.zad_Lockable

	elseif (deviousKeyword == "zad_DeviousCollar") || (deviousKeyword == "Collar") 
		thisKeyword = libs.zad_DeviousCollar

	elseif (deviousKeyword == "zad_DeviousGag") || (deviousKeyword == "Gag") 
		thisKeyword = libs.zad_DeviousGag

	elseif (deviousKeyword == "zad_DeviousGagPanel") || (deviousKeyword == "GagPanel") 
		thisKeyword = libs.zad_DeviousGagPanel

	elseif (deviousKeyword == "zad_DeviousBlindfold") || (deviousKeyword == "Blindfold") 
		thisKeyword = libs.zad_DeviousBlindfold

	elseif (deviousKeyword == "zad_DeviousBelt") || (deviousKeyword == "Belt") 
		thisKeyword = libs.zad_DeviousBelt

	elseif (deviousKeyword == "zad_DeviousPlug") || (deviousKeyword == "Plug") 
		thisKeyword = libs.zad_DeviousPlug

	elseif (deviousKeyword == "zad_DeviousPlugAnal") || (deviousKeyword == "PlugAnal") 
		thisKeyword = libs.zad_DeviousPlugAnal

	elseif (deviousKeyword == "zad_DeviousPlugVaginal") || (deviousKeyword == "PlugVaginal") 
		thisKeyword = libs.zad_DeviousPlugVaginal

	elseif (deviousKeyword == "zad_DeviousBra") || (deviousKeyword == "Bra") 
		thisKeyword = libs.zad_DeviousBra

	elseif (deviousKeyword == "WristRestraint") || (deviousKeyword == "WristRestraints") 
		thisKeyword = libs.zad_DeviousHeavyBondage

	elseif (deviousKeyword == "zad_DeviousArmCuffs") || (deviousKeyword == "ArmCuffs")  || (deviousKeyword == "ArmCuff") 
		thisKeyword = libs.zad_DeviousArmCuffs

	elseif (deviousKeyword == "zad_DeviousLegCuffs") || (deviousKeyword == "LegCuffs")  || (deviousKeyword == "LegCuff") 
		thisKeyword = libs.zad_DeviousLegCuffs

	elseif (deviousKeyword == "zad_DeviousArmbinder") || (deviousKeyword == "Armbinder")  || (deviousKeyword == "Armbinders") 
		thisKeyword = libs.zad_DeviousArmbinder

	elseif (deviousKeyword == "zad_DeviousYoke") || (deviousKeyword == "Yoke") 
		thisKeyword = libs.zad_DeviousYoke

	elseif (deviousKeyword == "zad_DeviousYokeBB") || (deviousKeyword == "YokeBB") 
		thisKeyword = libs.zad_DeviousYokeBB

	elseif (deviousKeyword == "zad_DeviousArmBinderElbow") || (deviousKeyword == "ArmBinderElbow")  || (deviousKeyword == "ArmbinderElbow") 
		thisKeyword = libs.zad_DeviousArmBinderElbow

	elseif (deviousKeyword == "zad_DeviousCuffsFront") || (deviousKeyword == "CuffsFront") 
		thisKeyword = libs.zad_DeviousCuffsFront

	elseif (deviousKeyword == "zad_DeviousCorset") || (deviousKeyword == "Corset") 
		thisKeyword = libs.zad_DeviousCorset

	elseif (deviousKeyword == "zad_DeviousStraitJacket") || (deviousKeyword == "StraitJacket") 
		thisKeyword = libs.zad_DeviousStraitJacket

	elseif (deviousKeyword == "zad_DeviousGloves") || (deviousKeyword == "Gloves") 
		thisKeyword = libs.zad_DeviousGloves

	elseif (deviousKeyword == "zad_DeviousBondageMittens") || (deviousKeyword == "BondageMittens")  || (deviousKeyword == "Mittens") 
		thisKeyword = libs.zad_DeviousBondageMittens

	elseif (deviousKeyword == "zad_DeviousHood") || (deviousKeyword == "Hood") 
		thisKeyword = libs.zad_DeviousHood

	elseif (deviousKeyword == "zad_DeviousSuit") || (deviousKeyword == "Suits") 
		thisKeyword = libs.zad_DeviousSuit

	elseif (deviousKeyword == "zad_DeviousHarness") || (deviousKeyword == "Harness") 
		thisKeyword = libs.zad_DeviousHarness

	elseif (deviousKeyword == "zad_DeviousHobbleSkirt") || (deviousKeyword == "HobbleSkirt") 
		thisKeyword = libs.zad_DeviousHobbleSkirt

	elseif (deviousKeyword == "zad_DeviousBoots") || (deviousKeyword == "Boots") 
		thisKeyword = libs.zad_DeviousBoots

	elseif (deviousKeyword == "zad_DeviousClamps") || (deviousKeyword == "Clamps") 
		thisKeyword = libs.zad_DeviousClamps

	elseif (deviousKeyword == "zad_DeviousPiercingsNipple") || (deviousKeyword == "PiercingNipple")  || (deviousKeyword == "NipplePiercing")|| (deviousKeyword == "NipplePiercings") 
		thisKeyword = libs.zad_DeviousPiercingsNipple

	elseif (deviousKeyword == "zad_DeviousPiercingsVaginal") || (deviousKeyword == "PiercingVaginal")|| (deviousKeyword == "VaginalPiercing")|| (deviousKeyword == "VaginalPiercings") 
		thisKeyword = libs.zad_DeviousPiercingsVaginal

	else
		Debug.Notification("[SD] getDeviousKeywordByString: Unknown generic keyword: " + deviousKeyword)  
		Debug.Trace("[SD] getDeviousKeywordByString: Unknown generic keyword: " + deviousKeyword)  
	endIf

	return thisKeyword
EndFunction

Bool Function ActorHasKeywordByString(actor akActor, String deviousKeyword = "")
	return libs.ActorHasKeyword(akActor, getDeviousKeywordByString( deviousKeyword ))
EndFunction

Bool Function isDeviceEquippedString( Actor akActor,  String sDeviceString  )
	; If device is armbinder, yoke, etc .. use getDeviousKeywordByString wihth 'WristRestraint' keyword as fallback
	; Else
	Bool bDeviceFound = akActor.WornHasKeyword(getDeviousKeywordByString(sDeviceString))

	If (!bDeviceFound) && ( (sDeviceString == "Armbinder") || (sDeviceString == "Armbinders") || (sDeviceString == "Yoke") || (sDeviceString == "YokeBB") || (sDeviceString == "ArmbinderElbow") || (sDeviceString == "CuffsFront"))
		bDeviceFound = akActor.WornHasKeyword(getDeviousKeywordByString("WristRestraint"))
	Endif

	Return bDeviceFound
EndFunction

Bool Function isDeviceEquippedKeyword( Actor akActor,  String sKeyword, String sDeviceString  )
	Actor PlayerActor = Game.GetPlayer() as Actor
	Form kForm
	Keyword kKeyword = getDeviousKeywordByString(sDeviceString)
 
 	If (kKeyword != None)
		kForm = libs.GetWornDeviceFuzzyMatch(PlayerActor, kKeyword) as Form
		If (kForm != None)
			; Debug.Trace("[SD] SetOutfit: test part " + iOutfitPart + " for keyword " +  deviousKeyword   )
			return (kForm.HasKeywordString(sKeyword) ) 
		Else
			; Debug.Trace("[SD] SetOutfit: test part " + iOutfitPart + " for keyword " +  deviousKeyword + " - nothing equipped "  )
			Return False
		EndIf
	else
		Debug.Trace("[SD] isDeviceEquippedKeyword: Keyword not found for: " + sDeviceString)  
	endIf
 
	Return False
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

Bool Function isWristRestraintEquipped (  Actor akActor )

	if akActor.WornHasKeyword(libs.zad_DeviousHeavyBondage)
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

Bool Function isCuffsFrontEquipped (  Actor akActor )

	if akActor.WornHasKeyword(libs.zad_DeviousCuffsFront)
	  	return True 
	Else
		Return False
	endIf

EndFunction

Bool Function isYokeBBEquipped (  Actor akActor )

	if akActor.WornHasKeyword(libs.zad_DeviousYokeBB)
	  	return True 
	Else
		Return False
	endIf

EndFunction

Bool Function isArmbinderElbowEquipped (  Actor akActor )

	if akActor.WornHasKeyword(libs.zad_DeviousArmBinderElbow)
	  	return True 
	Else
		Return False
	endIf

EndFunction

Bool Function isStraitJacketEquipped (  Actor akActor )

	if akActor.WornHasKeyword(libs.zad_DeviousStraitJacket)
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

Bool Function isPiercingsVaginalEquipped (  Actor akActor )

	if akActor.WornHasKeyword(libs.zad_DeviousPiercingsVaginal)
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



; STRemoveAllSectionTattoo(Form _form, String _section, bool _ignoreLock, bool _silent): remove all tattoos from determined section (ie, the folder name on disk, like "Bimbo")

; STAddTattoo(Form _form, String _section, String _name, int _color, bool _last, bool _silent, int _glowColor, bool _gloss, bool _lock): add a tattoo with more parameters, including glow, gloss (use it to apply makeup, looks much better) and locked tattoos.

function sendSlaveTatModEvent(actor akActor, string sType = "SD+", string sTatooName = "Slavers Hand (back)", int iColor = 0x99000000)
	; SlaveTats.simple_add_tattoo(bimbo, "Bimbo", "Tramp Stamp", last = false, silent = true)
  	int STevent = ModEvent.Create("STSimpleAddTattoo")  
  	Actor PlayerActor = Game.GetPlayer()
	Form fRaceOverride = StorageUtil.GetFormValue(PlayerActor, "_SD_fSlaveryGearRace")
	Form fActorOverride = StorageUtil.GetFormValue(PlayerActor, "_SD_fSlaveryGearActor")
	Form fOverride
	Bool bTatOverride = False 
	string tatooType  
	string tatooName  
	int tatooColor 
	int tatooGlow

	; If master Race is set, check if override device is set for this race and use it first
	Debug.Trace("[SD] sendSlaveTatModEvent - tattoo: " + sTatooName )  
	Debug.Trace("[SD] sendSlaveTatModEvent - fRaceOverride: " + fRaceOverride )  
	Debug.Trace("[SD] sendSlaveTatModEvent - fActorOverride: " + fActorOverride )  

	If ( fActorOverride!= none)
		Debug.Trace("[SD] sendSlaveTatModEvent - Actor override detected: " + StorageUtil.GetStringValue(fActorOverride, "_SD_sSlaveryTat"))  
		if (StorageUtil.GetStringValue(fActorOverride, "_SD_sSlaveryTat")!= "")
			Debug.Trace("[SD] 	- Actor override detected for tattoo" )  
			bTatOverride = True
			tatooName = StorageUtil.GetStringValue(fActorOverride, "_SD_sSlaveryTat" )
			tatooType = StorageUtil.GetStringValue(fActorOverride, "_SD_sSlaveryTatType" )
			tatooColor = StorageUtil.GetIntValue(fActorOverride, "_SD_iSlaveryTatColor" )
			tatooGlow = StorageUtil.GetIntValue(fActorOverride, "_SD_iSlaveryTatGlow" )
			fOverride = fActorOverride
		else
			Debug.Trace("[SD] 	- Actor override not found for tattoo" )  
		endIf
	EndIf
	
	If ( fRaceOverride!= none) && (!bTatOverride)
		Debug.Trace("[SD] sendSlaveTatModEvent - Race override detected: " + StorageUtil.GetStringValue(fRaceOverride, "_SD_sSlaveryTat" ))  
		if (StorageUtil.GetStringValue(fRaceOverride, "_SD_sSlaveryTat")!= "")
			Debug.Trace("[SD] 	- Racial override detected for tattoo" )  
			bTatOverride = True
			tatooName = StorageUtil.GetStringValue(fRaceOverride, "_SD_sSlaveryTat" )
			tatooType = StorageUtil.GetStringValue(fRaceOverride, "_SD_sSlaveryTatType" )
			tatooColor = StorageUtil.GetIntValue(fRaceOverride, "_SD_iSlaveryTatColor" )
			tatooGlow = StorageUtil.GetIntValue(fRaceOverride, "_SD_iSlaveryTatGlow" )
			fOverride = fRaceOverride
		else
			Debug.Trace("[SD] 	- Racial override not found for tattoo" )  
		endIf
	EndIf
	
	If (!bTatOverride) ; generic item
		Debug.Trace("[SD] sendSlaveTatModEvent - NO override detected")  
		StorageUtil.SetStringValue(akActor as Form, "_SD_sSlaveryTat", sTatooName )
		StorageUtil.SetStringValue(akActor as Form, "_SD_sSlaveryTatType", sType )
		tatooName = sTatooName
		tatooType = sType
		tatooColor = 0
		tatooGlow = 0
		fOverride = akActor as Form
	endIf

	If (tatooColor == 0)
		tatooColor = Math.LeftShift(128, 24) + Math.LeftShift(128, 16) + Math.LeftShift(64, 8) + 64
	endif

  	if (STevent) 
        ModEvent.PushForm(STevent, PlayerActor)      	; Form - actor
        ModEvent.PushString(STevent, tatooType)    		; String - type of tattoo?
        ModEvent.PushString(STevent, tatooName)  	; String - name of tattoo
        ModEvent.PushInt(STevent, tatooColor)  			; Int - color
        ModEvent.PushBool(STevent, true)        	; Bool - last = false
        ModEvent.PushBool(STevent, true)         	; Bool - silent = true

        ModEvent.Send(STevent)

        ; if tat is not in list, add it
        ; add application time - _SDGVP_gametime.GetValue() - and duration time
        StorageUtil.SetIntValue(fOverride, "_SD_iSlaveryTatDay", Game.QueryStat("Days Passed") )
 
		if (StorageUtil.FormListFind( none, "_SD_lSlaveryTatList", fOverride) <0)
			StorageUtil.FormListAdd( none, "_SD_lSlaveryTatList", fOverride)  
		endif


  	else
  		Debug.Trace("[_sdqs_fcts_outfit]  Send slave tat event failed.")
	endIf
endfunction

Function expireSlaveTats( Actor akSlave )
	; // iterate list from first added to last added
	Debug.Trace("[SD] Expire Slave Tats for " + akSlave)

	int currentDaysPassed = Game.QueryStat("Days Passed")
	int valueCount = StorageUtil.FormListCount(akSlave, "_SD_lSlaveryTatList")
	int i = 0
	int daysJoined 
	Form fOverride 
	Actor PlayerActor = Game.GetPlayer()

	while(i < valueCount)
		fOverride = StorageUtil.FormListGet(akSlave, "_SD_lSlaveryTatList", i)
		If (fOverride != none)

			daysJoined = currentDaysPassed - StorageUtil.GetIntValue( fOverride, "_SD_iSlaveryTatDay")

			if (daysJoined > StorageUtil.GetIntValue( fOverride, "_SD_iSlaveryTatDuration") )  && (StorageUtil.GetIntValue( fOverride, "_SD_iSlaveryTatDay" )!=-1)

				Debug.Trace("[SD]      Slave Tats[" + i + "] expired: " + fOverride.GetName() + " " + fOverride + " Days Since Marked: " + daysJoined )

				; StorageUtil.FormListRemoveAt( akSlave, "_SD_lSlaveFactions", i )
				StorageUtil.SetIntValue( fOverride, "_SD_iSlaveryTatDay",  -1 )
				Debug.Notification("Slave Tat removed: " + fOverride.GetName())

				Debug.Trace("[SD] Slave Tat removed: " + fOverride.GetName())

				; akSlave.RemoveFromFaction( slaveFaction as Faction )
				int STevent = ModEvent.Create("STSimpleRemoveTattoo") 
				if (STevent)
				    ModEvent.PushForm(STevent, PlayerActor)        ; Form - actor
				    ModEvent.PushString(STevent, StorageUtil.GetStringValue(fOverride, "_SD_sSlaveryTatType" ))     	; String - tattoo section (the folder name)
				    ModEvent.PushString(STevent, StorageUtil.GetStringValue(fOverride, "_SD_sSlaveryTat" ))    ; String - name of tattoo
				    ModEvent.PushBool(STevent, true)            ; Bool - last = false (the tattoos are only removed when last = true, use it on batches)
				    ModEvent.PushBool(STevent, true)            ; Bool - silent = true (do not show a message)
				    ModEvent.Send(STevent)
				endif
			EndIf
		Endif

		i += 1
	endwhile
EndFunction

Function addPunishmentDevice(String sDevice)
	Actor kPlayer = Game.getPlayer() as Actor
	Int    playerGender = kPlayer.GetLeveledActorBase().GetSex() as Int
	Actor kMaster = StorageUtil.GetFormValue(kPlayer, "_SD_CurrentOwner") as Actor
	Int 	isMasterSpeaking = StorageUtil.GetIntValue(kMaster, "_SD_iSpeakingNPC")

 	setMasterGearByRace ( kMaster, kPlayer  )

	If (sDevice == "PlugAnal") ; && (isMasterSpeaking==1)
		Debug.MessageBox("Your owner viciously inserts a cold plug inside your ass." )
		Debug.Trace("[_sdqs_fcts_outfit] Adding punishment item: Anal plug" )
			
		; setDeviousOutfitBelt ( bDevEquip = False, sDevMessage = "")
		; setDeviousOutfitPlugAnal ( bDevEquip = True, sDevMessage = "")
		; setDeviousOutfitBelt ( bDevEquip = True, sDevMessage = "")
		clearDeviceByString ( sDeviceString = "Belt")
		equipDeviceByString ( sDeviceString = "PlugAnal")
		equipDeviceByString ( sDeviceString = "Belt")

	ElseIf (sDevice == "PlugVaginal") && (playerGender==1) ; && (isMasterSpeaking==1)
		Debug.MessageBox("Your owner smiles wickedly and shoves a cold plug into your abused womb." )
		Debug.Trace("[_sdqs_fcts_outfit] Adding punishment item: Vaginal plug" )
		
		; setDeviousOutfitBelt ( bDevEquip = False, sDevMessage = "")
		; setDeviousOutfitPlugVaginal ( bDevEquip = True, sDevMessage = "")
		; setDeviousOutfitBelt ( bDevEquip = True, sDevMessage = "")
		clearDeviceByString ( sDeviceString = "Belt")
		equipDeviceByString ( sDeviceString = "PlugVaginal")
		equipDeviceByString ( sDeviceString = "Belt")

	ElseIf (sDevice == "Belt")  ; && (isMasterSpeaking==1)
		Debug.MessageBox("Your owner locks a chastity belt around your waist, making a point to let the metal pieces bite harshly into your skin." )
		Debug.Trace("[_sdqs_fcts_outfit] Adding punishment item: Belt" )
			
		; setDeviousOutfitBelt ( bDevEquip = True, sDevMessage = "")
		equipDeviceByString ( sDeviceString = "Belt")
	
	ElseIf (sDevice == "Blindfold")
		Debug.MessageBox("Your owner sternly glares at you and covers your eyes with a blindfold, leaving you helpless." )
		Debug.Trace("[_sdqs_fcts_outfit] Adding punishment item: Blinds" )
			
		; setDeviousOutfitBlindfold ( bDevEquip = True, sDevMessage = "")
		equipDeviceByString ( sDeviceString = "Blindfold")

	ElseIf (sDevice == "Gag") ; && (isMasterSpeaking==1)
		Debug.MessageBox("Your owner shoves a gag into your mouth to muffle your screams and stop your constant whining." )
		Debug.Trace("[_sdqs_fcts_outfit] Adding punishment item: Gag" )

		; setDeviousOutfitGag ( bDevEquip = True, sDevMessage = "")
		equipDeviceByString ( sDeviceString = "Gag")

	ElseIf (sDevice == "WristRestraint") || (sDevice == "WristRestraints") ; && (isMasterSpeaking==1)
		Debug.MessageBox("Your owner binds your hand rendering you completely helpless." )
		Debug.Trace("[_sdqs_fcts_outfit] Adding punishment item: Wrist Restraints" )

		; setDeviousOutfitGag ( bDevEquip = True, sDevMessage = "")
		clearDeviceByString ( sDeviceString = "WristRestraint")
		equipDeviceByString ( sDeviceString = "WristRestraint", sOutfitString = "", skipEvents = false, skipMutex = false, sDeviceTags = "")

	ElseIf (sDevice == "Armbinder") ; && (isMasterSpeaking==1)
		Debug.MessageBox("Your owner binds your hand rendering you completely helpless." )
		Debug.Trace("[_sdqs_fcts_outfit] Adding punishment item: Armbinder" )

		; setDeviousOutfitGag ( bDevEquip = True, sDevMessage = "")
		clearDeviceByString ( sDeviceString = "WristRestraint")
		equipDeviceByString ( sDeviceString = "WristRestraint", sOutfitString = "", skipEvents = false, skipMutex = false, sDeviceTags = "armbinder")

	ElseIf (sDevice == "Yoke") ; && (isMasterSpeaking==1)
		Debug.MessageBox("Your owner binds your hand rendering you completely helpless." )
		Debug.Trace("[_sdqs_fcts_outfit] Adding punishment item: Yoke" )

		; setDeviousOutfitGag ( bDevEquip = True, sDevMessage = "")
		clearDeviceByString ( sDeviceString = "WristRestraint")
		equipDeviceByString ( sDeviceString = "WristRestraint", sOutfitString = "", skipEvents = false, skipMutex = false, sDeviceTags = "yoke")

	Else ; generic punishment
		; Debug.MessageBox("Your owner binds your hand rendering you completely helpless." )
		Debug.Trace("[_sdqs_fcts_outfit] Adding punishment item: " + sDevice )

		equipDeviceByString ( sDeviceString = sDevice)

	EndIf

EndFunction


Function removePunishmentDevice(String sDevice)
	Actor kPlayer = Game.getPlayer() as Actor
	Int    playerGender = kPlayer.GetLeveledActorBase().GetSex() as Int
	Actor kMaster = StorageUtil.GetFormValue(kPlayer, "_SD_CurrentOwner") as Actor
	Int 	isMasterSpeaking = StorageUtil.GetIntValue(kMaster, "_SD_iSpeakingNPC")

 	setMasterGearByRace ( kMaster, kPlayer  )

	If (sDevice == "PlugAnal") && !isDeviceEquippedKeyword( kPlayer, "_SD_DeviousParasiteAn", "PlugAnal"  ) ; && (isMasterSpeaking==1)
		Debug.MessageBox("The anal plug is removed, leaving you terribly sore and empty." )
		Debug.Trace("[_sdqs_fcts_outfit] Removing punishment item: Anal plug" )
			
		; setDeviousOutfitBelt ( bDevEquip = False, sDevMessage = "")
		; setDeviousOutfitPlugAnal ( bDevEquip = False, sDevMessage = "")
		; setDeviousOutfitBelt ( bDevEquip = True, sDevMessage = "")
		clearDeviceByString ( sDeviceString = "Belt")
		clearDeviceByString ( sDeviceString = "PlugAnal")
		equipDeviceByString ( sDeviceString = "Belt")

	ElseIf (sDevice == "PlugVaginal") && !isDeviceEquippedKeyword( kPlayer, "_SD_DeviousParasiteVag", "PlugVaginal"  ) ; && (isMasterSpeaking==1)
		Debug.MessageBox("The vaginal plug is drenched as it is removed." )
		Debug.Trace("[_sdqs_fcts_outfit] Removing punishment item: Vaginal plug" )
			
		; setDeviousOutfitBelt ( bDevEquip = False, sDevMessage = "")
		; setDeviousOutfitPlugVaginal ( bDevEquip = False, sDevMessage = "")
		; setDeviousOutfitBelt ( bDevEquip = True, sDevMessage = "")
		clearDeviceByString ( sDeviceString = "Belt")
		clearDeviceByString ( sDeviceString = "PlugVaginal")
		equipDeviceByString ( sDeviceString = "Belt")

	ElseIf (sDevice == "Belt") ; && (isMasterSpeaking==1)
		Debug.MessageBox("The belt finally lets go of its grasp around your hips." )
		Debug.Trace("[_sdqs_fcts_outfit] Removing punishment item: Belt" )
			
		; setDeviousOutfitBelt ( bDevEquip = False, sDevMessage = "")
		clearDeviceByString ( sDeviceString = "Belt")
	
	ElseIf (sDevice == "Blindfold")
		Debug.MessageBox("A flood of painful light makes you squint as the blindfold is removed." )
		Debug.Trace("[_sdqs_fcts_outfit] Removing punishment item: Blinds" )
			
		; setDeviousOutfitBlindfold ( bDevEquip = False, sDevMessage = "")
		clearDeviceByString ( sDeviceString = "Blindfold")
	
	ElseIf (sDevice == "Gag") ; && (isMasterSpeaking==1)
		Debug.MessageBox("The gag is finally removed, leaving a screaming pain in your jaw." )
		Debug.Trace("[_sdqs_fcts_outfit] Removing punishment item: Gag "  )

		; setDeviousOutfitGag ( bDevEquip = False, sDevMessage = "")
		clearDeviceByString ( sDeviceString = "Gag")
	Else
		; Debug.MessageBox("The gag is finally removed, leaving a screaming pain in your jaw." )
		Debug.Trace("[_sdqs_fcts_outfit] Removing punishment item: " + sDevice )

		; setDeviousOutfitGag ( bDevEquip = False, sDevMessage = "")
		clearDeviceByString ( sDeviceString = sDevice)
	EndIf

EndFunction


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

Int Function countPunishmentEquipped (  Actor akActor )
	Int countPunishments = 0

	if (isGagEquipped(akActor))
		countPunishments += 1
	endIf
	if isBlindfoldEquipped(akActor) 
		countPunishments += 1
	endIf
	if isBeltEquipped(akActor) 
		countPunishments += 1
	endIf
	if isPlugVaginalEquipped(akActor)
		countPunishments += 1
	endIf
	if isPlugAnalEquipped(akActor)
		countPunishments += 1
	endIf

	Return countPunishments

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
		; While ( iFormIndex > 0 )
		;	iFormIndex -= 1
		;	Form kForm = akActor.GetWornForm( uiSlotMask[iFormIndex] ) 

		;	Armor kArmor = kForm as Armor
		;	If ( kArmor && isArmorRemovable( kForm ) )
		;		If ( bDrop )
				;	akActor.DropObject(kArmor as Armor, 1 )
		;		Else
				;	akActor.UnequipItem(kArmor as Armor, False, True )
		;		EndIf
		;	EndIf
		; EndWhile	
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


Function EquipSlaveRags(Actor akSlave) 

	If (StorageUtil.GetIntValue( akSlave  , "_SD_iCustomSlaveRags" ) == 0)
	 	akSlave.AddItem( SDSlaveRags as Form, 1, True )
	 	akSlave.EquipItem( SDSlaveRags as Form, True, True )

	ElseIf (StorageUtil.GetIntValue(akSlave, "_SD_iEnslaved")==0) || (StorageUtil.GetIntValue(akSlave, "_SD_iSlaveryLevel")<=1)
	 	akSlave.AddItem( SDSlaveRags1 as Form, 1, True )
	 	akSlave.EquipItem( SDSlaveRags1 as Form, True, True )

	ElseIf (StorageUtil.GetIntValue(akSlave, "_SD_iSlaveryLevel")==2)
	 	akSlave.AddItem( SDSlaveRags2 as Form, 1, True )
	 	akSlave.EquipItem( SDSlaveRags2 as Form, True, True )

	ElseIf (StorageUtil.GetIntValue(akSlave, "_SD_iSlaveryLevel")==3)
	 	akSlave.AddItem( SDSlaveRags3 as Form, 1, True )
	 	akSlave.EquipItem( SDSlaveRags3 as Form, True, True )

	ElseIf (StorageUtil.GetIntValue(akSlave, "_SD_iSlaveryLevel")==4)
	 	akSlave.AddItem( SDSlaveRags4 as Form, 1, True )
	 	akSlave.EquipItem( SDSlaveRags4 as Form, True, True )

	ElseIf (StorageUtil.GetIntValue(akSlave, "_SD_iSlaveryLevel")==5)
	 	akSlave.AddItem( SDSlaveRags5 as Form, 1, True )
	 	akSlave.EquipItem( SDSlaveRags5 as Form, True, True )

	ElseIf (StorageUtil.GetIntValue(akSlave, "_SD_iSlaveryLevel")==6)
	 	akSlave.AddItem( SDSlaveRags6 as Form, 1, True )
	 	akSlave.EquipItem( SDSlaveRags6 as Form, True, True )

	Endif
EndFunction

; ------------------------ Special functions to equip/remove non generic devices

Function equipNonGenericDeviceByString ( String sDeviceString = "", String sOutfitString = "", bool skipEvents = false, bool skipMutex = false )
	; Test for unique, non generic keyword should be done before calling this function

	Keyword kwDeviceKeyword = none
	Actor PlayerActor = Game.GetPlayer() as Actor
	Armor aWornDevice = none
	Armor aRenderedDevice = none
	String sGenericDeviceTags = ""
	Form kForm
	Form fRaceOverride = StorageUtil.GetFormValue(PlayerActor, "_SD_fSlaveryGearRace")
	Form fActorOverride = StorageUtil.GetFormValue(PlayerActor, "_SD_fSlaveryGearActor")
	Bool bDeviceOverride = False

	; If master Race is set, check if override device is set for this race and use it first

	kwDeviceKeyword = 	getDeviousKeywordByString(sDeviceString)
 
	If (kwDeviceKeyword != None)

		if !PlayerActor.WornHasKeyword(kwDeviceKeyword)

			if (sOutfitString!="")
				Debug.Trace("[SD] clearNonGenericDeviceByString called with message: " + sOutfitString)  
			Endif

			Debug.Trace("[SD] clearing device string: " + sDeviceString)  
			Debug.Trace("[SD] clearing device keyword: " + kwDeviceKeyword)  

			if (sOutfitString == "Sanguine")
				If ( sDeviceString == "Collar" )
					aRenderedDevice = zazSanguineCollarRendered 
					aWornDevice = zazSanguineCollar

				ElseIf ( sDeviceString == "WristRestraints" ) || ( sDeviceString == "WristRestraint" )
					aRenderedDevice = zazSanguineCuffsRendered 
					aWornDevice = zazSanguineCuffs
				
				ElseIf ( sDeviceString == "LegCuffs" )
					aRenderedDevice = zazSanguineShacklesRendered 
					aWornDevice = zazSanguineShackles
				
				ElseIf ( sDeviceString == "Gag" )
					aRenderedDevice = zazSanguineWoodenBitRendered
					aWornDevice = zazSanguineWoodenBit
				
				ElseIf ( sDeviceString == "Blindfold" )
					aRenderedDevice = zazSanguineBlindsRendered
					aWornDevice = zazSanguineBlinds
				
				ElseIf ( sDeviceString == "VaginalPiercing" )
					aRenderedDevice = zazSanguineArtifactRendered
					aWornDevice = zazSanguineArtifact
				EndIf

			elseif (sOutfitString == "Falmer")
				If ( sDeviceString == "Collar" )
					aRenderedDevice = zazFalmerCollarRendered 
					aWornDevice = zazFalmerCollar

				ElseIf ( sDeviceString == "WristRestraints" ) || ( sDeviceString == "WristRestraint" )
					aRenderedDevice = zazFalmerCuffsRendered 
					aWornDevice = zazFalmerCuffs

				EndIf

			elseif (sOutfitString == "Web")
				If ( sDeviceString == "Collar" )
					aRenderedDevice = zazWebCuffsRendered 
					aWornDevice = zazWebCuffs

				ElseIf ( sDeviceString == "WristRestraints" ) || ( sDeviceString == "WristRestraint" )
					aRenderedDevice = zazWebCollarRendered 
					aWornDevice = zazWebCollar

				EndIf


			elseif (sOutfitString == "Spriggan")
				If ( sDeviceString == "WristRestraints" ) || ( sDeviceString == "WristRestraint" )
					aRenderedDevice = zazSprigganHandsRendered 
					aWornDevice = zazSprigganHands

				ElseIf ( sDeviceString == "LegCuffs" )
					aRenderedDevice = zazSprigganFeetRendered 
					aWornDevice = zazSprigganFeet
				
				ElseIf ( sDeviceString == "Gag" )
					aRenderedDevice = zazSprigganMaskRendered 
					aWornDevice = zazSprigganMask
				
				ElseIf ( sDeviceString == "Harness" )
					aRenderedDevice = zazSprigganBodyRendered
					aWornDevice = zazSprigganBody
				EndIf

			Endif

			if ( (aWornDevice!=none) && (aRenderedDevice!=none))
				; preferred device

				Debug.Trace("[SD] 		equipNonGenericDeviceByString - preferred: " + aRenderedDevice + " - Device inventory: "  + aWornDevice  )

				equipDevice ( aWornDevice,  aRenderedDevice,  kwDeviceKeyword)

			else
				Debug.Trace("[SD]    equipNonGenericDeviceByString - Can't get worn device")
			endif
			
			; libs.ManipulateGenericDeviceByKeyword(PlayerActor, kwDeviceKeyword, False, skipEvents,  skipMutex)


		else
			Debug.Trace("[SD] equipNonGenericDeviceByString - player is not wearing: " + sDeviceString)  
		endIf

	else
		Debug.Trace("[SD] equipNonGenericDeviceByString - unknown device to clear " )  

	endif
EndFunction

Function clearNonGenericDeviceByString ( String sDeviceString = "", String sOutfitString = "", bool skipEvents = false, bool skipMutex = false )
	; Test for unique, non generic keyword should be done before calling this function

	Keyword kwDeviceKeyword = none
	Actor PlayerActor = Game.GetPlayer() as Actor
	Armor aWornDevice = none
	Armor aRenderedDevice = none
	String sGenericDeviceTags = ""
	Form kForm
	Form fRaceOverride = StorageUtil.GetFormValue(PlayerActor, "_SD_fSlaveryGearRace")
	Form fActorOverride = StorageUtil.GetFormValue(PlayerActor, "_SD_fSlaveryGearActor")
	Bool bDeviceOverride = False

	; If master Race is set, check if override device is set for this race and use it first

	kwDeviceKeyword = 	getDeviousKeywordByString(sDeviceString)
 
	If (kwDeviceKeyword != None)

		if PlayerActor.WornHasKeyword(kwDeviceKeyword)

			if (sOutfitString!="")
				Debug.Trace("[SD] clearNonGenericDeviceByString called with message: " + sOutfitString)  
			Endif

			Debug.Trace("[SD] clearing device string: " + sDeviceString)  
			Debug.Trace("[SD] clearing device keyword: " + kwDeviceKeyword)  

			aWornDevice = libs.GetWornDeviceFuzzyMatch(PlayerActor, kwDeviceKeyword) as Armor
			if (aWornDevice != None)
				aRenderedDevice = libs.GetRenderedDevice(aWornDevice) as Armor
				kForm = aWornDevice as Form

				clearDevice ( aWornDevice,  aRenderedDevice,  kwDeviceKeyword, true)
			else
				Debug.Trace("[SD]    clearNonGenericDeviceByString - Can't get worn device")
			endif
			
			; libs.ManipulateGenericDeviceByKeyword(PlayerActor, kwDeviceKeyword, False, skipEvents,  skipMutex)


		else
			Debug.Trace("[SD] clearNonGenericDeviceByString - player is not wearing: " + sDeviceString)  
		endIf

	else
		Debug.Trace("[SD] clearNonGenericDeviceByString - unknown device to clear " )  

	endif
EndFunction


;================================================================================

; Deprecated functions - remove eventually

;================================================================================


Function DDSetAnimating( Actor akActor, Bool isAnimating )
	libs.SetAnimating( akActor, isAnimating )
EndFunction

Bool Function DDIsBound( actor akActor )
	return libs.IsBound(akActor)
EndFunction

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


