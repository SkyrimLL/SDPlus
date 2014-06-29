;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 4
Scriptname _sdqf_whore_01 Extends Quest Hidden

;BEGIN ALIAS PROPERTY _SDRA_whore
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_whore Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_queue_ref1
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_queue_ref1 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_master
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_master Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_queue_ref3
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_queue_ref3 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_queue_ref2
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_queue_ref2 Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN AUTOCAST TYPE _sdqs_whore
Quest __temp = self as Quest
_sdqs_whore kmyQuest = __temp as _sdqs_whore
;END AUTOCAST
;BEGIN CODE
( Alias__SDRA_whore.GetReference() as Actor ).RemoveSpell( _SDSP_dance )
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN AUTOCAST TYPE _sdqs_whore
Quest __temp = self as Quest
_sdqs_whore kmyQuest = __temp as _sdqs_whore
;END AUTOCAST
;BEGIN CODE
( Alias__SDRA_whore.GetReference() as Actor ).AddSpell( _SDSP_dance )
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

SPELL Property _SDSP_dance  Auto  
