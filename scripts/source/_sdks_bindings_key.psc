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


		If fctOutfit.isArmsEquipped( kContainer ) && !fctOutfit.isArmsEquippedKeyword( kContainer,  "_SD_DeviousSpriggan"  ) && !fctOutfit.isArmsEquippedKeyword( kContainer,  "_SD_DeviousSanguine"  )
			fctOutfit.setDeviousOutfitArms ( bDevEquip = False, sDevMessage = "")
		EndIf

		If fctOutfit.isLegsEquipped( kContainer ) && !fctOutfit.isLegsEquippedKeyword( kContainer,  "_SD_DeviousSpriggan"  ) && !fctOutfit.isLegsEquippedKeyword( kContainer,  "_SD_DeviousSanguine"  )
			fctOutfit.setDeviousOutfitLegs ( bDevEquip = False, sDevMessage = "")
		EndIf

		If fctOutfit.isBlindfoldEquipped( kContainer ) && !fctOutfit.isBlindfoldEquippedKeyword( kContainer,  "_SD_DeviousSpriggan"  ) && !fctOutfit.isBlindfoldEquippedKeyword( kContainer,  "_SD_DeviousSanguine"  )
			fctOutfit.setDeviousOutfitBlindfold ( bDevEquip = False, sDevMessage = "")
		EndIf

		If fctOutfit.isGagEquipped( kContainer ) && !fctOutfit.isGagEquippedKeyword( kContainer,  "_SD_DeviousSpriggan"  ) && !fctOutfit.isGagEquippedKeyword( kContainer,  "_SD_DeviousSanguine"  )
			fctOutfit.setDeviousOutfitGag ( bDevEquip = False, sDevMessage = "")
		EndIf

		If fctOutfit.isCollarEquippedKeyword( kContainer,  "_SD_DeviousEnslaved"  )
			if (Utility.RandomInt(0,100) < 77)
				fctOutfit.setDeviousOutfitCollar ( bDevEquip = False, sDevMessage = "")
				Debug.Messagebox("Your Master's Key helps you break free of your chains and immediately crumbles into dust.")
			Else
				Debug.MessageBox("Your Master's Key helps you break free of your chains but the key crumbles into dust before you can try to force your collar open.")
			EndIf

		Else
			Debug.MessageBox("The key works on bindings but without an enchanted enslavement collar bound to a master, it is useless on your collar and immediately crumbles into dust.")
		EndIf

		Int keyCount = Game.GetPlayer().GetItemCount( _SD_MasterKey as Form )
		Game.GetPlayer().RemoveItem(_SD_MasterKey, keyCount)

		If (StorageUtil.GetIntValue(kContainer, "_SD_iEnslaved") == 1)
			SendModEvent("PCSubFree")		

			_SDSP_freedom.RemoteCast( akNewContainer, kContainer, kContainer )
		EndIf





	EndIf	
EndEvent

Key Property _SD_MasterKey  Auto  
