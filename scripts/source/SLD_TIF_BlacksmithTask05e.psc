;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SLD_TIF_BlacksmithTask05e Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Actor kPlayer = Game.GetPlayer() as Actor
ObjectReference kPlayerRef = Game.GetPlayer()

Self.GetOwningQuest().SetStage(440)

kPlayerRef.RemoveItem( DragonBones, 15)
kPlayerRef.AddItem( DragonArmor, 1)
kPlayerRef.AddItem( DragonShield, 1)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment


MiscObject Property DragonBones  Auto  

Armor Property DragonArmor  Auto  
Armor Property DragonShield Auto  

