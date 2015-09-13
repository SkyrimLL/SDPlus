;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _sdtif_walk_01 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
If ( _SDGVP_isMasterInTransit.GetValue() == 0 )
	Debug.Messagebox("Your owner is going on a walk. Don't stray too far or you will be punished!")
EndIf

StorageUtil.SetIntValue( Game.GetPlayer() ,"_SD_iEnableLeash", 1)
StorageUtil.SetIntValue( akSpeaker,"_SD_iFollowSlave", 0)
_SDGVP_isMasterFollower.SetValue(0) 
_SDGVP_isLeashON.SetValue(1)
_SDGVP_isMasterInTransit.SetValue(1)


akSpeaker.EvaluatePackage()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

GlobalVariable Property _SDGVP_isMasterFollower  Auto  

GlobalVariable Property _SDGVP_isLeashON  Auto  

GlobalVariable Property _SDGVP_isMasterInTransit  Auto  
