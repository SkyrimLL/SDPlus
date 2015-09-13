;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _sdtif_walk_02 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
If (_SDGVP_isMasterInTransit.GetValue() == 1 )
	Debug.Messagebox("Your owner is staying put for now. Don't take that as a permission to wander off!!")
EndIf

StorageUtil.SetIntValue( Game.GetPlayer() ,"_SD_iEnableLeash", 0)
StorageUtil.SetIntValue( akSpeaker,"_SD_iFollowSlave", 1)
_SDGVP_isMasterFollower.SetValue(1) 
_SDGVP_isLeashON.SetValue(0)
_SDGVP_isMasterInTransit.SetValue(0)


akSpeaker.EvaluatePackage()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

GlobalVariable Property _SDGVP_isMasterFollower  Auto  

GlobalVariable Property _SDGVP_isLeashON  Auto  

GlobalVariable Property _SDGVP_isMasterInTransit  Auto  
