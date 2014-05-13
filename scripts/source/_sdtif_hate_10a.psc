;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _sdtif_hate_10a Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
; random hate rape
; Debug.Notification("The dog suddenly humps you")

naked.Commented()
naked.SanguineRape( akSpeaker, SexLab.PlayerRef , "Aggressive,Dirty")
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Keyword Property _SDKP_sex  Auto  
_SDQS_naked Property naked  Auto

SexLabFramework Property SexLab  Auto  
