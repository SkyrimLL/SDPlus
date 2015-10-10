;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SLD_TIF_PCSubLeash02 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Debug.Notification("Your owner starts following you around.")

StorageUtil.SetFormValue( Game.GetPlayer(), "_SD_LeashCenter", akSpeaker)
StorageUtil.SetIntValue( Game.GetPlayer(), "_SD_iEnableLeash", 0)
StorageUtil.SetIntValue(akSpeaker,"_SD_iFollowSlave",1)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
