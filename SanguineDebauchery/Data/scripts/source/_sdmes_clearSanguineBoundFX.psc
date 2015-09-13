Scriptname _sdmes_clearSanguineBoundFX extends activemagiceffect  

_SDQS_fcts_outfit Property fctOutfit  Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)

	; Debug.MessageBox("[SD] Removing Sanguine Items")
	Debug.Trace("[SD] Removing Sanguine Items")

	; 0 - Collar
	; 1 - Arms
	; 2 - Legs
	; 3 - Gag
	; 4 - Plug Anal
	; 5 - Plug Vaginal
	; 6 - Blindfold
	; 7 - Belt
	; 8 - Harness
	
	if (fctOutfit.isDeviousOutfitPartByKeyword (  akTarget, 0, "_SD_DeviousSanguine"  )) ; && (Utility.RandomInt(0, 100) < 110)
		Debug.Trace("[SD] Removing Sanguine Collar")
		fctOutfit.setDeviousOutfitCollar ( iDevOutfit = 10, bDevEquip = False, sDevMessage = "")
		Utility.Wait(1.0)
	EndIf

	if (fctOutfit.isDeviousOutfitPartByKeyword (  akTarget, 1, "_SD_DeviousSanguine"  )) ; && (Utility.RandomInt(0, 100) < 110)
		Debug.Trace("[SD] Removing Sanguine Cuffs")
		fctOutfit.setDeviousOutfitArms ( iDevOutfit = 10, bDevEquip = False, sDevMessage = "")
		Utility.Wait(1.0)
	EndIf

	if (fctOutfit.isDeviousOutfitPartByKeyword (  akTarget, 2, "_SD_DeviousSanguine"  )) 
		Debug.Trace("[SD] Removing Sanguine Shackles")
		fctOutfit.setDeviousOutfitLegs ( iDevOutfit = 10, bDevEquip = False, sDevMessage = "")
		Utility.Wait(1.0)
	EndIf

	if (fctOutfit.isDeviousOutfitPartByKeyword (  akTarget, 3, "_SD_DeviousSanguine"  )) ; if (Utility.RandomInt(0, 100) < 110)
		Debug.Trace("[SD] Removing Sanguine Gag")
		fctOutfit.setDeviousOutfitGag ( iDevOutfit = 10, bDevEquip = False, sDevMessage = "")
		Utility.Wait(1.0)
		; kDreamer.RemoveItem( _SDA_gag, 1, False  )
	EndIf

	if (fctOutfit.isDeviousOutfitPartByKeyword (  akTarget, 5, "_SD_DeviousSanguine"  ))  ;if (Utility.RandomInt(0, 100) < 110)
		Debug.Trace("[SD] Removing Sanguine Artifact")
		fctOutfit.setDeviousOutfitPlugVaginal ( iDevOutfit = 10, bDevEquip = False, sDevMessage = "")
		Utility.Wait(1.0)
	;	fctOutfit.setDeviousOutfitBelt ( iDevOutfit = 10, bDevEquip = False, sDevMessage = "")
	EndIf
EndEvent