;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 3
Scriptname _SDSPPF_snp_move_to_marker_01 Extends Package Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(Actor akActor)
;BEGIN CODE
;
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2(Actor akActor)
;BEGIN CODE
ObjectReference female = _SDRAP_female.GetReference() as ObjectReference
ObjectReference marker = _SDRAP_marker.GetReference() as ObjectReference

marker.MoveTo( female, 96 * Math.Sin( female.GetAngleZ() ), 96 * Math.Cos( female.GetAngleZ() ), female.GetHeight() )
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ReferenceAlias Property _SDRAP_female  Auto
ReferenceAlias Property _SDRAP_marker  Auto  
