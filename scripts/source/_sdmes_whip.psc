Scriptname _SDMES_whip extends activemagiceffect  
{ USED }
Topic Property _SDTP_sayOnHit  Auto  

Event OnEffectStart(Actor akTarget, Actor akCaster)

	If akTarget.GetCurrentScene() == None
		akTarget.Say(_SDTP_sayOnHit)
	EndIf

EndEvent
