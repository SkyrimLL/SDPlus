;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 5
Scriptname _sdtif_beg_03 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_4
Function Fragment_4(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Actor kPlayer = _SDRAP_player.GetReference() as Actor

if ( akSpeaker.GetRelationshipRank(kPlayer) >= 0 )
	SexLab.PlayerRef.AddItem(Gold, Utility.RandomInt(1, ((akSpeaker.GetAV("Confidence") as Int) + (akSpeaker.GetAV("Morality") as Int) ) * (akSpeaker.GetAV("Assistance") as Int) ), false)
EndIf

If   (Utility.RandomInt(0,100)>90)
	Game.ForceThirdPerson()
	Debug.SendAnimationEvent(Game.GetPlayer() as ObjectReference, "bleedOutStart")

	Int IButton = _SD_rapeMenu.Show()

	If IButton == 0 ; Show the thing.
		funct.SanguineRape( akSpeaker, SexLab.PlayerRef, "Aggressive")
	Else
		SexLab.ActorLib.StripActor( SexLab.PlayerRef, DoAnimate= false)
	EndIf
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

_SDQS_functions Property funct  Auto

FormList Property _SDFLP_sex_items  Auto
FormList Property _SDFLP_punish_items  Auto
Spell Property _SDSP_freedom  Auto  
ReferenceAlias Property _SDRAP_player  Auto  

SexLabFramework Property SexLab  Auto  

MiscObject Property Gold  Auto  

Message Property _SD_rapeMenu  Auto  
