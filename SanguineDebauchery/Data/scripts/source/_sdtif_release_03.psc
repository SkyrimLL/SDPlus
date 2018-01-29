;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 5
Scriptname _sdtif_release_03 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_4
Function Fragment_4(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Actor kPlayer = Game.GetPlayer(); _SDRAP_player.GetReference() as Actor


;		funct.removeItemsInList( kPlayer, _SDFLP_sex_items )
;		funct.removeItemsInList( kPlayer, _SDFLP_punish_items )
		_SDSP_freedom.RemoteCast( kPlayer, kPlayer, kPlayer )

fctOutfit.clearDeviceByString( sDeviceString = "WristRestraint" )
fctOutfit.clearDeviceByString( sDeviceString = "ArmCuffs" )
fctOutfit.clearDeviceByString( sDeviceString = "LegCuffs" )
fctOutfit.clearDeviceByString( sDeviceString = "Blindfold" )
fctOutfit.clearDeviceByString( sDeviceString = "Hood" )
fctOutfit.clearDeviceByString( sDeviceString = "Gag" )
fctOutfit.clearDeviceByString( sDeviceString = "Yoke" )
fctOutfit.clearDeviceByString( sDeviceString = "Gloves" )

		funct.SanguineRape( akSpeaker, kPlayer  , "Dirty")
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

_SDQS_functions Property funct  Auto
_SDQS_fcts_outfit Property fctOutfit  Auto

FormList Property _SDFLP_sex_items  Auto
FormList Property _SDFLP_punish_items  Auto
Spell Property _SDSP_freedom  Auto  
ReferenceAlias Property _SDRAP_player  Auto  

SexLabFramework Property SexLab  Auto  
