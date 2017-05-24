;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _sdtif_dream_scene2 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
; _SDKP_sex.SendStoryEvent(akRef1 = akSpeaker, akRef2 = Game.GetPlayer(), aiValue1 = 3, aiValue2 = Utility.RandomInt( 0, _SDGVP_punishments.GetValueInt() ) )
akSpeaker.SendModEvent("PCSubPunish")
 Self.GetOwningQuest().setstage(210)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

GlobalVariable Property _SDGVP_punishments  Auto  

Keyword Property _SDKP_sex  Auto  
