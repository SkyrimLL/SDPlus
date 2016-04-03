;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname SLD_TIF_TempHirelingOff Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
; pFDS.Persuade(akSpeaker)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
tempHirelingREF.ForceRefTo( _SLD_NoRefGhost )
StorageUtil.SetFormValue( Game.GetPlayer(), "_SLD_fTempHireling", None)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

favordialoguescript Property pFDS  Auto  

ReferenceAlias Property tempHirelingREF  Auto  

ObjectReference Property _SLD_NoRefGhost  Auto  
