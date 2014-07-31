Scriptname _sdmes_clearSanguineBoundFX extends activemagiceffect  

_SDQS_fcts_outfit Property fctOutfit  Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)

	Debug.MessageBox("[SD] Removing Sanguine Items")
	Debug.Trace("[SD] Removing Sanguine Items")

	if (fctOutfit.isCollarEquipped(akTarget)) ; && (Utility.RandomInt(0, 100) < 110)
		Debug.Trace("[SD] Removing Sanguine Collar")
		fctOutfit.setDeviousOutfitCollar ( iDevOutfit = 10, bDevEquip = False, sDevMessage = "")
	EndIf

	if (fctOutfit.isCuffsEquipped(akTarget)) ; && (Utility.RandomInt(0, 100) < 110)
		Debug.Trace("[SD] Removing Sanguine Cuffs")
		fctOutfit.setDeviousOutfitArms ( iDevOutfit = 10, bDevEquip = False, sDevMessage = "")
	EndIf

	if (fctOutfit.isShacklesEquipped(akTarget)) 
		Debug.Trace("[SD] Removing Sanguine Shackles")
		fctOutfit.setDeviousOutfitLegs ( iDevOutfit = 10, bDevEquip = False, sDevMessage = "")
	EndIf

	; if (Utility.RandomInt(0, 100) < 110)
		Debug.Trace("[SD] Removing Sanguine Gag")
		fctOutfit.setDeviousOutfitGag ( iDevOutfit = 10, bDevEquip = False, sDevMessage = "")
		; kDreamer.RemoveItem( _SDA_gag, 1, False  )
	;EndIf

	;if (Utility.RandomInt(0, 100) < 110)
		Debug.Trace("[SD] Removing Sanguine Artifact")
		fctOutfit.setDeviousOutfitPlugVaginal ( iDevOutfit = 10, bDevEquip = False, sDevMessage = "")
	;	fctOutfit.setDeviousOutfitBelt ( iDevOutfit = 10, bDevEquip = False, sDevMessage = "")
	;EndIf
EndEvent