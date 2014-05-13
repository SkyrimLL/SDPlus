Scriptname _SDRAS_cage extends ReferenceAlias  

ReferenceAlias Property _SDRAP_masters_key  Auto
GlobalVariable Property _SDGVP_demerits  Auto  
GlobalVariable Property _SDGVP_demerits_join  Auto  
GlobalVariable Property _SDGVP_config_verboseMerits  Auto
GlobalVariable Property _SDGVP_state_caged  Auto  

Event OnLoad()
	Self.GetReference().SetLockLevel( Game.GetPlayer().GetBaseAV("Lockpicking") as Int )
EndEvent

Event OnActivate(ObjectReference akActionRef)
	Debug.Trace( "_SD:cage activate attempt " + akActionRef )
	ObjectReference cage = Self.GetReference() as ObjectReference
	If ( akActionRef.GetItemCount( _SDRAP_masters_key.GetReference() ) )
		If ( cage.IsLocked() )
			cage.Lock( False )
		EndIf
		cage.SetOpen()
		Self.GetOwningQuest().ModObjectiveGlobal( 1.0, _SDGVP_demerits, 3, _SDGVP_demerits_join.GetValue() as Float, False, True, _SDGVP_config_verboseMerits.GetValueInt() as Bool )
	EndIf
EndEvent

Event OnOpen(ObjectReference akActionRef)
	_SDGVP_state_caged.SetValue( 0 )
EndEvent

Event OnClose(ObjectReference akActionRef)
	_SDGVP_state_caged.SetValue( 1 )
EndEvent
