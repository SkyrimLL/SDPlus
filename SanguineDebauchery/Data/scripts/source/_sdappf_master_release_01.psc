;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _SDAPPF_master_release_01 Extends Package Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(Actor akActor)
;BEGIN CODE
If (_SDRAP_cage!=None)

	ObjectReference cage = _SDRAP_cage.GetReference() as ObjectReference
	 
	If (StorageUtil.GetIntValue( cage, "_SD_iCageBroken"  ) != 1) && (StorageUtil.GetIntValue(none, "_SD_bEnableCageScene") == 1)

		; Debug.Notification("[SD] Checking cage state. ID=" + cage as Form)
		; If ( cage.IsLocked() )
		;	Debug.Notification("[SD]  - Cage is locked. Unlocking it.")
		;	Debug.Notification("[SD]  - Cage is locked. Unlocking it.")
		;	cage.Lock( False, True )
		; EndIf

		; If (cage.GetOpenState() == 1)
		;	Debug.Notification("[SD]  - Updating cage state.")
		;	cage.SetOpen(0)
		; EndIf

		Debug.MessageBox("Get out and back to work.")

		akActor.EvaluatePackage()
	Else
		Debug.Trace("[_SDAPPF_master_release_01] Cage scene aborted")

	EndIf
Else
	Debug.Trace("[_SDAPPF_master_release_01] Cage alias is Null")
Endif
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ReferenceAlias Property _SDRAP_cage  Auto  
GlobalVariable Property _SDGVP_state_caged  Auto  