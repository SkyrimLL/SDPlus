;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SLD_TIF_JobMage329 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Actor kPlayer = Game.GetPlayer()

kPlayer.AddItem(SpellTome, 1)
kPlayer.AddItem(SpellTome2, 1)

kPlayer.RemoveItem(Lavender, 20)
kPlayer.RemoveItem(MoonSugar, 1)

Self.GetOwningQuest().SetStage(329)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Book Property SpellTome  Auto  

Book Property SpellTome2  Auto  

Ingredient Property MoonSugar  Auto  

Ingredient Property Lavender  Auto  
