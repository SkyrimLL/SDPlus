;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 5
Scriptname _sdtif_release_02 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_4
Function Fragment_4(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Actor kPlayer = _SDRAP_player.GetReference() as Actor
 


If   (Utility.RandomInt(0,100)>60)
	_SDSP_freedom.RemoteCast( kPlayer, kPlayer, kPlayer )

	fctOutfit.clearDeviceByString( sDeviceString = "WristRestraint" )
	fctOutfit.clearDeviceByString( sDeviceString = "ArmCuffs" )
	fctOutfit.clearDeviceByString( sDeviceString = "LegCuffs" )
	fctOutfit.clearDeviceByString( sDeviceString = "Gag" )
	fctOutfit.clearDeviceByString( sDeviceString = "Blindfold" )

	funct.SanguineRape( akSpeaker, kPlayer , "Aggressive")
Else
	Debug.Notification("You are mine now...")

	; StorageUtil.SetFormValue( Game.getPlayer() , "_SD_TempAggressor", akSpeaker)
	StorageUtil.SetIntValue(akSpeaker, "_SD_iForcedSlavery", 0)

	akSpeaker.SendModEvent("PCSubEnslave")
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

_SDQS_functions Property funct  Auto
_SDQS_fcts_outfit Property fctOutfit  Auto

FormList Property _SDFLP_sex_items  Auto
FormList Property _SDFLP_punish_items  Auto
Spell Property _SDSP_freedom  Auto  

GlobalVariable Property _SDGVP_buyoutEarned  Auto  
GlobalVariable Property _SDGVP_demerits  Auto  
Keyword Property _SDKP_enslave  Auto  
ReferenceAlias Property _SDRAP_player  Auto  

Keyword Property _SDKP_sex  Auto  
