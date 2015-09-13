;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _sdtif_naked_11 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
naked.Commented()
 

; Whipping
; _SDKP_sex.SendStoryEvent(akRef1 = akSpeaker, akRef2 = akSpeaker.GetDialogueTarget(), aiValue1 = 5 )

naked.SanguineRape( akSpeaker, SexLab.PlayerRef , "Fisting")
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Keyword Property _SDKP_sex  Auto  
_SDQS_naked Property naked  Auto

SexLabFramework Property SexLab  Auto  
