Scriptname _SDQS_arrested extends Quest  

Quest Property _SDQP_enslavement  Auto  

Event OnStoryArrest(ObjectReference akArrestingGuard, ObjectReference akCriminal, Location akLocation, int aiCrime)
	;_SDQP_enslavement.Stop()
	SendModEvent("PCSubFree")
	Stop()
	Reset()	
EndEvent




