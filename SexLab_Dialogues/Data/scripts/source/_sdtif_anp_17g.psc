;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _sdtif_anp_17g Extends TopicInfo Hidden

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
 
If (randomVar >= 9  ) ; Change appearance
	Debug.Notification( "ilok bak." )
;	Self.GetOwningQuest().ModObjectiveGlobal( -1.0, _SDGVP_demerits, 3, _SDGVP_demerits_join.GetValue() as Float, False, True, _SDGVP_config_verboseMerits.GetValueInt() as Bool )
	Utility.Wait(0.5)

	Int IButton = _SD_racemenu.Show()

	If IButton == 0  ; Show the thing.
		Game.ShowLimitedRaceMenu()
	EndIf

	Utility.Wait(1.0)

ElseIf (randomVar > 6  ) ; Surprise punishment
	Debug.Notification( "na buroi nok" )
;	Self.GetOwningQuest().ModObjectiveGlobal( 5.0, _SDGVP_demerits, 3, _SDGVP_demerits_join.GetValue() as Float, False, True, _SDGVP_config_verboseMerits.GetValueInt() as Bool )

;	If ( demerits <= 0 )
;		slave.UnequipItem( _SDAP_gag, False, True )
;		slave.RemoveItem( _SDAP_gag, count, True )
;	EndIf

	; Punishment
	; _SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 3, aiValue2 = Utility.RandomInt( 0, _SDGVP_punishments.GetValueInt() ) )
	
	; Whipping
	_SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 5 )

Else ; Just sex
	Debug.Notification( "(lustful groan)" )

             GlowLight.Cast(SexLab.PlayerRef as Actor, SexLab.PlayerRef as Actor)
             Utility.Wait(3.0)
             Game.EnablePlayerControls( abMovement = True )
             Game.SetPlayerAIDriven( False )

;	Self.GetOwningQuest().ModObjectiveGlobal( 1.0, _SDGVP_demerits, 3, _SDGVP_demerits_join.GetValue() as Float, False, True, _SDGVP_config_verboseMerits.GetValueInt() as Bool )

;	If ( demerits <= 0 )
;		slave.UnequipItem( _SDAP_gag, False, True )
;		slave.RemoveItem( _SDAP_gag, count, True )
;	EndIf

  _SDKP_sex.SendStoryEvent( \
	akRef1 = _SDRAP_master.GetReference() as ObjectReference, \
	akRef2 = _SDRAP_slave.GetReference() as ObjectReference, \
 	aiValue1 = 0, \
 	aiValue2 = Utility.RandomInt( 0, _SDGVP_positions.GetValueInt() )  )

	; Aggressive sex
	If  (SexLab.ValidateActor( kMaster as actor ) > 0) &&  (SexLab.ValidateActor(kSlave as actor) > 0) 

		actor[] sexActors = new actor[2]
		sexActors[0] = kSlave as actor
		sexActors[1] = kMaster  as actor
		; sslBaseAnimation[] animations = SexLab.GetAnimationsByTag(2, "Aggressive")
		; SexLab.StartSex(sexActors, animations)

 
	EndIf



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
