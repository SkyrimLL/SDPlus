Scriptname _SDMES_gaged extends activemagiceffect  

_SDQS_functions Property funct  Auto

Actor kTarget
Shout kShout
Spell kSpell

Int iSource

Event OnUpdate()
	kTarget.SetExpressionOverride( 16, 100 )

	kShout = kTarget.GetEquippedShout()
	If ( kShout )
		kTarget.UnequipShout( kShout )
	EndIf

	iSource = 0
	While ( iSource <= 3 )
		kSpell = kTarget.GetEquippedSpell( iSource )
		If ( kSpell )
			kTarget.UnequipSpell( kSpell, iSource )
		EndIf
		iSource += 1
	EndWhile

	If ( Self )
		RegisterForSingleUpdate( 0.1 )
	EndIf
EndEvent

Event OnEffectStart(Actor akTarget, Actor akCaster)
	kTarget = akTarget
	kTarget.SetExpressionOverride( 16, 100 )
	If ( Self )
		RegisterForSingleUpdate( 0.1 )
	EndIf
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	akTarget.ClearExpressionOverride()
EndEvent
