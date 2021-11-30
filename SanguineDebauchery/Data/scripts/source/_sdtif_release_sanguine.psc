;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _sdtif_release_sanguine Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Actor kPlayer = Game.GetPlayer()

fctOutfit.clearDeviceByString( sDeviceString = "WristRestraint" , sOutfitString = "" )
fctOutfit.clearDeviceByString( sDeviceString = "ArmCuffs" , sOutfitString = "" )
fctOutfit.clearDeviceByString( sDeviceString = "LegCuffs" , sOutfitString = "" )
fctOutfit.clearDeviceByString( sDeviceString = "Blindfold" , sOutfitString = "" )
fctOutfit.clearDeviceByString( sDeviceString = "Hood" , sOutfitString = "" )
fctOutfit.clearDeviceByString( sDeviceString = "Gag" , sOutfitString = "" )
fctOutfit.clearDeviceByString( sDeviceString = "Yoke" , sOutfitString = "" )
fctOutfit.clearDeviceByString( sDeviceString = "Gloves" , sOutfitString = "" )
fctOutfit.clearDeviceByString( sDeviceString = "PiercingVaginal" , sOutfitString = "" )
fctOutfit.clearDeviceByString( sDeviceString = "Belt" , sOutfitString = "" )
fctOutfit.clearDeviceByString( sDeviceString = "Corset" , sOutfitString = "" )
fctOutfit.clearDeviceByString( sDeviceString = "Harness" , sOutfitString = "" )
fctOutfit.clearDeviceByString( sDeviceString = "Boots" , sOutfitString = "" )
        
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
