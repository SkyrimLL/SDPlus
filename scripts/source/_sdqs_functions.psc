Scriptname _SDQS_functions extends Quest Conditional
{ USED }
Import Utility
Import SKSE

Bool Property sdBleedout = False Auto Conditional

;Int[] uiSlotMask

Actor Function GetPlayerDialogueTarget()
	Actor kPlayerRef = Game.GetPlayer()
	Actor kTargetRef = None
	Actor kNthRef    = None
 
	Cell kCell       = kPlayerRef.GetParentCell()
	Int iType        = 43 ; kNPC = 43
	Int iIndex       = kCell.GetNumRefs( iType ) 
 
	While iIndex && !kTargetRef
		iIndex -= 1
		kNthRef = kCell.GetNthRef( iIndex, iType ) as Actor
		If kNthRef != kPlayerRef && kNthRef.IsInDialogueWithPlayer()
			kTargetRef = kNthRef
		EndIf
	EndWhile
 
	Return kTargetRef
EndFunction

Actor Function findClosestHostileActorToActor(Actor akActor, float afRadius = -1.0, Bool abLeveled = True )
	Actor kReturnNPC = None
	Actor kNthNPC = None
	Cell crParentCell = akActor.GetParentCell()
	Float dist = 0.0

	Int index = 0
	Int count = crParentCell.GetNumRefs(43) ; kNPC = 43

	While index < count
		kNthNPC = crParentCell.GetNthRef(index, 43) as Actor
		
		If ( !kNthNPC.IsDead() && !kNthNPC.IsDisabled() && kNthNPC.GetActorValue("Aggression") > 0 && kNthNPC.GetActorValue("Confidence") > 0  && kNthNPC.GetRelationshipRank(akActor) <= -3 && akActor.HasLOS( kNthNPC ) && ( kReturnNPC == None || dist > akActor.GetDistance( kNthNPC ) ) )
			kReturnNPC = kNthNPC
			dist = akActor.GetDistance( kNthNPC )
		EndIf
		
		index += 1
	EndWhile

	If ( abLeveled )
		index = 0
		count = crParentCell.GetNumRefs(44) ; kLeveledCharacter = 44

		While index < count
			kNthNPC = crParentCell.GetNthRef(index, 44) as Actor
			
			If ( !kNthNPC.IsDead() && !kNthNPC.IsDisabled() && kNthNPC.GetActorValue("Aggression") > 0 && kNthNPC.GetActorValue("Confidence") > 0  && kNthNPC.GetRelationshipRank(akActor) <= -3 && akActor.HasLOS( kNthNPC ) && ( kReturnNPC == None || dist > akActor.GetDistance( kNthNPC ) ) )
				kReturnNPC = kNthNPC
				dist = akActor.GetDistance( kNthNPC )
			EndIf
			
			index += 1
		EndWhile
	EndIf

	If ( afRadius < 0.0 || dist <= afRadius )
		Return kReturnNPC
	Else
		Return None
	EndIf

EndFunction

Bool Function actorInWeakenedState( Actor akActor, Float afThreshold = 0.05 )
	Bool weakened = ( akActor.GetActorValuePercentage("health") <= afThreshold )

	; Debug.Notification("[_sdqs_functions] Weakened state: Base: " + akActor.GetBaseAV("health") )
	; Debug.Notification("[_sdqs_functions] Weakened state: " + akActor.GetActorValuePercentage("health") + "[" +afThreshold + "]")

	If (0 == 1) && ( weakened && !sdBleedout ) ; disabled because of DA
		sdBleedout = True
		Weapon krHand = akActor.GetEquippedWeapon()
		Weapon klHand = akActor.GetEquippedWeapon( True )
		If ( krHand )
			akActor.DropObject( krHand )
		EndIf
		If ( klHand )
			akActor.DropObject( klHand )
		EndIf

		akActor.StopCombatAlarm()
		akActor.StopCombat()
		Game.ForceThirdPerson()
		; Debug.SendAnimationEvent(akActor, "bleedOutStart")
	ElseIf (0 == 1) && ( sdBleedout && !weakened )
		sdBleedout = False
		; Debug.SendAnimationEvent(akActor, "bleedOutStop")
		Game.ForceThirdPerson()
	ElseIf (0 == 1) && ( sdBleedout && weakened )
		; Debug.Notification("[_sdqs_functions] Actor both Weakened and in bleedout")
	ElseIf (0 == 1) && ( !sdBleedout && !weakened )
		; Debug.Notification("[_sdqs_functions] Actor not weakened or in bleedout")
	EndIf
	
	Return weakened
EndFunction

Bool Function actorInKillState( Actor akActor, Float afBaseAVMult = 1.0, Int aiForcedMortality = 0 )
	Float health = akActor.GetAV("health")
	Float basehealth = akActor.GetBaseAV("health") * afBaseAVMult  
	Bool bloodyMess =  ( ( health < 0 && basehealth < Math.abs( health ) ) || aiForcedMortality == 1 )

	; Debug.Trace("[_sdqs_functions] Killed state: Base: " + akActor.GetBaseAV("health") + " - " + Math.abs( afBaseAVMult ) + "[" +bloodyMess + "]")
	; Debug.Trace("[_sdqs_functions] Killed state: Health:" + Math.abs( health ) + "[" +bloodyMess + "]")

	If ( bloodyMess )
		; Debug.Notification("[_sdqs_functions] Actor in killed state")
	Else
		; Debug.Notification("[_sdqs_functions] Actor not dead yet")
	EndIf

	Return ( bloodyMess )
EndFunction

; 0: Dialogue Anger
; 1: Dialogue Fear
; 2: Dialogue Happy
; 3: Dialogue Sad
; 4: Dialogue Surprise
; 5: Dialogue Puzzled
; 6: Dialogue Disgusted
; 7: Mood Neutral
; 8: Mood Anger
; 9: Mood Fear
; 10: Mood Happy
; 11: Mood Sad
; 12: Mood Surprise
; 13: Mood Puzzled
; 14: Mood Disgusted
; 15: Combat Anger
; 16: Combat Shout
Bool Function setRandomActorExpression( Actor akActor = None, Int baseIntensity = 40, Float timePassed = 0.0 )
	Int[] expressionType = New Int[3]
	Int min
	Int max

	If ( baseIntensity < 0 )
		akActor.ClearExpressionOverride()
		Return True
	EndIf

	If ( timePassed < 12.0 )
		min = intWithinRange( baseIntensity + 40, 0, 100)
		max = intWithinRange( baseIntensity + 60, 0, 100)
		expressionType[0] = 16  ; shout
		expressionType[1] = 15 ; anger
		expressionType[2] = 11 ; sad
	ElseIf ( timePassed < 36.0 )
		min = intWithinRange( baseIntensity + 20, 0, 100)
		max = intWithinRange( baseIntensity + 40, 0, 100)
		expressionType[0] = 13 ; puzzled
		expressionType[1] = 11 ; sad
		expressionType[2] = 12 ; surprise
	Else
		min = intWithinRange( baseIntensity, 0, 100)
		max = intWithinRange( baseIntensity + 20, 0, 100)
		expressionType[0] = 12 ; surprise
		expressionType[1] = 7  ; neutral
		expressionType[2] = 10 ; happy
	EndIf

	Return akActor.SetExpressionOverride( expressionType[ RandomInt(0, expressionType.Length - 1) ] ,RandomInt( min, max ) ) as Bool
EndFunction

Bool Function actorFactionInList( Actor akActor, FormList akFactionList, FormList akBannedFactionList = None )
	Int index
	Int size
	Bool found = False
	Bool banned = False

	If ( akActor && !akActor.IsEssential() && !akActor.IsDead() )
		If ( akBannedFactionList )
			index = 0
			size = akBannedFactionList.GetSize()
			While ( index < size && !banned )
				banned = akActor.IsInFaction( akBannedFactionList.GetAt(index) as Faction )
				index += 1
			EndWhile
		EndIf

		If ( !banned )
			index = 0
			size = akFactionList.GetSize()
			While ( index < size && !found )
				found = akActor.IsInFaction( akFactionList.GetAt(index) as Faction )
				index += 1
			EndWhile
		EndIf
	EndIf

	Debug.Trace("_SD::actorFactionInList akActor:" + akActor + " found:" + found )
	Return found
EndFunction

Bool Function qualifyActor( Actor akActor, Bool abCheckInScene = True )
	Bool bOutOfScene = ( !abCheckInScene || ( abCheckInScene && akActor.GetCurrentScene() == None ) )
	Return ( !akActor.IsDead() && !akActor.IsDisabled() && bOutOfScene )
EndFunction

Function playerAutoPilot( Bool abEnable = True )
	If ( abEnable )
	;	Game.DisablePlayerControls( abCamSwitch = True, abSneaking = True )
		Game.ForceThirdPerson()
	;	Game.SetPlayerAIDriven()
	Else
	;	Game.EnablePlayerControls( abFighting = False, abMenu = False )
	;	Game.SetPlayerAIDriven( False)
	EndIf
EndFunction

Function actorCombatShutdown( Actor akActor )
	If ( !akActor )
		Return
	EndIf

	; Debug.Notification("[_sdqs_functions] Actor ordered to stand down")
	Debug.SendAnimationEvent(akActor, "UnequipNoAnim")

	If ( akActor.IsSneaking() )
		akActor.StartSneaking()
	EndIf
	akActor.StopCombatAlarm()
	akActor.Stopcombat()
	; Debug.Notification("[_sdqs_functions] Actor should be calm now")
EndFunction

Float Function syncActorPosition ( Actor akActorM, Actor akActorF, Float afOffsetX = 0.0, Float afOffsetY = 0.0, Float afOffsetZ = 0.0, Bool abSameFacing = False, Bool abFlip = False, Float afOffsetD = 100.0 )
	Float fAngle = 0.0
	Float fFacing = 0.0
	If ( abFlip )
		fAngle = 180.0
	EndIf
	
	Float fScaleOffset = 1/( ( akActorM.GetScale() + akActorF.GetScale() ) / 2 )

	Float pX1 = 0.0
	Float pX2 = akActorM.X
	Float pY1 = 0.0
	Float pY2 = akActorM.Y
	Float pZ1 = 0.0
	Float pZ2 = akActorM.Z
	Float aX = akActorM.GetAngleX()
	Float aY = akActorM.GetAngleY()
	Float aZ = akActorM.GetAngleZ() + fAngle
	Float oX = (afOffsetD + afOffsetX) * Math.sin( aZ ) * fScaleOffset
	Float oY = (afOffsetD + afOffsetX) * Math.cos( aZ ) * fScaleOffset
	
	pX1 += oX
	pX2 += oX
	pY1 += oY
	pY2 += oY
	pZ1 += afOffsetZ
	pZ2 += afOffsetZ
	
	If ( abSameFacing )
		fFacing = akActorM.GetAngleZ()
	Else
		fFacing = akActorF.GetAngleZ() + akActorF.GetHeadingAngle( akActorM )
	EndIf
	
	akActorF.MoveTo(akActorM, pX1, pY1, pZ1)
	akActorF.TranslateTo(pX2, pY2, pZ2,  akActorF.GetAngleX(), akActorF.GetAngleY(), fFacing, 200.0 )
	
	Return akActorF.GetDistance( akActorM )
EndFunction

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

Bool Function isArmorRemovable ( Armor kArmor )
	If ( !kArmor  )
		Return False
	EndIf

	Return (!kArmor.HasKeywordString("_SD_nounequip")  && !kArmor.HasKeywordString("_SD_Spriggan")  && !kArmor.HasKeywordString("SOS_Underwear")  && !kArmor.HasKeywordString("SOS_Genitals") && !kArmor.HasKeywordString("_SLMC_MCdevice") && !kArmor.HasKeywordString("SexLabNoStrip") && !kArmor.hasKeywordString("zad_Lockable") && !kArmor.hasKeywordString("zad_deviousplug") && !kArmor.hasKeywordString("zad_DeviousArmbinder") )

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
			If ( kArmor && isArmorRemovable( kArmor ) )
				If ( bDrop )
					akActor.DropObject(kArmor as Armor, 1 )
				Else
					akActor.UnequipItem(kArmor as Armor, False, True )
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
		If ( kShield && isArmorRemovable( kShield ) )
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

Function limitedRemoveAllItems ( ObjectReference akContainer, ObjectReference akTransferTo = None, Bool abSilent = True, FormList akIgnored = None )
	Int iFormIndex = 0
	Bool bDeviousDeviceEquipped = False

	; First - limited removal of equipped items according to SexLab Consensual settings

	form[] slaveEquipment = SexLab.StripActor(akContainer as Actor)

	iFormIndex = slaveEquipment.Length

	While ( iFormIndex > 0 )
		iFormIndex -= 1
		Form kForm = slaveEquipment[iFormIndex]

		bDeviousDeviceEquipped = ( Game.GetPlayer().isEquipped(kForm) && (kForm.HasKeywordString("SexLabNoStrip") || kForm.hasKeywordString("zad_Lockable") || kForm.hasKeywordString("zad_deviousplug") || kForm.hasKeywordString("zad_DeviousArmbinder")) )

		If ( kForm && akIgnored && akIgnored.HasForm( kForm ) )
			; continue
		ElseIf ( kForm &&  uiTypes.Find( kForm.GetType() ) > -1 && !kForm.HasKeywordString("VendorNoSale") && !kForm.HasKeywordString("MagicDisallowEnchanting")  && !kForm.HasKeywordString("SOS_Underwear")  && !kForm.HasKeywordString("SOS_Genitals") && !kForm.HasKeywordString("_SLMC_MCDevice") && ( !bDeviousDeviceEquipped || !( Game.GetPlayer().isEquipped(kForm) && kForm.hasKeywordString("zad_DeviousGag")) ) ) 
			; akContainer.RemoveItem(kForm, akContainer.GetItemCount( kForm ), abSilent, akTransferTo)
			akTransferTo.AddItem(kForm, akContainer.GetItemCount( kForm ))
		EndIf
	EndWhile

	; Send all items in Equipment to akTransferTo

	Int[] uiTypes = New Int[12]
	uiTypes[0] = 23; kScrollItem = 23
	uiTypes[1] = 26; kArmor = 26
	uiTypes[2] = 27; kBook = 27
	uiTypes[3] = 30; kIngredient = 30
	uiTypes[4] = 32; kMisc = 32
	uiTypes[6] = 41; kWeapon = 41
	uiTypes[7] = 42; kAmmo = 42
	uiTypes[8] = 45; kKey = 45
	uiTypes[9] = 46; kPotion = 46
	uiTypes[10] = 48; kNote = 48
	uiTypes[11] = 52; kSoulGem = 52

	; iFormIndex = 0 ; Secondary loop disabled for now - undress only ;  akContainer.GetNumItems()

	While ( iFormIndex > 0 )
		iFormIndex -= 1
		Form kForm = akContainer.GetNthForm(iFormIndex)

		bDeviousDeviceEquipped = ( Game.GetPlayer().isEquipped(kForm) && (kForm.HasKeywordString("SexLabNoStrip") || kForm.hasKeywordString("zad_Lockable") || kForm.hasKeywordString("zad_deviousplug") || kForm.hasKeywordString("zad_DeviousArmbinder")) )

		If ( kForm && akIgnored && akIgnored.HasForm( kForm ) ) || (uiTypes.Find( kForm.GetType() ) == 26)
			; continue
		ElseIf ( kForm &&  uiTypes.Find( kForm.GetType() ) > -1 && !kForm.HasKeywordString("VendorNoSale") && !kForm.HasKeywordString("MagicDisallowEnchanting")  && !kForm.HasKeywordString("_SLMC_MCDevice")  && !kForm.HasKeywordString("SOS_Underwear")  && !kForm.HasKeywordString("SOS_Genitals") && ( !bDeviousDeviceEquipped || !( Game.GetPlayer().isEquipped(kForm) && kForm.hasKeywordString("zad_DeviousGag")) ) ) 
			akContainer.RemoveItem(kForm, akContainer.GetItemCount( kForm ), abSilent, akTransferTo)
		EndIf
	EndWhile
EndFunction

Function removeItemsInList( Actor akActor, FormList akItemList )
	Int idx = 0
	Int iCount = 0
	Armor nthArmor = None
	Form kForm

	if (akActor)
		While idx < akItemList.GetSize()
			kForm = akItemList.GetAt(idx) 
			; nthArmor = kForm as Armor
			if (kForm)
				iCount = akActor.GetItemCount( kForm as Armor )
				If ( iCount ) && (kForm as Armor)
					akActor.RemoveItem( kForm as Armor, iCount, True )
				EndIf
			EndIf
			idx += 1
		EndWhile
	EndIf
EndFunction


Bool Function isPunishmentEquiped (  Actor akActor )

	If ( akActor.WornHasKeyword( _SDKP_punish ) )
		Return True
	Else

		Int[] uiSlotMask = New Int[12]
		uiSlotMask[0]  = 0x00000008 ;33  Bindings / DD Armbinders
		uiSlotMask[1]  = 0x00008000 ;45  Collar / DD Collars / DD Cuffs (Neck)
		uiSlotMask[2] = 0x00040000 ;48  Ankles / DD plugs (Anal)
		uiSlotMask[3] = 0x02000000 ;55  Gag / DD Blindfold
		uiSlotMask[4] = 0x00004000 ;44  DD Gags Mouthpieces
		uiSlotMask[5] = 0x00080000 ;49  DD Chastity Belts
		uiSlotMask[6] = 0x00800000  ;53  DD Cuffs (Legs)
		uiSlotMask[7] = 0x04000000 ;56  DD Chastity Bra
		uiSlotMask[8] = 0x20000000  ;59  DD Armbinder / DD Cuffs (Arms)
		uiSlotMask[9]  = 0x00000004 ;32  Spriggan host
		uiSlotMask[10]  = 0x00100000 ;50  DD Gag Straps
		uiSlotMask[11]  = 0x01000000 ;54  DD Plugs (Vaginal)

		Int iFormIndex = uiSlotMask.Length
		Bool bDeviousDeviceEquipped = False

		While ( iFormIndex > 0 )
			iFormIndex -= 1
			Form kForm = akActor.GetWornForm( uiSlotMask[iFormIndex] ) 
			If (kForm != None)
				Armor kArmor = kForm  as Armor
				bDeviousDeviceEquipped = (kForm.HasKeywordString("SexLabNoStrip") || kForm.HasKeywordString("_SD_Spriggan")  || kForm.hasKeywordString("zad_Lockable") || kForm.hasKeywordString("zad_deviousPlugAnal")  || kForm.hasKeywordString("zad_deviousPlugVaginal") || kForm.hasKeywordString("zad_deviousCollar")|| kForm.hasKeywordString("zad_DeviousArmbinder")) 
			Else
				bDeviousDeviceEquipped = False
			EndIf

			If bDeviousDeviceEquipped
				return True 
			EndIf

		EndWhile
	EndIf

	Return False
EndFunction


Bool Function isBindingEquiped (  Actor akActor )

	If ( akActor.WornHasKeyword( _SDKP_bound ) )
		Return True
	Else

		Int[] uiSlotMask = New Int[1]
		uiSlotMask[0]  = 0x00000008 ;33  Bindings / DD Armbinders

		Int iFormIndex = uiSlotMask.Length
		Bool bDeviousDeviceEquipped = False

		While ( iFormIndex > 0 )
			iFormIndex -= 1
			Form kForm = akActor.GetWornForm( uiSlotMask[iFormIndex] ) 
			If (kForm != None)
				Armor kArmor = kForm  as Armor
				bDeviousDeviceEquipped = ( akActor.isEquipped(kForm) && (kForm.HasKeywordString("SexLabNoStrip") || kForm.hasKeywordString("zad_Lockable")  || kForm.hasKeywordString("zad_DeviousArmbinder")) )
			Else
				bDeviousDeviceEquipped = False
			EndIf

			If bDeviousDeviceEquipped
				return True 
			EndIf

		EndWhile
	EndIf

	Return False
EndFunction

Bool Function isGagEquiped (  Actor akActor )

	If ( akActor.WornHasKeyword( _SDKP_gagged ) )
		Return True
	Else

		Int[] uiSlotMask = New Int[2]
		uiSlotMask[0] = 0x02000000 ;55  Gag
		uiSlotMask[1] = 0x00004000 ;44  DD Gags

		Int iFormIndex = uiSlotMask.Length
		Bool bDeviousDeviceEquipped = False

		While ( iFormIndex > 0 )
			iFormIndex -= 1
			Form kForm = akActor.GetWornForm( uiSlotMask[iFormIndex] ) 
			If (kForm != None)
				Armor kArmor = kForm  as Armor
				bDeviousDeviceEquipped = ( akActor.isEquipped(kForm) && (kForm.HasKeywordString("SexLabNoStrip") || kForm.hasKeywordString("zad_Lockable")  ) )
			Else
				bDeviousDeviceEquipped = False
			EndIf

			If bDeviousDeviceEquipped
				return True 
			EndIf

		EndWhile
	EndIf

	Return False
EndFunction
; alter game defaults to my defaults
Function togglePlayerControlsOff( Bool abOff = True, Bool abMove = False, Bool abAct = False )
	If ( abOff )
		; abMovement: Disable the player's movement controls.
		; Default: True
		; abFighting: Disable the player's combat controls.
		; Default: True
		; abCamSwitch: Disable the ability to switch point of view.
		; Default: False
		; abLooking: Disable the player's look controls.
		; Default: False
		; abSneaking: Disable the player's sneak controls.
		; Default: False
		; abMenu: Disables menu controls (Journal, Inventory, Pause, etc.).
		; Default: True
		; abActivate: Disables ability for player to activate objects.
		; Default: True
		; abJournalTabs: Disables all Journal tabs except System.
		; Default: False
		; aiDisablePOVType: What system is disabling POV.
		; 0 = Script
		; 1 = Werewolf
		; Default: 0
		Game.DisablePlayerControls( abMovement = abMove, abActivate = abAct )
	Else
		Game.EnablePlayerControls( )
	EndIf
EndFunction

Function resetAllyToActor( Actor akSlave, FormList alFactionListIn )
	Int index = 0
	Int size = alFactionListIn.GetSize()

	While ( index < size )
		Faction nTHfaction = alFactionListIn.GetAt(index) as Faction
		akSlave.RemoveFromFaction( nTHfaction )
		index += 1
	EndWhile

	alFactionListIn.Revert()
EndFunction

Function transferFormListContents( FormList alFactionListIn, FormList alFactionListOut )
	Int index = 0
	Int size = alFactionListIn.GetSize()

	While ( index < size )
		Faction nTHfaction = alFactionListIn.GetAt(index) as Faction
		alFactionListOut.AddForm( nTHfaction )
		index += 1
	EndWhile

	alFactionListIn.Revert()
EndFunction


Bool Function allyToActor( Actor akMaster, Actor akSlave, FormList alFactionListIn, FormList alFactionListOut = None )
	Int index = 0
	Int size = alFactionListIn.GetSize()
	Bool ret = False

	If ( akMaster == None || akSlave == None )
		Return ret
	EndIf

	If ( alFactionListOut != None && alFactionListOut.GetSize() > 0 )
		resetAllyToActor( akSlave, alFactionListOut )
	EndIf

	If ( !qualifyActor( akMaster, False ) )
		Return ret
	EndIf

	While ( index < size )
		Faction nTHfaction = alFactionListIn.GetAt(index) as Faction

		If ( akMaster.IsInFaction( nTHfaction ) && !akSlave.IsInFaction( nTHfaction ) )
			If ( alFactionListOut != None )
				alFactionListOut.AddForm( nTHfaction )
			EndIf
			akSlave.AddToFaction( nTHfaction )
			ret = True
		EndIf
		index += 1
	EndWhile

	Return ret
EndFunction

Function syncActorFactions( Actor akMaster, Actor akSlave, FormList alFactionListOut = None )

	Int iFormIndex = ( akMaster as ObjectReference ).GetNumItems()
	While ( iFormIndex > 0 )
		iFormIndex -= 1
		Form nthForm = ( akMaster as ObjectReference ).GetNthForm(iFormIndex)
		If ( nthForm && nthForm.GetType() == 11 )
			If ( alFactionListOut != None )
				alFactionListOut.AddForm( nthForm as Faction )
			EndIf
			akSlave.AddToFaction( nthForm as Faction )
		EndIf
	EndWhile

EndFunction

Function sendCaptiveFollowerAway( Actor akFollower)

	Int iFormIndex = _SD_CaptiveFollowersLocations.length

	(akFollower as ObjectReference).MoveTo(_SD_CaptiveFollowersLocations[Utility.RandomInt(0,iFormIndex)] as ObjectReference)

EndFunction


Function stashStolenGoods( Actor akThief, ObjectReference akContainer )
	ActorBase kThiefBase = akThief.GetActorBase()
	Int iFormIndex = ( akThief as ObjectReference ).GetNumItems()

	Int[] stashTypes = new Int[6]
	stashTypes[0] = 26 ;kArmo
	stashTypes[1] = 27 ;kBook
	stashTypes[2] = 30 ;kIngredient
	stashTypes[3] = 41 ;kWeapon
	stashTypes[4] = 46 ;kPotion
	stashTypes[5] = 48 ;kNote

	While ( iFormIndex > 0 )
		iFormIndex -= 1
		Form nthForm = ( akThief as ObjectReference ).GetNthForm(iFormIndex)
		If ( nthForm && stashTypes.Find( nthForm.GetType() ) && ( nthForm as ObjectReference ).GetActorOwner() != kThiefBase )
			akThief.RemoveItem(nthForm, akThief.GetItemCount(nthForm), True, akContainer)
		EndIf
	EndWhile
EndFunction

Function stashAllStolenGoods( Actor akThief, ObjectReference akContainer )
	ActorBase kThiefBase = akThief.GetActorBase()
	Int iFormIndex = ( akThief as ObjectReference ).GetNumItems()

	Int[] stashTypes = new Int[6]
	stashTypes[0] = 26 ;kArmo
	stashTypes[1] = 27 ;kBook
	stashTypes[2] = 30 ;kIngredient
	stashTypes[3] = 41 ;kWeapon
	stashTypes[4] = 46 ;kPotion
	stashTypes[5] = 48 ;kNote

	While ( iFormIndex > 0 )
		iFormIndex -= 1
		Form nthForm = ( akThief as ObjectReference ).GetNthForm(iFormIndex)
		If ( nthForm   )
			akThief.RemoveItem(nthForm, akThief.GetItemCount(nthForm), True, akContainer)
		EndIf
	EndWhile
EndFunction

;; UTILITY FUNCTIONS
Int Function intMax( Int iA, Int iB )
	If ( iA >= iB )
		Return iA
	Else
		Return iB
	EndIf
EndFunction

Int Function intMin( Int iA, Int iB )
	If ( iA <= iB )
		Return iA
	Else
		Return iB
	EndIf
EndFunction

Float Function floatMax( Float iA, Float iB )
	If ( iA >= iB )
		Return iA
	Else
		Return iB
	EndIf
EndFunction

Float Function floatMin( Float iA, Float iB )
	If ( iA <= iB )
		Return iA
	Else
		Return iB
	EndIf
EndFunction

Int Function intWithinRange( Int in, Int low, Int high )
	If ( in < low )
		Return low
	EndIf
	If ( in > high )
		Return high
	EndIf
	Return in
EndFunction

Float Function floatWithinRange( Float in, Float low, Float high )
	If ( in < low )
		Return low
	EndIf
	If ( in > high )
		Return high
	EndIf
	Return in
EndFunction

Bool Function floatInRange( Float in, Float low, Float high )
	Return ( in >= low && in <= high )
EndFunction

Bool Function intInRange( Int in, Int low, Int high )
	Return ( in >= low && in <= high )
EndFunction

Float Function floatLinearInterpolation( Float bA, Float bB, Float aA, Float a, Float aB )
	Return bA + ( bB - bA )*(( a - aA )/( aB - aa ))
EndFunction

Function ArrayClear(Form[] myArray)
	Int idx = 0
	While idx < myArray.Length
		myArray[idx] = None
		idx += 1
	EndWhile
EndFunction

Bool Function isArrayClear(Form[] myArray)
	Bool bClear = True
	Int idx = 0
	While bClear && idx < myArray.Length
		bClear = ( myArray[idx] == None )
		idx += 1
	EndWhile
	Return bClear
EndFunction

Bool Function checkGenderRestriction(Actor akSpeaker, Actor akTarget)
	Int    speakerGender = akSpeaker.GetLeveledActorBase().GetSex() as Int
	Int    targetGender = akTarget.GetLeveledActorBase().GetSex() as Int
	Int    genderRestrictions = _SDGVP_gender_restrictions.GetValue() as Int

	return (genderRestrictions  == 0) || ( (genderRestrictions  == 1) && (speakerGender  == targetGender ) ) || ( (genderRestrictions  == 2) && (speakerGender  != targetGender ) ) 

EndFunction

Function SanguineRape(Actor akSpeaker, Actor akTarget, String SexLabInTags = "Aggressive", String SexLabOutTags = "Solo")


	If (!akSpeaker)
		Return
	EndIf
	
	If (!akTarget)
		Return
	EndIf
	
	Int    speakerGender = akSpeaker.GetLeveledActorBase().GetSex() as Int
	Int    targetGender = akTarget.GetLeveledActorBase().GetSex() as Int
	Int    genderRestrictions = _SDGVP_gender_restrictions.GetValue() as Int

	; Devious devices and punishment items restrictions
	; Debug.Notification("[SD sex] Speaker gender: " + speakerGender + " [ " + akSpeaker + " ] ")
	; Debug.Notification("[SD sex] Target gender: " + targetGender + " [ " + akTarget + " ] ")

	; If (akTarget == Game.GetPlayer())

		; uiSlotMask[6] = 0x00800000  ;53  DD Cuffs (Legs)
		; uiSlotMask[7] = 0x04000000 ;56  DD Chastity Bra
		; uiSlotMask[8] = 0x20000000  ;59  DD Cuffs (Arms)

		; Masturbation scenes
		If ((SexLabInTags == "Masturbation") || (SexLabOutTags == "Masturbation")) && (SexLab.ValidateActor( akSpeaker ) > 0)

			If (SexLabInTags == "Masturbation")  
				If (speakerGender  == 0)
					SexLabInTags = "Masturbation,M"
				Else
					SexLabInTags =  "Masturbation,F"
				EndIf

				; actor[] sexActors = new actor[1]
				; sexActors[0] = akSpeaker
				; sslBaseAnimation[] animations = SexLab.GetAnimationsByTags(1,  SexLabInTags)
				; SexLab.StartSex(sexActors, animations)

				SexLab.QuickStart(akSpeaker, AnimationTags = SexLabInTags)

			EndIf

			If (SexLabOutTags == "Masturbation")  
				If (targetGender  == 0)
					SexLabInTags = "Masturbation,M"
				Else
					SexLabInTags =  "Masturbation,F"
				EndIf

				; actor[] sexActors = new actor[1]
				; sexActors[0] = akTarget
				; sslBaseAnimation[] animations = SexLab.GetAnimationsByTags(1,  SexLabInTags)
				; SexLab.StartSex(sexActors, animations)

				SexLab.QuickStart(akTarget, AnimationTags = SexLabInTags)

			EndIf

		; Gender restrictions - 2 actors
		ElseIf checkGenderRestriction( akSpeaker,  akTarget)

			Int[] uiSlotMask = New Int[12]
			uiSlotMask[0] = 0x00000008 ;33  Bindings / DD Armbinders
			uiSlotMask[1] = 0x00008000 ;45  Collar / DD Collars / DD Cuffs (Neck)
			uiSlotMask[2] = 0x00040000 ;48  Ankles / DD plugs (Anal)
			uiSlotMask[3] = 0x02000000 ;55  Gag / DD Blindfold
			uiSlotMask[4] = 0x00004000 ;44  DD Gags Mouthpieces
			uiSlotMask[5] = 0x00080000 ;49  DD Chastity Belts
			uiSlotMask[6] = 0x00800000 ;53  DD Cuffs (Legs)
			uiSlotMask[7] = 0x04000000 ;56  DD Chastity Bra
			uiSlotMask[8] = 0x20000000 ;59  DD Armbinder / DD Cuffs (Arms)
			uiSlotMask[9] = 0x00000004 ;32  Spriggan host
			uiSlotMask[10]= 0x00100000 ;50  DD Gag Straps
			uiSlotMask[11]= 0x01000000 ;54  DD Plugs (Vaginal)

			Int iFormIndex = uiSlotMask.Length
			Form kForm

			; uiSlotMask[0]  = 0x00000008 ;33  Bindings / DD Armbinders
			kForm = akTarget.GetWornForm( uiSlotMask[0] ) 
			if (kForm)
				if (Game.GetPlayer().isEquipped(kForm) && (kForm.hasKeywordString("_SD_nounequip")  || kForm.hasKeywordString("zad_Lockable") || kForm.hasKeywordString("zad_DeviousArmbinder")) )
			;		SexLabInTags = SexLabInTags + ",Anal"
			;		SexLabOutTags = SexLabOutTags + ",Blowjob"
				EndIf
			EndIf

			; uiSlotMask[2] = 0x00040000 ;48  Ankles / DD plugs
			kForm = akTarget.GetWornForm( uiSlotMask[2] ) 
			if (kForm)
				if (Game.GetPlayer().isEquipped(kForm) && (kForm.hasKeywordString("zad_Lockable") || kForm.hasKeywordString("zad_DeviousPlug") ) )
			;		SexLabInTags = SexLabInTags + ",Oral"
			;		SexLabOutTags = SexLabOutTags + ",Anal,Vaginal"
				EndIf
			EndIf

			; uiSlotMask[3] = 0x02000000 ;55  Gag
			; uiSlotMask[4] = 0x00004000 ;44  DD Gags
			kForm = akTarget.GetWornForm( uiSlotMask[3] ) 
			if (kForm)
				if (Game.GetPlayer().isEquipped(kForm) && (kForm.hasKeywordString("_SD_nounequip")) )
			;		SexLabInTags = "Cuddling"
			;		SexLabOutTags = SexLabOutTags + ",Oral"
				EndIf		
			EndIf
			if (kForm)
				kForm = akTarget.GetWornForm( uiSlotMask[4] ) 
				if (Game.GetPlayer().isEquipped(kForm) && (kForm.hasKeywordString("zad_Lockable") || kForm.hasKeywordString("zad_DeviousGag") ) )
			;		SexLabInTags = "Cuddling"
			;		SexLabOutTags = SexLabOutTags + ",Oral"
				EndIf
			EndIf

			; uiSlotMask[5] = 0x00080000 ;49  DD Chastity Belts
			kForm = akTarget.GetWornForm( uiSlotMask[5] ) 
			if (kForm)
				if (Game.GetPlayer().isEquipped(kForm) && (kForm.hasKeywordString("zad_Lockable") || kForm.hasKeywordString("zad_DeviousBelt") ) )
			;		SexLabInTags = SexLabInTags + ",Kissing,Cuddling"
			;		SexLabOutTags = SexLabOutTags + ",Anal,Vaginal"
				EndIf
			EndIf
		
			If ( (genderRestrictions  == 1) && (speakerGender  == targetGender ) )
				If (speakerGender  == 0)
					SexLabInTags = SexLabInTags + ",MM"
				Else
					SexLabInTags = SexLabInTags + ",FF"
				EndIf
			ElseIf ( (genderRestrictions  == 2) && (speakerGender  != targetGender ) ) 
					
					If (speakerGender == 1) ; Mistress and Male slave
						SexLabInTags = SexLabInTags + ",Cowgirl"
					ElseIf  (speakerGender == 0) ; Master and Female slave
					;	SexLabInTags = SexLabInTags + ",Doggystyle"
					EndIf
			EndIf

			Debug.Trace("[_sd_naked] Gender check: Restrictions= " + genderRestrictions  + " [ " + akSpeaker + " / " + akTarget + " ] ")
			Debug.Trace("[_sd_naked] SexLabInTags= " + SexLabInTags )
			Debug.Trace("[_sd_naked] SexLabOutTags= " + SexLabOutTags)

			If  (SexLab.ValidateActor( akSpeaker ) > 0) &&  (SexLab.ValidateActor( akTarget ) > 0) 

				; actor[] sexActors = new actor[2]
				; sexActors[0] = akTarget
				; sexActors[1] = akSpeaker
				; sslBaseAnimation[] animations = SexLab.GetAnimationsByTags(2,  SexLabInTags,  SexLabOutTags)
				; SexLab.StartSex(sexActors, animations, victim = akTarget )

				; SexLab.QuickStart(SexLab.PlayerRef, akSpeaker, Victim = SexLab.PlayerRef, AnimationTags = "Aggressive")

				sslThreadModel Thread = SexLab.NewThread()
				Thread.AddActor(akTarget, true) ; // IsVictim = true
				Thread.AddActor(akSpeaker)
				Thread.SetAnimations(SexLab.GetAnimationsByTags(2, SexLabInTags,  SexLabOutTags))
				Thread.StartThread()

			EndIf
		Else
			Debug.Notification("[_sd_naked] Gender check failed: Restrictions= " + genderRestrictions  + " [ " + speakerGender + " / " + targetGender + " ] ")
		EndIf

	; Else
	; 	Debug.Notification("[_sd_naked] Target is not the player")
	; EndIf
EndFunction


GlobalVariable Property _SDGVP_naked_rape_chance Auto
GlobalVariable Property _SDGVP_naked_rape_delay Auto
GlobalVariable Property _SDGVP_gender_restrictions Auto
SexLabFrameWork Property SexLab Auto

Keyword Property _SDKP_punish Auto
Keyword Property _SDKP_bound Auto
Keyword Property _SDKP_gagged Auto

ObjectReference[] Property _SD_CaptiveFollowersLocations  Auto  