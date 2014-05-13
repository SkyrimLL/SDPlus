;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 4
Scriptname _SDQF_bountyslave_01 Extends Quest Hidden

;BEGIN ALIAS PROPERTY _SDRA_master
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_master Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_guard
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_guard Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDRA_slave
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias__SDRA_slave Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY _SDLA_hold
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias__SDLA_hold Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
Self.Reset()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
;bounty.payMyCrimeGold()
_SDQP_bounty.setstage(100)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

WEBountyCollectorScript Property bounty Auto
Quest Property _SDQP_bounty  Auto  
