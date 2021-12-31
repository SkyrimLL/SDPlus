Scriptname _SDGPCS_irons extends ObjectReference  

Quest Property _SDQP_dreamer  Auto  
GlobalVariable Property _SDGVP_config_dreamworldOnSleep Auto

Event OnActivate(ObjectReference akActionRef)
	_SDQS_dream dream = _SDQP_dreamer as _SDQS_dream

	; if (_SDQP_dreamer.GetStageDone(220)==1) || ((_SDGVP_config_dreamworldOnSleep.GetValue() as Int) == 0)
    If (StorageUtil.GetIntValue(dream, "_SD_iEnslaved") != 1)
       dream.sendDreamerBack( 99 )
    endif
    ; else
    ;	Debug.MessageBox("The chain is rusted and seems stuck in place...")
    ; endif
EndEvent
