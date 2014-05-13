;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _sdtif_dreamworld_02 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Debug.Notification( "You want to leave so soon?" )

Game.ForceThirdPerson()
Debug.SendAnimationEvent(Game.GetPlayer() as ObjectReference, "bleedOutStart")

Int IButton = _SD_rapeMenu.Show()

If IButton == 0 ; Show the thing.

	funct.SanguineRape( akSpeaker, Game.GetPlayer() , "Doggystyle")

EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

GlobalVariable Property _SDGV_SanguineBlessing  Auto  

Keyword Property _SDKP_sex  Auto  

GlobalVariable Property _SDGVP_punishments  Auto  

SexLabFramework Property SexLab  Auto  

_sdqs_functions Property funct  Auto  

Message Property _SD_rapeMenu  Auto  
