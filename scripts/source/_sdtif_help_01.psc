;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _sdtif_help_01 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Actor akPlayer = SexLab.PlayerRef 

While ( Utility.IsInMenuMode() )
EndWhile

	StorageUtil.SetFormValue( Game.getPlayer() , "_SD_TempAggressor", akSpeaker)
	StorageUtil.SetIntValue(akSpeaker, "_SD_iForcedSlavery", 0)

SendModEvent("PCSubTransfer")
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Keyword Property _SDKP_sex  Auto  

GlobalVariable Property _SDGVP_positions  Auto  

SexLabFramework Property SexLab  Auto  
_SDQS_functions Property funct  Auto

GlobalVariable Property _SDGVP_demerits Auto
GlobalVariable Property _SDGVP_enslaved Auto
GlobalVariable Property _SDGV_leash_length Auto
Keyword Property _SDKP_bound Auto
Keyword Property _SDKP_enslave Auto
FormList Property _SDFLP_sex_items Auto
FormList Property _SDFLP_punish_items Auto
FormList Property _SDFLP_master_items Auto

Quest Property _SDQP_enslavement  Auto  
