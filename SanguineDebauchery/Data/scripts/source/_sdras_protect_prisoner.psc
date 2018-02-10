Scriptname _SDRAS_protect_prisoner extends ReferenceAlias  

_SDQS_enslavement Property enslavement  Auto

ReferenceAlias[] Property _SDRAP_protecters  Auto  

ReferenceAlias Property _SDRAP_boss  Auto
ReferenceAlias Property _SDRAP_slave  Auto
ReferenceAlias Property _SDRAP_master  Auto

Keyword Property _SDKP_sex  Auto  

Bool bProtectorsLOS = False
Bool bAutoPilot = False
Actor kBoss = None
Actor kSlave = None
Actor kMaster = None
Actor kSelf = None
Float fRFSU = 0.1

Function checkWatchers()
	If ( !kSlave.GetCurrentScene() ) && (kMaster) && (kSlave)
		bProtectorsLOS = False
		Int idx = _SDRAP_protecters.Length
		While ( idx > 0 && !bProtectorsLOS )
			idx -= 1
			if ( _SDRAP_protecters[idx].GetReference() as Actor )
				bProtectorsLOS = ( _SDRAP_protecters[idx].GetReference() as Actor ).HasLOS( kSlave )
			EndIf
		EndWhile

		If ( bProtectorsLOS && !kSlave.HasLOS( kMaster ) )
		;	_SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 1)
		EndIf
	EndIf
EndFunction

Event OnInit()
	kBoss = _SDRAP_boss.GetReference() as Actor
	kSlave = _SDRAP_slave.GetReference() as Actor
	kMaster = _SDRAP_master.GetReference() as Actor
	kSelf = Self.GetReference() as Actor
	
	If ( kSelf == kSlave ) && (kMaster) && (kSlave)
		RegisterForLOS(kSlave, kBoss)
		RegisterForLOS(kSlave, kMaster)
		RegisterForSingleUpdate( fRFSU )
	EndIf
EndEvent

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
	Actor kActor

	If (akAggressor) && (StorageUtil.GetIntValue(Game.GetPlayer(), "_SD_iEnslaved")==1)
		If ( ( akAggressor as Actor ).IsHostileToActor( kSelf ) && Self.GetOwningQuest().GetStage() < 30 )
			Int idx = _SDRAP_protecters.Length
			While ( idx > 0 )
				idx -= 1
				kActor = _SDRAP_protecters[idx].GetReference() as Actor
				if ( kActor ) && (!kActor.IsDead())
					kActor.StartCombat( akAggressor as Actor )
				EndIf
			EndWhile
		EndIf
	EndIf
EndEvent

Event OnCellLoad()
	If ( Self.GetOwningQuest().GetStage() == 0 && kSlave.GetParentCell() == kBoss.GetParentCell() )
		Self.GetOwningQuest().SetStage(10)
	EndIf
EndEvent

Event OnGainLOS(Actor akViewer, ObjectReference akTarget)
	If (akViewer) && (akTarget) && (kBoss)
		If ( akViewer != kSlave && akTarget == kBoss && Self.GetOwningQuest().GetStage() == 0 )
			Self.GetOwningQuest().SetStage(10)
		EndIf
	EndIf
EndEvent

Event OnLostLOS(Actor akViewer, ObjectReference akTarget)
	If (akViewer) && (akTarget) && (kBoss)
		If ( akViewer != kSlave && akTarget == kMaster && Self.GetOwningQuest().GetStage() == 0 )
			checkWatchers()
		EndIf
	EndIf
EndEvent

Event OnUpdate()
	If ( kSlave && kBoss  )
		If ( Self.GetOwningQuest().GetStage() == 0 && kSlave.GetParentCell() == kBoss.GetParentCell() )
			Self.GetOwningQuest().SetStage(10)
		EndIf
		checkWatchers()
	EndIf

	If ( Self.GetOwningQuest().GetStage() == 0 )
		RegisterForSingleUpdate( fRFSU )
	EndIf
EndEvent
