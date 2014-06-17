;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 5
Scriptname _SDSP_slave_caged_scene Extends Package Hidden

;BEGIN FRAGMENT Fragment_4
Function Fragment_4(Actor akActor)
;BEGIN CODE
Actor kPlayer = Game.GetPlayer()
Float kMaxTime = kPlayer.GetDistance(_SDRAP_cageMarker.getRef()) / 32
Int kElapsed = 0
While (kElapsed < kMaxTime)
    Utility.Wait(10)
    If(kPlayer.GetDistance(_SDRAP_cageMarker.getRef()) < 150)
        kPlayer.MoveTo(_SDRAP_cageMarker.GetRef())
        kElapsed = Math.Ceiling(kMaxTime)
    EndIf
    kElapsed = kElapsed + 10
EndWhile
If(kPlayer.GetDistance(_SDRAP_cageMarker.getRef()) > 128)
    ;Insert/flag punishment for slow/unwilling slave
EndIf
kPlayer.MoveTo(_SDRAP_cageMarker.GetRef())
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ReferenceAlias Property _SDRAP_CageMarker  Auto  
