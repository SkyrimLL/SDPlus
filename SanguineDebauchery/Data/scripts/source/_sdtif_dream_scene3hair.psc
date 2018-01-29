;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _sdtif_dream_scene3hair Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Actor PlayerActor = Game.GetPlayer()

Int iAliciaHairColor = Math.LeftShift(60, 16) + Math.LeftShift(16, 8) + 13
StorageUtil.SetStringValue(PlayerActor, "_SLH_sHairColorName", "Dark Red" ) 
PlayerActor.SendModEvent("SLHRefreshHairColor","Dye")
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
