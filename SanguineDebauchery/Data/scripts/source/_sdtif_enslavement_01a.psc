;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname _sdtif_enslavement_01a Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_1
Function Fragment_1(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
ObjectReference kSlave=_SDRAP_slave.GetReference() as ObjectReference
ObjectReference kMaster=_SDRAP_master.GetReference() as ObjectReference
Int randomVar = Utility.RandomInt( 0, 10 ) 

;Self.GetOwningQuest().ModObjectiveGlobal( -1, _SDGVP_demerits, 3, _SDGVP_demerits_join.GetValue() as Float, False, True, _SDGVP_config_verboseMerits.GetValueInt() as Bool )

If (randomVar >= 5  ) ; Straining positions - used to be 60
	;Debug.Notification( "You will pay for that!" ) ;Why? I dont get this? 
	Debug.Notification( "$Go on..." )
	Utility.Wait(1.0)
	;Debug.Notification( "You've got " +  _SDGVP_demerits + "points, out of" + _SDGVP_demerits_join + "" )
	;Debug.Notification("[_sdqs_snp] Receiving scene:" + aiValue1 + " [ " + aiValue2 + " ]")
	; Punishment
	; _SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 3, aiValue2 = 5 ) ; Utility.RandomInt( 0, _SDGVP_punishments.GetValueInt() ) )
	
	; Whipping
	;_SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 5 )

Else
	Debug.Notification( "$Stop bugging me, Slave!" )
	; _SDKP_sex.SendStoryEvent( \
	;	akRef1 = _SDRAP_master.GetReference() as ObjectReference, \
	;	akRef2 = _SDRAP_slave.GetReference() as ObjectReference, \
	;	aiValue1 = 0, \
	;	aiValue2 = Utility.RandomInt( 0, _SDGVP_positions.GetValueInt() )  )

EndIf

_SDGVP_passive_chance.SetValue(  50 - ( _SDGVP_demerits.GetValue() as Int)  )  
_SDGVP_anger_chance.SetValue( 50 + (_SDGVP_demerits.GetValue() as Int)  )
_SDGVP_sorry.SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment


GlobalVariable Property _SDGVP_passive_chance  Auto  
GlobalVariable Property _SDGVP_anger_chance  Auto  
GlobalVariable Property _SDGVP_demerits  Auto  
SexLabFrameWork Property SexLab Auto

ReferenceAlias Property _SDRAP_slave  Auto  
ReferenceAlias Property _SDRAP_master  Auto  
Keyword Property _SDKP_sex  Auto   

GlobalVariable Property _SDGVP_demerits_join  Auto  
GlobalVariable Property _SDGVP_config_verboseMerits  Auto
GlobalVariable Property _SDGVP_positions  Auto  
GlobalVariable Property _SDGVP_punishments  Auto 

GlobalVariable Property _SDGVP_sorry  Auto  
