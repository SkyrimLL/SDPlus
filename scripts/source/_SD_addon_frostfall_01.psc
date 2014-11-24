;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 4
Scriptname _SD_addon_frostfall_01 Extends Quest Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
GoToState("monitor")

exposure    = Game.GetFormFromFile(0x0000183D, "chesko_frostfall.esp") As GlobalVariable
heatsources = Game.GetFormFromFile(0x0000D019, "chesko_frostfall.esp") As FormList

mortality   = Game.GetFormFromFile(0x000BBF59, "sanguinesDebauchery.esp") As GlobalVariable

Debug.Notification("SD Frostfall: adding heatsources ")
Int idx = 0
While ( heatsources && idx < kArmor.Length )
	If ( heatsources.Find( kArmor[idx] ) < 0 )
		; Debug.Notification("SD Frostfall: adding armor as heatsource " + kArmor[idx])
		heatsources.AddForm( kArmor[idx] )
	EndIf
	idx += 1
EndWhile

RegisterForSingleUpdate( 1.0 )
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
GoToState("null")

Int idx = 0
While ( heatsources && idx < kArmor.Length )
	If ( heatsources.Find( kArmor[idx] ) >= 0 )
		heatsources.RemoveAddedForm( kArmor[idx] )
	EndIf
	idx += 1
EndWhile

_SDGVP_mirror_frostfallMortality.SetValue( -1 )
_SDGVP_mirror_frostfallExposure.SetValue( -1 )
mortality.SetValue( 0 )
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

GlobalVariable mortality
GlobalVariable exposure
FormList heatsources
Armor slaveArmor1
Armor slaveArmor2
Armor[] kArmor

Event OnInit()
	kArmor = New Armor[6]
	kArmor[0] = Game.GetFormFromFile(0x000963C2, "sanguinesDebauchery.esp") As Armor
	kArmor[1] = Game.GetFormFromFile(0x00099445, "sanguinesDebauchery.esp") As Armor
	kArmor[2] = Game.GetFormFromFile(0x00024E56, "sanguinesDebauchery.esp") As Armor
	kArmor[3] = Game.GetFormFromFile(0x00062AE2, "sanguinesDebauchery.esp") As Armor
	kArmor[4] = Game.GetFormFromFile(0x0007F518, "sanguinesDebauchery.esp") As Armor
	kArmor[5] = Game.GetFormFromFile(0x0007F519, "sanguinesDebauchery.esp") As Armor
EndEvent

Auto State null
EndState

State monitor
	Event OnUpdate()
		_SDGVP_mirror_frostfallMortality.SetValue( mortality.GetValueInt( ) )
		_SDGVP_mirror_frostfallExposure.SetValue( exposure.GetValueInt( ) )
		
		If mortality.GetValueInt( ) == 1
			If exposure.GetValue() < 20
				Game.GetPlayer().EndDeferredKill()
			Else
				Game.GetPlayer().StartDeferredKill()
			EndIf
		EndIf
		
		RegisterForSingleUpdate( 1.0 )
	EndEvent
EndState

GlobalVariable Property _SDGVP_mirror_frostfallMortality  Auto  
GlobalVariable Property _SDGVP_mirror_frostfallExposure   Auto  
