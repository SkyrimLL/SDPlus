Scriptname _SDMES_daedric_fire extends activemagiceffect  

Light Property _SDLP_lightcampfire  Auto  

Actor kTarget
Actor kCaster

Float fX					;: Position along the X axis.
Float fY					;: Position along the Y axis.
Float fZ					;: Position along the Z axis.
Float fAngleX				;: Destination X Angle.
Float fAngleY				;: Destination Y Angle (rarely used).
Float fAngleZ				;: Destination Z Angle.
Float fTangentMagnitude	;: Magnitude of the spline tangents
Float fSpeed				;: Movement Speed.
Float fMaxRotationSpeed	;: The maximum rotation speed (Default is 0 to mean "don't clamp rotation speed")

Float fXFlip
Float fYFlip
Float fZFlip
Float fXRot
Float fYRot
Float fZRot

Function setTranslateToPosition()
	fXFlip = Utility.RandomInt(-1,1) * 100 as Float
	fYFlip = Utility.RandomInt(-1,1) * 100 as Float
	fZFlip = ( Utility.RandomInt(-1,1) * 50 ) + 100 as Float
	fXRot = Utility.RandomFloat( -20.0, 20.0 )
	fYRot = Utility.RandomFloat( -20.0, 20.0 )
	fZRot = Utility.RandomFloat( -20.0, 20.0 )

	fX = kCaster.GetPositionX() + fXFlip
	fY = kCaster.GetPositionY() + fYFlip
	fZ = kCaster.GetPositionY() + fZFlip
	fAngleX = kCaster.GetAngleX() + fXRot
	fAngleY = kCaster.GetAngleY() + fYRot
	fAngleZ = kCaster.GetAngleZ() + fZRot
	fTangentMagnitude = 0.25
	fSpeed = 30.0
	fMaxRotationSpeed = 0.0
EndFunction

Event OnTranslationComplete()
	setTranslateToPosition()
	RegisterForSingleUpdate( 0.1 )
EndEvent

Event OnTranslationFailed()

EndEvent

Event OnUpdate()
	; ( _SDLP_lightcampfire as ObjectReference ).SplineTranslateTo( fX, fY, fZ, fAngleX, fAngleY, fAngleZ, fTangentMagnitude, fSpeed, fMaxRotationSpeed )
EndEvent

Event OnEffectStart(Actor akTarget, Actor akCaster)
	kTarget = akTarget
	kCaster = akCaster
	setTranslateToPosition()
	RegisterForSingleUpdate( 0.1 )
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	UnregisterForUpdate()
	; _SDLP_lightcampfire.DeleteWhenAble()
EndEvent
