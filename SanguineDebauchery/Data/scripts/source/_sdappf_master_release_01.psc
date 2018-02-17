;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _SDAPPF_master_release_01 Extends Package Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(Actor akActor)
;BEGIN CODE
ObjectReference cage = _SDRAP_cage.GetReference() as ObjectReference
 
If (StorageUtil.GetIntValue( cage, "_SD_iCageBroken"  ) != 1)

	If ( cage.IsLocked() )
		cage.Lock( False )
	EndIf
	cage.SetOpen( )

	Debug.MessageBox("Get out and back to work.")
	_SDGVP_state_caged.SetValue(0)
	StorageUtil.SetIntValue( none, "_SD_iCageSceneActive"  , 0)

	akActor.EvaluatePackage()
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ReferenceAlias Property _SDRAP_cage  Auto  
GlobalVariable Property _SDGVP_state_caged  Auto  