Scriptname _sdmes_sanguineDeviceBound extends activemagiceffect  

_SDQS_functions Property funct  Auto
_SDQS_fcts_outfit Property fctOutfit  Auto

Float fRFSU = 600.0

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

	if (!fctOutfit.isCollarEquipped(akTarget))
		fctOutfit.setDeviousOutfitCollar ( iDevOutfit = 10, bDevEquip = True, sDevMessage = "")
	Else
		Debug.Trace("[SD] Skipping collar - slot in use")
	EndIf

	if (!fctOutfit.isCuffsEquipped(akTarget))
		fctOutfit.setDeviousOutfitArms ( iDevOutfit = 10, bDevEquip = True, sDevMessage = "")
	Else
		Debug.Trace("[SD] Skipping cuffs - slot in use")
	EndIf

	if (!fctOutfit.isShacklesEquipped(akTarget))
		fctOutfit.setDeviousOutfitLegs ( iDevOutfit = 10, bDevEquip = True, sDevMessage = "")
	Else
		Debug.Trace("[SD] Skipping shackles - slot in use")
	EndIf
	
	; fctOutfit.setDeviousOutfitBelt ( iDevOutfit = 10, bDevEquip = True, sDevMessage = "")
	; fctOutfit.setDeviousOutfitPlugAnal ( iDevOutfit = 10, bDevEquip = True, sDevMessage = "")

	fctOutfit.setDeviousOutfitGag ( iDevOutfit = 10, bDevEquip = True, sDevMessage = "")
	fctOutfit.setDeviousOutfitPlugVaginal ( iDevOutfit = 10, bDevEquip = True, sDevMessage = "")
	; kDreamer.EquipItem(  _SDA_gag , False, True )

	RegisterForSingleUpdate( fRFSU ); * Utility.RandomInt(1,5) )
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
;

EndEvent

Event OnUpdate()
	_SDSP_freedom.RemoteCast( kPlayer, kPlayer, kPlayer )
EndEvent

Spell Property _SDSP_freedom  Auto  