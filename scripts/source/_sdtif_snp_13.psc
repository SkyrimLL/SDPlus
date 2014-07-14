;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _sdtif_snp_13 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Actor slave = _SDRAP_slave.GetReference() as Actor
Actor master = _SDRAP_master.GetReference() as Actor
Int count = slave.GetItemCount( _SDAP_gag )
Int demerits = _SDGVP_demerits.GetValue() as Int
ObjectReference kMaster=_SDRAP_master.GetReference() as ObjectReference
ObjectReference kSlave=_SDRAP_slave.GetReference() as ObjectReference
Int randomVar = Utility.RandomInt( 0, 100 ) 

Self.GetOwningQuest().ModObjectiveGlobal( Utility.RandomInt( 1, 5 ), _SDGVP_demerits, 3, _SDGVP_demerits_join.GetValue() as Float, False, True, _SDGVP_config_verboseMerits.GetValueInt() as Bool )
enslave.UpdateSlaveState( master, slave )

If (randomVar >= (50 - demerits)  ) ; Straining positions
	Debug.Notification( "You will pay for that!" )

	; Punishment
	; _SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 3, aiValue2 = Utility.RandomInt( 0, _SDGVP_punishments.GetValueInt() ) )
	
	; Whipping
	_SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 5 )

ElseIf ((randomVar >=  (30 - demerits))) ; Dance
	Debug.Notification( "Your captor force you to dance" )

	; Start unresistible dance

	_SDKP_sex.SendStoryEvent(akLoc = kSlave.GetCurrentLocation(), akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 7, aiValue2 = 1 + Utility.RandomInt( 0, _SDGVP_dances.GetValueInt() ) )

ElseIf ((randomVar >  (20 - demerits))) ; Force feed skooma
	Debug.Notification( "Your mouth is held open as you are forced to swallow" )
	randomVar = Utility.RandomInt( 0, 10 ) 

	If (randomVar >= 5  )
		slave.AddItem( Skooma, 1, True )
	ElseIf (randomVar < 3  )
		slave.AddItem( FoodSolitudeSpicedWine, 2, True )
	ElseIf (randomVar == 4 )
		slave.AddItem( Ale, 5, True )
	EndIf

	While ( Utility.IsInMenuMode() )
	EndWhile
Else
	 _SDKP_sex.SendStoryEvent( \
		akRef1 = _SDRAP_master.GetReference() as ObjectReference, \
		akRef2 = _SDRAP_slave.GetReference() as ObjectReference, \
		aiValue1 = 0, \
		aiValue2 = Utility.RandomInt( 0, _SDGVP_positions.GetValueInt() )  )

EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ReferenceAlias Property _SDRAP_master  Auto  
ReferenceAlias Property _SDRAP_slave  Auto  
Keyword Property _SDKP_sex  Auto  
GlobalVariable Property _SDGVP_positions  Auto  
GlobalVariable Property _SDGVP_demerits  Auto  
GlobalVariable Property _SDGVP_demerits_join  Auto  
GlobalVariable Property _SDGVP_config_verboseMerits  Auto

GlobalVariable Property _SDGVP_dances  Auto
GlobalVariable Property _SDGVP_punishments  Auto 
Potion Property Skooma  Auto  
Potion Property FoodSolitudeSpicedWine  Auto  
Potion Property Ale  Auto  

Armor Property _SDAP_gag  Auto  
SexLabFramework property SexLab auto

_SDQS_enslavement Property enslave  Auto  
