Scriptname _SDAS_reequip extends ObjectReference

Quest Property _SDQP_assoc_quest  Auto  
Int Property _SDIP_assoc_stage = 0 Auto  

Event OnUnequipped(Actor akActor)
	If ( False && Self && (_SDQP_assoc_quest.GetStage() > 0) && (_SDQP_assoc_quest.GetStage() <= _SDIP_assoc_stage) && _SDQP_assoc_quest.IsRunning() )
		akActor.EquipItem( Self.GetBaseObject() as Armor, True, True )
	EndIf
EndEvent

Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
	If ( akOldContainer && !akNewContainer )
		Self.DeleteWhenAble()
	EndIf
EndEvent
