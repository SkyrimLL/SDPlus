Scriptname _sdmes_sanguineDeviceBound extends activemagiceffect  

_SDQS_functions Property funct  Auto
_SDQS_fcts_outfit Property fctOutfit  Auto

Float fRFSU = 0.1

Actor kPlayer 

Event OnEffectStart(Actor akTarget, Actor akCaster)
	; Test - Remove current collar first
	; if (fctOutfit.isCollarEquipped(akTarget))
	;	fctOutfit.setDeviousOutfitCollar ( bDevEquip = False, sDevMessage = "")
	; EndIf
	; if (fctOutfit.isBlindfoldEquipped(akTarget))
	; 	fctOutfit.setDeviousOutfitBlindfold ( bDevEquip = False, sDevMessage = "")
	; EndIf

	if (!fctOutfit.isCollarEquipped(akTarget))
		fctOutfit.setDeviousOutfitCollar ( iDevOutfit = 10, bDevEquip = True, sDevMessage = "")
	EndIf
	if (!fctOutfit.isBindingEquipped(akTarget))
		fctOutfit.setDeviousOutfitArms ( iDevOutfit = 10, bDevEquip = True, sDevMessage = "")
		fctOutfit.setDeviousOutfitLegs ( iDevOutfit = 10, bDevEquip = True, sDevMessage = "")
	EndIf
	
	; fctOutfit.setDeviousOutfitBelt ( iDevOutfit = 10, bDevEquip = True, sDevMessage = "")
	; fctOutfit.setDeviousOutfitPlugAnal ( iDevOutfit = 10, bDevEquip = True, sDevMessage = "")

	fctOutfit.setDeviousOutfitGag ( iDevOutfit = 10, bDevEquip = True, sDevMessage = "")
	fctOutfit.setDeviousOutfitPlugVaginal ( iDevOutfit = 10, bDevEquip = True, sDevMessage = "")
	; kDreamer.EquipItem(  _SDA_gag , False, True )

	; RegisterForSingleUpdate( fRFSU )
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)

	if (Utility.RandomInt(0, 100) < 90)
		fctOutfit.setDeviousOutfitCollar ( iDevOutfit = 10, bDevEquip = False, sDevMessage = "")
	EndIf

	if (Utility.RandomInt(0, 100) < 80)
		fctOutfit.setDeviousOutfitArms ( iDevOutfit = 10, bDevEquip = False, sDevMessage = "")
	EndIf

	fctOutfit.setDeviousOutfitLegs ( iDevOutfit = 10, bDevEquip = False, sDevMessage = "")

	if (Utility.RandomInt(0, 100) < 90)
		fctOutfit.setDeviousOutfitGag ( iDevOutfit = 10, bDevEquip = False, sDevMessage = "")
		; kDreamer.RemoveItem( _SDA_gag, 1, False  )
	EndIf

	if (Utility.RandomInt(0, 100) < 40)
		fctOutfit.setDeviousOutfitPlugVaginal ( iDevOutfit = 10, bDevEquip = True, sDevMessage = "")
	;	fctOutfit.setDeviousOutfitBelt ( iDevOutfit = 10, bDevEquip = False, sDevMessage = "")
	EndIf
EndEvent


