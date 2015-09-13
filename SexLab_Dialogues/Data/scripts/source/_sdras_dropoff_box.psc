Scriptname _SDRAS_dropoff_box extends ReferenceAlias  

ReferenceAlias Property _SDRAP_slave  Auto  

; Event OnOpen(ObjectReference akActionRef)
Event OnActivate(ObjectReference akActionRef)
	If (akActionRef == _SDRAP_slave.GetReference() as ObjectReference)
		Self.GetOwningQuest().Stop()
	EndIf
EndEvent

Event OnOpen(ObjectReference akActionRef)
	If (akActionRef == _SDRAP_slave.GetReference() as ObjectReference)
		Self.GetOwningQuest().Stop()
	EndIf
EndEvent
