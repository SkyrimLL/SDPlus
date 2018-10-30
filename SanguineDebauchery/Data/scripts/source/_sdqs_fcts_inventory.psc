Scriptname _sdqs_fcts_inventory extends Quest  
{ USED }
Import Utility
Import SKSE
SexLabFrameWork Property SexLab Auto
_SDQS_fcts_slavery Property fctSlavery  Auto
_SDQS_fcts_outfit Property fctOutfit  Auto

Keyword Property _SDKP_food  Auto  
Keyword Property _SDKP_food_raw  Auto  

MiscObject Property Gold  Auto  
MiscObject Property Firewood  Auto  

Quest Property _SDQP_enslavement Auto

GlobalVariable Property _SDGVP_buyout  Auto  
GlobalVariable Property _SDGVP_buyoutEarned  Auto  

Float fGoldEarned
Int iuType

Function limitedRemoveAllItems ( ObjectReference akContainer, ObjectReference akTransferTo = None, Bool abSilent = True, FormList akIgnored = None )
	Int iFormIndex = 0
	Bool bDeviousDeviceEquipped = False
	Actor kPlayer = Game.GetPlayer()
	Actor kActor = akContainer as Actor

	; First - limited removal of equipped items according to SexLab Consensual settings

	form[] slaveEquipment = SexLab.StripActor(kActor)

	iFormIndex = slaveEquipment.Length

	While ( iFormIndex > 0 )
		iFormIndex -= 1
		Form kForm = slaveEquipment[iFormIndex]

		bDeviousDeviceEquipped = ( kActor.isEquipped(kForm) && (!SexLab.IsStrippable(kForm) || kForm.hasKeywordString("zad_Lockable") || kForm.hasKeywordString("zad_deviousplug") || kForm.hasKeywordString("zad_DeviousArmbinder")) )

		If ( kForm && akIgnored && akIgnored.HasForm( kForm ) )
			; continue
		ElseIf ( kForm &&  uiTypes.Find( kForm.GetType() ) > -1 && !kForm.HasKeywordString("VendorNoSale") && !kForm.HasKeywordString("MagicDisallowEnchanting")  && !kForm.HasKeywordString("SOS_Underwear")  && !kForm.HasKeywordString("SOS_Genitals") && !kForm.HasKeywordString("_SLMC_MCDevice") && ( !bDeviousDeviceEquipped || !( kActor.isEquipped(kForm) && kForm.hasKeywordString("zad_DeviousGag")) ) ) 
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

		bDeviousDeviceEquipped = ( kActor.isEquipped(kForm) && (!SexLab.IsStrippable(kForm) || kForm.hasKeywordString("zad_Lockable") || kForm.hasKeywordString("zad_deviousplug") || kForm.hasKeywordString("zad_DeviousArmbinder")) )

		If ( kForm && akIgnored && akIgnored.HasForm( kForm ) ) || (uiTypes.Find( kForm.GetType() ) == 26)
			; continue
		ElseIf ( kForm &&  uiTypes.Find( kForm.GetType() ) > -1 && !kForm.HasKeywordString("VendorNoSale") && !kForm.HasKeywordString("MagicDisallowEnchanting")  && !kForm.HasKeywordString("_SLMC_MCDevice")  && !kForm.HasKeywordString("SOS_Underwear")  && !kForm.HasKeywordString("SOS_Genitals") && ( !bDeviousDeviceEquipped || !( kActor.isEquipped(kForm) && kForm.hasKeywordString("zad_DeviousGag")) ) ) 
			akContainer.RemoveItem(kForm, akContainer.GetItemCount( kForm ), abSilent, akTransferTo)
		EndIf
	EndWhile
EndFunction

Function safeRemoveAllItems ( ObjectReference akContainer, ObjectReference akTransferTo = None)
	Int iFormIndex = 0
	Bool bIgnoreItem = False
	Actor kPlayer = Game.GetPlayer()
	Actor kActor = akContainer as Actor

	; form[] slaveEquipment = SexLab.StripActor(kActor)
	; iFormIndex = slaveEquipment.Length

	iFormIndex = akContainer.GetNumItems()

	While ( iFormIndex > 0 )
		iFormIndex -= 1
		; Form kForm = slaveEquipment[iFormIndex]
		Form kForm = akContainer.GetNthForm(iFormIndex)

		If ( kForm )
			bIgnoreItem = ( kActor.isEquipped(kForm) && (!SexLab.IsStrippable(kForm)) && !kForm.hasKeywordString("zad_BlockGeneric") && !kForm.hasKeywordString("VendorNoSale") && !kForm.hasKeywordString("SexLabNoStrip") && !kForm.HasKeywordString("MagicDisallowEnchanting")  && !kForm.HasKeywordString("SOS_Underwear")  && !kForm.HasKeywordString("SOS_Genitals") && !kForm.HasKeywordString("_SLMC_MCDevice") ) 

			If ( !bIgnoreItem  ) 
				akContainer.RemoveItem(kForm, akContainer.GetItemCount( kForm ), True, akTransferTo)
				; akTransferTo.AddItem(kForm, akContainer.GetItemCount( kForm ))
			EndIf
		Endif
	EndWhile

EndFunction

Function limitedRemoveAllKeys ( ObjectReference akContainer, ObjectReference akTransferTo = None, Bool abSilent = True, FormList akIgnored = None )
	Int iFormIndex = 0
	Bool bDeviousDeviceEquipped = False
	Actor kPlayer = Game.GetPlayer()
	Actor kActor = akContainer as Actor

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

	iFormIndex = akContainer.GetNumItems()

	While ( iFormIndex > 0 )
		iFormIndex -= 1
		Form kForm = akContainer.GetNthForm(iFormIndex)

		If ( kForm && akIgnored && akIgnored.HasForm( kForm ) ) || (uiTypes.Find( kForm.GetType() ) == 26)
			; continue
		ElseIf ( kForm &&  uiTypes.Find( kForm.GetType() ) > -1 ) 
			if (kForm.GetType()==45) ; keys only
				akContainer.RemoveItem(kForm, akContainer.GetItemCount( kForm ), abSilent, akTransferTo)
			endif
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

Function ProcessGoldEarned(Actor kMaster, Actor kSlave, Float fGoldAmount )

	If (fGoldAmount > 0)
		fctSlavery.UpdateSlaveStatus( kSlave, "_SD_iGoalGold", modValue = fGoldAmount as Int)
		StorageUtil.SetIntValue(kMaster, "_SD_iGoldCountTotal", StorageUtil.GetIntValue(kMaster, "_SD_iGoldCountTotal") + (fGoldAmount as Int))

		; This is covered by ModObjectiveGlobal
		; _SDGVP_buyoutEarned.SetValue(StorageUtil.GetIntValue(kMaster, "_SD_iGoldCountTotal"))

		_SDQP_enslavement.ModObjectiveGlobal( afModValue = fGoldAmount,  aModGlobal = _SDGVP_buyoutEarned, aiObjectiveID = 6, afTargetValue = _SDGVP_buyout.GetValue() as Float)
		
		if (fGoldAmount>100)
			fctSlavery.ModMasterTrust( kMaster, 2)
		else
			fctSlavery.ModMasterTrust( kMaster, 1)
		endif

		fctSlavery.ModSlaveryTask(kSlave, "Bring gold", fGoldAmount as Int) 


		If ( StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryLevel") >= 2 )
			Debug.Notification("Good slave... keep it coming.")


		Else
			Debug.Notification("That's right.")

		Endif

	ElseIf (fGoldAmount == 0)
		Debug.Notification("What is this junk!?.")

	EndIf
EndFunction

Function ProcessGoldAdded(Actor kMaster, Actor kSlave)
	If (kMaster == None)
		Return
	Endif


	fGoldEarned = 0.0

	Debug.Trace( "[SD] Master receives gold from player" )

	If (StorageUtil.GetIntValue(kMaster, "_SD_iMasterIsCreature") == 0)
		Debug.Notification( "Good slave." )

		Float fGoldCoins = kSlave.GetItemCount(Gold) as Float
		kSlave.RemoveItem(Gold, fGoldCoins as Int)

		ProcessGoldEarned( kMaster,  kSlave, fGoldCoins )

	else
		Debug.Notification( "Your owner is disinterested." )
	endif

EndFunction

Function ProcessItemAdded(Actor kMaster, Actor kSlave, Form akBaseItem)
	Bool bIsMasterCreature = StorageUtil.GetIntValue(kMaster, "_SD_iMasterIsCreature") as Bool
	iuType = akBaseItem.GetType()
	fGoldEarned = 0.0

 	If ( StorageUtil.GetIntValue(kMaster, "_SD_iDisposition") > 0 )
 		fGoldEarned = akBaseItem.GetGoldValue()
	Else
		fGoldEarned = Math.Floor( akBaseItem.GetGoldValue() / 4 )
	EndIf

	Debug.Trace( "[SD] Master receives an item from player" )

	If (!bIsMasterCreature)
		Debug.Notification( "Good slave." )
	else
		Debug.Notification( "Your owner seems pleased." )
	endif

	If ( akBaseItem.HasKeyword( _SDKP_food ) || akBaseItem.HasKeyword( _SDKP_food_raw ) || (iuType == 46) ) ; food or potion
		; Master receives Food
		fctSlavery.UpdateSlaveStatus( kSlave, "_SD_iGoalFood", modValue = 1)
		fctSlavery.ModMasterTrust( kMaster, 1)
		fctSlavery.ModSlaveryTask( kSlave, "Bring food", 1)

		If ( StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryLevel") >= 2 ) && (!bIsMasterCreature)
			Debug.Notification("Mmm.. that should hit the spot.")
		ElseIf (!bIsMasterCreature)
				Debug.Notification("Well? What are you waiting for?.")
				Debug.Notification("Get back to work slave!")
		Else
				Debug.Notification("Your master groans happily.")
		EndIf

		ProcessGoldEarned( kMaster,  kSlave, fGoldEarned )

		If (Utility.RandomInt(0,100)<20)
			kMaster.EquipItem(akBaseItem, True, True)
		Endif

	; ElseIf ( iuType == 26 || iuType == 41 || iuType == 42 )
		; Weapon
	ElseIf ( iuType == 30 || iuType == 46 || iuType == 32 || iuType == 52 )
		; Creatures can accept natural ingredients

		If (akBaseItem == (Firewood as Form))
			fctSlavery.ModSlaveryTask( kSlave, "Bring firewood", 1)
		Else
			fctSlavery.ModSlaveryTask( kSlave, "Bring ingredient", 1)
		Endif

		if (fGoldEarned>100)
			fctSlavery.ModMasterTrust( kMaster, 2)
		else
			fctSlavery.ModMasterTrust( kMaster, 1)
		endif

		ProcessGoldEarned( kMaster,  kSlave, fGoldEarned )

		; TO DO - Master reaction if slave reaches buyout amount
		If (!akBaseItem.hasKeywordString("zad_Lockable"))
			If (Utility.RandomInt(0,100)<80) && (fGoldEarned>100)
				kMaster.EquipItem(akBaseItem, True, True)
			ElseIf (Utility.RandomInt(0,100)<40)
				kMaster.EquipItem(akBaseItem, True, True)
			Endif
		Endif
			
		Debug.Notification("(seems pleased)")


	ElseIf ((!bIsMasterCreature) || (StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryPunishmentOn")==1) )
		; Add code to match received items against Master's needs
		; Update Master's mood and trust

		If ( iuType == 27 )
			fctSlavery.ModSlaveryTask(kSlave, "Bring book", 1)
		ElseIf ( iuType == 26 )
			fctSlavery.ModSlaveryTask(kSlave, "Bring armor", 1)
		Elseif (iuType == 41 || iuType == 42 )
			fctSlavery.ModSlaveryTask(kSlave, "Bring weapon", 1)
		Endif


		ProcessGoldEarned( kMaster,  kSlave, fGoldEarned )

		; TO DO - Master reaction if slave reaches buyout amount
		If (Utility.RandomInt(0,100)<80) && (fGoldEarned>100)
			kMaster.EquipItem(akBaseItem, True, True)
		ElseIf (Utility.RandomInt(0,100)<40)
			kMaster.EquipItem(akBaseItem, True, True)
		Endif

	else
				
		Debug.Notification("(shrugs)")

	EndIf

EndFunction
