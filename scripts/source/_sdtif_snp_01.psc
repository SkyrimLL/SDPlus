;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _sdtif_snp_01 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
;( passive ) What must I do to please you?
Actor slave = _SDRAP_slave.GetReference() as Actor
Actor master  = _SDRAP_master.GetReference() as Actor
Int count = slave.GetItemCount( _SDAP_gag )
Int demerits = _SDGVP_demerits.GetValueInt()

ObjectReference kMaster=_SDRAP_master.GetReference() as ObjectReference
ObjectReference kSlave=_SDRAP_slave.GetReference() as ObjectReference
Int randomVar = Utility.RandomInt( 0, 10 ) 
 
_SDGVP_sorry.SetValue(0)


If (randomVar >= 9  ) ; Change appearance
;	Self.GetOwningQuest().ModObjectiveGlobal( (1 - Utility.RandomInt(2, 6)), _SDGVP_demerits, 3, _SDGVP_demerits_join.GetValue() as Float, False, True, _SDGVP_config_verboseMerits.GetValueInt() as Bool )
	Debug.Notification( "I don't like the way you look..." )
	
	Utility.Wait(0.5)
	Int IButton = _SD_racemenu.Show()
	If IButton == 0  ; Show the thing.
		Game.ShowLimitedRaceMenu()
	EndIf
	Utility.Wait(1.0)

ElseIf (randomVar >= 7  ) ; Surprise punishment
	Debug.Notification( "Did you think I would fall for that?!" )
;	Self.GetOwningQuest().ModObjectiveGlobal( 2.0, _SDGVP_demerits, 3, _SDGVP_demerits_join.GetValue() as Float, False, True, _SDGVP_config_verboseMerits.GetValueInt() as Bool )

	If ( Utility.RandomInt( 0, 10) >= 5 )
		; Punishment
		_SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 3, aiValue2 = Utility.RandomInt( 0, _SDGVP_punishments.GetValueInt()) )
	Else
		; Whipping
		_SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 5 )
	EndIf
	

ElseIf (randomVar >= 5) ; Dance
	Debug.Notification( "I want you to dance for me, Slave!" )
	
;	Self.GetOwningQuest().ModObjectiveGlobal( -7.0, _SDGVP_demerits, 3, _SDGVP_demerits_join.GetValue() as Float, False, True, _SDGVP_config_verboseMerits.GetValueInt() as Bool )

	;; Start unresistible dance
	_SDKP_sex.SendStoryEvent(akLoc = kSlave.GetCurrentLocation(), akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 7, aiValue2 = 1 + Utility.RandomInt( 0, _SDGVP_dances.GetValueInt() ) )
Else ; Just sex
	Debug.Notification( "Your captor's smile sends shivers down your spine" )
;	Self.GetOwningQuest().ModObjectiveGlobal( (1 - Utility.RandomInt(2, 6)), _SDGVP_demerits, 3, _SDGVP_demerits_join.GetValue() as Float, False, True, _SDGVP_config_verboseMerits.GetValueInt() as Bool )

    _SDKP_sex.SendStoryEvent( akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 0, aiValue2 = Utility.RandomInt( 0, _SDGVP_positions.GetValueInt())  )

 

      Game.EnablePlayerControls( abMovement = True )
      Game.SetPlayerAIDriven( False )

EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ReferenceAlias Property _SDRAP_master  Auto  
ReferenceAlias Property _SDRAP_slave  Auto  
Keyword Property _SDKP_sex  Auto  
GlobalVariable Property _SDGVP_dances  Auto
GlobalVariable Property _SDGVP_punishments  Auto  
GlobalVariable Property _SDGVP_positions  Auto  
GlobalVariable Property _SDGVP_demerits  Auto  
GlobalVariable Property _SDGVP_demerits_join  Auto  
GlobalVariable Property _SDGVP_config_verboseMerits  Auto

Armor Property _SDAP_gag  Auto  
SexLabFramework property SexLab auto

Message Property _SD_racemenu  Auto  

GlobalVariable Property _SDGVP_sorry  Auto  
