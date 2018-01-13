;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _sdtif_dreamworld_04 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Int randomNum = Utility.RandomInt(0, 100)
 
If (randomNum > 70)
	fctOutfit.clearNonGenericDeviceByString ( "WristRestraints", "Sanguine" )
	akSpeaker.SendModEvent("PCSubPunish") ; Punishment

ElseIf (randomNum > 30)
	fctOutfit.clearNonGenericDeviceByString ( "LegCuffs", "Sanguine" )
	akSpeaker.SendModEvent("PCSubWhip") ; Whipping

Else
	fctOutfit.clearNonGenericDeviceByString ( "Gag", "Sanguine" )
	akSpeaker.SendModEvent("PCSubSex") ; Sex
EndIf

;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

GlobalVariable Property _SDGV_SanguineBlessing  Auto  

Keyword Property _SDKP_sex  Auto  

GlobalVariable Property _SDGVP_punishments  Auto  

SexLabFramework Property SexLab  Auto  

_sdqs_functions Property funct  Auto  

Message Property _SD_rapeMenu  Auto  

_sdqs_fcts_outfit Property fctOutfit  Auto  
