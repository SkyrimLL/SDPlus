;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SLD_TIF_PCSubWork10 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Actor kPlayer = Game.Getplayer()

StorageUtil.SetIntValue( kPlayer  , "_SD_iHandsFree", 1)
StorageUtil.SetIntValue( kPlayer  , "_SD_iEnableAction", 1)
StorageUtil.SetStringValue( kPlayer , "_SD_sDefaultStance", "Standing")
StorageUtil.SetIntValue( kPlayer , "_SD_iEnableStand", 1 )

SendModEvent( "SDHandsFreeSlave" )
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

MiscObject Property Gold  Auto  
