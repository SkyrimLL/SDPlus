;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SLD_TIF_PCSubHello02a Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
; Debug.Notification("SLD: Sending story event [3]")
fctDialogue.SetNPCDialogueState ( akSpeaker )
 
; Debug.Messagebox("You are pushed down before you get a chance to say a word.")
 
fctDialogue.RobPlayer( akSpeaker)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

SLD_QST_Main Property fctDialogue  Auto

MiscObject Property Gold001  Auto  

SexLabFramework Property SexLab  Auto  
