;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SLD_TIF_PCSubCold01 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
; Debug.Notification("SLD: Sending story event [3]")

Int randomNum = Utility.RandomInt(0, 100)
; StorageUtil.SetFormValue( Game.getPlayer() , "_SD_TempAggressor", akSpeaker)

If (randomNum > 70)
	akSpeaker.SendModEvent("PCSubWhip") ; Whipping
Else
	akSpeaker.SendModEvent("PCSubSex") ; Sex
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
