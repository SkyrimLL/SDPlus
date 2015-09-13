;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _sdtif_dream_05 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
_SDQS_dream dream = Self.GetOwningQuest() as _SDQS_dream

_SDGV_SanguineBlessing.SetValue(_SDGV_SanguineBlessing.GetValue() + 1)

Utility.wait( 5.0 )


; Add new dialogue - let me go

; Inflict pain or pleasure on NPCs around in order to leave

; Add option to go directy after sex with Sanguine (if hands bound)
dream.sendDreamerBack( 10 )
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

GlobalVariable Property _SDGV_SanguineBlessing  Auto  
