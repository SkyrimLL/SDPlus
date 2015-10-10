;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SLD_TIF_PCSubWork01a Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
; Debug.Notification("SLD: Sending story event [3]")

Int randomNum = Utility.RandomInt(0, 100)
; StorageUtil.SetFormValue( Game.getPlayer() , "_SD_TempAggressor", akSpeaker)

 Game.getPlayer().AddItem(Gold, Utility.RandomInt(1, 10 + ((akSpeaker.GetAV("Confidence") as Int) + (akSpeaker.GetAV("Morality") as Int) ) * (akSpeaker.GetAV("Assistance") as Int) ), false)

If (randomNum > 70)
	Debug.Notification("Dance for us...")
	akSpeaker.SendModEvent("PCSubEntertain") ; Dance
ElseIf (randomNum > 50)
	Debug.Notification("Show us what you can do...")
	akSpeaker.SendModEvent("PCSubEntertain", "Soloshow") ; Show
ElseIf (randomNum > 30)
	Debug.Notification("Help yourselves boys!...")
	akSpeaker.SendModEvent("PCSubEntertain", "Gangbang") ; Gang bang
Else
	Debug.Notification("Get on your knees and lift up that ass of yours...")
	akSpeaker.SendModEvent("PCSubSex") ; Sex
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

MiscObject Property Gold  Auto  
