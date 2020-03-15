Scriptname _sdmes_falmerglowlight extends activemagiceffect  



Event OnEffectStart(Actor akTarget, Actor akCaster)
		akCaster.SendModEvent("SLPFalmerBlue")
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)

EndEvent