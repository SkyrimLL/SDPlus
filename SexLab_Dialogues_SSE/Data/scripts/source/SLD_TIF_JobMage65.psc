;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SLD_TIF_JobMage65 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Actor kPlayer = Game.getPlayer()

kPlayer.AddItem(FarengarBook, 1)
kPlayer.AddItem(Wheat, 10)
kPlayer.AddItem(Blisterwort, 10)

Self.GetOwningQuest().SetStage(65)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Book Property FarengarBook  Auto  

Ingredient Property Wheat  Auto  

Ingredient Property Blisterwort   Auto  
