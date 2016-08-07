;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _sdtif_groped_05 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
; Aggressive sex 
	If  (SexLab.ValidateActor( SexLab.PlayerRef as actor ) > 0) &&  (SexLab.ValidateActor( akSpeaker ) > 0) 

	;	funct.SanguineRape( akSpeaker, SexLab.PlayerRef as Actor , "Doggystyle")
		akSpeaker.SendModEvent("PCSubSex", "Doggystyle", 1.0 )
	EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Topic Property _SDTP_joined  Auto  

SexLabFramework Property SexLab  Auto  

SPELL Property GlowLight  Auto  

SPELL Property ChaurusSpit  Auto  
_SDQS_functions Property funct  Auto
