;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _sdtif_dreamworld_04 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Game.ForceThirdPerson()
; Debug.SendAnimationEvent(Game.GetPlayer() as ObjectReference, "bleedOutStart")

Int IButton = _SD_rapeMenu.Show()

If IButton == 0 ; Show the thing.

Int randomNum = Utility.RandomInt(0, 100)
StorageUtil.SetFormValue( Game.getPlayer() , "_SD_TempAggressor", akSpeaker)

If (randomNum > 70)
	SendModEvent("PCSubPunish") ; Punishment
ElseIf (randomNum > 30)
	SendModEvent("PCSubWhip") ; Whipping
Else
	SendModEvent("PCSubSex") ; Sex
EndIf

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
