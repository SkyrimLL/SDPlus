;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SLD_TIF_BlacksmithTask01aa Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
ObjectReference kPlayerRef = Game.GetPlayer() as ObjectReference
Actor kPlayer = Game.GetPlayer() as Actor

Self.GetOwningQuest().SetStage(100)

kPlayerRef.AddItem(AlvorKey, 1)
kPlayer.AddToFaction( AlvorFaction)
HomeLockList.AddForm(kPlayer as Form)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Key Property AlvorKey  Auto  

Faction Property AlvorFaction  Auto  
FormList Property HomeLockList Auto
