;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 4
Scriptname _SD_addon_frostfall_01 Extends Quest Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE

; Exposure variable disabled for Frostfall 3.0 compatibility

exposure    = none ; Game.GetFormFromFile(0x0000183D, "chesko_frostfall.esp") As GlobalVariable
heatsources = none ; Game.GetFormFromFile(0x0000D019, "chesko_frostfall.esp") As FormList

mortality   = Game.GetFormFromFile(0x000BBF59, "sanguinesDebauchery.esp") As GlobalVariable

; Debug.Notification("[SD] Frostfall Init mortality: " + mortality.GetValueInt( ))
; Debug.Notification("[SD] Frostfall Init exposure: " + exposure.GetValueInt( ))

Debug.Notification("[SD] Frostfall adding heatsources ")

; Frostfall 3.0 doesn't handle armor as heat source in the same way. Using modExposure instead.
If (heatsources != None) && (exposure != None)

	Int idx = 0
	While ( heatsources && idx < kArmor.Length )
		If ( heatsources.Find( kArmor[idx] ) < 0 )
			; Debug.Notification("SD Frostfall: adding armor as heatsource " + kArmor[idx])
			heatsources.AddForm( kArmor[idx] )
		EndIf
		idx += 1
	EndWhile
Endif

; RegisterForSingleUpdate( 1.0 )
GoToState("monitor")

;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE

; Frostfall 3.0 doesn't handle armor as heat source in the same way. Using modExposure instead.
If (heatsources != None) && (exposure != None)

	Int idx = 0
	While ( heatsources && idx < kArmor.Length )
		If ( heatsources.Find( kArmor[idx] ) >= 0 )
			heatsources.RemoveAddedForm( kArmor[idx] )
		EndIf
		idx += 1
	EndWhile

EndIf

_SDGVP_mirror_frostfallMortality.SetValue( -1 )
; _SDGVP_mirror_frostfallExposure.SetValue( -1 )
mortality.SetValue( 0 )
GoToState("null")

;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
import FrostUtil
Bool bFrostFallInit = false

GlobalVariable mortality
GlobalVariable exposure
FormList heatsources
Armor slaveArmor1
Armor slaveArmor2
Armor[] kArmor
ObjectReference kPlayerStorageRef
ObjectReference kPlayerRef
Actor kPlayer
Actor kMaster
Float fMasterDistance
 
Float frostfallColdLimit = 40.0
; 0.0 - 19.9 = Warm
; 20.0 - 39.9 = Comfortable
; 40.0 - 59.9 = Cold
; 60.0 - 79.9 = Very Cold
; 80.0 - 99.9 = Freezing
; 100.0 - 120.0 = Freezing to Death

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
		If (FrostUtil.GetAPIVersion() > 0) && !bFrostFallInit
			; exposurePoints.SetValue( FrostUtil.GetPlayerExposure() )
			Debug.Notification("[SD] Frostfall 3.0 update detected" )
			bFrostFallInit = true
		endIf

		kPlayerStorageRef = Game.GetFormFromFile(0x00113D17, "sanguinesDebauchery.esp") as ObjectReference
		kPlayerRef = Game.GetPlayer() 
		kPlayer = Game.GetPlayer() as Actor

		If bFrostFallInit

			_SDGVP_mirror_frostfallMortality.SetValue( mortality.GetValueInt( ) )
			; _SDGVP_mirror_frostfallExposure.SetValue( exposure.GetValueInt( ) )
			
			; Debug.Notification("[SD] Frostfall mortality: " + mortality.GetValueInt( ))
			; Debug.Notification("[SD] Frostfall exposure: " + exposure.GetValue( ))

			If mortality.GetValueInt( ) == 1
				If (FrostUtil.GetPlayerExposure() >= 100 )
				;	Game.GetPlayer().EndDeferredKill()
					If (StorageUtil.GetIntValue( Game.GetPlayer(), "_SD_iSanguineBlessings") >= 1) && (kPlayerRef.GetParentCell() != kPlayerStorageRef.GetParentCell())

						Debug.Trace("[SD] Frostfall: Sending SD Dreamworld event " )
						Debug.MessageBox("You collapse after nearly freezing to death and wake up back into Sanguine's lap." )
						SendModEvent("SDDreamworldPull")

					EndIf
				ElseIf (FrostUtil.GetPlayerExposure() >= 80 ) && (Utility.RandomInt(0,100)>90)
					Debug.Notification("You are numb from the cold." )

				Else
				;	Game.GetPlayer().StartDeferredKill()
				EndIf

				if (StorageUtil.GetIntValue(kPlayer, "_SD_iEnslaved") == 1)
					kMaster = StorageUtil.GetFormValue(kPlayer, "_SD_CurrentOwner") as Actor
					fMasterDistance = kPlayer.GetDistance( kMaster )

					if (fMasterDistance < 100) && (FrostUtil.GetPlayerExposure() >= 40 ) ; Cold and close to master
						FrostUtil.ModPlayerExposure( -2.0, frostfallColdLimit )
						Debug.Notification("[SD] Master warmth: " + FrostUtil.GetPlayerExposure() )

					elseif (fMasterDistance < 50) && (FrostUtil.GetPlayerExposure() >= 40 ) ; Cold and very close to master
						FrostUtil.ModPlayerExposure( -10.0, frostfallColdLimit )
						Debug.Notification("[SD] Master heat: " + FrostUtil.GetPlayerExposure() )

					endIf
				endif
			EndIf
		Endif
		
		RegisterForSingleUpdate( 1.0 )
	EndEvent
EndState

GlobalVariable Property _SDGVP_mirror_frostfallMortality  Auto  
GlobalVariable Property _SDGVP_mirror_frostfallExposure   Auto  
