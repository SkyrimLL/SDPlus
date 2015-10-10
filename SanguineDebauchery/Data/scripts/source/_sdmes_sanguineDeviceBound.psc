Scriptname _sdmes_sanguineDeviceBound extends activemagiceffect  

_SDQS_functions Property funct  Auto
_SDQS_fcts_outfit Property fctOutfit  Auto

Float fRFSU = 60.0
Float fTimer = 60.0

Actor kPlayer 

Event OnEffectStart(Actor akTarget, Actor akCaster)
	; Test - Remove current collar first
	; if (fctOutfit.isCollarEquipped(akTarget))
	;	fctOutfit.setDeviousOutfitCollar ( bDevEquip = False, sDevMessage = "")
	; EndIf
	; if (fctOutfit.isBlindfoldEquipped(akTarget))
	; 	fctOutfit.setDeviousOutfitBlindfold ( bDevEquip = False, sDevMessage = "")
	; EndIf

	kPlayer = akTarget

	; 0 - Collar
	; 1 - Arms
	; 2 - Legs
	; 3 - Gag
	; 4 - Plug Anal
	; 5 - Plug Vaginal
	; 6 - Blindfold
	; 7 - Belt
	; 8 - Harness
	
	if (!fctOutfit.isCollarEquipped (  akTarget ))
		fctOutfit.setDeviousOutfitCollar ( iDevOutfit = 10, bDevEquip = True, sDevMessage = "")
	Else
		Debug.Trace("[SD] Skipping sanguine collar - slot in use")
	EndIf

	if (!fctOutfit.isArmsEquipped (  akTarget ))  && !fctOutfit.isYokeEquipped( akTarget ) 
		fctOutfit.setDeviousOutfitArms ( iDevOutfit = 10, bDevEquip = True, sDevMessage = "")
	Else
		Debug.Trace("[SD] Skipping sanguine cuffs - slot in use")
	EndIf

	if (!fctOutfit.isLegsEquipped (  akTarget ))
		fctOutfit.setDeviousOutfitLegs ( iDevOutfit = 10, bDevEquip = True, sDevMessage = "")
	Else
		Debug.Trace("[SD] Skipping sanguine shackles - slot in use")
	EndIf
	
	; fctOutfit.setDeviousOutfitBelt ( iDevOutfit = 10, bDevEquip = True, sDevMessage = "")
	; fctOutfit.setDeviousOutfitPlugAnal ( iDevOutfit = 10, bDevEquip = True, sDevMessage = "")

	if (!fctOutfit.IsGagEquipped (  akTarget )) && (Utility.RandomInt(0,100) > 40)
		fctOutfit.setDeviousOutfitGag ( iDevOutfit = 10, bDevEquip = True, sDevMessage = "")
	Else
		Debug.Trace("[SD] Skipping sanguine gag - slot in use")
	EndIf
	
	; if (!fctOutfit.isDeviousOutfitPartByKeyword (  akTarget, 5 ))
	;	fctOutfit.setDeviousOutfitPlugVaginal ( iDevOutfit = 10, bDevEquip = True, sDevMessage = "")
	; Else
	;	Debug.Trace("[SD] Skipping sanguine artefact - slot in use")
	; EndIf
	; kDreamer.EquipItem(  _SDA_gag , False, True )

	fTimer = fRFSU * Utility.RandomInt(7 - StorageUtil.GetIntValue(kPlayer, "_SD_iSlaveryLevel") , 11  - StorageUtil.GetIntValue(kPlayer, "_SD_iSlaveryLevel"))
	Debug.Trace("[SD] Sanguine items timer: " + fTimer)
	RegisterForSingleUpdate( fTimer )
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	If (fctOutfit.countDeviousSlotsByKeyword (  akTarget, "_SD_DeviousSanguine" )>0)
		Debug.Trace("[SD] Sanguine items cleanup: OnEffectFinish" )
		_SDSP_freedom.RemoteCast( kPlayer, kPlayer, kPlayer )
	EndIf

EndEvent

Event OnUpdate()
	If (fctOutfit.countDeviousSlotsByKeyword (  kPlayer, "_SD_DeviousSanguine" )>0)
		Debug.Trace("[SD] Sanguine items timer: OnUpdate " )
		_SDSP_freedom.RemoteCast( kPlayer, kPlayer, kPlayer )
	EndIf

	fTimer = fRFSU * Utility.RandomInt(7 - StorageUtil.GetIntValue(kPlayer, "_SD_iSlaveryLevel") , 11  - StorageUtil.GetIntValue(kPlayer, "_SD_iSlaveryLevel"))
	Debug.Trace("[SD] Sanguine items timer: " + fTimer)
	RegisterForSingleUpdate( fTimer )
EndEvent

Spell Property _SDSP_freedom  Auto  