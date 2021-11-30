;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 5
Scriptname _sdtif_release_03sg Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_4
Function Fragment_4(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Actor kPlayer = Game.GetPlayer(); _SDRAP_player.GetReference() as Actor


;		funct.removeItemsInList( kPlayer, _SDFLP_sex_items )
;		funct.removeItemsInList( kPlayer, _SDFLP_punish_items )
		_SDSP_freedom.RemoteCast( kPlayer, kPlayer, kPlayer )

fctOutfit.clearDeviceByString( sDeviceString = "WristRestraint", sOutfitString = "" )
fctOutfit.clearDeviceByString( sDeviceString = "ArmCuffs" , sOutfitString = "" )
fctOutfit.clearDeviceByString( sDeviceString = "LegCuffs" , sOutfitString = "" )
fctOutfit.clearDeviceByString( sDeviceString = "Blindfold" , sOutfitString = "" )
fctOutfit.clearDeviceByString( sDeviceString = "Hood" , sOutfitString = "" )
fctOutfit.clearDeviceByString( sDeviceString = "Gag" , sOutfitString = "" )
fctOutfit.clearDeviceByString( sDeviceString = "Plug" , sOutfitString = "" )
fctOutfit.clearDeviceByString( sDeviceString = "PlugAnal" , sOutfitString = "" )
fctOutfit.clearDeviceByString( sDeviceString = "PlugVaginal" , sOutfitString = "" )
fctOutfit.clearDeviceByString( sDeviceString = "Yoke" , sOutfitString = "" )
fctOutfit.clearDeviceByString( sDeviceString = "Gloves" , sOutfitString = "" )
fctOutfit.clearDeviceByString( sDeviceString = "PiercingVaginal" , sOutfitString = "" )
        fctOutfit.clearNonGenericDeviceByString ( "WristRestraints", "Sanguine" )
        fctOutfit.clearNonGenericDeviceByString ( "Gag", "Sanguine" )

		funct.SanguineRape( akSpeaker, kPlayer  , "Foreplay")
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
