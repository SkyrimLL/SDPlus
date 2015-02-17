;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SLD_TIF_BlacksmithTask01d Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Self.GetOwningQuest().SetStage(120)

Game.getPlayer().AddItem(Hammer, 1)
Game.getPlayer().AddItem(Tong, 1)

Game.getPlayer().RemoveItem(IronOre, 1)
Game.getPlayer().RemoveItem(Firewood, 1)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

 

MiscObject Property Firewood  Auto  

MiscObject Property IronOre  Auto  

MiscObject Property Hammer  Auto  

MiscObject Property Tong  Auto  
