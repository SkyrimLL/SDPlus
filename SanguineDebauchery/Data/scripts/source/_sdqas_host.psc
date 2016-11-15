Scriptname _SDQAS_host extends ReferenceAlias  

LocationAlias Property _SDLAP_library  Auto  
ReferenceAlias Property _SDRAP_seed  Auto
Faction Property _SDFP_spriggan  Auto
Keyword Property _SDKP_sex  Auto

Sound Property _SDSMP_spriggananger  Auto  

Actor kHost
Actor kSeed
Actor kCombatTarget

Float fRFSU = 0.1

Event OnInit()
	; Do we need an update here? waiting state already has an update
	
	; If ( Self.GetOwningQuest() )
	; 	RegisterForSingleUpdate( fRFSU )
	; EndIf
	GoToState("waiting")
EndEvent

State waiting
	Event OnUpdate()
		If ( Self.GetOwningQuest().IsRunning() )
			GoToState("monitor")
		EndIf
		If ( Self.GetOwningQuest() )
			RegisterForSingleUpdate( fRFSU )
		EndIf
	EndEvent
EndState

State monitor
	Event OnBeginState()
		kHost = Self.GetReference() as Actor
		kSeed = _SDRAP_seed.GetReference() as Actor
	EndEvent
	
	Event OnLocationChange(Location akOldLoc, Location akNewLoc)
		If ( _SDLAP_library.GetLocation() == akNewLoc && Self.GetOwningQuest().GetStage() == 20 )
			Self.GetOwningQuest().SetObjectiveCompleted( 20 )
			Self.GetOwningQuest().SetObjectiveDisplayed( 30 )
			Self.GetOwningQuest().SetStage( 30 )
		EndIf
	EndEvent


	Event OnUpdate()
		kCombatTarget = kHost.GetCombatTarget()

		If ( kCombatTarget && kCombatTarget.IsInFaction( _SDFP_spriggan ) )
			Debug.Trace("[SD] Spriggan anger detected")
			_SDSMP_spriggananger.play( kHost )
			; _SDKP_sex.SendStoryEvent( akRef1 = kSeed, akRef2 = kHost, aiValue1 = 8, aiValue2 = Utility.RandomInt( 0, 6 ) )
		EndIf

		If ( Self.GetOwningQuest() )
			RegisterForSingleUpdate( fRFSU )
		EndIf
	EndEvent
EndState
