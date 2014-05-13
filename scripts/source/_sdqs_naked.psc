Scriptname _SDQS_naked extends Quest  

GlobalVariable Property _SDGVP_naked_rape_delay Auto
GlobalVariable Property GameDaysPassed Auto

float fNext = 0.0
float fNextAllowed = 0.02

Function Commented()
	fNext = GameDaysPassed.GetValue() + fNextAllowed + Utility.RandomFloat( 0.125, 0.25 )
	_SDGVP_naked_rape_delay.SetValue( fNext )
EndFunction


Function SanguineRape(Actor akSpeaker, Actor akTarget, String SexLabInTags = "Aggressive", String SexLabOutTags = "Solo")

	akTarget = Game.GetPlayer()
	
	if (akTarget.IsOnMount())
		return
	EndIf

	while ( Utility.IsInMenuMode() )
		Utility.Wait( 1.0 )
	endWhile

	Game.ForceThirdPerson()
	Debug.SendAnimationEvent(akTarget as ObjectReference, "bleedOutStart")

	Int IButton = _SD_rapeMenu.Show()

	If IButton == 0 ; Show the thing.

		; Debug.Messagebox("An overwhelming craving stops you in your tracks and feeds the lust of your aggressor.")
		; Utility.Wait(2)
		funct.SanguineRape(akSpeaker, akTarget,SexLabInTags,SexLabOutTags )
	EndIf
	
EndFunction

_SDQS_functions Property funct  Auto
Message Property _SD_rapeMenu Auto
