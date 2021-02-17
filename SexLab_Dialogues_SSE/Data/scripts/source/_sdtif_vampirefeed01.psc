;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _sdtif_vampirefeed01 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
fctSlavery.UpdateSlaveStatus( Game.GetPlayer(), "_SD_iGoalFood", modValue = 1)

_SDKP_sex.SendStoryEvent(akRef1 = akSpeaker, akRef2 = Game.GetPlayer(), aiValue1 = 6, aiValue2 = 0 )
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

_SDQS_fcts_slavery Property fctSlavery  Auto
Keyword Property _SDKP_sex  Auto  
