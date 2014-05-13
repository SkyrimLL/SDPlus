;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 4
Scriptname _SDGF_patch_dawnguard_01 Extends Quest Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
FormList slavers = Game.GetFormFromFile(0x00004E11, "sanguinesDebauchery.esp") As FormList
Int idx = 0
While ( slavers && idx < _SDFP_dawnguard.Length )
	If ( slavers.Find( _SDFP_dawnguard[idx] ) < 0 )
		slavers.AddForm( _SDFP_dawnguard[idx] )
	EndIf
	idx += 1
EndWhile
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
FormList slavers = Game.GetFormFromFile(0x00004E11, "sanguinesDebauchery.esp") As FormList
Int idx = 0
While ( slavers && idx < _SDFP_dawnguard.Length )
	If ( slavers.Find( _SDFP_dawnguard[idx] ) >= 0 )
		slavers.RemoveAddedForm( _SDFP_dawnguard[idx] )
	EndIf
	idx += 1
EndWhile
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Faction[] Property _SDFP_dawnguard  Auto  
