;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _sdtif_dream_scene2b Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Self.GetOwningQuest().setstage(210)
;	funct.SanguineRape( akSpeaker, Game.GetPlayer() , "Oral")

_SDQS_dream dream = Self.GetOwningQuest() as _SDQS_dream
; _SDGV_SanguineBlessing.SetValue(_SDGV_SanguineBlessing.GetValue() + 1)

ObjectReference arPortal = (akSpeaker as ObjectReference).PlaceAtMe(Game.GetFormFromFile(0x0007CD55, "Skyrim.ESM")) 
; SummonEffect.Cast( akSpeaker, akSpeaker )
Utility.wait( 3.0 )


dream.sendDreamerBack( 35 )
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment


Message Property  _SD_rapeMenu Auto

_SDQS_functions Property funct  Auto


