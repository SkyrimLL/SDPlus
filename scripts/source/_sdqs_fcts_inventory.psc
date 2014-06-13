Scriptname _sdqs_fcts_inventory extends Quest  
{ USED }
Import Utility
Import SKSE


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

SexLabFrameWork Property SexLab Auto

