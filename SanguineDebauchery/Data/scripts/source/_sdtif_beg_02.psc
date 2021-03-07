;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 5
Scriptname _sdtif_beg_02 Extends TopicInfo Hidden

; Helper function to calculate the actor strength
float Function GetActorStrengthPercentage(Actor akSubject, float Percentage = -1.0)
	If akSubject == None
		Return -1.0
	EndIf
	
	If Percentage <= 0
		Percentage = akSubject.GetActorValuePercentage("stamina")
	EndIf
	
;	float Strength = akSubject.GetMass() * Percentage
	ActorBase abSubject = akSubject.GetActorBase()
	float Strength = (akSubject.GetHeight() * akSubject.GetLength() * akSubject.GetWidth()) * (PapyrusUtil.ClampFloat(abSubject.GetWeight(), 1.0, 100.0) * 0.01) * Percentage
	
	If Strength < 0
		Strength = 0
	EndIf
	
	Return Strength
EndFunction

;BEGIN FRAGMENT Fragment_4
Function Fragment_4(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
	Actor kPlayer = _SDRAP_player.GetReference() as Actor

	if ( akSpeaker.GetRelationshipRank(kPlayer) >= 0 )
		SexLab.PlayerRef.AddItem(Gold, Utility.RandomInt(1, ((akSpeaker.GetAV("Confidence") as Int) + (akSpeaker.GetAV("Morality") as Int) ) * (akSpeaker.GetAV("Assistance") as Int) ), false)
	EndIf

	If (Utility.RandomInt(0,100)>60)
		Game.ForceThirdPerson()
		; Debug.SendAnimationEvent(Game.GetPlayer() as ObjectReference, "bleedOutStart")
		float AttackerStrengthPercentage = GetActorStrengthPercentage(akSpeaker)
		int AttackerStamina = akSpeaker.GetActorValue("stamina") as int
		float VictimStrengthPercentage = GetActorStrengthPercentage(kPlayer)
		int VictimStamina = kPlayer.GetActorValue("stamina") as int
		float AttackerStrength = AttackerStamina * AttackerStrengthPercentage
		float VictimStrength = VictimStamina * VictimStrengthPercentage
		Int IButton = 0

		If AttackerStrength < VictimStrength
			IButton = _SD_rapeMenu.Show()
		EndIf

		If IButton == 0 ; Show the thing.
			funct.SanguineRape( akSpeaker, SexLab.PlayerRef, "Aggressive")
		Else
			If AttackerStamina > VictimStamina
				AttackerStamina = VictimStamina
			EndIf
			SexLab.ActorLib.StripActor( SexLab.PlayerRef, DoAnimate= false, LeadIn = true)
			akSpeaker.DamageActorValue("stamina",AttackerStamina) 
			kPlayer.DamageActorValue("stamina",AttackerStamina)
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
