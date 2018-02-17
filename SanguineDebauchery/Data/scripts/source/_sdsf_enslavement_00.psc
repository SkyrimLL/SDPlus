;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 15
Scriptname _sdsf_enslavement_00 Extends Scene Hidden

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
; Debug.Notification("[SD] Cage scene - phase 1")
	Debug.Trace("[SD] Cage scene -  phase 1")
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_8
Function Fragment_8()
;BEGIN CODE
; Debug.Notification("[SD] Cage scene - phase 3")
	Debug.Trace("[SD] Cage scene -  phase 3")
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
; Debug.Notification("[cage] phase = 0" )
ObjectReference cage = _SDRAP_cage.GetReference() as ObjectReference
ObjectReference mark = _SDRAP_cage_marker.GetReference() as ObjectReference
Actor kSlave = _SDRAP_slave.GetReference() as Actor

	; Debug.Notification("[SD] Cage scene - scene start")
	Debug.Trace("[SD] Cage scene - scene start")


StorageUtil.SetIntValue( none, "_SD_iCageSceneActive"  , 0)
_SDGVP_state_caged.SetValue( 0 )

If (StorageUtil.GetIntValue( cage, "_SD_iCageBroken"  ) != 1)

	; Game.DisablePlayerControls( abMovement = true )
	; Game.SetPlayerAIDriven()

	Debug.MessageBox("Go to your cage.. right now!")

	mark.MoveTo(cage, -64.0 * Math.Sin(cage.GetAngleZ()), -64.0 * Math.Cos(cage.GetAngleZ()), 0.0)

	If ( cage.IsLocked() )
		cage.Lock( False )
	EndIf

	cage.SetOpen()
	StorageUtil.SetIntValue( none, "_SD_iCageSceneActive"  , 1)

EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
; Debug.Notification("[cage] phase = -1" )

	; Debug.Notification("[SD] Cage scene - scene end")
	Debug.Trace("[SD] Cage scene - scene end")

Game.EnablePlayerControls( abMovement = True )
Game.SetPlayerAIDriven( False )

ObjectReference cage = _SDRAP_cage.GetReference() as ObjectReference
ObjectReference cageMarker = _SDRAP_cage_marker.GetReference() as ObjectReference
Actor kSlave = _SDRAP_slave.GetReference() as Actor
Actor kMaster = _SDRAP_master.GetReference() as Actor

	; Debug.Notification("[SD] Cage scene - distance to player: " + cage.GetDistance(kSlave ))
	Debug.Trace("[SD] Cage scene - distance to player: " + cage.GetDistance(kSlave ))

if (cage.GetDistance(kSlave ) < 150)
	kSlave.MoveTo(cageMarker)
	cage.SetOpen( False )

	If ( !cage.IsLocked() )
		cage.Lock( True )
	EndIf

	_SDGVP_state_caged.SetValue( 1 )

	cage.SetLockLevel( kSlave.GetBaseAV("Lockpicking") as Int )

	Debug.MessageBox("Now stay quiet for the rest of the night.")
else
	Int randomNum = Utility.RandomInt(0, 100)

	StorageUtil.SetIntValue( kSlave , "_SD_iDom", StorageUtil.GetIntValue(kSlave , "_SD_iDom") + 1)
	StorageUtil.SetIntValue( kMaster, "_SD_iDisposition", StorageUtil.GetIntValue( kMaster, "_SD_iDisposition"  ) - 1  )
	kSlave.SendModEvent("SDPunishSlave","Gag")

	If (randomNum > 60)
		kMaster.SendModEvent("PCSubPunish") ; Punishment
	ElseIf (randomNum > 20)
		kMaster.SendModEvent("PCSubWhip") ; Whipping
	Else
		kMaster.SendModEvent("PCSubSex") ; Sex
	EndIf
endif

StorageUtil.SetIntValue( none, "_SD_iCageSceneActive"  , 0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
	; Debug.Notification("[SD] Cage scene - phase 2")
	Debug.Trace("[SD] Cage scene -  phase 2")
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ReferenceAlias Property _SDRAP_slave  Auto  
ReferenceAlias Property _SDRAP_master  Auto  
ReferenceAlias Property _SDRAP_cage  Auto  
ReferenceAlias Property _SDRAP_cage_marker  Auto  
GlobalVariable Property _SDGVP_state_caged  Auto 
