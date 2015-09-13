Scriptname _SDQS_thugslave extends Quest

Import Utility

ReferenceAlias Property _SDRAP_master  Auto
ReferenceAlias Property _SDRAP_slave  Auto
ReferenceAlias Property _SDRAP_thug_1  Auto
ReferenceAlias Property _SDRAP_thug_2  Auto

Actor kMaster
Actor kSlave
Actor kThug_1
Actor kThug_2

Float fRegForUpdate = 30.0

Event OnStoryScript(Keyword akKeyword, Location akLocation, ObjectReference akRef1, ObjectReference akRef2, int aiValue1, int aiValue2)
	kMaster = _SDRAP_master.GetReference() as Actor
	kSlave  = _SDRAP_slave.GetReference() as Actor
	kThug_1 = _SDRAP_thug_1.GetReference() as Actor
	kThug_2 = _SDRAP_thug_2.GetReference() as Actor

	If ( kMaster )
		kMaster.StopCombat()
		kMaster.SetRelationshipRank(kSlave, -4)
	EndIf
	If ( kThug_1 )
		kThug_1.StopCombat()
		kThug_1.SetRelationshipRank(kSlave, -4)
	EndIf
	If ( kThug_2 )
		kThug_2.StopCombat()
		kThug_2.SetRelationshipRank(kSlave, -4)
	EndIf

	If ( Self )
		RegisterForSingleUpdate( fRegForUpdate )
	EndIf
EndEvent

Auto State monitor
	Event OnUpdate()
		If ( kMaster )
			kMaster.EvaluatePackage()
		EndIf
		If ( kThug_1 )
			kThug_1.EvaluatePackage()
		EndIf
		If ( kThug_2 )
			kThug_2.EvaluatePackage()
		EndIf
		
		If ( Self )
			RegisterForSingleUpdate( fRegForUpdate )
		EndIf
	EndEvent
EndState

