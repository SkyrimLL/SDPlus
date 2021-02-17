;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _sdtif_dreamworld_01c Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
_SDQS_dream dream = Self.GetOwningQuest() as _SDQS_dream
; _SDGV_SanguineBlessing.SetValue(_SDGV_SanguineBlessing.GetValue() + 1)

ObjectReference arPortal = (akSpeaker as ObjectReference).PlaceAtMe(Game.GetFormFromFile(0x0007CD55, "Skyrim.ESM")) 
; SummonEffect.Cast( akSpeaker, akSpeaker )
Utility.wait( 3.0 )


	Int IButton = _SD_menu.Show()

	If IButton == 0   
		dream.sendDreamerBack( 15 )

	ElseIf IButton == 1  
		dream.sendDreamerBack( 25 )

	ElseIf IButton == 2  
		dream.sendDreamerBack( 35 )

	EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

GlobalVariable Property _SDGV_SanguineBlessing  Auto  

SPELL Property SummonEffect  Auto  

Message Property _SD_menu  Auto  
