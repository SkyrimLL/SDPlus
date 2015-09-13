Scriptname _SDRAS_sexlight extends ReferenceAlias  

ReferenceAlias Property _SDRAP_female  Auto  
ReferenceAlias Property _SDRAP_light  Auto  

Actor kFemale
ObjectReference kLight

Float fOffsetX = 100.0
Float fShiftX  = 0.0
Float fRotateZ = 0.0

Float pX
Float pY
Float pZ
Float aX
Float aY
Float aZ
Float oX
Float oY
Float oZ

Function rePosition()
	fRotateZ = (( fRotateZ + 1.0 ) as Int % 360 ) as Float
	fShiftX  = Utility.RandomFloat(-2.0, 2.0)

	pX = kFemale.X
	pY = kFemale.Y
	pZ = kFemale.Z
	aX = kFemale.GetAngleX()
	aY = kFemale.GetAngleY()
	aZ = kFemale.GetAngleZ() + fRotateZ
	oX = ( fOffsetX + fShiftX ) * Math.sin( aZ )
	oY = ( fOffsetX + fShiftX ) * Math.cos( aZ )
	oZ = ( kFemale as ObjectReference ).GetHeight() / 2.0
	pX += oX
	pY += oY
	pZ += oZ
EndFunction

Event OnCellAttach()
	GoToState("monitor")
	RegisterForSingleUpdate( 0.1 )
EndEvent

State monitor
	Event OnBeginState()
		kFemale = _SDRAP_female.GetReference() as Actor
		kLight = _SDRAP_light.GetReference() as ObjectReference
		rePosition()
	EndEvent
	
	Event OnTranslationComplete()
		rePosition()
		If ( Self && Self.GetOwningQuest() )
			RegisterForSingleUpdate( 0.1 )
		EndIf
	EndEvent

	Event OnTranslationFailed()
		rePosition()
		kLight.MoveTo( kFemale, oX, oY, pZ )
		If ( Self && Self.GetOwningQuest() )
			RegisterForSingleUpdate( 0.1 )
		EndIf
	EndEvent

	Event OnUpdate()
		If ( kFemale && kLight )
			kLight.SplineTranslateTo(oX, oY, pZ, kFemale.GetAngleX(), kFemale.GetAngleY(), kFemale.GetAngleZ(), 50.0, 150.0 )
		Else
			RegisterForSingleUpdate( 0.1 )
		EndIf
	EndEvent
EndState
