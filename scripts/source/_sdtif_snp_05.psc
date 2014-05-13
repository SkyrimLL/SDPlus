;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _sdtif_snp_05 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
_SDKP_task.SendStoryEvent(akRef1 = akSpeakerRef, akRef2 = _SDRAP_slave.GetReference() as ObjectReference, aiValue1 = 20, aiValue2 = 4)

_SDKP_trust_hands.SetValue(1)

Self.GetOwningQuest().SetStage(20)
Self.GetOwningQuest().ModObjectiveGlobal( -1.0, _SDGVP_demerits, 3, _SDGVP_demerits_join.GetValue() as Float, False, True, _SDGVP_config_verboseMerits.GetValueInt() as Bool )

Game.EnablePlayerControls( abMovement = True )
Game.SetPlayerAIDriven( False )
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment


Keyword Property _SDKP_task  Auto  

ReferenceAlias Property _SDRAP_slave  Auto  
GlobalVariable Property _SDGVP_demerits  Auto 
GlobalVariable Property _SDGVP_demerits_join  Auto  
GlobalVariable Property _SDGVP_config_verboseMerits  Auto

GlobalVariable Property _SDKP_trust_hands  Auto  
