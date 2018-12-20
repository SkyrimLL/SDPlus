;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SLD_TIF_GiftGold01a Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
; Debug.Notification("SLD: Sending story event [3]")
Actor kPlayer = Game.GetPlayer()

fctDialogue.SetNPCDialogueState ( akSpeaker )
SendModEvent("SDModTaskAmount","Ignore", -1)
akSpeaker.EvaluatePackage()

Int randomNum = Utility.RandomInt(0, 100)
StorageUtil.SetIntValue( kPlayer , "_SD_iDom", StorageUtil.GetIntValue( kPlayer , "_SD_iDom") + 1)
StorageUtil.SetIntValue( akSpeaker, "_SD_iDisposition", StorageUtil.GetIntValue( akSpeaker, "_SD_iDisposition"  ) - 1  )

If (randomNum > 60)
	akSpeaker.SendModEvent("PCSubPunish") ; Punishment
ElseIf (randomNum > 20)
	akSpeaker.SendModEvent("PCSubWhip") ; Whipping
Else
	akSpeaker.SendModEvent("PCSubSex") ; Sex
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

SPELL Property CharitySpell  Auto  

FormList Property _SLD_GiftFilter  Auto  
SLD_QST_Main Property fctDialogue  Auto
