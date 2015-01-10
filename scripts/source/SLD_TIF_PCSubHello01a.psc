;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SLD_TIF_PCSubHello01a Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
; Debug.Notification("SLD: Sending story event [3]")
 
Debug.Messagebox("You are grabbed by the collar and forcefully enslaved.")
; fctDialogue.StartPlayerRape( akSpeaker, "Rough")

StorageUtil.SetFormValue( Game.getPlayer() , "_SD_TempAggressor", akSpeaker)
SendModEvent("PCSubEnslave")
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

SLD_QST_Main Property fctDialogue  Auto
