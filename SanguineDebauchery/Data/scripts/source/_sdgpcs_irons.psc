Scriptname _SDGPCS_irons extends ObjectReference  

Quest Property _SDQP_dreamer  Auto  

Event OnActivate(ObjectReference akActionRef)
	_SDQS_dream dream = _SDQP_dreamer as _SDQS_dream

	if (_SDQP_dreamer.GetStageDone(220)==1)
       dream.sendDreamerBack( 99 )
    else
    	Debug.MessageBox("The chain is rusted and seems stuck in place...")
    endif
EndEvent
