;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname _sdtif_release_naked Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_1
Function Fragment_1(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
pFDS.Persuade(akSpeaker)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
; if (StorageUtil.GetIntValue(Game.GetPlayer(), "DCUR_SceneRunning")==1)
;    _SD_deviceRemovalON.setvalue(0)
; else
;    _SD_deviceRemovalON.setvalue(1)
; endif
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

GlobalVariable Property _SD_deviceRemovalON  Auto  
favordialoguescript Property pFDS  Auto  
