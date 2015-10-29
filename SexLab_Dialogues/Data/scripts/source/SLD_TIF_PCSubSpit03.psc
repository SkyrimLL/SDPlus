;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SLD_TIF_PCSubSpit03 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
; Debug.Notification("SLD: Sending story event [3]")

Int randomNum = Utility.RandomInt(0, 100)
; StorageUtil.SetFormValue( Game.getPlayer() , "_SD_TempAggressor", akSpeaker)
StorageUtil.SetIntValue( Game.GetPlayer() , "_SD_iDom", StorageUtil.GetIntValue( Game.GetPlayer(), "_SD_iDom") + 1)
StorageUtil.SetIntValue( akSpeaker, "_SD_iDisposition", StorageUtil.GetIntValue( akSpeaker, "_SD_iDisposition"  ) + 1  )
SendModEvent("SDPunishSlave","Gag")

If (randomNum > 60)
	akSpeaker.SendModEvent("PCSubPunish") ; Punishment
ElseIf (randomNum > 20)
	akSpeaker.SendModEvent("PCSubWhip") ; Whipping
Else
	akSpeaker.SendModEvent("PCSubEntertain", "Gangbang") ; Gang Bang

EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
