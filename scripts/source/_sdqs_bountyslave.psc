Scriptname _SDQS_bountyslave extends Quest  

_SDQS_enslavement Property enslave Auto

ReferenceAlias Property _SDRAP_master  Auto  
ReferenceAlias Property _SDRAP_slave  Auto  

Actor kMaster
Actor kSlave

Float fRegForUpdate = 10.0

Event OnInit()
	Debug.Trace("_SDQS_bountyslave.OnInit()")
	If ( Self )
		RegisterForSingleUpdate( fRegForUpdate )
	EndIf
	GoToState("waiting")
EndEvent

State waiting
	Event OnBeginState()
		Debug.Trace("_SDQS_bountyslave.OnBeginState() - waiting")
	EndEvent

	Event OnUpdate()
		If ( Self.IsRunning() )
			GoToState("monitor")
		EndIf
		If ( Self )
			RegisterForSingleUpdate( fRegForUpdate )
		EndIf
	EndEvent
EndState

State monitor
	Event OnBeginState()
		Debug.Trace("_SDQS_bountyslave.OnBeginState() - monitor")
		kMaster = _SDRAP_master.GetReference() as Actor
		kSlave = _SDRAP_slave.GetReference() as Actor
	EndEvent

	Event OnUpdate()
		If ( Self.IsStopping() || Self.IsStopped() || !Self.IsRunning() )
			GoToState("waiting")
			Return
		EndIf
		If ( !Game.IsMovementControlsEnabled() || kMaster.GetCurrentScene() )
			If ( Self )
				RegisterForSingleUpdate( fRegForUpdate )
			EndIf
			Return
		EndIf
		
		If ( Self )
			RegisterForSingleUpdate( fRegForUpdate )
		EndIf
	EndEvent
EndState

