;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 3
Scriptname _sdappf_master_caged_01 Extends Package Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(Actor akActor)
;BEGIN CODE
; Cage scene - Play Testing Required
_SDSP_caged.ForceStart()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2(Actor akActor)
;BEGIN CODE
ObjectReference cage = _SDRAP_cage.GetReference() as ObjectReference
ObjectReference mark = _SDRAP_cage_marker.GetReference() as ObjectReference

mark.MoveTo(cage, 32.0 * Math.Sin(cage.GetAngleZ()), 32.0 * Math.Cos(cage.GetAngleZ()), 0.0)

If ( cage.IsLocked() )
                Debug.Notification("imgay")
	;cage.Lock( False )
EndIf

If (cage.GetOpenState() == 1)
	cage.SetOpen(0)
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Scene Property _SDSP_caged  Auto  
ReferenceAlias Property _SDRAP_cage  Auto  
ReferenceAlias Property _SDRAP_cage_marker  Auto  
