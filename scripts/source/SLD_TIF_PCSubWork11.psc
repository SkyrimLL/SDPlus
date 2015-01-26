;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SLD_TIF_PCSubWork11 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
StorageUtil.SetIntValue( Game.getPlayer() , "_SD_iEnableWeaponEquip", 1)
StorageUtil.SetIntValue( Game.getPlayer() , "_SD_iEnableArmorEquip", 1)
StorageUtil.SetIntValue( Game.getPlayer() , "_SD_iEnableFight", 1)
StorageUtil.SetStringValue( Game.GetPlayer(), "_SD_sDefaultStance", "Standing")
StorageUtil.SetIntValue( Game.GetPlayer(), "_SD_iEnableStand", 1 )
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

MiscObject Property Gold  Auto  
