Scriptname _sdqs_fcts_inventory extends Quest  
{ USED }
Import Utility
Import SKSE
SexLabFrameWork Property SexLab Auto
_SDQS_fcts_slavery Property fctSlavery  Auto

Keyword Property _SDKP_food  Auto  
Keyword Property _SDKP_food_raw  Auto  

MiscObject Property Gold  Auto  

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

Function ProcessItemAdded(Actor kMaster, Actor kSlave, Form akBaseItem)
	iuType = akBaseItem.GetType()
	fGoldEarned = 0.0

	Debug.Trace( "[SD] Master receives an item from player" )

	If (StorageUtil.GetIntValue(kMaster, "_SD_iMasterIsCreature") == 0)
		Debug.Notification( "Good slave." )
	else
		Debug.Notification( "Your owner seems pleased." )
	endif

	If ( akBaseItem.HasKeyword( _SDKP_food ) || akBaseItem.HasKeyword( _SDKP_food_raw ) || (iuType == 46) ) ; food or potion
		; Master receives Food
		fctSlavery.UpdateSlaveStatus( kSlave, "_SD_iGoalFood", modValue = 1)
		fctSlavery.ModMasterTrust( kMaster, 1)
		fctSlavery.ModTaskAmount(kSlave, "Food", 1) 

		If ( StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryLevel") >= 2 )
			If (StorageUtil.GetIntValue(kMaster, "_SD_iMasterIsCreature") == 0)
				Debug.Notification("Mmm.. that should hit the spot.")
			endif
		Else
			If (StorageUtil.GetIntValue(kMaster, "_SD_iMasterIsCreature") == 0)
				Debug.Notification("Well? What are you waiting for?.")
				Debug.Notification("Get back to work slave!")
			endif
		EndIf

		If (Utility.RandomInt(0,100)<20)
			kMaster.EquipItem(akBaseItem, True, True)
		Endif

	; ElseIf ( iuType == 26 || iuType == 41 || iuType == 42 )
		; Weapon
	
	ElseIf ((StorageUtil.GetIntValue(kMaster, "_SD_iMasterIsCreature") == 0) || (StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryPunishmentOn")==1) )
		; Add code to match received items against Master's needs
		; Update Master's mood and trust

	 	If ( StorageUtil.GetIntValue(kMaster, "_SD_iDisposition") > 0 )
	 		fGoldEarned = akBaseItem.GetGoldValue()
		Else
			fGoldEarned = Math.Floor( akBaseItem.GetGoldValue() / 4 )
		EndIf

		Float fGoldCoins = kSlave.GetItemCount(Gold) as Float
		kSlave.RemoveItem(Gold, fGoldCoins as Int)

		fGoldEarned = fGoldEarned + fGoldCoins

		If (fGoldEarned > 0)
			fctSlavery.UpdateSlaveStatus( kSlave, "_SD_iGoalGold", modValue = fGoldEarned as Int)
			StorageUtil.SetIntValue(kMaster, "_SD_iGoldCountTotal", StorageUtil.GetIntValue(kMaster, "_SD_iGoldCountTotal") + (fGoldEarned as Int))
			; _SDGVP_buyoutEarned.SetValue(fGoldEarned)


			_SDQP_enslavement.ModObjectiveGlobal( afModValue = fGoldEarned as Int,  aModGlobal = _SDGVP_buyoutEarned, aiObjectiveID = 6, afTargetValue = _SDGVP_buyout.GetValue() as Float)
			
			if (fGoldEarned>100)
				fctSlavery.ModMasterTrust( kMaster, 2)
			else
				fctSlavery.ModMasterTrust( kMaster, 1)
			endif

			fctSlavery.ModTaskAmount(kSlave, "Valuables", fGoldEarned as Int) 


			If ( StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryLevel") >= 2 )
				Debug.Notification("Good slave... keep it coming.")


			Else
				Debug.Notification("That's right.")
				Debug.Notification("You don't have a use for gold anymore.")
	
			Endif

		ElseIf (fGoldEarned == 0)
			Debug.Notification("What is this junk!?.")

		EndIf

		; TO DO - Master reaction if slave reaches buyout amount
		If (Utility.RandomInt(0,100)<80) && (fGoldEarned>100)
			kMaster.EquipItem(akBaseItem, True, True)
		ElseIf (Utility.RandomInt(0,100)<40)
			kMaster.EquipItem(akBaseItem, True, True)
		Endif

	ElseIf (StorageUtil.GetIntValue(kMaster, "_SD_iMasterIsCreature") == 1)
		; Creatures can accept natural ingredients
		If ( iuType == 30 || iuType == 46 || iuType == 32 || iuType == 52 )
			fGoldEarned = akBaseItem.GetGoldValue()

			if (fGoldEarned>100)
				fctSlavery.ModMasterTrust( kMaster, 2)
			else
				fctSlavery.ModMasterTrust( kMaster, 1)
			endif

			; TO DO - Master reaction if slave reaches buyout amount
			If (Utility.RandomInt(0,100)<80) && (fGoldEarned>100)
				kMaster.EquipItem(akBaseItem, True, True)
			ElseIf (Utility.RandomInt(0,100)<40)
				kMaster.EquipItem(akBaseItem, True, True)
			Endif
				
			Debug.Notification("(seems pleased)")
		else
				
			Debug.Notification("(shrugs)")
		endif
	EndIf

EndFunction