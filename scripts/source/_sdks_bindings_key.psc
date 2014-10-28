Scriptname _SDKS_bindings_key extends ObjectReference  

_SDQS_functions Property funct  Auto
_SDQS_fcts_outfit Property fctOutfit  Auto

FormList Property _SDFLP_sex_items  Auto
FormList Property _SDFLP_punish_items  Auto
Spell Property _SDSP_freedom  Auto  

Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
	If ( akOldContainer == Game.GetPlayer() )
		Self.DeleteWhenAble()
	EndIf
	
	If (  akNewContainer == Game.GetPlayer() )
		Actor kContainer = akNewContainer as Actor
;		funct.removeItemsInList( kContainer, _SDFLP_sex_items )
;		funct.removeItemsInList( kContainer, _SDFLP_punish_items )

		Debug.Trace("[_sdks_master_key] Master key - Stop enslavement")

		fctOutfit.setDeviousOutfitArms ( bDevEquip = False, sDevMessage = "")
		fctOutfit.setDeviousOutfitLegs ( bDevEquip = False, sDevMessage = "")
;		fctOutfit.removePunishment( bDevGag = True,  bDevBlindfold = True,  bDevBelt = True,  bDevPlugAnal = True,  bDevPlugVaginal = True)
		fctOutfit.setDeviousOutfitBlindfold ( bDevEquip = False, sDevMessage = "")
		fctOutfit.setDeviousOutfitGag ( bDevEquip = False, sDevMessage = "")
	
		if (Utility.RandomInt(0,100) < 77)
			fctOutfit.setDeviousOutfitCollar ( bDevEquip = False, sDevMessage = "")
			Debug.Messagebox("Your Master's Key helps you break free of your chains.")
		Else
			Debug.MessageBox("Your Master's Key helps you break free of your chains but the key snapped as you tried to force your collar open.")
		EndIf

		SendModEvent("SDFree")
		_SDSP_freedom.RemoteCast( akNewContainer, kContainer, kContainer )
		Game.GetPlayer().RemoveItem(Self, Game.GetPlayer().GetItemCount( Self ))
	EndIf	
EndEvent
