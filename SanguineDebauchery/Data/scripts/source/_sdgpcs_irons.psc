Scriptname _SDGPCS_irons extends ObjectReference  

Quest Property _SDQP_dreamer  Auto  

Event OnActivate(ObjectReference akActionRef)
	_SDQS_dream dream = _SDQP_dreamer as _SDQS_dream
       dream.sendDreamerBack( 99 )
EndEvent
