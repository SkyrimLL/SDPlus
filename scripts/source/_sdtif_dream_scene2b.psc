;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _sdtif_dream_scene2b Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Game.ForceThirdPerson()
Debug.SendAnimationEvent(Game.GetPlayer() as ObjectReference, "bleedOutStart")

Int IButton = _SD_rapeMenu.Show()

If IButton == 0 ; Show the thing.

	funct.SanguineRape( akSpeaker, Game.GetPlayer() , "Sex")

EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment


Message Property  _SD_rapeMenu Auto

_SDQS_functions Property funct  Auto


