;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 3
Scriptname _SD_PlayerAliciaStart Extends Quest Hidden

;BEGIN ALIAS PROPERTY SD_PlayerAliciaStartRef
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_SD_PlayerAliciaStartRef Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
SetObjectiveDisplayed( 10)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
SetObjectiveDisplayed( 10, false)

if (dreamQuest.GetStageDone(200) == 0)
    dreamQuest.Setstage(200)
endif
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
_sdqs_dream Property dreamQuest  Auto  
