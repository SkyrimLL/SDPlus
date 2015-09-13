Scriptname _SDMES_silenced extends activemagiceffect  


Event OnEffectStart(Actor akTarget, Actor akCaster)
	If ( akTarget != Game.GetPlayer() )
		akTarget.AllowPCDialogue( False )
	EndIf
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	If ( akTarget != Game.GetPlayer() )
		akTarget.AllowPCDialogue( True )
	EndIf
EndEvent
