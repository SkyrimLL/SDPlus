;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _sdtif_join_34 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
; akSpeaker.SetRelationshipRank(_SDRAP_slave.GetReference() as Actor, -3)
_SDGVP_state_joined.SetValue( 0 )
_SDKP_trust_hands.SetValue( 1 )
_SDKP_trust_feet.SetValue( 1 )
Utility.Wait(0.5)
Self.GetOwningQuest().SetStage( 90 )
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

GlobalVariable Property _SDGVP_state_joined  Auto  
ReferenceAlias Property _SDRAP_slave  Auto  

GlobalVariable Property _SDKP_trust_hands  Auto  

GlobalVariable Property _SDKP_trust_feet  Auto  
