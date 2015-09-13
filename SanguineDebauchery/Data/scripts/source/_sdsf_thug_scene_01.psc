;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 8
Scriptname _SDSF_thug_scene_01 Extends Scene Hidden

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
If ( _SDGVP_config_enableTrainRun.GetValueInt() == 1 && _SDQP_whore.IsRunning()  )
	If ( _SDRAP_master )
		_SDRAP_master.GetActorReference().StopCombat()
		_SDRAP_master.GetActorReference().EvaluatePackage()
		whore.addToQueue( _SDRAP_master.GetReference() as ObjectReference )
	EndIf
	If ( _SDRAP_thug_1 )
		_SDRAP_thug_1.GetActorReference().StopCombat()
		_SDRAP_thug_1.GetActorReference().EvaluatePackage()
		whore.addToQueue( _SDRAP_thug_1.GetReference() as ObjectReference )
	EndIf
	If ( _SDRAP_thug_2)
		_SDRAP_thug_2.GetActorReference().StopCombat()
		_SDRAP_thug_2.GetActorReference().EvaluatePackage()
		whore.addToQueue( _SDRAP_thug_2.GetReference() as ObjectReference )
	EndIf
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

_SDQS_whore Property whore  Auto  

Quest Property _SDQP_whore  Auto  
GlobalVariable Property _SDGVP_config_enableTrainRun  Auto  
GlobalVariable Property _SDGVP_positions  Auto  

ReferenceAlias Property _SDRAP_slave  Auto  
ReferenceAlias Property _SDRAP_master  Auto  
ReferenceAlias Property _SDRAP_thug_1  Auto  
ReferenceAlias Property _SDRAP_thug_2  Auto  

Keyword Property _SDKP_sex  Auto  
