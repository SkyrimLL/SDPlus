;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname _SDTIF_help03 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_1
Function Fragment_1(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
While ( Utility.IsInMenuMode() )
EndWhile

Actor kPlayer = _SDRAP_player.GetReference() as Actor

SendModEvent("PCSubFree")
_SDSP_freedom.RemoteCast( SexLab.PlayerRef , SexLab.PlayerRef , SexLab.PlayerRef )

funct.SanguineRape( akSpeaker, SexLab.PlayerRef , "Sex")
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

SexLabFramework Property SexLab  Auto  
_SDQS_functions Property funct  Auto

FormList Property _SDFLP_sex_items  Auto
FormList Property _SDFLP_punish_items  Auto
Spell Property _SDSP_freedom  Auto  
ReferenceAlias Property _SDRAP_player  Auto  
