;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _SDTIF_vampireslave_01 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
_SDKP_sex.SendStoryEvent( akRef1 = _SDRAP_master.GetReference() as ObjectReference, akRef2 = _SDRAP_slave.GetReference() as ObjectReference, aiValue1 = 0, aiValue2 = Utility.RandomInt( 0, _SDGVP_positions.GetValue() as Int )  )

_SDQP_enslavement_tasks.Stop()
Self.GetOwningQuest().SetStage( 90 )
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Quest Property _SDQP_enslavement_tasks  Auto  
Keyword Property _SDKP_sex  Auto  
ReferenceAlias Property _SDRAP_master  Auto  
ReferenceAlias Property _SDRAP_slave  Auto  

GlobalVariable Property _SDGVP_positions  Auto  
