;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _sdtif_snp_01f Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
;( passive ) What must I do to please you?
Actor slave = _SDRAP_slave.GetReference() as Actor
Int count = slave.GetItemCount( _SDAP_gag )
Int demerits = _SDGVP_demerits.GetValueInt()

ObjectReference kMaster=_SDRAP_master.GetReference() as ObjectReference
ObjectReference kSlave=_SDRAP_slave.GetReference() as ObjectReference
Int randomVar = Utility.RandomInt( 0, 10 )
 
; 	Self.GetOwningQuest().ModObjectiveGlobal( (1 - Utility.RandomInt(2, 8)), _SDGVP_demerits, 3, _SDGVP_demerits_join.GetValue() as Float, False, True, _SDGVP_config_verboseMerits.GetValueInt() as Bool )
 	
If (randomVar >= 9  ) ; Change appearance for the stupid falmer
	Debug.Notification( "ilok bak" )
	
	Utility.Wait(0.5)
	Int IButton = _SD_racemenu.Show()
	If IButton == 0  ; Show the thing.
		Game.ShowLimitedRaceMenu()
	EndIf
	Utility.Wait(1.0)

ElseIf (randomVar == 7  ) ; Surprise punishment
	Debug.Notification( "na buroi nok... huhuhu !" )

	If (Utility.RandomInt( 0, 10 ) >= 5)
		; Punishment
		_SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 3, aiValue2 = Utility.RandomInt( 0, _SDGVP_punishments.GetValueInt()))	
	Else 
		; Whipping
		_SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 5 )
	EndIf
	
Else ; Just sex
	Debug.Notification( "(lustful groan)" )
  	GlowLight.Cast(SexLab.PlayerRef as Actor, SexLab.PlayerRef as Actor)
  	Utility.Wait(3.0)
 		_SDKP_sex.SendStoryEvent( akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 0, aiValue2 = Utility.RandomInt( 0, _SDGVP_positions.GetValueInt()) )
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

SPELL Property GlowLight  Auto  

Message Property _SD_racemenu  Auto  
