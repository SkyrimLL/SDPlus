;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _sdtif_serve_02 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
akSpeaker.SetRelationshipRank(Game.GetPlayer(), 3)
akSpeaker.AddToFaction(PotentialFollowerFaction)
akSpeaker.AddToFaction(CurrentFollowerFaction)
akSpeaker.SetFactionRank( CurrentFollowerFaction, -1)
akSpeaker.SetAV( "Assistance", 2)
akSpeaker.SetAV( "Confidence", 3)
; akSpeaker.AddToFaction(PotentialMarriageFaction)

_SDKP_trust_hands.SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Faction Property CurrentFollowerFaction  Auto  

Faction Property PotentialFollowerFaction  Auto  

Faction Property PotentialMarriageFaction  Auto  

GlobalVariable Property _SDKP_trust_hands  Auto  
