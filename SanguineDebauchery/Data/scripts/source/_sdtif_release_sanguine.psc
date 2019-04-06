;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _sdtif_release_sanguine Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Actor kPlayer = Game.GetPlayer()

fctOutfit.clearDeviceByString( sDeviceString = "WristRestraint" )
fctOutfit.clearDeviceByString( sDeviceString = "ArmCuffs" )
fctOutfit.clearDeviceByString( sDeviceString = "LegCuffs" )
fctOutfit.clearDeviceByString( sDeviceString = "Blindfold" )
fctOutfit.clearDeviceByString( sDeviceString = "Hood" )
fctOutfit.clearDeviceByString( sDeviceString = "Gag" )
fctOutfit.clearDeviceByString( sDeviceString = "Yoke" )
fctOutfit.clearDeviceByString( sDeviceString = "Gloves" )
fctOutfit.clearDeviceByString( sDeviceString = "PiercingVaginal" )
fctOutfit.clearDeviceByString( sDeviceString = "Belt" )
fctOutfit.clearDeviceByString( sDeviceString = "Corset" )
fctOutfit.clearDeviceByString( sDeviceString = "Harness" )
fctOutfit.clearDeviceByString( sDeviceString = "Boots" )
        
fctOutfit.clearNonGenericDeviceByString ( "WristRestraints", "Sanguine" )
fctOutfit.clearNonGenericDeviceByString ( "Gag", "Sanguine" )

kPlayer.EquipItem(Mead, 1 )
akSpeaker.AddItem(Mead, 1 )
akSpeaker.EquipItem(Mead, 1 )
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
_SDQS_functions Property funct  Auto
_sdqs_fcts_outfit Property fctOutfit  Auto  
 
ReferenceAlias Property _SDRAP_player  Auto  

Potion Property Mead Auto
