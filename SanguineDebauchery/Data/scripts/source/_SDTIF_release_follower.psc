;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 5
Scriptname _SDTIF_release_follower Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_4
Function Fragment_4(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
fctOutfit.clearDeviceNPCByString ( akSpeaker, sDeviceString = "WristRestraint" )
fctOutfit.clearDeviceNPCByString ( akSpeaker, sDeviceString = "ArmCuffs" )
fctOutfit.clearDeviceNPCByString ( akSpeaker, sDeviceString = "LegCuffs" )
fctOutfit.clearDeviceNPCByString ( akSpeaker, sDeviceString = "Blindfold" )
fctOutfit.clearDeviceNPCByString ( akSpeaker, sDeviceString = "Hood" )
fctOutfit.clearDeviceNPCByString ( akSpeaker,  sDeviceString = "Gag" )
fctOutfit.clearDeviceNPCByString ( akSpeaker, sDeviceString = "Yoke" )
fctOutfit.clearDeviceNPCByString ( akSpeaker, sDeviceString = "Gloves" )
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

_SDQS_functions Property funct  Auto

FormList Property _SDFLP_sex_items  Auto
FormList Property _SDFLP_punish_items  Auto
Spell Property _SDSP_freedom  Auto  
ReferenceAlias Property _SDRAP_player  Auto  

_sdqs_fcts_outfit Property fctOutfit  Auto  

MiscObject Property Gold  Auto  
