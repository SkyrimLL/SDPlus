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

;int Property kSlotMask30 = 0x00000001 AutoReadOnly
;int Property kSlotMask31 = 0x00000002 AutoReadOnly
;int Property kSlotMask32 = 0x00000004 AutoReadOnly
;int Property kSlotMask33 = 0x00000008 AutoReadOnly
;int Property kSlotMask34 = 0x00000010 AutoReadOnly
;int Property kSlotMask35 = 0x00000020 AutoReadOnly
;int Property kSlotMask36 = 0x00000040 AutoReadOnly
;int Property kSlotMask37 = 0x00000080 AutoReadOnly
;int Property kSlotMask38 = 0x00000100 AutoReadOnly
;int Property kSlotMask39 = 0x00000200 AutoReadOnly
;int Property kSlotMask40 = 0x00000400 AutoReadOnly
;int Property kSlotMask41 = 0x00000800 AutoReadOnly
;int Property kSlotMask42 = 0x00001000 AutoReadOnly
;int Property kSlotMask43 = 0x00002000 AutoReadOnly
;int Property kSlotMask44 = 0x00004000 AutoReadOnly
;int Property kSlotMask45 = 0x00008000 AutoReadOnly
;int Property kSlotMask46 = 0x00010000 AutoReadOnly
;int Property kSlotMask47 = 0x00020000 AutoReadOnly
;int Property kSlotMask48 = 0x00040000 AutoReadOnly
;int Property kSlotMask49 = 0x00080000 AutoReadOnly
;int Property kSlotMask50 = 0x00100000 AutoReadOnly
;int Property kSlotMask51 = 0x00200000 AutoReadOnly
;int Property kSlotMask52 = 0x00400000 AutoReadOnly
;int Property kSlotMask53 = 0x00800000 AutoReadOnly
;int Property kSlotMask54 = 0x01000000 AutoReadOnly
;int Property kSlotMask55 = 0x02000000 AutoReadOnly
;int Property kSlotMask56 = 0x04000000 AutoReadOnly
;int Property kSlotMask57 = 0x08000000 AutoReadOnly
;int Property kSlotMask58 = 0x10000000 AutoReadOnly
;int Property kSlotMask59 = 0x20000000 AutoReadOnly
;int Property kSlotMask60 = 0x40000000 AutoReadOnly
;int Property kSlotMask61 = 0x80000000 AutoReadOnly

Bool Function isArmorRemovable ( Form kForm )
	If ( !kForm  )
	;	Debug.Trace("[SD] Armor: " + kForm )
		Return False
	EndIf

	Bool isLocked = (kForm.HasKeywordString("_SD_nounequip")  || kForm.HasKeywordString("_SD_DeviousSanguine")  || kForm.HasKeywordString("_SD_DeviousSpriggan") || kForm.HasKeywordString("SOS_Underwear")  || kForm.HasKeywordString("SOS_Genitals") || kForm.HasKeywordString("_SLMC_MCdevice") || !SexLab.IsStrippable(kForm) || kForm.HasKeywordString("zad_Lockable") )

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
	uiSlotMask[0]  = 0x00000004 ;32
	uiSlotMask[1]  = 0x00000008 ;33
	uiSlotMask[2]  = 0x00000010 ;34
	uiSlotMask[3]  = 0x00000080 ;37
	uiSlotMask[4]  = 0x00000100 ;38
	uiSlotMask[5]  = 0x00000200 ;39
	uiSlotMask[6]  = 0x00001000 ;42


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

; Devious Devices 2.8.2
; Armbinder: 33, 59
; Blindfold: 55
; Body Harness: 45, 49
; Chastity Belts: 49
; Chastity Bra: 56
; Collars: 45
; Cuffs (Arms): 59
; Cuffs (Legs): 53
; Cuffs (Neck): 45
; Gags: 44
; Nipple Piercings: 56
; Plugs (Anal): 48
; Plugs (Vaginal): 54
; Vaginal Piercings: 48

Bool Function isPunishmentEquipped (  Actor akActor )

	Bool bDeviousDeviceEquipped = isGagEquipped(akActor) || isBlindfoldEquipped(akActor) || isBeltEquipped(akActor) || isPlugEquipped(akActor)

	Return bDeviousDeviceEquipped

EndFunction

Bool Function isRestraintEquipped (  Actor akActor )

	Bool bDeviousDeviceEquipped = isCollarEquipped(akActor) || isBindingEquipped(akActor)

	Return bDeviousDeviceEquipped

EndFunction


Bool Function isCollarEquipped (  Actor akActor )

	if akActor.WornHasKeyword(libs.zad_DeviousCollar)
	  	return True 
	Else
		Return False
	endIf

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

Bool Function isPlugEquipped (  Actor akActor )

	if akActor.WornHasKeyword(libs.zad_DeviousPlugAnal) || akActor.WornHasKeyword(libs.zad_DeviousPlugVaginal)
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

Bool Function isActorNaked( Actor akActor )
	if akActor.WornHasKeyword(ArmorCuirass) || akActor.WornHasKeyword(ClothingBody)
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
		Int iFormIndex = uiSlotMask.Length
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

; 0 - Collar
; 1 - Arms
; 2 - Legs
; 3 - Gag
; 4 - Blindfold
; 5 - Belt
; 6 - Plug Anal
; 7 - Plug Vaginal 

Bool Function isDeviousOutfitPartEquipped (  Actor akActor, Int iOutfitPart = -1 )
	Form kForm
	Int[] uiSlotMask = New Int[8]
	uiSlotMask[0] = 0x00008000 ;45  Collar / DD Collars / DD Cuffs (Neck)
	uiSlotMask[1] = 0x20000000 ;59  DD Armbinder / DD Cuffs (Arms) 
	uiSlotMask[2] = 0x00800000 ;53  DD Cuffs (Legs)
	uiSlotMask[3] = 0x00004000 ;44  DD Gags Mouthpieces
	uiSlotMask[4] = 0x02000000 ;55  DD Blindfold
	uiSlotMask[5] = 0x00080000 ;49  DD Chastity Belts
	uiSlotMask[6] = 0x00040000 ;48  DD plugs (Anal)
	uiSlotMask[7]=  0x08000000 ;57  DD Plugs (Vaginal)
	; uiSlotMask[8] = 0x00010000 ;46  DD Yokes

	; uiSlotMask[8] = 0x00008000 ;45  Collar / DD Collars / DD Cuffs (Neck) Harness - same as collar
	; uiSlotMask[9] = 0x04000000 ;56  DD Chastity Bra
	; uiSlotMask[10] = 0x00000008 ;33  Bindings / DD Armbinders
	; uiSlotMask[11]= 0x00000004 ;32  Spriggan host
	; uiSlotMask[12]= 0x00100000 ;50  DD Gag Straps

	Int iFormIndex = uiSlotMask.Length 

	If (iOutfitPart>=0)
		kForm = akActor.GetWornForm( uiSlotMask[iOutfitPart] ) 
		If (kForm != None)
			Armor kArmor = kForm  as Armor
			; Debug.Trace("[SD] SetOutfit: test zad_lockable for part " +  iOutfitPart + " - " + kForm.hasKeywordString("zad_Lockable") )
			return (!SexLab.IsStrippable(kForm) || kForm.HasKeywordString("_SD_DeviousSpriggan")  || kForm.hasKeywordString("zad_Lockable")  || kForm.hasKeywordString("zad_deviousPlugAnal")  || kForm.hasKeywordString("zad_deviousPlugVaginal") || kForm.hasKeywordString("zad_deviousCollar")|| kForm.hasKeywordString("zad_deviousGag") || kForm.hasKeywordString("zad_DeviousArmbinder")  ) 
		Else
			; Debug.Trace("[SD] SetOutfit: test zad_lockable - nothing equipped for part " +  iOutfitPart )
			Return False
		EndIf

	EndIf

	Return False
EndFunction

; 0 - Collar
Bool Function isCollarEquippedKeyword( Actor akActor,  String sKeyword  )
	Return isDeviousOutfitPartByKeyword (  akActor, 0, sKeyword )
EndFunction

; 1 - Arms
Bool Function isArmsEquippedKeyword( Actor akActor,  String sKeyword  )
	Return isDeviousOutfitPartByKeyword (  akActor, 1, sKeyword )
EndFunction

; 2 - Legs
Bool Function isLegsEquippedKeyword( Actor akActor,  String sKeyword  )
	Return isDeviousOutfitPartByKeyword (  akActor, 2, sKeyword )
EndFunction

; 3 - Gag
Bool Function isGagEquippedKeyword( Actor akActor,  String sKeyword  )
	Return isDeviousOutfitPartByKeyword (  akActor, 3, sKeyword )
EndFunction

; 4 - Blindfold
Bool Function isBlindfoldEquippedKeyword( Actor akActor,  String sKeyword  )
	Return isDeviousOutfitPartByKeyword (  akActor, 4, sKeyword )
EndFunction

; 5 - Belt
Bool Function isBeltEquippedKeyword( Actor akActor,  String sKeyword  )
	Return isDeviousOutfitPartByKeyword (  akActor, 5, sKeyword )
EndFunction

; 6 - Plug Anal
Bool Function isPlugAnalEquippedKeyword( Actor akActor,  String sKeyword  )
	Return isDeviousOutfitPartByKeyword (  akActor, 6, sKeyword )
EndFunction

; 7 - Plug Vaginal 
Bool Function isPlugVaginalEquippedKeyword( Actor akActor,  String sKeyword  )
	Return isDeviousOutfitPartByKeyword (  akActor, 7, sKeyword )
EndFunction


Bool Function isDeviousOutfitPartByKeyword (  Actor akActor, Int iOutfitPart = -1, String deviousKeyword = "zad_Lockable"  )
	Form kForm
	Int[] uiSlotMask = New Int[8]
	uiSlotMask[0] = 0x00008000 ;45  Collar / DD Collars / DD Cuffs (Neck)
	uiSlotMask[1] = 0x20000000 ;59  DD Armbinder / DD Cuffs (Arms) 
	uiSlotMask[2] = 0x00800000 ;53  DD Cuffs (Legs)
	uiSlotMask[3] = 0x00004000 ;44  DD Gags Mouthpieces
	uiSlotMask[4] = 0x02000000 ;55  DD Blindfold
	uiSlotMask[5] = 0x00080000 ;49  DD Chastity Belts
	uiSlotMask[6] = 0x00040000 ;48  DD plugs (Anal)
	uiSlotMask[7]=  0x08000000 ;57  DD Plugs (Vaginal)

	; uiSlotMask[8] = 0x00008000 ;45  Collar / DD Collars / DD Cuffs (Neck) Harness - same as collar
	; uiSlotMask[9] = 0x04000000 ;56  DD Chastity Bra
	; uiSlotMask[10] = 0x00000008 ;33  Bindings / DD Armbinders
	; uiSlotMask[11]= 0x00000004 ;32  Spriggan host
	; uiSlotMask[12]= 0x00100000 ;50  DD Gag Straps

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


Int Function countDeviousSlotsByKeyword (  Actor akActor, String deviousKeyword = "zad_Lockable" )
	Form kForm
	Int[] uiSlotMask = New Int[13]
	uiSlotMask[0] = 0x00008000 ;45  Collar / DD Collars / DD Cuffs (Neck)
	uiSlotMask[1] = 0x20000000 ;59  DD Armbinder / DD Cuffs (Arms) 
	uiSlotMask[2] = 0x00800000 ;53  DD Cuffs (Legs)
	uiSlotMask[3] = 0x00004000 ;44  DD Gags Mouthpieces
	uiSlotMask[4] = 0x02000000 ;55  DD Blindfold
	uiSlotMask[5] = 0x00080000 ;49  DD Chastity Belts
	uiSlotMask[6] = 0x00040000 ;48  DD plugs (Anal)
	uiSlotMask[7]=  0x08000000 ;57  DD Plugs (Vaginal)
	uiSlotMask[8] = 0x00008000 ;45  Collar / DD Collars / DD Cuffs (Neck) Harness - same as collar
	uiSlotMask[9] = 0x04000000 ;56  DD Chastity Bra
	uiSlotMask[10]= 0x20000000 ;59  DD Armbinder / DD Cuffs (Arms)
	uiSlotMask[11]= 0x00000004 ;32  Spriggan host
	uiSlotMask[12]= 0x00100000 ;50  DD Gag Straps

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
	if ((!isCollarEquipped(Game.GetPlayer())) && (bDevEquip)) 
		setDeviousOutfit ( iOutfitID= iDevOutfit, iOutfitPart = 0, bEquip = bDevEquip, sMessage = sDevMessage)

	ElseIf ((isCollarEquipped(Game.GetPlayer())) && (!bDevEquip))
		setDeviousOutfitByKeyword ( iOutfit= iDevOutfit, iOutfitPart = -1, ddArmorKeyword=libs.zad_DeviousCollar, bEquip = bDevEquip, sMessage = sDevMessage)
	EndIf
EndFunction

Function setDeviousOutfitArms ( Int iDevOutfit =-1, Bool bDevEquip = True, String sDevMessage = "")
	if ((!isArmsEquipped(Game.GetPlayer())) && (bDevEquip)) || ((isArmsEquipped(Game.GetPlayer())) && (!bDevEquip))
		setDeviousOutfit ( iOutfitID= iDevOutfit, iOutfitPart = 1, bEquip = bDevEquip, sMessage = sDevMessage)
	EndIf
EndFunction

Function setDeviousOutfitLegs ( Int iDevOutfit =-1, Bool bDevEquip = True, String sDevMessage = "")
	if ((!isLegsEquipped(Game.GetPlayer())) && (bDevEquip)) || ((isLegsEquipped(Game.GetPlayer())) && (!bDevEquip))
		setDeviousOutfit ( iOutfitID= iDevOutfit, iOutfitPart = 2, bEquip = bDevEquip, sMessage = sDevMessage)
	EndIf
EndFunction

Function setDeviousOutfitGag ( Int iDevOutfit =-1, Bool bDevEquip = True, String sDevMessage = "")
	if ((!isGagEquipped(Game.GetPlayer())) && (bDevEquip)) || ((isGagEquipped(Game.GetPlayer())) && (!bDevEquip))
		setDeviousOutfit ( iOutfitID= iDevOutfit, iOutfitPart = 3, bEquip = bDevEquip, sMessage = sDevMessage)
	EndIf
EndFunction

Function setDeviousOutfitBlindfold ( Int iDevOutfit =-1, Bool bDevEquip = True, String sDevMessage = "")
	if ((!isBlindfoldEquipped(Game.GetPlayer())) && (bDevEquip)) || ((isBlindfoldEquipped(Game.GetPlayer())) && (!bDevEquip))
		setDeviousOutfit ( iOutfitID= iDevOutfit, iOutfitPart = 4, bEquip = bDevEquip, sMessage = sDevMessage)
	EndIf
EndFunction

Function setDeviousOutfitBelt ( Int iDevOutfit =-1, Bool bDevEquip = True, String sDevMessage = "")
	if ((!isBeltEquipped(Game.GetPlayer())) && (bDevEquip)) || ((isBeltEquipped(Game.GetPlayer())) && (!bDevEquip))
		setDeviousOutfit ( iOutfitID= iDevOutfit, iOutfitPart = 5, bEquip = bDevEquip, sMessage = sDevMessage)
	EndIf
EndFunction

Function setDeviousOutfitPlugAnal ( Int iDevOutfit =-1, Bool bDevEquip = True, String sDevMessage = "")
	if ((!isPlugAnalEquipped(Game.GetPlayer())) && (bDevEquip)) || ((isPlugAnalEquipped(Game.GetPlayer())) && (!bDevEquip))
		setDeviousOutfit ( iOutfitID= iDevOutfit, iOutfitPart = 6, bEquip = bDevEquip, sMessage = sDevMessage)
	EndIf
EndFunction

Function setDeviousOutfitPlugVaginal ( Int iDevOutfit =-1, Bool bDevEquip = True, String sDevMessage = "")	
	if ((!isPlugVaginalEquipped(Game.GetPlayer())) && (bDevEquip)) || ((isPlugVaginalEquipped(Game.GetPlayer())) && (!bDevEquip))
		setDeviousOutfit ( iOutfitID= iDevOutfit, iOutfitPart = 7, bEquip = bDevEquip, sMessage = sDevMessage)
	EndIf
EndFunction

Function setDeviousOutfitBra ( Int iDevOutfit =-1, Bool bDevEquip = True, String sDevMessage = "")
	if ((!isBraEquipped(Game.GetPlayer())) && (bDevEquip)) || ((isBraEquipped(Game.GetPlayer())) && (!bDevEquip))
		setDeviousOutfitByKeyword ( iOutfit= iDevOutfit, iOutfitPart = -1, ddArmorKeyword=libs.zad_DeviousBra, bEquip = bDevEquip, sMessage = sDevMessage)

	EndIf
EndFunction

Function setDeviousOutfitBoots( Int iDevOutfit =-1, Bool bDevEquip = True, String sDevMessage = "")
	if ((!isBootsEquipped(Game.GetPlayer())) && (bDevEquip)) || ((isBootsEquipped(Game.GetPlayer())) && (!bDevEquip))
		setDeviousOutfitByKeyword ( iOutfit= iDevOutfit, iOutfitPart = -1, ddArmorKeyword=libs.zad_DeviousBoots, bEquip = bDevEquip, sMessage = sDevMessage)

	EndIf
EndFunction


Function setDeviousOutfitID ( Int iOutfit, String sMessage = "")
	StorageUtil.SetIntValue(Game.GetPlayer(), "_SD_iOutfit", iOutfit)

	If (sMessage != "")
		Debug.MessageBox(sMessage)
	EndIf
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

	if (StorageUtil.StringListCount( kActor, "_SD_lDevicesKeyword") != 0)
		Debug.Trace("[SD] Register devious keywords - aborting - list already set")
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
			ddArmorKeyword = libs.zad_DeviousPlugVaginal 

			setDeviousOutfitPart ( iOutfitID, iOutfitPart, bEquip,  ddArmorInventory,  ddArmorRendered,  ddArmorKeyword, bDestroy)
		EndIf

	; --------------------------------------------------------------------------------------------
	ElseIf (iOutfitID == -1) ; No special outfit ID provided... fall back on generic item add/removal
		if (!bEquip)
			bDestroy = True
		EndIf

		If ( (iOutfitPart==0) || (iOutfitPart==-1) )
			; 0 - Collar - Zaz Iron Collar
		;	ddArmorRendered = zazIronCollarRendered 
		;	ddArmorInventory = zazIronCollar
		;	ddArmorKeyword = libs.zad_DeviousCollar 

		;	setDeviousOutfitPart ( iOutfitID, iOutfitPart, bEquip,  ddArmorInventory,  ddArmorRendered,  ddArmorKeyword)
			setDeviousOutfitByTags ( iOutfitID, iOutfitPart, bEquip, sMessage, True  )
		Else
			setDeviousOutfitByTags ( iOutfitID, iOutfitPart, bEquip, sMessage, True  )

		EndIf

	EndIf

	Utility.Wait(0.5)

	If (sMessage != "")
		Debug.MessageBox(sMessage)
	EndIf

EndFunction

Function clearCollar ( bool skipEvents = false, bool skipMutex = false )
	; Armor kCollar = libs.GetWornDeviceFuzzyMatch(libs.PlayerRef, libs.zad_DeviousCollar  )
	libs.ManipulateGenericDeviceByKeyword(libs.PlayerRef, libs.zad_DeviousCollar, False, skipEvents,  skipMutex)
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
			ddArmorKeyword = StorageUtil.FormListGet( kMaster, "_SD_lDevicesKeyword", iOutfitPart) as Keyword 
		Else
			ddArmorKeyword = StorageUtil.FormListGet( kSlave, "_SD_lDevicesKeyword", iOutfitPart) as Keyword 
		EndIf
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
			Debug.Trace("[SD] Aborting device update - no device found"  )
		EndIf

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
			Debug.Trace("[SD] Aborting device update - no device found"  )
		EndIf
	Else
		; If iOutfitPart = -1, use purely generic device functions

		Debug.Trace("[SD] Set device by keyword only: " + ddArmorKeyword )

		libs.ManipulateGenericDeviceByKeyword(kSlave, ddArmorKeyword, bEquip, skipEvents = false, skipMutex = false)

	EndIf

EndFunction

Function setDeviousOutfitPart ( Int iOutfitID, Int iOutfitPart = -1, Bool bEquip = True, Armor ddArmorInventory, Armor ddArmorRendered, Keyword ddArmorKeyword, Bool bDestroy = False)

	if (iOutfitPart!=-1) 
		libs.Log("[SD] SetOutfit: ID:" + iOutfitID + " - Part: "  + iOutfitPart + " - Equip: "  + bEquip )

		if (bEquip) 
			
			if (!isDeviousOutfitPartEquipped ( libs.PlayerRef, iOutfitPart ))

				libs.Log("[SD] SetOutfit: equip - " + iOutfitID + " [ " + iOutfitPart + "]")
				libs.EquipDevice(libs.PlayerRef, ddArmorInventory , ddArmorRendered , ddArmorKeyword)
			Else
				libs.Log("[SD] SetOutfit: equip - " + iOutfitID + "skipped - device already equipped " )
			EndIf

		Else

			If (bDestroy)
				libs.Log("[SD] SetOutfit: destroy - " + iOutfitID + " [ " + iOutfitPart + "] " )

				if libs.PlayerRef.GetItemCount(ddArmorInventory) > 0
	 				libs.RemoveDevice(libs.PlayerRef, ddArmorInventory , ddArmorRendered , ddArmorKeyword, True, False, True)
	 			Else
	 			 	libs.Log("[SD] No matching item found in inventory - " + ddArmorInventory)
				EndIf
	 			
	 			; libs.ManipulateGenericDeviceByKeyword(libs.PlayerRef, ddArmorKeyword, bEquip, True, False)
			Else
				libs.Log("[SD] SetOutfit: remove - " + iOutfitID + " [ " + iOutfitPart + "] " )

				if libs.PlayerRef.GetItemCount(ddArmorInventory) > 0
	 				libs.RemoveDevice(libs.PlayerRef, ddArmorInventory , ddArmorRendered , ddArmorKeyword, False, False, False)
	 			Else
	 			 	libs.Log("[SD] No matching item found in inventory - " + ddArmorInventory)
				EndIf

	 			; libs.ManipulateGenericDeviceByKeyword(libs.PlayerRef, ddArmorKeyword, bEquip, False, False)
			EndIf

		EndIf
	EndIf

EndFunction
 
Function clearDevicesForEnslavement()

	If !isCollarEquippedKeyword( Game.getPlayer(),  "_SD_DeviousSanguine"  ) && !isCollarEquippedKeyword( Game.getPlayer(),  "_SD_DeviousEnslaved"  )
		setDeviousOutfitByKeyword ( iOutfit = -1, iOutfitPart = 0, ddArmorKeyword = libs.zad_DeviousCollar, bEquip = False, sMessage = "" , bDestroy = True)
	EndIf

	If !isArmsEquippedKeyword( Game.getPlayer(),  "_SD_DeviousSanguine"  ) && !isArmsEquippedKeyword( Game.getPlayer(),  "_SD_DeviousSpriggan"  ) && !isArmsEquippedKeyword( Game.getPlayer(),  "_SD_DeviousEnslaved"  )
		setDeviousOutfitByKeyword ( iOutfit = -1, iOutfitPart = 1, ddArmorKeyword = libs.zad_DeviousArmCuffs, bEquip = False, sMessage = "" , bDestroy = True)
	EndIf

	If !isLegsEquippedKeyword( Game.getPlayer(),  "_SD_DeviousSanguine"  ) && !isLegsEquippedKeyword( Game.getPlayer(),  "_SD_DeviousSpriggan"  ) && !isLegsEquippedKeyword( Game.getPlayer(),  "_SD_DeviousEnslaved"  )
		setDeviousOutfitByKeyword ( iOutfit = -1, iOutfitPart = 2, ddArmorKeyword = libs.zad_DeviousLegCuffs, bEquip = False, sMessage = "" , bDestroy = True)
	EndIf

EndFunction

Function addPunishment(Bool bDevGag = False, Bool bDevBlindfold = False, Bool bDevBelt = False, Bool bDevPlugAnal = False, Bool bDevPlugVaginal = False, Bool bDevArmbinder = False)
	Actor kPlayer = Game.getPlayer() as Actor
	Int    playerGender = kPlayer.GetLeveledActorBase().GetSex() as Int
	Actor kMaster = StorageUtil.GetFormValue(Game.GetPlayer(), "_SD_CurrentOwner") as Actor
	Int 	isMasterSpeaking = StorageUtil.GetIntValue(kMaster, "_SD_iSpeakingNPC")

	If (bDevPlugAnal) && (isMasterSpeaking==1)
		Debug.MessageBox("'Your ass is still too tight for my taste slave... this will teach you to disobey me.'\n Your owner viciously inserts a cold plug inside your ass." )
		Debug.Trace("[_sdqs_fcts_outfit] Adding punishment item: Anal plug" )
			
		setDeviousOutfitBelt ( bDevEquip = False, sDevMessage = "")
		setDeviousOutfitPlugAnal ( bDevEquip = True, sDevMessage = "")
		setDeviousOutfitBelt ( bDevEquip = True, sDevMessage = "")
	EndIf

	If (bDevPlugVaginal) && (playerGender==1) && (isMasterSpeaking==1)
		Debug.MessageBox("'Your are a cunt and need to be treated like one.'\n Your owner smiles wickedly and shoves a cold plug into your abused womb." )
		Debug.Trace("[_sdqs_fcts_outfit] Adding punishment item: Vaginal plug" )
		
		setDeviousOutfitBelt ( bDevEquip = False, sDevMessage = "")
		setDeviousOutfitPlugVaginal ( bDevEquip = True, sDevMessage = "")
		setDeviousOutfitBelt ( bDevEquip = True, sDevMessage = "")
	EndIf

	; Belt
	If (bDevBelt)  && (isMasterSpeaking==1)
		Debug.MessageBox("'Let's watch you squirm... that will change me from your attitude.'\n Your owner locks a chastity belt around your waist, making a point to let the metal pieces bite harshly into your skin." )
		Debug.Trace("[_sdqs_fcts_outfit] Adding punishment item: Belt" )
			
		setDeviousOutfitBelt ( bDevEquip = True, sDevMessage = "")
	EndIf

	; Blinds
	If (bDevBlindfold)
		Debug.MessageBox("Your owner sternly glares at you and covers your eyes with a blindfold, leaving you helpless." )
		Debug.Trace("[_sdqs_fcts_outfit] Adding punishment item: Blinds" )
			
		setDeviousOutfitBlindfold ( bDevEquip = True, sDevMessage = "")
	EndIf

	; Gag

	If (bDevGag) && (isMasterSpeaking==1)
		Debug.MessageBox("'I don't want to hear one more word from you!'\n Your owner shoves a gag into your mouth to muffle your screams and stop your constant whining." )
		Debug.Trace("[_sdqs_fcts_outfit] Adding punishment item: Gag" )

		setDeviousOutfitGag ( bDevEquip = True, sDevMessage = "")

	EndIf

EndFunction

Function removePunishment(Bool bDevGag = False, Bool bDevBlindfold = False, Bool bDevBelt = False, Bool bDevPlugAnal = False, Bool bDevPlugVaginal = False, Bool bDevArmbinder = False)
	Actor kPlayer = Game.getPlayer() as Actor
	Int    playerGender = kPlayer.GetLeveledActorBase().GetSex() as Int
	Actor kMaster = StorageUtil.GetFormValue(Game.GetPlayer(), "_SD_CurrentOwner") as Actor
	Int 	isMasterSpeaking = StorageUtil.GetIntValue(kMaster, "_SD_iSpeakingNPC")

	If (bDevPlugAnal) && !isPlugAnalEquippedKeyword( kPlayer, "_SD_DeviousParasiteAn"  ) && (isMasterSpeaking==1)
		Debug.MessageBox("The anal plug is removed, leaving you terribly sore and empty." )
		Debug.Trace("[_sdqs_fcts_outfit] Removing punishment item: Anal plug" )
			
		setDeviousOutfitBelt ( bDevEquip = False, sDevMessage = "")
		setDeviousOutfitPlugAnal ( bDevEquip = False, sDevMessage = "")
		setDeviousOutfitBelt ( bDevEquip = True, sDevMessage = "")
	EndIf

	If (bDevPlugVaginal) && !isPlugVaginalEquippedKeyword( kPlayer, "_SD_DeviousParasiteVag"  ) && (isMasterSpeaking==1)
		Debug.MessageBox("The vaginal plug is drenched as it is removed." )
		Debug.Trace("[_sdqs_fcts_outfit] Removing punishment item: Vaginal plug" )
			
		setDeviousOutfitBelt ( bDevEquip = False, sDevMessage = "")
		setDeviousOutfitPlugVaginal ( bDevEquip = False, sDevMessage = "")
		setDeviousOutfitBelt ( bDevEquip = True, sDevMessage = "")
	EndIf

	; Belt
	If (bDevBelt) && (isMasterSpeaking==1)
		Debug.MessageBox("The belt finally lets go of its grasp around your hips." )
		Debug.Trace("[_sdqs_fcts_outfit] Removing punishment item: Belt" )
			
		setDeviousOutfitBelt ( bDevEquip = False, sDevMessage = "")
	EndIf

	; Blinds
	If (bDevBlindfold)
		Debug.MessageBox("A flood of painful light makes you squint as the blindfold is removed." )
		Debug.Trace("[_sdqs_fcts_outfit] Removing punishment item: Blinds" )
			
		setDeviousOutfitBlindfold ( bDevEquip = False, sDevMessage = "")
	EndIf

	; Gag

	If (bDevGag) && (isMasterSpeaking==1)
		Debug.MessageBox("The gag is finally removed, leaving a screaming pain in your jaw." )
		Debug.Trace("[_sdqs_fcts_outfit] Removing punishment item: Gag "  )

		setDeviousOutfitGag ( bDevEquip = False, sDevMessage = "")

	EndIf

EndFunction

Function DDSetAnimating( Actor akActor, Bool isAnimating )
	libs.SetAnimating( akActor, isAnimating )
EndFunction


Keyword Property _SDKP_punish Auto
Keyword Property _SDKP_bound Auto
Keyword Property _SDKP_gagged Auto
Keyword Property ArmorCuirass  Auto  
Keyword Property ClothingBody  Auto  

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
