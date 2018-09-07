Scriptname _sdmes_clearSanguineBoundFX extends activemagiceffect  

_SDQS_fcts_outfit Property fctOutfit  Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Int iTargetValue
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

	if (StorageUtil.GetIntValue( akTarget , "_SD_iCoveted")==1)

		if (fctOutfit.isDeviceEquippedKeyword (  akTarget, "_SD_DeviousSanguine", "Collar"  )) && (Utility.RandomInt(0,100) > 50)
			Debug.Trace("[SD] Removing Sanguine Collar") 
			fctOutfit.clearNonGenericDeviceByString ( "Collar", "Sanguine" )
			Utility.Wait(1.0)
		Elseif (fctOutfit.isDeviceEquippedKeyword (  akTarget, "_SD_DeviousSanguine", "Collar"  ))
			Debug.Trace("The spectral collar remain locked around your neck.")
		EndIf

		if (fctOutfit.isDeviceEquippedKeyword (  akTarget, "_SD_DeviousSanguine", "WristRestraints"  )) && (Utility.RandomInt(0,100) > 50)
			Debug.Trace("[SD] Removing Sanguine Cuffs") 
			fctOutfit.clearNonGenericDeviceByString ( "WristRestraints", "Sanguine" )
			Utility.Wait(1.0)
		Elseif (fctOutfit.isDeviceEquippedKeyword (  akTarget, "_SD_DeviousSanguine", "WristRestraints"  ))
			Debug.Trace("The spectral cuffs remain locked around your wrists.")
		EndIf

		if (fctOutfit.isDeviceEquippedKeyword (  akTarget, "_SD_DeviousSanguine", "LegCuffs"  )) && (Utility.RandomInt(0,100) > 20)  
			Debug.Trace("[SD] Removing Sanguine Shackles")
			fctOutfit.clearNonGenericDeviceByString ( "LegCuffs", "Sanguine" )
			Utility.Wait(1.0)
		Elseif (fctOutfit.isDeviceEquippedKeyword (  akTarget, "_SD_DeviousSanguine", "LegCuffs"  ))
			Debug.Trace("The spectral shackles remain locked around your ankles.")
		EndIf

		if (fctOutfit.isDeviceEquippedKeyword (  akTarget, "_SD_DeviousSanguine", "Gag"  )) && (Utility.RandomInt(0,100) > 30) 
			Debug.Trace("[SD] Removing Sanguine Gag")
			fctOutfit.clearNonGenericDeviceByString ( "Gag", "Sanguine" )
			Utility.Wait(1.0)
			; kDreamer.RemoveItem( _SDA_gag, 1, False  )
		Elseif (fctOutfit.isDeviceEquippedKeyword (  akTarget, "_SD_DeviousSanguine", "Gag"  ))
			Debug.Trace("Your mouth remains filled with the spectral gag.")
		EndIf

		if (fctOutfit.isDeviceEquippedKeyword (  akTarget, "_SD_DeviousSanguine", "VaginalPiercing"  )) && (Utility.RandomInt(0,100) > 80)
			Debug.Trace("[SD] Removing Sanguine Artifact")
			fctOutfit.clearNonGenericDeviceByString ( "VaginalPiercing", "Sanguine" )
			Utility.Wait(1.0)
		Elseif (fctOutfit.isDeviceEquippedKeyword (  akTarget, "_SD_DeviousSanguine", "VaginalPiercing"  ))
			Debug.Trace("Your clit is still adorned with a spectral gem.")
		EndIf
	Else
		if (fctOutfit.isDeviceEquippedKeyword (  akTarget, "_SD_DeviousSanguine", "WristRestraints"  ))  
			Debug.Trace("[SD] Removing Sanguine Cuffs") 
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

		if (fctOutfit.isDeviceEquippedKeyword (  akTarget, "_SD_DeviousSanguine", "VaginalPiercing"  ))  
			Debug.Trace("[SD] Removing Sanguine Artifact")
			fctOutfit.clearNonGenericDeviceByString ( "VaginalPiercing", "Sanguine" )
			Utility.Wait(1.0) 
		EndIf

	EndIf

EndEvent

