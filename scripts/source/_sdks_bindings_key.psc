Scriptname _SDKS_bindings_key extends ObjectReference  

_SDQS_functions Property funct  Auto
_SDQS_fcts_outfit Property fctOutfit  Auto

FormList Property _SDFLP_sex_items  Auto
FormList Property _SDFLP_punish_items  Auto
Spell Property _SDSP_freedom  Auto  

Keyword Property _SDKP_collar  Auto 
Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
	If ( akOldContainer == Game.GetPlayer() )
		Self.DeleteWhenAble()
	EndIf
	
	If (  akNewContainer == Game.GetPlayer() )
		Actor kContainer = akNewContainer as Actor
;		funct.removeItemsInList( kContainer, _SDFLP_sex_items )
;		funct.removeItemsInList( kContainer, _SDFLP_punish_items )

		Debug.Trace("[_sdks_bindings_key] Master key - Stop enslavement")

		If (StorageUtil.GetIntValue(kContainer, "_SD_iEnslaved") == 1)
			SendModEvent("PCSubFree")			
		EndIf

		If !fctOutfit.isEquippedCuffsKeyword( kContainer,  "_SD_DeviousSpriggan"  ) && !fctOutfit.isEquippedCuffsKeyword( kContainer,  "_SD_DeviousSanguine"  )
			fctOutfit.setDeviousOutfitArms ( bDevEquip = False, sDevMessage = "")
		EndIf

		If !fctOutfit.isEquippedShacklesKeyword( kContainer,  "_SD_DeviousSpriggan"  ) && !fctOutfit.isEquippedShacklesKeyword( kContainer,  "_SD_DeviousSanguine"  )
			fctOutfit.setDeviousOutfitLegs ( bDevEquip = False, sDevMessage = "")
		EndIf

		If !fctOutfit.isEquippedBlindfoldKeyword( kContainer,  "_SD_DeviousSpriggan"  ) && !fctOutfit.isEquippedBlindfoldKeyword( kContainer,  "_SD_DeviousSanguine"  )
			fctOutfit.setDeviousOutfitBlindfold ( bDevEquip = False, sDevMessage = "")
		EndIf

		If !fctOutfit.isEquippedCuffsKeyword( kContainer,  "_SD_DeviousSpriggan"  ) && !fctOutfit.isEquippedCuffsKeyword( kContainer,  "_SD_DeviousSanguine"  )
			fctOutfit.setDeviousOutfitGag ( bDevEquip = False, sDevMessage = "")
		EndIf

		if (Utility.RandomInt(0,100) < 77)
			If !fctOutfit.isEquippedCollarKeyword( kContainer,  "_SD_DeviousSanguine"  )
				fctOutfit.setDeviousOutfitCollar ( bDevEquip = False, sDevMessage = "")
				Debug.Messagebox("Your Master's Key helps you break free of your chains.")
			EndIf
		Else
			Debug.MessageBox("Your Master's Key helps you break free of your chains but the key snapped as you tried to force your collar open.")
		EndIf

		_SDSP_freedom.RemoteCast( akNewContainer, kContainer, kContainer )
		Game.GetPlayer().RemoveItem(Self, Game.GetPlayer().GetItemCount( Self ))
	EndIf	
EndEvent
