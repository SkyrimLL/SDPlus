;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SLD_TIF_PCSubBeastRebeDraugrMagic Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Int randomNum = Utility.RandomInt(0, 100)
; StorageUtil.SetFormValue( Game.getPlayer() , "_SD_TempAggressor", akSpeaker)
StorageUtil.SetIntValue( Game.GetPlayer() , "_SD_iDom", StorageUtil.GetIntValue( Game.GetPlayer(), "_SD_iDom") + 1)

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
