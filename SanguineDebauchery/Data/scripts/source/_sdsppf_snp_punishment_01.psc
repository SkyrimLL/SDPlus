;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname _SDSPPF_snp_punishment_01 Extends Package Hidden

;BEGIN FRAGMENT Fragment_1
Function Fragment_1(Actor akActor)
;BEGIN CODE
ObjectReference female = _SDRAP_female.GetReference() as ObjectReference
akActor.SetAngle( akActor.GetAngleX(), akActor.GetAngleY(), akActor.GetAngleZ() + akActor.GetHeadingAngle( female ) )
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ReferenceAlias Property _SDRAP_female Auto
