;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _sdtif_dreamworld_03 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Debug.Notification( "We are just getting started!" )

Game.ForceThirdPerson()
Debug.SendAnimationEvent(Game.GetPlayer() as ObjectReference, "bleedOutStart")

Int IButton = _SD_rapeMenu.Show()

If IButton == 0 ; Show the thing.

 	; Whipping
	; _SDKP_sex.SendStoryEvent(akRef1 = akSpeaker, akRef2 = Game.GetPlayer(), aiValue1 = 5 )

	; Just sex
	funct.SanguineRape( akSpeaker, Game.GetPlayer()  , "Sex,Aggressive")
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
