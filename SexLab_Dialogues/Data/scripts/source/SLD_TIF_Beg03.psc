;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SLD_TIF_Beg03 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
fctDialogue.GiftPlayer(akSpeaker)

fctDialogue.StartPlayerRape( akSpeaker, "Dirty")
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

SLD_QST_Main Property fctDialogue  Auto
MiscObject Property Gold  Auto  
SexLabFramework Property SexLab  Auto  
