;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _sdtif_join_01s Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
; SLS_PlayerAliciaQuest.SetStage(20)

fctOutfit.clearNonGenericDeviceByString ( "LegCuffs", "Sanguine" )
fctOutfit.clearNonGenericDeviceByString ( "Gag", "Sanguine" )
fctOutfit.clearNonGenericDeviceByString ( "WristRestraints", "Sanguine" )
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Quest Property SLS_PlayerAliciaQuest  Auto  

_sdqs_fcts_outfit Property fctOutfit  Auto  
