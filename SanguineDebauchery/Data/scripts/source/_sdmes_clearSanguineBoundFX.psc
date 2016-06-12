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

	if (fctOutfit.isDeviceEquippedKeyword (  akTarget, "_SD_DeviousSanguine", "Collar"  )) ; && (Utility.RandomInt(0, 100) < 110)
		Debug.Trace("[SD] Removing Sanguine Collar")
		fctOutfit.clearDeviceByString ( sDeviceString = "Collar", sOutfitString = "", skipEvents = true, skipMutex = true )
		Utility.Wait(1.0)
	EndIf

	if (fctOutfit.isDeviceEquippedKeyword (  akTarget, "_SD_DeviousSanguine", "Armbinder"  )) ; && (Utility.RandomInt(0, 100) < 110)
		Debug.Trace("[SD] Removing Sanguine Cuffs")
		fctOutfit.clearDeviceByString ( sDeviceString = "Armbinder", sOutfitString = "", skipEvents = true, skipMutex = true )
		Utility.Wait(1.0)
	EndIf

	if (fctOutfit.isDeviceEquippedKeyword (  akTarget, "_SD_DeviousSanguine", "LegCuffs"  )) 
		Debug.Trace("[SD] Removing Sanguine Shackles")
		fctOutfit.clearDeviceByString ( sDeviceString = "LegCuffs", sOutfitString = "", skipEvents = true, skipMutex = true )
		Utility.Wait(1.0)
	EndIf

	if (fctOutfit.isDeviceEquippedKeyword (  akTarget, "_SD_DeviousSanguine", "Gag"  )) ; if (Utility.RandomInt(0, 100) < 110)
		Debug.Trace("[SD] Removing Sanguine Gag")
		fctOutfit.clearDeviceByString ( sDeviceString = "Gag", sOutfitString = "", skipEvents = true, skipMutex = true )
		Utility.Wait(1.0)
		; kDreamer.RemoveItem( _SDA_gag, 1, False  )
	EndIf

	if (fctOutfit.isDeviceEquippedKeyword (  akTarget, "_SD_DeviousSanguine", "PiercingVaginal"  )) ;if (Utility.RandomInt(0, 100) < 110)
		Debug.Trace("[SD] Removing Sanguine Artifact")
		fctOutfit.clearDeviceByString ( sDeviceString = "PiercingVaginal", sOutfitString = "", skipEvents = true, skipMutex = true )
		Utility.Wait(1.0)
	EndIf
EndEvent