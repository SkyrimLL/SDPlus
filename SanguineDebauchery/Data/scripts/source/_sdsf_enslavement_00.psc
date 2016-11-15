;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 15
Scriptname _sdsf_enslavement_00 Extends Scene Hidden

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
; Debug.Notification("[cage] phase = 2" )
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
; Debug.Notification("[cage] phase =1" )
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_8
Function Fragment_8()
;BEGIN CODE
; Debug.Notification("[cage] phase = 6" )
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
; Debug.Notification("[cage] phase = 0" )
ObjectReference cage = _SDRAP_cage.GetReference() as ObjectReference
ObjectReference mark = _SDRAP_cage_marker.GetReference() as ObjectReference

If (StorageUtil.GetIntValue( cage, "_SD_iCageBroken"  ) != 1)

	Game.DisablePlayerControls( abMovement = true )
	Game.SetPlayerAIDriven()

	Debug.MessageBox("Go to your cage.. right now!")

	mark.MoveTo(cage, -64.0 * Math.Sin(cage.GetAngleZ()), -64.0 * Math.Cos(cage.GetAngleZ()), 0.0)

	If ( cage.IsLocked() )
		cage.Lock( False )
	EndIf

	cage.SetOpen()
EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
; Debug.Notification("[cage] phase = -1" )

Game.EnablePlayerControls( abMovement = True )
Game.SetPlayerAIDriven( False )

ObjectReference cage = _SDRAP_cage.GetReference() as ObjectReference
Actor slave = _SDRAP_slave.GetReference() as Actor

cage.SetOpen( False )

If ( !cage.IsLocked() )
	cage.Lock( True )
EndIf

cage.SetLockLevel( slave.GetBaseAV("Lockpicking") as Int )
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ReferenceAlias Property _SDRAP_slave  Auto  
ReferenceAlias Property _SDRAP_cage  Auto  
ReferenceAlias Property _SDRAP_cage_marker  Auto  
