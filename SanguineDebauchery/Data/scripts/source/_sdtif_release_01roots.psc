;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _sdtif_release_01roots Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Debug.Messagebox("The ointment washes away the residual roots clinging to your body.")

;            fctOutfit.setDeviousOutfitArms ( iDevOutfit = 7, bDevEquip = False, sDevMessage = "")
;           fctOutfit.setDeviousOutfitLegs ( iDevOutfit = 7, bDevEquip = False, sDevMessage = "")
;            fctOutfit.setDeviousOutfitBelt ( iDevOutfit = 7, bDevEquip = False, sDevMessage = "")
;            fctOutfit.setDeviousOutfitBlindfold ( iDevOutfit = 7,  bDevEquip = False, sDevMessage = "")

fctOutfit.clearDeviceByString ( sDeviceString = "Armbinder", sOutfitString = "Spriggan"  )
fctOutfit.clearDeviceByString ( sDeviceString = "LegCuffs", sOutfitString = "Spriggan"  )
fctOutfit.clearDeviceByString ( sDeviceString = "Belt", sOutfitString = "Spriggan"  )
fctOutfit.clearDeviceByString ( sDeviceString = "Blindfold", sOutfitString = "Spriggan"  )
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

_SDQS_fcts_outfit Property fctOutfit  Auto
