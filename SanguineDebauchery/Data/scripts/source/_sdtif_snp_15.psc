;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _sdtif_snp_15 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
;Are you looking for a fight?
Actor slave = _SDRAP_slave.GetReference() as Actor
Actor master = _SDRAP_master.GetReference() as Actor
Int count = slave.GetItemCount( _SDAP_gag )
Int demerits = _SDGVP_demerits.GetValue() as Int
ObjectReference kMaster=_SDRAP_master.GetReference() as ObjectReference
ObjectReference kSlave=_SDRAP_slave.GetReference() as ObjectReference
Int randomVar = Utility.RandomInt( 0, 100 ) 

; Self.GetOwningQuest().ModObjectiveGlobal( Utility.RandomInt( 5, 10 ), _SDGVP_demerits, 3, _SDGVP_demerits_join.GetValue() as Float, False, True, _SDGVP_config_verboseMerits.GetValueInt() as Bool )
enslave.UpdateSlaveState( master, slave )

If (randomVar >= 90  ) ; Change appearance
	Debug.Notification( "$I don't like the way you look..." )
;	Self.GetOwningQuest().ModObjectiveGlobal( -1.0, _SDGVP_demerits, 3, _SDGVP_demerits_join.GetValue() as Float, False, True, _SDGVP_config_verboseMerits.GetValueInt() as Bool )
	Utility.Wait(0.5)

	Int IButton = _SD_racemenu.Show()

	If IButton == 0  ; Show the thing.
		Game.ShowLimitedRaceMenu()
	EndIf

	Utility.Wait(1.0)

ElseIf (randomVar >= 60 ) ; Straining positions
	Debug.Notification( "$Here it comes, Slave!" )

	If ( Utility.RandomInt( 0, 10) >= 5 )
		; Punishment
		_SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 3, aiValue2 = Utility.RandomInt( 0, _SDGVP_punishments.GetValueInt() ) )
	Else
	; Whipping
	_SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 5 )
	EndIf

ElseIf ( randomVar >=  40 ) ; Dance
	Debug.Notification( "$You will dance for me, Slave!" )

	; Start irresistible dance
	_SDKP_sex.SendStoryEvent(akLoc = kSlave.GetCurrentLocation(), akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 7, aiValue2 = Utility.RandomInt(1, _SDGVP_dances.GetValueInt()) )
	
ElseIf ( randomVar >=  20 ) ; Force feed skooma
	Debug.Notification( "$Let's get some of this inside you..." )
	randomVar = Utility.RandomInt( 0, 10 ) 
	
	If (randomVar >= 5  )
		Debug.Notification( "$Umph... Skooma!" )
		slave.AddItem( Skooma, 1, True )
	ElseIf (randomVar <= 3  )
		Debug.Notification( "$Uhg... Wine!" )
		slave.AddItem( FoodSolitudeSpicedWine, 1, True )
	ElseIf (randomVar == 4 )
		Debug.Notification( "$Ale?" )
		slave.AddItem( Ale, 1, True )
	EndIf 
	 	SkoomaEffect.Cast(slave, slave)
	Utility.Wait(2.0)
	While ( Utility.IsInMenuMode() )
	EndWhile
	
	Debug.Notification( "$You start dancing for some reason..." )
	_SDKP_sex.SendStoryEvent(akLoc = kSlave.GetCurrentLocation(), akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 7, aiValue2 = Utility.RandomInt(1, _SDGVP_dances.GetValueInt()))	
Else
	 _SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 0, aiValue2 = Utility.RandomInt( 0, _SDGVP_positions.GetValueInt()))
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

_SDQS_enslavement Property enslave  Auto  
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
SPELL Property SkoomaEffect  Auto 
Armor Property _SDAP_gag  Auto  
SexLabFramework property SexLab auto

Message Property _SD_racemenu  Auto  
