;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _sdtif_join_35 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
akSpeaker.SetRelationshipRank(_SDRAP_slave.GetReference() as Actor, 4)
akSpeaker.AddToFaction(PotentialFollowerFaction)
akSpeaker.AddToFaction(CurrentFollowerFaction)
akSpeaker.SetFactionRank( CurrentFollowerFaction, -1)
akSpeaker.AddToFaction(PotentialMarriageFaction)
akSpeaker.SetAV( "Assistance", 2)
akSpeaker.SetAV( "Confidence", 3)

_SDGVP_state_joined.SetValue( 1 )
SendModEvent("PCSubFree")


ObjectReference kPlayerStorage = _SDRAP_playerStorage.GetReference()
kPlayerStorage.RemoveAllItems(akTransferTo = akSpeaker, abKeepOwnership = True)

akSpeaker.ShowGiftMenu(False, None, True, False)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

GlobalVariable Property _SDGVP_state_joined  Auto  
ReferenceAlias Property _SDRAP_slave  Auto  

Faction Property CurrentFollowerFaction  Auto  

Faction Property PotentialFollowerFaction  Auto  

Faction Property PotentialMarriageFaction  Auto  

ReferenceAlias Property _SDRAP_playerStorage  Auto  
