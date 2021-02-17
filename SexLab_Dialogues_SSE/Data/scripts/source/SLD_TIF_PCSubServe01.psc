;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SLD_TIF_PCSubServe01 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Int iRandomNum = Utility.RandomInt(0,100)

If (iRandomNum > 80)
    SendModEvent("SDPickNextTask","Bring firewood")
ElseIf (iRandomNum > 50)
    SendModEvent("SDPickNextTask","Bring ingredient")
Else
    SendModEvent("SDPickNextTask","Bring food")
Endif
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
