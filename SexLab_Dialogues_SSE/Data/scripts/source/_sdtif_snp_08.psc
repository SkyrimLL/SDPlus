;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname _SDTIF_snp_08 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_1
Function Fragment_1(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
; objective 10 must be completed in 12  hours
_SDKP_task.SendStoryEvent(akRef1 = akSpeakerRef, akRef2 = akSpeaker.GetDialogueTarget() as ObjectReference, aiValue1 = 10, aiValue2 = 12)
Self.GetOwningQuest().SetStage(20)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment


Keyword Property _SDKP_task  Auto  
ReferenceAlias Property _SDRAP_master  Auto  
ReferenceAlias Property _SDRAP_slave  Auto  
