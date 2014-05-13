Scriptname _SDQS_watcher extends Quest  

_SD_ConfigMenu Property kConfig  Auto  

Quest Property DA14start  Auto
Quest Property DA14  Auto

Event OnInit()
	RegisterForSingleUpdate( 2.0 )
	GoToState("waiting")
EndEvent

State waiting
	Event OnUpdate()
		If ( self.IsRunning() )
			GoToState("monitor")
		EndIf
		RegisterForSingleUpdate( 2.0 )
	EndEvent
EndState

State monitor
	Event OnUpdate()
		If ( self.IsStopping() || self.IsStopped() )
			GoToState("waiting")
			RegisterForSingleUpdate( 2.0 )
			Return
		EndIf
		
		Bool bDA14Okay = ( DA14.IsCompleted() || DA14.IsRunning() || DA14start.IsCompleted() || DA14start.IsStageDone(70) )

		If ( bDA14Okay && !kConfig._SDBP_quests_primary_running[1] && !kConfig._SDBP_quests_primary_running[2])
			kConfig._SDBP_quests_primary_running[1] = True
			kConfig._SDQP_quests_primary[1].Start()
			kConfig._SDBP_quests_primary_running[2] = True
			kConfig._SDQP_quests_primary[2].Start()
		EndIf

		RegisterForSingleUpdate( 2.0 )
	EndEvent
EndState
