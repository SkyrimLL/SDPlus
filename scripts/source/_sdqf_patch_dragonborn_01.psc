;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 4
Scriptname _SDQF_patch_dragonborn_01 Extends Quest Hidden

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
FormList slavers = Game.GetFormFromFile(0x00004E11, "sanguinesDebauchery.esp") As FormList
Int idx = 0
While ( slavers && idx < _SDFP_dragonborne.Length )
	If ( slavers.Find( _SDFP_dragonborne[idx] ) >= 0 )
		slavers.RemoveAddedForm( _SDFP_dragonborne[idx] )
	EndIf
	idx += 1
EndWhile

FormList spriggans = Game.GetFormFromFile(0x000E167B, "sanguinesDebauchery.esp") As FormList
idx = 0
While ( spriggans && idx < _SDFP_spriggans.Length )
	If ( spriggans.Find( _SDFP_spriggans[idx] ) >= 0 )
		spriggans.RemoveAddedForm( _SDFP_spriggans[idx] )
	EndIf
	idx += 1
EndWhile
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
FormList slavers = Game.GetFormFromFile(0x00004E11, "sanguinesDebauchery.esp") As FormList
Int idx = 0
While ( slavers && idx < _SDFP_dragonborne.Length )
	If ( slavers.Find( _SDFP_dragonborne[idx] ) < 0 )
		slavers.AddForm( _SDFP_dragonborne[idx] )
	EndIf
	idx += 1
EndWhile

FormList spriggans = Game.GetFormFromFile(0x000E167B, "sanguinesDebauchery.esp") As FormList
idx = 0
While ( spriggans && idx < _SDFP_spriggans.Length )
	If ( spriggans.Find( _SDFP_spriggans[idx] ) < 0 )
		spriggans.AddForm( _SDFP_spriggans[idx] )
	EndIf
	idx += 1
EndWhile
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Faction[] Property _SDFP_dragonborne  Auto 
Faction[] Property _SDFP_spriggans  Auto 
