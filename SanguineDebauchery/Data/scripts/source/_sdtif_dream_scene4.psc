;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _sdtif_dream_scene4 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
_SDQS_dream dream = Self.GetOwningQuest() as _SDQS_dream
 Self.GetOwningQuest().setstage(230)

ObjectReference arPortal = (akSpeaker as ObjectReference).PlaceAtMe(Game.GetFormFromFile(0x0007CD55, "Skyrim.ESM")) 

Utility.wait( 3.0 )

dream.sendDreamerBack( 50 ) ; back to wherever
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
