Scriptname _sdqs_master_hunt extends Quest  

ObjectReference kRef1
ObjectReference kRef2



Event OnStoryScript(Keyword akKeyword, Location akLocation, ObjectReference akRef1, ObjectReference akRef2, int aiValue1, int aiValue2)

;

	If ( Self )
		RegisterForSingleUpdateGameTime( 0.125 )
		RegisterForSingleUpdate( 0.1 )
	EndIf

EndEvent

Event OnUpdateGameTime()
;
	If (kRef1 as Actor).IsDead()
		Self.SetStage(20)
		Self.Stop()
	EndIf

	If ( _SDGVP_enslaved.GetValue() == 1)
		Self.SetStage(10)
		Self.Stop()
	EndIf

	If ( Self &&  !(kRef1 as Actor).IsDead())
		RegisterForSingleUpdateGameTime( 0.25 )
	EndIf
EndEvent

Event OnUpdate()
	if (kRef2)
		While ( !kRef2.Is3DLoaded() )
		EndWhile

	EndIf

	If ( Self )
		RegisterForSingleUpdate( 0.1 )
	EndIf
EndEvent

GlobalVariable Property _SDGVP_enslaved  Auto  
