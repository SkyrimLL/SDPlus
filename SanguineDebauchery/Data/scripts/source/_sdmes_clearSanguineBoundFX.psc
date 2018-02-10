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

	; Collars and armbinders do not expire - compatibility with dremora race enslavement
	; if (fctOutfit.isDeviceEquippedKeyword (  akTarget, "_SD_DeviousSanguine", "Collar"  )) && (Utility.RandomInt(0, 100) > 40)
	;	Debug.Trace("[SD] Removing Sanguine Collar")
	;	fctOutfit.clearDeviceByString ( sDeviceString = "Collar", sOutfitString = "", skipEvents = true, skipMutex = true )
	;	Utility.Wait(1.0)
	;EndIf

	if (fctOutfit.isDeviceEquippedKeyword (  akTarget, "_SD_DeviousSanguine", "WristRestraints"  )) && (Utility.RandomInt(0, 100) > 40)
		Debug.Trace("[SD] Removing Sanguine Cuffs")
	;	fctOutfit.clearDeviceByString ( sDeviceString = "Armbinders", sOutfitString = "", skipEvents = true, skipMutex = true )
		fctOutfit.clearNonGenericDeviceByString ( "WristRestraints", "Sanguine" )
		Utility.Wait(1.0)
	EndIf

	if (fctOutfit.isDeviceEquippedKeyword (  akTarget, "_SD_DeviousSanguine", "LegCuffs"  ))  
		Debug.Trace("[SD] Removing Sanguine Shackles")
		fctOutfit.clearNonGenericDeviceByString ( "LegCuffs", "Sanguine" )
		Utility.Wait(1.0)
	EndIf

	if (fctOutfit.isDeviceEquippedKeyword (  akTarget, "_SD_DeviousSanguine", "Gag"  )) 
		Debug.Trace("[SD] Removing Sanguine Gag")
		fctOutfit.clearNonGenericDeviceByString ( "Gag", "Sanguine" )
		Utility.Wait(1.0)
		; kDreamer.RemoveItem( _SDA_gag, 1, False  )
	EndIf

	if (fctOutfit.isDeviceEquippedKeyword (  akTarget, "_SD_DeviousSanguine", "VaginalPiercing"  ))  && (Utility.RandomInt(0, 100) > 95)
		Debug.MessageBox("The spell fizzles before removing your piercing.")
	elseif (fctOutfit.isDeviceEquippedKeyword (  akTarget, "_SD_DeviousSanguine", "VaginalPiercing"  ))  
		Debug.Trace("[SD] Removing Sanguine Artifact")
		fctOutfit.clearNonGenericDeviceByString ( "VaginalPiercing", "Sanguine" )
		Utility.Wait(1.0)
	EndIf
EndEvent